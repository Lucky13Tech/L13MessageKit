//
//  L13Message.swift
//  L13MessageKit
//
//  Created by Luke Davis on 12/4/15.
//  Copyright © 2015 Lucky 13 Technologies, LLC. All rights reserved.


import UIKit

public protocol Message {
    
    var identifier: String { get }
    var isShown: Bool { get }
    var isDismissed: Bool { get }
    
}

public class L13Message: UIView, Message {
    
    var titleLabel = UILabel()
    var messageLabel = UILabel()
    
    public var title: String? {
        didSet {
            self.titleLabel.text = title
        }
    }
    public var message: String? {
        didSet {
            self.messageLabel.text = message
        }
    }
    
    internal var _identifier: String = NSUUID().UUIDString
    internal var _shown: Bool = false
    internal var _dismissed: Bool = false {
        didSet {
            self.onMessageDismissed()
        }
    }
    
    public var identifier: String {
        get {
            return _identifier
        }
    }
    
    public var isShown: Bool {
        get {
            return _shown
        }
    }
    
    public var isDismissed: Bool {
        get {
            return _dismissed
        }
    }
    
    public required init(title: String? = nil, message: String? = nil) {
        super.init(frame: UIApplication.sharedApplication().getRootView().frame)
        self.title = title
        self.message = message
        self.titleLabel.text = title
        self.messageLabel.text = message
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func willMoveToSuperview(newSuperview: UIView?) {
        print("Moving to view \(newSuperview)")
    }
    
    public override func didMoveToSuperview() {
        print("Moved to superView")
    }
    
    public override func removeFromSuperview() {
        _dismissed = true
        super.removeFromSuperview()
    }
    
}

public enum L13MessageDuration: NSTimeInterval {
    case Long = 4.0
    case Normal = 2.5
    case Short = 1.0
    case None = 0.0
}
