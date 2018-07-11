//
//  AddViewController.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/11.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class AddViewController: BaseViewController {

    /// 消费时间
    @IBOutlet weak var costTimeView: UIView!
    /// 消费类型
    @IBOutlet weak var costTypeView: UIView!
    /// 消费金额
    @IBOutlet weak var costTf: UITextField!
    
    @IBOutlet weak var costTypeL: UILabel!
    
    @IBOutlet weak var otherInfoTv: UITextView!
    
    @IBOutlet weak var finishBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
    }
    
    func initView() {
        
        self.otherInfoTv.k_placeholder = "输入备注信息(150字)"
        self.otherInfoTv.tintColor = UIColor.darkGray
        self.otherInfoTv.k_limitTextLength = 150
        self.costTf.k_limitTextLength = 3
        
        self.otherInfoTv.k_setCornerRadius(4.0)
        self.finishBtn.k_setCornerRadius(4.0)

        self.costTimeView.k_addTarget {
            
            self.view.endEditing(true)
            
            print("costTimeView")
        }
        self.costTypeView.k_addTarget { [unowned self] in
            
            self.view.endEditing(true)
            self.k_showSheets(title: "消费类型", subTitles: kCostTypeStr, callBack: { [unowned self] (index) in
                
                self.costTypeL.text = kCostTypeStr[index]
            })
        }
    }
    
    @IBAction func cancleBtnAction() {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func finishBtnAction() {
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
