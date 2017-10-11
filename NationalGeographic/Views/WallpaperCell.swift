//
//  WallpaperCell.swift
//  NationalGeographic
//
//  Created by Chaosky on 2016/11/19.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit
import Kingfisher

class WallpaperCell: UICollectionViewCell {
    
    @IBOutlet weak var wallpaperImageView: UIImageView!
    
    var model: UnsplashModel! {
        didSet {
            if let imageUrl = model.full_url {
                wallpaperImageView.kf.setImage(with: URL(string: imageUrl.appending("?imageView2/2/w/750/h/512")), placeholder:#imageLiteral(resourceName: "unsplash_default"), options: [.transition(.fade(0.5))])
            }
        }
    }
}
