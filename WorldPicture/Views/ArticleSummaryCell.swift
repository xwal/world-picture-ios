//
//  ArticleSummaryCell.swift
//  WorldPicture
//
//  Created by Chaosky on 2016/11/21.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit

class ArticleSummaryCell: UITableViewCell {

    @IBOutlet weak var articleTitleLabel: UILabel!
    
    @IBOutlet weak var descTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
