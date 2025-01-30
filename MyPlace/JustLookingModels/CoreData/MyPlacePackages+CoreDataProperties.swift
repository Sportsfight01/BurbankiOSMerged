//
//  HomeLandPackages+CoreDataProperties.swift
//  
//
//  Created by sreekanth reddy Tadi on 13/05/20.
//
//

import Foundation
import CoreData


extension MyPlacePackages {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyPlacePackages> {
        return NSFetchRequest<MyPlacePackages>(entityName: "MyPlacePackages")
    }

    @NSManaged public var address: String?
    @NSManaged public var bathRooms: String?
    @NSManaged public var bedRooms: String?
    @NSManaged public var brand: String?
    @NSManaged public var carSpace: String?
    @NSManaged public var dateAvailable: String?
    @NSManaged public var ensuite: Bool
    @NSManaged public var estateName: String?
    @NSManaged public var facade: String?
    @NSManaged public var facadePermanentUrl: String?
    @NSManaged public var houseName: String?
    @NSManaged public var housePrice: String?
    @NSManaged public var houseSize: String?
    @NSManaged public var inclusionFileName: String?
    @NSManaged public var inclusions: String?
    @NSManaged public var isCompare: Bool
    @NSManaged public var isDisplay: Bool
    @NSManaged public var isFav: Bool
    @NSManaged public var isShowOnWeb: Bool
    @NSManaged public var landSizeSqm: String?
    @NSManaged public var landTitleDate: String?
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var minLotLength: String?
    @NSManaged public var minLotWidth: String?
    @NSManaged public var packageDescription: String?
    @NSManaged public var packageId: String?
    @NSManaged public var packageId_LandBank: String?
    @NSManaged public var price: String?
    @NSManaged public var region: String?
    @NSManaged public var stateId: String?
    @NSManaged public var storey: String?
    @NSManaged public var study: Bool

    @NSManaged public var state: String?
    @NSManaged public var alfrescosq: Bool


}
