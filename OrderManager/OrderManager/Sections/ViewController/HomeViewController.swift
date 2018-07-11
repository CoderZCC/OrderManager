//
//  HomeViewController.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/11.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.tableView)
    }

    lazy var tableView: UITableView = { [unowned self] in
        let tableView = UITableView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: kWidth, height: kHeight))
        tableView.tableFooterView = UIView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
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
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
}

