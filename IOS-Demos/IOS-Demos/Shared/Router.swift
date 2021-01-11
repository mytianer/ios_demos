//
//  Router.swift
//  AAT
//
//  Created by DongYuan on 2017/12/11.
//  Copyright © 2017年 YiXue. All rights reserved.
//

import Foundation
import UIKit

class Router {
    
    static let shared = Router()
    
    var currentViewCotroller: UIViewController? {
        var result: UIViewController? = nil
        
        guard var topController = UIApplication.shared.keyWindow?.rootViewController else {
            return result
        }
        
        while let vc = topController.presentedViewController {
            topController = vc
        }
        
        if let tabbar = topController as? UITabBarController {
            if let nav = tabbar.selectedViewController as? UINavigationController {
                result = nav.children.last
            } else {
                result = tabbar.selectedViewController
            }
        } else if let nav = topController as? UINavigationController {
            result = nav.children.last
        } else {
            result = topController
        }
        
        return result
    }
    
}
