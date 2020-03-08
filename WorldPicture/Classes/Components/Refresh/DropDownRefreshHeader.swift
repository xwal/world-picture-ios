//
//  DropDownRefreshHeader.swift
//  WorldPicture
//
//  Created by chaosky on 2020/1/21.
//  Copyright © 2020 ChaosVoid. All rights reserved.
//

import UIKit
import MJRefresh

class DropDownRefreshHeader: MJRefreshGifHeader {

    let refreshImages = (0...4).map { (index) -> UIImage in
        return UIImage(named: "Common/dropdown_anim_0".appending(String(index)))!
    }
    
    override func prepare() {
        super.prepare()
        stateLabel?.isHidden = true
        lastUpdatedTimeLabel?.isHidden = true
        
        setImages(refreshImages, for: .idle)
        setImages(refreshImages, for: .pulling)
        setImages(refreshImages, for: .refreshing)
        setImages(refreshImages, for: .willRefresh)
    }

}
