//
//  String+Extension.swift
//  LaiAi
//
//  Created by DongYuan on 2018/5/19.
//  Copyright © 2018年 Jim1024. All rights reserved.
//

import UIKit

extension String {
    
    var addPrefix: String {
        let htmlPrefix = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header><div style='vertical-align : bottom'>\(self)</div>"
        return htmlPrefix
    }
    
    /// EZSE: Checks if string is empty or consists only of whitespace and newline characters
    public var isBlank: Bool {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty
    }
    
    var stringContainEmoji: Bool{
        let startIndex:String.Index = self.startIndex
        let endIndex:String.Index = self.endIndex
        let strRange = Range<String.Index>(uncheckedBounds: (startIndex,endIndex))
        let range = self.range(of: "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]", options: .regularExpression, range: strRange, locale: nil)
        return range != nil
    }
    
    var containsEmoji: Bool { // 包含表情
        for scalar in unicodeScalars {
            switch scalar.value {
            case
            0x00A0...0x00AF,
            0x2030...0x204F,
            0x2120...0x213F,
            0x2190...0x21AF,
            0x2310...0x329F,
            0x1F000...0x1F9CF:
                return true
            default:
                continue
            }
        }
        return false
    }
    
    var isOnlyContainNumberLetterChineseFormat: Bool { // 只能输入数字、字母、汉字、标点符号、 空格
        let pattern = "^[\\u4E00-\\u9FA5A-Za-z0-9（）,，。？！，、；：“”‘’《》{}—.?!,;:\"\"()-......·.•。！!:：():：—\\-+ ]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: self)
//        let matcher = MyRegex(pattern)
//        return matcher.match(self)
    }
    
    var isOnlyContainNumberLetterSymbolFormat: Bool { // 只能输入数字、字母、标点符号、 空格
        let pattern = "^[A-Za-z0-9（）,，。？！，、；：“”‘’《》{}—.?!,;:\"\"()-......·.•。！!:：():：—\\-+ ]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: self)
    }
    
    var isWechatIdFormat: Bool { // 微信号是否合法
        let pattern = "^[a-zA-Z0-9]{1}[-_a-zA-Z0-9]{5,19}+$" //只能输入字母、数字、下划线、减号，以字母或数字开头 6-20位
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: self)
    }
    
    var isOnlyContainNumberLetterChinese: Bool { // 只能输入数字、字母、汉字
        let pattern = "^[\\u4E00-\\u9FA5A-Za-z0-9]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: self)
    }
    
    var isOnlyContainNumberLetterFormat: Bool { // 只能输入数字、字母
        let pattern = "^[A-Za-z0-9]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: self)
    }
    
    var isOnlyNumberFormat: Bool { // 只能输入数字
        let pattern = "^[0-9]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: self)
    }
    
    var isOnlyNumberDotFormat: Bool { // 只能输入数字、点
        let pattern = "^[0-9.]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: self)
    }
    
//    var isContainSpeical: Bool { // 包含特殊字符
//        return false
//    }
    
    var isContainBlank: Bool { // 包含空格
        return self.contains(" ")
    }
    
    public func addToPasteboard() {
        let pasteboard = UIPasteboard.general
        pasteboard.string = self
    }
    
    // 截取前strNum个字符,后面拼接...
    func getPreString(strNum: Int)->String {
        if self.count > strNum {
            let index = self.index(self.startIndex, offsetBy:strNum)
            return "\(self[self.startIndex...index])..."
        }
        return self
    }
    
    // 截取前strNum个字符
    func getPrefix(strNum: Int)->String {
        if self.count > strNum  {
            let index = self.index(self.startIndex, offsetBy:(strNum - 1))
            return "\(self[self.startIndex...index])"
        }
        return self
    }
    
    // 截取前strNum个字符，并加...
    func getPrefixWithDot(strNum: Int)->String {
        if self.count > strNum {
            let index = self.index(self.startIndex, offsetBy:strNum - 1)
            return "\(self[self.startIndex...index])..."
        }
        return self
    }
    
    // 返回手机号中间隐藏四位
    var getCipherPhoneString: String {
        var subFourString = String()
        var preString = String()
        if self.count > 3 {
            preString = (self as NSString).substring(to: 3)
        }
        if self.count > 4 {
            subFourString = (self as NSString).substring(from: self.count - 4)
        }
        return "\(preString)****\(subFourString)"
    }
    
    // 返回手机号后四位
    var getSubFourString: String {
        if self.count > 4 {
            return (self as NSString).substring(from: self.count - 4)
        }
        return ""
    }
    
    // 返回身份证号前2位后4位，中间隐藏
    var getChpherIdNumberString: String {
        var subFourString = String()
        var preString = String()
        if self.count > 2 {
            preString = (self as NSString).substring(to: 2)
        }
        if self.count > 4 {
            subFourString = (self as NSString).substring(from: self.count - 4)
        }
        return "\(preString)************\(subFourString)"
    }
    
//    var md5 : String{
//        let str = self.cString(using: String.Encoding.utf8)
//        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
//        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
//        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
//
//        CC_MD5(str!, strLen, result)
//
//        let hash = NSMutableString()
//        for i in 0 ..< digestLen {
//            hash.appendFormat("%02x", result[i])
//        }
//        //        result.deinitialize()
//        let lowStr = String(format: hash as String)
//        return lowStr.uppercased()
//    }
    
    var isIDCard: Bool {
        let pattern = "(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        return pred.evaluate(with: self)
    }
    
    //真实姓名
    var isRealNameFormat: Bool {
        let pattern = "(^[\\u4e00-\\u9fa5][\\u4e00-\\u9fa5 · •]*[\\u4e00-\\u9fa5]$)|^[\\u4e00-\\u9fa5]$"
        let matcher = MyRegex(pattern)
        if matcher.match(self) == false {
            return false
        }
        return true
    }
    
    public func toInt() -> Int? {
        if let num = NumberFormatter().number(from: self) {
            return num.intValue
        } else {
            return nil
        }
    }
    
    public func toDouble() -> Double? {
        if let num = NumberFormatter().number(from: self) {
            return num.doubleValue
        } else {
            return nil
        }
    }
    
    public func toFloat() -> Float? {
        if let num = NumberFormatter().number(from: self) {
            return num.floatValue
        } else {
            return nil
        }
    }
    
    var isChinese: Bool {
        let pattern = "[\\u4e00-\\u9fa5]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: self)
    }
    
    var isPhoneNumber: Bool {
        return self.count == 11
//        let pattern = "^1+[1234567890]+\\d{9}"
//        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
//        return pred.evaluate(with: self) && self.count == 11
    }
    
    var isEmail: Bool {
        let pattern = "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$"
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        return pred.evaluate(with: self)
    }
    
    // 返回只显示银行CGFloat位
    var getFourBankNumber: String {
        var subFourString = String()
        if self.count > 4 {
            subFourString = (self as NSString).substring(from: self.count - 4)
        }
//        return "****  ****  ****  \(subFourString)"
        return subFourString
    }
    
    ///EZSE: Returns hight of rendered string
    public func height(_ width: CGFloat, font: UIFont, lineBreakMode: NSLineBreakMode?) -> CGFloat {
        var attrib: [NSAttributedString.Key: AnyObject] = [NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): font]
        if lineBreakMode != nil {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = lineBreakMode!
            attrib.updateValue(paragraphStyle, forKey: NSAttributedString.Key(rawValue: NSAttributedString.Key.paragraphStyle.rawValue))
        }
        let size = CGSize(width: width, height: CGFloat(Double.greatestFiniteMagnitude))
        return ceil((self as NSString).boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes:attrib, context: nil).height)
    }
    
    ///EZSE: Returns hight of rendered string
    public func width(_ maxWidth: CGFloat, fontSize: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineSpacing = 2
//        paragraphStyle.lineBreakMode = .byWordWrapping
        let attribute = [NSAttributedString.Key.font: font]
       return self.boundingRect(with: CGSize(width: maxWidth, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attribute, context: nil).size.width
    }
    
    public func width(_ maxWidth: CGFloat, font: UIFont) -> CGFloat {
        let attribute = [NSAttributedString.Key.font: font]
        return self.boundingRect(with: CGSize(width: maxWidth, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attribute, context: nil).size.width
    }
    
    //使用正则表达式替换
    func replace(withRegex pattern: String, with: String, options: NSRegularExpression.Options = []) -> String {
        let regex = try! NSRegularExpression(pattern: pattern, options: options)
        return regex.stringByReplacingMatches(in: self,
                                              options: [],
                                              range: NSMakeRange(0, self.count),
                                              withTemplate: with)
    }
    
    func removeEmoji() -> String {
        let pattern = "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"
        return self.replace(withRegex: pattern, with: "")
    }
    
    // MARK: 获取某一天所在的周一和周日
    func relativeDateStringForDate() -> String {
        let dateFormatterx = DateFormatter()
        dateFormatterx.locale = Locale(identifier: "zh_CN")
        dateFormatterx.dateFormat = "eeee yyyy-MM-dd HH:mm:ss"
        
        guard let date = dateFormatterx.date(from: dateFormatterx.string(from: Date())) else {return "今天"}
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "zh_CN")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let nowDate = dateFormatter.date(from: self) ?? Date()
        let nowWeekDay = dateFormatterx.string(from: nowDate).components(separatedBy: " ").first ?? "今天"
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.day,.weekOfYear,.weekday,.month,.year], from: nowDate, to: date)
        
        let yearx = comp.year ?? 0
        let dayx = comp.day ?? 0
        let weekdayx = comp.weekday ?? 0
        let weekOfYearx = comp.weekOfYear ?? 0
        let monthx = comp.month ?? 0
        if yearx > 0 {
            return "\(yearx)年前"
        }else if monthx > 0{
            return "\(monthx)月前"
        }else if weekOfYearx > 0{
            return "\(weekOfYearx)周前"
        }else if dayx > 0 {
            if dayx > 1{
                if weekdayx > 6{
                    return "\(dayx)天前"
                }else{
                    return nowWeekDay
                }
            }else{
                return "昨天"
            }
        }else{
            return "今天"
        }
    }

}

extension String {
    
    private static let dateFormat = DateFormatter()
    
    /// 字符串转日期
    func toDate(_ format: String) -> Date? {
        String.dateFormat.dateFormat = format
        return String.dateFormat.date(from: self)
    }
    
    // xxxx-xx-xx 转成 xxxx.xx.xx
    var getDotDate: String {
        if self.count >= 10 {
            let str = self.getPrefix(strNum: 10)
            let date = str.toDate("yyyy.MM.dd")
            return date?.toString(format: "yyyy.MM.dd") ?? ""
        } else {
            return self
        }
    }
}
