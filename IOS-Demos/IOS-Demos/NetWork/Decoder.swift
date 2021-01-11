//
//  Decoder.swift
//  AAT
//
//  Created by 李瀚 on 2018/3/28.
//  Copyright © 2018年 YiXue. All rights reserved.
//

import Foundation
import Alamofire

struct JSONArrayEncoding: ParameterEncoding {
    
    static let arrayKey = "jsonArray"
    
    static let `default` = JSONArrayEncoding()
    
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        
        guard let json = parameters?[JSONArrayEncoding.arrayKey] else {
            return request
        }
        
        let data = try JSONSerialization.data(withJSONObject: json, options: [])
        
        if request.value(forHTTPHeaderField: "Content-Type") == nil {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        request.httpBody = data
        
        return request
    }
}

extension JSONDecoder {

    class func date(withFormat format: String) -> JSONDecoder {
        let decode = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = format
        decode.dateDecodingStrategy = JSONDecoder.DateDecodingStrategy.formatted(formatter)
        return decode
    }
    
}

extension Encodable {
    
    func toDic() -> Dictionary<String, Any> {
        let jsonEncoder = JSONEncoder()
        if let data = try? jsonEncoder.encode(self) {
            if let dic = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                return dic 
            }
        }
        return [:]
    }
    
}
