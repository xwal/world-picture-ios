//
//  APIProvider.swift
// YiLuTong
//
//  Created by 霹雳火 on 16/05/2018.
//  Copyright © 2018 GuoXiaoMei. All rights reserved.
//

import Foundation
import Moya
import Result
import SwiftyJSON
import class Alamofire.ServerTrustPolicyManager
import enum Alamofire.ServerTrustPolicy

private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data // fallback to original data if it can't be serialized.
    }
}

private func reversedPrint(_ separator: String, terminator: String, items: Any...) {
    for item in items {
        if let msg = item as? String {
            print(msg)
        }
    }
}

// MARK: - Provider support

let APIProvider = MoyaProvider<MultiTarget>(plugins: [
    MoyaCacheablePlugin(),
    NetworkLoggerPlugin(verbose: true,
                        cURL: true,
                        output: reversedPrint),
    NetworkActivityPlugin(networkActivityClosure: { change, _ in
        DispatchQueue.main.async {
            switch change {
            case .began:
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            case .ended:
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }),
])

let RxAPIProvider = APIProvider.rx
