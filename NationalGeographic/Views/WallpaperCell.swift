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
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var publishDateLabel: UILabel!
    
    var model: WallpaperModel! {
        didSet {
            if let imageUrl = model.ios_wallpaper_url {
                wallpaperImageView.kf.setImage(with: URL(string: imageUrl))
            }
            publishDateLabel.text = model.publish_date
            
            titleLabel.text = model.title
        }
    }
}
