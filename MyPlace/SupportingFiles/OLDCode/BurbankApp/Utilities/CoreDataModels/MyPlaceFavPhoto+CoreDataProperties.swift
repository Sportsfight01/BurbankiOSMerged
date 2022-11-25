//
//  MyPlaceFavPhoto+CoreDataProperties.swift
//  
//
//  Created by dmss on 05/12/17.
//
//

import Foundation
import CoreData


extension MyPlaceFavPhoto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyPlaceFavPhoto> {
        return NSFetchRequest<MyPlaceFavPhoto>(entityName: "MyPlaceFavPhoto")
    }

    @NSManaged public var authorName: String?
    @NSManaged public var jobNumber: String?
    @NSManaged public var title: String?
    @NSManaged public var uploadedDate: String?
    @NSManaged public var urlID: String?
    @NSManaged public var url: String?
    @NSManaged public var imageID: String?
    @NSManaged public var imagePathForVLC: String?
    
}
