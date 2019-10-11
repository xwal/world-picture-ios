//
//  PictorialModel.swift
//  WorldPicture
//
//  Created by Chaosky on 2016/11/21.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit
import YYModel

class PictorialModel: NSObject, YYModel {

    @objc var destination: PictorialDestModel?

    @objc var articles: [PictorialArticleModel]?
    
    @objc static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["articles": PictorialArticleModel.self]
    }
}
class PictorialDestModel: NSObject {

    @objc var name_en: String?

    @objc var name_zh_cn: String?

}

class PictorialArticleModel: NSObject, YYModel {

    @objc var id: Int = 0

    @objc var destination_intro: String?

    @objc var desc: String?

    @objc var photo_author: String?

    @objc var trip: ArticleTripModel?

    @objc var attraction: ArticleAttractionModel?

    @objc var image_url: String?

    @objc var destination_intro_title: String?

    @objc var text_author: String?

    @objc var title: String?

    @objc var summary: String?

    @objc var description_notes: [ArticleDescNoteModel]?

    @objc var photos: [ArticlePhotoModel]?

    @objc var destination: ArticleDestModel?
    
    @objc static func modelCustomPropertyMapper() -> [String : Any]? {
        return ["desc": "description"]
    }
    
    @objc static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["description_notes": ArticleDescNoteModel.self, "photos": ArticlePhotoModel.self]
    }

}

class ArticleDestModel: NSObject {

    @objc var id: Int = 0

    @objc var name: String?

}

class ArticleTripModel: NSObject {

    @objc var id: Int = 0

    @objc var name: String?

}

class ArticleAttractionModel: NSObject {

    @objc var id: Int = 0

    @objc var name: String?

}

class ArticleDescNoteModel: NSObject, YYModel {

    @objc var image_url: String?

    @objc var image_width: Int = 0

    @objc var image_height: Int = 0

    @objc var desc: String?
    
    @objc static func modelCustomPropertyMapper() -> [String : Any]? {
        return ["desc": "description"]
    }

}

class ArticlePhotoModel: NSObject {

    @objc var image_url: String?

    @objc var image_height: Int = 0

    @objc var image_width: Int = 0

}

