//
//  KipalogAPITests.swift
//  KipalogAPI
//
//  Created by Nam Doan on 2018/06/07.
//  Copyright © 2018年 Nam Doan. All rights reserved.
//

import XCTest
@testable import KipalogAPI

final class KipalogAPITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testGetHotPostListSuccess() {
        let expectation = self.expectation(description: "testGetHotPostListSuccess")
        let env = KipalogAPI.Environment(apiRequester: KLTestRequester(responseWithJSONFile: "HotPostListSuccess.json"))
        KipalogAPI(env).getPostList(type: .hot) { (result) in
            XCTAssert(result.value?.count == 30)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 10)
    }

    func testGetHotPostListFailed() {
        let expectation = self.expectation(description: "testGetHotPostListFailed")
        let env = KipalogAPI.Environment(apiRequester: KLTestRequester(responseWithError: .connectionFailed))
        KipalogAPI(env).getPostList(type: .hot) { (result) in
            XCTAssertNil(result.value)
            XCTAssert(result.error! == KLError.connectionFailed)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 10)
    }

    func testGetNewestPostListSuccess() {
        let expectation = self.expectation(description: "testGetNewestPostListSuccess")
        let env = KipalogAPI.Environment(apiRequester: KLTestRequester(responseWithJSONFile: "NewestPostListSuccess.json"))
        KipalogAPI(env).getPostList(type: .latest) { (result) in
            XCTAssert(result.value?.count == 30)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 10)
    }

    func testGetNewestPostListFailed() {
        let expectation = self.expectation(description: "testGetNewestPostListFailed")
        let env = KipalogAPI.Environment(apiRequester: KLTestRequester(responseWithError: .connectionTimeout))
        KipalogAPI(env).getPostList(type: .latest) { (result) in
            XCTAssertNil(result.value)
            XCTAssert(result.error! == KLError.connectionTimeout)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 10)
    }

    func testGetPostListByTagSuccess() {
        let expectation = self.expectation(description: "testGetPostListByTagSuccess")
        let env = KipalogAPI.Environment(apiRequester: KLTestRequester(responseWithJSONFile: "PostListByTagSuccess.json"))
        KipalogAPI(env).getPostList(type: .tag("swift")) { (result) in
            XCTAssert(result.value?.count == 30)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 10)
    }

    func testGetPostListByTagFailed() {
        let expectation = self.expectation(description: "testGetPostListByTagSuccess")
        let env = KipalogAPI.Environment(apiRequester: KLTestRequester(responseWithError: .connectionTimeout))
        KipalogAPI(env).getPostList(type: .tag("swift")) { (result) in
            XCTAssertNil(result.value)
            XCTAssert(result.error! == KLError.connectionTimeout)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 10)
    }
}
