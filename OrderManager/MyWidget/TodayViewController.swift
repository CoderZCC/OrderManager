//
//  TodayViewController.swift
//  MyWidget
//
//  Created by 张崇超 on 2018/7/23.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreMotion

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var timeL: UILabel!
    
    var timer: Timer?
    let snowEmitter: CAEmitterLayer = CAEmitterLayer.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.countTime()
    }
    
    func changeStrToDate(timeStr: String, formatter: String) -> Date {
        let fat = DateFormatter.init()
        fat.dateFormat = formatter
        var date = fat.date(from: timeStr)
        // 会少8个小时
        date != nil ? (date!.addTimeInterval(60.0 * 60.0 * 8.0)) : (print("时间格式不对应:k_toDate"))
        
        return date ?? Date()
    }
    
    func countTime() {
        
        let myDate = self.changeStrToDate(timeStr: "2018 01-27", formatter: "yyyy MM-dd")
        let nowDate = Date().addingTimeInterval(60.0 * 60.0 * 8.0)
        
        let allDuration = abs(myDate.timeIntervalSince(nowDate))
        let dayHour = (60.0 * 60.0 * 24.0)
        let day: Int = Int(allDuration / dayHour)
        
        let hourDuration = (allDuration - Double(day) * dayHour)
        let hour: Int = Int(hourDuration / (60.0 * 60.0))
        
        let minuDuration = (hourDuration - Double(hour) * (60.0 * 60.0))
        let minu: Int = Int(minuDuration / 60.0)
        
        let secondDuration = (minuDuration - Double(minu) * 60.0)
        let second: Int = Int(secondDuration)
        
        self.timeL.text = "\(day)天\(hour)时\(minu)分\(second)秒"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.timer == nil {
            
            let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
                
                self.countTime()
            })
            self.timer = timer
            
        } else {
            
            self.countTime()
        }
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded        
        self.snowAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.timer?.invalidate()
        self.timer = nil
     
        self.snowEmitter.removeFromSuperlayer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        
        if activeDisplayMode == .compact {
            
            self.preferredContentSize = CGSize.init(width: self.view.frame.width, height: 110.0)
            
        } else {
            
            self.preferredContentSize = CGSize.init(width: self.view.frame.width, height: 200.0)
        }
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
       
        completionHandler(NCUpdateResult.newData)
    }
}

extension TodayViewController {
    
    /// 雪花效果
    func snowAnimation() {
        
        let cell = CAEmitterCell.init()
        cell.contents = UIImage.init(named: "snow")?.cgImage
        cell.birthRate = 3
        cell.lifetime = 10.0
        // 初速度
        cell.velocity = 20
        cell.velocityRange = 5
        cell.yAcceleration = 2
        cell.scale = 0.4
        // 粒子初始发射方向
        cell.emissionLongitude = CGFloat.pi
        cell.alphaSpeed = -0.1
        
        snowEmitter.position = CGPoint.init(x: self.view.frame.width / 2.0, y: 0.0)
        snowEmitter.emitterSize = CGSize.init(width: self.view.frame.width, height: 0.0)
        snowEmitter.emitterShape = CAEmitterLayerEmitterShape.line
        snowEmitter.emitterMode = CAEmitterLayerEmitterMode.outline
        
        snowEmitter.emitterCells = [cell]
        self.view.layer.addSublayer(snowEmitter)
    }
}

