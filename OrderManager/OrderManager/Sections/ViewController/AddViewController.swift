//
//  AddViewController.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/11.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class AddViewController: BaseViewController {

    /// 保存成功的回调
    var saveSuccessCallBack: (()->Void)?
    
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
    private var model: CostModel = CostModel()
    /// 顶部高度约束
    @IBOutlet weak var navHeightCons: NSLayoutConstraint!
    /// 标题文字
    @IBOutlet weak var navTitleL: UILabel!
    /// 是否是展示详情
    private var isDetail: Bool = false
    
    convenience init(model: CostModel) {
        self.init(nibName: "AddViewController", bundle: nil)
        
        self.isDetail = true
        self.model = model
        self.title = "消费详情"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
    }
    
    func initView() {
        
        self.finishBtn.isHidden = self.isDetail
        self.view.isUserInteractionEnabled = !self.isDetail
        if self.isDetail {
            
            self.navHeightCons.constant = 44.0
            
            self.costTf.text = self.model.costNum
            self.costTimeL.text = self.model.costTime
            self.costTypeL.text = self.model.costType
            self.otherInfoTv.text = self.model.costInfo
            if self.model.costInfo.isEmpty {
                self.otherInfoTv.text = "无备注信息"
            }
        }
        
        self.otherInfoTv.k_placeholder = "输入备注信息(150字)"
        self.otherInfoTv.tintColor = UIColor.darkGray
        self.otherInfoTv.k_limitTextLength = 150
        
        self.otherInfoTv.k_setCornerRadius(4.0)
        self.finishBtn.k_setCornerRadius(4.0)
        
        self.costTimeL.text = self.model.costTime
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

        var saveStr: String = "\(self.model.costYear);\(self.model.costMonth);\(self.model.costDay);\(self.costTimeL.text!);"
        saveStr += "\(costType);\(costNum);\(self.otherInfoTv.text ?? "无备注信息")"
        
        if kSaveDataTool.k_save(str: saveStr, to: kCachesPath) {

            self.showText("保存成功")
            self.saveSuccessCallBack?()
            self.cancleBtnAction()

        } else {

            self.showText("保存失败")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
