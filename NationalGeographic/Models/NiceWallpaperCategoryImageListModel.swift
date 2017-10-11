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

    @objc var result: Int = 0

    @objc var data: NWCILDataModel?

    @objc var reason: String?
    
}
class NWCILDataModel: NSObject, YYModel {

    @objc var images: [NWCILImageModel]?

    @objc var base_url: String?

    @objc var has_next: Bool = false
    
    @objc static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["images": NWCILImageModel.self]
    }

}

class NWCILImageModel: NSObject, YYModel {

    @objc var desc: String?

    @objc var view_times: Int = 0

    @objc var origin_image_url: String?

    @objc var publish_at: Int = 0

    @objc var id: Int = 0

    @objc var word: String?

    @objc var created_at: String?

    @objc var tags: [String]?

    @objc var width: String?

    @objc var image_url: String?

    @objc var height: String?

    @objc var desc_user: NWCILDescUserModel?

    @objc var up_times: Int = 0

    @objc var photo_user: NWCILPhotoUserModel?
    
    @objc static func modelCustomPropertyMapper() -> [String : Any]? {
        return ["description": "desc"]
    }

}

class NWCILDescUserModel: NSObject {

    @objc var user_id: Int = 0

    @objc var user_photo: String?

    @objc var user_name: String?

}

class NWCILPhotoUserModel: NSObject {

    @objc var user_id: Int = 0

    @objc var user_photo: String?

    @objc var user_link: String?

    @objc var user_name: String?

}

