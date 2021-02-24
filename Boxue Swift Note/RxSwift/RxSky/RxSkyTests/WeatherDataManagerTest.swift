//
//  WeatherDataManagerTest.swift
//  RxSkyTests
//
//  Created by Bq Lin on 2021/2/22.
//  Copyright © 2021 Bq. All rights reserved.
//

import XCTest
// 引入项目模块
@testable import RxSky

class WeatherDataManagerTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    //func testPerformanceExample() throws {
    //    // This is an example of a performance test case.
    //    self.measure {
    //        // Put the code you want to measure the time of here.
    //    }
    //}
    
    func test_requestWeatherData() {
        let expect = expectation(description: "测试天气数据请求")
        WeatherDataManager.shared.requestWeatherDataAt(latitude: 52, longitude: 100) { (data, error) in
            dump(data)
            dump(error)
            
            XCTAssert(data != nil, "数据不为空")
            XCTAssert(error == nil, "没有产生错误")
            
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 30, handler: nil)
    }

}
