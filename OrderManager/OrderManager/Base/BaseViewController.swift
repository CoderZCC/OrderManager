//
//  BaseViewController.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/11.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    var dataList: [CostModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = kViewColor
        
        // 使用自定义的返回图片
        let navbar = UINavigationBar.appearance()
        navbar.backIndicatorImage = #imageLiteral(resourceName: "back")
        navbar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "back")
        // 移除返回按钮上的文字
        let backItem = UIBarButtonItem.init()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem
        
        /*
         //使用系统的返回按钮图片
         let backItem = UIBarButtonItem.init()
         backItem.title = ""
         self.navigationItem.backBarButtonItem = backItem
         */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
