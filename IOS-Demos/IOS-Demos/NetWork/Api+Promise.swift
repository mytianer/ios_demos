//
//  Api+Promise.swift
//  LaiAi
//
//  Created by DongYuan on 2018/5/17.
//  Copyright © 2018年 Jim1024. All rights reserved.
//

import Promises
import Moya

extension Promise where Value: Response {
    
    func filterCodeMsg() -> Promise<Value> {
        return then { res in
            if let codeMsg = try? res.map(Model.CodeMsg.self) {
                if codeMsg.code == "4004" {
//                    CMUser.logOut()
                }
//                if codeMsg.success == false {
//                    throw CMError.api(codeMsg: codeMsg)
//                }
            }
        }
    }
    
    func map<D: Decodable>(_ type: D.Type, atKeyPath keyPath: String? = nil, using decoder: JSONDecoder = JSONDecoder()) -> Promise<D> {
        return then { res in
            try res.map(type, atKeyPath: keyPath, using: decoder)
        }
    }
    
    func mapJson() -> Promise<Any> {
        return then { res in
            try res.mapJSON()
        }
    }
    
}


extension Promise {
    
    @discardableResult
    func catchApiError(_ showError: Bool = true, excute: @escaping (Model.CodeMsg) -> () = {_ in}) -> Promise {
        return self.catch { error in
            if let er = error as? CMError {
                if case .api(let codeMsg) = er {
                    if showError {
                        if let msg = codeMsg.msg, msg != "" {
//                            ProgressHUD.show(msg)
                        }
                    }
                    excute(codeMsg)
                }
            } else{
//                if error.localizedDescription.contains("断开与互联网的连接") {
//                    ProgressHUD.show("网络连接失败，请检查您的联网状态")
//                }
//
//                #if LAIAI_TEST
//                Log.warning(error, "接口错误", "详情", 0)
//                Log.warning(error.localizedDescription, "接口错误", "描述", 0)
//                #endif
            }
        }
    }
    
}
