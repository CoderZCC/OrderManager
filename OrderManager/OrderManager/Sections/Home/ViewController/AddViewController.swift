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
            
            self.navHeightCons.constant = 44.0
            self.setDataShow()
            self.setUserInteraction(isEnable: false)
            
            // 设置导航栏右侧按钮
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "修改", clickCallBack: { [unowned self] in
                
                self.setUserInteraction(isEnable: true)
                self.finishBtn.isHidden = false
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            })
        }
        
        // UI设置
        self.otherInfoTv.k_placeholderColor = kPlaceholderTextcolor
        self.costTf.k_placeholderColor = kPlaceholderTextcolor
        self.otherInfoTv.k_placeholder = "输入备注信息(150字)"
        self.otherInfoTv.tintColor = UIColor.white
        self.otherInfoTv.k_limitTextLength = 150
        self.otherInfoTv.k_setCornerRadius(kCornerRadius)
        self.finishBtn.k_setCornerRadius(kCornerRadius)
        
        self.costTimeL.text = self.viewModel.costModel.costTime
        
        // 日期选择
        self.costTimeView.k_addTarget { [unowned self] tap in
            
            if !self.costTf.isUserInteractionEnabled { return }
            self.view.endEditing(true)
            DatePickerTool.showDatePickView(showModel: UIDatePickerMode.dateAndTime) { [unowned self] (timeStr) in
                
                if self.costTimeL.text! != timeStr {
                    self.viewModel.isChangevalue = true
                    self.costTimeL.text = timeStr
                }
            }
        }
        // 消费类型选择
        self.costTypeView.k_addTarget { [unowned self] tap in
            
            if !self.costTf.isUserInteractionEnabled { return }
            self.view.endEditing(true)
            self.k_showSheets(title: "消费类型", subTitles: kCostTypeStr, callBack: { [unowned self] (index) in
                
                if index == kCostTypeStr.count - 1 {
                    
                    self.k_showAlert(title: "请输入类型", placeholder: "消费类型", callBack: { [unowned self] (str) in
                        
                        self.viewModel.isChangevalue = true
                        self.costTypeL.text = str
                    })
                    
                } else {
                    
                    if self.costTypeL.text! != kCostTypeStr[index] {
                        self.viewModel.isChangevalue = true
                        self.costTypeL.text = kCostTypeStr[index]
                    }
                }
            })
        }
    }
    
    /// 设置是否可用
    func setUserInteraction(isEnable: Bool) {
        
        self.costTimeView.isUserInteractionEnabled = isEnable
        self.costTypeView.isUserInteractionEnabled = isEnable
        self.costTf.isUserInteractionEnabled = isEnable
        self.otherInfoTv.isUserInteractionEnabled = isEnable
    }
    
    /// 展示数据
    func setDataShow() {
        
        self.costTf.text = self.viewModel.costModel.costNum
        self.costTimeL.text = self.viewModel.costModel.costTime
        self.costTypeL.text = self.viewModel.costModel.costType
        self.otherInfoTv.text = self.viewModel.costModel.costInfo
    }
    
    //MARK: 点击事件
    /// 取消点击事件
    @IBAction func cancleBtnAction() {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    /// 完成点击事件
    @IBAction func finishBtnAction() {
    
        if self.costTypeL.text! == "请选择" {
            
            self.showText("请选择消费类型")
            return
        }
        if self.costTf.text!.isEmpty {
            
            self.showText("请输入消费金额")
            return
        }
        self.view.endEditing(true)
        
        self.viewModel.costModel.costType = self.costTypeL.text!
        self.viewModel.costModel.costTime = self.costTimeL.text!
        
        // 金额是否改变
        if self.viewModel.costModel.costNum != self.costTf.text! {
            self.viewModel.isChangevalue = true
            self.viewModel.costModel.costNum = self.costTf.text!
        }
        // 备注信息是否改变
        if self.viewModel.costModel.costInfo != self.otherInfoTv.text {
            self.viewModel.isChangevalue = true
            self.viewModel.costModel.costInfo = self.otherInfoTv.text.isEmpty ? ("") : (self.otherInfoTv.text)
        }
        if self.isDetail {
            
            self.viewModel.updateOrder() {
                
                self.saveSuccessCallBack?()
                self.finishBtn.isHidden = true
                self.setUserInteraction(isEnable: false)
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }
            
        } else {
            
            self.viewModel.saveOrder() {
                
                self.saveSuccessCallBack?()
                self.cancleBtnAction()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: 懒加载
    lazy var viewModel: AddViewModel = {
        let model = AddViewModel()
        return model
    }()
}
