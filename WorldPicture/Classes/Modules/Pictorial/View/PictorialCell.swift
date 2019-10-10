//
//  PictorialCell.swift
//  WorldPicture
//
//  Created by Chaosky on 2016/11/21.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit

class PictorialCell: UITableViewCell {

    @IBOutlet weak var destZhNameLabel: UILabel!
    
    @IBOutlet weak var destEnNameLabel: UILabel!
    
    @IBOutlet weak var articleCountLabel: UILabel!
    
    @IBOutlet weak var easyView: EasyView!

    var model: PictorialModel! {
        didSet {
            destZhNameLabel.text = model.destination?.name_zh_cn
            destEnNameLabel.text = model.destination?.name_en
            
            articleCountLabel.text = "\(model.articles?.count ?? 0) 组画报"
            
            if let articles = model.articles {
                easyView.articles = articles
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
