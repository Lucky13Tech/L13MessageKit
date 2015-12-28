//
//  File.swift
//  L13MessageKit
//
//  Created by Luke Davis on 12/15/15.
//  Copyright © 2015 Lucky 13 Technologies, LLC. All rights reserved.
//

import UIKit

public enum L13PresentationType: L13Presenter {
    case Normal
    case SlideUp
    case SlideDown
    case SlideLeft
    case SlideRight
    case Pop
    
    func present(view: L13View) {
        switch self {
        case .Normal:
            L13NormalShow(view: view).perform()
            break
        case .SlideUp :
            L13SlideUpShow(view: view).perform()
            break
        default :
            L13SlideUpShow(view: view).perform()
            break
        }
    }
    
    func dismiss(view: L13View) {
        switch self {
        case .Normal:
            L13NormalHide(view: view).perform()
            break
        case .SlideDown:
                L13SlideDownHide(view: view).perform()
            break
        default :
            break
        }
    }
}