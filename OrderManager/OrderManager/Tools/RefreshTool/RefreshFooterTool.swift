//
//  RefreshFooterTool.swift
//  上下拉刷新
//
//  Created by 张崇超 on 2018/7/5.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class RefreshFooterTool: UIView {

    /// 头试图的状态
    var footerState: RefreshFooterState = .idle {
        
        willSet {
            
            self.stateL.text = kFooterStateDic[newValue]
            self.activityView.isHidden = !(newValue == .refreshing || newValue == .pulling)
            (newValue == .refreshing || newValue == .pulling) ? (self.activityView.startAnimating()): (self.activityView.stopAnimating())
        }
    }
    
    /// 当前的滚动视图
    private var scrollView: UIScrollView!
    /// 开始刷新的回调
    private var callBack: (()->Void)?
    /// 初始的偏移量
    private var originalEdgeInset: UIEdgeInsets!
    /// 偏移量
    private var offSetY: CGFloat {
        return self.scrollView.contentOffset.y
    }
    /// 内容高度
    private var contentHeight: CGFloat {
        return self.scrollView.contentSize.height
    }
    /// 头视图
    private var headerView: RefreshHeaderTool {
        
        return objc_getAssociatedObject(self.scrollView, &kScrollViewHeaderViewKey) as! RefreshHeaderTool
    }
    /// 展示状态的Label
    @IBOutlet weak var stateL: UILabel!
    /// 菊花,默认隐藏
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    //MARK: -添加尾部刷新控件
    /// 添加尾部刷新控件
    ///
    /// - Parameters:
    ///   - scrollView: 当前的滚动视图
    ///   - callBack: 回调
    /// - Returns: footerView
    static func refreshWithFooter(scrollView: UIScrollView, callBack: (()->Void)?) -> RefreshFooterTool {
        
        let tool = RefreshFooterTool.loadHeaderView()
        tool.frame = CGRect.init(x: 0.0, y: scrollView.frame.height, width: scrollView.frame.width, height: kFooterHeight)
        tool.scrollView = scrollView
        tool.callBack = callBack
        tool.originalEdgeInset = scrollView.contentInset
        tool.footerState = .idle
        
        return tool
    }
    
    class func loadHeaderView() -> RefreshFooterTool {
        let tool = Bundle.main.loadNibNamed("RefreshTool", owner: nil, options: nil)?.last as! RefreshFooterTool
        return tool
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if self.frame.minY != self.contentHeight && self.contentHeight > 0.0 {
            
            self.frame = CGRect.init(x: 0.0, y: scrollView.contentSize.height, width: scrollView.frame.width, height: kFooterHeight)
        }
        
        self.isHidden = (self.contentHeight == 0.0)
        // 下拉, 正在刷新, 无数据, 头视图正在刷新, 隐藏了
        if self.offSetY < 0.0 || self.footerState == .refreshing || self.footerState == .noData || self.headerView.headerState == .refreshing || self.isHidden { return }
    
        if self.scrollView.isDragging {
            
            // 是否到底了,到底开始刷新,底部出现时开始刷新
            let num = self.offSetY + self.scrollView.frame.height
            if num > self.contentHeight + kFooterHeight && self.footerState == .idle {
                
                self.footerState = .pulling
                
            } else if num <= self.contentHeight + kFooterHeight && self.footerState == .pulling {
                
                self.resetNoDataState()
            }

        } else {
            
            if self.footerState == .pulling {
                
                self.footerState = .refreshing
                
                var newInset = self.scrollView.contentInset
                newInset.bottom = kFooterHeight
                self.scrollView.contentInset = newInset
                
                self.callBack?()
            }
        }
    }
    
    //MARK: 无数据
    /// 无数据
    func endRefrshWithNoData() {
        
        self.footerState = .noData
    }
    
    //MARK: 重设无数据
    /// 重设无数据
    func resetNoDataState() {
    
        self.footerState = .idle
    }
}
