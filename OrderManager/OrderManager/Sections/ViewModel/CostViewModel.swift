//
//  HomeViewModel.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/11.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

typealias CallBack = (([CostModel])->Void)?

class CostViewModel: NSObject {
        
    static func getOrderList(callBack: CallBack) {
        
        var dataList: [CostModel] = []
        for str in kSaveDataTool.k_getStrArr(from: kCachesPath) ?? [] {
            
            let model = CostModel.init(dataArr: str.components(separatedBy: ";"))
            
            
            dataList.append(model)
        }
        
        callBack?(dataList)
    }

}
