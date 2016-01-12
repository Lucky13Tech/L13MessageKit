//
//  L13SlideAnimationPresentation.swift
//  L13MessageKit
//
//  Created by Luke Davis on 1/5/16.
//  Copyright © 2016 Lucky 13 Technologies, LLC. All rights reserved.
//

import UIKit

// Add slide down, slide left, slide right

public protocol SlidePresentationAnimation {
    
    func prepareForSlideAnimation(parent: UIView)
    
    func animateSlidePresentation()
}

public protocol SlideDismissalAnimation {
    
    func prepareForSlideDismissalAnimation()
    
    func animateSlideDismissal(handler: () -> ())
    
}

public protocol SlideUpPresentationAnimation: SlidePresentationAnimation {
    
}

extension SlideUpPresentationAnimation where Self: UIView {
    
    public func prepareForSlideAnimation(parent: UIView) {
        self.frame.origin.y += parent.frame.height
    }
    
    public func animateSlidePresentation() {
        if let supaView = superview {
            UIView.animateWithDuration(0.35, delay: 0.0, options: .CurveEaseOut, animations: {
                // Raise the frame up. But remember we need to account for the tab bar if it exists
                self.frame.origin.y -= (supaView.frame.height + UIApplication.sharedApplication().bottomPadding)
                }) { complete in
            }
        }
    }
}

public protocol SlideDownDismissalAnimation: SlideDismissalAnimation {
    
}

extension SlideDownDismissalAnimation where Self: UIView {
    
    public func prepareForSlideDismissalAnimation() {
        
    }
    
    public func animateSlideDismissal(handler: () -> ()) {
        UIView.animateWithDuration(NSTimeInterval.standardDuration, delay: NSTimeInterval.zero, options: .CurveEaseInOut, animations: { self.frame.origin.y += (self.superview!.frame.height + UIApplication.sharedApplication().bottomPadding) }, completion: { done in
            handler()
        })
    }
}
