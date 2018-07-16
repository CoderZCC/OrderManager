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
    
    func selectedImg() {
        
        self.k_showSheets(title: "请选择", subTitles: ["从相册获取", "拍照"], callBack: { (index) in
            
            if index == 0 {
                
                CameraTool.takeImage(callBack: { (img) in
                    
                    self.headPic = img
                })
                
            } else {
                
                CameraTool.takePhoto(callBack: { (img) in
                    
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
        RegisterViewModel.userIsExit(account: self.loginModel.account) { (isOk, obj) in
            
            if let _ = obj {
                
                self.showText("账号已存在")
                
            } else {
                
                // 注册
                self.uploadImg(callBack: { (url) in
                    
                    self.addData(callBack: callBack)
                })
            }
        }
    }
    /// 注册
    private func addData(callBack: CallBack) {
        
        self.showLoading("开始注册")
        let userList = BmobObject.init(className: kUserListName)!
        userList.setObject(self.loginModel.account, forKey: "account")
        userList.setObject(self.loginModel.password, forKey: "password")
        userList.setObject(self.loginModel.headPic, forKey: "headPicUrl")
        
        let userId: String = kNowDate.k_toDateStr("yyyyMMddHHmmss")
        userList.setObject(userId, forKey: "userId")

        userList.saveInBackground(resultBlock: { (isOK, error) in
            
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
    
    /// 上传头像
    func uploadImg(callBack: ((String) -> Void)? ) {
        
        self.showLoading("图片处理中")
        let imgData = self.headPic.k_pressImgSize()
        let file = BmobFile.init(fileName: "\(kNowDate.k_toDateStr("yyMMddHHmmss")).png", withFileData: imgData)
        file?.save(inBackground: { (isOK, error) in
            
            if isOK {
                
                print("isOK:\(file!.url)")
                self.loginModel.headPic = file!.url
                callBack?(file!.url)
                self.hideHUD()

            } else {
                
                self.showText("图片上传失败，请重试")
            }
            
        }, withProgressBlock: { (progress) in
        
            self.showProgress(progress: progress, text: "图片上传中")
            print("progress:\(progress)")
        })
    }
    
    /// 账号是否存在
    ///
    /// - Parameters:
    ///   - account: 账号
    ///   - callback: 回调
    class func userIsExit(account: String, callback: ((Bool, BmobObject?) -> Void)? ) {
        
        let queryList = BmobQuery.init(className: kUserListName)!
        queryList.whereKey("account", equalTo: account)
        queryList.findObjectsInBackground { (dataArr, error) in
            
            if let dataArr = dataArr as? [BmobObject], !dataArr.isEmpty {
                
                let userObj = dataArr.first!
                callback?(true, userObj)
                
            } else {
                
                callback?(false, nil)
            }
        }
    }
    
}
