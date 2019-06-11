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
    let yanhuaEmitter: CAEmitterLayer = CAEmitterLayer.init()
    let yanhuaImg = UIImage(named: "fire.png")?.cgImage
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.countTime()
        if self.timer == nil {
            
            let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
                
                self.countTime()
            })
            self.timer = timer
        }
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        self.snowAnimation()
        self.createYanhua()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.timer?.invalidate()
        self.timer = nil
        
        self.snowEmitter.removeFromSuperlayer()
        self.yanhuaEmitter.removeFromSuperlayer()
    }
    
    func countTime() {
        let myDate = fat.date(from: "2018 01-27")!.addingTimeInterval(60.0 * 60.0 * 8.0)
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
    
    lazy var fat: DateFormatter = {
        let fat = DateFormatter.init()
        fat.dateFormat = "yyyy MM-dd"
        return fat
    }()
    
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
        cell.scale = 0.2
        // 粒子初始发射方向
        cell.emissionLongitude = CGFloat.pi
        cell.alphaSpeed = -0.1
        cell.spin = CGFloat.pi
        
        snowEmitter.position = CGPoint.init(x: self.view.frame.width / 2.0, y: 0.0)
        snowEmitter.emitterSize = CGSize.init(width: self.view.frame.width, height: 0.0)
        snowEmitter.emitterShape = CAEmitterLayerEmitterShape.line
        snowEmitter.emitterMode = CAEmitterLayerEmitterMode.outline
        
        snowEmitter.emitterCells = [cell]
        self.view.layer.addSublayer(snowEmitter)
    }
}

extension TodayViewController {
    
    private func createYanhua() {
        
        //发射器中心点
        yanhuaEmitter.emitterPosition = CGPoint(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height)
        
        //发射器尺寸
        yanhuaEmitter.emitterSize = CGSize(width: 50, height: 0.0)
        
        //发射器发射模式
        yanhuaEmitter.emitterMode = CAEmitterLayerEmitterMode.outline
        
        //发射器形状
        yanhuaEmitter.emitterShape = CAEmitterLayerEmitterShape.line
        
        //发射器粒子渲染效果
        yanhuaEmitter.renderMode = CAEmitterLayerRenderMode.additive
        
        //创建烟花子弹
        let bullet = CAEmitterCell()
        
        //子弹诞生速度,每秒诞生个数
        bullet.birthRate = 0.6
        
        //子弹的停留时间,即多少秒后消失
        bullet.lifetime = 1.3
        
        //子弹的样式,可以给图片
        bullet.contents = yanhuaImg
        bullet.scale = 0.3
        
        //子弹的发射弧度
        bullet.emissionRange = 0.15 * CGFloat.pi
        
        //子弹的速度
        bullet.velocity = 180
        //随机速度范围
        bullet.velocityRange = 10
        //y轴加速度
        bullet.yAcceleration = 0
        //自转角速度
        bullet.spin = CGFloat.pi * 2.0
        
        //三种随机色
        bullet.redRange = 1.0
        bullet.greenRange = 1.0
        bullet.blueRange = 1.0
        
        //开始爆炸
        let burst = CAEmitterCell()
        //属性同上
        burst.birthRate = 1.0
        burst.velocity = 0;
        burst.scale     = 2.5;
        burst.redSpeed = -1.5;        // shifting
        burst.blueSpeed = 1.5;        // shifting
        burst.greenSpeed = 1.0;        // shifting
        burst.lifetime = 0.35;
        
        //爆炸后的烟花
        let spark = CAEmitterCell()
        //属性设置同上
        spark.birthRate = 400
        spark.lifetime = 3
        spark.velocity = 125
        spark.velocityRange = 100
        spark.emissionRange = 2 * CGFloat.pi
        
        spark.contents = yanhuaImg
        spark.scale = 0.2
        spark.scaleRange = 0.05
        
        spark.greenSpeed        = -0.1;
        spark.redSpeed            = 0.4;
        spark.blueSpeed            = -0.1;
        spark.alphaSpeed        = -0.5;
        spark.spin                = 2 * CGFloat.pi
        spark.spinRange            = 2 * CGFloat.pi
        
        //这里是重点,先将子弹添加给发射器
        yanhuaEmitter.emitterCells = [bullet]
        
        //子弹发射后,将爆炸cell添加给子弹cell
        bullet.emitterCells = [burst]
        
        //将烟花cell添加给爆炸效果cell
        burst.emitterCells = [spark]
        
        //最后将发射器附加到主视图的layer上
        self.view.layer.addSublayer(yanhuaEmitter)
        
    }
    
    private func setUp() {
        let viewBounds = self.view.layer.bounds
        
        let snowEmitter = CAEmitterLayer()
        snowEmitter.emitterPosition = CGPoint(x: viewBounds.size.width / 2.0 , y: 200)
        snowEmitter.emitterSize = CGSize(width: 1, height: 0)
        snowEmitter.emitterMode = CAEmitterLayerEmitterMode.outline
        snowEmitter.emitterShape = CAEmitterLayerEmitterShape.line;
        snowEmitter.backgroundColor = UIColor.orange.cgColor
        
        self.view.layer.addSublayer(snowEmitter)
        
        // Configure the snowflake yanhuaEmitter cell
        let snowflake = CAEmitterCell()
        
        // 随机颗粒的大小
        snowflake.scale = 0.5;
        snowflake.scaleRange = 0.1;
        
        // 粒子参数的速度乘数因子；
        snowflake.birthRate        = 10.0;
        
        // 生命周期
        snowflake.lifetime        = 60.0;
        
        // 粒子速度
        snowflake.velocity        = 30;                // falling down slowly
        snowflake.velocityRange = 10;
        // 粒子y方向的加速度分量
        snowflake.yAcceleration = -20;
        
        // 周围发射角度
        snowflake.emissionRange = CGFloat.pi        // some variation in angle
        snowflake.emissionLongitude = CGFloat.pi
        // 自动旋转
        snowflake.spinRange        = CGFloat.pi;        // slow spin
        
        snowflake.contents        =  yanhuaImg
        snowEmitter.emitterCells = [snowflake]
    }
    
//    //将颜色转为图片
//    private func imageWithColor(_ color: UIColor) -> UIImage {
//
//        let rect = CGRect(x: 0.0, y: 0.0, width: 5.0, height: 5.0)
//        UIGraphicsBeginImageContext(rect.size)
//        let context = UIGraphicsGetCurrentContext()
//        context!.setFillColor(color.cgColor)
//        context!.fill(rect)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        return image!
//    }
}
