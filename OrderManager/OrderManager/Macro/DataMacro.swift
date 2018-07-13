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

/// 导航栏颜色
let kNavbarColor: UIColor = UIColor.k_colorWith(r: 214.0, g: 34.0, b: 34.0)
/// 消费类型 Str
let kCostTypeStr: [String] = ["早饭", "午饭", "晚饭", "网购", "话费", "其他"]

/// 缓存目录
let kCachesPath: String = String.k_documentsPath + "costDetail.plist"

/// 现在的时间
let kNowDate: Date = Date()

/// 加号按钮的大小
let kAddBtnWH: CGFloat = 65.0
/// 保存到本地点位置
let kAddBtnLocationKey: String = "kAddBtnLocationKey"

/// 字体大小
let kFont12: UIFont = UIFont.systemFont(ofSize: 12.0)
let kFont14: UIFont = UIFont.systemFont(ofSize: 14.0)
let kFont16: UIFont = UIFont.systemFont(ofSize: 16.0)

/// BmobID
let kBombID: String = "cd82cc6cef17ff9fe619b2fe68a07222"

