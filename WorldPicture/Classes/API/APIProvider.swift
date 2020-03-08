//
//  APIProvider.swift
//

import Foundation
import Moya

// MARK: - Provider support

let APIProvider = MoyaProvider<MultiTarget>(plugins: [
    MoyaCacheablePlugin(),
    NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(logOptions: [.formatRequestAscURL, .successResponseBody, .errorResponseBody])),
    NetworkActivityPlugin(networkActivityClosure: { change, _ in
        DispatchQueue.main.async {
            switch change {
            case .began:
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            case .ended:
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    })
])

//swiftlint:disable:next identifier_name
let RxAPIProvider = APIProvider.rx
