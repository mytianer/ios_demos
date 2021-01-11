//
//  LAGlobal.swift
//  LaiAi
//
//  Created by Jim on 2018/2/27.
//  Copyright © 2018年 Jim1024. All rights reserved.
//

import UIKit


let CMCache = NSCache<AnyObject, AnyObject>()

typealias EmptyBlock = (() -> ())

// 实现命名空间laiai
extension String: CMKitCompatible {}


extension CMKit where Base == UIImage {
    // 默认头像
    static var defaultAvatar:UIImage{
        return #imageLiteral(resourceName: "default_avatar")
    }
    /// 默认占位图
    static var defaultImage:UIImage{
        return #imageLiteral(resourceName: "default_image")
    }
    /// 默认图标
    static var defaultLogo:UIImage{
        return #imageLiteral(resourceName: "default_logo") 
    }

}

let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height

let iPhone6Por7P: Bool = SCREEN_WIDTH == 414 ? true : false
let iPhone6or7: Bool = SCREEN_WIDTH == 375 ? true : false
let iPhone5s5e4s = SCREEN_WIDTH == 320 ? true : false
private let 刘海屏幕 = UIScreen.main.bounds.size.equalTo(CGSize(width: 375, height: 812)) || UIScreen.main.bounds.size.equalTo(CGSize(width: 414, height: 896))

let StatusBarHeight: CGFloat = 刘海屏幕 ? 44 : 20
let TopBarHeight = StatusBarHeight + 44
let TabBarHeight: CGFloat = 刘海屏幕 ? 83.0 : 49.0
let HomeIndicatorHeight: CGFloat = 刘海屏幕 ? 34 : 0
let TopGapHeight: CGFloat = 刘海屏幕 ? 24 : 0
var ScrollerGapHeight: CGFloat = 刘海屏幕 ? 15 : 5 // 用于解决首页数据少的时候下拉时会出现的页面上下抖动

/// 相对iPhone6宽比
let WidthScale = SCREEN_WIDTH / 375
/// 相对iPhone6高比
let HeightScale = SCREEN_WIDTH / 667

/// 默认图片高宽比 9:16
//let ImageRatio: CGFloat = 0.5625
let ImageRatio: CGFloat = 2/5


/*================= Other =================*/

let ListBannerHeight: CGFloat = 130.0 / 375.0 * SCREEN_WIDTH

struct Measure {
    static let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
    static let navigationBarHeight: CGFloat = Router.shared.currentViewCotroller?.navigationController?.navigationBar.size.height ?? 44.0
}

struct LogTag {
    static let lifeCycle = "LifeCycle"
    static let viewDidLoad = "ViewDidLoad"
    static let dealloc = "Dealloc"
    static let debug = "debug"
}

struct UserDefaultKey {
    static let lastLaunchAdvertiseDay = "lastLaunchAdvertiseDay"
    static let lastLaunchAdvertiseIndex = "lastLaunchAdvertiseIndex"
    static let lastHomeAdvertiseIndex = "lastHomeAdvertiseIndex"
    static let lastHomeAdvertiseDay = "lastHomeAdvertiseDay"
    
    static let cacheUserId = "cacheUserId"
    
    // 搜索列表关键字记录
    static let searchRecordAryKey = "searchRecordAryKey"
    
    // 是否已经展示过了积分签到指引 bool
    static let hadShowScoreSignGuide = "hadShowScoreSignGuide"
}

struct NotificationName {
    static let userScoreChange = NSNotification.Name("userScoreChange")
}
