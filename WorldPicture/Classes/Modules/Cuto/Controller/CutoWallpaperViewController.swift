//
//  CutoWallpaperViewController.swift
//  WorldPicture
//
//  Created by Chaosky on 2016/11/19.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import MJRefresh

class CutoWallpaperViewController: UIViewController {
    
    var wallpaperArray = [CutoWallpaperModel]()
    
    var currentIndex = 0
    
    var nextCursor: String?

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        tableView.mj_header?.beginRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if currentIndex < wallpaperArray.count {
            tableView.scrollToRow(at: IndexPath(row: currentIndex, section: 0), at: .top, animated: true)
        }
    }
    
    func setupViews() {
        let screenSize = UIScreen.main.bounds.size
        let itemWidth = screenSize.width - 12.0
        let itemHeight = itemWidth * 512.0 / 750.0
        
        tableView.rowHeight = itemHeight
        tableView.dataSource = self
        
        let gifHeader = DropDownRefreshHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.requestData(cursor: nil)
        })
        tableView.mj_header = gifHeader
    }
    
    func addFooter() {
        let gifFooter = PullUpRefreshFooter { [weak self] in
            guard let self = self else { return }
            self.requestData(cursor: self.nextCursor)
        }
        tableView.mj_footer = gifFooter
    }
    
    func requestData(cursor: String?) {
        APIProvider.request(CutoAPI.wallpapers(lang: "zh", cursor: cursor).multiTarget) { [weak self] result in
            guard let self = self else { return }
            if let response = try? result.get(),
                let model = CutoWallpaperResponseModel.yy_model(withJSON: response.data),
                let images = model.results {
                
                if cursor == nil {
                    self.wallpaperArray.removeAll()
                }
                
                self.wallpaperArray.append(contentsOf: images)
                
                if let next = model.next, let nextUrl = URL(string: next) {
                    self.nextCursor = nextUrl.queryValue(for: "cursor")
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.tableView.mj_header?.endRefreshing()
                    self.addFooter()
                    if model.next != nil {
                        self.tableView.mj_footer?.endRefreshing()
                    }
                    else {
                        self.tableView.mj_footer?.endRefreshingWithNoMoreData()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.tableView.mj_header?.endRefreshing()
                    self.tableView.mj_footer?.endRefreshing()
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let wallpapaerPageVC = segue.destination as! CutoWallpaperPageViewController
        wallpapaerPageVC.wallpaperModelArray = wallpaperArray
        
        weak var weakSelf = self
        wallpapaerPageVC.indexChanged = { (index) in
            weakSelf?.currentIndex = index
        }
        
        guard let cell = sender as? UITableViewCell else {
            return
        }
        
        if let indexPath = tableView.indexPath(for: cell) {
            currentIndex = indexPath.row
            wallpapaerPageVC.selectedIndex = indexPath.row
        }
        
    }

}

extension CutoWallpaperViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wallpaperArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: CutoWallpaperCell.self, for: indexPath)
        cell.model = wallpaperArray[indexPath.row]
        return cell
    }
}
