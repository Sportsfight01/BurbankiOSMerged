//
//  MyPlaceStoredPhotoInfo+CoreDataProperties.swift
//  
//
//  Created by dmss on 30/01/18.
//
//

import Foundation
import CoreData


extension MyPlaceStoredPhotoInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyPlaceStoredPhotoInfo> {
        return NSFetchRequest<MyPlaceStoredPhotoInfo>(entityName: "MyPlaceStoredPhotoInfo")
    }
    @NSManaged public var jobNumber: String?
    @NSManaged public var isRead: Bool
    @NSManaged public var authorName: String?
    @NSManaged public var byClient: Int16
    @NSManaged public var current: Int16
    @NSManaged public var docDate: String?
    @NSManaged public var title: String?
    @NSManaged public var type: String?
    @NSManaged public var urlId: Int16
    @NSManaged public var url: String?

}
