//
//  KLModels.swift
//  KipalogAPI
//
//  Created by Nam Doan on 2018/06/07.
//  Copyright © 2018年 Nam Doan. All rights reserved.
//

import Foundation

public protocol KLPost {
    var title: String { get }
    var content: String { get }
}

public struct KLServerPost: KLPost {
    public let id: String
    public let title: String
    public let content: String

    public init?(json: JSONDictionary) {
        guard let id = json["id"] as? String, !id.isEmpty else {
            return nil
        }
        self.id = id
        self.title = json["title"] as? String ?? ""
        self.content = json["content"] as? String ?? ""
    }
}

public struct KLLocalPost: KLPost {
    public let title: String
    public let content: String
    public let tags: [String]
}
