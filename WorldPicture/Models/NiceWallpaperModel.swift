//
//  NiceWallpaperModel.swift
//  WorldPicture
//
//  Created by Chaosky on 2016/12/13.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit
import YYModel

class NiceWallpaperModel: NSObject {

    @objc var result: Int = 0

    @objc var data: NiceWallpaperDataModel?

    @objc var reason: String?
    
}
class NiceWallpaperDataModel: NSObject, YYModel {

    @objc var images: [NiceWallpaperImageModel]?

    @objc var base_url: String?

    @objc var has_next: Bool = false

    @objc static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["images": NiceWallpaperImageModel.self]
    }
}

class NiceWallpaperImageModel: NSObject, YYModel {

    @objc var height: CGFloat = 0.0

    @objc var up_times: Int = 0

    @objc var id: Int = 0

    @objc var pub_time: Date?

    @objc var width: CGFloat = 0.0

    @objc var desc_user: NiceWallpaperImageDescUserModel?

    @objc var image_url: String?

    @objc var desc: String?

    @objc var photo_user: NiceWallpaperImagePhotoUserModel?

    @objc var description_en: String?
    
    @objc static func modelCustomPropertyMapper() -> [String : Any]? {
        return ["desc": "description"]
    }
    
    @objc var view_times: Int = 0
    
    @objc var origin_image_url: String?
    
    @objc var publish_at: Int = 0
    
    @objc var word: String?
    
    @objc var created_at: String?
    
    @objc var tags: [String]?

}

class NiceWallpaperImageDescUserModel: NSObject {

    @objc var user_name: String?

    @objc var user_photo: String?

    @objc var user_id: Int = 0

}

class NiceWallpaperImagePhotoUserModel: NSObject {

    @objc var user_id: Int = 0

    @objc var user_photo: String?

    @objc var user_link: String?

    @objc var user_name: String?

}

