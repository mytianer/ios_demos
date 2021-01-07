//
//  UINavigationBar+Extension.swift
//  AAT
//
//  Created by DongYuan on 2018/5/15.
//  Copyright © 2018年 YiXue. All rights reserved.
//

import UIKit



extension UINavigationBar {
    
    var shadowImageLine: UIImageView? {
        return findNavigationbarLine(form: self)
    }
    
    private func findNavigationbarLine(form view: UIView) -> UIImageView? {
        if view is UIImageView && view.frame.size.height <= 1 {
            return view as? UIImageView
        }
        
        for vw in view.subviews {
            if let imageView = findNavigationbarLine(form: vw) {
                return imageView
            }
        }
        
        return nil
    }
    
}

