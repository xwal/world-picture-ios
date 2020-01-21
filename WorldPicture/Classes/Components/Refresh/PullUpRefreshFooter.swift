//
//  PullUpRefreshFooter.swift
//  WorldPicture
//
//  Created by chaosky on 2020/1/21.
//  Copyright © 2020 ChaosVoid. All rights reserved.
//

import UIKit
import MJRefresh

class PullUpRefreshFooter: MJRefreshAutoGifFooter {

    let refreshImages = (0...4).map { (index) -> UIImage in
        return UIImage(named: "dropdown_anim_0".appending(String(index)))!
    }
    
    override func prepare() {
        super.prepare()
        isRefreshingTitleHidden = true
        
        setImages(refreshImages, for: .idle)
        setImages(refreshImages, for: .pulling)
        setImages(refreshImages, for: .refreshing)
        setImages(refreshImages, for: .willRefresh)
    }

}
