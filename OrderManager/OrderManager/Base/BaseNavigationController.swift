//
//  BaseNavigationController.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/11.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: true)
        
        if let sliderVC = kRootVC as? SliderDrawerViewController, sliderVC.isNeedHidden {
            
            sliderVC.hiddenLeftVC()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension UINavigationController {
    
    override open var prefersStatusBarHidden: Bool {
        return false
    }
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return self.topViewController?.preferredStatusBarStyle ?? .lightContent
    }
    
    open override var childForStatusBarStyle: UIViewController? {
        return self.viewControllers.last
    }
    open override var childForStatusBarHidden: UIViewController? {
        return self.viewControllers.last
    }
}
