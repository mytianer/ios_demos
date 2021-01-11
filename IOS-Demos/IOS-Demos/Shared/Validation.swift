//
//  Validation.swift
//  LaiAi
//
//  Created by DongYuan on 2019/1/10.
//  Copyright © 2019 Laiai. All rights reserved.
//

import Foundation


enum ValidationResult {
    case success
    case fail(msg: String)
}

struct Validation {
    
    static func validatePhone(_ phone: String) -> ValidationResult {
        if phone.count == 0 {
            return .fail(msg: "请输入手机号")
        }
        
        if phone.count != 11 {
            return .fail(msg: "请正确填写手机号")
        }
        
        let pattern = "^[0-9]+$"
        let matcher = MyRegex(pattern)
        if matcher.match(phone) == false {
            return .fail(msg: "请正确填写手机号")
        }
        return ValidationResult.success
    }
    
    static func validateIdCard(_ number: String) -> ValidationResult {
        if number.count == 0 {
            return .fail(msg: "请输入身份证")
        }
        
        let pattern = "(^[1-9]\\d{5}(18|19|([23]\\d))\\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\\d{3}[0-9Xx]$)|(^[1-9]\\d{5}\\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\\d{2}[0-9Xx]$)"
        let matcher = MyRegex(pattern)
        if matcher.match(number) == false {
            return .fail(msg: "请正确填写身份证号")
        }
        return ValidationResult.success
    }
    
    static func validateRealName(_ name: String) -> ValidationResult {
        if name.count == 0 {
            return .fail(msg: "请输入姓名")
        }
        if name.count < 1 || name.count > 5 {
            return .fail(msg: "请输入1~5个字符的姓名")
        }
        
        let pattern = "^[a-zA-Z\\u4e00-\\u9fa5]+$"
        let matcher = MyRegex(pattern)
        if matcher.match(name) == false {
            return .fail(msg: "姓名只能包含字母、汉字")
        }
        return ValidationResult.success
    }
    
    static func validateEmail(_ str: String) -> ValidationResult {
        let mailPattern = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
        let matcher = MyRegex(mailPattern)
        if !matcher.match(str) {
            return .fail(msg: "邮箱格式不正确")
        }
        return ValidationResult.success
    }
    
    static func validateWechat(_ str: String) -> ValidationResult {
        let mailPattern = "^[a-zA-Z0-9]{1}[-_a-zA-Z0-9]{5,19}+$"
        let matcher = MyRegex(mailPattern)
        if !matcher.match(str) {
            return .fail(msg: "微信号不正确")
        }
        return ValidationResult.success
    }
    
}
