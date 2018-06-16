//
//  KLAPIRequester.swift
//  KipalogAPI
//
//  Created by Nam Doan on 2018/06/07.
//  Copyright © 2018年 Nam Doan. All rights reserved.
//

import Foundation

public typealias JSONDictionary = [String: Any]

struct KLAPI {
    enum RequestType: String {
        case post = "POST"
        case get = "GET"
    }

    enum Tag: String {
        case createPost = "v1/post"
        case previewPost = "v1/post/preview"
        case hotPostList = "v1/post/hot"
        case newestPostList = "v1/post/newest"
        case postByTag = "v1/post/bytag"

        var url: URL {
            return URL(string: "https://kipalog.com/api/" + self.rawValue)!
        }
        var type: KLAPI.RequestType {
            switch self {
            case .createPost, .previewPost, .postByTag:
                return .post
            case .hotPostList, .newestPostList:
                return .get
            }
        }
    }
}

protocol KLAPIRequesterProtocol {
    @discardableResult
    func post(_ apiTag: KLAPI.Tag, data: JSONDictionary, completion: @escaping (KLResult<JSONDictionary, KLError>) -> Void) -> URLSessionDataTask?
}

class KLAPIRequester: KLAPIRequesterProtocol {
    static let shared = KLAPIRequester()
    private var urlSession: URLSession
    private let completionQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "KLRequestManager Completion Queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()

    var accessToken: String = ""

    // MARK: - Initialize
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        configuration.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        self.urlSession = URLSession(configuration: configuration, delegate: nil, delegateQueue: completionQueue)
    }

    /// Send a HTTP request
    ///
    /// - Parameter request: The HTTP request to send.
    /// - Parameter completionHandler: Called on completion of the request.
    /// - Returns: A `URLSessionDataTask` that can be used for cancelling the request (if needed).
    @discardableResult
    private func httpRequest(with request: URLRequest, completionHandler: @escaping (KLResult<Data?, KLError>) -> Void) -> URLSessionDataTask {
        let task = self.urlSession.dataTask(with: request) { (data, response, error) in
            if let error = error {
                if case URLError.timedOut = error {
                    completionHandler(.failure(.connectionTimeout))
                } else {
                    completionHandler(.failure(.connectionFailed))
                }
                return
            }
            guard let response = response as? HTTPURLResponse else {
                completionHandler(.failure(.connectionFailed))
                return
            }
            guard response.statusCode == 200 else {
                completionHandler(.failure(.connectionFailed))
                return
            }
            completionHandler(.success(data))
        }
        task.resume()
        return task
    }


    @discardableResult
    func post(_ apiTag: KLAPI.Tag, data: JSONDictionary = [:], completion: @escaping (KLResult<JSONDictionary, KLError>) -> Void) -> URLSessionDataTask? {
        guard JSONSerialization.isValidJSONObject(data) else {
            completion(.failure(KLError.inputError))
            return nil
        }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            var request = URLRequest(url: apiTag.url)
            request.setValue(accessToken, forHTTPHeaderField: "X-Kipalog-Token")
            if apiTag.type == .post {
                request.httpMethod = apiTag.type.rawValue
                request.setValue("application/json", forHTTPHeaderField: "Accept-Charset")
                request.httpBody = jsonData
            }
            return httpRequest(with: request) { (response) in
                let result = response
                    .flatMap({ data -> KLResult<JSONDictionary, KLError> in
                        guard let data = data else {
                            return .failure(KLError.noContent)
                        }
                        let any = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                        guard let json = any as? JSONDictionary else {
                            return .failure(KLError.invalidJSON)
                        }
                        return .success(json)
                    })
                    .flatMap({ (json) -> KLResult<JSONDictionary, KLError> in
                        guard let code = json["status"] as? Int else {
                            return .failure(KLError.invalidJSON)
                        }
                        guard code == 200 else {
                            let error = KLError.serverError(code: code, message: json["cause"] as? String ?? "")
                            return .failure(error)
                        }
                        return .success(json)
                    })
                completion(result)
            }
        } catch {
            completion(.failure(KLError.inputError))
            return nil
        }
    }
}
