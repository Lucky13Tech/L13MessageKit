//
//  L13PresentationType.swift
//  L13MessageKit
//
//  Created by Luke Davis on 12/14/15.
//  Copyright © 2015 Lucky 13 Technologies, LLC. All rights reserved.
//

import Foundation

protocol L13Presenter {
    
    func present(view: L13View)
    
    func dismiss(view: L13View)
    
}

protocol L13Presentation {
    
    func perform()
    
}

protocol L13Animatable {
    
//    var containerFrame: CGRect { get }
    
}

extension NSTimeInterval {
    
    static var zero: Double {
        get {
            return 0.0
        }
    }
    
    static var standardDuration: Double {
        get {
            return 0.35
        }
    }
    
}

class L13BasePresentation: L13Presentation {
    
    internal var view: L13View
    
    required init(view: L13View) {
        self.view = view
    }
    
    func perform() {
        fatalError("Base Presentation must be overriden")
    }
}

class L13NormalShow: L13BasePresentation {
    
    override func perform() {
        UIView.animateWithDuration(NSTimeInterval.standardDuration, delay: NSTimeInterval.zero, options: .CurveEaseInOut, animations: {
            self.view.alpha = 1.0
            }) { complete in
                
        }
    }
}

class L13SlideUpShow: L13BasePresentation {
    
    override func perform() {
        UIView.animateWithDuration(NSTimeInterval.standardDuration, delay: NSTimeInterval.zero, options: .CurveEaseInOut, animations: {
//            self.view.center.y += self.view.containerFrame.
            }) { complete in
                
        }
    }
    
}

class L13NormalHide: L13BasePresentation {
    
    override func perform() {
        UIView.animateWithDuration(NSTimeInterval.standardDuration, delay: NSTimeInterval.zero, options: .CurveEaseInOut, animations: {
            self.view.alpha = 0.0
            }) { complete in
                
        }
    }
}

class L13CancelViewAnimation: L13BasePresentation {
    
    override func perform() {
        self.view.hidden = true
    }
}

//
//class L13Presentation: L13Presenter {
//    
//    private var nextPresentation: L13Presenter?
//    
//    required init(nextPresenter: L13Presenter?) {
//        self.nextPresentation = nextPresenter
//    }
//    
//    func present(message: L13Message) {
//        if let presentation = nextPresentation {
//            presentation.present(message)
//        }
//    }
//    
//}
//
//class L13FadePresentation: L13Presentation {
//    
//    override func present(message: L13Message) {
//        
//    }
//    
//}