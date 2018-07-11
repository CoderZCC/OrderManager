//
//  HeaderView.swift
//  上下拉刷新
//
//  Created by 张崇超 on 2018/7/4.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class RefreshHeaderTool: UIView {

    /// 头试图的状态
    var headerState: RefreshHeaderState = .idle {
        
        willSet {
            
            self.stateL.text = kHeaderStateDic[newValue]
            
            newValue == .refreshing ? (self.activityView.startAnimating()): (self.activityView.stopAnimating())
            self.imgV.isHidden = (newValue == .refreshing)
            self.activityView.isHidden = !(newValue == .refreshing)
            
            if self.imgV.isHidden { return }
            UIView.animate(withDuration: 0.3) {
                
                if newValue == .pulling {
                    
                    self.imgV.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi)
                    
                } else {
                    
                    self.imgV.transform = CGAffineTransform.identity
                }
            }
        }
    }
    /// 初始的偏移量
    private var originalEdgeInset: UIEdgeInsets!
    /// 当前的滚动视图
    private var scrollView: UIScrollView!
    /// 开始刷新的回调
    private var callBack: (()->Void)?
    /// 展示状态的Label
    @IBOutlet weak var stateL: UILabel!
    /// 展示更新时间的Label
    @IBOutlet weak var timeL: UILabel!
    /// 箭头图片
    @IBOutlet weak var imgV: UIImageView!
    /// 菊花,默认隐藏
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    /// 偏移量
    private var offSetY: CGFloat {
        return self.scrollView.contentOffset.y
    }

    //MARK: -添加头部刷新控件
    /// 添加头部刷新控件
    ///
    /// - Parameters:
    ///   - scrollView: 当前的滚动视图
    ///   - callBack: 回调
    /// - Returns: headerView
    static func refreshWithHeader(scrollView: UIScrollView, callBack: (()->Void)?) -> RefreshHeaderTool {
        
        let tool = RefreshHeaderTool.loadHeaderView()
        tool.frame = CGRect.init(x: 0.0, y: -kHeaderHeight, width: scrollView.frame.width, height: kHeaderHeight)
        tool.scrollView = scrollView
        tool.originalEdgeInset = scrollView.contentInset
        tool.callBack = callBack
        tool.headerState = .idle

        tool.timeL.text = "最后更新：" + (UserDefaults.standard.value(forKey: kLastUpdatekey) as? String ?? "无记录")
        
        return tool
    }
    
    class func loadHeaderView() -> RefreshHeaderTool {
        let tool = Bundle.main.loadNibNamed("RefreshTool", owner: nil, options: nil)?.first as! RefreshHeaderTool
        return tool
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if self.offSetY >= 0.0 || self.headerState == .refreshing { return }
        // 头部更好出现的偏移量
        let happenOffsetY = self.originalEdgeInset.top
        // 普通 和 即将刷新 的临界点
        let compareNum = happenOffsetY - kHeaderHeight;
      
        if self.scrollView.isDragging {
            
            if self.offSetY >= compareNum && self.headerState == .pulling {
                
                self.headerState = .idle
                
            } else if self.offSetY < compareNum && self.headerState == .idle {
                
                self.headerState = .pulling
                self.timeL.text = "最后更新：" + (UserDefaults.standard.value(forKey: kLastUpdatekey) as? String ?? "无记录")
            }
            
        } else {
            
            if self.headerState == .pulling && self.headerState != .refreshing {
                
                self.beginRefreshing()
            }
        }
    }
    
    //MARK: -开始刷新
    func beginRefreshing() {
        
        if self.headerState == .refreshing { return }
        self.headerState = .refreshing
        // 偏移
        var newInset = self.scrollView.contentInset
        newInset.top = kHeaderHeight
        if self.offSetY >= -(kHeaderHeight + 10.0) && self.offSetY != 0.0 {
            
            self.scrollView.contentInset = newInset
            self.callBack?()

        } else {
            
            UIView.animate(withDuration: 0.25, animations: {
                
                self.scrollView.contentInset = newInset
                
            }) { (isOK) in
                
                self.callBack?()
            }
        }
    }
    
    //MARK: -结束刷新
    func endRefreshing() {
        
        if self.headerState == .idle { return }
        self.headerState = .idle
        // 偏移
        UIView.animate(withDuration: 0.25, animations: {
            
            self.scrollView.contentInset = self.originalEdgeInset
            
        }) { (isOK) in
            
            self.headerState = .idle
            // 保存一个时间到偏好设置
            let dateStr = Date.currentTime(formatter: "MM-dd HH:mm")
            UserDefaults.standard.set(dateStr, forKey: kLastUpdatekey)
            UserDefaults.standard.synchronize()
        }
    }
}
