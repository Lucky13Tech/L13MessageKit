//
//  L13MessageType.swift
//  L13MessageKit
//
//  Created by Luke Davis on 12/4/15.
//  Copyright © 2015 Lucky 13 Technologies, LLC. All rights reserved.
//

import Foundation
import UIKit

/*!
*   An object that can be fired shall implement the following protocol
*/
protocol Firable: NSObjectProtocol {
    
    /*!
    *   Triggers the object to fire the object
    */
    func fire(presenter: Presenter)
    
}

protocol Cancelable: NSObjectProtocol {
    
    func cancel()
    
}

protocol Dismissable: NSObjectProtocol {
    
    func dismiss(presenter: Presenter)
    
}

protocol Schedulable: NSObjectProtocol {
    
    var fireDate: NSDate? {
        get set
    }
}

protocol Actionable: NSObjectProtocol {
    
    
}

protocol Presentable: NSObjectProtocol {
    
}

protocol ViewPresentable: Presentable {
    
    var view: UIView { get }
    
}

protocol ViewControllerPresentable: Presentable {
    
    var viewController: UIViewController { get }
    
}

protocol AutoDismissable: Dismissable {
    
    var dismissAfter: L13TransientMessageDuration? {
        get set
    }
    
}

protocol Configurable: NSObjectProtocol {
    
    
}


