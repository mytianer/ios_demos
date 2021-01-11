//
//  TargetType+ Description.swift
//  LaiAi
//
//  Created by DongYuan on 2018/11/27.
//  Copyright © 2018 Laiai. All rights reserved.
//

import Moya


protocol TargetTypeDescription {
    
    var description: String { get }
    
}

extension TargetType {
    
    var description: String {
        get {
            if let target = self as? TargetTypeDescription {
                return target.description
            }
            return ""
        }
    }

}
