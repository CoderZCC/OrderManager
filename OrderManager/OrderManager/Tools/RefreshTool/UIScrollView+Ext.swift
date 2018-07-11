//
//  BaseTableView.swift
//  NoDataTableView
//
//  Created by 张崇超 on 2018/6/1.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

enum PlaceholderEnum {
    case noData, netWorkError, serverError
}

var UIScrollViewPlacholderTextKey: UInt8 = 0
var UIScrollViewPlacholderImgKey: UInt8 = 1

var kScrollViewHeaderViewKey: Int = 2
var kScrollViewFooterViewKey: Int = 3

extension UIScrollView {
    
    // ================== 头部刷新控件 ==================
    
    //MARK: -添加Gif头部刷新控件
    /// 添加Gif头部刷新控件
    func addGifHeaderRefresh(callBack: (()->Void)?) {
        
        let header = RefreshGifHeaderTool.refreshWithHeader(scrollView: self, callBack: callBack)
        
        objc_setAssociatedObject(self, &kScrollViewHeaderViewKey, header, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        self.addObserver(header, forKeyPath: "contentOffset", options: .new, context: nil)
        self.addSubview(header)
    }
    //MARK: -添加普通头部刷新控件
    /// 添加普通头部刷新控件
    func addHeaderRefresh(callBack: (()->Void)?) {
        
        let header = RefreshHeaderTool.refreshWithHeader(scrollView: self, callBack: callBack)
        
        objc_setAssociatedObject(self, &kScrollViewHeaderViewKey, header, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        self.addObserver(header, forKeyPath: "contentOffset", options: .new, context: nil)
        self.addSubview(header)
    }
    
    //MARK: -开始刷新
    /// 开始刷新
    func headerBeginRefreshing() {
        
        let header = objc_getAssociatedObject(self, &kScrollViewHeaderViewKey)
        if let header = header as? RefreshGifHeaderTool {
            header.beginRefreshing()
        } else if let header = header as? RefreshHeaderTool {
            header.beginRefreshing()
        }
    }
    //MARK: -结束刷新
    /// 结束刷新
    func headerEndRefreshing() {
        
        let header = objc_getAssociatedObject(self, &kScrollViewHeaderViewKey)
        if let header = header as? RefreshGifHeaderTool {
            header.endRefreshing()
        } else if let header = header as? RefreshHeaderTool {
            header.endRefreshing()
        }
    }
    
    // ================== 尾部刷新控件 ==================
    
    //MARK: -添加Gif尾部刷新控件
    /// 添加Gif尾部刷新控件
    func addGifFooterRefresh(callBack: (()->Void)?) {
        
        let footer = RefreshGifFooterTool.refreshWithFooter(scrollView: self, callBack: callBack)
        
        objc_setAssociatedObject(self, &kScrollViewFooterViewKey, footer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        self.addObserver(footer, forKeyPath: "contentOffset", options: .new, context: nil)

        self.addSubview(footer)
    }
    //MARK: -添加普通尾部刷新控件
    /// 添加普通尾部刷新控件
    func addFooterRefresh(callBack: (()->Void)?) {
        
        let footer = RefreshFooterTool.refreshWithFooter(scrollView: self, callBack: callBack)
        
        objc_setAssociatedObject(self, &kScrollViewFooterViewKey, footer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        self.addObserver(footer, forKeyPath: "contentOffset", options: .new, context: nil)
        
        self.addSubview(footer)
    }
    
    //MARK: -展示无数据
    /// 展示无数据
    func footerEndRefrshWithNoData() {
     
        let footer = objc_getAssociatedObject(self, &kScrollViewFooterViewKey)
        if let footer = footer as? RefreshGifFooterTool {
            footer.endRefrshWithNoData()
        } else if let footer = footer as? RefreshFooterTool {
            footer.endRefrshWithNoData()
        }
    }
    //MARK: -重设无数据样式,进入待刷新状态
    /// 重设无数据样式,进入待刷新状态
    func footerResetNoDataState() {
        
        let footer = objc_getAssociatedObject(self, &kScrollViewFooterViewKey)
        if let footer = footer as? RefreshGifFooterTool {
            footer.resetNoDataState()
        } else if let footer = footer as? RefreshFooterTool {
            footer.resetNoDataState()
        }
    }
    
    // ================== 占位图 ==================
    /// 占位文字
    var placholderText: String? {
        get {
            return objc_getAssociatedObject(self, &UIScrollViewPlacholderTextKey
                ) as? String
        }
        set {
            objc_setAssociatedObject(self, &UIScrollViewPlacholderTextKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    /// 占位图
    var placholderImg: String? {
        get {
            return objc_getAssociatedObject(self, &UIScrollViewPlacholderImgKey
                ) as? String
        }
        set {
            objc_setAssociatedObject(self, &UIScrollViewPlacholderImgKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    /// 刷新数据 展示无数据占位图
    func k_reloadData(callBack: (()->Void)? = nil) {
        
        var count: Int = 0
        if self.isKind(of: UITableView.self) {

            let tab = self as! UITableView
            tab.reloadData()
            count = tab.numberOfRows(inSection: 0)
            
        } else if self.isKind(of: UICollectionView.self) {
            
            let col = self as! UICollectionView
            col.reloadData()
            count = col.numberOfItems(inSection: 0)
        }
        // 结束头部刷新
        self.headerEndRefreshing()
        // 结束尾部刷新
        let footer = objc_getAssociatedObject(self, &kScrollViewFooterViewKey) as? RefreshGifFooterTool
        if let footer = footer, footer.footerState != .noData {
            self.footerResetNoDataState()
        }
        
        if count == 0 {
            
            // 无数据
            let view = PlaceHolderView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: self.bounds.width, height: self.bounds.height))
            view.clickCallBack = callBack
            view.tag = 101
            view.textL.text = self.placholderText ?? "暂无数据哦~"
            view.imgV.image = UIImage.init(named: self.placholderImg ?? "noData")
            self.addSubview(view)
            
        } else {
            
            // 有数据了
            if let view = self.viewWithTag(101) {
                
                view.removeFromSuperview()
            }
        }
    }
}

class PlaceHolderView: UIView {

    /// 点击回调
    var clickCallBack: (()->Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.imgV)
        self.addSubview(self.textL)
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
        self.addGestureRecognizer(tap)
    }
    
    @objc func tapAction() {
        
        self.clickCallBack?()
    }
    
    lazy var imgV: UIImageView = {
        let width: CGFloat = 80.0
        let imgV = UIImageView.init(frame: CGRect.init(x: (kWidth - width) / 2.0, y: self.textL.frame.minY - width, width: width, height: width))
        imgV.contentMode = .scaleAspectFit
        
        return imgV
    }()
    
    lazy var textL: UILabel = {
        let label = UILabel.init(frame: CGRect.init(x: 0.0, y: (self.frame.height - 40.0) / 2.0, width: self.frame.width, height: 40.0))
        label.textAlignment = .center
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 14.0)
        
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
