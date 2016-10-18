//
//  TranslateManager.swift
//  TranslateTool
//
//  Created by 张忠 on 16/10/17.
//  Copyright © 2016年 Banny. All rights reserved.
//

import UIKit
import Zip

private let instance = TranslateManager()

let TranslateDone = Notification.Name("TranslateDone")
let ZipFileDown = Notification.Name("ZipFileDown")

class TranslateManager: NSObject {
    
    var sourceURL:URL?
    var sourceLang:Language?
    var targetLangs = [Language]()
    var lock = NSLock()
    
    var allTranslateItems = [TranslateItem]()
    var translateCount = 0
    
    class func sharedInstance() -> TranslateManager {
        return instance
    }
    
    func startTranslate() -> Bool {
        //读取文件
        let sources = parseSourceStringsFile()
        if sources.count == 0 {
            return false
        }
        guard let sLan = sourceLang else {
            return false
        }
        
        let tcm = TranslateCacheManager.sharedInstance()
        allTranslateItems.removeAll()
        
        var count = 0
        
        for lan in targetLangs {
            for need in sources {
                let trans = TranslateItem(trans: need, from: sLan, to: lan)
                if let str = tcm.getCached(text: trans.translate.text, lang: trans.toLang){
                    trans.result = str
                }
                else {
                    count += 1
                }
                allTranslateItems.append(trans)
            }
        }
        //获取翻译
        translateCount = count
        NotificationCenter.default.addObserver(self, selector: #selector(TranslateManager.oneDone), name: TranslateDone, object: nil)
        if translateCount > 0 {
            for trans in allTranslateItems {
                trans.startQuery()
            }
        }
        else {
            oneDone()
        }
        
        return true
    }
    
    func oneDone(){
        lock.lock()
        translateCount -= 1
        if translateCount <= 0 {//全部完成了
            NotificationCenter.default.removeObserver(self, name: TranslateDone, object: nil)
            if let url = self.writeToFilesAndZipped() {
                NotificationCenter.default.post(name: ZipFileDown, object: url)
            }
        }
        lock.unlock()
    }
    
    //输出到文件，文件夹，打包压缩，返回URL
    func writeToFilesAndZipped() -> URL? {
        let path = NSTemporaryDirectory()
        let folder = path.appending("files")
        let fm = FileManager.default
        
        //删除旧文件
        if fm.fileExists(atPath: folder) {
            do {
                try fm.removeItem(atPath: folder)
            }
            catch(_) {
            }
        }
        //输入到新文件
        var dic:[Language:NSMutableArray] = Dictionary()
        for item in allTranslateItems {
            let key = item.toLang
            if let array = dic[key] {
                array.add(item)
            }
            else {
                let arr = NSMutableArray()
                arr.add(item)
                dic[key] = arr
            }
        }
        
        do {
            try fm.createDirectory(atPath: folder, withIntermediateDirectories: true, attributes: nil)
            for lang in targetLangs {
                let proj = folder + "/" + lang.getFolderName()
                try fm.createDirectory(atPath: proj, withIntermediateDirectories: true, attributes: nil)
                if let array = dic[lang] {
                    array.sort(comparator: { (i1, i2) -> ComparisonResult in
                        let p1 = i1 as! TranslateItem
                        let p2 = i2 as! TranslateItem
                        return p1.translate.key.compare(p2.translate.key)
                    })
                    let fileName = proj.appending("/Localizable.strings")
                    let result = NSMutableString()
                    for item in array {
                        let it = item as! TranslateItem
                        result.append(it.getFinalResult())
                    }
                    try result.write(toFile: fileName, atomically: true, encoding: String.Encoding.utf8.rawValue)
                    print(result)
                }
                
            }
            let zipFilePath = path.appending("/archive.zip")
            let zipFileUrl = URL(fileURLWithPath:zipFilePath)
            try Zip.zipFiles(paths: [URL(fileURLWithPath:folder)], zipFilePath: zipFileUrl, password: nil, progress: nil)
            return zipFileUrl
        }
        catch (_){
        }
        //压缩
        return nil
    }
    
    func parseSourceStringsFile() -> [NeedTranslate]{
        var array = [NeedTranslate]()
        
        if let dic = NSDictionary(contentsOf: self.sourceURL!) {
            for (key,value) in dic {
                let trans = NeedTranslate(text: value as! String, key: key as! String, comment: "")
                    array.append(trans)
            }
        }
        
        return array
    }
    
    func getDetailInfo() -> String {
        var str = ""
        for lan in targetLangs {
            str.append("\(lan.getFullName()), ")
        }
        return "Translate from \(sourceLang!.getFullName()) to \(str)"
    }
}
