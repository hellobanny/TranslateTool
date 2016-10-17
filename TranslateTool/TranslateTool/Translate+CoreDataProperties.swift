//
//  Translate+CoreDataProperties.swift
//  TranslateTool
//
//  Created by 张忠 on 16/10/17.
//  Copyright © 2016年 Banny. All rights reserved.
//

import Foundation
import CoreData


extension Translate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Translate> {
        return NSFetchRequest<Translate>(entityName: "Translate");
    }

    @NSManaged public var text: String?
    @NSManaged public var lang: String?
    @NSManaged public var translate: String?
    @NSManaged public var time: NSDate?

}
