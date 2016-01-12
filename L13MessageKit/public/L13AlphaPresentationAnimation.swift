//
//  File.swift
//  L13MessageKit
//
//  Created by Luke Davis on 12/15/15.
//  Copyright © 2015 Lucky 13 Technologies, LLC. All rights reserved.
//

import UIKit

public protocol PresentationAnimation {
    
    func prepareForPresentationAnimation(parent: UIView)
    
    func animatePresentation()
    
}

public protocol DismissalAnimation {
    
    func prepareForDismissalAnimation()
    
    func animateDismissal(handler: () -> ())
    
}

public protocol AlphaPresentationAnimation: PresentationAnimation {
    
}

extension AlphaPresentationAnimation where Self: UIView {
    
    public func prepareForPresentationAnimation(parent: UIView) {
        self.alpha = 0.0
    }
    
    public func animatePresentation() {
        UIView.animateWithDuration(0.35, delay: NSTimeInterval.zero, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.alpha = 1.0
            }, completion: nil)
    }
    
}

public protocol AlphaDismissalAnimation: DismissalAnimation {
    
}

extension AlphaDismissalAnimation where Self: UIView {
    
    public func prepareForDismissalAnimation() {
        
    }
    
    public func animateDismissal(handler: () -> ()) {
        UIView.animateWithDuration(0.35, delay: NSTimeInterval.zero, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.alpha = 0.0
            }, completion: { done in
                handler()
        })
    }
    
}
