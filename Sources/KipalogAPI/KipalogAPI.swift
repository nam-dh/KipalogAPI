//
//  KipalogAPI.swift
//  KipalogAPI
//
//  Created by Nam Doan on 2018/06/07.
//  Copyright © 2018年 Nam Doan. All rights reserved.
//

import Foundation

public class KipalogAPI {
    struct Environment {
        let apiRequester: KLAPIRequesterProtocol
    }
    public static let shared = KipalogAPI()

    private let environment: Environment
    init(_ env: KipalogAPI.Environment? = nil) {
        self.environment = env ?? KipalogAPI.Environment(apiRequester: KLAPIRequester.shared)
    }

    public var accessToken: String {
        get {
            return KLAPIRequester.shared.accessToken
        }
        set {
            KLAPIRequester.shared.accessToken = newValue
        }
    }

    public enum PostListType {
        case hot
        case latest
        case tag(String)

        var apiTag: KLAPI.Tag {
            switch self {
            case .hot:
                return .hotPostList
            case .latest:
                return .latestPostList
            case .tag:
                return .postByTag
            }
        }

        var requestData: JSONDictionary {
            switch self {
            case .hot, .latest:
                return [:]
            case .tag(let name):
                return ["tag_name": name]
            }
        }
    }

    public func getPostList(type: PostListType, completion: @escaping (KLResult<[KLServerPost], KLError>) -> Void) {
        environment.apiRequester.post(type.apiTag, data: type.requestData) { (result) in
            let res = result
                .flatMap({ (json) -> KLResult<[JSONDictionary], KLError> in
                    if let list = json["content"] as? [JSONDictionary] {
                        return .success(list)
                    } else {
                        return .failure(.invalidJSON)
                    }
                })
                .flatMap({ (list) -> KLResult<[KLServerPost], KLError> in
                    let posts = list.compactMap({ KLServerPost(json: $0) })
                    return .success(posts)
                })
            completion(res)
        }
    }

    public enum PostAction: String {
        case publish = "published"
        case draft = "draft"
    }

    public func post(_ post: KLLocalPost, action: PostAction, completion: @escaping (KLError?) -> Void) {
        let data: JSONDictionary = [
            "title": post.title,
            "content": post.content,
            "status": action.rawValue,
            "tag": post.tags.joined(separator: ",")
        ]
        environment.apiRequester.post(.createPost, data: data) { (result) in
            completion(result.error)
        }
    }

    public func preview(_ post: KLLocalPost, completion: @escaping (KLResult<KLLocalPost, KLError>) -> Void) {
        guard post.type == .markdown else {
            return completion(.failure(KLError.inputError))
        }
        let data: JSONDictionary = [
            "content": post.content
        ]
        environment.apiRequester.post(.previewPost, data: data) { (result) in
            let response = result
                .flatMap({ (json) -> KLResult<KLLocalPost, KLError> in
                    if let content = json["content"] as? String {
                        let newPost = KLLocalPost(title: post.title, content: content, tags: post.tags, type: .html)
                        return .success(newPost)
                    } else {
                        return .failure(.invalidJSON)
                    }
                })
            completion(response)
        }
    }
}
