//
//  AddModel.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/11.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class CostModel: NSObject {

    /// 消费时间
    var costTime: String = Date().k_toDateStr("yyyy MM-dd HH:mm")
    /// 消费类型
    var costType: String?
    /// 消费金额
    var costNum: String?
    /// 消费备注
    var costInfo: String = ""
}
