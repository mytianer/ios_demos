//
//  UIColor+CMKit.swift
//  LaiAi
//
//  Created by DongYuan on 2018/5/17.
//  Copyright © 2018年 Jim1024. All rights reserved.
//

extension CMKit where Base == UIColor {

    /// 333333
    static var primaryText: UIColor {
        return UIColor.hex(0x333333)
    }
    
    /// 666666
    static var secondaryText: UIColor {
        return UIColor.hex(0x666666)
    }
    
    /// 999999
    static var thirdText: UIColor {
        return UIColor.hex(0x999999)
    }
    
    
    /// E60012
    static var primary: UIColor {
        return UIColor.hex(0xE60012)
    }
    
    /// F64C25
    static var primaryVariant: UIColor {
        return UIColor.hex(0xF64C25)
    }
    
    /// F39800
    static var secondary: UIColor {
        return UIColor.hex(0xF39800)
    }
    
    /// FCC43C
    static var secondaryVariant: UIColor {
        return UIColor.hex(0xFCC43C)
    }
    
    /// 932FE3
    static var third: UIColor {
        return UIColor.hex(0x932FE3)
    }
    
    
    /// F0F0F0
    static var background: UIColor {
        return UIColor.hex(0xF0F0F0)
    }
    
    /// FAFAFA
    static var surface: UIColor {
        return UIColor.hex(0xFAFAFA)
    }
    
    /// DDDDDD
    static var onBackground: UIColor {
        return UIColor.hex(0xDDDDDD)
    }
    
    /// F3F3F3
    static var cellBackgroud: UIColor {
        return UIColor.hex(0xF3F3F3)
    }
    
    /// 6403BD
    static var four: UIColor {
        return UIColor.hex(0x6403BD)
    }
    
    /// 8D30E3
    static var fourVariant: UIColor {
        return UIColor.hex(0x8D30E3)
    }
    
    /// E8E8E8
    static var line: UIColor {
        return UIColor.hex(0xE8E8E8)
    }
}



extension CMKit where Base == UIColor {
    
    // 礼包购买成功背景
    /// F1B974
    static var orangeF1B974: UIColor {
        return UIColor.hex(0xF1B974)
    }
    
    
    // 银行卡管理
    /// 91C5F8
    static var blue91C5F8: UIColor {
        return UIColor.hex(0x91C5F8)
    }
    
    /// 486AC1
    static var blue486AC1: UIColor {
        return UIColor.hex(0x486AC1)
    }
    
    /// 89A3E2
    static var blue89A3E2: UIColor {
        return UIColor.hex(0x89A3E2)
    }
    
    
    // 设置白色view的透明度，不影响子view 的透明度
    static func clearBgWithAlpha(_ alpha: CGFloat,color:UIColor = UIColor.black) -> UIColor {
       return color.withAlphaComponent(alpha)
    }
    
    
    /// 红色背景渐变 店铺、我的首页头部
    static var bgGradientRedColors: [UIColor] {
        return [UIColor.hexValue("D02E30"), UIColor.hexValue("F8481F")]
    }
    
    /// 灰色按钮渐变
    static var btnGradientGrayColors: [UIColor] {
        return [UIColor.hex(0xBEBEBE), UIColor.hex(0xA0A0A0), UIColor.hex(0x848484)]
    }
    
    
    // 蓝紫色渐变
    static var btnGradientBlueColors: [UIColor] {
        return [UIColor.cm.four, UIColor.cm.fourVariant]
    }
    
    // 蓝紫色渐变
    static var btnDisableGradientBlueColors: [UIColor] {
        return [UIColor.cm.four.withAlphaComponent(0.5), UIColor.cm.fourVariant.withAlphaComponent(0.5)]
    }
    
    
    /// 黄色按钮渐变
    static var btnGradientYellowColors: [UIColor] {
        return [UIColor.cm.primaryVariant, UIColor.cm.secondary]
    }
    
    /// 黄色按钮渐变
    static var btnDisableGradientYellowColors: [UIColor] {
        return [UIColor.cm.primaryVariant.withAlphaComponent(0.5), UIColor.cm.secondary.withAlphaComponent(0.5)]
    }
    
    /// 红色按钮渐变
    static var btnGradientRedColors: [UIColor] {
        return [UIColor.cm.primary, UIColor.cm.primaryVariant]
    }
    
    /// 红色按钮渐变
    static var btnDisableGradientRedColors: [UIColor] {
        return [UIColor.cm.primary.withAlphaComponent(0.5), UIColor.cm.primaryVariant.withAlphaComponent(0.5)]
    }
}
