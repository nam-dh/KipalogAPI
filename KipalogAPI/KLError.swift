//
//  KLError.swift
//  KipalogAPI
//
//  Created by Nam Doan on 2018/06/07.
//  Copyright © 2018年 Nam Doan. All rights reserved.
//

import Foundation

public enum KLError: Equatable {
    case connectionTimeout
    case connectionFailed
    case inputError
    case noContent
    case invalidJSON
    case serverError(code: Int, message: String)
    case unknown
}
