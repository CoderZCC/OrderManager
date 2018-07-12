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
    /// 顶部高度约束
    @IBOutlet weak var navHeightCons: NSLayoutConstraint!
    /// 标题文字
    @IBOutlet weak var navTitleL: UILabel!
    /// 是否是展示详情
    private var isDetail: Bool = false
    
    convenience init(model: CostModel) {
        self.init(nibName: "AddViewController", bundle: nil)
        
        self.isDetail = true
        self.viewModel.costModel = model
        self.title = "消费详情"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
    }
    
    func initView() {
        
        self.finishBtn.isHidden = self.isDetail
        if self.isDetail {
            
            self.costTypeView.isUserInteractionEnabled = false
            self.costTf.isUserInteractionEnabled = false
            self.otherInfoTv.isUserInteractionEnabled = false

            self.navHeightCons.constant = 44.0
            
            self.costTf.text = self.viewModel.costModel.costNum
            self.costTimeL.text = self.viewModel.costModel.costTime
            self.costTypeL.text = self.viewModel.costModel.costType
            self.otherInfoTv.text = self.viewModel.costModel.costInfo
            if self.viewModel.costModel.costInfo.isEmpty {
                self.otherInfoTv.text = "无备注信息"
            }
        }
        
        self.otherInfoTv.k_placeholderColor = UIColor.k_colorWith(r: 223.0, g: 221.0, b: 220.0)
        self.costTf.k_placeholderColor = self.otherInfoTv.k_placeholderColor
        self.otherInfoTv.k_placeholder = "输入备注信息(150字)"
        self.otherInfoTv.tintColor = UIColor.white
        self.otherInfoTv.k_limitTextLength = 150
        
        self.otherInfoTv.k_setCornerRadius(4.0)
        self.finishBtn.k_setCornerRadius(4.0)
        
        self.costTimeL.text = self.viewModel.costModel.costTime
        self.costTypeView.k_addTarget { [unowned self] in
            
            self.view.endEditing(true)
            self.k_showSheets(title: "消费类型", subTitles: kCostTypeStr, callBack: { [unowned self] (index) in
                
                self.costTypeL.text = kCostTypeStr[index]
            })
        }
        // 日期选择
        self.costTimeView.k_addTarget { [unowned self] in
            
            self.view.endEditing(true)
            DatePickerTool.showDatePickView(showModel: UIDatePickerMode.dateAndTime) { [unowned self] (timeStr) in
                
                self.costTimeL.text = timeStr
            }
        }
    }
    
    //MARK: 点击事件
    /// 取消点击事件
    @IBAction func cancleBtnAction() {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    /// 完成点击事件
    @IBAction func finishBtnAction() {
        
        guard let costType = self.costTypeL.text else {
            
            self.showText("请选择消费类型")
            return
        }
        guard let costNum = self.costTf.text else {
            
            self.showText("请输入消费金额")
            return
        }
        self.view.endEditing(true)
        
        self.viewModel.costModel.costInfo = self.otherInfoTv.text.isEmpty ? ("暂无备注信息") : (self.otherInfoTv.text)
        self.viewModel.costModel.costNum = costNum
        self.viewModel.costModel.costType = costType
        
        self.viewModel.saveOrder() {
            
            self.showText("保存成功")
            self.saveSuccessCallBack?()
            self.cancleBtnAction()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: 懒加载
    lazy var viewModel: CostViewModel = {
        let model = CostViewModel()
        return model
    }()
}
