//
//  HomeViewModel.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/11.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit
import CoreLocation

typealias CallBack = (()->Void)?

class CostViewModel: NSObject {
    
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
        return arr.sorted()
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
        
        return modelArr ?? []
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
            
            if let arr = sectionDicArr[model.costMD] {
                
                print("新增")
                sectionDicArr[model.costMD] = (arr + [model])
                
            } else {
                
                print("创建")
                sectionDicArr[model.costMD] = [model]
            }
        }
        print(sectionDicArr)
        self.dataList = sectionDicArr

        callBack?()
    }

    /// 保存订单
    ///
    /// - Parameter callBack: 完成的回调
    func saveOrder(callBack: CallBack) {
        
        var saveStr: String = "\(self.costModel.costType!);\(self.costModel.costNum!);\(self.costModel.costInfo);"
        
        saveStr += "\(self.costModel.costMD);\(self.costModel.costYM);\(self.costModel.costTime);" + "\(self.costModel.address)"
        
        if kSaveDataTool.k_save(str: saveStr, to: kCachesPath) {
            
            callBack?()
            
        } else {
            
            self.showText("保存失败")
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
            
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude

            print(latitude,longitude)
            
            self.locationManager.stopUpdatingLocation()
            
            self.clGeocoder.reverseGeocodeLocation(location) { (marks, error) in
                
                if error != nil {return}
                if let result = marks {
                    
                    var callbackStr: String!
                    let firstPL: CLPlacemark = result.first!
                    if let address = firstPL.addressDictionary!["FormattedAddressLines"] as? [Any] {
                        
                        callbackStr = (address.first as? String) ?? "未知区域"

                    } else {
                        
                        callbackStr = firstPL.name ?? "未知区域"
                    }
                    
                    // 计算高度
                    let size = callbackStr.k_textSize(size: CGSize.init(width: kWidth * 3.0 / 2.0, height: kHeight), font: k_Font14)
                    self.areaHeight = min(18.0, size.height)
                    
                    self.locationCallBack?(callbackStr)
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        self.showText("定位失败")
    }
}
