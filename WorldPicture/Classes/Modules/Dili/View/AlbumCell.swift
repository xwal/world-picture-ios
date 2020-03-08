//
//  AlbumCell.swift
//  WorldPicture
//
//  Created by Chaosky on 2016/11/15.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit
import Kingfisher

class AlbumCell: UITableViewCell {

    @IBOutlet weak var albumImageView: UIImageView!
    
    @IBOutlet weak var albumNameLabel: UILabel!
    
    var model: AlbumModel? {
        didSet {
            if let url = model?.url {
                albumImageView.kf.setImage(with: URL(string: url), placeholder: Asset.Assets.Dili.nopic.image, options: [.transition(.fade(0.5))])
            }
            
            albumNameLabel.text = model?.title
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
