//
//  Provider.swift
//  LaiAi
//
//  Created by wenjingjie on 2018/4/26.
//  Copyright © 2018年 Jim1024. All rights reserved.
//

import Foundation
import Moya

class DefaultProvider<Target>: MoyaProvider<Target> where Target: TargetType {
    
    override init(endpointClosure: @escaping EndpointClosure = MoyaProvider.defaultEndpointMapping,
                  requestClosure: @escaping RequestClosure = MoyaProvider<Target>.defaultRequestMapping,
                  stubClosure: @escaping StubClosure = MoyaProvider.neverStub,
                  callbackQueue: DispatchQueue? = nil,
                  session: Session = MoyaProvider<Target>.defaultAlamofireSession(),
                  plugins: [PluginType] = [],
                  trackInflights: Bool = false) {

        var allPlugins = plugins
        allPlugins.append(HeaderPlugin())
        #if LAIAI_TEST
        allPlugins.append(LogPlugin(output: Log.reversedLog))
        #endif
        
        super.init(endpointClosure: endpointClosure,
                   requestClosure: requestClosure,
                   stubClosure: stubClosure,
                   callbackQueue: callbackQueue,
                   session: session,
                   plugins: allPlugins,
                   trackInflights: trackInflights)

    }
    
}


private struct HeaderPlugin: PluginType {
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        let currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
        
        var req = request
//        req.setValue(CMUser.accessToken, forHTTPHeaderField: "X-Access-Token")
        req.setValue(currentVersion, forHTTPHeaderField: "appVersion")
        req.setValue("app", forHTTPHeaderField: "client")
        req.setValue("ios", forHTTPHeaderField: "channel")
        
        return req
    }
    
}



private struct LogPlugin: PluginType {
    
    private let separator = ", "
    private let terminator = "\n"
    private let output: (_ separator: String, _ terminator: String, _ items: Any...) -> Void
    
    public init(output: ((_ separator: String, _ terminator: String, _ items: Any...) -> Void)? = nil) {
        self.output = output ?? LogPlugin.reversedPrint
    }
    
    func willSend(_ request: RequestType, target: TargetType) {
        output(separator, terminator, logNetworkRequest(request.request as URLRequest?, target: target))
    }
    
    func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        if case .success(let response) = result {
            output(separator, terminator, logNetworkResponse(response.response, data: response.data, target: target))
        } else {
            output(separator, terminator, logNetworkResponse(nil, data: nil, target: target))
        }
    }
    
    private func format(identifier: String, message: String) -> String {
        return "\(identifier): \(message)"
    }
    
    private func logNetworkRequest(_ request: URLRequest?, target: TargetType) -> String {
        
        var output = format(identifier: "\(target.description) Request", message: "") + terminator
        
        if let des = request?.description {
            output += "   Url    : \(des)" + terminator
        }else{
            output += "   ⚠️ invalid request!!!" + terminator
        }
        
        if let headers = request?.allHTTPHeaderFields {
            output += "   Headers: \(headers.description)" + terminator
        }
        
        if let bodyStream = request?.httpBodyStream {
            output += "   Stream : \(bodyStream.description)" + terminator
        }
        
        if let httpMethod = request?.httpMethod {
            output += "   Method : \(httpMethod)" + terminator
        }
        
        if let body = request?.httpBody, let stringOutput = String(data: body, encoding: .utf8) {
            if request?.value(forHTTPHeaderField: "Content-Type") == "application/x-www-form-urlencoded; charset=utf-8" {
                let strs = stringOutput.components(separatedBy: "&")
                var dic = [String : String]()
                for str in strs {
                    let ss = str.components(separatedBy: "=")
                    dic.updateValue(ss.last ?? "", forKey: ss.first ?? "")
                }
                
                let jsonData = try? JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
                let stringData = String(data: jsonData!, encoding: String.Encoding.utf8) ?? ""
                output += "   Body   :" + terminator
                output += stringData
            }else{
                output += "   Body   : \(stringOutput)"
            }
        }
        
        return output
    }
    
    private func logNetworkResponse(_ response: HTTPURLResponse?, data: Data?, target: TargetType) -> String {
        guard let response = response else {
            return format(identifier: "\(target.description) Response", message: "Received empty network response for \(target).")
        }
        
        var output = format(identifier: "\(target.description) Response", message: "") + terminator
        
        if let url = response.url {
            output += "   Url    : \(url)" + terminator
        }
        
        output += "   Code   : \(response.statusCode)" + terminator
        
        if let data = data {
            var stringData = ""
            
            if let dic = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                let jsonData = try? JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
                stringData = String(data: jsonData ?? Data(), encoding: String.Encoding.utf8) ?? ""
                output += "   Data   :" + terminator
                output += stringData
            }else{
                stringData = String(data: data, encoding: String.Encoding.utf8) ?? ""
                output += "   Data   : \(stringData)"
            }
        }
        
        return output
    }
    
    
    static func reversedPrint(_ separator: String, terminator: String, items: Any...) {
        for item in items {
            print(item, separator: separator, terminator: terminator)
        }
    }
}


