//
//  LeftViewController.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/13.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class LeftViewController: BaseViewController {

    /// 内容试图
    @IBOutlet weak var contentView: UIView!
    /// 退出登录
    @IBOutlet weak var logoutBtn: UIButton!
    /// 距离右侧的约束
    @IBOutlet weak var rightCons: NSLayoutConstraint!
    /// 集合视图
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
    }

    func initView() {
        
        self.logoutBtn.k_setCornerRadius(kCornerRadius)
        self.rightCons.constant = kWidth - kSliderMaxWidth
        
        self.layout.minimumLineSpacing = 1.0
        self.layout.minimumInteritemSpacing = 1.0
        self.layout.headerReferenceSize = CGSize.init(width: self.contentView.bounds.width, height: 100.0)
        
        self.collectionView.contentInset = UIEdgeInsets.init(top: 5.0, left: 15.0, bottom: 5.0, right: 15.0)
        let itemW: CGFloat = self.viewModel.getItemWidth(columnsNum: 2)
        self.layout.itemSize = CGSize.init(width: itemW, height: itemW)
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        self.collectionView.register(UINib.init(nibName: "LeftContentCell", bundle: nil), forCellWithReuseIdentifier: "LeftContentCell")
        self.collectionView.register(UINib.init(nibName: "LeftHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "sectionHeader")
    }
    
    @IBAction func logoutAction() {
        
        self.k_showAlert(title: "确定要退出登录吗?") {
            
            kSaveDataTool.k_deletePassword(account: LoginModel.cachesAccount)
            kAppDelegate.loginResult(isSuccess: false)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    lazy var viewModel: LeftViewModel = { [unowned self] in
        let viewModel = LeftViewModel.init(collectionView: self.collectionView)
        return viewModel
    }()
    
}

extension LeftViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let themeVC = ThemeViewController()
        self.k_navigationVC?.pushViewController(themeVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LeftContentCell", for: indexPath) as! LeftContentCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            
            let headView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "sectionHeader", for: indexPath)
            
            return headView
        }
        return UICollectionReusableView()
    } 
}
