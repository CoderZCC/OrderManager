//
//  AppDelegate+Ext.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/12.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit
import UserNotifications

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func registerAppNote() {
        
        if #available(iOS 10.0, *) {
            
            let notifiCenter = UNUserNotificationCenter.current()
            
            notifiCenter.delegate = self
            
            let types = UNAuthorizationOptions(arrayLiteral: [.alert, .badge, .sound])
            
            notifiCenter.requestAuthorization(options: types) { (flag, error) in
                if flag {
                    
                    print("iOS request notification success")
                    
                }else{
                    
                    print(" iOS 10 request notification fail")
                }
            }
        } else {
            
            //iOS8,iOS9注册通知
            let setting = UIUserNotificationSettings.init(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(setting)
        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([UNNotificationPresentationOptions.alert, UNNotificationPresentationOptions.sound])
    }
    
}
