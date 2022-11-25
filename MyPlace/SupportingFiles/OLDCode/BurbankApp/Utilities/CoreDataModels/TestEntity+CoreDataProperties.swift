//
//  TestEntity+CoreDataProperties.swift
//  
//
//  Created by dmss on 24/01/18.
//
//

import Foundation
import CoreData


extension TestEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TestEntity> {
        return NSFetchRequest<TestEntity>(entityName: "TestEntity")
    }

    @NSManaged public var toBoolean: Bool
    @NSManaged public var toDate: NSDate?
    @NSManaged public var toDecimal: NSDecimalNumber?
    @NSManaged public var toDouble: Double
    @NSManaged public var toFloat: Float
    @NSManaged public var toInt16: Int16
    @NSManaged public var toInt32: Int32
    @NSManaged public var toInt64: Int64
    @NSManaged public var toString: String?

}
