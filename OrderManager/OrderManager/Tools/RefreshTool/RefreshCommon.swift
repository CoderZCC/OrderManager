//
//  RefreshCommon.swift
//  上下拉刷新
//
//  Created by 张崇超 on 2018/7/6.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class RefreshCommon: NSObject {
    
    /// 刷新动画
    static var loadingArr: [UIImage] = {
        var arr: [UIImage] = []
        for index in 1...3 {
            arr.append(UIImage.init(named: "dropdown_loading_0\(index)")!)
        }
        return arr
    }()
    /// 下拉动画
    static var pullingArr: [UIImage] = {
        var arr: [UIImage] = []
        for index in 1...60 {
            arr.append(UIImage.init(named: "dropdown_anim__000\(index)")!)
        }
        return arr
    }()
}

// ------------------------头试图相关------------------------
enum RefreshHeaderState {
    // 闲置状态, 松开就可以进行刷新的状态, 正在刷新中的状态
    case idle, pulling, refreshing
}

let kIdleStr: String = "下拉可以刷新"
let kPullingStr: String = "松开立即刷新"
let kRefreshingStr: String = "正在刷新数据中..."

let kHeaderStateDic: [RefreshHeaderState: String] = [.idle: kIdleStr, .pulling: kPullingStr, .refreshing: kRefreshingStr]

/// 头试图的高度
let kHeaderHeight: CGFloat = 40.0

/// 上次更新时间的键
let kLastUpdatekey: String = "kLastUpdatekey"

// ------------------------尾试图相关------------------------
enum RefreshFooterState {
    // 闲置状态, 正在刷新中的状态, 无数据了, 松手即刷新
    case idle, refreshing, noData, pulling
}

let kidleStr_Footer: String = "上拉加载更多"
let kRefreshing_Footer: String = "正在加载更多的数据..."
let kNoData_Footer: String = "没有更多数据了"
let kPullingStr_Footer: String = "松手加载更多"

let kFooterStateDic: [RefreshFooterState: String] = [.idle: kidleStr_Footer, .refreshing: kRefreshing_Footer, .noData: kNoData_Footer, .pulling: kPullingStr_Footer]

/// 尾试图的高度
let kFooterHeight: CGFloat = 40.0

// ------------------------其他相关------------------------
extension Date {
    
    //MARK: 获取当前时间
    /// 获取当前时间
    ///
    /// - Parameter formatter: yyyy-MM-dd HH:mm:ss
    /// - Returns: 字符串时间
    static func currentTime(formatter: String? = "yyyy-MM-dd HH:mm:ss") -> String {
        
        let now = Date.init()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        dateFormatter.locale = Locale.current
        let dateStr = dateFormatter.string(from: now)
        
        return dateStr
    }
    
    //MARK: 获取当前时间的年月日
    /// 获取当前时间的年月日
    ///
    /// - Returns: DateComponents
    static func currentYMD() -> DateComponents {
        
        let now = Date()
        // 获取当前的Calendar
        let calendar = Calendar.current
        // 使用（时区+时间）重载函数进行转换（这里参数in使用TimeZone的构造器创建了一个东七区的时区）
        let dateComponets = calendar.dateComponents(in: TimeZone.init(secondsFromGMT: 3600*7)!, from: now)
        /*
        let year = dateComponets.year!
        let month = dateComponets.month!
        let day = dateComponets.day!
        let hour = dateComponets.hour!
        let minute = dateComponets.minute!
        let second = dateComponets.second!
        */
        
        return dateComponets
    }
}

