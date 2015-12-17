//
//  L13MessageManager.swift
//  L13MessageKit
//
//  Created by Luke Davis on 12/4/15.
//  Copyright © 2015 Lucky 13 Technologies, LLC. All rights reserved.
//

import UIKit

public protocol L13MessageManagerDelegate: NSObjectProtocol {
    
//    func messageManager(manager: L13MessageManager, willPostMessage message: L13Message) -> Bool
//    
//    func messageManager(manager: L13MessageManager, didPostMessage message: L13Message)
//    
//    func messageManager(manager: L13MessageManager, willCancelMessage message: L13Message) -> Bool
//    
//    func messageManager(manager: L13MessageManager, didCancelMessage message: L13Message)
    
}

/**
 *  Message Styles
 *    1. Message Style <- Firable, Identifiable, Cancalable, Dismissable, Schedulable
 *      1. Action Message <- Actionable
 *        1. Notification Style
 *        2. Alert Style
 *        3. Action Banner Style
 *        4. Action Modal Style
 *      2. Transient Message <- AutoDismissable
 *        1. Hud Style
 *          1. Toast Style - Timed Duration
 *              1. Toast Banner Style
 *        2. Banner Style
 *        3. Modal Style
 *
*/
public class L13MessageManager: NSObject {
    
    public var delegate: L13MessageManagerDelegate?
    
    private var _messages = Dictionary<String, L13Message>()
    
    // Current Messages
    public var messages: [String: L13Message] {
        get {
            return _messages
        }
    }
    
    // Post message
    public func postMessage(message: L13Message) throws {
        message.fire()
    }
    
    public func postMessage(message: L13Message, withDelay delay: NSTimeInterval) throws {
        self.delay(delay) {
            message.fire()
        }
    }
    
    // Cancel message
    public func cancelMessage(message: L13Message) throws {
        message.dismiss()
    }

}

extension L13MessageManager {
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
}
