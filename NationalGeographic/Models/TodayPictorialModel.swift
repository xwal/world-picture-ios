//
//  TodayPictorialModel.swift
//  NationalGeographic
//
//  Created by Chaosky on 2016/12/2.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit
import YYModel

class TodayPictorialModel: WallpaperModel, YYModel {
    @objc var articles: [PictorialArticleModel]?
    
    @objc static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["articles": PictorialArticleModel.self]
    }
}
