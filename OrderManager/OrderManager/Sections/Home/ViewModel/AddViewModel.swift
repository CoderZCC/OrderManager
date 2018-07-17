//
//  HomeViewModel.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/11.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit
import CoreLocation

class AddViewModel: NSObject {
    
    /// 是否需要更新
    var isChangevalue: Bool = false
    
    /// 定位回调
    var locationCallBack:((String)->Void)?
    private let locationManager = CLLocationManager.init()
    private let clGeocoder = CLGeocoder.init()
    /// 位置高度
    var areaHeight: CGFloat = 49.0
    /// 数据模型
    var costModel: CostModel = CostModel()
   
    /// 保存订单
    ///
    /// - Parameter callBack: 完成的回调
    func saveOrder(callBack: CallBack) {
        
        self.showLoading("保存数据中")
        ServicerTool.addCostMsg(costModel: self.costModel, success: {
            
            self.showText("保存成功")
            callBack?()

        }) {
            
            callBack?()
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
            
            callBack?()
            self.showText("更新失败")
        }
    }
}

/// 定位相关
extension AddViewModel: CLLocationManagerDelegate {
    
    /// 开始定位
    ///
    /// - Parameter locationCallBack: 回调
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
