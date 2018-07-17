//
//  RegisterViewController.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/13.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController {

    /// 账号
    @IBOutlet weak var accountTf: UITextField!
    /// 密码
    @IBOutlet weak var passwordTf: UITextField!
    /// 注册按钮
    @IBOutlet weak var registerBtn: UIButton!
    /// 头像
    @IBOutlet weak var headImgV: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initView()
    }

    func initView() {
        
        // 输入框设置
        self.accountTf.k_placeholderColor = kPlaceholderTextcolor
        self.passwordTf.k_placeholderColor = kPlaceholderTextcolor
        // 注册按钮设置
        self.registerBtn.k_setCornerRadius(kCornerRadius)
        self.registerBtn.isEnabled = false
        self.viewModel.registerBtnEnabledBacK = { [unowned self] isEnabled in
            
            self.registerBtn.isEnabled = isEnabled
        }
        // 头像设置
        self.headImgV.k_setCircleImgV()
        self.viewModel.headPicCallBack = { img in
            
            self.headImgV.image = img
        }
        self.headImgV.k_addTarget { (tap) in
            
            self.view.endEditing(true)
            self.viewModel.selectedImg()
        }
    }
    
    /// 注册事件
    @IBAction func registerAction() {
        
        self.viewModel.headPic = self.headImgV.image!
        self.viewModel.register {
            
            kAppDelegate.loginResult(isSuccess: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        
        self.viewModel.headPicCallBack = nil
        self.viewModel.registerBtnEnabledBacK = nil
    }
    
    lazy var viewModel: RegisterViewModel = { [unowned self] in
        let model = RegisterViewModel.init(accountTf: self.accountTf)
        
        return model
    }()
}
