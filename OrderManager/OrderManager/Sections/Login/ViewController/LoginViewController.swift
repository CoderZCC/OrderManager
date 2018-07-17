//
//  LoginViewController.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/13.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {

    /// 账号
    @IBOutlet weak var accountTf: UITextField!
    /// 密码
    @IBOutlet weak var passwordTf: UITextField!
    /// 登录按钮
    @IBOutlet weak var loginBtn: UIButton!
    /// 头像
    @IBOutlet weak var headPic: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initView()        
    }
    
    func initView() {
        
        // 输入框设置
        self.accountTf.k_placeholderColor = kPlaceholderTextcolor
        self.passwordTf.k_placeholderColor = kPlaceholderTextcolor
        
        // 登录按钮设置
        self.loginBtn.k_setCornerRadius(kCornerRadius)
        self.loginBtn.isEnabled = false
        self.viewModel.loginBtnEnabledBacK = { [unowned self] isEnabled in
            self.loginBtn.isEnabled = isEnabled
        }
        // 头像设置
        self.headPic.k_setCircleImgV()
        self.headPic.k_setImage(url: LoginModel.cachesHeadPic)
        self.viewModel.headImgVChange = { [unowned self] imgUrl in
            self.headPic.k_setImage(url: imgUrl)
        }
    }
    
    /// 登录按钮点击事件
    @IBAction func loginBtnAction(_ sender: UIButton) {
        
        self.viewModel.login {
            
            kAppDelegate.loginResult(isSuccess: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        
        self.viewModel.headImgVChange = nil
        self.viewModel.loginBtnEnabledBacK = nil
    }
    
    lazy var viewModel: LoginViewModel = { [unowned self] in
        let model = LoginViewModel.init(accountTf: self.accountTf)
        
        return model
    }()

}
