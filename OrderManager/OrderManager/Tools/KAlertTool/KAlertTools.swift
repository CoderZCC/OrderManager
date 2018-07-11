//
//  KAlertTools.swift
//  Swift代码练习
//
//  Created by 张崇超 on 2017/7/25.
//  Copyright © 2017年 huayu. All rights reserved.
//

import UIKit

extension UIResponder {
    
    /// 底部弹窗
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - subTitles: 子标题
    ///   - callBack: 点击回调
    func k_showSheets(title: String?, subTitles: [String]?, callBack: @escaping(Int) -> Void) {
        
        kAlertSheetTools.showAlertSheet(title: title, subTitleArr: subTitles, clickAction: callBack)
    }
}

class KAlertTools: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var subTitleL: UILabel!
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var centerSpace: NSLayoutConstraint!
    
    var leftAction:()->Void = {}
    var rightAction:()->Void = {}
    var finishInput:(String) ->Void = {_ in}
    var isRunning:Bool  = false
    
    ///单例
    static let sharedManager:KAlertTools = {
        
        let tool = Bundle.main.loadNibNamed("KAlertTools", owner: nil, options: nil)?.last as! KAlertTools
        tool.frame = CGRect(x:0 , y: 0 ,width: kWidth ,height: kHeight)
        tool.contentView.transform = CGAffineTransform.init(scaleX: 0.001, y: 0.001)
        
        return tool
    }()
    
    ///输入框
    class func showAlertTextFieldView (title:String? , placeholder:String? ,leftBtn:String? = "取消" ,rightBtn:String? = "确定" ,leftAction:@escaping ()->Void ,rightAction:@escaping (String)->Void)
    {
        let tool = KAlertTools.sharedManager
        if tool.isRunning {
            
            return
        }
        tool.isRunning = true
        tool.centerSpace.constant -= 40.0

        let window = UIApplication.shared.keyWindow
        window?.addSubview(tool)
        
        tool.subTitleL.isHidden = true
        tool.textField.isHidden = false
        tool.textField.text = nil
        //赋值
        if let title = title {
            
            tool.titleL.text = title
        }
        if let placeholder = placeholder {
            
            tool.textField.placeholder = placeholder
        }
        
        if let leftBtn = leftBtn {
            
            tool.leftBtn.setTitle(leftBtn, for: UIControlState.normal)
        }
        if let rightBtn = rightBtn {
            
            tool.rightBtn.setTitle(rightBtn, for: UIControlState.normal)
        }
        
        tool.finishInput = rightAction
        tool.leftAction = leftAction
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
            
            tool.alpha = 1.0
            tool.contentView.transform = CGAffineTransform.identity
            
        }) { (isOk) in
            
            tool.textField.becomeFirstResponder()
            tool.isRunning = false
        }
    }
    
    ///警告框
    class func showAlertView(title:String? , subTitle:String? , leftBtn:String? = "取消", rightBtn:String? = "确定",leftBtnAction:@escaping ()->Void ,rightBtnAction:@escaping () ->Void)
    {
        let tool = KAlertTools.sharedManager
        if tool.isRunning {
            
            return
        }
        tool.isRunning = true
        
        let window = UIApplication.shared.keyWindow
        window?.addSubview(tool)

        //赋值
        tool.subTitleL.isHidden = false
        tool.textField.isHidden = true
        
        if let title = title {
            
            tool.titleL.text = title
        }
        if let subTitle = subTitle {
            
            tool.subTitleL.text = subTitle
        }
        if let leftBtn = leftBtn {
            
            tool.leftBtn.setTitle(leftBtn, for: UIControlState.normal)
        }
        if let rightBtn = rightBtn {
            
            tool.rightBtn.setTitle(rightBtn, for: UIControlState.normal)
        }
        
        tool.rightAction = rightBtnAction
        tool.leftAction = leftBtnAction

        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
            
            tool.alpha = 1.0
            tool.contentView.transform = CGAffineTransform.identity

        }) { (isOk) in
            
            tool.isRunning = false
        }
    }
    
    ///隐藏
    class func dismissView()
    {
        let tool = KAlertTools.sharedManager
        if tool.isRunning {
            
            return
        }
        tool.isRunning = true
        UIView.animate(withDuration: 0.3, animations: {
            
            tool.alpha = 0.0
            tool.contentView.transform = CGAffineTransform.init(scaleX: 0.001, y: 0.001)
            
        }) { (isFinish) in
            
            tool.isRunning = false
            tool.removeFromSuperview()
            //复原
            if tool.textField.isHidden == false {
                
                tool.centerSpace.constant += 40.0
            }
        }
    }
    
    //MARK: -Action-
    @IBAction func btnAction(_ sender: UIButton) {
        
        let tool = KAlertTools.sharedManager
        KAlertTools.dismissView()
        if sender.tag == 100 {
            
            //左侧按钮
            tool.leftAction()
            
        }else if (sender.tag == 101) {
            
            if tool.textField.isHidden {
                
                //右侧按钮
                tool.rightAction()
            }else{
                
                if let text = tool.textField.text {
                    
                    tool.finishInput(text)
                }
            }
        }
    }
}

class kAlertSheetTools: UIView {
    
    ///标题
    var titleText = ""
    ///是否正在运行
    var isRunning:Bool = false
    ///子标题数组
    var subTitleArr:Array<String> = []
    ///回调
    var subTitleClick:(Int)->Void = {_ in }
    ///单元格标记符
    static let identifier = "kAlertSheetCell"
    ///表视图
    var tableView: UITableView?
    
    ///单例
    static let sharedManager:kAlertSheetTools = {
        
        let tool = kAlertSheetTools()
        tool.frame = CGRect(x:0 , y: 0 ,width: kWidth ,height: kHeight)
        tool.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
        tool.alpha = 0.0

        return tool
    }()
    
    static func showAlertSheet(title:String? , subTitleArr:Array<String>? , clickAction:@escaping (Int)->Void)
    {
        let tool = kAlertSheetTools.sharedManager
        if tool.isRunning {
            
            //正在运行,结束运行
            return
        }
        tool.isRunning = true
        let window = UIApplication.shared.keyWindow
        window?.addSubview(tool)
        
        //赋值
        if let title = title {
            tool.titleText = title
        }
        tool.subTitleClick = clickAction
        if let subTitleArr = subTitleArr {
            
            tool.subTitleArr = subTitleArr
        }
        
        if let tableView = tool.tableView {
            
            tableView.removeFromSuperview()
        }
        tool.createTableView()
        tool.addSubview(tool.tableView!)
        tool.tableView!.reloadData()
        
        //展示View
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
            
            tool.alpha = 1.0
            tool.tableView!.transform = CGAffineTransform.identity
            
        }){ (isOK) in
            
            tool.isRunning = false
        }
    }
    
    //触摸消失
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        cancleAction(isNeed: false)
    }
    //MARK:点击事件
    @objc func clickAction() -> Void {
        
        cancleAction(isNeed: false)
    }
    
    ///消失方法
    func cancleAction(isNeed:Bool) -> Void {
        
        let tool = kAlertSheetTools.sharedManager
        if tool.isRunning {
            
            return
        }
        tool.isRunning = true
        UIView.animate(withDuration: 0.4, animations: {
            
            tool.alpha = 0.0
            tool.tableView!.transform = CGAffineTransform.init(translationX: 0, y: kHeight)
            
        }) { (isOk) in
            
            tool.isRunning = false
            tool.removeFromSuperview()
            if isNeed {
                
                self.subTitleClick(self.subTitleArr.count)
            }
        }
    }
    
    //创建表视图
    func createTableView() {
        
        let bottomSpace: CGFloat = ((kHeight == 812) ? 34.0 : 0.0)
        let cellHeight:CGFloat = 44.0
        let footHeight:CGFloat = 55.0
        var height:CGFloat = cellHeight * CGFloat(self.subTitleArr.count) + bottomSpace
        
        //取消按钮的位置
        height += footHeight
        
        //是否有标题
        if !self.titleText.isEmpty
        {
            height += 49.0
        }
        
        let tableView = UITableView.init(frame: CGRect(x:0.0 , y: Double(kHeight - height) ,width: Double(kWidth) , height: Double(height)), style: UITableViewStyle.plain)
        
        tableView.transform = CGAffineTransform.init(translationX: 0, y: kHeight)
        
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = CGFloat(cellHeight)
        tableView.sectionHeaderHeight = 0.0001
        tableView.sectionFooterHeight = 100
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.cellLayoutMarginsFollowReadableWidth = false
        //头视图
        if !self.titleText.isEmpty
        {
            let headL = UILabel.init(frame: CGRect(x:10 , y: 0, width:kWidth - 20 ,height:49))
            headL.text = self.titleText
            headL.textAlignment = NSTextAlignment.center
            headL.numberOfLines = 3
            headL.font = UIFont.systemFont(ofSize: 16.0)
            headL.textColor = UIColor.black
            
            //添加边框
            let layer = CALayer()
            let y = headL.frame.size.height - 0.5
            layer.frame = CGRect(x: 8, y: y ,width: kWidth - 16 ,height: 0.5)
            layer.backgroundColor = UIColor.k_colorWith(rgb: 214.0).cgColor
            headL.layer.addSublayer(layer)
            
            tableView.tableHeaderView = headL
        }
        
        //尾试图
        let footView:UIView = UIView.init(frame: CGRect(x:0.0 , y: 0.0 ,width:Double(kWidth) ,height : Double(footHeight)))
        footView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        
        let footBtn = UIButton(type: UIButtonType.custom)
        footBtn.frame = CGRect(x: 0.0 , y: 6.0 , width: Double(kWidth) ,height: Double(footHeight))
        footBtn.backgroundColor = UIColor.white
        footBtn.setTitle("取消", for: UIControlState.normal)
        footBtn.addTarget(self, action: #selector(kAlertSheetTools.clickAction), for: UIControlEvents.touchUpInside)
        footBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        
        footView.addSubview(footBtn)
        tableView.tableFooterView = footView
        
        let tool = kAlertSheetTools.sharedManager
        tool.tableView = tableView
    }
}

extension kAlertSheetTools :UITableViewDataSource,UITableViewDelegate
{

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //点击事件
        subTitleClick(indexPath.row)
        cancleAction(isNeed: false)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.subTitleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: kAlertSheetTools.identifier)
        if cell == nil {
            
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: kAlertSheetTools.identifier)
            cell?.textLabel?.textAlignment = NSTextAlignment.center
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
        }
        cell?.textLabel?.text = subTitleArr[indexPath.row]
        
        return cell!
    }
}
