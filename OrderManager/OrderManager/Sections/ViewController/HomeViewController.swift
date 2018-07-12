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
    @IBOutlet weak var selectedTBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initView()
        self.tableView.k_headerBeginRefreshing()
    }
    
    func initView() {
        
        self.title = "OrderManager"
        
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
        
        self.viewModel.getOrderList(searchT: self.selectedTBtn.titleLabel!.text!) { [unowned self] in
            
            self.tableView.k_headerEndRefreshing()
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

        let modelArr = self.viewModel.getValueModel(indexPath.section)
        let model = modelArr[indexPath.row]
     
        let detailVC = AddViewController.init(model: model)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.viewModel.dataList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let modelArr = self.viewModel.getValueModel(section)
        let model = modelArr.first!
        
        return model.isOpen ? (modelArr.count) : (0)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let text = self.viewModel.getKeyStr(section)
        let headView = OrderHeaderView.loadXibView(text: text, height: tableView.sectionHeaderHeight)
        
        let modelArr = self.viewModel.getValueModel(section)
        headView.showAnimaton(isOpen: modelArr.first!.isOpen)
        
        headView.k_addTarget {

            DispatchQueue.main.async {
                
                modelArr.first!.isOpen = !modelArr.first!.isOpen
                tableView.reloadSections(IndexSet.init(integer: section), with: .automatic)
            }
        }
        
        return headView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderCell
        cell.model = self.viewModel.getValueModel(indexPath.section)[indexPath.row]
        
        return cell
    }
}

        
