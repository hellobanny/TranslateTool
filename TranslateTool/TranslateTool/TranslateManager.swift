//
//  TranslateManager.swift
//  TranslateTool
//
//  Created by 张忠 on 16/10/17.
//  Copyright © 2016年 Banny. All rights reserved.
//

import UIKit

private let instance = TranslateManager()

class TranslateManager: NSObject {
    
    var sourceURL:URL?
    var sourceLang:Language?
    var targetLangs = [Language]()
    
    class func sharedInstance() -> TranslateManager {
        return instance
    }
    
    func startTranslate() -> Bool {
        
    
        return true
    }
}
