//
//  DropDownAnimation.swift
//  LaiAi
//
//  Created by 李瀚 on 2018/4/27.
//  Copyright © 2018年 Jim1024. All rights reserved.
//

import UIKit

class DropDownAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        guard let toVC = transitionContext?.viewController(forKey: .to),
            let _ = transitionContext?.viewController(forKey: .from) else {
                return 0
        }
        if toVC.isBeingPresented {
            return 0.5
        } else {
            return 0.25
        }
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let toVC = transitionContext.viewController(forKey: .to),
            let fromVC = transitionContext.viewController(forKey: .from),
            let fromView = fromVC.view,
            let toView = toVC.view else {
                return
        }
        
        
        let duration = transitionDuration(using: transitionContext)
        
        if toVC.isBeingPresented {
            if toVC.preferredContentSize != .zero {
                toView.frame = CGRect(x: (toView.bounds.width - toVC.preferredContentSize.width) / 2,
                                      y: toView.bounds.height - toVC.preferredContentSize.height,
                                      width: toVC.preferredContentSize.width,
                                      height: toVC.preferredContentSize.height)
            } else {
                toView.frame = CGRect(x: 0,
                                      y: 0,
                                      width: SCREEN_WIDTH,
                                      height: SCREEN_HEIGHT)
            }
            
            containerView.addSubview(toView)
            
            toView.transform = CGAffineTransform(translationX: 0, y: toView.bounds.height)
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.5, options: .curveLinear, animations: {
                toView.transform = .identity
            }, completion: { (_) in
                transitionContext.completeTransition(true)
            })
        }
        
        if fromVC.isBeingDismissed {
            UIView.animate(withDuration: duration, animations: {
                fromView.transform = CGAffineTransform(translationX: 0, y: fromView.bounds.height)
            }, completion: { (_) in
                transitionContext.completeTransition(true)
            })
        }
        
    }
}
