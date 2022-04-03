//
//  Direction_SampleTests.swift
//  Direction-SampleTests
//
//  Created by Shichimitoucarashi on 5/10/19.
//  Copyright © 2019 keisuke yamagishi. All rights reserved.
//

import XCTest
import GoogleMaps

class Direction_SampleTests: XCTestCase {

    override func setUp() {
        super.setUp()
        APIKEY = "AIzaSyC0hOi1H3H-GorTbUIG8Ttoy4jDua5Vcd4"
        GMSServices.provideAPIKey("AIzaSyC0hOi1H3H-GorTbUIG8Ttoy4jDua5Vcd4")
    }

    func testSingleDirection() {

        let exp = expectation(description: "Single Exception")

        let direction = Direction(from: "35.6775602107869,139.692658446729",
                                  to: "35.707848364433,139.701456092298")
        direction.detectRoute(completion: { (route) in
            XCTAssertEqual(route.routes.count, 1)
            exp.fulfill()
        }, failuer: { _ in
            XCTFail("Failuer? OMG 😱")
            exp.fulfill()
        })
        wait(for: [exp], timeout: 60.0)
    }

    func testMultipleDirection() {

        let exp = expectation(description: "Multiple Exception")

        let direction = Direction(from: "35.6775602107869,139.692658446729",
                                  to: "35.707848364433,139.701456092298",
                                  alternative: true)
        direction.detectRoute(completion: { (route) in
            XCTAssert(route.routes.count > 0 ? true : false )
            exp.fulfill()
        }, failuer: { _ in
            XCTFail("Failuer? OMG 😱")
            exp.fulfill()
        })
        wait(for: [exp], timeout: 60.0)
    }

    func test_DrectionFailuer () {

        let exp = expectation(description: "Failuer Exception")

        let direction = Direction(from: "Failuer_1",
                                  to: "Failuer_2",
                                  alternative: true)
        direction.detectRoute(completion: { _ in
            XCTFail("not Failuer OMG 😱")
            exp.fulfill()
        }, failuer: { _ in
            exp.fulfill()
        })
        wait(for: [exp], timeout: 60.0)

    }

    func test_DrectionDriving () {

        print("TEST3")

        let exp = expectation(description: "Failuer Exception")

        let direction = Direction(from: "35.6775602107869,139.692658446729",
                                  to: "35.707848364433,139.701456092298",
                                  alternative: true,
                                  mode: .driving)
        direction.detectRoute(completion: { (route) in
            XCTAssert(route.routes.count > 0 ? true : false )
            exp.fulfill()
        }, failuer: { _ in
            exp.fulfill()
        })
        wait(for: [exp], timeout: 60.0)

    }

    func test_DrectionBicycling () {

        let exp = expectation(description: "Failuer Exception")
        let direction = Direction(from: "35.6775602107869,139.692658446729",
                                  to: "35.707848364433,139.701456092298",
                                  alternative: true,
                                  mode: .bicycling)
        direction.detectRoute(completion: { (route) in
            XCTAssert(route.routes.count > 0 ? true : false )
            exp.fulfill()
        }, failuer: { _ in
            exp.fulfill()
        })
        wait(for: [exp], timeout: 60.0)
    }

    func test_DrectionWalking () {

        let exp = expectation(description: "Failuer Exception")
        let direction = Direction(from: "35.6775602107869,139.692658446729",
                                  to: "35.707848364433,139.701456092298",
                                  alternative: true,
                                  mode: .walking)
        direction.detectRoute(completion: { (route) in
            XCTAssert(route.routes.count > 0 ? true : false )
            exp.fulfill()
        }, failuer: { _ in
            exp.fulfill()
        })
        wait(for: [exp], timeout: 60.0)

    }
