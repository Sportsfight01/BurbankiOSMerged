//
//  HomesList.swift
//  BurbankApp
//
//  Created by Madhusudhan on 12/01/17.
//  Copyright © 2017 DMSS. All rights reserved.
//

import UIKit

class Home: NSObject {

    var houseName: String?
    var houseDetails = [HouseDetails]()
    
    init(dic: [String : Any])
    {
        super.init()
        houseName = NSString.checkNullValue((dic["HouseName"] as? String) ?? "")
      //  houseDetails = dic["HouseDetails"] as? HouseDetails
        if let houseArray = dic["HouseDetails"] as? NSArray
        {
            for houeDetailsDic in houseArray
            {
                let newHouswe = HouseDetails(dic: houeDetailsDic as! [String : Any])
                
                houseDetails.append(newHouswe)
            }
        }
    }
    
    
}


class HouseDetails: NSObject {
    
    var bathRooms: Int?
    var bedRooms: Int?
    var brand: String?
    var houseName: String?
    var houseAddress: String?
    var carSpace: Int?
    var storey: String?
    var houseDocument : String?
    var houseId : Int!
    var packageId : Int!
    var facadePathList : NSArray!
    var lotWidth: Float?
    var houseSize: Int?
    var landSize: Float!
    var landDepth: Float!
    var landWidth: Float!
    var price : Int!
    var minLotWidth : Float!
    var minLotLength : Float!
    var floorPlanPathList: NSArray!
    var houseDescription: String?
    var isFavourite: Bool?

    init(dic: [String : Any])
    {
        super.init()
        bathRooms = dic["Bathrooms"] as? Int
        bedRooms = dic["BedRooms"] as? Int
        brand = dic["Brand"] as? String
        houseName = dic["HouseName"] as? String
        houseAddress = (dic["Address"] as? String) ?? ""
        carSpace = (dic["CarSpace"] as? Int) ?? (dic["CarSpaces"] as? Int)
        storey = dic["Storey"] as? String
        houseDocument = NSString.checkNullValue(dic["HouseDocument"] as? String)
        facadePathList = (dic["FacadePathList"] as? NSArray) ?? ([(dic["FacadeImagePath"] as? String)!])
        houseId = dic["HouseId"] as? Int
        packageId = (dic["Packageid"] as? Int) ?? 0
        lotWidth = NSString.checkIntegerNull((dic["HouseLength"] as? Float) ?? (dic["HomeWidth"] as? Float))
        houseSize = dic["HouseSize"] as? Int
        landSize = (dic["LandSize"] as? Float) ?? (dic["BlockSize"] as? Float) ?? 0
        landDepth = (dic["LandDepth"] as? Float) ?? 0
        landWidth = (dic["LandWidth"] as? Float) ?? 0
        price = (dic["Price"] as? Int) ?? (dic["PackagePrice"] as? Int)
        minLotWidth = NSString.checkIntegerNull(dic["MinLotWidth"] as? Float)
        minLotLength = NSString.checkIntegerNull(dic["MinLotLength"] as? Float)
        floorPlanPathList = (dic["FloorPlanPathList"] as? NSArray) ?? (dic["FloorPlanImgPath"] as? NSArray)
        houseDescription = (dic["HouseDescription"] as? String) ?? (dic["Description"] as? String)
        isFavourite = (dic["IsFavourite"] as? Bool) ?? false
    }
}
