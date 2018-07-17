//
//  ThemeViewModel.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/17.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

let kThemeListName: String = "ThemeList"

class ThemeViewModel: NSObject {

    var dataList: [ThemeModel] = []
    
    func getItemSize(collectionView: UICollectionView) -> CGSize {
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        let width: CGFloat = (kWidth - collectionView.contentInset.left - collectionView.contentInset.right - layout.minimumInteritemSpacing * 2.0) / 3.0
        let height: CGFloat = width * 1.5
        
        return CGSize.init(width: width, height: height)
    }
    
    /// 获取主题列表
    ///
    /// - Parameter callBack: 回调
    func getThemeList(callBack: (() -> Void)?) {
        
        let queryList = BmobQuery.init(className: kThemeListName)!
        queryList.findObjectsInBackground { (dataArr, error) in
            
            self.dataList = []
            for data in dataArr ?? [] {
                
                if let dataDic = data as? BmobObject {
                    
                    let model = ThemeModel.init(obj: dataDic)
                    self.dataList.append(model)
                    
                } else {
                    
                    print("数据解析失败")
                }
            }
            callBack?()
        }
    }
    
    func saveToServer(callBack: (() -> Void)?) {
        
        let queryList = BmobQuery.init(className: kThemeListName)!
        queryList.whereKey("userId", equalTo: LoginModel.cachesUserId)
        queryList.findObjectsInBackground { (dataArr, error) in
            
            if let dataArr = dataArr as? [BmobObject], !dataArr.isEmpty {
                
                let userObj = dataArr.first!
                let newObj = BmobObject.init(outDataWithClassName: userObj.className, objectId: userObj.objectId)!
                if let dic = kSaveDataTool.K_getData(from: kThemeSavePath) as? [String: Data] {
                    
                    newObj.setObject(dic.keys.first!, forKey: "themeId")
                    
                } else {
                    
                    newObj.setObject("0", forKey: "themeId")
                }
                
                newObj.updateInBackground(resultBlock: { (isOK, error) in
                    
                    isOK ? (callBack?()): (callBack?())
                })
                
            } else {
                
                callBack?()
            }
        }
    }
    
}
