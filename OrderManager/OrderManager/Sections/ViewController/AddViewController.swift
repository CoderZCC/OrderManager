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
    @IBOutlet weak var costTimeL: UILabel!
    /// 消费类型
    @IBOutlet weak var costTypeView: UIView!
    @IBOutlet weak var costTypeL: UILabel!
    /// 消费金额
    @IBOutlet weak var costTf: UITextField!
    /// 备注
    @IBOutlet weak var otherInfoTv: UITextView!
    /// 完成按钮
    @IBOutlet weak var finishBtn: UIButton!
    /// 数据模型
    private let model: CostModel = CostModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
    }
    
    func initView() {
        
        self.otherInfoTv.k_placeholder = "输入备注信息(150字)"
        self.otherInfoTv.tintColor = UIColor.darkGray
        self.otherInfoTv.k_limitTextLength = 150
        
        self.otherInfoTv.k_setCornerRadius(4.0)
        self.finishBtn.k_setCornerRadius(4.0)
        
        self.costTimeL.text = self.model.costTime
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
        
        guard let costType = self.costTypeL.text else {
            
            self.showText("请选择消费类型")
            return
        }
        guard let costNum = self.costTf.text else {
            
            self.showText("请输入消费金额")
            return
        }
        self.model.costType = costType
        self.model.costNum = costNum
        
        let saveStr: String = self.model.costTime + ";" + costType + ";" + costNum + ";" + self.model.costInfo
        let isOk = kSaveDataTool.k_save(str: saveStr, to: kCachesPath)
        if isOk {
            
            self.showText("保存成功")
            
        } else {
            
            self.showText("保存失败")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    lazy var viewModel: AddViewModel = {
        let viewModel = AddViewModel()
        
        return viewModel
    }()
    
}
