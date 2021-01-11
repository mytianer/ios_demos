//
//  Promise+Extension.swift
//  LaiAi
//
//  Created by DongYuan on 2019/5/16.
//  Copyright © 2019 Laiai. All rights reserved.
//

import Foundation
import Kingfisher
import Promises


extension Promise {
    
    class func downloadImage(for url: String) -> Promise<UIImage> {
        let promise = Promise<UIImage>.pending()
        KingfisherManager.shared.retrieveImage(with: URL(string: url) ?? URL(fileURLWithPath: ""), options: nil, progressBlock: nil) { (image, error, _, _) in
            if let img = image {
                promise.fulfill(img)
            }
            if let err = error {
                promise.reject(err)
            }
        }
        return promise
    }
    
    class func saveImageInAlbum(image: UIImage) -> Promise<Void> {
        let promise = Promise<Void>.pending()
//        PhotoAlbumUtil.saveImageInAlbum(image: image, albumName: "优市") { res in
//            switch res {
//            case .success:
//                promise.fulfill(())
//            case .denied:
//                promise.reject(PhotoError.denied)
//            case .error:
//                promise.reject(PhotoError.error(str: ""))
//            }
//        }
        return promise
    }
    
}
