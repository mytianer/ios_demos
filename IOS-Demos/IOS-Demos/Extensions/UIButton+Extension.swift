//
//  UIButton+Extension.swift
//  LaiAi
//
//  Created by Yixue_ZhangWentong on 2018/6/20.
//  Copyright © 2018年 Jim1024. All rights reserved.
//

import Foundation
import UIKit

extension UIButton{
    
    func set(image: UIImage?, title: String, titlePosition: UIView.ContentMode, additionalSpacing: CGFloat, state: UIControl.State) {
        self.setImage(image, for: state)
        self.setTitle(title, for: state)
        
        positionLabelRespectToImage(titleSize: self.titleLabel?.intrinsicContentSize ?? CGSize.zero,
                                    imageSize: image?.size ?? CGSize.zero,
                                    position: titlePosition,
                                    spacing: additionalSpacing)
    }
    
    private func positionLabelRespectToImage(titleSize: CGSize, imageSize: CGSize, position: UIView.ContentMode, spacing: CGFloat) {
        var titleInsets: UIEdgeInsets
        var imageInsets: UIEdgeInsets
        
        let bunWidth = self.frame.size.width
        assert(bunWidth > 0, "请先设置Button的Frame，Width大于0")
        
        switch position {
        case .top:
            if titleSize.width + imageSize.width > bunWidth {
                titleInsets = UIEdgeInsets(top: -(imageSize.height + spacing) / 2,
                                           left: -imageSize.width,
                                           bottom: (imageSize.height + spacing) / 2,
                                           right: 0)
                imageInsets = UIEdgeInsets(top: (spacing + titleSize.height) / 2,
                                           left: (bunWidth - imageSize.width) / 2,
                                           bottom: -(spacing + titleSize.height) / 2,
                                           right: -(bunWidth - imageSize.width) / 2)
            }else{
                titleInsets = UIEdgeInsets(top: -(imageSize.height + spacing) / 2,
                                           left: -imageSize.width / 2,
                                           bottom: (imageSize.height + spacing) / 2,
                                           right: imageSize.width / 2)
                imageInsets = UIEdgeInsets(top: (spacing + titleSize.height) / 2,
                                           left: titleSize.width / 2,
                                           bottom: -(spacing + titleSize.height) / 2,
                                           right: -titleSize.width / 2)
            }
        case .bottom:
            if titleSize.width + imageSize.width > bunWidth {
                titleInsets = UIEdgeInsets(top: (imageSize.height + spacing) / 2,
                                           left: -imageSize.width,
                                           bottom: -(imageSize.height + spacing) / 2,
                                           right: 0)
                imageInsets = UIEdgeInsets(top: -(spacing + titleSize.height) / 2,
                                           left: (bunWidth - imageSize.width) / 2,
                                           bottom: (spacing + titleSize.height) / 2,
                                           right: -(bunWidth - imageSize.width) / 2)
            }else{
                titleInsets = UIEdgeInsets(top: (imageSize.height + spacing) / 2,
                                           left: -imageSize.width / 2,
                                           bottom: -(imageSize.height + spacing) / 2,
                                           right: imageSize.width / 2)
                imageInsets = UIEdgeInsets(top: -(spacing + titleSize.height) / 2,
                                           left: titleSize.width / 2,
                                           bottom: (spacing + titleSize.height) / 2,
                                           right: -titleSize.width / 2)
            }
        case .left:
            titleInsets = UIEdgeInsets(top: 0,
                                       left: -(imageSize.width + spacing / 2),
                                       bottom: 0,
                                       right: imageSize.width + spacing / 2)
            imageInsets = UIEdgeInsets(top: 0,
                                       left: titleSize.width + spacing / 2,
                                       bottom: 0,
                                       right: -(titleSize.width + spacing / 2))
        case .right:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        default:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        self.titleEdgeInsets = titleInsets
        self.imageEdgeInsets = imageInsets
    }
    
}


extension UIButton {
    
    private struct AssociatedKeys {
        static var normalBgColorKey = "UIButton.normalBgColorKey"
        static var highlightBgColorKey = "UIButton.highlightBgColorKey"
        static var selectedBgColorKey = "UIButton.selectedBgColorKey"
        
        static var structModeKey = "UIButton.structModeKey"
        static var structIntervalKey = "UIButton.structIntervalKey"
    }
    
    @IBInspectable var normalBgColor: UIColor? {
        get {
            return objc_getAssociatedObject(self,
                                            &AssociatedKeys.normalBgColorKey) as? UIColor
        }
        set {
            objc_setAssociatedObject(self,
                                     &AssociatedKeys.normalBgColorKey,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            var image: UIImage?
            if let color = newValue {
                image = UIImage.createImage(color)
                backgroundColor = nil
            }
            setBackgroundImage(image, for: .normal)
        }
    }
    
    @IBInspectable var highlightBgColor: UIColor? {
        get {
            return objc_getAssociatedObject(self,
                                            &AssociatedKeys.highlightBgColorKey) as? UIColor
        }
        set {
            objc_setAssociatedObject(self,
                                     &AssociatedKeys.highlightBgColorKey,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            var image: UIImage?
            if let color = newValue {
                image = UIImage.createImage(color)
                backgroundColor = nil
            }
            setBackgroundImage(image, for: .highlighted)
        }
    }
    
    @IBInspectable var selectedBgColor: UIColor? {
        get {
            return objc_getAssociatedObject(self,
                                            &AssociatedKeys.selectedBgColorKey) as? UIColor
        }
        set {
            objc_setAssociatedObject(self,
                                     &AssociatedKeys.selectedBgColorKey,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            var image: UIImage?
            if let color = newValue {
                image = UIImage.createImage(color)
                backgroundColor = nil
            }
            setBackgroundImage(image, for: .selected)
        }
    }
}

extension UIButton {
    
    enum StructMode: Int {
        case leftImageRightText = 0
        case leftTextRightImage = 1
        case topTextBottomImage = 2
        case topImageBottomText = 3
    }
    
    /// 图文结构
    @IBInspectable var structMode: Int {
        get {
            return objc_getAssociatedObject(self,
                                            &AssociatedKeys.structModeKey) as? Int ?? 0
        }
        set {
            objc_setAssociatedObject(self,
                                     &AssociatedKeys.structModeKey,
                                     newValue,
                                     .OBJC_ASSOCIATION_ASSIGN)
            layoutStruct()
        }
    }
    
    /// 空隙
    @IBInspectable var structInterval: CGFloat {
        get {
            return objc_getAssociatedObject(self,
                                            &AssociatedKeys.structIntervalKey) as? CGFloat ?? 0.0
        }
        set {
            objc_setAssociatedObject(self,
                                     &AssociatedKeys.structIntervalKey,
                                     newValue,
                                     .OBJC_ASSOCIATION_ASSIGN)
            layoutStruct()
        }
    }
    
    func layoutStruct() {
        guard let title = currentTitle, let titleLabel = self.titleLabel else { return }
        let titleSize = title.size(withAttributes: [NSAttributedString.Key.font: titleLabel.font])
        
        switch StructMode(rawValue: structMode) ?? .leftImageRightText {
        case .leftImageRightText:
            titleEdgeInsets = UIEdgeInsets(top: 0,
                                           left: structInterval,
                                           bottom: 0,
                                           right: 0)
            imageEdgeInsets = UIEdgeInsets(top: 0,
                                           left: -structInterval,
                                           bottom: 0,
                                           right: 0)
            
        case .leftTextRightImage:
            titleEdgeInsets = UIEdgeInsets(top: 0,
                                           left: -((imageView?.frame.width ?? 0) + structInterval / 2.0),
                                           bottom: 0,
                                           right: (imageView?.frame.width ?? 0) + structInterval / 2.0)
            
            imageEdgeInsets = UIEdgeInsets(top: 0,
                                           left: titleSize.width + structInterval / 2.0,
                                           bottom: 0,
                                           right: -(titleSize.width + structInterval / 2.0))
            
        
            
        case .topTextBottomImage:
            titleEdgeInsets = UIEdgeInsets(top: -((imageView?.frame.height ?? 0) + structInterval) / 2.0,
                                           left: -(imageView?.frame.width ?? 0),
                                           bottom: ((imageView?.frame.height ?? 0) + structInterval) / 2.0,
                                           right: 0)
            imageEdgeInsets = UIEdgeInsets(top: (titleSize.height + structInterval) / 2.0,
                                           left: 0,
                                           bottom: -(titleSize.height + structInterval) / 2.0,
                                           right: -titleSize.width)
            
        case .topImageBottomText:
            titleEdgeInsets = UIEdgeInsets(top: ((imageView?.frame.height ?? 0) + structInterval) / 2.0,
                                           left: -(imageView?.frame.width ?? 0),
                                           bottom: -((imageView?.frame.height ?? 0) + structInterval) / 2.0,
                                           right: 0)
            imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + structInterval) / 2.0,
                                           left: 0,
                                           bottom: (titleSize.height + structInterval) / 2.0,
                                           right: -titleSize.width)
        }
    }
    
    
}

