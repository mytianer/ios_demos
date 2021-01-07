//
//  Double+Extension.swift
//  LaiAi
//
//  Created by DongYuan on 2018/5/19.
//  Copyright © 2018年 Jim1024. All rights reserved.
//

import Foundation


extension Double {

    var toInt: Int {
        return Int(self)
    }
    var toString: String {
        return String(self)
    }
    
    var twoDecimalFormat: String { // 保留小数点后两位
        return String(format: "%.2f", self)
    }
    
    // 2  2.3  2.31
    var shortDecimalFormat: String {
        var theValue = String(format: "%.2f", self)
        if theValue.hasSuffix("0") {
            theValue = String(format: "%.1f", self)
        }
        if theValue.hasSuffix("0") {
            theValue = toInt.toString
        }
        return theValue
    }
    
    //MARK: -根据后台时间戳返回几分钟前，几小时前，几天前
    func updateTimeToCurrennTime() -> String {
        //获取当前的时间戳
        let currentTime = Date().timeIntervalSince1970
        //时间戳为毫秒级要 ／ 1000， 秒就不用除1000，参数带没带000
        let timeSta:TimeInterval = TimeInterval(self / 1000)
        //时间差
        let reduceTime : TimeInterval = currentTime - timeSta
        //时间差小于60秒
        if reduceTime < 60 {
            return "刚刚"
        }
        //时间差大于一分钟小于60分钟内
        let mins = Int(reduceTime / 60)
        if mins < 60 {
            return "\(mins)分钟前"
        }
        //时间差大于一小时小于24小时内
        let hours = Int(reduceTime / 3600)
        if hours < 24 {
            return "\(hours)小时前"
        }
        //时间差大于一天小于30天内
        let days = Int(reduceTime / 3600 / 24)
        if days < 30 {
            return "\(days)天前"
        }
        //不满足上述条件---或者是未来日期-----直接返回日期
        let date = NSDate(timeIntervalSince1970: timeSta)
        let dfmatter = DateFormatter()
        //yyyy-MM-dd HH:mm:ss
        dfmatter.dateFormat="yyyy年MM月dd日 HH:mm:ss"
        return dfmatter.string(from: date as Date)
    }

}
