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
import DateToolsSwift
import DZNEmptyDataSet

class AlbumListViewController: UITableViewController {

    var currentPage = 1
    
    let CellIdentifier = "AlbumCell"
    
    var isLoading: Bool = false {
        didSet {
            self.tableView.reloadEmptyDataSet()
        }
    }
    
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
        setupEmptyDataSet()
        setupCacheData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tableView.mj_header.endRefreshing()
        self.tableView.mj_footer.endRefreshing()
    }
    
    func setupView() {
        let header = MJRefreshNormalHeader(refreshingBlock: {
            self.isLoading = true
            self.currentPage = 1
            self.requestData(withPage: self.currentPage)
        })
        header?.lastUpdatedTimeKey = "AlbumListViewControllerHeader"
        header?.arrowView.image = UIImage(named: "blueArrow")
        header?.stateLabel.isHidden = true
        header?.lastUpdatedTimeLabel.isHidden = true
        header?.activityIndicatorViewStyle = .white
        tableView.mj_header = header
        
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { 
            self.currentPage += 1
            self.requestData(withPage: self.currentPage)
        })
        
        self.tableView.tableFooterView = UIView()
        
        
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
        
        if updatedTime.daysAgo >= 1 {
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
                self.isLoading = false
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

extension AlbumListViewController: DZNEmptyDataSetDelegate, DZNEmptyDataSetSource
{
    func setupEmptyDataSet() {
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
    }
    
    // MARK: DZNEmptyDataSetSource
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "无网络连接"
        let font = UIFont.boldSystemFont(ofSize: 17)
        let textColor = UIColor(hex: "25282b")
        
        let attributes: [NSAttributedStringKey: Any] = [.font:font, .foregroundColor: textColor]
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        if self.isLoading {
            return #imageLiteral(resourceName: "loading_imgBlue")
        }
        else {
            return #imageLiteral(resourceName: "placeholder_emptydataset")
        }
    }
    
    func imageAnimation(forEmptyDataSet scrollView: UIScrollView!) -> CAAnimation! {
        let animation = CABasicAnimation(keyPath: "transform")
        animation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        animation.toValue = NSValue(caTransform3D: CATransform3DMakeRotation(.pi / 2, 0.0, 0.0, 1.0))
        animation.duration = 0.25
        animation.isCumulative = true
        animation.repeatCount = MAXFLOAT
        
        return animation
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        let text = "点击刷新"
        let font = UIFont.systemFont(ofSize: 15)
        let textColor = UIColor(hex: state == .normal ? "007ee5" : "48a1ea")
        let attributes: [NSAttributedStringKey: Any] = [.font: font, .foregroundColor: textColor]
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor(hex: "f0f3f5")
    }
    
    // MARK: DZNEmptyDataSetDelegate
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return self.albumModelArray.count == 0
    }
    
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return false
    }
    
    func emptyDataSetShouldAnimateImageView(_ scrollView: UIScrollView!) -> Bool {
        return self.isLoading
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        self.tableView.mj_header.beginRefreshing()
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        self.tableView.mj_header.beginRefreshing()
    }
}
