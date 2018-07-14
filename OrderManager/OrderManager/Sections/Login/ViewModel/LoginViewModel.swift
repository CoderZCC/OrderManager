//
//  LoginViewModel.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/13.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

/// 消费表
let kUserListName: String = "User"

class LoginViewModel: NSObject {
    
    /// 按钮是否可用
    var loginBtnEnabledBacK: ((Bool)->Void)?
    /// 账号是否可用
    var isAccountEnabled: Bool {
        
        return self.loginModel.account.count > 0
    }
    /// 密码是否可用
    var isPasswordEnabled: Bool {
        
        return self.loginModel.password.count > 5
    }
    /// 数据模型
    var loginModel: LoginModel = LoginModel()
    
    convenience init(accountTf: UITextField) {
        self.init()
        
        accountTf.text = LoginModel.cachesAccount
        if let cachesAcount = accountTf.text {
            self.loginModel.account = cachesAcount
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: nil, queue: OperationQueue.main) { (note) in
            
            let currentTf = note.object as! UITextField
            
            if accountTf == currentTf {
                
                self.loginModel.account = currentTf.text!
                
            } else {
                
                self.loginModel.password = currentTf.text!
            }
            self.loginBtnEnabledBacK?(self.isAccountEnabled && self.isPasswordEnabled)
        }
    }
    
    /// 登录
    ///
    /// - Parameter callBack: 回调
    func login(callBack: CallBack) {
        
        // 先检查用户是否存在
        self.showLoading("检查账号中")
        RegisterViewModel.userIsExit(account: self.loginModel.account) { (isOK, obj) in
            
            if let userObj = obj {
                
                let account: String = userObj.object(forKey: "account") as! String
                let password: String = userObj.object(forKey: "password") as! String
                let objectId: String = userObj.object(forKey: "objectId") as! String

                // 检查密码
                if password == self.loginModel.password {
                    
                    // 移除通知
                    NotificationCenter.default.removeObserver(self)
                    
                    callBack?()
                    self.showText("欢迎你,\(account)!")
                    // 保存账号
                    kSaveDataTool.k_addValueToUserdefault(key: kAccountkey, value: account)
                    // 保存密码
                    kSaveDataTool.k_saveOrUpdatePassword(account: account, password: password)
                    
                    // 保存userId
                    kSaveDataTool.k_addValueToUserdefault(key: kUserIdkey, value: objectId)

                } else {
                    
                    self.showText("账号或密码错误")
                }
                
            } else {
                
                // 用户不存在
                self.showText("用户不存在")
            }
        }
    }
}
