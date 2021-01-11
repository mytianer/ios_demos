//
//  CMUser.swift
//  LaiAi
//
//  Created by wenjingjie on 2018/5/3.
//  Copyright © 2018年 Jim1024. All rights reserved.
//

import UIKit

private let CMXAccessToken = "CMXAccessToken"

struct UserInfo: Codable {
    var nickName: String?
    var accountName: String?
    var infraUserId: Int?
    var realName: String?
    var customerUser: Bool?
    var logoPath: String?
    
    var phoneMobile: String?
    var email: String?
    var birthDayStr: String?
    var sex: Gender?   // 0：未知  1：男  2：女
    var city: String?
    var province: String?
    var weChatNum: String?
    
    var agentNumber: String?
    var laiaiNumber: Int?
    var laiaiUserId: Int?
    var merchantUser: Bool?
    /// 保证金状态 0-没交， 1-已交
    var marginStatus: MarginStatus?
    /// 是否是经销商
    var agentFlag: Bool?
    /// 身份证
    var cardNum: String?
    /// 是否有注册送券
    var haveRegisterCoupons: Bool?
    /// 是否绑定手机号(通联)
    var isPhoneChecked: Bool?
    /// 绑定通联的手机号
    var phone: String?
    /// 是否通联实名认证
    var isIdentityChecked: Bool?
    /// 是否签约
    var isSignContract: Bool?
//    var isRealNameVerify: Bool? /// 是否实名认证, 已废弃
    var cartSwitchType: CartSwitchType? // 用于记录购物车展示tab,0代表来艾商品tab，1代表海外购tab
    var shopStatus: GiftBuyStatus? // 店铺状态 0未开店， 1已开店
    var shopGrade: ShopGrade?
    
    var signinFlag: Bool?   // 积分签到提醒开关
    /// 极光推送签到开关tag
    var signinRemindTag: String {
        return "signinRemindTag"
    }
    
    enum Gender: Int, Codable {
        case unknow = 0
        case man = 1
        case woman = 2
        
        var toString: String? {
            switch self {
            case .unknow:
                return nil
            case .man:
                return "男"
            case .woman:
                return "女"
            }
        }
    }
    
    enum CartSwitchType: Int, Codable {
        case laiai = 0
        case oversea = 1
    }
    
    enum MarginStatus: Int, Codable {
        case unpay = 0      // 未交
        case payoff = 1     // 已交
    }
    enum GiftBuyStatus: Int, Codable {
        case unbuy = 0      // 未开店
        case alreadyBuy = 1     // 已开店
    }
    enum ShopGrade: Int, Codable {
        case unknow = 0
        case normal = 1 // 普通店主
        case gold = 2 // 金牌店主
        
        init(rawValue: Int) {
            switch rawValue {
            case 1: self = .normal
            case 2: self = .gold
            default: self = .unknow
            }
        }
        
        var image: UIImage? {
            switch self {
            case .unknow: return nil
            case .normal: return UIImage(named: "mine_normal")
            case .gold: return UIImage(named: "mine_gold")
            }
        }
    }
}


class CMUser: NSObject {
    
    static let shared = CMUser()
    
    private var privateInfo: UserInfo?
    private var privateScore: Int = 0
    
    class var score: Int {
        get {
            return CMUser.shared.privateScore
        }
        set {
            CMUser.shared.privateScore = newValue
            NotificationCenter.default.post(name: NotificationName.userScoreChange, object: newValue)
        }
    }
    
    class var info: UserInfo? {
        set(newValue){
            CMUser.shared.privateInfo = newValue
            if let userId = newValue?.infraUserId {
                CMUser.cacheUserId = userId
            }
        }
        get{
            return CMUser.shared.privateInfo
        }
    }
    
    class var isLogin: Bool {
        return CMUser.accessToken.count > 0
    }
    class var accessToken: String {
        set(value) {
            UserDefaults.standard.set(value, forKey: CMXAccessToken)
        }
        get{
           return UserDefaults.standard.string(forKey: CMXAccessToken) ?? ""
        }
    }
    class var userId: String {
        return CMUser.info?.infraUserId?.toString ?? CMUser.cacheUserId?.toString ?? ""
    }
    
    
    class var isTapDragSortCommodityTip: Bool {
        return UserDefaults.standard.bool(forKey: "isTapDragSortCommodityTip")
    }

    class func logOut() {
        self.accessToken = ""
        CMUser.cacheUserId = nil
        
        // 清理广告缓存记录
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.lastLaunchAdvertiseDay)
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.lastLaunchAdvertiseIndex)
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.lastHomeAdvertiseIndex)
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.lastHomeAdvertiseDay)
        UserDefaults.standard.synchronize()
    }

    class var cacheUserId: Int? {
        get {
            return UserDefaults.standard.integer(forKey: UserDefaultKey.cacheUserId)
        }
        set {
            UserDefaults.standard.set(newValue ?? 0, forKey: UserDefaultKey.cacheUserId)
            UserDefaults.standard.synchronize()
        }
    }
}
