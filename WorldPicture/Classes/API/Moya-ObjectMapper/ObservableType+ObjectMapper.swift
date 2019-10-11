//
//  ObserverType+ObjectMapper.swift
//
//  Created by Ivan Bruel on 09/12/15.
//  Copyright © 2015 Ivan Bruel. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper
import RxSwift

/// Extension for processing Responses into Mappable objects through ObjectMapper
public extension ObservableType where Element == Response {

    /// Maps data received from the signal into an object
    /// which implements the Mappable protocol and returns the result back
    /// If the conversion fails, the signal errors.
    func map<T: BaseMappable>(_ type: T.Type, context: MapContext? = nil) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            Observable.just(try response.map(type, context: context))
        }
    }

    /// Maps data received from the signal into an array of objects
    /// which implement the Mappable protocol and returns the result back
    /// If the conversion fails, the signal errors.
    func map<T: BaseMappable>(_ type: [T].Type, context: MapContext? = nil) -> Observable<[T]> {
        return flatMap { response -> Observable<[T]> in
            Observable.just(try response.map(type, context: context))
        }
    }

    /// Maps data received from the signal into an object
    /// which implements the Mappable protocol and returns the result back
    /// If the conversion fails, the signal errors.
    func map<T: BaseMappable>(_ type: T.Type, atKeyPath keyPath: String, context: MapContext? = nil) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            Observable.just(try response.map(T.self, atKeyPath: keyPath, context: context))
        }
    }

    /// Maps data received from the signal into an array of objects
    /// which implement the Mappable protocol and returns the result back
    /// If the conversion fails, the signal errors.
    func map<T: BaseMappable>(_ type: [T].Type, atKeyPath keyPath: String, context: MapContext? = nil) -> Observable<[T]> {
        return flatMap { response -> Observable<[T]> in
            Observable.just(try response.map(type, atKeyPath: keyPath, context: context))
        }
    }
}

// MARK: - ImmutableMappable
public extension ObservableType where Element == Response {

    /// Maps data received from the signal into an object
    /// which implements the ImmutableMappable protocol and returns the result back
    /// If the conversion fails, the signal errors.
    func map<T: ImmutableMappable>(_ type: T.Type, context: MapContext? = nil) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            Observable.just(try response.map(type, context: context))
        }
    }

    /// Maps data received from the signal into an array of objects
    /// which implement the ImmutableMappable protocol and returns the result back
    /// If the conversion fails, the signal errors.
    func map<T: ImmutableMappable>(_ type: [T].Type, context: MapContext? = nil) -> Observable<[T]> {
        return flatMap { response -> Observable<[T]> in
            Observable.just(try response.map(type, context: context))
        }
    }

    /// Maps data received from the signal into an object
    /// which implements the ImmutableMappable protocol and returns the result back
    /// If the conversion fails, the signal errors.
    func map<T: ImmutableMappable>(_ type: T.Type, atKeyPath keyPath: String, context: MapContext? = nil) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            Observable.just(try response.map(T.self, atKeyPath: keyPath, context: context))
        }
    }

    /// Maps data received from the signal into an array of objects
    /// which implement the ImmutableMappable protocol and returns the result back
    /// If the conversion fails, the signal errors.
    func map<T: ImmutableMappable>(_ type: [T].Type, atKeyPath keyPath: String, context: MapContext? = nil) -> Observable<[T]> {
        return flatMap { response -> Observable<[T]> in
            Observable.just(try response.map(type, atKeyPath: keyPath, context: context))
        }
    }
}
