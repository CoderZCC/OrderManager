//
//  OrderHeaderView.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/12.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class OrderHeaderView: UIView {
    
    /// 时间
    @IBOutlet weak var timeL: UILabel!
    /// 箭头
    @IBOutlet weak var arrowImgV: UIImageView!
    
    /// 创建Xib
    class func loadXibView(text: String, height: CGFloat) -> OrderHeaderView {
        let tool = Bundle.main.loadNibNamed("OrderHeaderView", owner: nil, options: nil)?.last as! OrderHeaderView
        tool.frame = CGRect.init(x: 0.0, y: 0.0, width: kWidth, height: height)
        tool.timeL.text = text
        
        return tool
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func showAnimaton(isOpen: Bool) {
        
        UIView.animate(withDuration: 0.3) {
            
            self.arrowImgV.transform = isOpen ? (CGAffineTransform.identity) : (CGAffineTransform.init(rotationAngle: CGFloat.pi))
        }        
    }

}
