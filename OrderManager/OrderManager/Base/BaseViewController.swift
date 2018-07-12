//
//  BaseViewController.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/11.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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

        self.view.insertSubview(self.bgImgV, at: 0)
    }

    lazy var bgImgV: UIImageView = {
        let imgV = UIImageView.init(frame: UIScreen.main.bounds)
        imgV.contentMode = .scaleAspectFill
        imgV.image = #imageLiteral(resourceName: "bg")
        
        let blur = UIBlurEffect.init(style: UIBlurEffectStyle.dark)
        let maskView = UIVisualEffectView.init(effect: blur)
        maskView.alpha = 1.0
        maskView.frame = imgV.bounds
        imgV.addSubview(maskView)
        
        return imgV
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
