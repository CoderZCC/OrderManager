//
//  ServicerTool.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/13.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

/// 消费表
let kCostListName: String = "CostList"

typealias SuccessNoDataBlock = (()->Void)?
typealias SuccessDataBlock = (([CostModel])->Void)?
typealias FailBlock = (()->Void)?

class ServicerTool: NSObject {
    
    /// 上传头像
    ///
    /// - Parameters:
    ///   - img: 头像
    ///   - callBack: 回调
    class func uploadImg(img: UIImage, callBack: ((String) -> Void)?) {
        
        kWindow?.showLoading("图片处理中")
        let imgData = img.k_pressImgSize()
        let file = BmobFile.init(fileName: "\(kNowDate.k_toDateStr("yyMMddHHmmss")).png", withFileData: imgData)
        file?.save(inBackground: { (isOK, error) in
            
            if isOK {
                
                print("isOK:\(file!.url)")
                callBack?(file!.url)
                kWindow?.hideHUD()
                
            } else {
                
                kWindow?.showText("图片上传失败，请重试")
            }
            
        }, withProgressBlock: { (progress) in
            
            kWindow?.showProgress(progress: progress, text: "图片上传中")
        })
    }
    
    /// 检查账号是否存在
    ///
    /// - Parameters:
    ///   - account: 账号
    ///   - callback: 回调
    class func userIsExit(account: String, callback: ((Bool, BmobObject?) -> Void)? ) {
        
        let queryList = BmobQuery.init(className: kUserListName)!
        queryList.whereKey("account", equalTo: account)

        queryList.findObjectsInBackground { (dataArr, error) in
            
            if let dataArr = dataArr as? [BmobObject], !dataArr.isEmpty {
                
                let userObj = dataArr.first!
                callback?(true, userObj)
                
            } else {
                
                callback?(false, nil)
            }
        }
    }
    
    //MARK: 添加消费数据
    /// 添加消费数据
    ///
    /// - Parameters:
    ///   - costModel: 消费模型
    ///   - success: 成功
    ///   - fail: 失败
    class func addCostMsg(costModel: CostModel, success: SuccessNoDataBlock, fail: FailBlock) {
        
        let list: BmobObject = BmobObject.init(className: kCostListName)!
        self.setValueTo(costModel: costModel, object: list)

        list.saveInBackground { (isOK, error) in
            
            isOK ? (success?()) : (fail?())
        }
    }
    
    //MARK: 查询消费数据
    /// 查询消费数据
    ///
    /// - Parameters:
    ///   - queryYM: 查询年月
    ///   - success: 成功
    ///   - fail: 失败
    class func getCostMsg(queryYM: String, success: SuccessDataBlock, fail: FailBlock) {
        
        let queryList = BmobQuery.init(className: kCostListName)!
        queryList.whereKey("costYearMonth", equalTo: queryYM)
        queryList.whereKey("userId", equalTo: LoginModel.cachesUserId)
        
        queryList.findObjectsInBackground { (dataArr, error) in
            
            if let error = error {
             
                fail?()
                print("error:\(error)")
                return
            }
            var arr: [CostModel] = []
            for data in dataArr ?? [] {
                
                if let dataDic = data as? BmobObject {
                    
                    let model = CostModel()
                    model.costTime = dataDic.object(forKey: "costTime") as! String
                    model.costType = dataDic.object(forKey: "costType") as? String
                    model.costNum = dataDic.object(forKey: "costNum") as? String
                    model.costInfo = dataDic.object(forKey: "costInfo") as! String
                    model.costYM = dataDic.object(forKey: "costYearMonth") as! String
                    model.objectId = dataDic.object(forKey: "objectId") as! String
                    
                    arr.append(model)
                    
                } else {
                    
                    print("数据解析失败")
                }
            }
            success?(arr)
        }
    }
    
    //MARK: 更新消费数据
    /// 更新消费数据
    ///
    /// - Parameters:
    ///   - costModel: 数据模型
    ///   - success: 成功
    ///   - fail: 失败
    class func updateCostMsg(costModel: CostModel, success: SuccessNoDataBlock, fail: FailBlock) {
        
        let queryList = BmobQuery.init(className: kCostListName)!
        queryList.getObjectInBackground(withId: costModel.objectId) { (object, error) in
            
            if let object = object {
                
                let newObj = BmobObject.init(outDataWithClassName: object.className, objectId: object.objectId)!
                self.setValueTo(costModel: costModel, object: newObj)
                
                newObj.updateInBackground(resultBlock: { (isOK, error) in
                    
                    isOK ? (success?()) : (fail?())
                })
            }
        }
    }
    
    //MARK: 删除消费数据
    /// 删除消费数据
    ///
    /// - Parameters:
    ///   - costModel: 数据模型
    ///   - success: 成功
    ///   - fail: 失败
    class func deleteOrder(costModel: CostModel, success: SuccessNoDataBlock, fail: FailBlock) {
        
        let queryList = BmobQuery.init(className: kCostListName)!
        queryList.getObjectInBackground(withId: costModel.objectId) { (object, error) in
            
            if let obj = object {
                
                obj.deleteInBackground({ (isOK, error) in
                    
                    isOK ? (success?()) : (fail?())
                })
            } else {
                
                fail?()
            }
        }
    }
    
    /// 设置数据
    private class func setValueTo(costModel: CostModel, object: BmobObject) {
        
        object.setObject(LoginModel.cachesUserId, forKey: "userId")
        
        object.setObject(costModel.costTime, forKey: "costTime")
        object.setObject(costModel.costType, forKey: "costType")
        object.setObject(costModel.costNum!, forKey: "costNum")
        object.setObject(costModel.costInfo, forKey: "costInfo")
        object.setObject(costModel.costYM, forKey: "costYearMonth")
    }
}
