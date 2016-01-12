//
//  L13MoveableAction.swift
//  L13MessageKit
//
//  Created by Luke Davis on 1/7/16.
//  Copyright © 2016 Lucky 13 Technologies, LLC. All rights reserved.
//

import UIKit

public enum L13MovementDirection {
    case Left
    case Up
    case Right
    case Down
}

public protocol L13MovableAction {
    
    func didStartMoving()
    
    func didStopMoving(originalPoint: CGPoint, endingPoint: CGPoint, endVelocity: CGPoint)
}

extension L13MovableAction where Self: UIView {
    
    public func resetView() {
        self.animateMovement(CGAffineTransformMakeTranslation(0, 0))
    }
    
}

public protocol L13DragableAction: L13MovableAction {
    
    func makeMovable()
    
}

extension L13MovableAction where Self: UIView {
    
    public func makeMovable() {
        
        var startingPoint = CGPointZero
        var currentPoint = CGPointZero
        
        let panRecognizer = UIPanGestureRecognizer { [unowned self] (recognizer) -> Void in
            let gesture = recognizer as! UIPanGestureRecognizer
            let velocity = gesture.velocityInView(self)
            let translate = gesture.translationInView(self)
            switch gesture.state {
            case .Began:
                print("startpoint: \(self.center) frame = \(self.frame)")
                // Need to record current view point
                startingPoint = self.center
                // Since we are just beginning set the current point to the starting point
                currentPoint = startingPoint
                self.didStartMoving()
                break
            case .Ended:
                // Need to call the didStopMoving method
                self.didStopMoving(startingPoint, endingPoint: currentPoint, endVelocity: velocity)
                break
            case .Changed:
                var movedPoint = startingPoint
                movedPoint.x += translate.x
                movedPoint.y += translate.y
                let transform = CGAffineTransformTranslate(self.transform, movedPoint.x - currentPoint.x , movedPoint.y - currentPoint.y)
                self.animateMovement(transform)
                currentPoint = movedPoint
                break
            default:
                self.resetView()
                break
            }
            
        }
        self.addGestureRecognizer(panRecognizer)
    }
    
    func animateMovement(transform: CGAffineTransform) {
        UIView.animateWithDuration(0.001) {
            self.transform = transform
        }
    }
}

public protocol L13SwipeToDismissAction: L13MovableAction {
    
    func letSwipeToDismiss(swipeDirection: L13MovementDirection, flingThreshold: CGFloat)
    
    func didDismissWithFling()
    
}

extension L13SwipeToDismissAction where Self:UIView {
    
    public func letSwipeToDismiss(swipeDirection: L13MovementDirection = .Right, flingThreshold: CGFloat = 125.0) {
        
        var startingPoint = CGPointZero
        var currentPoint = CGPointZero
        
        let panRecognizer = UIPanGestureRecognizer { [unowned self] (recognizer) -> Void in
            let gesture = recognizer as! UIPanGestureRecognizer
            let velocity = gesture.velocityInView(self)
            let translate = gesture.translationInView(self)
            switch gesture.state {
            case .Began:
                // Need to record current view point
                startingPoint = self.center
                // Since we are just beginning set the current point to the starting point
                currentPoint = startingPoint
                self.didStartMoving()
                break
            case .Ended:
                // Determine if the current state is considered a fling
                if self.canDismiss(swipeDirection, currentVelocity: velocity, threshold: flingThreshold) {
                    self.didDismissWithFling()
                }
                // Need to call the didStopMoving method
                self.didStopMoving(startingPoint, endingPoint: currentPoint, endVelocity: velocity)
                break
            case .Changed:
                let movedPoint = self.calculateMovePoint(translate, startPoint: startingPoint, swipeDirection: swipeDirection)
                let transform = CGAffineTransformTranslate(self.transform, movedPoint.x - currentPoint.x , movedPoint.y - currentPoint.y)
                self.animateMovement(transform)
                currentPoint = movedPoint
                break
            default:
                self.resetView()
                break
            }
            
        }
        self.addGestureRecognizer(panRecognizer)
    }
    
    public func didStartMoving() {
        
    }
    
    public func didStopMoving(originalPoint: CGPoint, endingPoint: CGPoint, endVelocity: CGPoint) {
        return
    }
    
    public func didDismissWithFling() {
        return
    }
    
    func canDismiss(direction: L13MovementDirection, currentVelocity: CGPoint, threshold: CGFloat) -> Bool {
        var transform: CGAffineTransform
        var viewFrame: CGRect
        if self.superview != nil {
            viewFrame = self.superview!.frame
        } else {
            viewFrame = UIScreen.mainScreen().bounds
        }
        switch direction {
        case .Right:
            if currentVelocity.x > threshold {
                transform = CGAffineTransformMakeTranslation(viewFrame.width, 0)
                self.animateMovement(transform)
                self.removeFromSuperview()
                return true
            }
            break
        case .Left:
            if currentVelocity.x < threshold {
                transform = CGAffineTransformMakeTranslation(-(viewFrame.width), 0)
                self.animateMovement(transform)
                self.removeFromSuperview()
                return true
            }
            break
        case .Up:
            if currentVelocity.y < threshold {
                transform = CGAffineTransformMakeTranslation(0, -(viewFrame.height))
                self.animateMovement(transform)
                self.removeFromSuperview()
                return true
            }
            break
        case .Down:
            if currentVelocity.y > threshold {
                transform = CGAffineTransformMakeTranslation(0, viewFrame.height)
                self.animateMovement(transform)
                self.removeFromSuperview()
                return true
            }
            break
        }
        self.resetView()
        return false
    }
    
    func calculateMovePoint(translation: CGPoint, startPoint: CGPoint, swipeDirection: L13MovementDirection) -> CGPoint {
        var movePoint = startPoint
        switch swipeDirection {
        case .Right:
            if translation.x + startPoint.x > startPoint.x {
                movePoint.x += translation.x
            }
            break
        case .Left:
            if translation.x + startPoint.x < startPoint.x {
                movePoint.x += translation.x
            }
            break
        case .Up:
            if translation.y + startPoint.y < startPoint.y {
                movePoint.y += translation.y
            }
            break
        case .Down:
            if translation.y + startPoint.y > startPoint.y {
                movePoint.y += translation.y
            }
            break
        }
        return movePoint
    }
    
    
}
