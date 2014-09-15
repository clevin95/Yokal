//
//  LoginAnimatedTransitioning.swift
//  Yokal2.0
//
//  Created by Carter Levin on 8/7/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//



import UIKit

class LoginAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController:UIViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toViewController:UIViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let container:UIView = transitionContext.containerView()
        UIView.animateKeyframesWithDuration(0.5, delay: 0, options: nil, animations: {
            toViewController.view.transform = CGAffineTransformIdentity;
            }, completion: {(completed:Bool) in
                transitionContext.completeTransition(completed)
        })
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 1.5
    }

}