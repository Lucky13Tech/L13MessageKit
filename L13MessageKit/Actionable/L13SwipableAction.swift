//
//  L13SwipableAction.swift
//  L13MessageKit
//
//  Created by Luke Davis on 1/6/16.
//  Copyright © 2016 Lucky 13 Technologies, LLC. All rights reserved.
//

import UIKit

public protocol L13SwipableRightAction {
    
    func letSwipeRight()
    
    func didSwipeRight()
    
}

extension L13SwipableRightAction where Self: UIView {
    
    public func letSwipeRight() {
        
        let swipeGestureRecognizer = UISwipeGestureRecognizer { [unowned self] (recognizer) -> Void in
//            let gesture = recognizer as! UISwipeGestureRecognizer
            self.didSwipeRight()
        }
        swipeGestureRecognizer.direction = .Right
        self.addGestureRecognizer(swipeGestureRecognizer)
    }
    
    public func didSwipeRight() {
        print("Did Swipe Right")
        return
    }
}
