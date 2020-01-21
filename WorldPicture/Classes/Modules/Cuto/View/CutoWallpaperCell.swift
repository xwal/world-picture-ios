//
//  CutoWallpaperCell.swift
//  WorldPicture
//
//  Created by Chaosky on 2016/11/19.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit
import Kingfisher

class CutoWallpaperCell: UITableViewCell {
    
    @IBOutlet weak var wallpaperImageView: UIImageView!
    
    var model: CutoWallpaperModel! {
        didSet {
            if let imageUrl = model.thumbnail {
                wallpaperImageView.kf.setImage(with: URL(string: imageUrl), placeholder: Asset.Assets.unsplashDefault.image, options: [.transition(.fade(0.5))])
            }
        }
    }
}
