//
//  Startup.swift
//  LaiAi
//
//  Created by DongYuan on 2018/7/23.
//  Copyright © 2018年 Jim1024. All rights reserved.
//

import UIKit
import Promises
import Kingfisher


class Startup {
    
    class func start(autoLogin: Bool) {
        (autoLogin ? loginPromise().then{ launchAdPromise() } : loginPromise())
            .delay(1)
            .always {
                self.checkAppState()
                self.checkNewVersion()
            }
            .catchApiError(false)
    }
    
    /// 登录逻辑线
    private class func loginPromise() -> Promise<Void> {
        return Api.Login.fetchUserInfo()
            .then { _ in
//                Api.Work.fetchShopDetail().catchApiError(false)
//                Api.Login.fetchDomain().catchApiError(false)
            }
    }
    
    /// 启动广告逻辑线
    private class func launchAdPromise() -> Promise<Void> {
        return Api.Login.fetchAdvertisementBanner(position: 3)
            .then { models in
//                guard let adVc = UIApplication.shared.keyWindow?.rootViewController as? LaunchAdvertisementController else { return }
//                var url: String? = nil
//                var targetModel: Model.AdModel?
//                if models.count > 0 {
//                    let advertiseDay = UserDefaults.standard.object(forKey: UserDefaultKey.lastLaunchAdvertiseDay) as? String ?? ""
//                    var index = UserDefaults.standard.integer(forKey: UserDefaultKey.lastLaunchAdvertiseIndex)
//                    let today = Date().toString(format: "yyyy-MM-dd")
//                    if advertiseDay != today { index = -1 }
//                    index = index + 1
//                    UserDefaults.standard.set(today, forKey: UserDefaultKey.lastLaunchAdvertiseDay)
//                    UserDefaults.standard.set(index, forKey: UserDefaultKey.lastLaunchAdvertiseIndex)
//                    UserDefaults.standard.synchronize()
//
//                    let targetIndex = index % models.count  // 轮播
//                    url = models.getElementAt(targetIndex)?.imgUrl
//                    targetModel = models.getElementAt(targetIndex)
//                }
//                adVc.setAd(url: url, adClick: {
//                    self.handleLaunchAd(with: targetModel)
//                })
            }
            .delay(3)
    }
    
    /// 处理启动页广告
    private class func handleLaunchAd(with model: Model.AdModel?) {
//        guard let tabVc = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController,
//            let homeNav = tabVc.selectedViewController as? UINavigationController,
//            let model = model,
//            let vc = Router.resolveTargetController(from: model.showUrl ?? "") else { return }
//            homeNav.show(vc, sender: nil)
    }
    
    // 查询审核状态
    private class func checkAppState() {
        guard AppInfo.shared.iosAuditedFlag,
            let tabVc = UIApplication.shared.keyWindow?.rootViewController as? LAMainController,
            tabVc.viewControllers?.count == 4 else {
            return
        }
        tabVc.resetScence()
    }
    
    // 新版本检测
    private class func checkNewVersion() {
        Api.Login.fetchNewAppVersion()
            .then { model -> Void in
                let lastTipVersion = UserDefaults.standard.object(forKey: "hasTipNewVersionUpgrade") as? String ?? ""
                let currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
                
                let vc = NewVersionUpgradeController()
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                vc.newVersionInfo = model
                vc.nextBlock = {
                    self.nextCheck()
                }
                
                if let newVersion = model.versionName?.lowercased().replacingOccurrences(of: "ios-", with: ""),
                    newVersion.compare(currentVersion, options: .numeric, range: nil, locale: nil) == .orderedDescending {
                    if model.isForce == 1 {
                        Router.shared.currentViewCotroller?.present(vc, animated: true)
                    }else if newVersion != lastTipVersion {
                        Router.shared.currentViewCotroller?.present(vc, animated: true)
                    }else{
                        self.nextCheck()
                    }
                    
                    UserDefaults.standard.set(newVersion, forKey: "hasTipNewVersionUpgrade")
                }else{
                    self.nextCheck()
                }
            }
            .catch { _ in
                self.nextCheck()
            }
    }
    
    private class func nextCheck() {
        // 如果有开屏广告、新用户专享券：优先展示我的积分签到新人指引，关闭新人指引后，才能看到其它弹窗
//        ScoreGuideView.share?.tryToShow(complete: {
//            if CMUser.info?.haveRegisterCoupons == true {
//                self.checkNewUserCoupons()
//            }else{
//                self.checkAdvertisement()
//            }
//        })
    }
    
    // 首页广告
    private class func checkAdvertisement() {
        Api.Login.fetchAdvertisementBanner(position: 2)
            .then { models -> Void in
                guard models.count > 0, CMUser.isLogin else { return }
                
                var advertiseIndex = UserDefaults.standard.integer(forKey: UserDefaultKey.lastHomeAdvertiseIndex)
                let advertiseDay = UserDefaults.standard.object(forKey: UserDefaultKey.lastHomeAdvertiseDay) as? String ?? ""
                let today = Date().toString(format: "yyyy-MM-dd")
                if advertiseDay != today { advertiseIndex = -1 }
                advertiseIndex = advertiseIndex + 1
                if advertiseIndex >= models.count { return }    // 不轮播
                UserDefaults.standard.set(advertiseIndex, forKey: UserDefaultKey.lastHomeAdvertiseIndex)
                UserDefaults.standard.set(today, forKey: UserDefaultKey.lastHomeAdvertiseDay)
                UserDefaults.standard.synchronize()
                
                showAdvertise(models.getElementAt(advertiseIndex))
            }
            .catchApiError()
        
        func showAdvertise(_ model: Model.AdModel?) {
            guard let model = model else { return }
            if let url = URL(string: model.imgUrl ?? "") {
                KingfisherManager.shared.downloader.downloadImage(with: url) { (image, _, _, _) in
                    if let image = image {
                        let vc = AdvertisementController()
                        vc.modalPresentationStyle = .overFullScreen
                        vc.modalTransitionStyle = .crossDissolve
                        vc.info = model
                        vc.adverImage = image
                        Router.shared.currentViewCotroller?.present(vc, animated: true)
                    }
                }
            }
        }
    }
    
}


