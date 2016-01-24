//
//  L13AlertMessage.swift
//  L13MessageKit
//
//  Created by Luke Davis on 1/5/16.
//  Copyright © 2016 Lucky 13 Technologies, LLC. All rights reserved.
//

import UIKit

public class L13AlertMessage: UIAlertController, Message, DisruptivePresentation {
    
    public var identifier: String {
        get {
            return "\(self.view.tag)"
        }
    }
    
    public var isShown: Bool {
        get {
            return self.presentingViewController != nil
        }
    }
    
    public var isDismissed: Bool {
        get {
            return !self.isShown
        }
    }
    
}
