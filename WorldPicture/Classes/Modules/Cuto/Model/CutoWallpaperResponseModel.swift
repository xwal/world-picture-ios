//
//  CutoWallpaperResponseModel.swift
//  WorldPicture
//
//  Created by chaosky on 2020/1/21.
//  Copyright © 2020 ChaosVoid. All rights reserved.
//

import Foundation
import YYModel

class CutoWallpaperResponseModel: NSObject, YYModel {
    @objc var next: String?
    @objc var previous: String?
    @objc var results: [CutoWallpaperModel]?
    
    @objc static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["results": CutoWallpaperModel.self]
    }
}

class CutoWallpaperModel: NSObject, YYModel {
    var wallpaperId: Int?
    @objc var url: String?
    @objc var unsplash_url: String?
    @objc var thumbnail: String?
    @objc var tags: [CutoWallpaperTagModel]?
    @objc var author: CutoWallpaperAuthorModel?
    @objc var created_at: String?
    
    static func modelCustomPropertyMapper() -> [String : Any]? {
        return ["wallpaperId": "id"]
    }
    
    @objc static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["tags": CutoWallpaperTagModel.self]
    }
}

class CutoWallpaperTagModel: NSObject, YYModel {
    var tagId: Int?
    @objc var name: String?
    
    static func modelCustomPropertyMapper() -> [String : Any]? {
        return ["tagId": "id"]
    }
}

class CutoWallpaperAuthorModel: NSObject, YYModel {
    var authorId: Int?
    @objc var name: String?
    @objc var avatar: String?
    @objc var website: String?
    
    static func modelCustomPropertyMapper() -> [String : Any]? {
        return ["authorId": "id"]
    }
}
