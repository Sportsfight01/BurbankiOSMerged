//
//  MyPlacePhotoNote+CoreDataProperties.swift
//  
//
//  Created by dmss on 06/12/17.
//
//

import Foundation
import CoreData


extension MyPlacePhotoNote {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyPlacePhotoNote> {
        return NSFetchRequest<MyPlacePhotoNote>(entityName: "MyPlacePhotoNote")
    }

    @NSManaged public var urlID: String?
    @NSManaged public var noteDescription: String?
    @NSManaged public var jobNumber: String?
    @NSManaged public var authorName: String?
    @NSManaged public var photoTitle: String?
   

}
