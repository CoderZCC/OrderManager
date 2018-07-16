//
//  AddModel.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/11.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class CostModel: NSObject {

    /// 主键
    var objectId: String = ""
    /// 消费时间 月日
    lazy var costMD: String = {
        return self.costTime.k_subText(from: 5, to: 9)
    }()
    /// 消费时间 年月
    lazy var costYM: String = {
        return self.costTime.k_subText(to: 3) + "-" + self.costTime.k_subText(from: 5, to: 6)
    }()
    /// 消费时间 年月日时分
    var costTime: String = kNowDate.k_toDateStr("yyyy MM-dd HH:mm")
    /// 消费类型 0-5
    var costType: String?
    /// 消费金额
    var costNum: String?
    /// 消费备注
    var costInfo: String = ""
    /// 是否展开
    var isOpen: Bool = false
    
    convenience init(dataArr: [String]) {
        self.init()
        
        self.costType = dataArr[0]
        self.costNum = dataArr[1]
        self.costInfo = dataArr[2]
        
        self.costMD = dataArr[3]
        self.costYM = dataArr[4]
        self.costTime = dataArr[5]
    }

}
