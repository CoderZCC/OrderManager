//
//  StartViewController.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/13.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class StartViewController: BaseViewController {

    /// 注册按钮
    @IBOutlet weak var registerBtn: UIButton!
    /// 登录按钮
    @IBOutlet weak var loginBtn: UIButton!
    
    /// 播放器
    let videoPlayer = VideoPlayer.init(frame: CGRect.init(x: 0.0, y: 0.0, width: kWidth, height: kHeight), videoUrl: URL.init(fileURLWithPath: Bundle.main.path(forResource: "1", ofType: "mp4")!))

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initView()
        self.setUpPlayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.videoPlayer.resumePlay()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.videoPlayer.pausePlay()
    }
    
    /// 设置播放器
    func setUpPlayer() {
        
        self.videoPlayer.volume = 0.0
        self.videoPlayer.isRunPlay = true
        self.view.layer.addSublayer(self.videoPlayer.playerLayer)
        self.view.bringSubview(toFront: self.registerBtn)
        self.view.bringSubview(toFront: self.loginBtn)
    }
    
    func initView() {
        
        self.k_setNavBarTranslucent()
        
        self.registerBtn.layer.borderWidth = 1.0
        self.registerBtn.layer.borderColor = UIColor.white.cgColor
        self.registerBtn.k_setCornerRadius(kCornerRadius)
        self.loginBtn.k_setCornerRadius(kCornerRadius)
        
        if let bgImgV = self.view.subviews.first as? UIImageView {
            bgImgV.removeFromSuperview()
        }
    }
    
    /// 注册按钮点击事件
    @IBAction func regitserAction() {
        
        let loginVC = RegisterViewController()
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    /// 登录按钮点击事件
    @IBAction func loginAction() {
        
        let loginVC = LoginViewController()
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        
        self.videoPlayer.destoryPlayer()
    }
    
}
