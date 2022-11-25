//
//  HomeLand.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 06/04/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit

class HomeLandPackage: NSObject {
    
    
    var favouritedUser: UserBean?
    
    
    var Id: String?
    var packageId: String?
    var packageId_LandBank: String?
    
    var state: String?
    
    var stateId: String?
    var address: String?
    var estateName: String?
    var region: String?
    var latitude: String?
    var longitude: String?
    
    
    var inclusions: String?
    var inclusionFileName: String?
    var facadePermanentUrl: String?
    
    
    var houseName: String?
    var facade: String?
    var housePrice: String?
    var landSizeSqm: String?
    var houseSize: String?
    var brand: String?
    var packageDescription: String?
    var storey: String?
    var bedRooms: String?
    var bathRooms: String?
    var carSpace: String?
    var price: String?
    var minLotWidth: String?
    var minLotLength: String?
    
    var study: Bool = false
    var ensuite: Bool = false
    
    var alfrescosq: Bool = false
    
    // Other Boolean tags
    var isFav: Bool = false
    var isShowOnWeb: Bool = false
    var isCompare: Bool = false
    var isDisplay: Bool = false
    
    //Dates
    var dateAvailable: String?
    var landTitleDate: String?
    
    
    
    
    
    
    override init() {
        super.init()
        
        
    }
    
    
    
    init(_ dict: [String: Any]) {
        super.init()
        
        if dict.keys.count == 0 {
            emptyValues()
            return
        }
        
        
//        (dict[""] as? NSNumber ?? 0).stringValue
        
        Id = (dict["Id"] as? NSNumber ?? 0).stringValue
        packageId = (dict["PackageId"] as? NSNumber ?? 0).stringValue
        packageId_LandBank = (dict["PackageId_LandBank"] as? NSNumber ?? 0).stringValue
        
        state = String.checkNullValue((dict["State"] ?? "") as Any)
        stateId = (dict["StateId"] as? NSNumber ?? 0).stringValue
        address = String.checkNullValue((dict["Address"] ?? "") as Any)
        estateName = String.checkNullValue((dict["EstateName"] ?? "") as Any)
        region = String.checkNullValue((dict["Region"] ?? "") as Any)
        latitude = String.checkNullValue((dict["Latitude"] ?? "") as Any)
        longitude = String.checkNullValue((dict["Longitude"] ?? "") as Any)
        
        
        inclusions = String.checkNullValue((dict["Inclusions"] ?? "") as Any)
        inclusionFileName = String.checkNullValue((dict["InclusionFileName"] ?? "") as Any)
        facadePermanentUrl = String.checkNullValue((dict["FacadePermanentUrl"] ?? "") as Any)
        
        
        houseName = String.checkNullValue((dict["HouseName"] ?? "") as Any)
        facade = String.checkNullValue((dict["Facade"] ?? "") as Any)
        housePrice = (dict["HousePrice"] as? NSNumber ?? 0).stringValue
        landSizeSqm = (dict["LandSizeSqm"] as? NSNumber ?? 0).stringValue
        houseSize = (dict["HouseSize"] as? NSNumber ?? 0).stringValue
        
        brand = String.checkNullValue((dict["Brand"] ?? "") as Any)
        packageDescription = String.checkNullValue((dict["Description"] ?? "") as Any)
        storey = (dict["Storey"] as? NSNumber ?? 0).stringValue
        bedRooms = (dict["BedRooms"] as? NSNumber ?? 0).stringValue
        bathRooms = (dict["BathRooms"] as? NSNumber ?? 0).stringValue
        carSpace = (dict["CarSpace"] as? NSNumber ?? 0).stringValue
        
        price = (dict["Price"] as? NSNumber ?? 0).stringValue
        minLotWidth = (dict["MinLotWidth"] as? NSNumber ?? 0).stringValue
        minLotLength = (dict["MinLotLength"] as? NSNumber ?? 0).stringValue
        
        //        minLotLength = (dict["MinLotLength"] as? NSNumber ?? 0).stringValue
        
        
        study = (dict["Study"] as? NSNumber ?? 0).boolValue
        ensuite = (dict["Ensuite"] as? NSNumber ?? 0).boolValue
        
        alfrescosq = (dict["Alfrescosq"] as? NSNumber ?? 0).boolValue
        
        isFav = (dict["IsFav"] as? NSNumber ?? 0).boolValue
        isShowOnWeb = (dict["IsShowOnWeb"] as? NSNumber ?? 0).boolValue
        isCompare = (dict["IsCompare"] as? NSNumber ?? 0).boolValue
        isDisplay = (dict["IsDisplay"] as? NSNumber ?? 0).boolValue
        
        
        //Dates
        dateAvailable = String.checkNullValue((dict["DateAvailable"] ?? "") as Any)
        landTitleDate = String.checkNullValue((dict["LandTitleDate"] ?? "") as Any)
        
        
    }
    
    
    func emptyValues () {
        
        Id = ""
        packageId = ""
        packageId_LandBank = ""
        
        stateId = ""
        address = ""
        estateName = ""
        region = ""
        latitude = ""
        longitude = ""
        
        
        inclusions = ""
        inclusionFileName = ""
        facadePermanentUrl = ""
        
        
        houseName = ""
        facade = ""
        housePrice = ""
        landSizeSqm = ""
        houseSize = ""
        brand = ""
        packageDescription = ""
        storey = ""
        bedRooms = ""
        bathRooms = ""
        carSpace = ""
        price = ""
        minLotWidth = ""
        minLotLength = ""
        
        
        //Dates
        dateAvailable = ""
        landTitleDate = ""
        
    }
    
    
    
}






/*
 LotNo
 HomePlan
 Bed2sqm
 LivingAreasqm
 PromoName
 CollectionUrl
 DisplaysList
 TotalSizesq
 Bed1sqm
 RetailPriceLessFHOG
 HomeWidth
 FormattedPrice
 EmailAddress
 Palettes
 FHOG
 FacadeMediumImageUrls
 CommaDelimitedInclusions
 FacadeImageGuid
 Garagesq
 ConsultantSurName
 
 LandDepth
 Alfrescosqm
 StandardFacades
 EdgeImages
 SliderImages
 
 LandSize
 Rooms
 Mealssqm
 GroundFloorsqm
 HouseLength
 HouseWidth
 LandWidth
 LivingAreasq
 PostCode
 LandPrice
 Bed3sqm
 Visualisation
 VisualiseFacade
 ContactNo
 FirstFloorsqm
 FirstFloorsq
 GroundFloorsq
 HomeLength
 ValidFacades
 Bed4sqm
 VideoURL
 ConsultantFirstName
 Street
 Porchsqm
 Garagesqm
 FacadeImageName
 StateAbbrev
 Familysqm
 Livingsqm
 Porchsq
 BlockType
 Suburb
 InclusionPrice
 HouseDimensions_HouseName
 FacadeImage
 NodeGuid
 TotalSizesqm
 HouseId_LandBank
 
 ["MinLotLength": 25, "InclusionFileName": inclusions_burbank range_20191023, "LotNo": 29, "Storey": 1, "HomePlan": <null>, "Bed2sqm": 0, "LivingAreasqm": 108.4, "Id": 9068, "PromoName": , "isFav": 0, "CollectionUrl": <null>, "DisplaysList": <null>, "State": Victoria, "TotalSizesq": 16, "Bed1sqm": 0, "Facade": Nolan, "HouseSize": 148, "RetailPriceLessFHOG": 438300, "HomeWidth": 9, "FormattedPrice": <null>, "EmailAddress": chitraksh.bhargav@burbank.com.au, "Palettes": <null>, "Address": 29, Goodison Grove, Tarneit, VIC 3029 (Edgeleigh  Estate), "Description": , "FHOG": 10000, "FacadeMediumImageUrls": <null>, "CommaDelimitedInclusions": , "FacadeImageGuid": 00000000-0000-0000-0000-000000000000, "Garagesq": 3.89, "FacadePermanentUrl": ~/getmedia/54d1aaca-843c-4f5a-832e-b62d2051afec/Cole_Nolan.jpg, "ConsultantSurName": Bhargav, "StateId": 11, "Inclusions": [BBS]Site Costs Including Rock Assurance[BBS]Council and Developer Requirements[BBS]12 Month Price Freeze With Option To Extend[BBS]Quality Assured With Our 30-Year Structural Guarantee and 15-Month Maintenance Pledge[BBS]Multiple Floorplans and Facade Options Available[BBS]Style Your Home With Expert Interior Designers At Our Edge Selection Studio, "LandDepth": 28, "Alfrescosqm": 0, "StandardFacades": <null>, "EdgeImages": <null>, "SliderImages": <null>, "LandSize": 294, "HouseName": Cole, "Rooms": <null>, "Mealssqm": 0, "LandTitleDate": 2019-12-15T00:00:00, "GroundFloorsqm": 108.4, "DateAvailable": 0001-01-01T00:00:00, "HouseLength": 0, "HouseWidth": 0, "LandWidth": 10.5, "LivingAreasq": 11.67, "PackageId": 9068, "PostCode": 3029, "LandSizeSqm": 294, "LandPrice": 263000, "BathRooms": 2, "Bed3sqm": 0, "Visualisation": 0, "Study": 0, "VisualiseFacade": <null>, "Region": West, "IsDisplay": 0, "ContactNo": 0424 447 033, "FirstFloorsqm": 0, "Longitude": , "Brand": Burbank Range, "EstateName": Edgeleigh , "FirstFloorsq": 0, "Latitude": , "Alfrescosq": 0, "GroundFloorsq": 11.67, "CarSpace": 2, "MinLotWidth": 10.5, "HomeLength": 0, "ValidFacades": <null>, "Price": 448300, "Bed4sqm": 0, "VideoURL": <null>, "Ensuite": 1, "BedRooms": 3, "ConsultantFirstName": Chitraksh , "Street": Goodison Grove, "IsCompare": 0, "PackageId_LandBank": 257761, "Porchsqm": 4.6, "Garagesqm": 36.1, "FacadeImageName": <null>, "IsFav": 0, "StateAbbrev": , "Familysqm": 0, "Livingsqm": 0, "Porchsq": 0.5, "IsShowOnWeb": 0, "BlockType": 4, "Suburb": Tarneit, "InclusionPrice": 7500, "HouseDimensions_HouseName": <null>, "FacadeImage": <null>, "NodeGuid": 00000000-0000-0000-0000-000000000000, "HousePrice": 174800, "TotalSizesqm": 149.1, "HouseId_LandBank": 0]
 */
