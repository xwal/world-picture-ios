//
//  TodayPictorialModel.swift
//  WorldPicture
//
//  Created by Chaosky on 2016/12/2.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit
import YYModel

class TodayPictorialModel: NSObject, YYModel {
    @objc var id: Int = 0

    @objc var title: String?

    @objc var android_wallpaper_url: String?

    @objc var destination: String?

    @objc var ios_wallpaper_url: String?

    @objc var publish_date: String?
    
    @objc var articles: [PictorialArticleModel]?
    
    @objc static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["articles": PictorialArticleModel.self]
    }
}
