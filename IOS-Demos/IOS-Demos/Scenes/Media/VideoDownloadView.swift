//
//  VideoDownloadView.swift
//  AAT
//
//  Created by DongYuan on 2018/1/10.
//  Copyright © 2018年 YiXue. All rights reserved.
//

import UIKit
import AVFoundation


class VideoDownloadView: UIView {
    
    private let progressView = UIView()
    private let progressLayer = CAShapeLayer()
    private var closeCallback: (() -> ())?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(frame: CGRect, assetUrl: URL, closeCallback: @escaping () -> ()) {
        super.init(frame: frame)
        
        self.closeCallback = closeCallback
        self.backgroundColor = UIColor.black
        
        let closeBun = UIButton(frame: CGRect(x: 20, y: 27, width: 30, height: 30))
        closeBun.setImage(R.image.chat_close()!, for: .normal)
        closeBun.addTarget(self, action: #selector(self.close), for: .touchUpInside)
        self.addSubview(closeBun)
        
        let previewImageView = UIImageView()
        previewImageView.center = self.center
        if let previewImage = self.generatePreviewImage(with: assetUrl) {
            previewImageView.image = previewImage
            let height = previewImage.size.height / previewImage.size.width * self.width
            previewImageView.frame = CGRect(x: 0, y: 0, width: self.width, height: height)
            previewImageView.center = self.center
            self.addSubview(previewImageView)
        }
        
        self.addSubview(progressView)
        progressView.frame = CGRect(x: 0, y: 0, width: 75, height: 75)
        progressView.center = self.center
        
        self.setupCircleLayer()
        self.setupProgressLayer()
    }
    
    
    @objc func close() {
        self.closeCallback?()
    }
    
    //获取视频第一帧的图片
    private func generatePreviewImage(with url: URL) -> UIImage? {
        let asset = AVAsset(url: url)
        let gen = AVAssetImageGenerator(asset: asset)
        gen.appliesPreferredTrackTransform = true
        if let image = try? gen.copyCGImage(at: CMTime(value: 0, timescale: 1), actualTime: nil) {
            return UIImage(cgImage: image)
        }
        return nil
    }
    
    private func setupCircleLayer() {
        let circleLayer = CAShapeLayer()
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.white.cgColor
        circleLayer.allowsEdgeAntialiasing = true
        circleLayer.lineCap = CAShapeLayerLineCap.round
        circleLayer.lineWidth = 3
        
        let path = UIBezierPath(arcCenter: CGPoint(x: progressView.width/2, y: progressView.height/2),
                                radius: progressView.width/2 - 2,
                                startAngle: 0,
                                endAngle: CGFloat(Double.pi) * 2,
                                clockwise: true)
        circleLayer.path = path.cgPath
        progressView.layer.addSublayer(circleLayer)
    }
    
    
    private func setupProgressLayer() {
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = UIColor.white.cgColor
        progressLayer.allowsEdgeAntialiasing = true
        progressLayer.lineWidth = 30
        
        progressView.layer.addSublayer(progressLayer)
    }
    
    func updateProgress(with progress: Double) {
        let path = UIBezierPath(arcCenter: CGPoint(x: progressView.width/2, y: progressView.height/2),
                                radius: 15,
                                startAngle: CGFloat(Double.pi) * -0.5,
                                endAngle: CGFloat(Double.pi) * -0.5 + CGFloat(Double.pi) * 2 * CGFloat(progress),
                                clockwise: true)
        progressLayer.path = path.cgPath
    }
    
    
    
}
