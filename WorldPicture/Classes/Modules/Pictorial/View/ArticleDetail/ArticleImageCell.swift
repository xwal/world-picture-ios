//
//  ArticleImageCell.swift
//  WorldPicture
//
//  Created by Chaosky on 2016/11/21.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit
import Kingfisher
import SnapKit

class ArticleImageCell: UITableViewCell {
    @IBOutlet weak var descNoteImageView: UIImageView!

    @IBOutlet weak var descNoteTextView: UITextView!
    
    var model: ArticleDescNoteModel! {
        didSet {
            descNoteImageView.snp.remakeConstraints { (maker) in
                maker.width.equalTo(descNoteImageView.snp.height).multipliedBy(Float(model.image_width) / Float(model.image_height))
            }
            descNoteImageView.kf.setImage(with: URL(string: model.image_url!), placeholder: KFCrossPlatformImage(named: "Placeholder"))
            descNoteTextView.text = model.desc
            self.layoutIfNeeded()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        descNoteImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer { (gesture) in
            NotificationCenter.default.post(name: NSNotification.Name(NGPArticleDetailBigImageSelectedNotification), object: self.descNoteImageView.kf.webURL)
        }
        descNoteImageView.addGestureRecognizer(tapGesture)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
