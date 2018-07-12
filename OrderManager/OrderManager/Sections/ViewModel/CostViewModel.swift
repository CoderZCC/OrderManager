//
//  HomeViewModel.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/11.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

typealias CallBack = (()->Void)?

class CostViewModel: NSObject {
    
    /// 数据模型
    var costModel: CostModel!
    /// 数据源
    var dataList: [String: [CostModel]] = [:]
    /// 所有的key
    lazy var allKeys: [String] = {
        var arr: [String] = []
        for key in self.dataList.keys {
            
            arr.append(key)
        }
        return arr
    }()
    /// 获取key
    ///
    /// - Parameter index: 组下标
    /// - Returns: key
    func getKeyStr(_ index: Int) -> String {
        
        return self.allKeys[index]
    }
    /// 获取model数组
    ///
    /// - Parameter index: 组下标
    /// - Returns: model数组
    func getValueModel(_ index: Int) -> [CostModel] {
        
        let key = self.getKeyStr(index)
        let modelArr = self.dataList[key]
        
        return modelArr ?? []
    }
    
    /// 获取订单列表
    ///
    /// - Parameters:
    ///   - searchT: 时间
    ///   - callBack: 回调
    func getOrderList(searchT: String, callBack: CallBack) {
        
        self.dataList.removeAll()
        
        var allDateArr: [CostModel] = []
        for str in kSaveDataTool.k_getStrArr(from: kCachesPath) ?? [] {
            
            let model = CostModel.init(dataArr: str.components(separatedBy: ";"))
            if model.costYM == searchT && !allDateArr.contains(model) {
                
                allDateArr.append(model)
            }
        }
        
        // 以日分组
        var sectionDicArr: [String: [CostModel]] = [:]
        for model in allDateArr {
            
            if let arr = sectionDicArr[model.costYMD] {
                
                sectionDicArr[model.costYMD] = (arr + [model])
                
            } else {
                
                sectionDicArr[model.costYMD] = [model]
            }
        }
        self.dataList = sectionDicArr

        callBack?()
    }

    /// 保存订单
    ///
    /// - Parameter callBack: 完成的回调
    func saveOrder(callBack: CallBack) {
        
        var saveStr: String = "\(self.costModel.costType!);\(self.costModel.costNum!);\(self.costModel.costInfo);"
        saveStr += "\(self.costModel.costYMD);\(self.costModel.costYM);\(self.costModel.costTime)"
        
        if kSaveDataTool.k_save(str: saveStr, to: kCachesPath) {
            
            callBack?()
            
        } else {
            
            self.showText("保存失败")
        }
    }
    
}
