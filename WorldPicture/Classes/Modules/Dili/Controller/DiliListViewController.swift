//
//  MainViewController.swift
//  WorldPicture
//
//  Created by Chaosky on 2016/11/15.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit
import Alamofire
import YYModel
import MJRefresh
import DateToolsSwift
import DZNEmptyDataSet

class DiliListViewController: UITableViewController {

    var currentPage = 1
    
    let CellIdentifier = "AlbumCell"
    
    var albumModelArray = [AlbumModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupEmptyDataSet()
        loadData()
    }
    
    func setupView() {
        let header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.currentPage = 1
            self.requestData(withPage: self.currentPage)
        })
        header.lastUpdatedTimeKey = "AlbumListViewControllerHeader"
        header.arrowView?.image = Asset.Dili.blueArrow.image
        header.stateLabel?.isHidden = true
        header.lastUpdatedTimeLabel?.isHidden = true
        header.loadingView?.style = .white
        tableView.mj_header = header
        
        let footer = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.currentPage += 1
            self.requestData(withPage: self.currentPage)
        })
        footer.isHidden = true
        tableView.mj_footer = footer
        
        tableView.tableFooterView = UIView()
    }
    
    func loadData() {
        tableView.mj_header?.beginRefreshing()
    }
    
    func requestData(withPage page: Int) {
        APIProvider.request(DiliAPI.mains(page: page).multiTarget) { [weak self] result in
            guard let self = self else { return }
            var hasMoreData = false
            switch result {
            case let .success(response):
                if let albumListModel = AlbumListModel.yy_model(withJSON: response.data) {
                    if var albumList = albumListModel.album {
                        
                        if page == 1 {
                            self.albumModelArray.removeAll()
                        }
                        albumList.removeAll(where: { $0.ds == "0" })
                        self.albumModelArray.append(contentsOf: albumList)
                    }
                    
                    if let total = Int((albumListModel.total)!) {
                        if self.albumModelArray.count >= total {
                            hasMoreData = false
                        } else {
                            hasMoreData = true
                        }
                    }
                }
                break
            case .failure:
                if self.currentPage > 1 {
                    self.currentPage -= 1
                }
            }
            DispatchQueue.main.async {
                if hasMoreData {
                    self.tableView.mj_footer?.isHidden = false
                    self.tableView.mj_footer?.endRefreshing()
                }
                else {
                    self.tableView.mj_footer?.endRefreshingWithNoMoreData()
                }
                self.tableView.mj_header?.endRefreshing()
                
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
        if case .detailSegue = StoryboardSegue.Dili(segue) {
            let destVC = segue.destination as! DiliDetailViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                let albumModel = albumModelArray[indexPath.row]
                destVC.albumID = albumModel.id
            }
        }
    }
    

}

extension DiliListViewController: DZNEmptyDataSetDelegate, DZNEmptyDataSetSource
{
    func setupEmptyDataSet() {
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
    }
    
    // MARK: DZNEmptyDataSetSource
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "无网络连接"
        let font = UIFont.boldSystemFont(ofSize: 17)
        let textColor = UIColor(hex: "25282b")
        
        let attributes: [NSAttributedString.Key: Any] = [.font:font, .foregroundColor: textColor]
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return Asset.Assets.placeholderEmptydataset.image
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControl.State) -> NSAttributedString! {
        let text = "点击刷新"
        let font = UIFont.systemFont(ofSize: 15)
        let textColor = UIColor(hex: state == .normal ? "007ee5" : "48a1ea")
        let attributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: textColor]
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor(hex: "f0f3f5")
    }
    
    // MARK: DZNEmptyDataSetDelegate
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return albumModelArray.count == 0
    }
    
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return false
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        tableView.mj_header?.beginRefreshing()
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        tableView.mj_header?.beginRefreshing()
    }
}
