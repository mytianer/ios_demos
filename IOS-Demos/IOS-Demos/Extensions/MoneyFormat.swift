//
//  MoneyFormat.swift
//  AAT
//
//  Created by 李瀚 on 2018/4/8.
//  Copyright © 2018年 YiXue. All rights reserved.
//

import Foundation


extension Double {
    
    func moneyFormatStr(cutDecimal: Bool = false) -> String {
        if !cutDecimal {
            return "￥\(self.twoDecimalFormat)"
        }
        return (Int(self * 100) % 100 == 0)
            ? "￥\(self.toInt)"
            : "￥\(self.shortDecimalFormat)"
//            : "￥\(self.twoDecimalFormat)"
    }
    
    /*
     cutDecimal, true, 去掉小数则取整，有小数则显示小数; false, 显示小数
     color，字体颜色
     fontSize, 字体大小
     weightType，字体规格
     unitFontSize, nil, ￥字体大小直接去fontSize
     decimalFontSize, nil, 小数部分字体大小
     strikeStyle，是否划线价
     */
    func attributedMoney(cutDecimal: Bool = false,
                         color: UIColor,
                         fontSize: CGFloat,
                         weightType: UIFont.WeightType = .regular,
                         unitFontSize: CGFloat? = nil,
                         decimalFontSize: CGFloat? = nil,
                         strikeStyle: Bool = false) -> NSMutableAttributedString {
        
        return toString.attributedMoney(cutDecimal: cutDecimal,
                                        color: color,
                                        fontSize: fontSize,
                                        weightType: weightType,
                                        unitFontSize: unitFontSize,
                                        decimalFontSize: decimalFontSize,
                                        strikeStyle: strikeStyle)
    }
    
    
    func moneyFormat() -> String {
        return "￥\(self.twoDecimalFormat)"
    }
    
    func attributedTextMoneyFormat() -> NSMutableAttributedString {
        let aString = NSMutableAttributedString(string: "")
        let money = NSAttributedString(string: "¥", attributes: [NSAttributedString.Key.font: UIFont(name: "PingFangSC-Medium", size: 12) ?? UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.cm.primary])
        let amount = NSAttributedString(string: self.twoDecimalFormat, attributes: [NSAttributedString.Key.font: UIFont(name: "PingFangSC-Semibold", size: 18) ?? UIFont.systemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.cm.primary])
        aString.append(money)
        aString.append(amount)
        return aString
    }
    
}

extension Float {
    
    func moneyFormat() -> String {
        return "￥\(Double(self).twoDecimalFormat)"
    }
    
}

extension String {
    
    func moneyFormatStr(cutDecimal: Bool = false) -> String {
        return (self.filter{ $0 != "￥"}.toDouble() ?? 0.00).moneyFormatStr(cutDecimal: cutDecimal)
    }
    
    func attributedMoney(cutDecimal: Bool = false,
                         color: UIColor,
                         fontSize: CGFloat,
                         weightType: UIFont.WeightType = .regular,
                         unitFontSize: CGFloat? = nil,
                         decimalFontSize: CGFloat? = nil,
                         strikeStyle: Bool = false) -> NSMutableAttributedString {
        var theAmount = self.filter{ $0 != "￥"}
        if let theAmountDouble = theAmount.toDouble() {
            theAmount = theAmountDouble.moneyFormatStr(cutDecimal: cutDecimal).filter{ $0 != "￥" }
        }
        
        let aString = NSMutableAttributedString(string: "")
        
        // ￥字体变化
        let money = NSAttributedString(string: "¥",
                                       attributes: [.font: UIFont.pingFangSC(size: (unitFontSize == nil ? fontSize : unitFontSize!), weightType),
                                                    .foregroundColor: color])
        aString.append(money)
        
        let componets = theAmount.components(separatedBy: ".")
        if let decimalSize = decimalFontSize, componets.count == 2 {
            // 小数字体变化
            let round = NSAttributedString(string: componets.first! + ".",
                                               attributes: [.font: UIFont.pingFangSC(size: fontSize, weightType),
                                                            .foregroundColor: color])
            aString.append(round)
            let decimal = NSAttributedString(string: componets.last!,
                                             attributes: [.font: UIFont.pingFangSC(size: decimalSize, weightType),
                                                          .foregroundColor: color])
            aString.append(decimal)
            
        } else {
            let amount = NSAttributedString(string: theAmount,
                                            attributes: [.font: UIFont.pingFangSC(size: fontSize, weightType),
                                                         .foregroundColor: color])
            aString.append(amount)
        }
        
        if strikeStyle {
            aString.addAttributes([.strikethroughStyle : 1], range: NSRange(location: 0, length: aString.length))
        }
        
        return aString
    }
    
    
    func moneyFormat() -> String {
        return "￥\(self.toDouble()?.twoDecimalFormat ?? "0.00")"
    }
    
    func twoDecimalFormat() -> String {
        return self.toDouble()?.twoDecimalFormat ?? "0.00"
    }
    
    func attributedTextMoneyFormat() -> NSMutableAttributedString {
        let aString = NSMutableAttributedString(string: "")
        let money = NSAttributedString(string: "¥", attributes: [NSAttributedString.Key.font: UIFont(name: "PingFangSC-Medium", size: 12) ?? UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.cm.primary])
        let amount = NSAttributedString(string: self.twoDecimalFormat(), attributes: [NSAttributedString.Key.font: UIFont(name: "PingFangSC-Semibold", size: 18) ?? UIFont.systemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.cm.primary])
        aString.append(money)
        aString.append(amount)
        return aString
    }
}

