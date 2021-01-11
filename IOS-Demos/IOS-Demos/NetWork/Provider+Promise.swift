//
//  MoyaProvider.swift
//  LaiAi
//
//  Created by wenjingjie on 2018/4/26.
//  Copyright © 2018年 Jim1024. All rights reserved.
//

import Foundation
import Moya
import Promises

extension MoyaProvider: CMKitCompatible { }

extension CMKit where Base: MoyaProviderType {
    
    func request(_ target: Base.Target, callbackQueue: DispatchQueue? = .none, progress: ProgressBlock? = .none) -> Promise<Response> {
        let res = Promise<Response>.pending()
        _ = base.request(target, callbackQueue: callbackQueue, progress: progress) { result in
            switch result{
            case .success(let value):
                res.fulfill(value)
            case .failure(let error):
                res.reject(error)
            }
        }
        return res
    }
}

