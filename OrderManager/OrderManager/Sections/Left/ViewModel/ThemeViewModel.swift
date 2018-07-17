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

    var collectionView: UICollectionView!
    var dataList: [ThemeModel] = []
    
    func getItemSize(collectionView: UICollectionView) -> CGSize {
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        let width: CGFloat = (kWidth - collectionView.contentInset.left - collectionView.contentInset.right - layout.minimumInteritemSpacing * 2.0) / 3.0
        let height: CGFloat = width * 1.5
        
        return CGSize.init(width: width, height: height)
    }
    
    /// 选择照片事件
    func selectedImg() {
        
        self.k_showSheets(title: "请选择", subTitles: ["从相册获取", "拍照"], callBack: { (index) in
            
            if index == 0 {
                
                CameraTool.takeImage(callBack: { (img) in
                    
                    self.addThemeToServer(img: img)
                })
                
            } else {
                
                CameraTool.takePhoto(callBack: { (img) in
                   
                    self.addThemeToServer(img: img)
                })
            }
        })
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
    
    /// 添加主题到云端
    ///
    /// - Parameters:
    ///   - img: 图片
    ///   - callBack: 回调
    func addThemeToServer(img: UIImage) {
        
        ServicerTool.uploadImg(img: img) { (path) in
            
            let themeList = BmobObject.init(className: kThemeListName)!
            themeList.setObject(path, forKey: "themeImgUrl")
            themeList.setObject(kNowDate.k_toDateStr("yyyyMMddHHmmss"), forKey: "themeId")

            themeList.saveInBackground { (isOK, error) in
                
                if isOK {
                    
                    self.showText("主题上传成功")
                    self.collectionView.k_headerBeginRefreshing()
                    
                } else {
                    
                    self.showText("主题上传失败")
                }
            }
        }
    }
    
    /// 保存主题到云端
    ///
    /// - Parameter callBack: 回调
    func saveToServer(callBack: ((Bool)->Void)?) {
        
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
                    
                    callBack?(isOK)
                })
                
            } else {
                
                callBack?(false)
            }
        }
    }
    
}
