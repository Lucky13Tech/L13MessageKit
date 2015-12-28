//
//  L13MessageManagerTest.swift
//  L13MessageKit
//
//  Created by Luke Davis on 12/24/15.
//  Copyright © 2015 Lucky 13 Technologies, LLC. All rights reserved.
//

import XCTest


class L13MessageManagerTest: XCTestCase {
    
    let manager = L13MessageManager()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        manager.clear()
        super.tearDown()
    }
    
    /**
     Tests that a valid message will be marked as the presented messgae. This is validated through posting and checkng the presented Message field
    */
    func testPostMessage_setsMessageAsPresented() {
        let message = L13Message()
        try! manager.postMessage(message)
        XCTAssertNotNil(manager.presentedMessage)
        XCTAssertEqual(manager.presentedMessage, message)
    }
    
    /**
     Tests that a message will be placed into the scheduled queue if another message is already presented
    */
    func testPostMessage_setsMessageInScheduledQueueIfMessageAlreadyPresented() {
        let firstMessage = L13Message()
        let secondMessage = L13Message()
        // Present first message
        try! manager.postMessage(firstMessage)
        // Without dismissing let's try and post the second messsage
        try! manager.postMessage(secondMessage)
        // The scheduled messages list should not be empty
        XCTAssertTrue(manager.scheduledMessages.count == 1)
        // The scheduled messages should contain secondMessage
        XCTAssertEqual(manager.scheduledMessages.first, secondMessage)
        // The secondMessage should not be in the presentedMessage field
        XCTAssertNotEqual(manager.presentedMessage, secondMessage)
    }
    
    /**
     Tests that dismiss removes the message from the presentedMessage
    */
    func testDismissPresentedMessage_removesFromPresentedMessage() {
        let message = L13Message()
        try! manager.postMessage(message)
        XCTAssertNotNil(manager.presentedMessage)
        try! manager.dismissPresentedMessage()
        XCTAssertNil(manager.presentedMessage)
    }
    
    /**
     Tests that dismiss throws error if there is no presented message
    */
    func testDismissMessage_throwsErrorIfPresentedMessageIsNotThatOfTheRequested() {
        var errorThrown = false
        do {
            try manager.dismissPresentedMessage()
        } catch L13MessageManagerError.NoPresentedMessage {
            errorThrown = true
        } catch {
            assertionFailure("Unrecognized error condition")
        }
        XCTAssertTrue(errorThrown)
    }
    
    /**
     Test that another message is presented if the previous presented message is dismissed
    */
    func testPostMessage_movesNextMessageToPresented() {
        let firstMessage = L13Message()
        let secondMessage = L13Message()
        let thirdMessage = L13Message()
        // Set the first message
        try! manager.postMessage(firstMessage)
        // Set the second message
        try! manager.postMessage(secondMessage)
        // Just to confirm that only the first message is removed from the scheduled queue let's add one more
        try! manager.postMessage(thirdMessage)
        // Dismiss the first message
        try! manager.dismissPresentedMessage()
        // Check that the presented message is now secondMessage
        XCTAssertEqual(manager.presentedMessage?.identifier, secondMessage.identifier)
        // Check that the scheduleMessages has one message
        XCTAssertTrue(manager.scheduledMessages.count == 1)
        // Confirm that the message in the scheduled messages is the third message
        XCTAssertEqual(manager.scheduledMessages.first?.identifier, thirdMessage.identifier)
    }
    
    func testCancelMessage_removesMessageFromScheduled() {
        let firstMessage = L13Message()
        let secondMessage = L13Message()
        let thirdMessage = L13Message()

        try! manager.postMessage(firstMessage)
        try! manager.postMessage(secondMessage)
        try! manager.postMessage(thirdMessage)
        // Since the first message would be posted there should be two messages in the scheduled messages
        XCTAssertTrue(manager.scheduledMessages.count == 2)
        try! manager.cancelScheduledMessage(secondMessage)
        // The scheduled size should now be 1
        XCTAssertTrue(manager.scheduledMessages.count == 1)
        // The element left in the scheduled queue should be the third message
        XCTAssertEqual(manager.scheduledMessages.first, thirdMessage)
    }
}
