//
//  L13View.swift
//  L13MessageKit
//
//  Created by Luke Davis on 12/16/15.
//  Copyright © 2015 Lucky 13 Technologies, LLC. All rights reserved.
//

import UIKit

/**
 # L13View
 A subclass which can be used for animation purposes
*/
class L13View: UIView, L13Animatable {
    
    var parentView: UIView = UIView(frame: CGRectZero)
    var startingPoint: CGPoint = CGPointZero
    var endingPoint: CGPoint = CGPointZero
    var startingSize: CGRect = CGRectZero
    var endingSize: CGRect = CGRectZero

}
