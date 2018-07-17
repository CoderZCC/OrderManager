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
        
        self.loginResult(isSuccess: LoginModel.isLogin)
        
        //self.regitserAppLocalNote()
        self.registerBmob()
        
        UIApplication.shared.isStatusBarHidden = false
        
        return true
    }
    
    /// 切换根试图
    ///
    /// - Parameter isSuccess: true/false
    func loginResult(isSuccess: Bool) {
        
        // 转场动画
        let transition = CATransition.init()
        transition.type = "rippleEffect"
        transition.duration = 0.5
        kWindow?.layer.add(transition, forKey: "transition")
        
        if !isSuccess {
            
            let loginVC = StartViewController()
            let rootVC = BaseNavigationController(rootViewController: loginVC)
            window?.rootViewController = rootVC
            self.setNavigation(vc: loginVC)
            return
        }
        let homeVC = HomeViewController()
        let mainVC = BaseNavigationController(rootViewController: homeVC)
        let leftVC = LeftViewController()
        
        let rootVC = SliderDrawerViewController.init(mainVC: mainVC, leftVC: leftVC, leftWidth: kSliderMaxWidth)
        
        kWindow?.rootViewController = rootVC
        self.setNavigation(vc: homeVC)
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

extension AppDelegate {
    
    func registerBmob() {
        
        Bmob.register(withAppKey: kBombID)
        Bmob.setBmobRequestTimeOut(10.0)
    }
}
