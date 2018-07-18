//
//  DataMacro.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/11.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

/// 是否是iphoneX
var kIsIphoneX: Bool {
    var systemInfo = utsname()
    uname(&systemInfo)
    let machineMirror = Mirror(reflecting: systemInfo.machine)
    
    let identifier = machineMirror.children.reduce("") { identifier, element in
        guard let value = element.value as? Int8, value != 0 else { return identifier }
        return identifier + String(UnicodeScalar(UInt8(value)))
    }
    let arr = identifier.components(separatedBy: ",")
    if (arr.first ?? "") == "x86_64" {
        
        return kHeight > 736.0
    }
    return ((arr.first ?? "") == "iPhone10") && ((arr.last ?? "") == "3" || (arr.last ?? "") == "6")
}
/// 导航栏高度
var kNavBarHeight: CGFloat { return kIsIphoneX ? (88.0) : (64.0) }
/// 底部不可控区域
var kBottomSpace: CGFloat { return kIsIphoneX ? (34.0) : (0.0) }
/// 屏幕宽
var kWidth: CGFloat { return UIScreen.main.bounds.size.width }
/// 屏幕高
var kHeight: CGFloat { return UIScreen.main.bounds.size.height }
/// 主窗口
var kWindow: UIWindow { return UIApplication.shared.keyWindow! }
/// 根试图控制器
var kRootVC: UIViewController? { return kWindow.rootViewController }
/// AppDeleagte
var kAppDelegate: AppDelegate { return UIApplication.shared.delegate as! AppDelegate }

/// 主题切换
let kThemeChangeNoteKey: String = "kThemeChangeNoteKey"
/// 主题文件保存的地址
let kThemeSavePath: String = String.k_documentsPath + "theme.plist"

/// 导航栏颜色
let kNavbarColor: UIColor = UIColor.k_colorWith(r: 214.0, g: 34.0, b: 34.0)
/// 消费类型 Str
let kCostTypeStr: [String] = ["早饭", "午饭", "晚饭", "网购", "话费", "其他"]

/// 缓存目录
let kCachesPath: String = String.k_documentsPath + "costDetail.plist"

/// 现在的时间
var kNowDate: Date {
    return Date()
}
/// 加号按钮的大小
let kAddBtnWH: CGFloat = 65.0
/// 保存到本地点位置
let kAddBtnLocationKey: String = "kAddBtnLocationKey"

/// 字体大小
let kFont12: UIFont = UIFont.systemFont(ofSize: 12.0)
let kFont14: UIFont = UIFont.systemFont(ofSize: 14.0)
let kFont16: UIFont = UIFont.systemFont(ofSize: 16.0)

/// 占位文字颜色
let kPlaceholderTextcolor: UIColor = UIColor.k_colorWith(r: 223.0, g: 221.0, b: 220.0)

/// 圆角
let kCornerRadius: CGFloat = 4.0

/// 侧滑的最大距离
let kSliderMaxWidth: CGFloat = kWidth * 0.8

/// BmobID
let kBombID: String = "cd82cc6cef17ff9fe619b2fe68a07222"

/// 回调
typealias CallBack = (()->Void)?

/// 账号对应的key
let kAccountkey: String = "kAccountkey"
let kUserIdkey: String = "kUserIdkey"



