//
//  LeftHeaderView.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/16.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class LeftHeaderView: UICollectionReusableView {

    @IBOutlet weak var headImgV: UIImageView!
    @IBOutlet weak var nikeNameL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.headImgV.k_setCircleImgV()
        self.headImgV.k_setImage(url: LoginModel.cachesHeadPic)
        self.nikeNameL.text = LoginModel.cachesAccount
    }
    
}
