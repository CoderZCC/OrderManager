//
//  LeftViewController.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/13.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class LeftViewController: BaseViewController {

    @IBOutlet weak var logoutBtn: UIButton!
    
    @IBOutlet weak var rightCons: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
    }

    func initView() {
        
        self.logoutBtn.k_setCornerRadius(kCornerRadius)
        self.rightCons.constant = kWidth - kSliderMaxWidth
    }
    
    @IBAction func logoutAction() {
        
        self.k_showAlert(title: "确定要退出登录吗?") {
            
            kSaveDataTool.k_deletePassword(account: LoginModel.cachesAccount)
            kAppDelegate.loginResult(isSuccess: false)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
