//
//  KLResult.swift
//  KipalogAPI
//
//  Created by Nam Doan on 2018/06/07.
//  Copyright © 2018年 Nam Doan. All rights reserved.
//

import Foundation

public enum KLResult<Value, ErrorType> {
    case success(Value)
    case failure(ErrorType)

    /// Returns `true` if the result is a success, `false` otherwise.
    public var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }

    /// Returns `true` if the result is a failure, `false` otherwise.
    public var isFailure: Bool {
        return !isSuccess
    }

    /// Returns the associated value if the result is a success, `nil` otherwise.
    public var value: Value? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }

    /// Returns the associated error value if the result is a failure, `nil` otherwise.
    public var error: ErrorType? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }

    @inline(__always)
    public func map<U>(_ transform: (Value) -> U) -> KLResult<U, ErrorType> {
        return self.flatMap { .success(transform($0)) }
    }

    @inline(__always)
    public func flatMap<U>(_ transform: (Value) -> KLResult<U, ErrorType>) -> KLResult<U, ErrorType> {
        switch self {
        case let .success(value):
            return transform(value)
        case let .failure(error):
            return .failure(error)
        }
    }

    @inline(__always)
    @discardableResult
    public func mapError<U>(_ transform: (ErrorType) -> U) -> KLResult<Value, U> {
        return self.flatMapError { .failure(transform($0)) }
    }

    @inline(__always)
    public func flatMapError<U>(_ transform: (ErrorType) -> KLResult<Value, U>) -> KLResult<Value, U> {
        switch self {
        case let .success(value):
            return .success(value)
        case let .failure(error):
            return transform(error)
        }
    }
}
