//
//  CMPresentSegue.swift
//  LaiAi
//
//  Created by DongYuan on 2018/10/8.
//  Copyright © 2018 Laiai. All rights reserved.
//

import UIKit
import QuartzCore


class CMPresentSegue: UIStoryboardSegue {
    
    override func perform() {
        let source = self.source
        let destination = self.destination
        
        source.present(destination, animated: true)
    }
    
}
