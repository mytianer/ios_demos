//
//  LaunchAdvertisementController.swift
//
//  Created by mengqingzheng on 2017/4/5.
//  Copyright © 2017年 meng. All rights reserved.
//

import UIKit
import Kingfisher


class LaunchAdvertisementController: UIViewController {
    
    // 广告图距底部距离
    private let bottomLogoHeight: CGFloat = 125 / 375 * SCREEN_WIDTH
    
    // 广告显示时间
    private let showTime = 3
    // 等待定时器
    private var waitTimer: DispatchSourceTimer?
    // 广告定时器
    private var adTimer: DispatchSourceTimer?
    // 广告点击闭包
    private var adClick: EmptyBlock?
    
    // 完成闭包
    var completion: EmptyBlock?
    
    // 广告图
    private lazy var launchAdImgView: UIImageView = {
        let imgView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - self.bottomLogoHeight))
        imgView.contentMode = .scaleAspectFill
        imgView.isUserInteractionEnabled = true
        imgView.alpha = 0.2
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(launchAdTapAction))
        imgView.addGestureRecognizer(tap)
        return imgView
    }()
    
    /// 跳过按钮
    private lazy var skipBtn: UIButton = {
        let button = UIButton.init(type: .custom)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        button.frame = CGRect(x: SCREEN_WIDTH - 70, y: SCREEN_HEIGHT - bottomLogoHeight - 40, width: 60, height: 25)
        button.cornerRadius = 12.5
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.pingFangSC(size: 14)
        button.setTitle("跳过", for: .normal)
        button.addTarget(self, action: #selector(skipBtnClick), for: .touchUpInside)
        return button
    }()
    
    /// 广告点击
    @objc private func launchAdTapAction() {
        launchAdImgView.isUserInteractionEnabled = false
        launchAdRemove { [weak self] in
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self?.adClick?()
//            })
        }
    }
    @objc private func skipBtnClick() {
        skipBtn.isEnabled = false
        launchAdRemove()
    }
    
    /// 关闭广告
    private func launchAdRemove(completion: EmptyBlock = {}) {
        if self.waitTimer?.isCancelled == false {
            self.waitTimer?.cancel()
        }
        if self.adTimer?.isCancelled == false {
            self.adTimer?.cancel()
        }
        
        self.completion?()
        completion()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        
        startTimer()
    }
    
    private func setupView() {
        let logo = assetsLaunchImage()
        let logoView = UIImageView(image: logo)
        self.view.addSubview(logoView)
    }
    
    /// 设置广告
    func setAd(url: String?, adClick: EmptyBlock?) {
        if let url = url, let adUrl = URL(string: url) {
            self.launchAdImgView.kf.setImage(with: adUrl) {[weak self] (_, _, _, _) in
                self?.view.addSubview(self?.launchAdImgView ?? UIView())
                self?.view.addSubview(self?.skipBtn ?? UIView())
                
                if self?.waitTimer?.isCancelled == true {
                    return
                }
                self?.adStartTimer()
                UIView.animate(withDuration: 0.8, animations: {
                    self?.launchAdImgView.alpha = 1
                })
            }
            self.adClick = adClick
        } else {
            launchAdRemove()
        }
    }
    
    /// 默认定时器
    private func startTimer() {
        waitTimer = DispatchSource.makeTimerSource(flags: [], queue: .global())
        waitTimer?.schedule(deadline: .now() + 1.5)
        
        waitTimer?.setEventHandler(handler: { [weak self] in
            DispatchQueue.main.async {
                self?.launchAdRemove()
            }
        })
        
        waitTimer?.resume()
    }
    
    /// 图片倒计时
    private func adStartTimer() {
        if self.waitTimer?.isCancelled == false {
            self.waitTimer?.cancel()
        }
        
        adTimer = DispatchSource.makeTimerSource(flags: [], queue: .global())
        adTimer?.schedule(deadline: .now() + .seconds(showTime))
        
        adTimer?.setEventHandler(handler: { [weak self] in
            DispatchQueue.main.async {
                self?.launchAdRemove()
            }
        })
        adTimer?.resume()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    private func assetsLaunchImage() -> UIImage? {
        let size = UIScreen.main.bounds.size
        let orientation = "Portrait" //横屏 "Landscape"
        
        guard let launchImages = Bundle.main.infoDictionary?["UILaunchImages"] as? [[String: Any]] else {
            return nil
        }
        
        for dict in launchImages {
            let imageSize = NSCoder.cgSize(for: dict["UILaunchImageSize"] as! String)
            if __CGSizeEqualToSize(imageSize, size) && orientation == (dict["UILaunchImageOrientation"] as! String) {
                let launchImageName = dict["UILaunchImageName"] as! String
                let image = UIImage(named: launchImageName)
                return image
            }
        }
        return nil
    }
    
}



