//
//  VideoRecordView.swift
//  AAT
//
//  Created by DongYuan on 2017/12/28.
//  Copyright © 2017年 YiXue. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class VideoRecordView: UIView {

    var maxDuration = 10
    var recordStateCallBack: ((_ isRecording: Bool) -> ())?
    
    //录制视频时 按住中心点的垂直偏移量  用于调整焦距
    var recordCenterVerticalOffset = PublishSubject<CGFloat>()
    
    private var outsideView = UIView()
    private var insideView = UIView()
    private var percentLayer = CAShapeLayer()
    
    private var recordState = RecordState.end
    private var updateProgess: Observable<Int>?
    
    private let bag = DisposeBag()
    
    private enum RecordState: Int {
        case began
        case end
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initUI()
    }
    
    
    private func initUI() {
        outsideView.backgroundColor = UIColor.hexValue("ffffff", alpha: 0.7)
        insideView.backgroundColor = .white
        
        self.addSubview(outsideView)
        self.addSubview(insideView)
        
        self.resizeSubviews()
        
        percentLayer.fillColor = UIColor.clear.cgColor
        percentLayer.strokeColor = UIColor.aat.primary.cgColor
        percentLayer.allowsEdgeAntialiasing = true
        percentLayer.lineCap = CAShapeLayerLineCap.round
        percentLayer.lineWidth = 5
        outsideView.layer.addSublayer(percentLayer)
        
        updateProgess = Observable<Int>.interval(0.1, scheduler: MainScheduler.instance)
            .take(maxDuration * 10 + 1)
            .takeWhile({[weak self] _ in
                self?.recordState == .began
            })
            .share(replay: 1)
    }
    
    private func startRecord() {
        recordState = .began
        self.resizeSubviews()
        
        updateProgess?
            .bind {[weak self] count in
                guard let duration = self?.maxDuration else { return }
                if count >= duration * 10 {
                    self?.stopRecord()
                }else{
                    let percent =  Float(count) / Float(10 * duration)
                    self?.updateProgress(percent > 1 ? 1:percent)
                }
            }
            .disposed(by: bag)
        
        self.recordStateCallBack?(true)
    }
    
    
    private func stopRecord() {
        recordState = .end
        self.resizeSubviews()
        
        self.updateProgress(0)
        self.recordStateCallBack?(false)
    }
    
    
    private func updateProgress(_ percent: Float) {
        let path = UIBezierPath(arcCenter: outsideView.center,
                                radius: outsideView.width/2 - 3,
                                startAngle: CGFloat(Double.pi)/2 * -1,
                                endAngle: CGFloat(Double.pi)/2 * -1 + CGFloat(Double.pi) * 2 * CGFloat(percent),
                                clockwise: true)
        
        print("绘制进度: \(percent)")
        percentLayer.path = path.cgPath
    }
    
    
    private func resizeSubviews() {
        var insideWith: CGFloat = 50
        var outsideWith: CGFloat = 80
        if recordState == .began {
            insideWith = 30
            outsideWith = 105
        }
        
        let rect = self.bounds
        
        UIView.animate(withDuration: 0.2) {
            self.outsideView.frame = CGRect(x: rect.width/2 - outsideWith/2,
                                            y: rect.height/2 - outsideWith/2,
                                            w: outsideWith,
                                            h: outsideWith)
            self.outsideView.layer.cornerRadius = outsideWith/2
            
            self.insideView.frame = CGRect(x: rect.width/2 - insideWith/2,
                                           y: rect.height/2 - insideWith/2,
                                           w: insideWith,
                                           h: insideWith)
            self.insideView.layer.cornerRadius = insideWith/2
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if recordState == .end {
            self.startRecord()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        if let offset = touches.first?.location(in: insideView).y, offset <= -70 {
            let availableSpace = self.centerY - 160
            let percent = (-offset - 70) / availableSpace
            print(percent)
            recordCenterVerticalOffset.onNext(percent < 1 ? percent:1)
        }
    }
    
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        if recordState == .began {
            self.stopRecord()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if recordState == .began {
            self.stopRecord()
        }
    }
    
    
    
}
