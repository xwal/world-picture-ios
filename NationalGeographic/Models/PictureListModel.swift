//
//  PictureListModel.swift
//  NationalGeographic
//
//  Created by Chaosky on 2016/11/15.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit
import YYModel

class PictureListModel: NSObject, YYModel {

    var picture: [PictureModel]?

    var counttotal: String?
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["picture": PictureModel.self]
    }
    
}
class PictureModel: NSObject {

    var id: String?

    var thumb: String?

    var author: String?

    var addtime: String?

    var url: String?

    var pmd5: String?

    var type: String?

    var title: String?

    var size: String?

    var albumid: String?

    var yourshotlink: String?

    var weburl: String?

    var encoded: String?

    var sort: String?

    var copyright: String?

    var content: String?

}

