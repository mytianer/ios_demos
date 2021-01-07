//
//  UILabel+Extension.swift
//  LaiAi
//
//  Created by Ryan on 2019/9/11.
//  Copyright © 2019 Laiai. All rights reserved.
//

import UIKit

private var LabelGradientLayerKey: Void?
private var LabelGradientLabelKey: Void?

extension UILabel {
    
    var textGradientLayer: CAGradientLayer? {
        get {
            return objc_getAssociatedObject(self, &LabelGradientLayerKey) as? CAGradientLayer
        }
        set {
            objc_setAssociatedObject(self, &LabelGradientLayerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var textGradientLabel: UILabel? {
        get {
            return objc_getAssociatedObject(self, &LabelGradientLabelKey) as? UILabel
        }
        set {
            objc_setAssociatedObject(self, &LabelGradientLabelKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    func setGradientTextColor(colors: [UIColor],
                              starPoint: CGPoint = CGPoint(x: 0.5, y: 0),
                              endPoint: CGPoint = CGPoint(x: 0.5 , y: 1.0),
                              locations: [Float]? = nil) {
        textColor = UIColor.clear
        guard let gradientLayer = self.textGradientLayer, let label = textGradientLabel else {
            // label
            let label = UILabel()
            label.frame = bounds
            label.font = font
            label.text = text
            label.textAlignment = textAlignment
            self.textGradientLabel = label
            addSubview(label)
            
            // layer
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = bounds
            gradientLayer.startPoint = starPoint
            gradientLayer.endPoint = endPoint
            gradientLayer.colors = colors.map({$0.cgColor})
            self.textGradientLayer = gradientLayer
            
            layer.addSublayer(gradientLayer)
            gradientLayer.mask = label.layer
            return
        }
        label.frame = bounds
        gradientLayer.frame = label.bounds
        gradientLayer.startPoint = starPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.colors = colors.map({$0.cgColor})
    }
}
