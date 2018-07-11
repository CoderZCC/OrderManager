//
//  HomeViewController.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/11.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initView()
        self.tableView.k_headerBeginRefreshing()
    }
    
    func initView() {
        
        self.title = "OrderManager"
        
        self.tableView.k_hiddeLine()
        self.tableView.rowHeight = 49.0
        self.tableView.backgroundColor = kViewColor
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.k_addHeaderRefresh { [unowned self] in
            
            self.dataList?.removeAll()
            self.initData()
        }
    }
    
    func initData() {
        
        CostViewModel.getOrderList { (arr) in
            
            self.dataList = arr
            self.tableView.k_reloadData()
        }
    }
    
    @IBAction func addBtnAction() {
        
        let addVC = AddViewController()
        addVC.saveSuccessCallBack = { [unowned self] in
            
            self.tableView.k_headerBeginRefreshing()
        }
        self.present(addVC, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    lazy var viewModel: CostViewModel = {
        let viewModel = CostViewModel()
        
        return viewModel
    }()
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let model = self.dataList![indexPath.row]

        let detailVC = AddViewController.init(model: model)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell")
        if cell == nil {
            
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: "OrderCell")
            cell?.selectionStyle = .none
        }
        let model = self.dataList![indexPath.row]
        cell?.textLabel?.text = model.costTime
        cell?.detailTextLabel?.text = (model.costNum ?? "0.0") + "元"
        
        return cell!
    }
}

        
