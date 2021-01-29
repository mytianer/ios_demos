//
//  AATVideoRecordController.swift
//  AAT
//
//  Created by DongYuan on 2017/12/28.
//  Copyright © 2017年 YiXue. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import AVFoundation


class AATVideoRecordController: UIViewController {
    
    @IBOutlet weak var cameraBun: UIButton!
    @IBOutlet weak var downBun: UIButton!
    
    @IBOutlet weak var cancelBun: UIButton!
    @IBOutlet weak var confirmBun: UIButton!
    @IBOutlet weak var cancelCenterX: NSLayoutConstraint!
    @IBOutlet weak var confirmCenterX: NSLayoutConstraint!
    
    @IBOutlet weak var recordView: VideoRecordView!
    
    fileprivate var audioOutputQueue = DispatchQueue(label: "com.yixue.laiai.audioOutput")
    fileprivate var videoOutputQueue = DispatchQueue(label: "com.yixue.laiai.videoOutput", qos: .userInitiated)
    
    fileprivate var captureSession = AVCaptureSession()
    fileprivate var cameraDevice: AVCaptureDevice?
    
    fileprivate var videoDataOutput = AVCaptureVideoDataOutput()
    fileprivate var audioDataOutput = AVCaptureAudioDataOutput()
    fileprivate var stillImageOutput = AVCaptureStillImageOutput()
    
    fileprivate var videoCompressionSettings: [String: Any] = [:]
    fileprivate var audioCompressionSettings: [String: Any] = [:]
    
    fileprivate var audioFormatDescription: CMFormatDescription?
    fileprivate var videoFormatDescription: CMFormatDescription?
    
    fileprivate var assetWriter = AATAssetWriter()
    
    fileprivate var previewLayer = AVCaptureVideoPreviewLayer()
    
    private var playLayer: AVPlayerLayer?
    
    private var tempFilePath = "" // 当前录制视频的存放路径
    private var cameraImage: UIImage? //拍摄的照片
    
    var recorderCallBack: (((videoPath: String?, previewImage: UIImage)) -> Void)? //videoPath为nil时  previewImage为拍摄的照片
    
    private let bag = DisposeBag()
    
    
    init() {
        super.init(nibName: R.nib.aatVideoRecordController.name, bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(nibName: R.nib.aatVideoRecordController.name, bundle: Bundle.main)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.videoPlayDidEnd),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: nil)
        
        
        self.showRecord()
        
        self.setupCaptureSession()
        if self.captureSession.inputs.count > 0 {
            self.captureSession.startRunning()
        }
        
        cameraBun.rx.tap.asObservable()
            .bind {[weak self] in
                self?.swapFrontAndBackCamera()
            }
            .disposed(by: bag)
        
        downBun.rx.tap.asObservable()
            .bind {[weak self] in
                self?.dismiss(animated: true)
            }
            .disposed(by: bag)
        
        cancelBun.rx.tap.asObservable()
            .bind {[weak self] in
                self?.stopPreviewVideo()
                self?.resetVideoZoom()
                self?.showRecord()
                try? FileManager.default.removeItem(atPath: self?.tempFilePath ?? "")
            }
            .disposed(by: bag)
        
        confirmBun.rx.tap.asObservable()
            .bind {[weak self] in
                if let image = self?.cameraImage {
                    self?.recorderCallBack?((videoPath: nil, previewImage: image))
                }else{
                    let path = self?.tempFilePath ?? ""
                    self?.recorderCallBack?((videoPath: path, previewImage: (self?.generatePreviewImage(with: path))!))
                }
                self?.dismiss(animated: true)
            }
            .disposed(by: bag)
        
        recordView.recordStateCallBack = {[unowned self] isRecording in
            if isRecording {
                self.setupAssetWriter()
                self.cameraImage = nil
                self.downBun.isHidden = true
                self.assetWriter.startRecording()
            }else{
                self.assetWriter.finishRecording()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                    self.previewVideo()
                })
            }
        }
        
        //调整视频缩放
        recordView.recordCenterVerticalOffset
            .bind {[weak self] percent in
                guard let device = self?.cameraDevice else { return }
                
                let maxZoom = device.activeFormat.videoMaxZoomFactor // 6s值为16
                let difference = maxZoom - 1
                let targetZoom = difference * percent + 1
                
                try? device.lockForConfiguration()
                device.ramp(toVideoZoomFactor: (targetZoom < maxZoom ? targetZoom:maxZoom), withRate: 10) // rate  每秒缩放视频的倍数
                device.unlockForConfiguration()
            }
            .disposed(by: bag)
        
    }
    
    //禁止横屏
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let videoStatus =  AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        let audioStatus =  AVCaptureDevice.authorizationStatus(for: AVMediaType.audio)
        
        if  videoStatus == .denied
            || videoStatus == .restricted
            || audioStatus == .denied
            || audioStatus == .restricted {
            let vc = UIAlertController(title: nil, message: "请在iPhone的“设置-隐私”选项中，允许来艾访问你的摄像头和麦克风", preferredStyle: .alert)
            let action = UIAlertAction(title: "确定", style: .default) {[weak self] _ in
                self?.dismiss(animated: true)
            }
            vc.addAction(action)
            self.present(vc, animated: true)
        }
    }
    
    //获取视频第一帧的图片 并裁剪
    func generatePreviewImage(with path: String) -> UIImage {
        let asset = AVAsset(url: URL(fileURLWithPath: path))
        let gen = AVAssetImageGenerator(asset: asset)
        gen.appliesPreferredTrackTransform = true
        if let image = try? gen.copyCGImage(at: CMTime(value: 0, timescale: 1), actualTime: nil) {
            let x = CGFloat((image.width - 253)) / 2
            let y = CGFloat((image.height - 450)) / 2
            if let croppingImage = image.cropping(to: CGRect(x: x, y: y, w: 253, h: 450)) {
                return UIImage(cgImage: croppingImage)
            }
        }
        return UIImage()
    }
    
    //预览录制完的视频
    private func previewVideo() {
        let asset = AVURLAsset(url: URL(fileURLWithPath: self.tempFilePath))
        
        if asset.duration.seconds < 0.1 {
            guard let videoConnection = stillImageOutput.connection(with: AVMediaType.video) else { return }
            
            self.stillImageOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: {[weak self] sampleBuffer, error in
                self?.captureSession.stopRunning()
                
                if let buffer = sampleBuffer,
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer) {
                    self?.cameraImage = UIImage(data: imageData)
                }
                
                self?.showCancelConfirm()
            })
            try? FileManager.default.removeItem(atPath: self.tempFilePath)
        }else if 0.1..<2 ~= asset.duration.seconds  {
            AATHUD.showError("录制时间太短!")
            self.resetVideoZoom()
            stopPreviewVideo()
            showRecord()
            try? FileManager.default.removeItem(atPath: self.tempFilePath)
            tempFilePath = ""
        }else {
            self.captureSession.stopRunning()
            
            let playItem = AVPlayerItem(asset: asset)
            let player = AVPlayer(playerItem: playItem)
            
            playLayer = AVPlayerLayer(player: player)
            playLayer?.frame = self.view.bounds
            playLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            playLayer?.player?.play()
            self.view.layer.insertSublayer(playLayer!, above: self.previewLayer)
            self.showCancelConfirm()
        }
    }
    
    //重置视频缩放
    private func resetVideoZoom() {
        guard let device = self.cameraDevice else { return }
        try? device.lockForConfiguration()
        device.ramp(toVideoZoomFactor: 1, withRate: 10)
        device.unlockForConfiguration()
    }
    
    //停止预览视频
    private func stopPreviewVideo() {
        playLayer?.player?.pause()
        playLayer?.removeFromSuperlayer()
        playLayer = nil
        
        if self.captureSession.inputs.count > 0 {
            self.captureSession.startRunning()
        }
    }
    //播放结束
    @objc private func videoPlayDidEnd() {
        if let player = self.playLayer?.player {
            player.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
            player.play()
        }
    }
    
    
    private func setupAssetWriter() {
        let tempFileName = ProcessInfo.processInfo.globallyUniqueString
        self.tempFilePath = NSTemporaryDirectory().appending("\(tempFileName).mp4")
        
        self.setupCompressionSettings()
        
        self.assetWriter.tempFilePath = self.tempFilePath
        self.assetWriter.audioTrackSettings = self.audioCompressionSettings
        self.assetWriter.audioTrackSourceFormatDescription = self.audioFormatDescription
        self.assetWriter.videoTrackSettings = self.videoCompressionSettings
        self.assetWriter.videoTrackSourceFormatDescription = self.videoFormatDescription
        
        self.assetWriter.prepareToRecord()
    }
    

    deinit {
        NotificationCenter.default.removeObserver(self)
        self.captureSession.stopRunning()
    }
    
    //切换前置后置摄像头
    private func swapFrontAndBackCamera() {
        guard let inputs = self.captureSession.inputs as? [AVCaptureDeviceInput] else { return }
        
        for input in inputs {
            let device = input.device
            if device.hasMediaType(AVMediaType.video) {
                var newCamera: AVCaptureDevice?
                
                switch device.position {
                case .front:
                    self.cameraBun.alpha = 0.6
                    newCamera = self.createCamera(with: .back)
                case .back:
                    self.cameraBun.alpha = 1
                    newCamera = self.createCamera(with: .front)
                case .unspecified: ()
                }
                guard let camera = newCamera, let newInput = try? AVCaptureDeviceInput(device: camera) else { return }
                
                self.captureSession.beginConfiguration()
                self.captureSession.removeInput(input)
                self.captureSession.addInput(newInput)
                self.captureSession.commitConfiguration()
            }
        }
    }
    
    
    private func createCamera(with position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let newDevides = AVCaptureDevice.devices(for: AVMediaType.video)
        for device in newDevides {
            if device.position == position {
                return device
            }
        }
        return nil
    }
    
    //显示确认和取消
    private func showCancelConfirm() {
        cancelBun.isHidden = false
        confirmBun.isHidden = false
        UIView.animate(withDuration: 0.2) {
            self.cancelCenterX.constant = -70
            self.confirmCenterX.constant = 70
            self.view.layoutIfNeeded()
        }
        
        downBun.isHidden = true
        recordView.isHidden = true
        cameraBun.isHidden = true
    }
    
    //显示录制按钮
    private func showRecord() {
        cancelBun.isHidden = true
        confirmBun.isHidden = true
        cancelCenterX.constant = 0
        confirmCenterX.constant = 0
        
        downBun.isHidden = false
        recordView.isHidden = false
        cameraBun.isHidden = false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}


/// 初始化视频录制session 设置输入和输出
extension AATVideoRecordController {
    
    fileprivate func setupCaptureSession() {
        self.previewLayer.session = captureSession
        self.previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.previewLayer.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        self.view.layer.insertSublayer(self.previewLayer, at: 0)
        
        self.addCameraInput()
        self.addMicInput()
        self.addDataOutput()
    }
    
    
    fileprivate func addCameraInput() {
        cameraDevice = AVCaptureDevice.default(for: .video)
        guard let device = cameraDevice else { return }
        do {
            let deviceInput = try AVCaptureDeviceInput.init(device: device)
            if captureSession.canAddInput(deviceInput) {
                captureSession.addInput(deviceInput)
            }
        } catch let error {
            print("配置摄像头输入错误: \(error.localizedDescription)")
        }
    }
    
    fileprivate func addMicInput() {
        guard let device = AVCaptureDevice.default(for: .audio) else { return }
        do {
            let deviceInput = try AVCaptureDeviceInput.init(device: device)
            if captureSession.canAddInput(deviceInput) {
                captureSession.addInput(deviceInput)
            }
        } catch let error {
            print("配置麦克风输入错误: \(error.localizedDescription)")
        }
    }
    
    fileprivate func addDataOutput() {
        self.videoDataOutput.videoSettings = nil
        self.videoDataOutput.alwaysDiscardsLateVideoFrames = false
        self.videoDataOutput.setSampleBufferDelegate(self, queue: self.videoOutputQueue)
        
        self.audioDataOutput.setSampleBufferDelegate(self, queue: self.audioOutputQueue)
        
        self.stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        
        if self.captureSession.canAddOutput(self.videoDataOutput) {
            self.captureSession.addOutput(self.videoDataOutput)
        }
        
        if self.captureSession.canAddOutput(self.audioDataOutput) {
            self.captureSession.addOutput(self.audioDataOutput)
        }
        
        if self.captureSession.canAddOutput(self.stillImageOutput) {
            self.captureSession.addOutput(self.stillImageOutput)
        }
    }
    
    
    fileprivate func setupCompressionSettings() {
        // 全屏大小会导致录制的视频尺寸长宽都加1  待解决
        let outputSize = CGSize(width: mainScreenWidth - 1, height: mainScreenHeight - 1)
        
        let numPixels = outputSize.width * outputSize.height
        // 每像素比特
        let bitsPerPixel: CGFloat = 6.0
        let bitsPerSecond = numPixels * bitsPerPixel
        
        // 码率和帧率设置
        let compressionProperties = [AVVideoAverageBitRateKey: bitsPerSecond,
                                     AVVideoExpectedSourceFrameRateKey: 30,
                                     AVVideoMaxKeyFrameIntervalKey: 30,
                                     AVVideoProfileLevelKey:AVVideoProfileLevelH264BaselineAutoLevel] as [String : Any]
        
        self.videoCompressionSettings = [AVVideoCodecKey : AVVideoCodecH264,
                                         AVVideoScalingModeKey : AVVideoScalingModeResizeAspectFill,
                                         AVVideoWidthKey : outputSize.height,
                                         AVVideoHeightKey : outputSize.width,
                                         AVVideoCompressionPropertiesKey : compressionProperties]
        // 音频设置
        self.audioCompressionSettings = [AVEncoderBitRatePerChannelKey : 28000,
                                        AVFormatIDKey : kAudioFormatMPEG4AAC,
                                        AVNumberOfChannelsKey : 1,
                                        AVSampleRateKey : 22050]
    }
    
}


extension AATVideoRecordController: AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        autoreleasepool {
            if videoDataOutput.connection(with: AVMediaType.video) == connection {
                if self.videoFormatDescription == nil {
                    objc_sync_enter(self)
                    let des = CMSampleBufferGetFormatDescription(sampleBuffer)
                    self.videoFormatDescription = des
                    objc_sync_exit(self)
                }else{
                    objc_sync_enter(self)
                    if self.assetWriter.status == .writing {
                        self.assetWriter.append(sampleBuffer: sampleBuffer, mediaType: AVMediaType.video)
                    }
                    objc_sync_exit(self)
                }
            } else if audioDataOutput.connection(with: AVMediaType.audio) == connection {
                if self.audioFormatDescription == nil {
                    objc_sync_enter(self)
                    let des = CMSampleBufferGetFormatDescription(sampleBuffer)
                    self.audioFormatDescription = des
                    objc_sync_exit(self)
                }else{
                    objc_sync_enter(self)
                    if self.assetWriter.status == .writing {
                        self.assetWriter.append(sampleBuffer: sampleBuffer, mediaType: AVMediaType.audio)
                    }
                    objc_sync_exit(self)
                }
            }
        }
    }
    
//
//    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//
//    }
//
    
}



