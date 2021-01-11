//
//  Theme.swift
//  LaiAi
//
//  Created by DongYuan on 2018/5/29.
//  Copyright © 2018年 Jim1024. All rights reserved.
//

import UIKit
//import IQKeyboardManagerSwift


class Theme: NSObject {
    
    class func setupTheme() {
//        configKeyboard()
        setNavigationBarAppearance()
        setTextInputAppearance()
    }
    
    
    /// 键盘
//    private class func configKeyboard() {
//        IQKeyboardManager.shared.enable = true
//        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
//        IQKeyboardManager.shared.enableAutoToolbar = true
//    }
    
    
    private class func setTextInputAppearance() {
        UITextField.appearance().tintColor = R.color.primary()
        UITextView.appearance().tintColor = R.color.primary()
    }
    
    /// 设置全局导航栏
    private class func setNavigationBarAppearance() {
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        }
        
        let nb = UINavigationBar.appearance()
        resetNavigationBar(bar: nb)
        
        let bbi = UIBarButtonItem.appearance()
        resetNavigationBarItem(item: bbi)
    }
    
    class func resetNavigationBar(bar: UINavigationBar) {
        bar.tintColor = R.color.secondaryText()
        bar.barTintColor = UIColor.white
        bar.backIndicatorImage = #imageLiteral(resourceName: "nav_back")
        bar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "nav_back")
        // 去掉分割线
        bar.shadowImage = UIImage()
        
        bar.titleTextAttributes = [.foregroundColor: R.color.secondaryText()!,
                                   .font: UIFont.boldSystemFont(ofSize: 17)]
    }
    
    class func resetNavigationBarItem(item: UIBarButtonItem) {
        item.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 14),
                                     .foregroundColor: R.color.secondaryText()!],
                                    for: .normal)
        item.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 14),
                                     .foregroundColor: R.color.secondaryText()!],
                                    for: .highlighted)
    }

}



