//
//  CMKit.swift
//  LaiAi
//
//  Created by wenjingjie on 2018/4/26.
//  Copyright © 2018年 Jim1024. All rights reserved.
//

import Foundation
import Moya
import PromiseKit


/// 类型协议
protocol TypeWrapperProtocol {
    associatedtype Base
    var base: Base { get }
    init(value: Base)
}
struct CMKit<T>: TypeWrapperProtocol {
    let base: T
    init(value: T) {
        self.base = value
    }
}


/// 命名空间协议
protocol CMKitCompatible {
    associatedtype WrapperType
    var cm: WrapperType { get }
    static var cm: WrapperType.Type { get }
}
extension CMKitCompatible {
    var cm: CMKit<Self> {
        return CMKit(value: self)
    }
    static var cm: CMKit<Self>.Type {
        return CMKit.self
    }
}
/*
public struct CMKit<Base> {
    public let base: Base
    
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol CMKitCompatible {
    associatedtype BaseType
    
    static var cm: BaseType.Type { get }
    var cm: BaseType { get }
}

extension CMKitCompatible {
    public static var cm: CMKit<Self>.Type {
        return CMKit<Self>.self
    }
    
    public var cm: CMKit<Self> {
        return CMKit(self)
    }
}
*/
extension NSObject: CMKitCompatible { }




