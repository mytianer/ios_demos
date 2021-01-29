//
//  AATVideoPlayController.swift
//  AAT
//
//  Created by DongYuan on 2017/12/26.
//  Copyright © 2017年 YiXue. All rights reserved.
//

import UIKit
import AVFoundation
import RxSwift
import Photos

class AATVideoPlayController: UIViewController {
    
    @IBOutlet weak var playView: UIView!
    @IBOutlet weak var playBun: UIButton!//中心播放按钮
    //需要旋转的父View
    @IBOutlet weak var transformView: UIView!
    @IBOutlet weak var transformViewWidth: NSLayoutConstraint!
    @IBOutlet weak var transformViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var topBarTop: NSLayoutConstraint!
    @IBOutlet weak var bottomBarBottom: NSLayoutConstraint!
    
    @IBOutlet weak var closeBun: UIButton!//顶部关闭按钮
    @IBOutlet weak var bottomPlayBun: UIButton!//底部播放按钮
    @IBOutlet weak var startTimeLab: UILabel!
    @IBOutlet weak var endTimeLab: UILabel!
    @IBOutlet weak var progressBar: ProgressSlider!
    @IBOutlet weak var rotationBun: UIButton!//旋转屏幕按钮
    
    @IBOutlet weak var dowloadButton: UIButton!
    
    private var isPortrait = true//是否竖屏
    
    private var updateLink: CADisplayLink?
    
    private var videoPath: URL?
    private var downloadDirectory: URL?
    private var filePathCallback: ((URL) -> Void)?
    
    private var playLayer: AVPlayerLayer?
    private let bag = DisposeBag()
    
    required init(videoPath: URL, downloadDirectory: URL? = nil, filePathCallback: ((URL) -> Void)? = nil) {
        super.init(nibName: R.nib.aatVideoPlayController.name, bundle: Bundle.main)
        
        self.videoPath = videoPath
        self.downloadDirectory = downloadDirectory
        self.filePathCallback = filePathCallback
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(nibName: R.nib.aatVideoPlayController.name, bundle: Bundle.main)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.showPlayBar(true)
        self.setupUI()
   
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.moviePlayDidEnd),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: nil)
        
        closeBun.rx.tap.asObservable()
            .bind {[weak self] in
                self?.dismiss(animated: true)
            }
            .disposed(by: bag)
        
        bottomPlayBun.rx.tap.asObservable()
            .bind {[weak self] in
                let isSelected = self?.bottomPlayBun.isSelected
                self?.playVideo(!isSelected!)
            }
            .disposed(by: bag)
        
        playBun.rx.tap.asObservable()
            .bind { [weak self] in
                self?.playVideo(true)
            }
            .disposed(by: bag)
        
        progressBar.slidingSubject.asObservable()
            .bind(onNext: {[weak self] flag in
                self?.playVideo(!flag)
            })
            .disposed(by: bag)
        
        dowloadButton.rx.tap.asObservable()
            .bind { [weak self] in
                self?.saveVideoToAlbum()
            }
            .disposed(by: bag)
        
        rotationBun.rx.tap.asObservable()
            .bind { [weak self] in
                self?.isPortrait = !(self?.isPortrait)!
                self?.transformLandscape()
            }
            .disposed(by: bag)
        
    }
    
    func saveVideoToAlbum() {
        playVideo(false)
        // 保存到本地
        let authStatus =  PHPhotoLibrary.authorizationStatus()
        
        if(authStatus == .denied || authStatus == .restricted) {
            let vc = UIAlertController(title: nil, message: "请打开相册访问权限", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "取消", style: .default)
            let action2 = UIAlertAction(title: "设置", style: .default) { action in
                UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
            }
            vc.addAction(action1)
            vc.addAction(action2)
            self.present(vc, animated: true)
            return
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            if let urlNodes = videoPath?.absoluteString.split(separator: "/") {
                let fileName = urlNodes[urlNodes.count - 1]
                let localFilePath = downloadDirectory?.appendingPathComponent(fileName, isDirectory: false)
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: localFilePath!)
                }, completionHandler: { (isSuccess, error) in
                    if isSuccess {
                        AATHUD.showHudSuccess("已成功保存到相册")
                    }else {
                        AATHUD.showError("保存失败")
                    }
                })
            }
        } else {
            AATHUD.showError("请设置相册访问权限")
        }
    }
    
    func setupSubscriptions() {
        guard let playItem = playLayer?.player?.currentItem else { return }
        
        playItem.rx.observe(AVPlayer.Status.self, "status")
            .filterNil()
            .bind(onNext: {[weak self] type in
                print("player.status == \(type.rawValue)")
                if type == AVPlayer.Status.readyToPlay {
                    self?.playVideo(false)
                    self?.showPlayBar(false)
                }
            })
            .disposed(by: bag)
        
        progressBar.rx.value.asObservable()
            .bind { persent in
                let duration = playItem.duration.seconds
                if duration.isNaN == false {
                    let targetTime = Int(persent * Float(duration))//小数点时间会导致 太低时间尺度警告⚠️
                    playItem.seek(to: CMTime(seconds: Double(targetTime), preferredTimescale: 1))
                }
            }
            .disposed(by: bag)
    }
    
    
    func setupUI() {
        transformViewWidth.constant = mainScreenWidth
        transformViewHeight.constant = mainScreenHeight
        
        progressBar.setThumbImage(#imageLiteral(resourceName: "schedule_dot"), for: UIControl.State())
        
        guard let assetUrl = self.videoPath else { return }
        if !assetUrl.isFileURL {
            guard let directory = self.downloadDirectory else {
                print("没有下载文件存放路径！！！")
                return
            }
            // 根据视频在服务器的地址来截取文件名
            let urlNodes = assetUrl.absoluteString.split("/")
            let fileName = urlNodes[urlNodes.count - 1]
            let localFilePath = directory.appendingPathComponent(fileName, isDirectory: false)
            let fileData = NSData(contentsOf: localFilePath)
            let fileSizePart = (fileData?.length ?? 0) / 1024
            
            // 检测本地是否有该文件
            if (FileManager.default.fileExists(atPath: localFilePath.path) && fileSizePart >= 10) {
                self.filePathCallback?(localFilePath)
                self.preparePlay(with: localFilePath)
            }else {
                if networkStatus == .notReachable {
                    self.dismiss(animated: true)
                    return
                }else {
                    let downloadView = VideoDownloadView(frame: CGRect(x: 0, y: 0, w: mainScreenWidth, h: mainScreenHeight),
                                                         assetUrl: assetUrl) {[weak self] in
                                                            self?.dismiss(animated: true)
                    }
                    self.view.addSubview(downloadView)
                    
                    AATApi.File.downloadFile(url: assetUrl, destinationDirectory: directory, fileName: fileName)
                        .bind(onNext: {[weak self] progressResponse in
                            let progress = progressResponse.progress
                            print("下载进度: \(progress)")
                            if progressResponse.completed {
                                downloadView.removeFromSuperview()
                                let videoPath = URL(fileURLWithPath: directory.path.appending("/\(fileName)"))
                                self?.filePathCallback?(videoPath)
                                self?.preparePlay(with: videoPath)
                            }else{
                                downloadView.updateProgress(with: progress)
                            }
                        })
                        .disposed(by: bag)
                }
            }
        }else{
            self.preparePlay(with: assetUrl)
        }
    }
    
    
    func preparePlay(with assetUrl: URL) {
        let asset = AVURLAsset(url: assetUrl)
        let playItem = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: playItem)
        
        playLayer = AVPlayerLayer(player: player)
        playLayer?.frame = CGRect(x: 0, y: 0, w: mainScreenWidth, h: mainScreenHeight)
        playLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
        playLayer?.contentsScale = UIScreen.main.scale
        self.playView.layer.addSublayer(playLayer!)
        
        self.setupSubscriptions()
    }
    
    //暂停或播放
    func playVideo(_ isPlay: Bool) {
        guard let player = self.playLayer?.player else { return }
        
        self.playBun.isHidden = isPlay
        self.bottomPlayBun.isSelected = isPlay
        
        if isPlay {
            if player.rate == 0 {
                if player.currentItem?.currentTime() == player.currentItem?.duration {
                    player.currentItem?.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
                }
                player.play()
            }
        }else{
            if player.rate == 1.0 {
                player.pause()
            }
        }
    }
    
    
    func setupUpdateTimer() {
        updateLink = CADisplayLink(target: self, selector: #selector(self.updateVideoInfo))
        updateLink?.add(to: .main, forMode: .default)
    }
    
    //更新时间和进度条
    @objc func updateVideoInfo() {
        guard let playItem = playLayer?.player?.currentItem else { return }
        
        let currentTime = playItem.currentTime().seconds
        let totalTime = playItem.duration.seconds
        
        guard !(currentTime.isNaN || totalTime.isNaN) else { return }
        
        if progressBar.isSliding == false {
            progressBar.setValue(Float(currentTime / totalTime), animated: true)
        }
        
        startTimeLab.text = convertDurationToString(currentTime)
        endTimeLab.text = convertDurationToString(totalTime)
    }
    
    
    func convertDurationToString(_ duration: Double) -> String {
        let minute = Int(duration) / 60
        let second = Int(duration) % 60
        
        return  String(format: "%02d:%02d", minute, second)
    }
    

    @IBAction func playViewClick(_ sender: Any) {
        if topBarTop.constant == 0 {
            self.showPlayBar(false)
        }else{
            self.showPlayBar(true)
        }
    }
    
    //横竖屏UI切换
    func transformLandscape() {
        if self.isPortrait {
            transformViewWidth.constant = mainScreenWidth
            transformViewHeight.constant = mainScreenHeight
            self.playLayer?.frame = CGRect(x: 0, y: 0, w: mainScreenWidth, h: mainScreenHeight)
        }else{
            transformViewWidth.constant = mainScreenHeight
            transformViewHeight.constant = mainScreenWidth
            self.playLayer?.frame = CGRect(x: 0, y: 0, w: mainScreenHeight, h: mainScreenWidth)
        }
        
        UIView.animate(withDuration: 0.3) {
            if self.isPortrait {
                self.transformView.transform = CGAffineTransform(rotationAngle: 0)
            }else{
                self.transformView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
            }
        }
    }
    
    //是否显示顶部和底部工具条
    func showPlayBar(_ isShow: Bool) {
        UIView.animate(withDuration: 0.3) {
            if isShow {
                self.topBarTop.constant = 0
                self.bottomBarBottom.constant = 0
            }else{
                self.topBarTop.constant = -64
                self.bottomBarBottom.constant = -64
            }
            
            self.view.layoutIfNeeded()
        }
    }
    
    //播放结束
    @objc func moviePlayDidEnd() {
        bottomPlayBun.isSelected = false
        playBun.isHidden = false
        self.showPlayBar(true)
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    deinit {
        playLayer?.player?.pause()
        playLayer?.removeFromSuperlayer()
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupUpdateTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        updateLink?.invalidate()
        self.updateLink = nil
    }
    
    
}

