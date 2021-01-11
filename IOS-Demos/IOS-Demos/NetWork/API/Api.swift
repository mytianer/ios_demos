//
//  Api.swift
//  LaiAi
//
//  Created by 李瀚 on 2018/4/26.
//  Copyright © 2018年 Jim1024. All rights reserved.
//

import Foundation


struct Api {
    
    static var config = Environment.develop(url: "http://ys-gateway-develop.lai-ai.com")
//    static var config = Environment.distribution
    
    enum Environment {
        case develop(url: String)
        case distribution
    }

    struct BaseURL {
        
        static var gateway: String {
            switch Api.config {
            case .develop(let url):
                return url
            case .distribution:
                return ""
            }
        }
        
    }
    
}
