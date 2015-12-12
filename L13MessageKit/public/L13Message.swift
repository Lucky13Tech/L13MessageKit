//
//  L13Message.swift
//  L13MessageKit
//
//  Created by Luke Davis on 12/4/15.
//  Copyright © 2015 Lucky 13 Technologies, LLC. All rights reserved.
//

import UIKit

public protocol Identifiable: NSObjectProtocol {
    
    var identifier: String { get }
    
}

public class L13Message: NSObject, Identifiable, Firable, Dismissable  {
    
    static var window: UIWindow?
    
    internal var _identifier: String!
    internal var _shown: Bool = false
    internal var _seen: Bool = false
    
    public var title: String?
    public var message: String?
    
    public var isSeen: Bool {
        return _seen
    }
    
    public var identifier: String {
        get {
            return _identifier
        }
    }
    
    public override init() {
        // Get view Controller
        L13Message.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        L13Message.window!.windowLevel = UIWindowLevelAlert + 1
        L13Message.window!.rootViewController = UIViewController(nibName: nil, bundle: nil)
    }
    
    func fire() {
        L13Message.window!.makeKeyAndVisible()
    }
    
    func dismiss() {
        L13Message.window!.hidden = true
        // Now make the original UIWindow key
        UIApplication.sharedApplication().delegate?.window!?.makeKeyWindow()
    }
    
}

public class L13ScheduleMessage: L13Message, Schedulable, Cancelable {
    
    internal var scheduledFireDate: NSDate? {
        didSet {
            // Set scheduled selector
        }
    }
    
    public var fireDate: NSDate? {
        set (fireOn) {
            scheduledFireDate = fireDate
        }
        get {
            return scheduledFireDate
        }
    }
    
    public func cancel() {
        
    }
    
}

public class L13ActionMessage: L13ScheduleMessage, Actionable {
    
    public typealias L13CompletionHandler = () -> ()
    public typealias L13MessageAction = (title: String, handler: (L13CompletionHandler) -> ())
    
    public var actions: [L13MessageAction]? = []
    
}

public class L13NotificationMessage: L13ActionMessage {
    
}

public class L13AlertMessage: L13ActionMessage {
    
    internal var alertController: UIAlertController?
    
    override func fire() {
        super.fire()
        self.alertController = UIAlertController(title: super.title, message: super.message, preferredStyle: .Alert)
        addActions()
        L13Message.window!.rootViewController!.presentViewController(alertController!, animated: true, completion: nil)
    }
    
    override func dismiss() {
        super.dismiss()
    }
    
    private func addActions() {
        if actions != nil && actions?.count > 0 {
            for a: L13MessageAction in actions! {
                self.alertController?.addAction(UIAlertAction(title: a.title, style: .Default) { action in a.handler( { self.dismiss() } ) })
            }
        } else {
            // Default action
            self.alertController?.addAction(UIAlertAction(title: "OK", style: .Default) { action in
                self.dismiss()
                } )
        }
    }
    
}

public class L13ActionModal: L13ActionMessage {
    
}

public class L13ActionBanner: L13ActionModal {
    
    public override func fire() {
        
    }
    
    
    
}

public enum L13TransientMessageDuration: NSTimeInterval {
    case Long = 4.0
    case Normal = 2.5
    case Short = 1.0
    case None = 0.0
}

public class L13TransientMessage: L13ScheduleMessage, AutoDismissable, Configurable {
    
    var view: UIView!
    var container: UIView?
    internal var isPresented: Bool = false
    
    let defaultGutterSize: CGFloat = 35
    let defaultHorizontalMargin: CGFloat = 60
    
    internal var scheduledDismissal: L13TransientMessageDuration?
    
    public override init() {
        super.init()
        self.container = UIApplication.sharedApplication().delegate?.window?!.rootViewController?.view
        self.view = self.createView()
//        self.view.layer.cornerRadius = 10
        self.view.frame.origin.y += container!.frame.height
        self.container?.addSubview(self.view)
    }
    
    public var dismissAfter: L13TransientMessageDuration? {
        get {
            return scheduledDismissal
        }
        set(schedule) {
            scheduledDismissal = schedule
        }
    }
    
    func createView() -> UIView {
        let frame = getViewSize()
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.grayColor()
        let label = UILabel(frame: CGRectMake(0, 20, view.frame.width, 35))
        label.font = UIFont(name: "San Fransisco", size: 34)
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        label.text = "Lucky 13 Technologies, LLC."
        view.addSubview(label)
        return view
    }
    
    func getViewSize() -> CGRect {
        var frame = CGRectZero
        if let _container = container {
            // Get container frame
            frame = CGRectInset(_container.frame, defaultGutterSize, defaultGutterSize)
            // Calculate size of margin
        }
        return frame
    }
    
    override func fire() {
        if container != nil && !self.isPresented {
            UIView.animateWithDuration(0.35, delay: 0.0, options: .CurveEaseOut, animations: {
                self.isPresented = true
                self.view.frame.origin.y -= self.container!.frame.height
                }) { complete in
                    if let dismissal = self.scheduledDismissal {
                        self.performSelector(Selector("dismiss"), withObject: nil, afterDelay: dismissal.rawValue)
                    }
            }
        }
    }
    
    @objc override func dismiss() {
        if container != nil && self.isPresented {
            UIView.animateWithDuration(0.35, delay: 0.0, options: .CurveEaseInOut, animations: {
                self.view.frame.origin.y += self.container!.frame.height
                self.isPresented = false
                }) { complete in

            }
        }
    }
    
    deinit {
        self.view.removeFromSuperview()
    }
    
}

public class L13Hud: L13TransientMessage {
    
}

public class L13Toast: L13Hud {
    
}

public class L13BannerToast: L13Toast {
    
    private let toastHieght: CGFloat = 45
    private var toastTitle = UILabel(frame: CGRectZero)
    private var toastMessage = UILabel(frame: CGRectZero)
    
    public override init() {
        super.init()
        let mainLayout = UIStackView(frame: CGRectMake(8, 8, view.frame.width - 16, view.frame.height - 16))
        mainLayout.axis = .Vertical
        mainLayout.distribution = .Fill
        mainLayout.alignment = .FirstBaseline
        view.addSubview(mainLayout)
        self.toastTitle.frame = CGRectMake(0, 0, view.frame.width, 0)
        toastTitle.font = UIFont.systemFontOfSize(8)
        toastTitle.textColor = UIColor.whiteColor()
        toastTitle.setContentHuggingPriority(301, forAxis: .Vertical)
        mainLayout.addArrangedSubview(self.toastTitle)
        self.toastMessage.frame = CGRectMake(0, 0, view.frame.width, 0)
        toastMessage.font = UIFont.systemFontOfSize(18)
        toastMessage.textColor = UIColor.whiteColor()
        toastMessage.setContentHuggingPriority(300, forAxis: .Vertical)
        mainLayout.addArrangedSubview(self.toastMessage)
    }
    
    override func fire() {
        toastTitle.text = self.title
        self.toastMessage.text = self.message
        super.fire()
    }
    
    override func createView() -> UIView {
        let frame = container == nil ? CGRectZero : container!.frame
        let topFrameFromBottom = frame.height - toastHieght
        let view = UIView(frame: CGRectMake(0, topFrameFromBottom, frame.width, toastHieght))
        view.backgroundColor = UIColor.purpleColor()
        return view
    }
    
}

public class L13Modal: L13TransientMessage {
    
    
}

public class L13Banner: L13Modal {
    
}
