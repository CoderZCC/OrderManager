//
//  HomeViewController.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/11.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

    /// 表视图
    @IBOutlet weak var tableView: UITableView!
    /// 日期选择按钮
    @IBOutlet weak var selectedTBtn: UIButton!
    /// 日期按钮文字
    var topBtnText: String {
        
        return self.selectedTBtn.titleLabel!.text!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
        self.tableView.k_headerBeginRefreshing()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /// 头像更新
        let imgV = self.leftView.viewWithTag(101) as! UIImageView
        imgV.k_setImage(url: LoginModel.cachesHeadPic)
    }
    
    func initView() {
        
        self.title = "我的账单"
        
        /// 2018-07
        let btnTitle = kNowDate.k_toDateStr("yyyy-MM")
        self.selectedTBtn.k_set(image: #imageLiteral(resourceName: "selected"), title: btnTitle, titlePosition: UIViewContentMode.left, additionalSpacing: 4.0, state: .normal)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: self.leftView)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "total"), clickCallBack: {
            
            self.viewModel.showTotalMoney()
        })
        
        self.view.addSubview(self.addBtn)
        self.tableView.sectionHeaderHeight = 35.0
        self.tableView.sectionFooterHeight = 0.01
        self.tableView.k_hiddeLine()
        self.tableView.rowHeight = 200.0
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib.init(nibName: "OrderCell", bundle: nil), forCellReuseIdentifier: "OrderCell")
        
        self.tableView.k_addHeaderRefresh { [unowned self] in
            
            self.initData()
        }
    }
    
    func initData() {
        
        self.viewModel.getOrderList(searchT: self.topBtnText) { [unowned self] in
            
            self.viewModel.isNeedOpenFirst = true
            self.tableView.k_headerEndRefreshing()
            self.tableView.k_reloadData()
        }
    }
    
    //MARK: 点击事件
    /// 日期选择
    @IBAction func selectedAction() {
        
        SpecialPickerView.showPickView(currentTime: self.topBtnText) { (str) in
            
            if self.topBtnText != str {
                
                self.selectedTBtn.setTitle(str, for: .normal)
                self.tableView.k_headerBeginRefreshing()
            }
        }
    }
    
    /// 拖动手势
    @objc func panAction(pan: UIPanGestureRecognizer) {
        
        let locationPoint = pan.location(in: self.view)
        switch pan.state {
        case .changed:
            
            self.addBtn.center = locationPoint

        case .ended, .cancelled:
            
            if locationPoint.y - kAddBtnWH / 2.0 <= 0.0 {
                
                self.addBtn.center = CGPoint.init(x: locationPoint.x, y: kAddBtnWH / 2.0)
                
            } else if locationPoint.y + kAddBtnWH / 2.0 >= self.view.frame.height {
                
                self.addBtn.center = CGPoint.init(x: locationPoint.x, y: self.view.frame.height - kAddBtnWH / 2.0)
                
            } else if locationPoint.x - kAddBtnWH / 2.0 <= 0.0 {
                
                self.addBtn.center = CGPoint.init(x: kAddBtnWH / 2.0, y: locationPoint.y)
                
            } else if locationPoint.x + kAddBtnWH / 2.0 >= kWidth {
                
                self.addBtn.center = CGPoint.init(x: kWidth - kAddBtnWH / 2.0, y: locationPoint.y)
            }
            let str = self.addBtn.center.x.k_toCGFloatString() + ";" + self.addBtn.center.y.k_toCGFloatString()
            kSaveDataTool.k_addValueToUserdefault(key: kAddBtnLocationKey, value: str)
            
        default:
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: 懒加载
    lazy var viewModel: HomeViewModel = {
        let viewModel = HomeViewModel()
        
        return viewModel
    }()
    
    lazy var addBtn: UIButton = { [unowned self] in
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(origin: CGPoint.zero, size: CGSize(width: kAddBtnWH, height: kAddBtnWH))
        btn.setImage(#imageLiteral(resourceName: "add"), for: .normal)
        btn.center = self.viewModel.addBtnLocation

        btn.k_addTarget({ [unowned self] tap in
            
            let addVC = AddViewController()
            addVC.saveSuccessCallBack = { [unowned self] in
                
                self.tableView.k_headerBeginRefreshing()
            }
            self.present(addVC, animated: true, completion: nil)
        })
        
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(panAction))
        btn.addGestureRecognizer(pan)
        
        return btn
    }()
    
    lazy var leftView: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: 40.0, height: 40.0))
        view.k_addTarget({ (tap) in
            
            (kRootVC as! SliderDrawerViewController).showLeftVC()
        })
        
        let imgV = UIImageView.init(frame: view.bounds)
        imgV.k_setCircleImgV()
        imgV.tag = 101
        view.addSubview(imgV)
        
        return view
    }()
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let modelArr = self.viewModel.getValueModel(indexPath.section)
        let model = modelArr[indexPath.row]
     
        let detailVC = AddViewController.init(model: model)
        detailVC.saveSuccessCallBack = {
            
            self.tableView.k_headerBeginRefreshing()
        }
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.viewModel.dataList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let modelArr = self.viewModel.getValueModel(section)
        let model = modelArr.first!
        
        if section == 0 && self.viewModel.isNeedOpenFirst {
            
            self.viewModel.isNeedOpenFirst = false
            model.isOpen = true
        }
        return model.isOpen ? (modelArr.count) : (0)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let text = self.viewModel.getKeyStr(section)
        let modelArr = self.viewModel.getValueModel(section)
        let model = modelArr.first!
        let weekDay = model.costTime.k_toDate(formatter: "yyyy MM-dd HH:mm").k_weekDay()
        
        let headView = OrderHeaderView.loadXibView(viewModel: self.viewModel, text: text + " " + weekDay, height: tableView.sectionHeaderHeight)
        
        headView.showAnimaton(isOpen: modelArr.first!.isOpen)
        
        headView.k_addTarget { tap in

            DispatchQueue.main.async {
                
                modelArr.first!.isOpen = !modelArr.first!.isOpen
                tableView.reloadSections(IndexSet.init(integer: section), with: .automatic)
            }
        }
        
        return headView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderCell
        
        let costModel = self.viewModel.getValueModel(indexPath.section)[indexPath.row]
        cell.model = costModel

        cell.showView.k_addLongPressTarget { [unowned self] tap in
            
            if tap.state == .began {
                
                self.k_showAlert(title: "确定要删除此条记录吗?", rightAction: {
                    
                    self.viewModel.deleteOrder(costModel: costModel, callBack: {
                        
                        self.tableView.k_headerBeginRefreshing()
                    })
                })
            }
        }
        
        return cell
    }
}

        
