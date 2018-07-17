//
//  ThemeModel.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/17.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class ThemeModel: NSObject {

    var themeId: String = ""
    var themeImgUrl: String = ""
    /// 缓存路径
    lazy var cachesPath: String? = {
        let tuple = DownLoadTool.getDownloadResult(downloadUrl: self.themeImgUrl)

        return tuple.savePath
    }()
    /// 是否正在使用
    lazy var isUse: Bool = {
        
        if let dic = kSaveDataTool.K_getData(from: kThemeSavePath) as? [String: Data] {
            
            let id = dic.keys.first!
            return self.themeId == id
        }
        return false
    }()
    
    
    convenience init(obj: BmobObject) {
        self.init()
    
        self.themeId = obj.object(forKey: "themeId") as! String
        self.themeImgUrl = obj.object(forKey: "themeImgUrl") as! String
    }

    
}
