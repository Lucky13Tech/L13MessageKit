//
//  L13PresentationManager.swift
//  L13MessageKit
//
//  Created by Luke Davis on 12/20/15.
//  Copyright © 2015 Lucky 13 Technologies, LLC. All rights reserved.
//

import UIKit

protocol Presenter {
    
    func presentMessage(presentable: L13Message)
    
    func dismissMessage(presentable: L13Message)
    
}

/**
 Knows how to present each type of message
*/
class L13PresentationManager: NSObject, Presenter {

    
    
//    static var window: UIWindow?
//    
//    override init() {
//        L13PresentationManager.window = UIWindow(frame: UIScreen.mainScreen().bounds)
//        L13PresentationManager.window!.windowLevel = UIWindowLevelAlert + 1
//        L13PresentationManager.window!.rootViewController = UIViewController(nibName: nil, bundle: nil)
//        
//    }

    func presentMessage(presentable: L13Message) {
        if let transientMessage = presentable as? L13TransientMessage {
            presentTransientMessage(transientMessage)
        }
    }
    
    func presentTransientMessage(presentable: L13TransientMessage) {
        let presentation = presentable.presentationAnimation
        let messageView = presentable.view
        messageView.parentView.addSubview(messageView)
        presentation.present(messageView)
    }
//
//    func presentDisruptiveMessage(presentable: L13DisruptiveMessage) {
//        L13PresentationManager.window!.makeKeyAndVisible()
//        // Show 
//        L13PresentationManager.window!.rootViewController?.presentViewController(presentable.viewController, animated: true, completion: nil)
//    }
    func dismissMessage(presentable: L13Message) {
        let dismiss = presentable.dismissalAnimation
        let messageView = presentable.view
        dismiss.dismiss(messageView)
    }
//    
//    func dismissTransientMessage(presentable: ViewPresentable) {
//        
//    }
//    
//    func dismiss(presentable: ViewControllerPresentable) {
//        L13PresentationManager.window!.hidden = true
//        // Now make the original UIWindow key
//        UIApplication.sharedApplication().delegate?.window!?.makeKeyWindow()
//    }

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
