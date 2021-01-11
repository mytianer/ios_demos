//
//  PresentationController.swift
//  LaiAi
//
//  Created by 李瀚 on 2018/4/27.
//  Copyright © 2018年 Jim1024. All rights reserved.
//

import UIKit

class PresentationController: UIPresentationController {
    
    private lazy var transView: UIView = {
        return UIView(frame: UIScreen.main.bounds)
    }()
    private lazy var effectTransView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let effectView = UIVisualEffectView(effect: blurEffect)
        effectView.frame = UIScreen.main.bounds
        
        return effectView
    }()
    
    var useEffectMask: Bool = false
    var tapToDismiss: Bool = false
    
    
    override func presentationTransitionWillBegin() {
        if useEffectMask {
            effectTransView.alpha = 0.0
            containerView?.addSubview(effectTransView)
            presentingViewController.transitionCoordinator?.animate(alongsideTransition: { [unowned self] (_) in
                self.effectTransView.alpha = 0.88
            }, completion: nil)
            
        } else {
            transView.backgroundColor = .black
            transView.alpha = 0
            containerView?.addSubview(transView)
            presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [unowned self] (_) in
                self.transView.alpha = 0.4
            })
        }
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        guard tapToDismiss else {
            return
        }
        
        if presentedViewController.preferredContentSize == .zero
            || presentedViewController.preferredContentSize == UIScreen.main.bounds.size {
            
            let dismissView = UIView(frame: UIScreen.main.bounds)
            dismissView.backgroundColor = UIColor.clear
            presentedViewController.view.insertSubview(dismissView, at: 0)
            
            dismissView.addTapGesture { [unowned self](_) in
                self.presentedViewController.dismiss(animated: true)
            }
        }else {
            if useEffectMask {
                effectTransView.addTapGesture { [unowned self](_) in
                    self.presentedViewController.dismiss(animated: true)
                }
            } else {
                transView.addTapGesture { [unowned self](_) in
                    self.presentedViewController.dismiss(animated: true)
                }
            }
        }
    }
    
    override func dismissalTransitionWillBegin() {
        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { [unowned self] (_) in
            if self.useEffectMask {
                self.effectTransView.alpha = 0
            } else {
                self.transView.alpha = 0
            }
        }, completion: { [unowned self] (_) in
            if self.useEffectMask {
                self.effectTransView.removeSubviews()
            } else {
                self.transView.removeSubviews()
            }
        })
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerViewBounds = containerView?.bounds else { return .zero }
        let presentedViewContentSize = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerViewBounds.size)
        var presentedViewControllerFrame = containerViewBounds
        presentedViewControllerFrame.size.height = presentedViewContentSize.height
        presentedViewControllerFrame.origin.y = containerViewBounds.maxY - presentedViewContentSize.height
        return presentedViewControllerFrame
    }
    
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)
        if container as? UIViewController == presentedViewController {
            containerView?.layoutSubviews()
        }
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        if container as! UIViewController == presentedViewController {
            return container.preferredContentSize
        } else {
            return super.size(forChildContentContainer: container, withParentContainerSize: parentSize)
        }
    }
}
