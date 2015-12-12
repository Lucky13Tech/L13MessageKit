//
//  L13MessageKitTests.swift
//  L13MessageKitTests
//
//  Created by Luke Davis on 12/4/15.
//  Copyright © 2015 Lucky 13 Technologies, LLC. All rights reserved.
//

import XCTest
@testable import L13MessageKit

class L13MessageKitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        try! L13MessageManager().postMessage(PrinterMessage(message: "Made It"))
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}

class PrinterMessage: L13Message {
    
    var message: String
    
    init(message: String) {
        self.message = message
    }
    
    override func fire() {
        print("Output Test: \(message)")
    }
    
}
