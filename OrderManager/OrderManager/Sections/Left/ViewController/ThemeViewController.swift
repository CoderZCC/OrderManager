//
//  ThemeViewController.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/17.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class ThemeViewController: BaseViewController {

    /// 集合视图
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initView()
    }
    
    func initView() {
        
        self.title = "主题管理"

        self.layout.minimumLineSpacing = 5.0
        self.layout.minimumInteritemSpacing = 5.0
        self.collectionView.contentInset = UIEdgeInsetsMake(0.0, 8.0, 5.0, 8.0)
        
        self.layout.itemSize = self.viewModel.getItemSize(collectionView: self.collectionView)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(UINib.init(nibName: "ThemeCell", bundle: nil), forCellWithReuseIdentifier: "ThemeCell")
        
        self.collectionView.k_addHeaderRefresh {
            
            self.initData()
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "上传", clickCallBack: {
            
            self.viewModel.selectedImg()
        })
        self.collectionView.k_headerBeginRefreshing()
    }

    func initData() {
        
        self.viewModel.getThemeList { [unowned self] in
            
            self.collectionView.k_headerEndRefreshing()
            self.collectionView.k_reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    lazy var viewModel: ThemeViewModel = {
        let model = ThemeViewModel()
        model.collectionView = self.collectionView
        
        return model
    }()
}

extension ThemeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! ThemeCell
        
        PhotoBrowerTool.showPhotoBrower(imgArrs: self.viewModel.dataList, currentIndex: indexPath.row, baseView: collectionView, currentImg: cell.imgV.image, originalFrame: collectionView.convert(cell.frame, to: self.view))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.viewModel.dataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThemeCell", for: indexPath) as! ThemeCell
        let model = self.viewModel.dataList[indexPath.row]
        cell.themeModel = model
        cell.callBack = {
            
            collectionView.k_headerBeginRefreshing()
        }
        
        return cell
    }
}
