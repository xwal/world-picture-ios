//
//  AlbumCell.swift
//  NationalGeographic
//
//  Created by Chaosky on 2016/11/15.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit
import Kingfisher

class AlbumCell: UITableViewCell {

    @IBOutlet weak var albumImageView: UIImageView!
    
    @IBOutlet weak var albumNameLabel: UILabel!
    
    @IBOutlet weak var eyeImageView: UIImageView!
    
    var model: AlbumModel? {
        didSet {
            if let url = model?.url {
                albumImageView.kf.setImage(with: URL(string: url), placeholder: Image(named: "nopic"), options: nil, progressBlock: nil, completionHandler: nil)
            }
            
            albumNameLabel.text = model?.title
            
            if let id = model?.id {
                let checked = HistoryRecordManager.shared.check(id)
                eyeImageView.isHidden = checked
            }
            
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
