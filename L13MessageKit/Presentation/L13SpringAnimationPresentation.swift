//
//  L13SpringAnimationPresentation.swift
//  L13MessageKit
//
//  Created by Luke Davis on 1/5/16.
//  Copyright © 2016 Lucky 13 Technologies, LLC. All rights reserved.
//

import UIKit

public protocol L13SpringPresentationAnimation {
    
    func prepareForSpringAnimation()
    
    func animateSpringPresentation()
    
}

extension L13SpringPresentationAnimation where Self: UIView {
    
    public func prepareForSpringAnimation() {
        self.transform = CGAffineTransformMakeScale(0.1, 0.1)
        return
    }
    
    public func animateSpringPresentation() {
        UIView.animateWithDuration(0.35, delay: NSTimeInterval.zero, usingSpringWithDamping: 0.23, initialSpringVelocity: 5.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.transform = CGAffineTransformIdentity
            }, completion: nil)
    }
    
}

public protocol L13SpringReleasePresentationAnimation {
    
    func prepareForSpringReleaseAnimation()
    
    func animateSpringDismissal()
    
}

extension L13SpringReleasePresentationAnimation where Self: UIView {
    
    public func prepareForSpringReleaseAnimation() {
        return
    }
    
    public func animateSpringDismissal() {
        UIView.animateWithDuration(0.35, delay: NSTimeInterval.zero, usingSpringWithDamping: 0.23, initialSpringVelocity: 5.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.transform = CGAffineTransformMakeScale(0.1, 0.1)
            }, completion: nil)
    }
    
}