//
//  TranslateManager.swift
//  TranslateTool
//
//  Created by 张忠 on 16/10/17.
//  Copyright © 2016年 Banny. All rights reserved.
//

import UIKit
import Zip

let GoogleAPIKey = ""
let GoogleTranslateURL = "https://www.googleapis.com/language/translate/v2"
let FinalFileName = "Archive.zip"

let OneTranslateDone = Notification.Name("OneTranslateDone")
let AllTranslateDone = Notification.Name("AllTranslateDone")

private let instance = TranslateManager()

class TranslateManager: NSObject {
    
    var sourceURL:URL?
    var sourceLang:Language?
    var targetLangs = [Language]()
    var lock = NSLock()
    
    var allTranslateItems = [TranslateItem]()
    var translateCount = 0
    var needTranslateOnline = 0
    
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
        var textCount = 0
        for lan in targetLangs {
            for need in sources {
                let trans = TranslateItem(trans: need, from: sLan, to: lan)
                if let str = tcm.getCached(text: trans.translate.text, lang: trans.toLang){
                    trans.result = str
                }
                else {
                    count += 1
                    textCount += need.text.characters.count
                }
                allTranslateItems.append(trans)
            }
        }
        print("Total need translate is \(textCount)")
        if textCount > 10000 {
            return false
        }
        //获取翻译
        translateCount = count
        needTranslateOnline = count
        NotificationCenter.default.addObserver(self, selector: #selector(TranslateManager.oneTranslateDone), name: OneTranslateDone, object: nil)
        if translateCount > 0 {
            for trans in allTranslateItems {
                trans.startQuery()
            }
        }
        else {
            oneTranslateDone()
        }
        
        return true
    }
    
    func oneTranslateDone(){
        lock.lock()
        translateCount -= 1
        if translateCount <= 0 {//全部完成了
            NotificationCenter.default.removeObserver(self, name: OneTranslateDone, object: nil)
            if let url = self.writeToFilesAndZipped() {
                NotificationCenter.default.post(name: AllTranslateDone, object: url)
            }
        }
        lock.unlock()
    }
    
    func getProcesss() -> Float {
        return Float(needTranslateOnline - translateCount)/Float(needTranslateOnline)
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
        var groupedDic:[Language:NSMutableArray] = Dictionary()
        for item in allTranslateItems {
            let key = item.toLang
            if let array = groupedDic[key] {
                array.add(item)
            }
            else {
                let arr = NSMutableArray()
                arr.add(item)
                groupedDic[key] = arr
            }
        }
        
        do {
            try fm.createDirectory(atPath: folder, withIntermediateDirectories: true, attributes: nil)
            for lang in targetLangs {
                let projPath = folder + "/" + lang.getFolderName()
                try fm.createDirectory(atPath: projPath, withIntermediateDirectories: true, attributes: nil)
                if let sameLangItems = groupedDic[lang] {
                    sameLangItems.sort(comparator: { (i1, i2) -> ComparisonResult in
                        let p1 = i1 as! TranslateItem
                        let p2 = i2 as! TranslateItem
                        return p1.translate.key.compare(p2.translate.key)
                    })
                    let fileName = projPath.appending("/Localizable.strings")
                    let result = NSMutableString()
                    for item in sameLangItems {
                        let it = item as! TranslateItem
                        result.append(it.getFinalResult())
                    }
                    try result.write(toFile: fileName, atomically: true, encoding: String.Encoding.utf8.rawValue)
                    //print(result)
                }
                
            }
            //打包
            let zipFilePath = path.appending("/\(FinalFileName)")
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
