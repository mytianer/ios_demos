//
//  UIColor+Extension.swift
//  LaiAi
//
//  Created by DongYuan on 2018/6/1.
//  Copyright © 2018年 Jim1024. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor {
        return UIColor.init(red: r / 255,
                            green: g / 255,
                            blue: b / 255,
                            alpha: 1.0)
    }
    
    static func hex(_ Hex: UInt32) -> UIColor {
        return UIColor.init(red: CGFloat((Hex & 0xFF0000) >> 16) / 255.0,
                            green: CGFloat((Hex & 0xFF00) >> 8) / 255.0,
                            blue: CGFloat((Hex & 0xFF)) / 255.0,
                            alpha: 1.0)
    }
    
    /// 随机颜色
    static func random() -> UIColor {
        return UIColor(red: CGFloat(arc4random_uniform(256)) / 255.0,
                       green: CGFloat(arc4random_uniform(256)) / 255.0,
                       blue: CGFloat(arc4random_uniform(256)) / 255.0, alpha: 1.0)
    }
    
    
    class func hexValue(_ hexColor: String) -> UIColor {
        return self.hexValueWithAlpha(hexColor, alpha: 1.0)
    }
    
    class func hexValueWithAlpha(_ hexColor: String, alpha: CGFloat? = 1.0) -> UIColor {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = alpha ?? 1.0
        
        let scanner = Scanner(string: hexColor)
        var hexComponent: CUnsignedLongLong = 0
        let scannerResult: Bool = scanner.scanHexInt64(&hexComponent)
        
        func verifyHexValue() -> Bool {
            let length = hexColor.count
            if (length == 3 || length == 6) && scannerResult {
                return true
            } else {
                return false
            }
        }
        
        let checkResult = verifyHexValue()
        assert(checkResult, "Invalid Hex Color Value")
        
        switch hexColor.count {
        case 3:
            red = CGFloat((hexComponent & 0xF00) >> 8 * 17) / 255.0
            green = CGFloat((hexComponent & 0x0F0) >> 4 * 17) / 255.0
            blue = CGFloat(hexComponent & 0x00F * 17) / 255.0
        case 6:
            red = CGFloat((hexComponent & 0xFF0000) >> 16) / 255.0
            green = CGFloat((hexComponent & 0x00FF00) >> 8) / 255.0
            blue = CGFloat(hexComponent & 0x0000FF) / 255.0
        default:
            red = 1.0
            green = 1.0
            blue = 1.0
        }
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
