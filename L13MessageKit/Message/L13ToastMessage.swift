//
//  L13ToastMessage.swift
//  L13MessageKit
//
//  Created by Luke Davis on 1/5/16.
//  Copyright © 2016 Lucky 13 Technologies, LLC. All rights reserved.
//

import UIKit

public class L13ToastView: L13Message, TransientPresentation {
    
    private let toastHieght: CGFloat = 45
    private let textPadding: CGFloat = 16
    
    public required init(title: String?, message: String?) {
        super.init(title: title, message: message)
        let top: CGFloat = frame.height - UIApplication.sharedApplication().bottomPadding //- toastHieght
        self.frame = CGRectMake(0, top, frame.width, toastHieght)
        self.backgroundColor = UIColor.purpleColor()//self.viewConfiguration.messageViewColor
        self.alpha = 0.85//self.viewConfiguration.messageAlpha
        self.layer.cornerRadius = 0//self.viewConfiguration.messageViewCornerRadius
        let mainLayout = UIStackView(frame: CGRectMake(8, 8, self.frame.width - self.textPadding, self.frame.height - self.textPadding))
        mainLayout.axis = .Vertical
        mainLayout.distribution = .Fill
        mainLayout.alignment = .FirstBaseline
        self.addSubview(mainLayout)
        self.titleLabel.font = UIFont.systemFontOfSize(8)//self.viewConfiguration.titleFont
        self.titleLabel.textColor = UIColor.whiteColor()//self.viewConfiguration.titleColor
        self.titleLabel.setContentHuggingPriority(301, forAxis: .Vertical)
        mainLayout.addArrangedSubview(self.titleLabel)
        self.messageLabel.font = UIFont.systemFontOfSize(18)//self.viewConfiguration.subtitleFont
        self.messageLabel.textColor = UIColor.whiteColor()//self.viewConfiguration.subtitleColor
        self.messageLabel.textAlignment = .Left
        self.messageLabel.setContentHuggingPriority(300, forAxis: .Vertical)
        mainLayout.addArrangedSubview(self.messageLabel)
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