//
//  RegisterViewModel.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/13.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class RegisterViewModel: NSObject {

    /// 按钮是否可用
    var registerBtnEnabledBacK: ((Bool)->Void)?
    /// 头像图片
    var headPicCallBack: ((UIImage)->Void)?
    
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
    /// 头像
    var headPic: UIImage = #imageLiteral(resourceName: "defaultImg") {
        willSet {
            
            self.headPicCallBack?(newValue)
        }
    }
    
    convenience init(accountTf: UITextField) {
        self.init()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: nil, queue: OperationQueue.main) { (note) in
            
            let currentTf = note.object as! UITextField
            
            if accountTf == currentTf {
                
                self.loginModel.account = currentTf.text!
                
            } else {
                
                self.loginModel.password = currentTf.text!
            }
            self.registerBtnEnabledBacK?(self.isAccountEnabled && self.isPasswordEnabled)
        }
    }
    
    /// 选择照片事件
    func selectedImg() {
        
        self.k_showSheets(title: "请选择", subTitles: ["从相册获取", "拍照"], callBack: { [unowned self] (index) in
            
            if index == 0 {
                
                CameraTool.takeImage(callBack: { [unowned self] (img) in
                    
                    self.headPic = img
                })
                
            } else {
                
                CameraTool.takePhoto(callBack: { [unowned self] (img) in
                    
                    self.headPic = img
                })
            }
        })
    }
    
    /// 注册按钮点击事件
    ///
    /// - Parameter callBack: 回调
    func register(callBack: CallBack) {
        
        // 先检查用户是否存在
        self.showLoading("检查账号中")
        ServicerTool.userIsExit(account: self.loginModel.account) { [unowned self] (isOk, obj) in
            
            if let _ = obj {
                
                self.showText("账号已存在")
                
            } else {
                
                // 上传头像
                ServicerTool.uploadImg(img: self.headPic, callBack: { [unowned self] (str) in
                    
                    self.loginModel.headPic = str
                    // 保存信息
                    self.addData(callBack: callBack)
                })
            }
        }
    }
    /// 设置注册信息
    private func addData(callBack: CallBack) {
        
        self.showLoading("开始注册")
        let userList = BmobObject.init(className: kUserListName)!
        userList.setObject(self.loginModel.account, forKey: "account")
        userList.setObject(self.loginModel.password, forKey: "password")
        userList.setObject(self.loginModel.headPic, forKey: "headPicUrl")
        
        let userId: String = kNowDate.k_toDateStr("yyyyMMddHHmmss")
        self.loginModel.userId = userId
        userList.setObject(self.loginModel.userId, forKey: "userId")

        userList.saveInBackground(resultBlock: { [unowned self] (isOK, error) in
            
            if let _ = error {
                
                self.showText("注册失败")
                
            } else {
                
                // 移除通知
                NotificationCenter.default.removeObserver(self)
                
                callBack?()
                self.showText("欢迎你,\(self.loginModel.account)!")
                // 保存密码
                kSaveDataTool.k_saveOrUpdatePassword(account: self.loginModel.account, password: self.loginModel.password)
                
                kSaveDataTool.k_saveModel(model: self.loginModel, to: kUserMsgPath)
            }
        })
    }
}
