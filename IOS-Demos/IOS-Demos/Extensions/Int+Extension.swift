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
    
    /// EZSE: Converts integer value to Double.
    public var toDouble: Double { return Double(self) }
    
    public var toBool: Bool {
        return self == 1 ? true : false
    }
    
    func toString(length: Int = 0) -> String {
        let remind = length - toString.count
        if remind > 0 {
            var target = toString
            for _ in 0..<remind {
                target = "0" + target
            }
            return target
        } else {
            return toString
        }
    }
}

extension Bool {
    
    public var toInt: Int {
        return self ? 1 : 0
    }
}
