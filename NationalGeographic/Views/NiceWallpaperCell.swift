//
//  NiceWallpaperCell.swift
//  NationalGeographic
//
//  Created by Chaosky on 2016/12/13.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit
import Kingfisher
import MMParallaxCell

class NiceWallpaperCell: MMParallaxCell {
    @IBOutlet weak var upTimesLabel: UILabel!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userHeadImageView: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var monthLabel: UILabel!
    
    @IBOutlet weak var weeklyLabel: UILabel!
    
    @IBOutlet weak var descLabel: UILabel!
    
    var imageBaseUrl: String = ""
    
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
            self.parallaxImage.kf.setImage(with: URL(string: "\(imageBaseUrl)\(imageURL)"), options: [.transition(.fade(0.5))])
        }
        upTimesLabel.text = "\(model.up_times)"
        userNameLabel.text = model.photo_user?.user_name ?? ""
        
        if let imageURL = model.photo_user?.user_photo {
            userHeadImageView.kf.setImage(with: URL(string: imageURL), placeholder: Image(named: "personal_head_default"))
        }
    
        descLabel.text = model.desc ?? ""
        
        guard let pubTime = model.pub_time else {
            return
        }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en")
        formatter.dateFormat = "dd,MMM,EEEE"
        
        let formatDateStr = formatter.string(from: pubTime)
        let dateArray = formatDateStr.components(separatedBy: ",")
        dayLabel.text = dateArray[0]
        monthLabel.text = dateArray[1]
        weeklyLabel.text = dateArray[2]
    }
    
}
