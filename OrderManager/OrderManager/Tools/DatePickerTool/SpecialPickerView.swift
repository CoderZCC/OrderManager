//
//  SpecialPickerView.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/12.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class SpecialPickerView: UIView {
    
    /// 返回的字符串类型
    static var callbackStyle: String = "yyyy MM-dd HH:mm"
    
    /// 展示时间控件
    ///
    /// - Parameters:
    ///   - currentTime: 显示的时间
    ///   - callback: 选中回调
    static func showPickView(currentTime: String, callback: ((String)->Void)?) {
        
        let tool = SpecialPickerView.loadXibView()
        tool.alpha = 0.0
        
        if tool.isAnimating { return }
        tool.isAnimating = true
        
        kWindow?.addSubview(tool)
        tool.showView.transform = CGAffineTransform.init(translationX: 0.0, y: kHeight)
        tool.callback = callback
        tool.viewModel.scrollTo(pickView: tool.pickerView, time: currentTime)
        
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: .allowAnimatedContent, animations: {
            
            tool.alpha = 1.0
            tool.showView.transform = CGAffineTransform.identity
            
        }) { (isOK) in
            
            tool.isAnimating = false
        }
    }
    
    /// pickerView
    @IBOutlet weak var pickerView: UIPickerView!
    /// 展示View
    @IBOutlet weak var showView: UIView!
    /// 是否在执行动画
    private var isAnimating: Bool = false
    /// 回调
    private var callback: ((String)->Void)?
    
    class func loadXibView() -> SpecialPickerView {
        let tool = Bundle.main.loadNibNamed("MyPickerTool", owner: nil, options: nil)?.last as! SpecialPickerView
        tool.frame = UIScreen.main.bounds
        
        return tool
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.cancleAction()
    }
    
    /// 取消事件
    @IBAction func cancleAction() {
        
        if self.isAnimating { return }
        self.isAnimating = true
        UIView.animate(withDuration: 0.3, animations: { [unowned self] in
            
            self.alpha = 0.0
            self.showView.transform = CGAffineTransform.init(translationX: 0.0, y: kHeight)
            
        }) { (isOK) in
            
            self.pickerView.delegate = nil
            self.pickerView.dataSource = nil
            self.isAnimating = false
            self.removeFromSuperview()
        }
    }
    
    /// 确定事件
    @IBAction func sureAction() {
        
        self.cancleAction()
        self.callback?(self.viewModel.selectedStr)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
    }
    
    lazy var viewModel: SpecialViewModel = {
        let model = SpecialViewModel()
        return model
    }()
}

extension SpecialPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return self.viewModel.numberOfRows(component: component)
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        return self.viewModel.titleForRow(component: component, row: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.viewModel.selectedContent(component: component, row: row)
    }
}

class SpecialViewModel: NSObject {
    
    /// 选择的时间
    var selectedStr: String = ""
    /// 年
    lazy var yearArr: [String] = {
        return ["\(kNowDate.k_YMDHMS().year!)"]
    }()
    /// 12个月
    lazy var monthArr: [String] = {
        var arr: [String] = []
        for index in 1...12 {
            
            arr.append(String.init(format: "%.2ld", index))
        }
        return arr
    }()

    /// 个数
    ///
    /// - Parameter component: 下标
    /// - Returns: 个数
    func numberOfRows(component: Int) -> Int {
        
        return component == 0 ? (self.yearArr.count) : (self.monthArr.count)
    }
    
    /// 展示内容
    ///
    /// - Parameters:
    ///   - component: 第一列
    ///   - row: 第二列
    /// - Returns: 内容
    func titleForRow(component: Int, row: Int) -> String {
        
        if component == 0 {
            
            return self.yearArr[row]
        }
        return self.monthArr[row]
    }
    
    /// 选中的内容
    ///
    /// - Parameters:
    ///   - component: 第一列
    ///   - row: 第二列
    /// - Returns: 字符串
    func selectedContent(component: Int, row: Int) {
        
        var year: String!
        var month: String!
        component == 0 ? (year = self.yearArr[row]) : (month = self.monthArr[row])
        if year == nil {
            year = self.yearArr[0]
        }
        if month == nil {
            month = self.monthArr[0]
        }
        self.selectedStr = year! + "-" + month!
    }
    
    /// 滚动到指定时间
    ///
    /// - Parameters:
    ///   - pickView: pickView
    ///   - time: time
    func scrollTo(pickView: UIPickerView, time: String) {
        
        let arr = time.components(separatedBy: "-")
        let year = arr.first!
        let month = arr.last!
        
        let yearIndex = self.yearArr.index(of: year) ?? 0
        let monthIndex = self.monthArr.index(of: month) ?? 0
        
        pickView.selectRow(yearIndex, inComponent: 0, animated: true)
        pickView.selectRow(monthIndex, inComponent: 1, animated: true)
    }
}
