//
//  UICollectionView+Extension.swift
//  LaiAi
//
//  Created by Ryan on 2019/9/11.
//  Copyright © 2019 Laiai. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    
    func indexPath(in responder: UIResponder) -> IndexPath? {
        var indexPath: IndexPath?
        
        var next = responder.next
        while next != nil {
            if let cell = next as? UICollectionViewCell {
                indexPath = self.indexPath(for: cell)
                break
            } else {
                next = next?.next
            }
        }
        
        return indexPath
    }
}
