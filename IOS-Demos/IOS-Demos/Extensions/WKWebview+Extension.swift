//
//  WKWebview+Extension.swift
//  AAT
//
//  Created by 李瀚 on 2019/2/12.
//  Copyright © 2019 YiXue. All rights reserved.
//

import Foundation
import WebKit

private var ImgUrlsKey: Void?
private let jsGetImages =  "function getImages(){" +
    "var objs = document.getElementsByTagName(\"img\");" +
    "var imgScr = '';" +
    "for(var i=0;i<objs.length;i++){" +
    "imgScr = imgScr + objs[i].src + '+';" +
    "};" +
    "return imgScr;" +
    "};"
private let jsClickImage = "function registerImageClickAction(){" +
    "var imgs=document.getElementsByTagName('img');" +
    "var length=imgs.length;" +
    "for(var i=0;i<length;i++){" +
    "img=imgs[i];" +
    "img.onclick=function(){" +
    "window.location.href='image-preview:'+this.src}" +
    "}" +
    "}"


extension WKWebView {
    private var imgUrls: [String] {
        get {
            return objc_getAssociatedObject(self, &ImgUrlsKey) as? [String] ?? []
        }
        set {
            objc_setAssociatedObject(self, &ImgUrlsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func getImagUrlsByJs() {
        // 注入获取图片
        evaluateJavaScript(jsGetImages)
        evaluateJavaScript("getImages()") { [weak self] (result, error) in
            guard error == nil, let imageUrl = result as? String, imageUrl.count > 0 else { return }
            var urls = imageUrl.components(separatedBy: "+")
            urls.removeLast()
            print("getUrls successed: \(urls)")
            self?.imgUrls = urls
        }
        // 注入点击事件
        evaluateJavaScript(jsClickImage)
        evaluateJavaScript("registerImageClickAction()")
    }
    
    func getImage(byRequest request: URLRequest, completion: (_ imgUrls: [String], _ imageIndex: Int) -> Void) {
        guard let requestString = request.url?.absoluteString else { return }
        let scheme = "image-preview:"
        if requestString.hasPrefix(scheme) {
            let imgUrl = (requestString as NSString).substring(from: scheme.count)
            guard let index = imgUrls.firstIndex(of: imgUrl) else { return }
            completion(imgUrls, index)
        }
    }
}
