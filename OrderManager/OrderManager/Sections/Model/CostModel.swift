//
//  AddModel.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/11.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class CostModel: NSObject {

    /// 消费时间 月日
    //var costMD: String = kNowDate.k_toDateStr("MM-dd")
    lazy var costMD: String = {
        return self.costTime.k_subText(from: 5, to: 9)
    }()
    /// 消费时间 年月
    //var costYM: String = kNowDate.k_toDateStr("yyyy-MM")
    lazy var costYM: String = {
        return self.costTime.k_subText(to: 3) + "-" + self.costTime.k_subText(from: 5, to: 6)
    }()
    /// 消费时间 年月日时分
    var costTime: String = kNowDate.k_toDateStr("yyyy MM-dd HH:mm")
    /// 消费类型
    var costType: String?
    /// 消费金额
    var costNum: String?
    /// 位置信息
    var address: String = "未知区域"
    /// 消费备注
    var costInfo: String = "暂无备注信息"
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
        self.address = dataArr[6]
    }

}
