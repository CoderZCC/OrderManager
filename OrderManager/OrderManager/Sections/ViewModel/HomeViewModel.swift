//
//  HomeViewModel.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/11.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

typealias CallBack = (([CostModel])->Void)?

class HomeViewModel: NSObject {
        
    static func getOrderList(callBack: CallBack) {
        
        callBack?([])
    }
    
    static func setModel(model: CostModel, conentArr: [String]) {
        
        model.costYear = conentArr[0]
        model.costMonth = conentArr[1]
        model.costDay = conentArr[2]

        model.costTime = conentArr[3]
        model.costType = conentArr[4]
        model.costNum = conentArr[5]
        model.costInfo = conentArr[6]
    }
}
