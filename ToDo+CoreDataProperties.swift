//
//  ToDo+CoreDataProperties.swift
//  CoreData.FromNowOn
//
//  Created by togashi yoshiki on 2018/02/21.
//  Copyright © 2018年 togashi yoshiki. All rights reserved.
//
//

import Foundation
import CoreData


extension ToDo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDo> {
        return NSFetchRequest<ToDo>(entityName: "ToDo")
    }

    @NSManaged public var todotitle: String?
    @NSManaged public var tododeta: NSDate?

}
