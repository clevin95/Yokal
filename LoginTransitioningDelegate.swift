//
//  LoginTransitioningDelegate.swift
//  Yokal2.0
//
//  Created by Carter Levin on 8/7/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

import UIKit

class LoginTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transitioning:LoginAnimatedTransitioning = LoginAnimatedTransitioning()
        return transitioning
    }
    
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            let transitioning:LoginAnimatedTransitioning = LoginAnimatedTransitioning()
            return transitioning
    }
    

}
