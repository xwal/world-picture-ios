//
//  MoyaCacheablePlugin.swift
//  WorldPicture
//
//  Created by 霹雳火 on 2019/10/14.
//  Copyright © 2019 ChaosVoid. All rights reserved.
//

import Foundation
import Moya

final class MoyaCacheablePlugin: PluginType {
  func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
    if let moyaCachableProtocol = target as? MoyaCacheable {
      var cachableRequest = request
      cachableRequest.cachePolicy = moyaCachableProtocol.cachePolicy
      return cachableRequest
    }
    return request
  }
}
