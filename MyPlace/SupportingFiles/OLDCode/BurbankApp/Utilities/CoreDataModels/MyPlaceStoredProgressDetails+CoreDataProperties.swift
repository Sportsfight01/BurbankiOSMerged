//
//  MyPlaceStoredProgressDetails+CoreDataProperties.swift
//  
//
//  Created by dmss on 23/01/18.
//
//

import Foundation
import CoreData


extension MyPlaceStoredProgressDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyPlaceStoredProgressDetails> {
        return NSFetchRequest<MyPlaceStoredProgressDetails>(entityName: "MyPlaceStoredProgressDetails")
    }
    @NSManaged public var jobNumber: String?
    @NSManaged public var isRead: Bool
    @NSManaged public var currentStatus: String?
    @NSManaged public var name: String?
    @NSManaged public var previousStatus: String?
    @NSManaged public var stageName: String?
    @NSManaged public var status: String?
    @NSManaged public var taskID: Int16
    @NSManaged public var dateActual: String?//
    @NSManaged public var phaseCode: String?
    
}
