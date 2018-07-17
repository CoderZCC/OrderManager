//
//  ThemeCell.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/17.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class ThemeCell: UICollectionViewCell {

    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var textL: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    var themeModel: ThemeModel! {
        willSet {
            
            self.imgV.k_setImage(url: newValue.themeImgUrl)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imgV.k_setCornerRadius(4.0)
        self.textL.k_setCornerRadius(3.0)
        self.textL.k_setBorder(color: UIColor.lightGray, width: 1.0)
    }

}
