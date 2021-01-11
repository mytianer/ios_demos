//
//  ImagePicker.swift
//  AAT
//
//  Created by DongYuan on 2017/10/30.
//  Copyright © 2017年 YiXue. All rights reserved.
//

import UIKit
import AVFoundation
import Photos


class ImagePicker: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var target: UIViewController?
    private var photoCallback: ((UIImage) -> Void)?
    
    func selectPhoto(with target: UIViewController, soureType: UIImagePickerController.SourceType, allowsEditing: Bool = true, callback: @escaping ((UIImage) -> Void)) {
        self.target = target
        self.photoCallback = callback
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = allowsEditing
        
        if soureType == .camera {
            if cameraPermissions() {
                if UIImagePickerController.isSourceTypeAvailable(soureType) {
                    imagePickerController.sourceType = soureType
                    if #available(iOS 11.0, *) {
                        UIScrollView.appearance().contentInsetAdjustmentBehavior = .automatic
                    }
                    self.target?.present(imagePickerController, animated: true)
                }
            }else{
                self.showPermissionSetting(with: soureType)
            }
        }else if soureType == .photoLibrary {
            if photoPermissions() {
                if UIImagePickerController.isSourceTypeAvailable(soureType) {
                    imagePickerController.sourceType = soureType
                    if #available(iOS 11.0, *) {
                        UIScrollView.appearance().contentInsetAdjustmentBehavior = .automatic
                    }
                    self.target?.present(imagePickerController, animated: true)
                }
            }else{
                self.showPermissionSetting(with: soureType)
            }
        }
    }
    
    private func showPermissionSetting(with type: UIImagePickerController.SourceType) {
        var strAlertTitle = ""
    
        if type == .camera {
            strAlertTitle = "请打开相机访问权限"
        }else{
            strAlertTitle = "请打开相册访问权限"
        }
        
        let vc = UIAlertController(title: nil, message: strAlertTitle, preferredStyle: .alert)
        let action1 = UIAlertAction(title: "取消", style: .default)
        let action2 = UIAlertAction(title: "设置", style: .default) { action in
            
            let url = URL(string: UIApplication.openSettingsURLString) ?? URL(fileURLWithPath: "")
            UIApplication.shared.openURL(url)
        }
        vc.addAction(action1)
        vc.addAction(action2)
        self.target?.present(vc, animated: true)
    }

    private func photoPermissions() -> Bool {
        let authStatus =  PHPhotoLibrary.authorizationStatus()
        
        if(authStatus == .denied || authStatus == .restricted) {
            return false
        }
        return true
    }
    
    private func cameraPermissions() -> Bool {
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        if(authStatus == .denied || authStatus == .restricted) {
            return false
        }
        return true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true){
            if #available(iOS 11.0, *) {
                UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
            }
            if picker.allowsEditing == true {
                if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                    self.photoCallback?(image.scale(UIScreen.main.bounds.width))
                }
            }else{
                if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                    self.photoCallback?(image.scale(UIScreen.main.bounds.width))
                }
            }
        }
    }
    
    
}

