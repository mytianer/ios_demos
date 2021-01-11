//
//  AdvertisementController.swift
//  LaiAi
//
//  Created by DongYuan on 2018/7/23.
//  Copyright © 2018年 Jim1024. All rights reserved.
//

import UIKit


class AdvertisementController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    
    private let imageTap = UITapGestureRecognizer()
    
    var info = Model.AdModel()
    var adverImage = UIImage()
    
    private let maxWidth = SCREEN_WIDTH - 60
    private let maxHeight = SCREEN_HEIGHT - 200
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageTap.addTarget(self, action: #selector(self.tapAdver))
        imageView.addGestureRecognizer(imageTap)
        
        
        var newImage: UIImage?
        
        if adverImage.size.width / adverImage.size.height > self.maxWidth / self.maxHeight {
            newImage = adverImage.scale(self.maxWidth)
        } else {
            newImage = adverImage.scale(self.maxHeight)
        }
        self.imageView.image = newImage
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: {
                self.imageViewHeight.constant = newImage?.size.height ?? 0
                self.view.layoutIfNeeded()
            })
        }
        
    }
    
    @IBAction func didClickCloseBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @objc func tapAdver() {
//        let vc = Router.resolveTargetController(from: info.showUrl ?? "")
//        self.dismiss(animated: true) {
//            if let targetVc = vc {
//                Router.shared.currentViewCotroller?.navigationController?.show(targetVc, sender: nil)
//            }
//        }
    }
    

}
