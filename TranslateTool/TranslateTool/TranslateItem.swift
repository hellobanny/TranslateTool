//
//  TranslateItem.swift
//  TranslateTool
//
//  Created by 张忠 on 16/10/17.
//  Copyright © 2016年 Banny. All rights reserved.
//

import UIKit
import SwiftyJSON

struct NeedTranslate {
    var text:String
    var key:String
    var comment:String
}

class TranslateItem: NSObject {
    
    var translate:NeedTranslate
    
    var fromLang:Language
    var toLang:Language
    var result:String?
    
    func isDone() -> Bool {
        return result != nil
    }
    
    init(trans:NeedTranslate,from:Language,to:Language) {
        translate = trans
        fromLang = from
        toLang = to
        super.init()
    }
    
    func startQuery(){
        if result != nil {
            return
        }
        let qStr = NSString(string: translate.text).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)
        let queryUrl = "\(GoogleTranslateURL)?key=\(GoogleAPIKey)&q=\(qStr!)&source=\(fromLang.getShortName())&target=\(toLang.getShortName())"
        
        func actionOfFaile() {
            //失败了
            result = "#Error#" + translate.text
            NotificationCenter.default.post(name: OneTranslateDone, object: self)
        }
        
        if let url = URL(string: queryUrl) {
            let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if let dt = data {
                    let json = JSON(data: dt)
                    if let str = json["data"]["translations"][0]["translatedText"].string{
                        //成功了
                        self.result = str
                        TranslateCacheManager.sharedInstance().cache(text: self.translate.text, lang: self.toLang, trans: str)
                        NotificationCenter.default.post(name: OneTranslateDone, object: self)
                        //print(self.getFinalResult())
                        return
                    }
                }
                actionOfFaile()
            })
            task.resume()
            return
        }
        actionOfFaile()
    }
    
    
    func getFinalResult() -> String {
        return translate.comment + "\n\"" + translate.key + "\" = \"" + result! + "\";\n"
    }
}
