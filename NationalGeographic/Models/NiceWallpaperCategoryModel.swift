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
    
    
    var result: Int = 0

    var data: NiceWallpaperCategoryData?

    var reason: String?
    

}
class NiceWallpaperCategoryData: NSObject, YYModel {

    var base_url: String?

    var tags: [NiceWallpaperCategoryTag]?
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["tags" : NiceWallpaperCategoryTag.self]
    }

}

class NiceWallpaperCategoryTag: NSObject {

    var en_name: String?

    var id: Int = 0

    var name: String?

    var cover: String?

}

