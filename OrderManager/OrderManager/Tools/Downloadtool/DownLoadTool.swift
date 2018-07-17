//
//  DownLoadTool.swift
//  CVolleyballAssociation
//
//  Created by 张崇超 on 2017/12/19.
//  Copyright © 2017年 Zebra. All rights reserved.
//

import UIKit
import Alamofire

enum DownloadResult {
    case finish, noFinish, noDownload
    case success, fail, cancle
}

/// 缓存列表plist文件位置
let kcachesListPath: String = NSHomeDirectory() + "/Documents/downloadFile/cachesData.plist"

/// 文件下载位置
let kDownloadFile: String = NSHomeDirectory() + "/Documents/downloadFile/"

class DownLoadTool: NSObject {

    /// 下载任务
    private var downloadRequest: DownloadRequest!
    /// 文件名称
    private var fileName: String!
    /// 下载进度
    private var progress: Progress!
    /// 下载地址
    private var downloadUrl: String!
    /// 下载完成时赋值的元组
    var finishTuple: (result:DownloadResult, savePath:String?, resumeData:Data?, progress:String?, progressNum:Float?)!
    
    //MARK: -开始下载
    @discardableResult
    class func download(downloadUrl: String) -> DownLoadTool {
        
        let tool = DownLoadTool()
        tool.downloadUrl = downloadUrl
        
        /// 文件下载地址
        let destination:DownloadRequest.DownloadFileDestination! = { _, response in
            
            let suggestedFilename = response.suggestedFilename!
            let fileType = suggestedFilename.components(separatedBy: ".").last ?? ".png"
            let fileName = Date().k_toDateStr("yyyyMMddHHmmss") + ".\(fileType)"
            // 文件下载地址
            let fileURL = URL.init(fileURLWithPath: kDownloadFile.appendingFormat("%@/",fileName))
            // 文件名称
            tool.fileName = "\(fileName)"
            
            return (fileURL, [.createIntermediateDirectories, .removePreviousFile])
        }
        
        let tuple = DownLoadTool.getDownloadResult(downloadUrl: downloadUrl)
        if tuple.result == DownloadResult.noFinish {
            
            /// 继续下载
            tool.downloadRequest = Alamofire.download(resumingWith: tuple.resumeData!, to: destination)
            
        } else if tuple.result == DownloadResult.noDownload {
            
            /// 下载任务
            tool.downloadRequest = Alamofire.download(downloadUrl, to: destination)
            
        } else {
            
            tool.finishTuple = tuple
            print("已缓存完成:\(tuple.savePath!)")
        }
        return tool
    }
    
    @discardableResult
    func downloadProgress(progress:((CGFloat)->Void)?) -> DownLoadTool {
        
        if let downloadRequest = self.downloadRequest {
            
            downloadRequest.downloadProgress { (data) in
                
                self.progress = data
                progress?(CGFloat(data.fractionCompleted))
                print("当前进度：\(data.fractionCompleted)")
            }
            
        } else {
         
            progress?(CGFloat(1.0))
        }
        return self
    }
    
    @discardableResult
    func downloadResult(result:((DownloadResult, String?)->Void)?) -> DownLoadTool {
    
        if self.downloadRequest == nil {
            
            result?(DownloadResult.success, self.finishTuple.savePath)
            return self
        }
        self.downloadRequest.responseData { (data) in
         
            let response:DownloadResponse = data
            
            switch response.result {
            case .success(_):
                
                let url = "\(response.destinationURL!)"
                print("下载完成:\(url)")
                result?(DownloadResult.success, url.replacingOccurrences(of: "file://", with: ""))
                
            case .failure(let error):
                
                if error.localizedDescription.contains("cancelled") {
                 
                    print("下载取消")
                    result?(DownloadResult.cancle, nil)
  
                } else {
                    
                    print("下载失败:\(error)")
                    result?(DownloadResult.fail, nil)
                }
            }

            var dic = NSMutableDictionary.init()
            if let cachesAllDic = DownLoadTool.getCachesData() {
                
                // 所有缓存
                dic = cachesAllDic
            }
            var newDict = NSMutableDictionary.init()
            if let cachesDic: NSMutableDictionary = dic[self.downloadUrl!] as? NSMutableDictionary {
                
                // 当前任务缓存
                newDict = cachesDic
            }

            if let _ = response.destinationURL {
                
                // 已下载完
                newDict.setObject(self.fileName! as Any, forKey: "downloadPath" as NSCopying)
                
            } else {
                
                // MB单位 Progress
                let allSize:CGFloat = CGFloat(self.progress.totalUnitCount) / 1000.0 / 1000.0
                let downloadSize:CGFloat = CGFloat(self.progress.completedUnitCount) / 1000.0 / 1000.0
                // 未下载大小
                let noDownloadSizeStr = String.init(format: "%.2fMB", allSize - downloadSize)
                // 进度条进度
                let progressHUDNum = "\(Float(self.progress.fractionCompleted))"
                
                // 未下载完
                newDict.setObject(progressHUDNum as Any, forKey: "progressNum" as NSCopying)
                newDict.setObject(noDownloadSizeStr as Any, forKey: "progress" as NSCopying)
                newDict.setObject(response.resumeData as Any, forKey: "resumeData" as NSCopying)
            }
            dic.setObject(newDict as Any, forKey: self.downloadUrl! as NSCopying)
            let isSave = dic.write(toFile: kcachesListPath, atomically: true)
            print("下载plist保存结果:\(isSave)")
        }
        return self
    }
    
    @discardableResult
    func downloadCancle() -> DownLoadTool {
        
        self.downloadRequest.cancel()
        return self
    }
}

extension DownLoadTool {
    
    static func getCachesData() -> NSMutableDictionary? {
        
        let dic = NSMutableDictionary.init(contentsOfFile: kcachesListPath)
        if let dic = dic {
            
            return dic
        }
        return nil
    }
    
    static func getDownloadResult(downloadUrl:String) -> (result:DownloadResult, savePath:String?, resumeData:Data?, progress:String?, progressNum:Float?) {
        
        // 所有已经下载内容
        if let cachesAllDic = self.getCachesData() {
            
            if let cachesDic:NSMutableDictionary = cachesAllDic[downloadUrl] as? NSMutableDictionary {
                
                if let savePath:String = cachesDic.object(forKey: "downloadPath") as? String {
                    
                    // 下载完成
                    return (DownloadResult.finish, kDownloadFile + savePath, nil, nil, nil)
                    
                } else {
                    
                    // 未下载完
                    if let data:Data = cachesDic.object(forKey: "resumeData") as? Data {
                        
                        var progress:String = "0.00MB"
                        if let progressData:String = cachesDic.object(forKey: "progress") as? String {
                            
                            progress = progressData
                        }
                        let num = cachesDic.object(forKey: "progressNum") as! String
                        return (DownloadResult.noFinish, nil, data, progress, Float.init(num))
                        
                    } else {
                        
                        // 数据异常
                        return (DownloadResult.noDownload, nil, nil, nil, nil)
                    }
                }
                
            } else {
                
                // 未下载过
                return (DownloadResult.noDownload, nil, nil, nil, nil)
            }
            
        } else {
            
            // 未下载过
            return (DownloadResult.noDownload, nil, nil, nil, nil)
        }
    }
    
}

