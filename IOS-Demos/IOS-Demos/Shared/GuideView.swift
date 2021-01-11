//
//  IntroduceView.swift
//  LaiAi
//
//  Created by Yixue_ZhangWentong on 2018/08/21.
//  Copyright © 2018 Jim1024. All rights reserved.
//

import UIKit
import SnapKit

//枚举，popView出现的位置
enum PopViewPosition : Int,Codable {
    case left
    case center
    case right
}
class IntroduceView: UIView {

    var detail:String?{
        didSet{
            self.mainTitleLabel?.text = detail
        }
    }
    var arrowPosition:PopViewPosition = .center{
        didSet{
            switch arrowPosition {
            case PopViewPosition.left:
                self.arrowImageView?.snp.remakeConstraints { (maker) in
                    maker.top.equalTo(self.snp.top)
                    maker.bottom.equalTo((self.contentView ?? UIView()).snp.top)
                    maker.leading.equalTo(self.snp.leading).offset(10)
                }
                self.layoutIfNeeded()
            case PopViewPosition.center:
                self.arrowImageView?.snp.remakeConstraints { (maker) in
                    maker.top.equalTo(self.snp.top)
                    maker.bottom.equalTo((self.contentView ?? UIView()).snp.top)
                    maker.centerX.equalTo(self.snp.centerX)
                }
                self.layoutIfNeeded()
            case PopViewPosition.right:
                self.arrowImageView?.snp.remakeConstraints { (maker) in
                    maker.top.equalTo(self.snp.top)
                    maker.bottom.equalTo((self.contentView ?? UIView()).snp.top)
                    maker.trailing.equalTo(self.snp.trailing).offset(-10)
                }
                self.layoutIfNeeded()
            }
        }
    }
    
    var cancelBlock:((UIButton)->Void)?
    
    fileprivate var arrowImageView:UIImageView?
    private var contentView:UIView?
    private var backgroundImageView:UIImageView?
    private var mainTitleLabel:UILabel?
    private var cancelButton:UIButton?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.initCustomViews()
        
    }
    private func initCustomViews(){
        self.isUserInteractionEnabled = true
        
        self.backgroundColor = UIColor.clear
        self.arrowImageView = UIImageView(image: #imageLiteral(resourceName: "shop_remind_once"))
        self.addSubview(self.arrowImageView ?? UIView())
        self.contentView = UIView()
        self.contentView?.translatesAutoresizingMaskIntoConstraints = false
        self.contentView?.layer.shadowOffset = CGSize(width: 1, height:  1)
        self.contentView?.layer.shadowColor = R.color.onBackground()?.cgColor
        self.contentView?.layer.shadowRadius = 6
        self.contentView?.isUserInteractionEnabled = true
        self.contentView?.cornerRadius = 6
        self.addSubview(self.contentView ?? UIView())
        self.backgroundImageView = UIImageView(image: #imageLiteral(resourceName: "btn_tag_lighted"))
        self.backgroundImageView?.contentMode = .scaleAspectFill
        self.backgroundImageView?.cornerRadius = 6
        self.backgroundImageView?.isUserInteractionEnabled = true
        self.contentView?.addSubview(self.backgroundImageView ?? UIView())
        self.backgroundImageView?.snp.makeConstraints { (maker) in
            maker.edges.equalTo((self.contentView ?? UIView()).snp.edges)
            maker.width.height.equalTo((self.contentView ?? UIView()))
        }
        self.mainTitleLabel = UILabel()
        self.mainTitleLabel?.textColor = UIColor.white
        self.mainTitleLabel?.font = UIFont.init(name: "PingFangSC-Medium", size: 15)
        self.mainTitleLabel?.lineBreakMode = .byWordWrapping
        self.mainTitleLabel?.numberOfLines = 0
        self.mainTitleLabel?.text = "内容"
        self.contentView?.addSubview(self.mainTitleLabel ?? UIView())
        self.contentView?.bringSubviewToFront(self.mainTitleLabel ?? UIView())
        self.cancelButton = UIButton(type: .custom)
        self.cancelButton?.setImage(#imageLiteral(resourceName: "shop_remind_close"), for: .normal)
        self.cancelButton?.isUserInteractionEnabled = false
        self.contentView?.addSubview(self.cancelButton ?? UIView())
        self.contentView?.bringSubviewToFront(self.cancelButton ?? UIView())
        self.mainTitleLabel?.snp.makeConstraints { (maker) in
            maker.top.equalTo((self.contentView ?? UIView()).snp.top).offset(9)
            maker.bottom.equalTo((self.contentView ?? UIView()).snp.bottom).offset(-9)
            maker.leading.equalTo((self.contentView ?? UIView()).snp.leading).offset(9)
            maker.trailing.equalTo((self.cancelButton ?? UIView()).snp.leading).offset(-9)
        }
        self.cancelButton?.snp.makeConstraints { (maker) in
            maker.centerY.equalTo((self.mainTitleLabel ?? UIView()).snp.centerY)
            maker.trailing.equalTo((self.contentView ?? UIView()).snp.trailing).offset(-9)
            maker.height.width.equalTo(14)
        }
        
        self.arrowImageView?.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.snp.top)
            maker.bottom.equalTo((self.contentView ?? UIView()).snp.top)
            maker.centerX.equalTo(self.snp.centerX)
        }
        self.contentView?.snp.makeConstraints { (maker) in
            maker.leading.equalTo(self.snp.leading)
            maker.trailing.equalTo(self.snp.trailing)
            maker.bottom.equalTo(self.snp.bottom)
        }
    }
    
    
    @objc func cancelButtonTapped(_ bt:UIButton){
        dismiss()
        self.cancelBlock?(bt)
        
    }
    open func showAtView(view:UIView?,arrowPosition:PopViewPosition = .center){
        let rect = view?.convert(view?.bounds ?? CGRect.zero, to: UIApplication.shared.keyWindow ?? UIWindow()) ?? CGRect.zero
        self.showInRect(rect: rect, arrowPosition: arrowPosition)
    }
    open func showInPoint(point:CGPoint,arrowPosition:PopViewPosition = .center){
        print(point)
        self.arrowPosition = arrowPosition
        let keyWindow = UIApplication.shared.keyWindow ?? UIWindow()
        keyWindow.addSubview(self)
        self.arrowImageView?.snp.makeConstraints { (maker) in
            maker.top.equalTo(keyWindow).offset(point.y + 20)
            maker.leading.equalTo(keyWindow).offset(point.x)
        }

        self.alpha = 0
        
        //淡出动画
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.5)
        self.alpha = 1
        UIView.commitAnimations()
    }
    open func showInRect(rect:CGRect,arrowPosition:PopViewPosition = .center){
        let point = CGPoint(x: rect.origin.x, y: rect.origin.y)
        self.arrowPosition = arrowPosition
        let keyWindow = UIApplication.shared.keyWindow ?? UIWindow()
        keyWindow.addSubview(self)
        self.arrowImageView?.snp.makeConstraints { (maker) in
            maker.top.equalTo(keyWindow.snp.top).offset(point.y + 20)
            maker.leading.equalTo(keyWindow.snp.leading).offset(point.x)
        }
        
        self.alpha = 0
        
        //淡出动画
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.5)
        self.alpha = 1
        UIView.commitAnimations()
        
    }
    
    open func dismiss(){
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.5)
        self.alpha = 0
        UIView.commitAnimations()
        let time: TimeInterval = 0.5
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(Int(time * 1000))){
            self.removeFromSuperview()
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        
    }

}


class GuideView: UIView {
    
    var introView:IntroduceView?
    var cancelGuide:((UITapGestureRecognizer)->Void)?
    var detail:String?{
        didSet{
            self.introView?.detail = detail
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.1)
        self.introView = IntroduceView()
        self.introView?.detail = "XXXXXXXXXXXX"
        self.addSubview(self.introView ?? UIView())
        self.bringSubviewToFront(self.introView ?? UIView())
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        self.addGestureRecognizer(tap)
    }
    convenience init(detail:String?,cancelGuide:((UITapGestureRecognizer)->Void)?){
        self.init(frame: UIScreen.main.bounds)
        self.introView?.detail = detail
        self.cancelGuide = cancelGuide
    }
    @objc func backgroundTapped(_ tap:UITapGestureRecognizer){
        self.dismiss()
        self.cancelGuide?(tap)
    }

    open func showAtView(view:UIView?,arrowPosition:PopViewPosition = .center){
        let rect = view?.convert(view?.bounds ?? CGRect.zero, to: UIApplication.shared.keyWindow ?? UIWindow()) ?? CGRect.zero
        self.showInRect(rect: rect, arrowPosition: arrowPosition)
    }
    open func showInPoint(point:CGPoint,arrowPosition:PopViewPosition = .center){
        self.introView?.arrowPosition = arrowPosition
        let keyWindow = UIApplication.shared.keyWindow ?? UIWindow()
        keyWindow.addSubview(self)
        self.introView?.arrowImageView?.snp.makeConstraints { (maker) in
            maker.top.equalTo(keyWindow).offset(point.y + 25)
            maker.leading.equalTo(keyWindow).offset(point.x)
        }
        
        self.alpha = 0
        
        //淡出动画
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.5)
        self.alpha = 1
        UIView.commitAnimations()
    }
    open func showInRect(rect:CGRect,arrowPosition:PopViewPosition = .center){
        let point = CGPoint(x: rect.maxX/2+rect.minX/2, y: rect.maxY/2+rect.minY/2)
        self.introView?.arrowPosition = arrowPosition
        let keyWindow = UIApplication.shared.keyWindow ?? UIWindow()
        keyWindow.addSubview(self)
        self.introView?.arrowImageView?.snp.makeConstraints { (maker) in
            maker.top.equalTo(keyWindow.snp.top).offset(point.y + 20)
            maker.leading.equalTo(keyWindow.snp.leading).offset(point.x)
        }
        
        self.alpha = 0
        
        //淡出动画
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.5)
        self.alpha = 1
        UIView.commitAnimations()
        
    }
    open func dismiss(){
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.5)
        self.alpha = 0
        UIView.commitAnimations()
        let time: TimeInterval = 0.5
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(Int(time * 1000))){
            self.removeFromSuperview()
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
}
