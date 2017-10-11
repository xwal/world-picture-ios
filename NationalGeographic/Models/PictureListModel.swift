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

    @objc var picture: [PictureModel]?

    @objc var counttotal: String?
    
    @objc static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["picture": PictureModel.self]
    }
    
}
class PictureModel: NSObject {

    @objc var id: String?

    @objc var thumb: String?

    @objc var author: String?

    @objc var addtime: String?

    @objc var url: String?

    @objc var pmd5: String?

    @objc var type: String?

    @objc var title: String?

    @objc var size: String?

    @objc var albumid: String?

    @objc var yourshotlink: String?

    @objc var weburl: String?

    @objc var encoded: String?

    @objc var sort: String?

    @objc var copyright: String?

    @objc var content: String?

}

