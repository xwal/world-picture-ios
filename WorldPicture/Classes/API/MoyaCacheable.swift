//
//  MoyaCacheable.swift
//  WorldPicture
//
//  Created by 霹雳火 on 2019/10/14.
//  Copyright © 2019 ChaosVoid. All rights reserved.
//

import Foundation

protocol MoyaCacheable {
    typealias MoyaCacheablePolicy = URLRequest.CachePolicy
    var cachePolicy: MoyaCacheablePolicy { get }
}

extension MoyaCacheable {
    var cachePolicy: MoyaCacheablePolicy {
        return .useProtocolCachePolicy
    }
}
