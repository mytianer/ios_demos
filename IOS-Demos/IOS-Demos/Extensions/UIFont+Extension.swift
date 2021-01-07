//
//  UIFont+Extension.swift
//  LaiAi
//
//  Created by DongYuan on 2018/10/17.
//  Copyright © 2018 Laiai. All rights reserved.
//

import UIKit


extension UIFont {
    
    enum WeightType {
        case regular
        case medium
        case semibold
    }
    
    class func pingFangSC(size: CGFloat, _ type: WeightType = .regular) -> UIFont {
        switch type {
        case .regular:
            return UIFont(name: "PingFangSC-Regular", size: size) ?? UIFont.boldSystemFont(ofSize: size)
        case .medium:
            return UIFont(name: "PingFangSC-Medium", size: size) ?? UIFont.boldSystemFont(ofSize: size)
        case .semibold:
            return UIFont(name: "PingFangSC-Semibold", size: size) ?? UIFont.boldSystemFont(ofSize: size)
        }
    }
    
    
    
}
