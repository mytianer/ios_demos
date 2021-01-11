//
//  NotificationManager.swift
//  LaiAi
//
//  Created by Ryan on 2019/10/10.
//  Copyright © 2019 Laiai. All rights reserved.
//

import UIKit

struct NotificationManager {
    
    static let share = NotificationManager()
    
    /// 检查通知权限，true可以请求api
    func checkCurrentNotificationStatus(block: ((Bool) -> Void)?) {
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().getNotificationSettings { (settngs) in
                DispatchQueue.main.async {
                    switch settngs.authorizationStatus {
                    case .notDetermined:
                        UNUserNotificationCenter.current().requestAuthorization(options: UNAuthorizationOptions.alert.union(.sound).union(.sound)) { (flag, _) in
                            DispatchQueue.main.async {
                                block?(flag)
                            }
                        }
                    case .denied:
                        block?(false)
                        self.showAlertToOpenNotificationSetting()
                    default:
                        block?(true)
                    }
                }
            }
        } else {
            if let _ = UIApplication.shared.currentUserNotificationSettings?.types {
                block?(true)
            } else {
                let types = UIUserNotificationSettings.init(types: UIUserNotificationType.alert.union(.badge).union(.sound), categories: nil)
                UIApplication.shared.registerUserNotificationSettings(types)
                UIApplication.shared.registerForRemoteNotifications()
                block?(false)
            }
        }
    }
    
    private func showAlertToOpenNotificationSetting() {
        let alert = UIAlertController(title: "请开启通知权限", message: "为你提供签到提醒、订单、活动等通知", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "不允许", style: .cancel, handler: nil)
        let confirm = UIAlertAction(title: "去开启", style: .default) { (_) in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.openURL(url)
            }
        }
        alert.addAction(cancel)
        alert.addAction(confirm)
        Router.shared.currentViewCotroller?.present(alert, animated: true, completion: nil)
    }
    
}
