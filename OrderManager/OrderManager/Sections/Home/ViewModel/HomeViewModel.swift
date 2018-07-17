//
//  HomeViewModel.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/17.
//  Copyright © 2018年 ZCC. All rights reserved.
//
import UIKit

class HomeViewModel: NSObject {
    
    /// 是否需要展开第一个
    var isNeedOpenFirst: Bool = true

    /// 数据模型
    var costModel: CostModel = CostModel()
    /// 数据源
    var dataList: [String: [CostModel]] = [:]
    /// 所有的key
    var allKeys: [String] {
        var arr: [String] = []
        for key in self.dataList.keys {
            
            arr.append(key)
        }
        return arr.sorted().reversed()
    }
    
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
        var modelArr = self.dataList[key] ?? []
        modelArr.sort { (model1: CostModel, model2: CostModel) -> Bool in
            return model1.costTime > model2.costTime
        }
        
        return modelArr
    }
    
    /// 加号按钮的位置
    var addBtnLocation: CGPoint {
        if let str = kSaveDataTool.k_checkValueFromUserdefault(key: kAddBtnLocationKey) {
            
            let arr = str.components(separatedBy: ";")
            return CGPoint.init(x: arr.first!.k_toCGFloat(), y: arr.last!.k_toCGFloat())
        }
        return CGPoint.init(x: kAddBtnWH / 2.0, y: kHeight - kAddBtnWH * 4.0)
    }
    
    /// 获取订单列表
    ///
    /// - Parameters:
    ///   - searchT: 时间
    ///   - callBack: 回调
    func getOrderList(searchT: String, callBack: CallBack) {
        
        ServicerTool.getCostMsg(queryYM: searchT, success: { (modelArr) in
            
            // 以日分组
            var sectionDicArr: [String: [CostModel]] = [:]
            for model in modelArr {
                
                if let arr = sectionDicArr[model.costMD] {
                    
                    sectionDicArr[model.costMD] = (arr + [model])
                    
                } else {
                    
                    sectionDicArr[model.costMD] = [model]
                }
            }
            self.dataList = sectionDicArr
            callBack?()
            
        }) {
            
            callBack?()
            self.showText("查询列表失败")
        }
    }
    
    /// 删除消费数据
    ///
    /// - Parameters:
    ///   - costModel: 数据模型
    ///   - callBack: 回调
    func deleteOrder(costModel: CostModel, callBack: CallBack) {
        
        self.showLoading("删除数据中")
        ServicerTool.deleteOrder(costModel: costModel, success: {
            
            self.hideHUD()
            callBack?()
            
        }) {
            
            callBack?()
            self.showText("删除失败")
        }
    }
}

extension HomeViewModel {
    
    /// 获取当天的消费金额
    ///
    /// - Returns: [String : CGFloat]
    var allCosts: [String : CGFloat] {
        
        var dic: [String : CGFloat] = [:]
        let allNum = self.dataList.count
        for index in 0..<allNum {
            
            let key = self.getKeyStr(index)
            var keyValue: CGFloat = 0.00
            for model in self.dataList[key] ?? [] {
                
                keyValue += model.costNum!.k_toCGFloat()
            }
            dic[key] = keyValue
        }
        return dic
    }
}

