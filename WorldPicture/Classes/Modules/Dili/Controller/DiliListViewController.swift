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
import GoogleMobileAds

class DiliListViewController: UIViewController {

    var currentPage = 1
    
    let CellIdentifier = "AlbumCell"
    
    var albumModelArray = [AlbumModel]()
    
    @IBOutlet weak var tableView: UITableView!
    private var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadData()
    }
    
    func setupView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let header = DropDownRefreshHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.currentPage = 1
            self.requestData(withPage: self.currentPage)
        })
        header.lastUpdatedTimeKey = "AlbumListViewControllerHeader"
        tableView.mj_header = header
        
        let footer = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.currentPage += 1
            self.requestData(withPage: self.currentPage)
        })
        footer.isHidden = true
        tableView.mj_footer = footer
        
        tableView.tableFooterView = UIView()
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-6178635866936443/1396797175"
        bannerView.rootViewController = self
        bannerView.delegate = self
        bannerView.isAutoloadEnabled = true
        
        view.addSubview(bannerView)
        bannerView.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.bottom.equalTo(bottomLayoutGuide.snp.top)
        }
        
        bannerView.load(GADRequest())
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension DiliListViewController: UITableViewDataSource {
    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return albumModelArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath) as! AlbumCell

        let albumModel = albumModelArray[indexPath.row]
        cell.model = albumModel
        
        return cell
    }
}

extension DiliListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let albumModel = albumModelArray[indexPath.row]
        HistoryRecordManager.shared.add(albumModel.id!)
    }
}

extension DiliListViewController: GADBannerViewDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
      print("adViewDidReceiveAd")
    }

    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
        didFailToReceiveAdWithError error: GADRequestError) {
      print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
}
