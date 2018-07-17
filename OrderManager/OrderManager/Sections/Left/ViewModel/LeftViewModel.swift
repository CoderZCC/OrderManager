//
//  LeftViewModel.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/16.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class LeftViewModel: NSObject {

    var collectionView: UICollectionView!
    
    convenience init(collectionView: UICollectionView) {
        self.init()

        self.collectionView = collectionView
    }
    
    /// 获取单元格大小
    ///
    /// - Parameters:
    ///   - columnsNum: 列数
    ///   - lineSpace: 列间隔
    /// - Returns: 大小
    func getItemWidth(columnsNum: Int) -> CGFloat {
        
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let lineSpace = layout.minimumLineSpacing
        let leftMargin = self.collectionView.contentInset.left
        let rightMargin = self.collectionView.contentInset.left
        
        return (kSliderMaxWidth - lineSpace * (CGFloat(columnsNum) - 1.0) - leftMargin - rightMargin) / CGFloat(columnsNum)
    }
    
}
