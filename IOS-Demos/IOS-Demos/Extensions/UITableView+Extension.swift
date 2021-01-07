//
//  UITableView+Extension.swift
//  LaiAi
//
//  Created by Ryan on 2018/10/11.
//  Copyright © 2018年 Laiai. All rights reserved.
//

import UIKit

extension UITableView {
    
    func indexPath(in responder: UIResponder) -> IndexPath? {
        var indexPath: IndexPath?
        
        var next = responder.next
        while next != nil {
            if let cell = next as? UITableViewCell {
                indexPath = self.indexPath(for: cell)
                break
            } else {
                next = next?.next
            }
        }
        
        return indexPath
    }
}
