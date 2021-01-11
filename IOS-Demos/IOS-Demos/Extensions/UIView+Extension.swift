//
//  UIView+Extension.swift
//  LaiAi
//
//  Created by 李瀚 on 2018/4/24.
//  Copyright © 2018年 Jim1024. All rights reserved.
//

import UIKit

private var GradientLayerKey: Void?

extension UIView {
    
    var gradientLayer: CAGradientLayer? {
        get {
            return objc_getAssociatedObject(self, &GradientLayerKey) as? CAGradientLayer
        }
        
        set {
            objc_setAssociatedObject(self, &GradientLayerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func addRoundedOrShadow(radius:CGFloat, shadowOpacity:CGFloat, shadowColor:UIColor)  {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        let subLayer = CALayer()
        let fixframe = self.frame
        let newFrame = CGRect(x: fixframe.minX + 5, y: fixframe.minY, width: fixframe.width - 30, height: fixframe.height - 23)
        subLayer.frame = newFrame
        subLayer.cornerRadius = radius
        subLayer.backgroundColor = R.color.surface()?.cgColor
        subLayer.masksToBounds = false
        subLayer.shadowColor = shadowColor.cgColor // 阴影颜色
        subLayer.shadowOffset = CGSize(width: 0, height: 0) // 阴影偏移,width:向右偏移3，height:向下偏移2，默认(0, -3),这个跟shadowRadius配合使用
        subLayer.shadowOpacity = Float(shadowOpacity) //阴影透明度
        subLayer.shadowRadius = 5;//阴影半径，默认3
        self.superview?.layer.insertSublayer(subLayer, below: self.layer)
    }
    
    func setGradientBackgroundColor(colors: [UIColor],
                                    starPoint: CGPoint = CGPoint(x: 0, y: 0.5),
                                    endPoint: CGPoint = CGPoint(x: 1 , y: 0.5),
                                    locations: [Float]? = nil) {
        guard let gradientLayer = self.gradientLayer else {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = bounds
            gradientLayer.startPoint = starPoint
            gradientLayer.endPoint = endPoint
            gradientLayer.colors = colors.map({$0.cgColor})
            self.gradientLayer = gradientLayer
            layer.insertSublayer(gradientLayer, at: 0)
            return
        }
        gradientLayer.frame = bounds
        gradientLayer.startPoint = starPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.colors = colors.map({$0.cgColor})
    }

    /// 设置圆角
    @IBInspectable var cornerRadius: CGFloat {
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = true
        }
        get {
            return self.layer.cornerRadius
        }
    }
    
    /// 设置边框宽度
    @IBInspectable var borderWidth: CGFloat {
        set {
            self.layer.borderWidth = newValue
        }
        get {
            return self.layer.borderWidth
        }
    }
    
    /// 设置边框颜色
    @IBInspectable var borderColor: UIColor {
        set {
            self.layer.borderColor = newValue.cgColor
        }
        get {
            return UIColor(cgColor: self.layer.borderColor ?? UIColor.clear.cgColor)
        }
    }
    
    
    /// EZSwiftExtensions - Make sure you use  "[weak self] (gesture) in" if you are using the keyword self inside the closure or there might be a memory leak
    public func addTapGesture(tapNumber: Int = 1, action: ((UITapGestureRecognizer) -> Void)?) {
        let tap = BlockTap(tapCount: tapNumber, fingerCount: 1, action: action)
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
    
    public var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    public var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    /** 宽 */
    public var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    
    /** 高 */
    public var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    /** 下 */
    public var bottom: CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }
        
        set {
            var frame = self.frame
            frame.origin.y = newValue - self.frame.size.height
            self.frame = frame
        }
    }
    
    /** 右 */
    public var right: CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width
        }
        
        set {
            var frame = self.frame
            frame.origin.x = newValue - self.frame.size.width
            self.frame = frame
        }
    }
    /** 尺寸 */
    public var size: CGSize {
        get {
            return self.frame.size
        }
        
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
    }
    
    /** 竖直中心对齐 */
    public var centerX: CGFloat {
        get {
            return self.center.x
        }
        
        set {
            var center = self.center
            center.x = newValue
            self.center = center
        }
    }
    /** 水平中心对齐 */
    public var centerY: CGFloat {
        get {
            return self.center.y
        }
        
        set {
            var center = self.center
            center.y = newValue
            self.center = center
        }
    }
    
    public func roundCorners(_ corners: UIRectCorner, radius: CGFloat, roundedRect: CGRect? = nil) {
        let theRoundedRect = (roundedRect != nil) ? roundedRect! : self.bounds
        let path = UIBezierPath(roundedRect: theRoundedRect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius,
                                                    height: radius))
        guard let cornerMask = self.layer.mask as? CAShapeLayer else {
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
            return
        }
        cornerMask.path = path.cgPath
    }
    
}

extension UIView {
    
    func removeSubviews() {
        self.subviews.forEach{ $0.removeFromSuperview() }
    }
}

extension UIView {
    
    func scaleShake() {
        layer.removeAnimation(forKey: "scaleShake")
        let anim = CAKeyframeAnimation(keyPath: "transform.scale")
        anim.values = [0.98, 1.1, 1.0, 0.98]
        anim.duration = 1.0
        anim.repeatCount = MAXFLOAT
        anim.isRemovedOnCompletion = false
        layer.add(anim, forKey: "scaleShake")
    }
    
    func angleShake() {
        layer.removeAnimation(forKey: "angleShake")
        layer.anchorPoint = CGPoint(x: 0.0, y: 1.0)
        let anim = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        anim.values = [Double.pi / 15, 0.0, -Double.pi / 15, 0.0, Double.pi / 15]
        anim.duration = 1.2
        anim.repeatCount = MAXFLOAT
        anim.isRemovedOnCompletion = false
        layer.add(anim, forKey: "angleShake")
    }
    
}



