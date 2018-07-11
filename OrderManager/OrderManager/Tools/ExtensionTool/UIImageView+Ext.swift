//
//  UIImage+Ext.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/7/10.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

extension UIImageView {
    
    
}

extension UIImage {
    
    //MARK: 裁剪方形图片为圆形
    /// 裁剪方形图片为圆形
    ///
    /// - Parameter backColor: 填充颜色,默认白色
    /// - Returns: 新图片
    func k_circleImage(backColor: UIColor = UIColor.white) -> UIImage {
        
        let rect = CGRect(origin: CGPoint(), size: self.size)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, true, UIScreen.main.scale)
        // 填充
        backColor.setFill()
        UIRectFill(rect)
        
        // 形状
        let circlePath = UIBezierPath.init(ovalIn: rect)
        circlePath.addClip()
        
        self.draw(in: rect)
        
        UIColor.darkGray.setStroke()
        circlePath.lineWidth = 1.0
        circlePath.stroke()
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result ?? self
    }
}
