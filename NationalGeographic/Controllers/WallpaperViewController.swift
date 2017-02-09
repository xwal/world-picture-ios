//
//  WallpaperViewController.swift
//  NationalGeographic
//
//  Created by Chaosky on 2016/11/19.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import MJRefresh

private let reuseIdentifier = "WallpaperCell"

class WallpaperViewController: UICollectionViewController {
    
    var wallpaperArray = [WallpaperModel]()
    
    var currentIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        requestWallpaper()
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
        let itemWidth = (screenSize.width - 12.0) / 2
        let itemHeight = itemWidth * 1136 / 640.0
        (self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize = CGSize(width: itemWidth, height: itemHeight)
        self.collectionView?.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.requestWallpaper()
        })
    }
    
    func requestWallpaper() {
        self.loadingImageView.startAnimating()
        let url = URL(string: NGPAPI_CHANYOUJI_WALLPAPER)!
        let request = URLRequest(url: url, cachePolicy: self.collectionView!.mj_header.isRefreshing() ? .useProtocolCachePolicy : .returnCacheDataElseLoad)
        
        Alamofire.request(request).responseJSON { (response) in
            if let JSON = response.result.value {
                self.wallpaperArray = NSArray.yy_modelArray(with: WallpaperModel.self, json: JSON) as! [WallpaperModel]
            }
            DispatchQueue.main.async {
                self.collectionView?.mj_header.endRefreshing()
                self.loadingImageView.stopAnimating()
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
