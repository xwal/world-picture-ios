//
//  NiceWallpaperModel.swift
//  NationalGeographic
//
//  Created by Chaosky on 2016/12/13.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit
import YYModel

class NiceWallpaperModel: NSObject {

    var result: Int = 0

    var data: NiceWallpaperDataModel?

    var reason: String?
    
}
class NiceWallpaperDataModel: NSObject, YYModel {

    var images: [NiceWallpaperImageModel]?

    var base_url: String?

    var has_next: Bool = false

    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["images": NiceWallpaperImageModel.self]
    }
}

class NiceWallpaperImageModel: NSObject, YYModel {

    var height: CGFloat = 0.0

    var up_times: Int = 0

    var id: Int = 0

    var pub_time: Date?

    var width: CGFloat = 0.0

    var desc_user: NiceWallpaperImageDescUserModel?

    var image_url: String?

    var desc: String?

    var photo_user: NiceWallpaperImagePhotoUserModel?

    var description_en: String?
    
    static func modelCustomPropertyMapper() -> [String : Any]? {
        return ["desc": "description"]
    }
    
    var view_times: Int = 0
    
    var origin_image_url: String?
    
    var publish_at: Int = 0
    
    var word: String?
    
    var created_at: String?
    
    var tags: [String]?

}

class NiceWallpaperImageDescUserModel: NSObject {

    var user_name: String?

    var user_photo: String?

    var user_id: Int = 0

}

class NiceWallpaperImagePhotoUserModel: NSObject {

    var user_id: Int = 0

    var user_photo: String?

    var user_link: String?

    var user_name: String?

}

