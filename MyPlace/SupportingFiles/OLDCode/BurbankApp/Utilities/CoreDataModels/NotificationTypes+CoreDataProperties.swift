//
//  NotificationTypes+CoreDataProperties.swift
//  
//
//  Created by dmss on 18/01/18.
//
//

import Foundation
import CoreData


extension NotificationTypes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NotificationTypes> {
        return NSFetchRequest<NotificationTypes>(entityName: "NotificationTypes")
    }

    @NSManaged public var photoAdded: Bool
    @NSManaged public var stageComplete: Bool
    @NSManaged public var stageChange: Bool

}
