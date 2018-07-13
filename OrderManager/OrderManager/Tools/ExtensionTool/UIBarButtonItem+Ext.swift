//
//  UIBarButtonItem+Ext.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/13.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

var kUIBarItemActionKey: Int = 0

extension UIBarButtonItem {
    
    /// 添加点击事件回调
    ///
    /// - Parameters:
    ///   - image: 图片
    ///   - style: 类型 默认 plain
    ///   - clickCallBack: 点击回调
    /// - Returns: UIBarButtonItem
    static func k_addTarget(image: UIImage?, style: UIBarButtonItemStyle = .plain, clickCallBack: (()->Void)?) -> UIBarButtonItem {
        
        objc_setAssociatedObject(self, &kUIBarItemActionKey, clickCallBack, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        let barItem = UIBarButtonItem.init(image: image, style: style, target: self, action: #selector(UIBarButtonItem.k_barItemAction))
        
        return barItem
    }
    /// 添加点击事件回调
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - style: 类型 默认 plain
    ///   - clickCallBack: 点击回调
    /// - Returns: UIBarButtonItem
    static func k_addTarget(title: String, style: UIBarButtonItemStyle = .plain, clickCallBack: (()->Void)?) -> UIBarButtonItem {
        
        objc_setAssociatedObject(self, &kUIBarItemActionKey, clickCallBack, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        let barItem = UIBarButtonItem.init(title: title, style: style, target: self, action: #selector(UIBarButtonItem.k_barItemAction))
        
        return barItem
    }
    @objc static func k_barItemAction() {
        
        let callBack = objc_getAssociatedObject(self, &kUIBarItemActionKey) as! (()->Void)?
        callBack?()
    }
}
