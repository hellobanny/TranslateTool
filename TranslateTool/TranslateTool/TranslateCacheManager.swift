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
        let predicate = NSPredicate(format: "(text = %@) AND (lang = %@)", text,lang.getShortName())
        if let cache = Translate.mr_findFirst(with: predicate ,in:NSManagedObjectContext.mr_default()){
            if let dt = cache.time as? Date {
                if Date().timeIntervalSince(dt) < CacheTimeOut {
                    return cache.translate
                }
            }
        }
        return nil
    }
    
    @discardableResult open func cache(text:String,lang:Language,trans:String) -> Translate? {
        let cc = NSManagedObjectContext.mr_default()
        let predicate = NSPredicate(format: "(text = %@) AND (lang = %@)", text,lang.getShortName())
        if let cache = Translate.mr_findFirst(with: predicate, in: cc){
            cache.translate = trans
            cache.time = NSDate()
            cc.mr_saveToPersistentStoreAndWait()
        }
        else if let tr = Translate.mr_createEntity(in: cc){
            tr.text = text
            tr.lang = lang.getShortName()
            tr.translate = trans
            tr.time = NSDate()
            cc.mr_saveToPersistentStoreAndWait()
            return tr
        }
        return nil
    }
}
