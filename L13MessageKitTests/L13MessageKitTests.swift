//
//  L13MessageKitTests.swift
//  L13MessageKitTests
//
//  Created by Luke Davis on 12/4/15.
//  Copyright © 2015 Lucky 13 Technologies, LLC. All rights reserved.
//

import XCTest
@testable import L13MessageKit

class L13MessageTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMessage_IsShownWhenFired() {
        let message = L13Message()
        message.fire()
        XCTAssertTrue(message.isShown)
    }
    
    func testMessage_isNotShownAfterDismissal() {
        let message = L13Message()
        message.fire()
        message.dismiss()
        XCTAssertFalse(message.isShown)
    }
    
    func testMessage_isVisableOnFire() {
        let message = L13Message()
        message.fire()
    }
    
}
