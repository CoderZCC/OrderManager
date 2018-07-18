//
//  BaseViewController.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/11.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    /// 当前的主题图片
    var kThemeImageData: Data? {
        
        // id: data
        if let dic = kSaveDataTool.K_getData(from: kThemeSavePath) as? [String: Data] {
            
            return dic.values.first!
        }
        return nil
    }
    
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
        self.view.k_tapDismissKeyboard()
        
        self.themeChangeNote()
        NotificationCenter.default.addObserver(self, selector: #selector(themeChangeNote), name: NSNotification.Name.init(kThemeChangeNoteKey), object: nil)
    }
    
    @objc func themeChangeNote() {
        
        if let imgData = kThemeImageData {
            
            self.bgImgV.image = UIImage.init(data: imgData)

        } else {
            
            self.bgImgV.image = #imageLiteral(resourceName: "bg")
        }
    }

    private lazy var bgImgV: UIImageView = {
        let imgV = UIImageView.init(frame: UIScreen.main.bounds)
        imgV.contentMode = .scaleAspectFill
        imgV.clipsToBounds = true
        
        let maskView = UIView.init(frame: imgV.bounds)
        maskView.backgroundColor = UIColor.black
        maskView.alpha = 0.1
        
        imgV.addSubview(maskView)
        
        return imgV
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        print("----\(self)销毁了----\n")
    }
}
