//
//  UIScrollViewExtensions.swift
//  WorldPicture
//
//  Created by 霹雳火 on 2019/10/14.
//  Copyright © 2019 ChaosVoid. All rights reserved.
//

import Foundation
import UIKit

public enum RefreshStatus: Int {
    case invalidData // 无效的数据
    case hasMoreData // 还有更多数据
    case noMoreData // 没有更多数据
}

public extension UIScrollView {
    func refresh(status: RefreshStatus, isEmpty: Bool, shouldForcedDisplay: Bool = false) {
        mj_header?.endRefreshing()
        switch status {
        case .invalidData: // 无效的数据
            mj_footer?.endRefreshing()
        case .hasMoreData: // 还有更多数据
            mj_footer?.endRefreshing()
            mj_footer?.isHidden = false
        case .noMoreData: // 没有更多数据
            mj_footer?.endRefreshingWithNoMoreData()
            mj_footer?.isHidden = false
        }
        // 数据为空，隐藏footer
        if isEmpty {
            mj_footer?.isHidden = true
        }
    }
}
