//
//  Int+Extension.swift
//  LaiAi
//
//  Created by DongYuan on 2018/5/18.
//  Copyright © 2018年 Jim1024. All rights reserved.
//

import Foundation


extension Int {
    
    var toString: String {
        return String(self)
    }
    
    var toDouble: Double {
        return Double(self)
    }
    
    var toBool: Bool {
        return self == 1 ? true : false
    }
}

extension Bool {
    
    public var toInt: Int {
        return self ? 1 : 0
    }
}
