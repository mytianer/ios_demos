//
//  UIViewController+Extension.swift
//  MVPTest
//
//  Created by Ryan on 2018/9/21.
//  Copyright © 2018年 Ryan. All rights reserved.
//

import UIKit

extension UIViewController {
    
    private struct AssociatedKeys {
        static var operaionKey = "UIViewController.operaion"
    }
    
    var transitionOperation: TransitionOperation? {
        get {
            return objc_getAssociatedObject(self,
                                            &AssociatedKeys.operaionKey) as? TransitionOperation
        }
        set {
            objc_setAssociatedObject(self,
                                     &AssociatedKeys.operaionKey,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            self.modalPresentationStyle = .custom
            self.transitioningDelegate = newValue
        }
    }
}


class TransitionOperation: NSObject, UIViewControllerTransitioningDelegate {
    
    typealias FetchPresentationControllerHandle = ((_ presented: UIViewController, _ presenting: UIViewController?) -> UIPresentationController)
    
    private var presentedTransitioning: UIViewControllerAnimatedTransitioning?
    private var dismissedTransitioning: UIViewControllerAnimatedTransitioning?
    private var presentation: FetchPresentationControllerHandle?
    
    init(presentedTransitioning: UIViewControllerAnimatedTransitioning? = nil,
         dismissedTransitioning: UIViewControllerAnimatedTransitioning? = nil,
         presentationController: FetchPresentationControllerHandle? = nil) {
        super.init()
        self.presentedTransitioning = presentedTransitioning
        self.dismissedTransitioning = dismissedTransitioning
        self.presentation = presentationController
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissedTransitioning
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentedTransitioning
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return presentation?(presented, presenting)
    }
}


