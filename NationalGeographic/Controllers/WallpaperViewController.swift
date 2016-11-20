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

private let reuseIdentifier = "WallpaperCell"

class WallpaperViewController: UICollectionViewController {
    
    var loadingImageView: UIImageView!
    
    var wallpaperArray = [WallpaperModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        requestWallpaper()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    func setupViews() {
        loadingImageView = UIImageView()
        var animationImages = [UIImage]()
        for index in 1...32 {
            
            if let image = UIImage(named: "loading_\(index)") {
                animationImages.append(image)
            }
        }
        loadingImageView.animationImages = animationImages
        self.view.addSubview(loadingImageView)
        loadingImageView.snp.makeConstraints { (maker) in
            maker.center.equalTo(self.view.center)
        }
        let screenSize = UIScreen.main.bounds.size
        let itemWidth = (screenSize.width - 12.0) / 2
        let itemHeight = itemWidth * 1136 / 640.0
        (self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize = CGSize(width: itemWidth, height: itemHeight)
    }
    
    func requestWallpaper() {
        self.loadingImageView.startAnimating()
        Alamofire.request("http://chanyouji.com/api/pictorials.json").responseJSON { (response) in
            if let JSON = response.result.value {
                self.wallpaperArray = NSArray.yy_modelArray(with: WallpaperModel.self, json: JSON) as! [WallpaperModel]
            }
            DispatchQueue.main.async {
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
    }

}
