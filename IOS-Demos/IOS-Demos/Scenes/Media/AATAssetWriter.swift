//
//  AATVideoWriter.swift
//  AAT
//
//  Created by DongYuan on 2018/1/3.
//  Copyright © 2018年 YiXue. All rights reserved.
//

import Foundation
import AVFoundation
import CoreMedia



class AATAssetWriter {
    
    enum WriteState: Int {
        case prepare
        case writing
        case finish
        case fail
    }
    
    private var assetWriter: AVAssetWriter?
    
    private var audioInput: AVAssetWriterInput?
    private var videoInput: AVAssetWriterInput?
    
    var audioTrackSettings: [String: Any]?
    var videoTrackSettings: [String: Any]?
    
    var audioTrackSourceFormatDescription: CMFormatDescription?
    var videoTrackSourceFormatDescription: CMFormatDescription?
    
    var tempFilePath = ""
    var status = WriteState.prepare
    
    private var haveStartedSession = false
    
    private let writingQueue = DispatchQueue(label: "com.yixue.laiai.videoWriting")
    
    
    
    deinit {
        assetWriter?.cancelWriting()
    }
    
    
    func prepareToRecord() {
        
        do {
            if FileManager.default.fileExists(atPath: self.tempFilePath) {
                try FileManager.default.removeItem(atPath: self.tempFilePath)
            }
        } catch let error {
            print("删除已存在的文件失败: \(error.localizedDescription)")
        }
        
        guard let aw = try? AVAssetWriter(url: URL(fileURLWithPath: self.tempFilePath), fileType: AVFileType.mp4) else {
            print("初始化AssetWriter失败")
            return
        }
        self.assetWriter = aw
        
        
        if self.assetWriter?.canApply(outputSettings: audioTrackSettings, forMediaType: AVMediaType.audio) == true {
            self.audioInput = AVAssetWriterInput(mediaType: AVMediaType.audio, outputSettings: audioTrackSettings, sourceFormatHint: audioTrackSourceFormatDescription)
            self.audioInput?.expectsMediaDataInRealTime = true
            
            if self.assetWriter?.canAdd(self.audioInput!) == true {
                self.assetWriter?.add(self.audioInput!)
            }
        }
        
        if self.assetWriter?.canApply(outputSettings: videoTrackSettings, forMediaType: AVMediaType.video) == true {
            self.videoInput = AVAssetWriterInput(mediaType: AVMediaType.video, outputSettings: videoTrackSettings, sourceFormatHint: videoTrackSourceFormatDescription)
            self.videoInput?.expectsMediaDataInRealTime = true
            self.videoInput?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2)) //人像方向
            
            if self.assetWriter?.canAdd(self.videoInput!) == true {
                self.assetWriter?.add(self.videoInput!)
            }
        }
        
    }
    
    
    func startRecording() {
        if self.assetWriter?.startWriting() == false {
            print("assetWriter开始写入失败: \(self.assetWriter?.error?.localizedDescription ?? "")")
            return
        }
        
        self.transition(status: .writing)
    }
    
    
    
    func finishRecording() {
        switch (self.status) {
        case .prepare, .finish:
            print("还没有开始记录")
            return
        case .fail:
            print("记录失败")
        case .writing:
            self.transition(status: .finish)
        }
        
        self.assetWriter?.finishWriting(completionHandler: {[weak self] in
            if let error = self?.assetWriter?.error {
                print("assetWriter写入失败: \(error.localizedDescription)")
                self?.transition(status: .fail)
            }else{
                self?.transition(status: .finish)
            }
        })
    }
    
    
    
    func append(sampleBuffer: CMSampleBuffer, mediaType: AVMediaType) {
        
        writingQueue.async {[unowned self] in
            if self.status != .writing {
                print("不是在录制状态中  status == \(self.status.rawValue)")
                return
            }
            
            if self.haveStartedSession == false && mediaType == AVMediaType.video {
                self.assetWriter?.startSession(atSourceTime: CMSampleBufferGetPresentationTimeStamp(sampleBuffer))
                self.haveStartedSession = true
            }
            
            let input = mediaType == AVMediaType.video ? self.videoInput:self.audioInput
            
            if input?.isReadyForMoreMediaData == true {
                if input?.append(sampleBuffer) == false {
                    self.transition(status: .fail)
                }
            }else{
                print("\(mediaType) 输入不能添加更多数据了，抛弃 buffer")
            }
        }
        
    }
    
    
    func transition(status: WriteState) {
        if status != self.status {
            if status == .finish || status == .fail {
                writingQueue.async {[unowned self] in
                    self.assetWriter = nil
                    self.audioInput = nil
                    self.videoInput = nil
                    self.haveStartedSession = false
                    if status == .fail {
                        try? FileManager.default.removeItem(atPath: self.tempFilePath)
                    }
                }
            }
            self.status = status
        }
        
    }
    
    
}
