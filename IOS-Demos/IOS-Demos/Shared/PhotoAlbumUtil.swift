//
//  PhotoAlbumUtil.swift
//  LaiAi
//
//  Created by wenjingjie on 2018/7/23.
//  Copyright © 2018年 Jim1024. All rights reserved.
//

import Photos
import UIKit

//操作结果枚举
enum PhotoAlbumUtilResult {
    case success, error, denied
}

//相册操作工具类
class PhotoAlbumUtil: NSObject {
    
    class func showSavePhotoActionSheet(image: UIImage, currentVc: UIViewController) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let saveAction = UIAlertAction(title: "保存到相册", style: .default) { (_) in
            self.saveImageInAlbum(image: image, albumName: "优市") { (result) in
                switch result{
                case .success:
                    ProgressHUD.show("保存成功")
                case .denied:
                    ProgressHUD.show("保存失败，请设置相册权限")
                case .error:
                    ProgressHUD.show("保存失败，请稍后再试")
                }
            }
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        currentVc.present(alertController, animated: true)
    }
    
    // 请求权限
    class func requestAuthorization(_ handler: ((_ result: Bool) -> Void)?) {
        switch PHPhotoLibrary.authorizationStatus() {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (status) in
                handler?(status == .authorized)
            }
        case .denied, .restricted:
            handler?(false)
            showPermissionSetting()
        case .authorized:
            handler?(true)
        @unknown default:
            handler?(false)
        }
    }
    
    //判断是否授权
    class func isAuthorized() -> Bool {
        return PHPhotoLibrary.authorizationStatus() == .authorized ||
            PHPhotoLibrary.authorizationStatus() == .notDetermined
    }
    
    private class func showPermissionSetting() {
        let vc = UIAlertController(title: nil, message: "请打开相册访问权限", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "取消", style: .default)
        let action2 = UIAlertAction(title: "设置", style: .default) { action in
            let url = URL(string: UIApplication.openSettingsURLString) ?? URL(fileURLWithPath: "")
            UIApplication.shared.openURL(url)
        }
        vc.addAction(action1)
        vc.addAction(action2)
        Router.shared.currentViewCotroller?.present(vc, animated: true)
    }
    
    //保存图片到相册
    class func saveImageInAlbum(image: UIImage,
                                albumName: String = "",
                                completion: ((PhotoAlbumUtilResult) -> ())? = nil) {
        
        //权限验证
        if !isAuthorized() {
            self.showPermissionSetting()
            return
        }
        var assetAlbum: PHAssetCollection?
        
        //如果指定的相册名称为空，则保存到相机胶卷。（否则保存到指定相册）
        if albumName.isEmpty {
            let list = PHAssetCollection.fetchAssetCollections(with: .smartAlbum,
                                                               subtype: .smartAlbumUserLibrary,
                                                               options: nil)
            assetAlbum = list.firstObject
        } else {
            //看保存的指定相册是否存在
            let list = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
            list.enumerateObjects({ (album, index, stop) in
                if albumName == album.localizedTitle {
                    assetAlbum = album
                    stop.initialize(to: true)
                }
            })
            //不存在的话则创建该相册
            if assetAlbum == nil {
                PHPhotoLibrary.shared().performChanges({
                    PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
                }, completionHandler: { (isSuccess, error) in
                    if isSuccess && error == nil {
                        self.saveImageInAlbum(image: image,
                                              albumName: albumName,
                                              completion: completion)
                    }else {
                        print("创建相册失败----", error.debugDescription)
                        self.saveImageInAlbum(image: image,
                                              completion: completion)
                    }
                })
                return
            }
        }
        
        //保存图片
        PHPhotoLibrary.shared().performChanges({
            //添加的相机胶卷
            let result = PHAssetChangeRequest.creationRequestForAsset(from: image)
            //是否要添加到相簿
            if !albumName.isEmpty {
                guard let assetPlaceholder = result.placeholderForCreatedAsset else {return}
                let albumChangeRequest = PHAssetCollectionChangeRequest(for: assetAlbum!)
                albumChangeRequest?.addAssets([assetPlaceholder]  as NSArray)
            }
        }) { (isSuccess: Bool, error: Error?) in
            if isSuccess {
                completion?(.success)
            } else{
                completion?(.error)
            }
        }
    }
}

