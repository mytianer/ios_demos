//
//  Date+Extension.swift
//  LaiAi
//
//  Created by DongYuan on 2018/7/23.
//  Copyright © 2018年 Jim1024. All rights reserved.
//

import Foundation


extension Date {

    public var year: Int {
        return Calendar.current.component(Calendar.Component.year, from: self)
    }
    
    public var month: Int {
        return Calendar.current.component(Calendar.Component.month, from: self)
    }
    
    public var day: Int {
        return Calendar.current.component(Calendar.Component.day, from: self)
    }

    public init?(fromString string: String, format: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        if let date = formatter.date(from: string) {
            self = date
        } else {
            return nil
        }
    }

    public func toString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    var dayString: String {
        let dateFormatter = DateFormatter()
        let calendar = Calendar.current
        let unitSet:Set<Calendar.Component> = [.year, .month, .day]
        let comp1 = calendar.dateComponents(unitSet, from: self)
        let comp2 = calendar.dateComponents(unitSet, from: Date())
        
        if comp1.year == comp2.year, comp1.month == comp2.month {
            let offsetDay = comp2.day! - comp1.day!
            switch offsetDay {
            case 0:
                dateFormatter.dateFormat = "HH:mm"
            case 1:
                dateFormatter.dateFormat = "昨天"
            case 2:
                dateFormatter.dateFormat = "前天"
            default:
                dateFormatter.dateFormat = "yyyy-MM-dd"
            }
        } else {
            dateFormatter.dateFormat = "yyyy-MM-dd"
        }
        return dateFormatter.string(from: self)
    }
    
    
    mutating func add(_ componet: Calendar.Component, value: Int) {
        switch componet {
        case .second, .minute, .hour, .day, .month, .year:
            self = Calendar.current.date(byAdding: componet, value: value, to: self) ?? self
            
        case .weekOfYear, .weekOfMonth:
            self = Calendar.current.date(byAdding: .day, value: value * 7, to: self) ?? self
            
        default:
            break
        }
    }
}
