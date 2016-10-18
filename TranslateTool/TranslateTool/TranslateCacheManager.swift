//
//  TranslateCacheManager.swift
//  TranslateTool
//
//  Created by 张忠 on 16/10/17.
//  Copyright © 2016年 Banny. All rights reserved.
//

import UIKit
import MagicalRecord

private let instance = TranslateCacheManager()
private let CacheTimeOut:Double = 365*24*3600

class TranslateCacheManager: NSObject {
    
    class func sharedInstance() -> TranslateCacheManager {
        return instance
    }
    
    override init() {
        if NSPersistentStoreCoordinator.mr_default() == nil {
            MagicalRecord.setupCoreDataStack(withStoreNamed: "LocalDB.xcdatamodeld")
        }
    }
    
    func printAllCache() {
        if let array = Translate.mr_findAll() as? [Translate] {
            for ts in array {
                print(ts.text)
                print(ts.lang)
                print(ts.translate)
            }
        }
    }
    
    open func getCached(text:String,lang:Language) -> String? {
        if let cache = Translate.mr_findFirst(with: NSPredicate(format: "text = \"%@\" and lang = \"%@\"", text,lang.getShortName())){
            if let dt = cache.time as? Date {
                if Date().timeIntervalSince(dt) < CacheTimeOut {
                    return cache.translate
                }
            }
        }
        return nil
    }
    
    @discardableResult open func cache(text:String,lang:Language,trans:String) -> Translate? {
        if let cache = Translate.mr_findFirst(with: NSPredicate(format: "text = \"%@\" and lang = \"%@\"", text,lang.getShortName())){
            cache.translate = trans
            cache.time = NSDate()
            NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
        }
        else if let tr = Translate.mr_createEntity() {
            tr.text = text
            tr.lang = lang.getShortName()
            tr.translate = trans
            tr.time = NSDate()
            NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
            return tr
        }
        return nil
    }
}
