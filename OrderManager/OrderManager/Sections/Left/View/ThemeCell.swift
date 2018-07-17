//
//  ThemeCell.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/17.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

class ThemeCell: UICollectionViewCell {

    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var textL: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    var callBack: (()->Void)?
    
    var themeModel: ThemeModel! {
        willSet {
            
            self.imgV.k_setImage(url: newValue.themeImgUrl)
            
            if newValue.isUse {
                
                self.textL.text = "当前使用"
                self.textL.textColor = UIColor.green
                
            } else {
                
                self.textL.textColor = UIColor.white
                self.textL.text = (newValue.cachesPath == nil) ? ("立即下载"): ("立即使用")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imgV.k_setCornerRadius(4.0)
        self.textL.k_setCornerRadius(3.0)
        self.textL.k_setBorder(color: UIColor.lightGray, width: 1.0)
        
        self.bottomView.k_addTarget { [unowned self] (tap) in
            
           self.downloadFile()
        }
        self.textL.layer.addSublayer(self.progressLayer)
    }

    func downloadFile() {
        
        if let path = self.themeModel.cachesPath {
            
            self.setTheme(path: path)
            return
        }
        DownLoadTool.download(downloadUrl: self.themeModel.themeImgUrl).downloadProgress(progress: { (progress) in
            
            var newFrmae = self.progressLayer.frame
            newFrmae.size.width = self.textL.bounds.width * progress
            
            self.progressLayer.frame = newFrmae
            self.textL.text = "正在下载"

        }).downloadResult(result: { (result, path) in

            if result == .success {
                
                self.setTheme(path: path!)
            }
        })
    }
    
    func setTheme(path: String) {
        
        self.textL.text = "当前使用"
        let imgData: Data = try! Data.init(contentsOf: URL.init(fileURLWithPath: path))
        
        // 保存到本地 主题数据
        let isOk = kSaveDataTool.k_save(data: [self.themeModel.themeId: imgData], to: kThemeSavePath)
        if isOk {
            
            NotificationCenter.default.post(name: NSNotification.Name.init(kThemeChangeNoteKey), object: nil)
            self.callBack?() 
        }
    }
    
    lazy var progressLayer: CAShapeLayer = {
        let layer = CAShapeLayer.init()
        layer.backgroundColor = UIColor.white.withAlphaComponent(0.5).cgColor
        layer.frame = CGRect.init(x: 0.0, y: 0.0, width: 0.0, height: self.textL.bounds.height)
        
        return layer
    }()
    
}
