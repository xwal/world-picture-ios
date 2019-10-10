//
//  AlbumListModel.swift
//  WorldPicture
//
//  Created by Chaosky on 2016/11/15.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit
import YYModel

class AlbumListModel: NSObject, YYModel {
    
    @objc var pagecount: String?
    
    @objc var album: [AlbumModel]?
    
    @objc var total: String?
    
    @objc var page: String?
    
    @objc static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["album": AlbumModel.self]
    }
}

class AlbumModel: NSObject {
    
    @objc var id: String?
    
    @objc var timingpublish: String?
    
    @objc var addtime: String?
    
    @objc var url: String?
    
    @objc var adshow: String?
    
    @objc var title: String?
    
    @objc var timing: String?
    
    @objc var fabu: String?
    
    @objc var encoded: String?
    
    @objc var amd5: String?
    
    @objc var sort: String?
    
    @objc var ds: String?
}
