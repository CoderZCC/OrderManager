//
//  AddModel.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/11.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class CostModel: NSObject {

    /// 年
    var costYear: String = "\(Date().k_YMDHMS().year!)"
    /// 月
    var costMonth: String = "\(Date().k_YMDHMS().month!)"
    /// 日
    var costDay: String = "\(Date().k_YMDHMS().day!)"
    /// 消费一天
    var sameDayArr: [CostModel] = []
    
    /// 消费时间
    var costTime: String = Date().k_toDateStr("yyyy MM-dd HH:mm")
    /// 消费类型
    var costType: String?
    /// 消费金额
    var costNum: String?
    /// 消费备注
    var costInfo: String = ""
}
