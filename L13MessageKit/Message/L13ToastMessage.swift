//
//  L13ToastMessage.swift
//  L13MessageKit
//
//  Created by Luke Davis on 1/5/16.
//  Copyright © 2016 Lucky 13 Technologies, LLC. All rights reserved.
//

import UIKit

public class L13ToastView: L13Message, TransientPresentation {
    
    public let mainLayout: UIStackView
    
    public var toastHeight: CGFloat = 45
    public var textPadding: CGFloat = 16
    
    
    
    public required init(title: String?, message: String?) {
        self.mainLayout = UIStackView()
        super.init(title: title, message: message)
        let top: CGFloat = frame.height - UIApplication.sharedApplication().bottomPadding
        self.frame = CGRectMake(0, top, frame.width, toastHeight)
        self.backgroundColor = UIColor.purpleColor()
        self.alpha = 0.85
        self.layer.cornerRadius = 0
        mainLayout.frame = CGRectMake(8, 8, self.frame.width - self.textPadding, self.frame.height - self.textPadding)
        mainLayout.axis = .Vertical
        mainLayout.distribution = .Fill
        mainLayout.alignment = .FirstBaseline
        mainLayout.setContentHuggingPriority(250, forAxis: .Horizontal)
        self.addSubview(mainLayout)
        self.titleLabel.font = UIFont.systemFontOfSize(8)
        self.titleLabel.textColor = UIColor.whiteColor()
        mainLayout.addArrangedSubview(self.titleLabel)
        self.messageLabel.font = UIFont.systemFontOfSize(18)
        self.messageLabel.textColor = UIColor.whiteColor()
        self.messageLabel.textAlignment = .Left
        mainLayout.addArrangedSubview(self.messageLabel)
        print("Main Layout frame \(mainLayout.frame)")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

public class L13Toast: L13ToastView, SlideUpPresentationAnimation, SlideDownDismissalAnimation {
    
    
    public override func willMoveToSuperview(newSuperview: UIView?) {
        if let newView = newSuperview {
            self.prepareForSlideAnimation(newView)
        }
    }
    
    public override func didMoveToSuperview() {
        self.animateSlidePresentation()
    }
    
    public override func removeFromSuperview() {
        self.animateSlideDismissal() {
            super.removeFromSuperview()
        }
    }
}

public class L13ToastDrawer: L13Toast, L13PullUpAction {
    
    
    public required init(title: String?, message: String?) {
        super.init(title: title, message: message)
        self.makePullable()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}