//
//  ProgressHUD.swift
//  LaiAi
//
//  Created by wenjingjie on 2018/5/9.
//  Copyright © 2018年 Jim1024. All rights reserved.
//

import UIKit

enum AlertType {
    case progress
    case show
    case confirm
    case upload
    case noImageConfirm
}

public class ProgressHUD: UIView {
    
    private var activityIndicator = UIActivityIndicatorView()
    private var textLab = UILabel()
    private var containerView = UIView()
    private var imageView = UIImageView()
    private var lineView = UIView()
    private var okButton = UIButton()
    private static let shareView = ProgressHUD()
    
    public class func show(_ status: String, progress: Float = 1.5, userInteractionEnabled: Bool = false) {
        if status.replacingOccurrences(of: " ", with: "").count == 0 { return }
        self.dismiss()
        DispatchQueue.main.async {
            self.frontWindow()?.endEditing(true)
            
            let str = NSString(string: status)
            let font = UIFont.systemFont(ofSize: 15)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 2
            paragraphStyle.lineBreakMode = .byWordWrapping
            let attribute = [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: paragraphStyle.copy()]
            let size = str.boundingRect(with: CGSize(width: SCREEN_WIDTH - 180, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attribute, context: nil).size
            
            shareView.frame = CGRect(x: 0, y: 0, width: size.width + 60, height: size.height + 40)
            shareView.layer.cornerRadius = 6
            shareView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            self.frontWindow()?.addSubview(shareView)
            self.frontWindow()?.isUserInteractionEnabled = userInteractionEnabled
            shareView.textLab.frame = CGRect(x: 15, y: 20, width: size.width + 30, height: size.height)
            shareView.textLab.textColor = UIColor.white
            shareView.textLab.numberOfLines = 0
            shareView.textLab.textAlignment = .center
            shareView.textLab.font = UIFont.systemFont(ofSize: 15)
            shareView.addSubview(shareView.textLab)
            shareView.center = self.frontWindow()?.center ?? CGPoint.zero
            
            let paraph = NSMutableParagraphStyle()
            paraph.lineSpacing = 2
            paraph.alignment = .center
            let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 15),
                              NSAttributedString.Key.paragraphStyle: paraph]
            shareView.textLab.attributedText = NSAttributedString(string: str as String, attributes: attributes)
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(Int(progress * 1000))){
                self.dismiss()
                self.frontWindow()?.isUserInteractionEnabled = true
            }
        }
        
    }

   @objc public class func dismiss() {
        DispatchQueue.main.async {
            self.shareView.removeFromSuperview()
            self.shareView.textLab.removeFromSuperview()
            self.shareView.activityIndicator.stopAnimating()
            self.shareView.activityIndicator.removeFromSuperview()
            self.shareView.imageView.removeFromSuperview()
            self.shareView.lineView.removeFromSuperview()
            self.shareView.containerView.removeFromSuperview()
            self.shareView.okButton.removeFromSuperview()
        }
    }
    
    
    private class func frontWindow() -> UIWindow? {
        
        let frontToBackWindows = UIApplication.shared.windows.reversed()
        
        for wd in frontToBackWindows {
            let windowOnMainScreen = wd.screen == UIScreen.main
            let windowIsVisible = !wd.isHidden && wd.alpha > 0
            let windowLevelSupported = wd.windowLevel >= UIWindow.Level.normal
            let windowKeyWindow = wd.isKeyWindow
            
            if(windowOnMainScreen && windowIsVisible && windowLevelSupported && windowKeyWindow) {
                return wd
            }
        }
        
        return nil
    }
}
