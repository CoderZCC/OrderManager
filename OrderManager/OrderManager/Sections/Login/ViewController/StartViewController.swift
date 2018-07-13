//
//  StartViewController.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/13.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class StartViewController: BaseViewController {

    @IBOutlet weak var registerBtn: UIButton!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initView()
    }
    
    func initView() {
        
        self.k_setNavBarTranslucent()
        
        self.registerBtn.layer.borderWidth = 1.0
        self.registerBtn.layer.borderColor = UIColor.white.cgColor
        self.registerBtn.k_setCornerRadius(kCornerRadius)
        self.loginBtn.k_setCornerRadius(kCornerRadius)
    }
    
    @IBAction func regitserAction() {
        
        let loginVC = RegisterViewController()
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    @IBAction func loginAction() {
        
        let loginVC = LoginViewController()
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
