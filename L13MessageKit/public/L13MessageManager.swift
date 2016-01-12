//
//  L13MessageManager.swift
//  L13MessageKit
//
//  Created by Luke Davis on 12/4/15.
//  Copyright © 2015 Lucky 13 Technologies, LLC. All rights reserved.
//

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
import UIKit

public enum L13MessageManagerError: ErrorType {
    case NoPresentedMessage
}

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
 # L13MessageManager 
 Provides a way to manage messages available to the user
 
 ## Features
   1. Post a Message
     1. A message can be delayed for when it is shown on screen
     2. Ensures only one message is presented at a time
       1. If a message is posted and another message is already presented the new message will be added to the back of a scheduled queue
   2. A presented message can be dismissed without an identifier
   3. A scheduled message can be canceled
   4.
 
 */
public class L13MessageManager: NSObject {
    
//    public var delegate: L13MessageManagerDelegate?
//    
//    // The messages should be tracked at a class level not an instance. This will prevent multiple lists
//    private static var _messages = L13Queue<L13Message>()
//    // The presented message should be at a class level to avoid multiple instances
//    private static var _presentedMessage: L13Message?
//    var presenter = L13PresentationManager()
//    
//    // Current Messages
//    public var scheduledMessages: [L13Message] {
//        get {
//            return L13MessageManager._messages.array
//        }
//    }
//    
//    // Provides the currently presented message
//    public var presentedMessage: L13Message? {
//        get {
//            return L13MessageManager._presentedMessage
//        }
//    }
//    
//    // Post message
//    public func postMessage(message: L13Message) throws {
//        // Check if message is already being presented
//        if presentedMessage != nil {
//            // If Message is presented place in queue
//            L13MessageManager._messages.enqueue(message)
//        } else {
//            // Let the message know it is getting ready to be displayed
//            message.willLoad()
//            message.didLoad()
//            message.willShow()
//            // else show
//            message.fire(L13PresentationManager())
//            // Once a message is displayed place in presentedMesssge var
//            L13MessageManager._presentedMessage = message
//            if let autoDismiss = message as? AutoDismissable {
//                if let time = autoDismiss.dismissAfter {
//                    L13MessageManager.delay(time.rawValue) {
//                        if let msg = self.presentedMessage {
//                            if msg.identifier == message.identifier {
//                                message.willHide()
//                                message.dismiss(L13PresentationManager())
//                                L13MessageManager._presentedMessage = nil
//                                message.didHide()
//                                self.validateSchedule()
//                            }
//                            
//                        }
//                    }
//                }
//            }
//            message.didShow()
//        }
//    }
//    
//    /**
//     Executes a postMessage after a specified amount of time
//     
//     Delay does not guarantee that the message will be posted at the specified time. There are several factors that go into consideration. One factor is largely determined by the looper. Another factor, which can greatly effect the delay, is if there are other scheduled messages.
//    */
//    public func postMessage(message: L13Message, withDelay delay: NSTimeInterval) throws {
//        L13MessageManager.delay(delay) {
//            do {
//                try self.postMessage(message)
//            } catch {
//
//            }
//        }
//    }
//    
//    public func dismissPresentedMessage() throws {
//        // Remove the message from presentedMessage only if the messages are the same
//        guard let presentedMessage = L13MessageManager._presentedMessage else {
//            throw L13MessageManagerError.NoPresentedMessage
//        }
//        
//        presentedMessage.willHide()
//        presentedMessage.dismiss(L13PresentationManager())
//        L13MessageManager._presentedMessage = nil
//        presentedMessage.didHide()
//        self.validateSchedule()
//    }
//    
//    public func cancelScheduledMessage(message: L13Message) throws {
//        L13MessageManager._messages.removeElement(message)
//    }
//    
//    func validateSchedule() -> Bool{
//        if scheduledMessages.count > 0 && L13MessageManager._presentedMessage == nil {
//            let message = L13MessageManager._messages.dequeue()
//            try! self.postMessage(message!)
//        }
//        return false
//    }
//    
//    func clear() {
//        L13MessageManager._presentedMessage = nil
//        L13MessageManager._messages.clear()
//    }

}

//extension L13Message: Firable, Dismissable {
//    
//    func fire(presenter: Presenter) {
//        self._shown = true
//        presenter.presentMessage(self)
//    }
//    
//    func dismiss(presenter: Presenter) {
//        presenter.dismissMessage(self)
//        self._shown = false
//    }
//}


/////////// Should be in CommonKit
extension L13MessageManager {
    
    static func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
}

extension NSTimeInterval {
    
    static var zero: Double {
        get {
            return 0.0
        }
    }
    
    static var standardDuration: Double {
        get {
            return 0.35
        }
    }
    
}

private class _Node<T> {
    let value: T?
    var nextNode: _Node<T>?
    
    private init() {
        self.value = nil
    }
    
    init(value: T) {
        self.value = value
    }
}

public class L13Queue<T: Equatable> {
    
    typealias Type = T
    
    private var head: _Node<Type>
    private var tail: _Node<Type>
    private var _count: Int = 0
    
    init() {
        self.tail = _Node<T>()
        self.head = self.tail
    }
    
    public var count: Int {
        get {
            return _count
        }
    }
    
    public var array: [T] {
        get {
            var items: [T] = []
            var currentNode = self.head
            while let item = currentNode.nextNode {
                if let val = item.value {
                    items.append(val)
                }
                currentNode = item
            }
            return items
        }
    }
    
    public func enqueue(element: T) {
        let newNode = _Node<T>(value: element)
        // Set the current tail's next node to new element
        self.tail.nextNode = newNode
        // Now set the tail to point at new element
        self.tail = self.tail.nextNode!
        self._count++
    }
    
    public func dequeue() -> T? {
        // Get the head's next node
        if let nextNode = self.head.nextNode {
            // If the head has a node return head
            self.head = nextNode
            // then set head's node to the head
            self._count--
            return nextNode.value
        } else {
            // If the head's node does not have a nextNode we are at the end of the queue return nil
            return nil
        }
    }
    
    /**
      Removes the matching element. Returns the removed element or nil if no matching element found
     */
    public func removeElement(element: T) -> T? {
        var currentNode = self.head
        while let nextNode = currentNode.nextNode {
            if let val = nextNode.value {
                if val == element {
                    // Replace the current node's next node with its next node
                    let newNode = nextNode.nextNode
                    currentNode.nextNode = newNode
                    // Return the value of the node we have removed
                    return val
                }
            }
            currentNode = nextNode
        }
        return nil
    }
    
    public func clear() {
        self.head.nextNode = nil
        self.tail = self.head
    }
    
    public func isEmpty() -> Bool {
        // Means that both pointers are the same memory address. If true list is empty
        return self.head === self.tail
    }
    
    private func swapNode(nodeToBeReplaced: _Node<T>, withNode newNode: _Node<T>) {
        // Since the next node matches the element we are looking for we need to swap nodes
        // The current node's next node needs swapped with the next node's next node
        // Confusing, right?
        
    }
    
}
