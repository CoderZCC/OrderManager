//
//  LoginModel.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/13.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class LoginModel: NSObject {

    /// 缓存的账号
    static var cachesAccount: String {
        return kSaveDataTool.k_checkValueFromUserdefault(key: kAccountkey) ?? ""
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
    
    var account: String = ""
    var password: String = ""
}
