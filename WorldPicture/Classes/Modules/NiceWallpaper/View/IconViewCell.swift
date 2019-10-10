//
//  IconViewCell.swift
//  WorldPicture
//
//  Created by Chaosky on 2016/12/29.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit

class IconViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iconNameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        iconImageView.layer.cornerRadius = 13
        iconImageView.layer.masksToBounds = true
    }
}
