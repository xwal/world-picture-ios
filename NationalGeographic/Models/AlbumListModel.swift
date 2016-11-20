//
//  AlbumListModel.swift
//  NationalGeographic
//
//  Created by Chaosky on 2016/11/15.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit
import YYModel

class AlbumListModel: NSObject, YYModel {
    
    var pagecount: String?
    
    var album: [AlbumModel]?
    
    var total: String?
    
    var page: String?
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["album": AlbumModel.self]
    }
}

class AlbumModel: NSObject {
    
    var id: String?
    
    var timingpublish: String?
    
    var addtime: String?
    
    var url: String?
    
    var adshow: String?
    
    var title: String?
    
    var timing: String?
    
    var fabu: String?
    
    var encoded: String?
    
    var amd5: String?
    
    var sort: String?
    
    var ds: String?
}
