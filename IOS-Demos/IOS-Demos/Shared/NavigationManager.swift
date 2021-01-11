//
//  NavigationManager.swift
//  LaiAi
//
//  Created by Ryan on 2019/9/16.
//  Copyright © 2019 Laiai. All rights reserved.
//

import UIKit

protocol NavigationManagerProtocol: class {
    
    // 是否隐藏当前导航栏 默认false
    var navigationBarShouldHidden: Bool { get }
    
    // 是否关闭当前侧滑返回手势 默认false
    var disableInteractivePopGestureRecognizer: Bool { get }
}



class NavigationManager: NSObject, UIGestureRecognizerDelegate {
    
    static let share = NavigationManager()
    
    func takeOverNavigationController(_ navigationController: UINavigationController?) {
        guard let nav = navigationController else { return }
        nav.delegate = self
        nav.interactivePopGestureRecognizer?.delegate = self
    }
}

extension NavigationManager: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        // 控制导航栏显示隐藏
        let navigationBarHideden = (viewController as? NavigationManagerProtocol)?.navigationBarShouldHidden ?? false
        viewController.navigationController?.setNavigationBarHidden(navigationBarHideden, animated: true)

        // 自定义返回按钮
        viewController.navigationController?.navigationBar.backItem?.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // 控制侧滑返回
        guard navigationController.viewControllers.count > 1 else {
            navigationController.interactivePopGestureRecognizer?.isEnabled = false
            return
        }
        let disablePopGesture = (viewController as? NavigationManagerProtocol)?.disableInteractivePopGestureRecognizer ?? false
        navigationController.interactivePopGestureRecognizer?.isEnabled = !disablePopGesture
    }
}


extension UINavigationController: UINavigationBarDelegate {
    // 隐藏返回按钮标题
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPush item: UINavigationItem) -> Bool {
        item.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        // 为了解决隐藏导航栏的情况
        if navigationBar.items?.last?.backBarButtonItem?.title != " " {
            navigationBar.items?.last?.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        }
        return true
    }
    
//    /// 注意： 不能在shouldPop中修改，会导致返回键丢失
//    public func navigationBar(_ navigationBar: UINavigationBar, didPop item: UINavigationItem) {
//        // 客服咨询侧滑返回需要修改 navigationBar背景色
//        if item.title == "机器人小艾" || item.title?.contains("客服") == true || item.title == nil || item.title?.contains("排队") == true {
//            let attr = [NSAttributedString.Key.foregroundColor: UIColor.cm.secondaryText, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
//            navigationBar.titleTextAttributes = attr
//            navigationBar.barTintColor = UIColor.white
//        }
//    }
    
}
