//
//  L13Message.swift
//  L13MessageKit
//
//  Created by Luke Davis on 12/4/15.
//  Copyright © 2015 Lucky 13 Technologies, LLC. All rights reserved.


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
    
    final func fire() {
        L13Message.window!.makeKeyAndVisible()
        showMessage()
    }
    
    final func dismiss() {
        hideMessage()
        L13Message.window!.hidden = true
        // Now make the original UIWindow key
        UIApplication.sharedApplication().delegate?.window!?.makeKeyWindow()
    }
    
    internal func showMessage() {
        fatalError("Must Implement showMessage()")
    }
    
    internal func hideMessage() {
        fatalError("Must Implement hideMessage()")
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
    
    override init() {
        super.init()
        self.container = UIApplication.sharedApplication().getRootView()
        self.view = self.createView()
        self.view.layer.cornerRadius = 10
        self.view.frame.origin.y += container!.bounds.height
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
        label.font = UIFont.systemFontOfSize(34)
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
    
    override final func showMessage() {
        willShowMessage()
        if container != nil && !self.isPresented {
            UIView.animateWithDuration(0.35, delay: 0.0, options: .CurveEaseOut, animations: {
                self.isPresented = true
                // Raise the frame up. But remember we need to account for the tab bar if it exists
                self.view.frame.origin.y -= (self.container!.frame.height + UIApplication.sharedApplication().bottomPadding)
                }) { complete in
                    if let dismissal = self.scheduledDismissal {
                        self.performSelector(Selector("dismiss"), withObject: nil, afterDelay: dismissal.rawValue)
                    }
            }
        }
    }
    
    @objc override final func hideMessage() {
        if container != nil && self.isPresented {
            UIView.animateWithDuration(0.35, delay: 0.0, options: .CurveEaseInOut, animations: {
                self.view.frame.origin.y += self.container!.frame.height
                self.isPresented = false
                }) { complete in
                    
            }
        }
        didHideMessage()
    }
    
    func willShowMessage() {
        fatalError("Must implement showTransientMessage()")
    }
    
    func didHideMessage() {
        fatalError("Must implement hideTransientMessage()")
    }
    
    deinit {
        self.view.removeFromSuperview()
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
    
    override func showMessage() {
//        super.showMessage()
        self.alertController = UIAlertController(title: super.title, message: super.message, preferredStyle: .Alert)
        addActions()
        L13Message.window!.rootViewController!.presentViewController(alertController!, animated: true, completion: nil)
    }
    
    override func hideMessage() {
//        super.hideMessage()
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
    
  
    
    
}

public class L13Hud: L13TransientMessage {
    
}

//public class L13MessageHudView: UIView {
//    
//    let label = UILabel()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        addSubview(label)
//        layer.cornerRadius = 15
//        backgroundColor = UIColor(white: 0.15, alpha: 0.85)
//        label.textColor = UIColor.whiteColor()
//        label.textAlignment = NSTextAlignment.Center
//        
//        label.text = " "
//    }
//    
//    override public func layoutSubviews() {
//        label.frame = CGRect(origin: CGPointZero, size: frame.size)
//        
//        //            CGRect(x: 0,
//        //            y: label.intrinsicContentSize().height,
//        //            width: frame.width,
//        //            height: label.intrinsicContentSize().height)
//    }
//    
//    public func show(msg: String) {
//        L13Thread.executeInMainQueue {
//            self.label.text = "\(msg)"
//            self.hidden = false
//        }
//    }
//    
//    required public init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//}
//
//public class L13ActivityHub: L13MessageHudView {
//    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
//    
//    public override init(frame: CGRect) {
//        super.init(frame: frame)
//        insertSubview(activityIndicator, aboveSubview: super.label)
//        
//        stopAnimating()
//    }
//    
//    required public init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//    
//    override public func layoutSubviews() {
//        activityIndicator.frame = CGRect(origin: CGPointZero, size: frame.size)
//        let labelOrgin = CGPointMake(CGPointZero.x, (CGPointZero.y + frame.height / 4))
//        label.frame = CGRect(origin: labelOrgin, size: frame.size)
//        //CGRect(x: 0,
//        //y: activityIndicator.frame.origin.y + activityIndicator.frame.height + label.intrinsicContentSize().height,
//        //            width: frame.width,
//        //            height: label.intrinsicContentSize().height)
//    }
//    
//    func show() {
//        super.show("Loading...".localized)
//    }
//    
//    public func updateProgress(value: Double) {
//        L13Thread.executeInMainQueue {
//            self.label.text = "Loading \(Int(value * 100))%"
//        }
//    }
//    
//    func startAnimating() {
//        activityIndicator.startAnimating()
//        
//        NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: "show", userInfo: nil, repeats: false)
//    }
//    
//    public func stopAnimating() {
//        hidden = true
//        activityIndicator.stopAnimating()
//    }
//    
//    
//}


public class L13Toast: L13Hud {
    
    private let toastHieght: CGFloat = 45
    private var toastTitle = UILabel(frame: CGRectZero)
    private var toastMessage = UILabel(frame: CGRectZero)
    
    /**
     * We still want the
     */
    public override init() {
        super.init()
        view.layer.cornerRadius = 0
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
    
    override func willShowMessage() {
        toastTitle.text = self.title
        self.toastMessage.text = self.message
    }
    
    override func didHideMessage() {
        
    }
    
    override func createView() -> UIView {
        let frame = container == nil ? CGRectZero : container!.frame
        let topFrameFromBottom = frame.height - toastHieght
        let view = UIView(frame: CGRectMake(0, topFrameFromBottom, frame.width, toastHieght))
        view.backgroundColor = UIColor.purpleColor()
        view.alpha = 0.8
        return view
    }
}

public class L13Banner: L13Toast {
    
    public override init() {
        super.init()
        view.layer.cornerRadius = 8
    }
    
    override func createView() -> UIView {
        let frame = container == nil ? CGRectZero : container!.frame
        let top: CGFloat = 20 + 20
        let view = UIView(frame: CGRectMake(8, top, frame.width - 16 , toastHieght))
        view.backgroundColor = UIColor.purpleColor()
        return view
    }
    
}

public class L13Modal: L13TransientMessage {
    
    
}

extension UIApplication {
    
    var rootViewController: UIViewController? {
        get {
            return UIApplication.sharedApplication().delegate?.window?!.rootViewController
        }
    }
    
    /**
     Calculates the height that should be adjusted based on if there is a nav bar or not
     return nav bar height if found; else 0
     */
    var topPadding: CGFloat {
        get {
            if let root = rootViewController as? UINavigationController {
                return root.navigationBar.bounds.height
            }
            return 0
        }
    }
    
    /**
     Calculates the height that should be adjusted based on if there is a tab bar or not
     return tab bar height if found; else 0
    */
    var bottomPadding: CGFloat {
        get {
            if let root = rootViewController as? UITabBarController {
                return root.tabBar.bounds.height
            }
            return 0
        }
    }
    
    func getRootView() -> UIView {
        if let rootController = rootViewController {
            let presentedController = self.getViewFromController(rootController)
            return presentedController.view
        }
        return UIView(frame: CGRectZero)
    }
    
    func getViewFromController(controller: UIViewController) -> UIViewController {
        if let navCon = controller as? UINavigationController {
            return getViewFromController(navCon.visibleViewController!)
        } else if let tabCon = controller as? UITabBarController {
            return getViewFromController(tabCon.selectedViewController!)
        } else if let modalController = controller.presentedViewController {
            return getViewFromController(modalController)
        } else {
            return controller
        }
    }
    
}
