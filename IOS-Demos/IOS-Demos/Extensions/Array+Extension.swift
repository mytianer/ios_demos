//
//  Array+Extension.swift
//  LaiAi
//
//  Created by DongYuan on 2018/5/24.
//  Copyright © 2018年 Jim1024. All rights reserved.
//

import Foundation

extension Array {

    func getElementAt(_ index: Int) -> Element? {
        if self.count > index {
            return self[index]
        }
        return nil
    }

}
