//
//  LoginModel.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/13.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

let kUserMsgPath: String = String.k_documentsPath + "userMsg.plist"

class LoginModel: NSObject, NSCoding {

    /// 缓存的账号
    static var cachesAccount: String {
        let model = kSaveDataTool.k_getModel(from: kUserMsgPath)
      
        return model?.account ?? ""
    }
    
    /// 缓存的userId 
    static var cachesUserId: String {
        let model = kSaveDataTool.k_getModel(from: kUserMsgPath)
     
        return model?.userId ?? ""
    }
    
    /// 缓存的headPic
    static var cachesHeadPic: String {
        let model = kSaveDataTool.k_getModel(from: kUserMsgPath)

        return model?.headPic ?? ""
    }
    
    /// 是否已登录
    static var isLogin: Bool {
        
        let account = LoginModel.cachesAccount
        if account.isEmpty {
            
            return false
        }
        let psd = kSaveDataTool.k_getPassword(account: account)
        
        return psd != nil
    }
    
    var userId: String = ""
    var account: String = ""
    var password: String = ""
    var headPic: String = ""
    
    override init() {
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.userId, forKey: "userId")
        aCoder.encode(self.account, forKey: "account")
        aCoder.encode(self.password, forKey: "password")
        aCoder.encode(self.headPic, forKey: "headPic")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        self.userId = aDecoder.decodeObject(forKey: "userId") as! String
        self.account = aDecoder.decodeObject(forKey: "account") as! String
        self.password = aDecoder.decodeObject(forKey: "password") as! String
        self.headPic = aDecoder.decodeObject(forKey: "headPic") as! String
    }
    
  
}
