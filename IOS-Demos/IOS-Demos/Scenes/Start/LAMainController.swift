//
//  LAMainController.swift
//  LaiAi
//
//  Created by Jim on 2018/2/27.
//  Copyright © 2018年 Jim1024. All rights reserved.
//

import UIKit


enum Movement {
    case refresh
    case loadMore
}

class LAMainController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.backgroundColor = UIColor.white
        tabBar.tintColor = R.color.primary()
        tabBar.isTranslucent = false
        delegate = self
        
        resetScence()
    }
    
    fileprivate func addChildViewControllers() {
        var vcs: [(UIViewController, String, String)] = []
        
//        vcs.append((R.storyboard.market.instantiateInitialViewController()!, "优市", "tab_market"))
//        vcs.append((R.storyboard.shop.instantiateInitialViewController()!, "店铺", "tab_work"))
//        if AppInfo.shared.iosAuditedFlag == false {
//            vcs.append((R.storyboard.task.instantiateInitialViewController()!, "任务", "tab_task"))
//        }
//        vcs.append((R.storyboard.my.instantiateInitialViewController()!, "我的", "tab_my"))
        
        let navControllers = vcs.map { (vc, title, icon) -> UINavigationController in
            vc.title = title
            vc.tabBarItem.image = UIImage(named: icon)?.withRenderingMode(.alwaysOriginal)
            vc.tabBarItem.selectedImage = UIImage(named: icon + "_lighted")?.withRenderingMode(.alwaysOriginal)
            vc.tabBarItem.setTitleTextAttributes([.foregroundColor: R.color.thirdText()!], for: .normal)
            vc.tabBarItem.setTitleTextAttributes([.foregroundColor: R.color.primaryVariant()!], for: .selected)
            vc.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -3)
            
            let nav = UINavigationController(rootViewController: vc)
            nav.navigationBar.isTranslucent = false
            vc.extendedLayoutIncludesOpaqueBars = false
            
            NavigationManager.share.takeOverNavigationController(nav)
            return nav
        }
        
        self.setViewControllers(navControllers, animated: true)
    }
    
    func resetScence() {
        self.viewControllers?.removeAll()
        self.addChildViewControllers()
    }
    
}

extension LAMainController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
    }

}
