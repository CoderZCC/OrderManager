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
        self.initData()
    }
    
    func initView() {
        
        self.title = "OrderManager"
        
        self.tableView.k_hiddeLine()
        self.tableView.rowHeight = 49.0
        self.tableView.backgroundColor = kViewColor
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func initData() {
        
        self.showLoading()
        HomeViewModel.getOrderList { (arr) in
            
            self.hideHUD()
            self.dataList = arr
            self.tableView.k_reloadData()
        }
    }
    
    @IBAction func addBtnAction() {
        
        let addVC = AddViewController()
        self.present(addVC, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    lazy var viewModel: HomeViewModel = {
        let viewModel = HomeViewModel()
        
        return viewModel
    }()
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailVC = DetailViewController()
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

        
