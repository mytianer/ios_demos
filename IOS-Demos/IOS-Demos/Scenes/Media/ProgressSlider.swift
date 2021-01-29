//
//  ProgressSlider.swift
//  AAT
//
//  Created by DongYuan on 2017/12/27.
//  Copyright © 2017年 YiXue. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ProgressSlider: UISlider {

    var isSliding = false
    var slidingSubject = PublishSubject<Bool>()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.isSliding = true
        slidingSubject.onNext(true)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        self.isSliding = true
        slidingSubject.onNext(true)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.isSliding = false
        slidingSubject.onNext(false)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.isSliding = false
        slidingSubject.onNext(false)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.point(inside: point, with: event) == false {
            return nil
        }
        
        return self
    }
    
}


