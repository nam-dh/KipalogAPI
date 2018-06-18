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
    var tags: [String] { get }
    var type: KLContentType { get }
}

public enum KLContentType {
    case markdown
    case html
}

public struct KLServerPost: KLPost {
    public let id: String
    public let title: String
    public let content: String
    public let tags: [String]
    public let type: KLContentType

    public init?(json: JSONDictionary) {
        guard let id = json["id"] as? String, !id.isEmpty else {
            return nil
        }
        self.id = id
        self.title = json["title"] as? String ?? ""
        self.content = json["content"] as? String ?? ""
        self.type = .markdown
        self.tags = []
    }

    public init(id: String, title: String, content: String, tags: [String] = [], type: KLContentType) {
        self.id = id
        self.title = title
        self.content = content
        self.tags = []
        self.type = type
    }
}

public struct KLLocalPost: KLPost {
    public let title: String
    public let content: String
    public let tags: [String]
    public let type: KLContentType

    public init(title: String, content: String, tags: [String], type: KLContentType) {
        self.title = title
        self.content = content
        self.tags = tags
        self.type = type
    }
}
