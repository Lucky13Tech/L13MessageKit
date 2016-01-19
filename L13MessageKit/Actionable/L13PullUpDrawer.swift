//
//  L13PullUpDrawer.swift
//  L13MessageKit
//
//  Created by Luke Davis on 1/16/16.
//  Copyright © 2016 Lucky 13 Technologies, LLC. All rights reserved.
//

import UIKit

public protocol L13PullUpAction {

    func makePullable()
    
    func calculatedViewHeight() -> CGFloat
    
    func didOpen()
    
    func didClose()
    
}

extension L13PullUpAction where Self: UIView {
    
    public func makePullable() {
        // Get the starting height so we know the minimum height value
        
        var startingPoint = CGPointZero
        var currentPoint = CGPointZero
        let startingFrame = self.frame
        
        let panRecognizer = UIPanGestureRecognizer { [unowned self] (recognizer) -> Void in
            let gesture = recognizer as! UIPanGestureRecognizer
            let translate = gesture.translationInView(self)
            let maxHeight = self.calculatedViewHeight()
            switch gesture.state {
            case .Began:
                // Need to record current view point
                startingPoint = self.frame.origin
                // Since we are just beginning set the current point to the starting point
                currentPoint = startingPoint
                break
            case .Ended:
                let thresholdHeight = (maxHeight * 0.55)
                if self.frame.height == maxHeight  {
                    // Just allow the view to set
                } else if self.frame.height > thresholdHeight {
                    let calculcatedFrame = CGRectMake(self.frame.origin.x, (startingFrame.origin.y - self.calculatedViewHeight()), self.frame.width, self.calculatedViewHeight())
                    self.animateViewMovement(calculcatedFrame, withDuration: 0.35, withDampening: 0.39, withIntialVelocity: 35.0) {
                        completed in
                        self.didOpen()
                    }
                } else {
                    let calculcatedFrame = CGRectMake(self.frame.origin.x, startingFrame.origin.y - startingFrame.height, self.frame.width, startingFrame.height)
                    self.animateViewMovement(calculcatedFrame, withDuration: 0.35, withDampening: 0.43, withIntialVelocity: 40.0) {
                        completed in
                        self.didClose()
                    }
                }
                break
            case .Changed:
                var movedPoint = startingPoint
                movedPoint.x += translate.x
                movedPoint.y += translate.y
                var calculatedHeight = self.frame.height
                var calculatedY = self.frame.origin.y
                if (calculatedHeight - (movedPoint.y - currentPoint.y)) <= maxHeight && (calculatedHeight - (movedPoint.y - currentPoint.y)) > startingFrame.height {
                    // Moving up. Since we are moving in the negative we need to subtract
                    calculatedHeight -= movedPoint.y - currentPoint.y
                    calculatedY += movedPoint.y - currentPoint.y
                }
                let growFrame = CGRectMake(self.frame.origin.x, calculatedY, self.frame.width, calculatedHeight)
                self.animateViewMovement(growFrame, withDuration: 0.01, completion: nil)
                currentPoint = movedPoint
                break
            default:
                self.resetPullableView()
                break
            }
            
        }
        let tapRecognizer = UITapGestureRecognizer { [unowned self] (recognizer) -> Void in
            if self.frame.height == self.calculatedViewHeight()  {
                let calculcatedFrame = CGRectMake(self.frame.origin.x, startingFrame.origin.y - startingFrame.height, self.frame.width, startingFrame.height)
                self.animateViewMovement(calculcatedFrame, withDuration: 0.35, withDampening: 0.43, withIntialVelocity: 40.0) {
                    completed in
                    self.didClose()
                }
            } else {
                let calculcatedFrame = CGRectMake(self.frame.origin.x, (startingFrame.origin.y - self.calculatedViewHeight()), self.frame.width, self.calculatedViewHeight())
                self.animateViewMovement(calculcatedFrame, withDuration: 0.35, withDampening: 0.39, withIntialVelocity: 35.0) {
                    completed in
                    self.didOpen()
                }
            }
        }
        self.addGestureRecognizer(panRecognizer)
        self.addGestureRecognizer(tapRecognizer)
        // Add dragable view to top of view
        // Add gesture recognizer
        // If drag is up and less than intrinsigic height open view
        // If drag is down and is greater than starting height move down
        // else stop movement
    }
    
    func animateViewMovement(frame: CGRect, withDuration duration: NSTimeInterval = 0.35, withDampening dampen: CGFloat = 0.40, withIntialVelocity velocity: CGFloat = 35.0, completion: ((Bool) -> Void)?) {
        UIView.animateWithDuration(duration, delay: NSTimeInterval.zero, usingSpringWithDamping: dampen, initialSpringVelocity: velocity, options: UIViewAnimationOptions.CurveLinear, animations: {
            self.frame = frame
            }, completion: completion)
    }
    
    func resetPullableView() {
        
    }
    
    public func calculatedViewHeight() -> CGFloat {
        return 150.0
    }
    
//    func animateViewMovement(transform: CGAffineTransform) {
//        UIView.animateWithDuration(0.35, delay: NSTimeInterval.zero, usingSpringWithDamping: 6.0, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.CurveLinear, animations: {
//                self.transform = transform
//            }, completion: nil)
//    }
    
    public func open() {
//        UIView.animateWithDuration(0.35, delay: NSTimeInterval.zero, usingSpringWithDamping: 6.0, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.CurveLinear, animations: {
//                self.frame = CGRectMake(self.frame.origin.x, startingFrame.origin.y - startingFrame.height, self.frame.width, startingFrame.height)
//            }) { done in
//                self.didOpen()
//        }
    }
    
    public func didOpen() {
        return
    }
    
    public func close() {
//        UIView.animateWithDuration(0.35, delay: NSTimeInterval.zero, usingSpringWithDamping: 6.0, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.CurveLinear, animations: {
//            
//            }) { done in
//                self.didClose()
//        }
    }
    
    public func didClose() {
        return
    }
    
}
