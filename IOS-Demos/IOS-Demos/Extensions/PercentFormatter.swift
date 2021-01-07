//
//  PercentFormatter.swift
//  LaiAi
//
//  Created by 李瀚 on 2018/4/27.
//  Copyright © 2018年 Jim1024. All rights reserved.
//

import Foundation

extension NumberFormatter {
    static let precentFormatter: NumberFormatter = {
        let fm = NumberFormatter()
        fm.numberStyle = .percent
        fm.minimumFractionDigits = 0
        fm.maximumFractionDigits = 2
        return fm
    }()
}

protocol PrecentFormat {
    func precentFormat() -> String?
}

extension Double: PrecentFormat {
    func precentFormat() -> String? {
        return NumberFormatter.precentFormatter.string(from: NSNumber(value: self))
    }
}

extension Int: PrecentFormat {
    func precentFormat() -> String? {
        return NumberFormatter.precentFormatter.string(from: NSNumber(value: self))
    }
}

extension String: PrecentFormat {
    func precentFormat() -> String? {
        guard let num = NumberFormatter().number(from: self) else { return nil}
        return NumberFormatter.precentFormatter.string(from: num)
    }
}
