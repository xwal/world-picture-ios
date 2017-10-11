//
//  NiceWallpaperCategoryModel.swift
//  NationalGeographic
//
//  Created by Chaosky on 2017/2/9.
//  Copyright © 2017年 ChaosVoid. All rights reserved.
//

import UIKit
import YYModel

class NiceWallpaperCategoryModel: NSObject {
    
    
    @objc var result: Int = 0

    @objc var data: NiceWallpaperCategoryData?

    @objc var reason: String?
    

}
class NiceWallpaperCategoryData: NSObject, YYModel {

    @objc var base_url: String?

    @objc var tags: [NiceWallpaperCategoryTag]?
    
    @objc static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["tags" : NiceWallpaperCategoryTag.self]
    }

}

class NiceWallpaperCategoryTag: NSObject {

    @objc var en_name: String?

    @objc var id: Int = 0

    @objc var name: String?

    @objc var cover: String?

}

