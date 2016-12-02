//
//  ArticlePhotosCell.swift
//  NationalGeographic
//
//  Created by Chaosky on 2016/11/21.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit
import SnapKit

class ArticlePhotosCell: UITableViewCell {

    var photos: [ArticlePhotoModel]! {
        didSet {
            self.contentView.removeAllSubviews()
            
            let contentView = self.contentView
            var prefixView = self.contentView
            
            for index in stride(from: 0, to: photos.count, by: 2) {
                let leftImageView = UIImageView()
                self.contentView.addSubview(leftImageView)
                
                let leftPhotoModel = photos[index]
                leftImageView.kf.setImage(with: URL(string: leftPhotoModel.image_url!))
                leftImageView.snp.makeConstraints({ (maker) in
                    maker.width.equalTo(leftImageView.snp.height).multipliedBy(Float(leftPhotoModel.image_width) / Float(leftPhotoModel.image_height))
                    
                    if index == 0 {
                        maker.top.equalTo(prefixView.snp.top).offset(10)
                        maker.left.equalTo(prefixView.snp.left).offset(10)
                    }
                    else {
                        maker.top.equalTo(prefixView.snp.bottom).offset(5)
                        maker.left.equalTo(prefixView.snp.left)
                    }
                })
                
                prefixView = leftImageView
                
                let rightImageView = UIImageView()
                self.contentView.addSubview(rightImageView)
                
                rightImageView.snp.makeConstraints({ (maker) in
                    maker.right.equalTo(contentView.snp.right).offset(-10)
                    maker.top.equalTo(prefixView.snp.top)
                    maker.bottom.equalTo(prefixView.snp.bottom)
                    maker.left.equalTo(prefixView.snp.right).offset(5)
                    maker.width.equalTo(prefixView.snp.width)
                })
                
                if index + 1 < photos.count {
                    let rightPhotoModel = photos[index + 1]
                    rightImageView.kf.setImage(with: URL(string: rightPhotoModel.image_url!))
                }
                else {
                    rightImageView.isHidden = true
                }
                
                // 判断是否为最后一个
                if index + 2 >= photos.count {
                    leftImageView.snp.makeConstraints({ (maker) in
                        maker.bottom.equalTo(contentView).offset(-10).priority(250)
                    })
                }
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
