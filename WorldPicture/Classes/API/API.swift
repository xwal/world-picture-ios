//
//  API.swift
// YiLuTong
//
//  Created by 霹雳火 on 2018/9/6.
//  Copyright © 2018 GuoXiaoMei. All rights reserved.
//

import Foundation
import Moya
import SwifterSwift

protocol MultiTargetProtocol: TargetType {
    var multiTarget: MultiTarget { get }
}

extension MultiTargetProtocol {
    var multiTarget: MultiTarget {
        return MultiTarget(self)
    }
    
    var headers: [String: String]? {
        return nil
    }
    
    // Mock数据文件的名字和枚举类型的名字保持一致
    var sampleData: Data {
        return Data()
    }
}

// MARK: 地理集
enum DiliAPI: MultiTargetProtocol {
    
    // 地理列表
    case mains(page: Int)
    // 地理相册
    case albums(albumId: String)
    
    var baseURL: URL {
        return URL(string: "http://dili.bdatu.com/jiekou/")!
    }
    
    var path: String {
        switch self {
        case let .albums(albumId):
            return "/albums/a\(albumId).html"
        case let .mains(page):
            return "/mains/p\(page).html"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .albums:
            return .get
        case .mains:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .mains, .albums:
            return .requestPlain
        }
    }
}

// MARK: 最美集
enum ZuimeiaAPI: MultiTargetProtocol {
    
    // 每日壁纸
    case everydayWallpaper(time: TimeInterval, pageSize: Int)
    // 分类列表
    case categoryList
    // 标签
    case tag(tagId: Int, time: TimeInterval, pageSize: Int)
    
    var baseURL: URL {
        return URL(string: "http://lab.zuimeia.com")!
    }
    
    var path: String {
        switch self {
        case .everydayWallpaper:
            return "/wallpaper/category/2/"
        case .categoryList:
            return "/wallpaper/tag/home/list/"
        case let .tag(tagId, _, _):
            return "/api/v2/wallpaper/tag/\(tagId)/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .everydayWallpaper, .categoryList, .tag:
            return .get
        }
    }
    
    var task: Task {
        let pixelSize = UIScreen.main.nativeBounds
        let resolution = "{\(Int(pixelSize.width)), \(Int(pixelSize.height))}"
        switch self {
        case let .everydayWallpaper(time, pageSize):
            var params: [String: Any] = [:]
            params["time"] = "\(Int(time))"
            params["platform"] = "iphone"
            params["resolution"] = resolution
            params["page_size"] = pageSize
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .categoryList:
            var params: [String: Any] = [:]
            params["platform"] = "iphone"
            params["resolution"] = resolution
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case let .tag(_, time, pageSize):
            var params: [String: Any] = [:]
            params["publish_at"] = "\(Int(time))"
            params["platform"] = "iphone"
            params["resolution"] = resolution
            params["page_size"] = pageSize
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }
}
