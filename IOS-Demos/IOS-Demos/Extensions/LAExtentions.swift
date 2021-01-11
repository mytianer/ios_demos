//
//  LAExtentions.swift
//  LaiAi
//
//  Created by wenjingjie on 2018/4/8.
//  Copyright © 2018年 Jim1024. All rights reserved.
//

import UIKit
import Foundation

extension CMKit where Base == UIImageView {
    
    func setImageWith(urlString:String, placeholder: UIImage) {
        base.kf.setImage(with: URL(string: urlString), placeholder: placeholder)
    }
    
}



public extension Bundle {

    /// EZSE: load xib
    /// Usage: let view: ViewXibName = Bundle.loadNib("ViewXibName")
    class func loadNib<T>(_ name: String) -> T? {
        return Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.first as? T
    }
}


extension UITableView {
    func registerCellNib<T: UITableViewCell>(_ aClass: T.Type) {
        let name = String(describing: aClass)
        let nib = UINib(nibName: name, bundle: nil)
        register(nib, forCellReuseIdentifier: name)
    }
    
    func registerCellClass<T: UITableViewCell>(_ aClass: T.Type) {
        let name = String(describing: aClass)
        register(aClass, forCellReuseIdentifier: name)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(_ aClass: T.Type) -> T! {
        let name = String(describing: aClass)
        guard let cell = dequeueReusableCell(withIdentifier: name) as? T else {
            return aClass.init()
        }
        return cell
    }
    
    func registerHeaderFooterNib<T: UITableViewHeaderFooterView>(_ aClass: T.Type) {
        let name = String(describing: aClass)
        let nib = UINib(nibName: name, bundle: nil)
        register(nib, forHeaderFooterViewReuseIdentifier: name)
    }
    
    func registerHeaderFooterClass<T: UITableViewHeaderFooterView>(_ aClass: T.Type) {
        let name = String(describing: aClass)
        register(aClass, forHeaderFooterViewReuseIdentifier: name)
    }
    
    func dequeueReusableHeaderFooter<T: UITableViewHeaderFooterView>(_ aClass: T.Type) -> T! {
        let name = String(describing: aClass)
        guard let cell = dequeueReusableHeaderFooterView(withIdentifier: name) as? T else {
            return aClass.init()
        }
        return cell
    }
    
}

extension UICollectionView {
    func registerCellNib<T: UICollectionViewCell>(_ aClass: T.Type) {
        let name = String(describing: aClass)
        let nib = UINib(nibName: name, bundle: nil)
        register(nib, forCellWithReuseIdentifier: name)
    }
    
    func registerCellClass<T: UICollectionViewCell>(_ aClass: T.Type) {
        let name = String(describing: aClass)
        register(aClass, forCellWithReuseIdentifier: name)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(_ aClass: T.Type, for indexPath: IndexPath) -> T! {
        let name = String(describing: aClass)
        guard let cell = dequeueReusableCell(withReuseIdentifier: name, for: indexPath) as? T else {
            return aClass.init()
        }
        return cell
    }
    
    func registerHeaderFooterNib<T: UICollectionReusableView>(_ aClass: T.Type, forSupplementaryViewOfKind kind: String) {
        let name = String(describing: aClass)
        let nib = UINib(nibName: name, bundle: nil)
        register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: name)
    }
    
    func registerHeaderFooterClass<T: UICollectionReusableView>(_ aClass: T.Type, forSupplementaryViewOfKind kind: String) {
        let name = String(describing: aClass)
        register(aClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: name)
    }
    
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(_ aClass: T.Type, ofKind kind: String, for indexPath: IndexPath) -> T! {
        let name = String(describing: aClass)
        guard let view = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: name, for: indexPath) as? T else {
            return aClass.init()
        }
        
        return view
    }
}


extension NSObject {
    public var className: String {
        return type(of: self).className
    }
    
    public static var className: String {
        return String(describing: self)
    }
}


open class BlockLongPress: UILongPressGestureRecognizer {
    private var longPressAction: ((UILongPressGestureRecognizer) -> Void)?
    
    public override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }
    
    public convenience init (action: ((UILongPressGestureRecognizer) -> Void)?) {
        self.init()
        longPressAction = action
        addTarget(self, action: #selector(self.didLongPressed(_:)))
    }
    
    @objc open func didLongPressed(_ longPress: UILongPressGestureRecognizer) {
        if longPress.state == UIGestureRecognizer.State.began {
            longPressAction?(longPress)
        }
    }
}

open class BlockTap: UITapGestureRecognizer {
    private var tapAction: ((UITapGestureRecognizer) -> Void)?
    
    public override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }
    
    public convenience init (
        tapCount: Int = 1,
        fingerCount: Int = 1,
        action: ((UITapGestureRecognizer) -> Void)?) {
        self.init()
        self.numberOfTapsRequired = tapCount
        
        #if os(iOS)
            
            self.numberOfTouchesRequired = fingerCount
            
        #endif
        
        self.tapAction = action
        self.addTarget(self, action: #selector(BlockTap.didTap(_:)))
    }
    
    @objc open func didTap (_ tap: UITapGestureRecognizer) {
        tapAction? (tap)
    }
}


class MyRegex: NSObject {
    
    let regex: NSRegularExpression?
    
    init(_ pattern: String) {
        regex = try? NSRegularExpression(pattern: pattern,
                                         options: .caseInsensitive)
    }
    
    func match(_ input: String) -> Bool {
        if let matches = regex?.matches(in: input,
                                        options: [],
                                        range: NSMakeRange(0, input.count)) {
            return matches.count > 0
        } else {
            return false
        }
    }
}

extension Dictionary where Key == String {
    
    func stringValue(forKey key: String) -> String {
        if let value = self[key] {
            switch value {
            case is Bool:
                return String(value as? Bool ?? false)
            case is Int:
                return String(value as? Int ?? 0)
            case is Double:
                return String(value as? Double ?? 0)
            case is String:
                return value as? String ?? ""
            default:
                return "Object"
            }
        }
        return ""
    }
    
}

