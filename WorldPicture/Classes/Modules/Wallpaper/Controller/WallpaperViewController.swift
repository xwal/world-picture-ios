//
//  WallpaperViewController.swift
//  WorldPicture
//
//  Created by Chaosky on 2016/11/19.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import MJRefresh
import AVOSCloud

private let reuseIdentifier = "WallpaperCell"

class WallpaperViewController: UICollectionViewController {
    
    var wallpaperArray = [UnsplashModel]()
    
    var currentIndex = 0
    
    var pageIndex = 0
    
    var pageCount = 0
    
    let refreshImages = (0...4).map { (index) -> UIImage in
        return UIImage(named: "dropdown_anim_0".appending(String(index)))!
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        collectionView?.mj_header?.beginRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if currentIndex < wallpaperArray.count {
            collectionView?.scrollToItem(at: IndexPath(row: currentIndex, section: 0), at: .top, animated: true)
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    func setupViews() {
        let screenSize = UIScreen.main.bounds.size
        let itemWidth = screenSize.width - 12.0
        let itemHeight = itemWidth * 512.0 / 750.0
        (collectionView?.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        let gifHeader = MJRefreshGifHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.requestPageCount()
        })
        gifHeader.stateLabel?.isHidden = true
        gifHeader.lastUpdatedTimeLabel?.isHidden = true
        
        gifHeader.setImages(refreshImages, for: .idle)
        gifHeader.setImages(refreshImages, for: .pulling)
        gifHeader.setImages(refreshImages, for: .refreshing)
        gifHeader.setImages(refreshImages, for: .willRefresh)
        collectionView?.mj_header = gifHeader
    }
    
    func addFooter() {
        let gifFooter = MJRefreshAutoGifFooter { [weak self] in
            guard let self = self else { return }
            self.requestData(withPage: self.pageIndex - 1)
        }
        gifFooter.isRefreshingTitleHidden = true
        gifFooter.setImages(refreshImages, for: .idle)
        gifFooter.setImages(refreshImages, for: .pulling)
        gifFooter.setImages(refreshImages, for: .refreshing)
        gifFooter.setImages(refreshImages, for: .willRefresh)
        collectionView?.mj_footer = gifFooter
    }
    
    func requestPageCount() {
        
        let queryCount = AVQuery(className: "Count")
        queryCount.getObjectInBackground(withId: "5666312cddb2a419aef3f847") { [weak self] (object, error) in
            guard let self = self else { return }
            guard let obj = object else {
                DispatchQueue.main.async {
                    self.collectionView?.mj_header?.endRefreshing()
                    self.collectionView?.mj_footer?.endRefreshing()
                }
                return
            }
            guard let count = obj.object(forKey: "size") as? Int else {
                DispatchQueue.main.async {
                    self.collectionView?.mj_header?.endRefreshing()
                    self.collectionView?.mj_footer?.endRefreshing()
                }
                return
            }
            
            self.pageCount = count
            
            self.pageIndex = self.pageCount
            
            self.requestData(withPage: self.pageIndex)
        }
    }
    
    func requestData(withPage page: Int) {
        let unsplashQuery = UnsplashModel.query()
        unsplashQuery.whereKey("type", equalTo: String(page))
        unsplashQuery.findObjectsInBackground { [weak self] (objs, err) in
            guard let self = self else { return }
            guard let unsplashs = objs as? [UnsplashModel] else {
                DispatchQueue.main.async {
                    self.collectionView?.mj_header?.endRefreshing()
                    self.collectionView?.mj_footer?.endRefreshing()
                }
                return
            }
            
            if page == self.pageCount {
                self.wallpaperArray.removeAll()
            }
            else {
                self.pageIndex -= 1
            }
            
            self.wallpaperArray.append(contentsOf: unsplashs)
            
            DispatchQueue.main.async {
                if page == self.pageCount {
                    self.addFooter()
                }
                if self.pageIndex > 0 {
                    self.collectionView?.mj_footer?.endRefreshing()
                }
                else {
                    self.collectionView?.mj_footer?.endRefreshingWithNoMoreData()
                }
                self.collectionView?.mj_header?.endRefreshing()
                self.collectionView?.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wallpaperArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! WallpaperCell
    
        cell.model = wallpaperArray[indexPath.row]
    
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let wallpapaerPageVC = segue.destination as! WallpaperPageViewController
        wallpapaerPageVC.wallpaperModelArray = wallpaperArray
        
        weak var weakSelf = self
        wallpapaerPageVC.indexChanged = { (index) in
            weakSelf?.currentIndex = index
        }
        
        guard let cell = sender as? UICollectionViewCell else {
            return
        }
        
        if let indexPath = collectionView?.indexPath(for: cell) {
            currentIndex = indexPath.row
            wallpapaerPageVC.selectedIndex = indexPath.row
        }
        
    }

}
