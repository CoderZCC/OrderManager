//
//  AppDelegate.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/11.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
        
        let homeVC = HomeViewController()
        let rootVC = BaseNavigationController.init(rootViewController: homeVC)
        window?.rootViewController = rootVC
        self.setNavigation(vc: homeVC)
        
        return true
    }
}

extension AppDelegate {
    
    /// 设置导航栏
    func setNavigation(vc: BaseViewController) {
        
        let navbar = UINavigationBar.appearance()
        // 设置标题文字颜色
        navbar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        // 设置导航栏的背景颜色
        navbar.barTintColor = kNavbarColor
        // 设置导航栏是否透明
        navbar.isTranslucent = false
        // 设置导航栏上按钮的颜色
        navbar.tintColor = UIColor.white
    }
}
