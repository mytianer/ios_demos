//
//  UIImage+Extension.swift
//  LaiAi
//
//  Created by DongYuan on 2018/5/19.
//  Copyright © 2018年 Jim1024. All rights reserved.
//

import Foundation
import ImageIO

//MARK:-
extension UIImageView {
    
    func setLocalGifImage(gifName:String) {
        DispatchQueue.global().async {
            guard let path = Bundle.main.path(forResource: gifName, ofType: nil),
                let data = NSData(contentsOfFile: path),
                let imageSource = CGImageSourceCreateWithData(data, nil) else { return }
            /// 图片帧数
            let totalCount = CGImageSourceGetCount(imageSource)
            var images = [UIImage]()
            var gifDuration = 0.0
            for i in 0 ..< totalCount {
                
                // 获取对应帧的 CGImage
                guard let imageRef = CGImageSourceCreateImageAtIndex(imageSource, i, nil) else {return }
                
                if totalCount == 1 {
                    /// 单张图片
                    gifDuration = Double.infinity
                    guard let path = Bundle.main.path(forResource: gifName, ofType: nil),
                        let imageData = NSData(contentsOfFile: path),
                        let image = UIImage.init(data: imageData as Data) else {return }
                    images.append(image)
                    
                } else{
                    /// gif
                    guard let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil),
                        let gifInfo = (properties as NSDictionary)[kCGImagePropertyGIFDictionary as String] as? NSDictionary,
                        let frameDuration = (gifInfo[kCGImagePropertyGIFDelayTime as String] as? NSNumber) else {
                            return
                    }
                    gifDuration += frameDuration.doubleValue
                    // 获取帧的img
                    let image = UIImage.init(cgImage: imageRef, scale: UIScreen.main.scale, orientation: UIImage.Orientation.up)
                    
                    images.append(image)
                }
            }
            DispatchQueue.main.async {
                self.animationImages = images
                self.animationDuration = gifDuration
                self.animationRepeatCount = 0
                self.startAnimating()
            }
        }
    }
}


extension UIImage {
    
    func compressToData(_ maxByte: Int) -> Data {
        var maxLength: CGFloat = 320
        let image = self.scale(maxLength)
        
        var compressionQuality: CGFloat = 1
        var resData = Data()
        var tempImage = image
        var allBytes = 0
        // 压图片质量
        repeat{
            resData = tempImage.jpegData(compressionQuality: compressionQuality) ?? Data()
            tempImage = UIImage(data: resData) ?? UIImage()
            allBytes = resData.count
            print("图片大小  = \(allBytes)")
            
            if compressionQuality < 0.2 {
                break
            }else{
                compressionQuality -= 0.1
            }
        }while allBytes > maxByte
        
        if allBytes < maxByte {
            return resData
        }
        // 缩小图片
        repeat{
            if maxLength < 10 {
                break
            }else{
                maxLength = maxLength * 0.9
            }
            tempImage = tempImage.scale(maxLength)
            resData = tempImage.jpegData(compressionQuality: compressionQuality) ?? Data()
            allBytes = resData.count
            print("图片大小  = \(allBytes)")
        }while allBytes > maxByte
        
        return resData
    }
    
    func compress(_ maxByte: Int) -> UIImage {
        return UIImage(data: self.compressToData(maxByte)) ?? UIImage()
    }
    
    func scale(_ maxLength: CGFloat) -> UIImage {
        var newWidth: CGFloat = 0.0
        var newHeight: CGFloat = 0.0
        let width = self.size.width
        let height = self.size.height
        
        if (width > maxLength || height > maxLength) {
            if (width > height) {
                newWidth = maxLength
                newHeight = newWidth * height / width
            } else {
                newHeight = maxLength
                newWidth = newHeight * width / height
            }
        } else {
            newWidth = width
            newHeight = height
        }
        return self.resize(CGSize(width: newWidth, height: newHeight))
    }
    
    func resize(_ newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    class func createImage(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let image = image {
            return image
        } else {
            return UIImage()
        }
    }
    
    class func qrcode(_ content: String) -> UIImage {
        // 根据CIImage生成指定大小的高清UIImage
        func createNonInterpolatedUIImageFormCIImage(image: CIImage, size: CGFloat) -> UIImage {
            //CIImage没有frame与bounds属性,只有extent属性
            let ciextent: CGRect = image.extent.integral
            let scale: CGFloat = min(size/ciextent.width, size/ciextent.height)
            
            let context = CIContext(options: nil)  //创建基于GPU的CIContext对象,性能和效果更好
            let bitmapImage: CGImage = context.createCGImage(image, from: ciextent)! //CIImage->CGImage
            
            let width = ciextent.width * scale
            let height = ciextent.height * scale
            let cs: CGColorSpace = CGColorSpaceCreateDeviceGray() //灰度颜色通道
            let info_UInt32 = CGImageAlphaInfo.none.rawValue
            
            let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: info_UInt32)! //图形上下文，画布
            bitmapRef.interpolationQuality = CGInterpolationQuality.none //写入质量
            bitmapRef.scaleBy(x: scale, y: scale) //调整“画布”的缩放
            bitmapRef.draw(bitmapImage, in: ciextent)  //绘制图片
            
            let scaledImage: CGImage = bitmapRef.makeImage()! //保存
            return UIImage(cgImage: scaledImage)
        }
        
        let data = content.data(using: .utf8)
        
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")
        qrFilter?.setValue(data, forKey: "inputMessage")
        
        // 上色
        let params = ["inputImage": qrFilter?.outputImage ?? CIImage.init(),
                      "inputColor0": CIColor(color: UIColor.black),
                      "inputColor1": CIColor(color: UIColor.white)]
        let colorFilter = CIFilter(name: "CIFalseColor", parameters: params)
        let ciImage = colorFilter?.outputImage ?? CIImage.init()
        
        return createNonInterpolatedUIImageFormCIImage(image: ciImage, size: 300)
    }
    
    func addCornerRadius(_ radius: CGFloat, borderWith: CGFloat = 0, borderColor: UIColor = .clear) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        
        let clipPath = UIBezierPath(roundedRect: CGRect(origin: CGPoint.zero, size: self.size), cornerRadius: radius)
        borderColor.setFill()
        clipPath.fill()
        clipPath.addClip()
        
        let imageRect = CGRect(x: borderWith,
                               y: borderWith,
                               width: self.size.width - 2 * borderWith,
                               height: self.size.height - 2 * borderWith)
        
        if borderWith > 0 {
            let drawPath = UIBezierPath(roundedRect: imageRect, cornerRadius: radius)
            drawPath.addClip()
        }
        
        self.draw(in: imageRect)
        
        let resultImage = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        return resultImage
    }
    
}

extension UIImage {
    
    /// 设置渐变颜色背景图层
    static func colors(colors: [UIColor],
                      size: CGSize,
                      starPoint: CGPoint = CGPoint(x: 0, y: 0.5),
                      endPoint: CGPoint = CGPoint(x: 1 , y: 0.5),
                      locations: [NSNumber]? = nil) -> UIImage? {
        
        UIGraphicsBeginImageContext(size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(origin: CGPoint.zero, size: size)
        gradientLayer.startPoint = starPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.locations = locations
        gradientLayer.colors = colors.map({$0.cgColor})
        gradientLayer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 图片转字符串
    func toAttributeString() -> NSAttributedString {
        let textAttachment = NSTextAttachment()
        textAttachment.image = self
        textAttachment.bounds = CGRect(x: 0, y: -2, width: self.size.width, height: self.size.height)
        return NSAttributedString(attachment: textAttachment)
    }
}


extension UIImage {
    
    static func redrawVertImages(imageObjs: [(UIImage, CGSize)]?, complete: ((UIImage?) -> Void)?) {
        guard let imageObjs = imageObjs, imageObjs.count > 0 else {
            complete!(nil)
            return
        }
        
        let contentWidth: CGFloat = imageObjs[0].1.width
        var contentHeight: CGFloat = 0
        for imageObj in imageObjs {
            contentHeight = contentHeight + imageObj.1.height
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: contentWidth, height: contentHeight),
                                               false,
                                               UIScreen.main.scale)
        
        UIImage.drawImage(imageObjs: imageObjs, index: 0, offsetY: 0) {
            let resultImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            complete?(resultImage)
        }
    }
    
    fileprivate static func drawImage(imageObjs: [(UIImage, CGSize)], index: Int, offsetY: CGFloat, complete: @escaping () -> Void) {
        guard imageObjs.count > index else {
            complete()
            return
        }
        imageObjs[index].0.draw(in: CGRect(origin: CGPoint(x: 0, y: offsetY),
                                           size: imageObjs[index].1))
        UIImage.drawImage(imageObjs: imageObjs, index: index + 1, offsetY: offsetY + imageObjs[index].1.height, complete: complete)
    }
    
}
