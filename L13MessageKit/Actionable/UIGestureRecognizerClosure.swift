
//
//  UIGestureRecognizerClosure.swift
//
//  Adds closures to gesture setup. Just an example of using an extension.
//
//  Usage:
//
//  self.view.addGestureRecognizer(UITapGestureRecognizer(){
//      print("UITapGestureRecognizer")
//  })
//
//  let longpressGesture = UILongPressGestureRecognizer() {
//    print("UILongPressGestureRecognizer")
//  }
//  self.view.addGestureRecognizer(longpressGesture)
//
//  Michael L. Collard
//  collard@uakron.edu

import UIKit

//
//  Associator.swift
//  STP
//
//  Created by Chris O'Neil on 10/11/15.
//  Copyright © 2015 Because. All rights reserved.
//

import ObjectiveC

private final class Wrapper<T> {
    let value: T
    init(_ x: T) {
        value = x
    }
}

class Associator {
    
    static private func wrap<T>(x: T) -> Wrapper<T>  {
        return Wrapper(x)
    }
    
    static func setAssociatedObject<T>(object: AnyObject, value: T, associativeKey: UnsafePointer<Void>, policy: objc_AssociationPolicy) {
        if let v: AnyObject = value as? AnyObject {
            objc_setAssociatedObject(object, associativeKey, v,  policy)
        }
        else {
            objc_setAssociatedObject(object, associativeKey, wrap(value),  policy)
        }
    }
    
    static func getAssociatedObject<T>(object: AnyObject, associativeKey: UnsafePointer<Void>) -> T? {
        if let v = objc_getAssociatedObject(object, associativeKey) as? T {
            return v
        }
        else if let v = objc_getAssociatedObject(object, associativeKey) as? Wrapper<T> {
            return v.value
        }
        else {
            return nil
        }
    }
}


private class MultiDelegate : NSObject, UIGestureRecognizerDelegate {
    @objc func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension UIGestureRecognizer {
    
    struct PropertyKeys {
        static var blockKey = "BCBlockPropertyKey"
        static var multiDelegateKey = "BCMultiDelegateKey"
    }
    
    private var block:((recognizer:UIGestureRecognizer) -> Void) {
        get {
            return Associator.getAssociatedObject(self, associativeKey:&PropertyKeys.blockKey)!
        }
        set {
            Associator.setAssociatedObject(self, value: newValue, associativeKey:&PropertyKeys.blockKey, policy: .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    private var multiDelegate:MultiDelegate {
        get {
            return Associator.getAssociatedObject(self, associativeKey:&PropertyKeys.multiDelegateKey)!
        }
        set {
            Associator.setAssociatedObject(self, value: newValue, associativeKey:&PropertyKeys.multiDelegateKey, policy: .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    convenience init(block:(recognizer:UIGestureRecognizer) -> Void) {
        self.init()
        self.block = block
        self.multiDelegate = MultiDelegate()
        self.delegate = self.multiDelegate
        self.addTarget(self, action: "didInteractWithGestureRecognizer:")
    }
    
    @objc func didInteractWithGestureRecognizer(sender:UIGestureRecognizer) {
        self.block(recognizer: sender)
    }
}


// Global array of targets, as extensions cannot have non-computed properties
//private var target = [Target]()
//
//extension UIGestureRecognizer {
//    
//    convenience init(trailingClosure closure: (() -> ())) {
//        // let UIGestureRecognizer do its thing
//        self.init()
//        
//        target.append(Target(closure))
//        self.addTarget(target.last!, action: "invoke")
//    }
//}
//
//private class Target {
//    
//    // store closure
//    private var trailingClosure: (() -> ())
//    
//    init(_ closure:(() -> ())) {
//        trailingClosure = closure
//    }
//    
//    // function that gesture calls, which then
//    // calls closure
//    /* Note: Note sure why @IBAction is needed here */
//    @IBAction func invoke() {
//        trailingClosure()
//    }
//}