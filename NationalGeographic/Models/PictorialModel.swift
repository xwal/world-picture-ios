//
//  PictorialModel.swift
//  NationalGeographic
//
//  Created by Chaosky on 2016/11/21.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit
import YYModel

class PictorialModel: NSObject, YYModel {

    var destination: PictorialDestModel?

    var articles: [PictorialArticleModel]?
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["articles": PictorialArticleModel.self]
    }
}
class PictorialDestModel: NSObject {

    var name_en: String?

    var name_zh_cn: String?

}

class PictorialArticleModel: NSObject, YYModel {

    var id: Int = 0

    var destination_intro: String?

    var desc: String?

    var photo_author: String?

    var trip: ArticleTripModel?

    var attraction: ArticleAttractionModel?

    var image_url: String?

    var destination_intro_title: String?

    var text_author: String?

    var title: String?

    var summary: String?

    var description_notes: [ArticleDescNoteModel]?

    var photos: [ArticlePhotoModel]?

    var destination: ArticleDestModel?
    
    static func modelCustomPropertyMapper() -> [String : Any]? {
        return ["desc": "description"]
    }
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["description_notes": ArticleDescNoteModel.self, "photos": ArticlePhotoModel.self]
    }

}

class ArticleDestModel: NSObject {

    var id: Int = 0

    var name: String?

}

class ArticleTripModel: NSObject {

    var id: Int = 0

    var name: String?

}

class ArticleAttractionModel: NSObject {

    var id: Int = 0

    var name: String?

}

class ArticleDescNoteModel: NSObject, YYModel {

    var image_url: String?

    var image_width: Int = 0

    var image_height: Int = 0

    var desc: String?
    
    static func modelCustomPropertyMapper() -> [String : Any]? {
        return ["desc": "description"]
    }

}

class ArticlePhotoModel: NSObject {

    var image_url: String?

    var image_height: Int = 0

    var image_width: Int = 0

}

