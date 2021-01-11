//
//  Api+File.swift
//  LaiAi
//
//  Created by DongYuan on 2018/5/22.
//  Copyright © 2018年 Jim1024. All rights reserved.
//

import Foundation
import Moya
import Promises

extension Api {
    
    struct File {
        
        fileprivate static let defaultProvider = DefaultProvider<API>()
        
        fileprivate enum API {
            case downloadFile(url: URL, destination: URL, fileName: String)
            case uploadImages(images: [UIImage])
        }
    }
}

extension Api.File {
    
    static func downloadFile(url: URL, destinationDirectory: URL, fileName: String, progress: ProgressBlock? = .none) -> Promise<Response> {
        return defaultProvider.cm.request(.downloadFile(url: url, destination: destinationDirectory, fileName: fileName), progress: progress)
    }

    static func uploadImages(images: [UIImage]) -> Promise<[String]> {
        return defaultProvider.cm.request(.uploadImages(images: images))
            .filterCodeMsg()
            .map([String].self, atKeyPath: "data")
    }
    
}

extension Api.File.API: TargetTypeDescription {
    var description: String {
        switch self {
        case .downloadFile:
            return "下载文件"
        case .uploadImages:
            return "上传多张图片"
        }
    }
}

extension Api.File.API: TargetType {
    var baseURL: URL {
        if case .downloadFile(let url, _, _) = self {
            return url
        }
        return URL(string: Api.BaseURL.gateway)!
    }
    
    var path: String {
        switch self {
        case .uploadImages:
            return "laiai-ys-member/api/common/imageUpload"
        default:
            return ""
        }
    }
    
    var method: Moya.Method {
        if case .downloadFile = self {
            return .get
        }
        return .post
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .downloadFile(_ , let destination, let fileName):
            return .downloadDestination({ _, response  in
                //两个参数表示如果有同名文件则会覆盖，如果路径中文件夹不存在则会自动创建
                (destinationURL: URL(fileURLWithPath: destination.path.appending("/\(fileName)")),
                 options: [.removePreviousFile, .createIntermediateDirectories])
            })
            
        case let .uploadImages(images):
            if images.count <= 0 { // 大于0才继续上传到服务器，否则会闪退
                return .requestPlain
            }
            var formDatas = [MultipartFormData]()
            for image in images {
                let data = image.compressToData(500 * 1000)
                let formData = MultipartFormData(provider: .data(data), name: "images", fileName: "image.png", mimeType: "image/png")
                formDatas.append(formData)
            }
            return .uploadMultipart(formDatas)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
}

