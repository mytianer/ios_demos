//
//  Api+Login.swift
//  LaiAi
//
//  Created by wenjingjie on 2018/4/27.
//  Copyright © 2018年 Jim1024. All rights reserved.
//

import Moya
import Promises

extension Api {
    
    class Login {
        
        fileprivate static let defaultProvider = DefaultProvider<API>()
        
        //        统一命名标准  增删改查 -> add delete update fetch
        fileprivate enum API {
            case loginIn(userName:String, password: String)
            case fetchUserInfo
            case fetchNewAppVersion
            /// 获取广告列表 position: 1品类banner 2开屏APP弹窗广告 3开机广告 4支付页面广告位 14积分抽奖入口ƒ
            case fetchAdvertisementBanner(position: Int)
        }
        
    }
}


extension Api.Login {
    
    //        app版本检查更新
    final class func fetchNewAppVersion() -> Promise<Model.NewAppVersion> {
        return defaultProvider.cm.request(.fetchNewAppVersion)
            .filterCodeMsg()
            .map(Model.NewAppVersion.self, atKeyPath: "data")
    }
    
    final class func loginIn(userName:String,password:String) -> Promise<String> {
        return defaultProvider.cm.request(.loginIn(userName:userName, password:password))
            .filterCodeMsg()
            .map(String.self, atKeyPath: "data.accessToken")
    }
    
    final class func fetchUserInfo() -> Promise<Any> {
         return defaultProvider.cm.request(.fetchUserInfo)
            .filterCodeMsg()
            .mapJson()
    }
    
    /// 获取广告列表 position: 1品类banner 2开屏APP弹窗广告 3开机广告 4支付页面广告位
    static func fetchAdvertisementBanner(position: Int) -> Promise<[Model.AdModel]> {
        return defaultProvider.cm.request(.fetchAdvertisementBanner(position: position))
            .filterCodeMsg()
            .map([Model.AdModel].self, atKeyPath: "data")
    }
    
}

extension Api.Login.API: AccessTokenAuthorizable {
    var authorizationType: AuthorizationType? {
        return .none
    }
}

extension Api.Login.API: TargetTypeDescription {
    var description: String {
        switch self {
        case .fetchNewAppVersion:
            return "获取新版本"
        case .loginIn:
            return "登录"
        case .fetchUserInfo:
            return "获取用户信息"
        case .fetchAdvertisementBanner:
            return "获取广告列表"
        }
    }
}


extension Api.Login.API: TargetType {
    public var baseURL: URL {
        return URL(string: Api.BaseURL.gateway)!
    }
    
    public var path: String {
        switch self {
        case .fetchNewAppVersion:
            return "laiai-ys-marketing/api/marketing/common/getAppUpdateUrl"
       case .loginIn:
            return "laiai-ys-passport/api/passport/passwordLogin"
        case .fetchUserInfo:
            return "laiai-ys-member/api/infra/user/findUser"
        
        case .fetchAdvertisementBanner:
            return "laiai-ys-re/api/commonBanner/list"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case
             .loginIn,
             .fetchUserInfo:
            return .post
        default:
            return .get
        }
    }
    
    public var task: Task {
        switch self {
        case .fetchNewAppVersion:
            let currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
            return .requestParameters(parameters: ["type": 1,
                                                   "appVersion": "ios-" + currentVersion,
                                                   "isTest": 1],
                                      encoding: URLEncoding.queryString)
            
        case .loginIn(let userName, let password):
            return .requestParameters(parameters: ["userName": userName,
                                                   "password": password],
                                      encoding: URLEncoding.queryString)
       
        case .fetchAdvertisementBanner(let position):
            return .requestParameters(parameters: ["position": position],
                                      encoding: URLEncoding.queryString)
            
        default:
            return .requestPlain
        }
    }
    
    public var validate: Bool {
        return false
    }
    
    public var headers: [String: String]? {
        return nil
    }
    
    public var sampleData: Data {
        switch self {
        default:
            return "{}".data(using: .utf8) ?? Data()
        }
    }
    
}
