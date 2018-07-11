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

let kNavbarColor: UIColor = UIColor.k_colorWith(r: 214.0, g: 34.0, b: 34.0)
