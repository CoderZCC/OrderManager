//
//  HomeViewModel.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/11.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit
import CoreLocation

class CostViewModel: NSObject {
        
    /// 是否需要更新
    var isChangevalue: Bool = false
    /// 是否需要展开第一个
    var isNeedOpenFirst: Bool = true
    
    /// 定位回调
    var locationCallBack:((String)->Void)?
    private let locationManager = CLLocationManager.init()
    private let clGeocoder = CLGeocoder.init()
    /// 位置高度
    var areaHeight: CGFloat = 49.0
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
        let modelArr = self.dataList[key]
        
        return modelArr?.reversed() ?? []
    }
    
    /// 加号按钮的位置
    var addBtnLocation: CGPoint {
        if let str = kSaveDataTool.k_checkValueFromUserdefault(key: kAddBtnLocationKey) {
            
            let arr = str.components(separatedBy: ";")
            return CGPoint.init(x: Int(arr.first!)!, y: Int(arr.last!)!)
        }
        return CGPoint.init(x: kAddBtnWH / 2.0, y: kHeight - kAddBtnWH * 4.0)
    }
    
    /// 获取订单列表
    ///
    /// - Parameters:
    ///   - searchT: 时间
    ///   - callBack: 回调
    func getOrderList(searchT: String, callBack: CallBack) {
        
        self.dataList.removeAll()
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
            
            self.showText("查询列表失败")
        }
    }

    /// 保存订单
    ///
    /// - Parameter callBack: 完成的回调
    func saveOrder(callBack: CallBack) {
        
        self.showLoading("保存数据中")
        ServicerTool.addCostMsg(costModel: self.costModel, success: {
            
            self.showText("保存成功")
            callBack?()

        }) {
            
            self.showText("保存失败")
        }
    }
    
    /// 更新消费数据
    ///
    /// - Parameters:
    ///   - costModel: 数据模型
    ///   - callBack: 回调
    func updateOrder(callBack: CallBack) {
        
        if !self.isChangevalue  {
            
            callBack?()
            return
        }
        self.showLoading("更新数据中")
        ServicerTool.updateCostMsg(costModel: self.costModel, success: {
            
            self.showText("更新成功")
            callBack?()
            
        }) {
            
            self.showText("更新失败")
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
            
            self.showText("删除失败")
        }
    }
    
}

extension CostViewModel: CLLocationManagerDelegate {
    
    func startLocation(locationCallBack:((String)->Void)?) {
        
        self.locationCallBack = locationCallBack
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.distanceFilter = 50
        self.locationManager.requestWhenInUseAuthorization()
        
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            
            self.locationManager.stopUpdatingLocation()
            
            self.clGeocoder.reverseGeocodeLocation(location) { (marks, error) in
                
                var callbackStr: String = "未知区域"
                if let result = marks {
                    
                    let firstPL: CLPlacemark = result.first!
                    if let address = firstPL.addressDictionary!["FormattedAddressLines"] as? [Any] {
                        
                        callbackStr = (address.first as? String) ?? "未知区域"

                    } else {
                        
                        callbackStr = firstPL.name ?? "未知区域"
                    }
                }
                // 计算高度
                let size = callbackStr.k_textSize(size: CGSize.init(width: kWidth * 3.0 / 2.0, height: kHeight), font: kFont14)
                self.areaHeight = min(18.0, size.height)
                
                self.locationCallBack?(callbackStr)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        self.showText("定位失败")
    }
}
