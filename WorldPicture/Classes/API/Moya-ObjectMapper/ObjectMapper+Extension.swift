//
//  ObjectMapper+Extension.swift
//  YiLuTong
//
//  Created by 霹雳火 on 2018/11/9.
//  Copyright © 2018 GuoXiaoMei. All rights reserved.
//

import Foundation
import ObjectMapper

public extension BaseMappable {
    /// Initializes object from a Data
    init?(JSONData: Data, context: MapContext? = nil) {
        guard let JSONString = String(data: JSONData, encoding: .utf8) else {
            return nil
        }
        self.init(JSONString: JSONString)
    }
    
    func toJSONData(prettyPrint: Bool = false) -> Data? {
        return toJSONString(prettyPrint: prettyPrint)?.data(using: .utf8)
    }
}

public extension Array where Element: BaseMappable {
    init?(JSONData: Data, context: MapContext? = nil) {
        guard let JSONString = String(data: JSONData, encoding: .utf8) else {
            return nil
        }
        self.init(JSONString: JSONString)
    }
    
    func toJSONData(prettyPrint: Bool = false) -> Data? {
        return toJSONString(prettyPrint: prettyPrint)?.data(using: .utf8)
    }
}
