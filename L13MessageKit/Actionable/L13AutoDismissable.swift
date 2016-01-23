//
//  L13AutoDismissable.swift
//  L13MessageKit
//
//  Created by Luke Davis on 1/20/16.
//  Copyright © 2016 Lucky 13 Technologies, LLC. All rights reserved.
//

import UIKit

public protocol L13AutoDismissable {
    
    func makeAutoDismissable(dismissIn duration: NSTimeInterval)
    
}

extension L13AutoDismissable where Self: UIView {
    
    public func makeAutoDismissable(dismissIn duration: NSTimeInterval) {
        L13MessageManager.delay(duration) {
            self.removeFromSuperview()
        }
    }
    
}
