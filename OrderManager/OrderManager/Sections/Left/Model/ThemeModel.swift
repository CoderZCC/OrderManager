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
    
    convenience init(obj: BmobObject) {
        self.init()
    
        self.themeId = obj.object(forKey: "themeId") as! String
        self.themeImgUrl = obj.object(forKey: "themeImgUrl") as! String
    }

    
}
