//
//  NiceWallpaperCategoryCell.swift
//  NationalGeographic
//
//  Created by Chaosky on 2017/2/9.
//  Copyright © 2017年 ChaosVoid. All rights reserved.
//

import UIKit

class NiceWallpaperCategoryCell: CSMParallaxCell {

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.backgroundColor = UIColor.clear
        parallaxImage.backgroundColor = UIColor.clear
    }

}
