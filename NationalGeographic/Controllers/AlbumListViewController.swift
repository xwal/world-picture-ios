//
//  MainViewController.swift
//  NationalGeographic
//
//  Created by Chaosky on 2016/11/15.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit
import Alamofire
import YYModel
import MJRefresh
import YYCategories

class AlbumListViewController: UITableViewController {

    var currentPage = 1
    
    let CellIdentifier = "AlbumCell"
    
    let refreshIntervalSeconds = 60 * 60 * 4.0
    
    var cacheDataURL: URL {
        
        return UIApplication.shared.documentsURL.appendingPathComponent("AlbumListModel.data")
    }
    
    var albumModelArray = [AlbumModel]() {
        didSet {
            updateCacheData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCacheData()
    }
    
    func setupView() {
        let header = MJRefreshNormalHeader(refreshingBlock: {
            self.currentPage = 1
            self.requestData(withPage: self.currentPage)
        })
        header?.lastUpdatedTimeKey = "AlbumListViewControllerHeader"
        header?.arrowView.image = UIImage(named: "blueArrow")
        header?.activityIndicatorViewStyle = .white
        tableView.mj_header = header
        
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { 
            self.currentPage += 1
            self.requestData(withPage: self.currentPage)
        })
    }
    
    func setupCacheData() {
        
        guard let updatedTime = tableView.mj_header.lastUpdatedTime else {
            tableView.mj_header.beginRefreshing()
            return
        }
        
        do {
            let cacheJSONData = try Data(contentsOf: cacheDataURL)
            albumModelArray = NSArray.yy_modelArray(with: AlbumModel.self, json: cacheJSONData) as! [AlbumModel]
            tableView.reloadData()
        } catch {
            tableView.mj_header.beginRefreshing()
        }
        
        let timeInterval = NSDate().timeIntervalSince(updatedTime)
        if timeInterval > refreshIntervalSeconds {
            tableView.mj_header.beginRefreshing()
        }
        
    }
    
    func updateCacheData() {
        // 将数据写入本地
        if let data = (self.albumModelArray as NSArray).yy_modelToJSONData() {
            do {
                try data.write(to: self.cacheDataURL)
            } catch let error {
                print(error)
            }
        }
    }
    
    func requestData(withPage page: Int) {
        let requestURL = String(format: NGPAPI_DILI_MAIN, page)
        Alamofire.request(requestURL).responseJSON { (response) in
            
            var hasMoreData = true
            // 是否有数据
            if let JSON = response.result.value {
                
                if let albumListModel = AlbumListModel.yy_model(withJSON: JSON) {
                    if let albumList = albumListModel.album {
                        
                        if page == 1 {
                            self.albumModelArray.removeAll()
                        }
                        self.albumModelArray.append(contentsOf: albumList)
                    }
                    
                    if let total = Int((albumListModel.total)!) {
                        if self.albumModelArray.count >= total {
                            hasMoreData = false
                        }
                    }
                }
            }
            else {
                if self.currentPage > 1 {
                    self.currentPage -= 1
                }
            }
            
            DispatchQueue.main.async {
                if hasMoreData {
                    self.tableView.mj_footer.endRefreshing()
                }
                else {
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                }
                self.tableView.mj_header.endRefreshing()
                
                self.tableView.reloadData()
            }
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return albumModelArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath) as! AlbumCell

        let albumModel = albumModelArray[indexPath.row]
        cell.model = albumModel
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let albumModel = albumModelArray[indexPath.row]
        HistoryRecordManager.shared.add(albumModel.id!)
        
        if let cell = tableView.cellForRow(at: indexPath) as? AlbumCell {
            cell.eyeImageView.isHidden = true
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "DetailSegue" {
            let destVC = segue.destination as! AlbumDetailViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                let albumModel = albumModelArray[indexPath.row]
                destVC.albumID = albumModel.id
            }
            
        }
    }
    

}
