//
//  NiceWallpaperCategoryImageListModel.swift
//  NationalGeographic
//
//  Created by Chaosky on 2017/2/9.
//  Copyright © 2017年 ChaosVoid. All rights reserved.
//

import UIKit
import YYModel

class NiceWallpaperCategoryImageListModel: NSObject {

    var result: Int = 0

    var data: NWCILDataModel?

    var reason: String?
    
}
class NWCILDataModel: NSObject, YYModel {

    var images: [NWCILImageModel]?

    var base_url: String?

    var has_next: Bool = false
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["images": NWCILImageModel.self]
    }

}

class NWCILImageModel: NSObject, YYModel {

    var desc: String?

    var view_times: Int = 0

    var origin_image_url: String?

    var publish_at: Int = 0

    var id: Int = 0

    var word: String?

    var created_at: String?

    var tags: [String]?

    var width: String?

    var image_url: String?

    var height: String?

    var desc_user: NWCILDescUserModel?

    var up_times: Int = 0

    var photo_user: NWCILPhotoUserModel?
    
    static func modelCustomPropertyMapper() -> [String : Any]? {
        return ["description": "desc"]
    }

}

class NWCILDescUserModel: NSObject {

    var user_id: Int = 0

    var user_photo: String?

    var user_name: String?

}

class NWCILPhotoUserModel: NSObject {

    var user_id: Int = 0

    var user_photo: String?

    var user_link: String?

    var user_name: String?

}

