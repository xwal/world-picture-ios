//
//  CRMWebOperations.swift
//  GXM-CRM
//
//  Created by jsonmess on 2017/12/8.
//  Copyright © 2017年 GuoXiaoMei. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class WebOperations {
    // 拦截规则
    lazy var allowUrlRules: [String] = {
        ["http", "https", "file"]
    }()
    // MARK: 处理和维护Web中拦截的规则
    /// 检测过滤内部跳转并返回拦截需求
    func checkAndBlockInternalUrlScheme(request: URLRequest?) -> WKNavigationActionPolicy {
        if let url = request?.url {
            if let scheme = url.scheme, !allowUrlRules.contains(scheme) {
                return .cancel
            }
        }
        return .allow
    }

}
