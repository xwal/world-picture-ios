//
//  PictureCell.swift
//  NationalGeographic
//
//  Created by Chaosky on 2016/11/16.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit
import Kingfisher

class PictureCell: UICollectionViewCell, UIScrollViewDelegate {
    @IBOutlet weak var pictureImageView: UIImageView!
    
//    override func awakeFromNib() {
//        pictureImageView.isUserInteractionEnabled = true
//       let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
//        pictureImageView.addGestureRecognizer(pinchGesture)
//    }
//    
//    func handlePinch(_ sender: UIPinchGestureRecognizer) {
//        if sender.state == .began || sender.state == .changed {
//            var transform = pictureImageView.transform
//            transform = transform.scaledBy(x: sender.scale, y: sender.scale)
//            pictureImageView.transform = transform
//            sender.scale = 1
//        }
//        else {
//            print(pictureImageView.transform)
//            if pictureImageView.transform.a < 1 || pictureImageView.transform.d < 1 {
//                pictureImageView.transform = CGAffineTransform.identity
//            }
//        }
//        
//    }
    
    var model: PictureModel? {
        didSet {
            if let url = model?.url {
                pictureImageView.kf.setImage(with: URL(string: url), placeholder: Image(named: "nopic"), options: nil, progressBlock: nil, completionHandler: nil)
                pictureImageView.kf.indicatorType = .activity
            }
        }
    }
    
    // MARK: - UIScrollViewDelegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return pictureImageView
    }
}
