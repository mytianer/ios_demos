//
//  NewVersionUpgradeController.swift
//  AAT
//
//  Created by DongYuan on 2018/4/12.
//  Copyright © 2018年 YiXue. All rights reserved.
//

import UIKit

class NewVersionUpgradeController: UIViewController {

    var newVersionInfo: Model.NewAppVersion?
    
    @IBOutlet weak var closeBun: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var confirmBtn: UIButton!
    
    var nextBlock: EmptyBlock?
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        confirmBtn.setBackgroundImage(UIImage.colors(colors: [R.color.primary()!, R.color.secondary()!],
                                                     size: confirmBtn.size), for: .normal)
        infoLabel.text = newVersionInfo?.fuction?.replacingOccurrences(of: "\\n", with: "\n")
        if newVersionInfo?.isForce == 1 {
            closeBun.isHidden = true
        }
    }

    
    @IBAction func closeClick(_ sender: Any) {
        self.dismiss(animated: true){
            self.nextBlock?()
        }
    }
    
    
    @IBAction func upgradeClick(_ sender: Any) {
        if let url = URL(string: newVersionInfo?.downloadUrl ?? ""), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }

}
