//
//  LACmLoginVC.swift
//  LaiAi
//
//  Created by wenjingjie on 2018/5/4.
//  Copyright © 2018年 Jim1024. All rights reserved.
//

import UIKit

/// 登录页面
class LoginViewController: UIViewController, UITextFieldDelegate, NavigationManagerProtocol {
    
    var navigationBarShouldHidden: Bool { return true }
    var disableInteractivePopGestureRecognizer: Bool { return true }
    
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var getCodeButton: UIButton!
    
//    @IBOutlet weak var protocolLabel: TTTAttributedLabel!
    @IBOutlet weak var exchangeBtn: UIButton!
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var hud: UIActivityIndicatorView!
    
    private var accountString = ""
    private var codeString = ""
    private var getCodeAccount = ""
    
    private var timerCount = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        IQKeyboardManager.shared.enable = true
//        IQKeyboardManager.shared.keyboardDistanceFromTextField = 100
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        IQKeyboardManager.shared.keyboardDistanceFromTextField = 10
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmButton.setBackgroundImage(UIImage.colors(colors: [R.color.primary()!, R.color.secondary()!],
                                                        size: confirmButton.size), for: .normal)
        self.navigationController?.navigationBar.shadowImageLine?.isHidden = true
        
        updateButtonState()
        setupProtocolLabel()
        accountTextField.attributedPlaceholder = NSAttributedString(string: "请输入手机号",
                                                             attributes: [.font: UIFont.pingFangSC(size: 16),
                                                                          .foregroundColor: R.color.thirdText()!])
        codeTextField.attributedPlaceholder = NSAttributedString(string: "请输入验证码",
                                                          attributes: [.font: UIFont.pingFangSC(size: 16),
                                                                       .foregroundColor: R.color.thirdText()!])
        accountTextField.addTarget(self, action: #selector(self.accountTextFieldChanged), for: .editingChanged)
        codeTextField.addTarget(self, action: #selector(self.codeTextFieldChanged), for: .editingChanged)
        codeTextField.delegate = self
        codeTextField.returnKeyType = .go
        
        NavigationManager.share.takeOverNavigationController(navigationController)
    }
    
    
    func setupProtocolLabel() {
//        let attr = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13),
//                    NSAttributedString.Key.foregroundColor: UIColor.cm.primaryText]
//        self.protocolLabel.linkAttributes = attr
//        self.protocolLabel.activeLinkAttributes = attr
//        self.protocolLabel.lineBreakMode = .byWordWrapping
//        self.protocolLabel.lineSpacing = 5.0
//        let protocol1 = "《优市销售平台协议》"
//        let protocol2 = "《优市用户注册协议》"
//        let protocol3 = "《用户隐私协议》"
//        let range1 = NSMakeRange(0, protocol1.count)
//        let range2 = NSMakeRange(range1.location + range1.length + 1, protocol2.count)
//        let range3 = NSMakeRange(range2.location + range2.length + 1, protocol3.count)
//        let urlLink1 = self.protocolLabel.addLink(toPhoneNumber: protocol1, with: range1)
//        let urlLink2 = self.protocolLabel.addLink(toPhoneNumber: protocol2, with: range2)
//        let urlLink3 = self.protocolLabel.addLink(toPhoneNumber: protocol3, with: range3)
//        urlLink1?.linkTapBlock = TTTAttributedLabelLinkBlock?.init({[weak self] (TTTAttributedLabel, TTTAttributedLabelLink) in
//            let vc = LACloudMallWebViewController()
//            vc.title = "优市销售平台协议"
//            vc.urlString = String.cm.platformSellProtocolURLString
//            self?.navigationController?.pushViewController(vc, animated: true)
//        })
//        urlLink2?.linkTapBlock = TTTAttributedLabelLinkBlock?.init({[weak self] (TTTAttributedLabel, TTTAttributedLabelLink) in
//            let vc = LACloudMallWebViewController()
//            vc.title = "优市用户注册协议"
//            vc.urlString = String.cm.registerProtocolURLString
//            self?.navigationController?.pushViewController(vc, animated: true)
//        })
//        urlLink3?.linkTapBlock = TTTAttributedLabelLinkBlock?.init({[weak self] (TTTAttributedLabel, TTTAttributedLabelLink) in
//            let vc = LACloudMallWebViewController()
//            vc.title = "用户隐私协议"
//            vc.urlString = String.cm.privacyURLString
//            self?.navigationController?.pushViewController(vc, animated: true)
//        })
    }
    
    func updateButtonState() {
        if accountString.count > 0 && self.codeString.count >= 6 {
            confirmButton.isEnabled = true
        } else {
            confirmButton.isEnabled = false
        }
    }
    
    @IBAction func didClickLosePhone(_ sender: Any) {
//        let vc = LACloudMallWebViewController()
//        vc.urlString = Api.BaseURL.modifyPhone
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didClickgetCodeButton(_ sender: UIButton) {
        self.getCodeAccount = self.accountString
        guard accountTextField.text?.isPhoneNumber == true else {
            ProgressHUD.show("请填有效的手机号")
            return
        }
    }
    
    @IBAction func onLoginButton(_ sender: Any) {
        self.login()
    }

    func login() {
        if self.getCodeAccount != self.accountString {
            ProgressHUD.show("当前手机号和获取验证码手机号不匹配！")
            return
        }
        confirmButton.isUserInteractionEnabled = false
        hud.startAnimating()
    }
    
    func startTimer() {
        if self.timerCount > 0 {
            getCodeButton.setTitle("\(self.timerCount)s后重新获取", for: .disabled)
            getCodeButton.setTitleColor(R.color.thirdText()!, for: .disabled)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {[weak self] in
                self?.timerCount = (self?.timerCount ?? 1) - 1
                self?.startTimer()
            }
        } else {
            getCodeButton.isEnabled = true
            getCodeButton.setTitle("获取验证码", for: .normal)
            getCodeButton.setTitleColor(R.color.primaryVariant()!, for: .normal)
        }
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        self.login()
        return true
    }
    
    @objc func accountTextFieldChanged(_ textField: UITextField) {
        accountString = textField.text ?? ""
        self.timerCount = 0
        updateButtonState()
    }
    
    @objc func codeTextFieldChanged(_ textField: UITextField) {
        codeString = textField.text ?? ""
        updateButtonState()
    }
   
}

