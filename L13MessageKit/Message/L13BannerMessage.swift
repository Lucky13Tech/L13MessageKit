//
//  L13BannerMessage.swift
//  L13MessageKit
//
//  Created by Luke Davis on 1/5/16.
//  Copyright © 2016 Lucky 13 Technologies, LLC. All rights reserved.
//

import UIKit

/**
 Base Banner message which can be extended
 */
public class L13BannerView: L13Message, TransientPresentation {
    
    private let topPadding: CGFloat = 20.0
    private let messageHeight: CGFloat = 45
    private let textPadding: CGFloat = 16
    
    public required init(title: String?, message: String?) {
        super.init(title: title, message: message)
        let top: CGFloat = topPadding + UIApplication.sharedApplication().topPadding
        self.frame = CGRectMake(8, top, frame.width - 16 , messageHeight)
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

/**
 Convenience Banner Message
*/
public class L13Banner: L13BannerView, AlphaPresentationAnimation, AlphaDismissalAnimation, L13SpringPresentationAnimation, L13SwipeToDismissAction {
    
    public required init(title: String?, message: String?) {
        super.init(title: title, message: message)
        self.letSwipeToDismiss()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func willMoveToSuperview(newSuperview: UIView?) {
        if let newView = newSuperview {
            self.prepareForPresentationAnimation(newView)
            self.prepareForSpringAnimation()
        }
    }
    
    public override func didMoveToSuperview() {
        self.animatePresentation()
        self.animateSpringPresentation()
    }
    
    public override func removeFromSuperview() {
        self.animateDismissal() {
            super.removeFromSuperview()
        }
    }
    
}