//
//  MyPlaceStageCompleteDetails+CoreDataProperties.swift
//  
//
//  Created by dmss on 29/01/18.
//
//

import Foundation
import CoreData


extension MyPlaceStageCompleteDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyPlaceStageCompleteDetails> {
        return NSFetchRequest<MyPlaceStageCompleteDetails>(entityName: "MyPlaceStageCompleteDetails")
    }

    @NSManaged public var jobNumber: String?
    @NSManaged public var isRead: Bool
    @NSManaged public var name: String?
    @NSManaged public var status: String?
    @NSManaged public var dateDescription: String?
    @NSManaged public var dateActual: String?
    @NSManaged public var stageName: String?
    @NSManaged public var phasecode: String?
    @NSManaged public var taskid: Int16
    @NSManaged public var stageID: Int16

}
