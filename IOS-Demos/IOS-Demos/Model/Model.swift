//
//  Model.swift
//  LaiAi
//
//  Created by 李瀚 on 2018/4/25.
//  Copyright © 2018年 Jim1024. All rights reserved.
//

import Foundation

struct Model {}

extension Model {
    
    /// 广告targetType = 3时，活动类型 1 满减 2 满折 3 满送（赠商品+赠送券+送积分) 4 换购 5：N元任选 12：买送
    enum AdActivityType: Int, Codable {
        case none = 0
        case overMinus = 1
        case overDiscount = 2
        case overGive = 3
        case change = 4
        case nChoice = 5
        case giftBuy = 12
        
        init(rawValue: Int) {
            switch rawValue {
            case 1: self = .overMinus
            case 2: self = .overDiscount
            case 3: self = .overGive
            case 4: self = .change
            case 5: self = .nChoice
            case 12: self = .giftBuy
            default: self = .none
            }
        }
    }
}

extension Model {
    
    struct CodeMsg: Codable {
        var code: String?
        var msg: String?
    }

    struct NewAppVersion: Codable {
        var versionName: String?
        var id: Int?
        var updateTime: String?
        var fuction: String?
        var type: String?
        var isForce: Int?
        var downloadUrl: String?
    }
    
    struct AdModel: Codable {
        var id: Int?
        var sort: Int?
        /// 图片地址
        var imgUrl: String?
        /// 跳转的地址、参数
        var targetSource: String?
        /// 1 满减 2 满折 3 满送（赠商品+赠送券+送积分) 4 换购 5：N元任选
        var activityType: AdActivityType?
        var showUrl: String?
    }
    
    enum ImageType: String {
        case logo
        case background
        case commodityPic
        case detailPic
        case commentPic
        case afterSale
    }
    
    
}
