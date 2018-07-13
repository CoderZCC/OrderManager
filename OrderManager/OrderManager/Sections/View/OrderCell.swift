//
//  OrderCell.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/12.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {

    /// 数据模型
    var model: CostModel! {
        
        willSet {
            
            self.timeL.text = newValue.costTime.k_dealTimeToShow(formatter: "yyyy MM-dd HH:mm")
            self.costNumL.text = newValue.costNum!
            
            self.costTypeL.text = "消费类型:" + newValue.costType!
        }
    }
    /// 日期
    @IBOutlet weak var timeL: UILabel!
    /// 圆角View
    @IBOutlet weak var showView: UIView!
    /// 消费类型
    @IBOutlet weak var costTypeL: UILabel!
    /// 消费金额
    @IBOutlet weak var costNumL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.showView.k_setCornerRadius(5.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }    
}
