//
//  KLTestRequester.swift
//  KipalogAPITests
//
//  Created by Nam Doan on 2018/06/07.
//  Copyright © 2018年 Nam Doan. All rights reserved.
//

import Foundation

final class KLTestRequester: KLAPIRequesterProtocol {
    typealias PostHandler = ((KLAPI.Tag, ((KLResult<JSONDictionary, KLError>) -> Void)?) -> URLSessionDataTask?)
    private let handler: PostHandler

    init(_ handler: @escaping PostHandler) {
        self.handler = handler
    }

    convenience init(responseWithJSONFile fileName: String) {
        let handler: PostHandler = { (_, completion) in
            let json = KLTestUtility.loadJSONFromFile(fileName)
            completion?(.success(json!))
            return nil
        }
        self.init(handler)
    }

    convenience init(responseWithError error: KLError) {
        let handler: PostHandler = { (_, completion) in
            completion?(.failure(error))
            return nil
        }
        self.init(handler)
    }

    @discardableResult
    func post(_ apiTag: KLAPI.Tag, data: JSONDictionary, completion: @escaping (KLResult<JSONDictionary, KLError>) -> Void) -> URLSessionDataTask? {
        return self.handler(apiTag, completion)
    }
}
