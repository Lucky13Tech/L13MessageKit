//
//  L13Presentation.swift
//  L13MessageKit
//
//  Created by Luke Davis on 12/20/15.
//  Copyright © 2015 Lucky 13 Technologies, LLC. All rights reserved.
//

import UIKit

public protocol Presentation {
    
    func present()
    
    func dismiss()
    
}

public protocol TransientPresentation: Presentation {
    
}

extension TransientPresentation where Self: UIView {
    
    public func present() {
        let rootView = UIApplication.sharedApplication().getRootView()
        rootView.addSubview(self)
    }
    
    public func dismiss() {
        self.removeFromSuperview()
    }
    
}

public protocol DisruptivePresentation: Presentation {
    
}

extension DisruptivePresentation where Self: UIView {
    
    public func present() {
        let windowManager = WindowManager()
        let container = windowManager.messageContainerView
        container.backgroundColor = UIColor(white: 0.0, alpha: 0.34)
        container.addSubview(self)
        windowManager.pushMessageWindow()
    }
    
    public func dismiss() {
        let windowManager = WindowManager()
        self.removeFromSuperview()
        windowManager.popMessageWindow()
    }
    
}

extension DisruptivePresentation where Self: UIViewController {
    
    public func present() {
        if let rootController = UIApplication.sharedApplication().rootViewController {
           rootController.presentViewController(self, animated: true, completion: nil)
        }
    }
    
    public func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

class WindowManager {
    static let messageWindow = UIWindow(frame: UIScreen.mainScreen().bounds)
    
    static let rootViewController = UIViewController(nibName: nil, bundle: nil)
    
    var messageContainerView: UIView {
        get {
            return WindowManager.rootViewController.view
        }
    }
    
    init() {
        if WindowManager.messageWindow.rootViewController == nil {
            let frame = WindowManager.messageWindow.frame
            let baseView = UIView(frame: frame)
            WindowManager.rootViewController.view = baseView
            WindowManager.messageWindow.rootViewController = WindowManager.rootViewController
        }
    }
    
    func pushMessageWindow() {
        WindowManager.messageWindow.windowLevel = UIWindowLevelAlert + 1
        WindowManager.messageWindow.makeKeyAndVisible()
    }
    
    func popMessageWindow() {
        WindowManager.messageWindow.hidden = true
    }
    
}

extension UIApplication {
    
    var rootViewController: UIViewController? {
        get {
            return self.delegate?.window?!.rootViewController
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
                // Removing 4 because there is a 4 point pad on the top of the tabbar
                return root.tabBar.frame.height - 4
            }
            return 0
        }
    }
    
    func getRootView() -> UIView {
        if let rootController = rootViewController {
            let presentedController = self.getRootViewControllerFromController(rootController)
            return presentedController.view
        }
        return UIView(frame: CGRectZero)
    }
    
    func getRootViewControllerFromController(controller: UIViewController) -> UIViewController {
        if let navCon = controller as? UINavigationController {
            return getRootViewControllerFromController(navCon.visibleViewController!)
        } else if let tabCon = controller as? UITabBarController {
            return getRootViewControllerFromController(tabCon.selectedViewController!)
        } else if let modalController = controller.presentedViewController {
            return getRootViewControllerFromController(modalController)
        } else {
            return controller
        }
    }
    
}
