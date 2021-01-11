//
//  Error.swift
//  LaiAi
//
//  Created by DongYuan on 2018/5/19.
//  Copyright © 2018年 Jim1024. All rights reserved.
//

import Foundation


enum CMError: Swift.Error, CustomStringConvertible {
    
    case api(codeMsg: Model.CodeMsg)
    
    var description: String {
        switch self {
        case .api(let cm):
            return "api 错误: code: \(cm.code ?? ""), msg: \(cm.msg ?? "")"
        }
    }
}

enum PhotoError: Swift.Error, CustomStringConvertible {
    case denied
    case error(str: String)
    
    var description: String {
        switch self {
        case .denied:
            return "请打开相册访问权限"
        case .error(let str):
            return str
        }
    }
}
