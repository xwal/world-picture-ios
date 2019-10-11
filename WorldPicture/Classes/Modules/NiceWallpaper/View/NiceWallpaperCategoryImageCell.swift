//
//  NiceWallpaperCategoryImageCell.swift
//  WorldPicture
//
//  Created by Chaosky on 2017/2/9.
//  Copyright © 2017年 ChaosVoid. All rights reserved.
//

import UIKit
import Kingfisher
import MMParallaxCell

class NiceWallpaperCategoryImageCell: MMParallaxCell {
    
    @IBOutlet weak var upTimesLabel: UILabel!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userHeadImageView: UIImageView!
    
    @IBOutlet weak var descLabel: UILabel!
    
    var model: NiceWallpaperImageModel! {
        didSet {
            updateViews()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userHeadImageView.layer.cornerRadius = 11
        userHeadImageView.layer.masksToBounds = true
        contentView.backgroundColor = UIColor.clear
        parallaxImage.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateViews() {
        if let imageURL = model.image_url {
            parallaxImage.kf.setImage(with: URL(string: "\(NGPAPI_ZUIMEIA_BASE_URL)\(imageURL)"), options: [.transition(.fade(0.5))])
        }
        upTimesLabel.text = "\(model.up_times)"
        userNameLabel.text = model.photo_user?.user_name ?? ""
        
        if let imageURL = model.photo_user?.user_photo {
            userHeadImageView.kf.setImage(with: URL(string: imageURL), placeholder: KFCrossPlatformImage(named: "personal_head_default"))
        }
        
        descLabel.text = model.desc?.length != 0 ? model.desc : "喜欢这张图就帮它配词吧~"
    }
    
}
