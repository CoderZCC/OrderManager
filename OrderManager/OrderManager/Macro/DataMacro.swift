//
//  DataMacro.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/11.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

let kWidth = UIScreen.main.bounds.size.width
let kHeight = UIScreen.main.bounds.size.height
let kNavBarHeight: CGFloat = kHeight > 736.0 ? (88.0) : (64.0)
let kWindow = UIApplication.shared.keyWindow
let kRootVC = kWindow?.rootViewController
let kBottomSpace: CGFloat = kHeight > 736.0 ? (34.0) : (0.0)

let kViewColor: UIColor = UIColor.k_colorWith(rgb: 216.0)
/// 导航栏颜色
let kNavbarColor: UIColor = UIColor.k_colorWith(r: 214.0, g: 34.0, b: 34.0)
/// 消费类型 Str
let kCostTypeStr: [String] = ["早饭", "午饭", "晚饭", "网购", "话费", "其他"]
/// 消费类型 ID
let kCostTypeID: [Int: String] = [0: "早饭", 1: "午饭", 2: "晚饭", 3: "网购", 4: "话费", 5: "其他"]
/// 缓存目录
let kCachesPath: String = String.k_documentsPath + "costDetail.plist"
