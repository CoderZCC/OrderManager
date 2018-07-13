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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initView()        
    }
    
    func initView() {
        
        self.loginBtn.k_setCornerRadius(kCornerRadius)
        self.accountTf.k_placeholderColor = kPlaceholderTextcolor
        self.passwordTf.k_placeholderColor = kPlaceholderTextcolor
        
        self.loginBtn.isEnabled = false
        self.viewModel.loginBtnEnabledBacK = { isEnabled in
            
            self.loginBtn.isEnabled = isEnabled
        }
    }
    
    @IBAction func loginBtnAction(_ sender: UIButton) {
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    lazy var viewModel: LoginViewModel = { [unowned self] in
        let model = LoginViewModel.init(accountTf: self.accountTf)
        
        return model
    }()

}
