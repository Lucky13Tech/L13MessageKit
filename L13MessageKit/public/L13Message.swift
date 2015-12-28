//
//  L13Message.swift
//  L13MessageKit
//
//  Created by Luke Davis on 12/4/15.
//  Copyright © 2015 Lucky 13 Technologies, LLC. All rights reserved.


import UIKit

/**
 1. Create view on init
 2. On post set labels and other last minute resources
 3. Add to container view
*/
public protocol Identifiable: NSObjectProtocol {
    
    var identifier: String { get }
    
}

public class MessageViewConfigure {
    
    // Message configuration
    var messageViewColor: UIColor? = UIColor(colorLiteralRed: 0.8, green: 0.8, blue: 0.8, alpha: 0.8)
    var messageViewCornerRadius: CGFloat = 0.0
    var messageAlpha: CGFloat = 1.0
    var messageHorizontalMargin: CGFloat = 0.0
    var messageVerticalMargin: CGFloat = 0.0
    
    // Text configuration
    var titleColor: UIColor? = UIColor(white: 1.0, alpha: 0.85)
    var titleFont: UIFont = UIFont.systemFontOfSize(34.0)
    var subtitleColor: UIColor? = UIColor(white: 1.0, alpha: 0.85)
    var subtitleFont: UIFont = UIFont.systemFontOfSize(18.0)
    
    // Underlying view configuration
    var backgroundViewColor: UIColor? = UIColor(white: 0.0, alpha: 0.35)
    
}

/**
 Steps to build Message view
   1. Init views and configurations
   2. 
*/
public class L13Message: NSObject, Identifiable, Presentable, Configurable  {
    
    internal var _identifier: String = NSUUID().UUIDString
    internal var _shown: Bool = false
    
    internal var view: L13View = L13View(frame: CGRectZero)
    internal var presentationAnimation: L13PresentationType = .Normal
    internal var dismissalAnimation: L13PresentationType = .Normal
    public var viewConfiguration = MessageViewConfigure()
    
    public var title: String?
    public var message: String?
    
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
    
    override init() {
        super.init()
//        // Initialize views
//        self.willLoad()
//        // Get view Controller
//        // Let views be configured
//        self.didLoad()
    }
    
    internal func willLoad() {
        
    }
    
    internal func didLoad() {
        // View intialization
    }
    
    internal func willShow() {
        // Update any fields that may have been changed between init and posting
    }
    
    internal func didShow() {
        
    }
    
    internal func willHide() {
        
    }
    
    internal func didHide() {
        
    }
    
}

//extension Presentable where Self: Configurable {
//    
//    var messageView: L13View {
//        get {
//            return L13View()
//        }
//    }
//    
//}

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
    
    override init() {
        super.init()
    }
    
    public func cancel() {
        
    }
    
}

public class L13DisruptiveMessage: L13Message {
    
    var viewController: UIViewController
    
    override init() {
        viewController = UIViewController(nibName: nil, bundle: nil)
        super.init()
    }
    
}

public enum L13TransientMessageDuration: NSTimeInterval {
    case Long = 4.0
    case Normal = 2.5
    case Short = 1.0
    case None = 0.0
}

public class L13TransientMessage: L13ScheduleMessage, AutoDismissable {
    
    var container: UIView?
    
    var titleLabel: UILabel!
    
    internal var scheduledDismissal: L13TransientMessageDuration?
    public override var title: String? {
        didSet {
            
        }
    }
        
    public override init() {
        super.init()
        // Set defaults for configuration. Later the message view will be built in a different class
        self.viewConfiguration.titleFont = UIFont.systemFontOfSize(34)
        self.viewConfiguration.titleColor = UIColor.whiteColor()
        self.viewConfiguration.messageViewCornerRadius = 10
        self.viewConfiguration.messageHorizontalMargin = 20
        self.viewConfiguration.messageVerticalMargin = 20
        self.viewConfiguration.messageViewColor = UIColor.grayColor()
        self.presentationAnimation = .Normal
        self.dismissalAnimation = .Normal
    }
    
    override final func willLoad() {
        self.container = UIApplication.sharedApplication().getRootView()
        self.view = self.createBaseView()
        self.view.parentView = container!
    }
    
    override func didLoad() {
        view.backgroundColor = self.viewConfiguration.messageViewColor
        self.titleLabel = UILabel(frame: CGRectMake(8, 20, view.frame.width, 35))
        self.titleLabel.font = self.viewConfiguration.titleFont
        self.titleLabel.textColor = self.viewConfiguration.titleColor
        self.titleLabel.textAlignment = .Center
        view.addSubview(self.titleLabel)
        view.layer.cornerRadius = self.viewConfiguration.messageViewCornerRadius
    }
    
    func createBaseView() -> L13View {
        var frame = CGRectZero
        if let _container = self.container {
            // Get container frame
            frame = _container.frame
            // Calculate size of margin
        }
        return L13View(frame: frame)
    }
    
    override func willShow() {
        super.willShow()
        self.titleLabel.text = self.title
    }
    
    override func didHide() {
        self.view.removeFromSuperview()
    }
    
    public var dismissAfter: L13TransientMessageDuration? {
        get {
            return scheduledDismissal
        }
        set(schedule) {
            scheduledDismissal = schedule
        }
    }
    
    deinit {
    }
    
}

public class L13ActionMessage: L13ScheduleMessage, Actionable {
    
    public typealias L13CompletionHandler = () -> ()
    public typealias L13MessageAction = (title: String, handler: (L13CompletionHandler) -> ())
    
    public var actions: [L13MessageAction]? = []
    
}

public class L13NotificationMessage: L13ActionMessage {
    
}

//public class L13AlertMessage: L13ActionMessage {
//    
//    internal var alertController: UIAlertController?
//    
//    override func showMessage() {
////        super.showMessage()
//        self.alertController = UIAlertController(title: super.title, message: super.message, preferredStyle: .Alert)
//        addActions()
//        L13Message.window!.rootViewController!.presentViewController(alertController!, animated: true, completion: nil)
//    }
//    
//    override func hideMessage() {
////        super.hideMessage()
//    }
//    
//    private func addActions() {
//        if actions != nil && actions?.count > 0 {
//            for a: L13MessageAction in actions! {
//                self.alertController?.addAction(UIAlertAction(title: a.title, style: .Default) { action in a.handler( { self.dismiss() } ) })
//            }
//        } else {
//            // Default action
//            self.alertController?.addAction(UIAlertAction(title: "OK", style: .Default) { action in
//                self.dismiss()
//                } )
//        }
//    }
//    
//}

public class L13ActionModal: L13ActionMessage {
    
}

public class L13ActionBanner: L13ActionModal {
    
  
    
    
}

public class L13Hud: L13DisruptiveMessage {
    
    override init() {
        super.init()
    }
    
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


public class L13Toast: L13TransientMessage {
    
    private let toastHieght: CGFloat = 45
    private let textPadding: CGFloat = 16
//    private var toastTitle = UILabel(frame: CGRectZero)
    private var toastMessage = UILabel(frame: CGRectZero)
    
    /**
     * We still want the
     */
    public override init() {
        super.init()
        // Set defaults for configuration
        self.viewConfiguration.titleFont = UIFont.systemFontOfSize(8)
        self.viewConfiguration.titleColor = UIColor.whiteColor()
        self.viewConfiguration.subtitleFont = UIFont.systemFontOfSize(18)
        self.viewConfiguration.subtitleColor = UIColor.whiteColor()
        self.viewConfiguration.messageAlpha = 0.8
        self.viewConfiguration.messageViewCornerRadius = 0
        self.viewConfiguration.messageHorizontalMargin = 0
        self.viewConfiguration.messageVerticalMargin = 0
        self.viewConfiguration.messageViewColor = UIColor.purpleColor()
    }
    
    override func didLoad() {
        let frame = container == nil ? CGRectZero : container!.frame
        let top: CGFloat = frame.height - UIApplication.sharedApplication().bottomPadding - toastHieght
        view.frame = CGRectMake(0, top, frame.width, toastHieght)
        view.backgroundColor = self.viewConfiguration.messageViewColor
        view.alpha = self.viewConfiguration.messageAlpha
        view.layer.cornerRadius = self.viewConfiguration.messageViewCornerRadius
        let mainLayout = UIStackView(frame: CGRectMake(8, 8, view.frame.width - self.textPadding, view.frame.height - self.textPadding))
        mainLayout.axis = .Vertical
        mainLayout.distribution = .Fill
        mainLayout.alignment = .FirstBaseline
        view.addSubview(mainLayout)
        //        self.toastTitle.frame = CGRectMake(0, 0, view.frame.width, 0)
        //        toastTitle.font = self.viewConfiguration.titleFont
        //        toastTitle.textColor = self.viewConfiguration.titleColor
        //        toastTitle.setContentHuggingPriority(301, forAxis: .Vertical)
        //        mainLayout.addArrangedSubview(self.toastTitle)
        self.titleLabel = UILabel(frame: CGRectMake(0, 0, view.frame.width, 0))
        self.titleLabel.frame = CGRectMake(0, 0, view.frame.width, 0)
        self.titleLabel.font = self.viewConfiguration.titleFont
        self.titleLabel.textColor = self.viewConfiguration.titleColor
        self.titleLabel.setContentHuggingPriority(301, forAxis: .Vertical)
        mainLayout.addArrangedSubview(self.titleLabel)
        self.toastMessage.frame = CGRectMake(0, 0, view.frame.width, 0)
        toastMessage.font = self.viewConfiguration.subtitleFont
        toastMessage.textColor = self.viewConfiguration.subtitleColor
        toastMessage.textAlignment = .Left
        toastMessage.setContentHuggingPriority(300, forAxis: .Vertical)
        mainLayout.addArrangedSubview(self.toastMessage)
    }
    
    override func willShow() {
//        super.willShow()
        self.toastMessage.text = self.message
        self.titleLabel.text = self.title
    }
}

public class L13Banner: L13Toast {
    
    static let topPadding: CGFloat = 20.0
    static let cornerRadius: CGFloat = 8.0
    
    public override init() {
        super.init()
        self.viewConfiguration.messageViewCornerRadius = L13Banner.cornerRadius
        self.viewConfiguration.messageViewColor = UIColor.purpleColor()
    }
    
    override func didLoad() {
        super.didLoad()
        let frame = container == nil ? CGRectZero : container!.frame
        let top: CGFloat = L13Banner.topPadding + UIApplication.sharedApplication().topPadding
        view.frame = CGRectMake(8, top, frame.width - 16 , toastHieght)
    }
    
}

public class L13Modal: L13TransientMessage {
    
    
}
