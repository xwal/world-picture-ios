//
//  UIViewController+NGP.swift
//  WorldPicture
//
//  Created by Chaosky on 2016/12/2.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

private let loadingImageViewTag = 10000

extension UIViewController {
    var loadingImageView: UIImageView {
        if let imageView = view.viewWithTag(loadingImageViewTag) {
            return imageView as! UIImageView
        }
        let loadingImageView = UIImageView()
        loadingImageView.tag = loadingImageViewTag
        view.addSubview(loadingImageView)
        var animationImages = [UIImage]()
        for index in 1...32 {
            
            if let image = UIImage(named: "loading_\(index)") {
                animationImages.append(image)
            }
        }
        loadingImageView.animationImages = animationImages
        
        loadingImageView.snp.makeConstraints { (maker) in
            maker.center.equalTo(view)
        }
        return loadingImageView
    }
}
