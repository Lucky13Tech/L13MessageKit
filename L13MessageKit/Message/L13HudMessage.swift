//
//  L13HudMessage.swift
//  L13MessageKit
//
//  Created by Luke Davis on 1/6/16.
//  Copyright © 2016 Lucky 13 Technologies, LLC. All rights reserved.
//

import UIKit

public class L13Hud: L13Message, DisruptivePresentation, AlphaDismissalAnimation, AlphaPresentationAnimation {
    
    let mainLayout: UIStackView
    public var contentPadding: CGFloat = 10.0
    public var contentOffset: CGPoint = CGPointZero
    
    public var showIndicator: Bool {
        didSet {
            self.activityIndicator.hidden = !showIndicator
        }
    }
    
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    
    
    public convenience required init(title: String?, message: String?) {
        self.init(title: title, message: message, showProgressIndicator: false)
    }
    
    public init(title: String?, message: String?, showProgressIndicator: Bool = false) {
        self.showIndicator = showProgressIndicator
        self.mainLayout = UIStackView()
        super.init(title: title, message: message)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor(white: 0.0, alpha: 0.85)
        self.layer.cornerRadius = 15
        self.mainLayout.translatesAutoresizingMaskIntoConstraints = false
        mainLayout.axis = .Vertical
        mainLayout.distribution = .EqualCentering
        mainLayout.alignment = .Center
        mainLayout.spacing = 10
        self.addSubview(mainLayout)
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[stackView]-10-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: ["stackView":mainLayout]))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[stackView]-10-|", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: ["stackView":mainLayout]))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: 1, constant: 0))
        self.setContentHuggingPriority(150, forAxis: .Vertical)
        self.setContentHuggingPriority(150, forAxis: .Horizontal)
        self.titleLabel.font = UIFont.systemFontOfSize(24)
        self.titleLabel.textColor = UIColor.whiteColor()
        self.titleLabel.textAlignment = .Center
        self.titleLabel.lineBreakMode = .ByWordWrapping
        self.titleLabel.numberOfLines = 0
        self.messageLabel.font = UIFont.systemFontOfSize(16)
        self.messageLabel.textColor = UIColor.whiteColor()
        self.messageLabel.textAlignment = .Center
        self.messageLabel.lineBreakMode = .ByWordWrapping
        self.messageLabel.numberOfLines = 0
        self.activityIndicator.center = self.center
        mainLayout.addArrangedSubview(titleLabel)
        mainLayout.addArrangedSubview(activityIndicator)
        mainLayout.addArrangedSubview(messageLabel)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.center = superview!.center
    }
    
    public override func willMoveToSuperview(newSuperview: UIView?) {
        if let newView = newSuperview {
            self.prepareForPresentationAnimation(newView)
        }
    }

    public override func didMoveToSuperview() {
        self.activityIndicator.startAnimating()
        self.animatePresentation()
    }

    public override func removeFromSuperview() {
        self.animateDismissal() {
            self.activityIndicator.stopAnimating()
            super.removeFromSuperview()
        }
    }
    
}

//public class L13Hud: L13HudView, AlphaDismissalAnimation, AlphaPresentationAnimation {
//
////    public override func willMoveToSuperview(newSuperview: UIView?) {
////        if let newView = newSuperview {
////            self.prepareForPresentationAnimation(newView)
////        }
////    }
////    
////    public override func didMoveToSuperview() {
////        self.activityIndicator.startAnimating()
////        self.animatePresentation()
////    }
////    
////    public override func removeFromSuperview() {
////        self.animateDismissal() {
////            self.activityIndicator.stopAnimating()
////            super.removeFromSuperview()
////        }
////    }
//    
//}
