//
//  ArticleImageCell.swift
//  NationalGeographic
//
//  Created by Chaosky on 2016/11/21.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit
import Kingfisher

class ArticleImageCell: UITableViewCell {
    @IBOutlet weak var descNoteImageView: UIImageView!

    @IBOutlet weak var descNoteTextView: UITextView!
    
    var model: ArticleDescNoteModel! {
        didSet {
            descNoteImageView.kf.setImage(with: URL(string: model.image_url!), placeholder: Image(named: "Placeholder"), options: nil, progressBlock: nil, completionHandler: nil)
            descNoteTextView.text = model.desc
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
