//
//  DisplayHomeModel.swift
//  BurbankApp
//
//  Created by Naveen Kourampalli on 10/06/21.
//  Copyright © 2021 Sreekanth tadi. All rights reserved.
//

import UIKit

class DisplayHomeModel: NSObject {
    
    
    var favouritedUser: UserBean?
    
    
    var stateId : String?
    var brand : String?
    var closingdate : String?
    var display : String?
    var displayStatus : String?
    var estateName : String?
    var houseName : String?
    var houseSize : String?
    var latitude : String?
    var longitude : String?
    var lotNo : String?
    var lotPostCode : String?
    var lotStreet1 : String?
    var lotSuburb : String?
    var openTimes : String?
    var openHoursWeek : String?
    var openingDate : String?
    var regionName : String?
    var idDisplay : String?
    var idHouseType : String?
    var imageUrl : String?
    var facadeName : String?
    var facadePermanentUrl : String?
    var collectionUrl : String?
    var sgVideourl : String?
    var xmastiming : String?
    var markerImageUrl : String?
    var consultants : String?
    var displayURL : String?
    var carSpace : String?
    var bathRooms : String?
    var bedRooms : String?
    var id : String?
    var locations : NSArray?
    var isFav :  Bool!
    
    override init() {
        super.init()
        
        
    }
    
    
    
    init(_ dict: [String: Any]) {
        super.init()
        
        if dict.keys.count == 0 {
            emptyValues()
            return
        }
        
                
        id = (dict["Id"] as? NSNumber ?? 0).stringValue
        stateId = (dict["StateId"] as? NSNumber ?? 0).stringValue
        brand = (dict["Brand"] as? String ?? " ")
        closingdate = String.checkNullValue((dict["Closingdate"] ?? "") as Any)
        stateId = (dict["StateId"] as? NSNumber ?? 0).stringValue
        display = String.checkNullValue((dict["Display"] ?? "") as Any)
        displayStatus = String.checkNullValue((dict["DisplayStatus"] ?? "") as Any)
        estateName = String.checkNullValue((dict["EstateName"] ?? "") as Any)
        latitude = String.checkNullValue((dict["Latitude"] ?? "") as Any)
        longitude = String.checkNullValue((dict["Longitude"] ?? "") as Any)
        lotNo = String.checkNullValue((dict["LotNo"] ?? "") as Any)
        lotPostCode = String.checkNullValue((dict["LotPostCode"] ?? "") as Any)
        lotStreet1 = String.checkNullValue((dict["LotStreet1"] ?? "") as Any)
        lotSuburb = String.checkNullValue((dict["LotSuburb"] ?? "") as Any)
        openTimes = String.checkNullValue((dict["OpenTimes"] ?? "") as Any)
        openHoursWeek = String.checkNullValue((dict["OpenHoursWeek"] ?? "") as Any)
        openingDate = String.checkNullValue((dict["OpeningDate"] ?? "") as Any)
        openTimes = String.checkNullValue((dict["OpenTimes"] ?? "") as Any)
        regionName = String.checkNullValue((dict["RegionName"] ?? "") as Any)
        idDisplay = (dict["idDisplay"] as? NSNumber ?? 0).stringValue
        idHouseType =  (dict["idHouseType"] as? NSNumber ?? 0).stringValue
        imageUrl = String.checkNullValue((dict["imageUrl"] ?? "") as Any)
        facadeName = String.checkNullValue((dict["FacadeName"] ?? "") as Any)
        sgVideourl = String.checkNullValue((dict["sgVideourl"] ?? "") as Any)
        facadePermanentUrl = String.checkNullValue((dict["FacadePermanentUrl"] ?? "") as Any)
        xmastiming  = String.checkNullValue((dict["Xmastiming"] ?? "") as Any)
        displayURL = String.checkNullValue((dict["DisplayURL"] ?? "") as Any)
        houseName = String.checkNullValue((dict["HouseName"] ?? "") as Any)
        houseSize = (dict["HouseSize"] as? NSNumber ?? 0).stringValue
        brand = String.checkNullValue((dict["Brand"] ?? "") as Any)
        bedRooms = (dict["BedRooms"] as? NSNumber ?? 0).stringValue
        bathRooms = (dict["BathRooms"] as? NSNumber ?? 0).stringValue
        carSpace = (dict["CarSpace"] as? NSNumber ?? 0).stringValue
        collectionUrl = String.checkNullValue((dict["CollectionUrl"] ?? "") as Any)
        locations = (dict["Locations"] as? NSArray ?? [])
        isFav = (dict["IsFavourite"] as? Bool ?? false)

    }
    
    
    func emptyValues () {
        
        stateId  = ""
        brand  = ""
        closingdate  = ""
        display  = ""
        displayStatus  = ""
        estateName  = ""
        houseName  = ""
        houseSize  = ""
        latitude  = ""
        longitude  = ""
        lotNo  = ""
        lotPostCode  = ""
        lotStreet1  = ""
        lotSuburb  = ""
        openTimes  = ""
        openHoursWeek  = ""
        openingDate  = ""
        regionName  = ""
        idDisplay  = ""
        idHouseType  = ""
        imageUrl  = ""
        facadeName  = ""
        facadePermanentUrl  = ""
        collectionUrl  = ""
        sgVideourl  = ""
        xmastiming  = ""
        markerImageUrl  = ""
        consultants  = ""
        displayURL  = ""
        carSpace  = ""
        bathRooms  = ""
        bedRooms  = ""
        id  = ""
        locations = []
        isFav = false
   
    }
    
    
}

class PupularDisplays: NSObject {
    
    
    var favouritedUser: UserBean?
    
    
    
    
    var stateId : String?
    var brand : String?
    var houseName : String?
    var houseSize : String?
    var imageUrl : String?
    var facadeName : String?
    var myplace3d : Bool?
    var housePrice : Int?
    var storey : Int?
    var locations = [designLocations]()
    var carSpace : String?
    var bedRooms : String?
    var bathRooms : String?
    var id : String?
    var IsFav : Bool?
 
  
    override init() {
        super.init()
        
        
    }
    
    
    
    init(_ dict: [String: Any]) {
        super.init()
        
        if dict.keys.count == 0 {
            emptyValues()
            return
        }
        
                
        id = (dict["Id"] as? NSNumber ?? 0).stringValue
        stateId = (dict["StateId"] as? NSNumber ?? 0).stringValue
        brand = (dict["Brand"] as? String ?? " ")
        stateId = (dict["StateId"] as? NSNumber ?? 0).stringValue
        imageUrl = String.checkNullValue((dict["ImageUrl"] ?? "") as Any)
        facadeName = String.checkNullValue((dict["Facade"] ?? "") as Any)
        houseName = String.checkNullValue((dict["HouseName"] ?? "") as Any)
        houseSize = dict["HouseSize"] as? String ?? " "
        myplace3d = (dict["Myplace3d"] as? Bool ?? false)
        storey = (dict["Storey"] as? Int ?? 0)
        housePrice = (dict["HousePrice"] as? Int ?? 0)
        IsFav = (dict["IsFavourite"] as? Bool ?? false)
        let packagesResult1 = dict["DesignLocation"] as! [NSDictionary]
//        print("----------------------*******---------------------------------------------------------")
        for package1: NSDictionary in packagesResult1 {
           
//            print(package1)
            let designLocationData = designLocations(package1 as! [String : Any])
//            print(designLocationData)
            locations.append(designLocationData)
//            print("====_____+++++=====",locations)
//            print("----------------------*******---------------------------------------------------------")
        }
//        print("----------------------*******---------------------------------------------------------")
       // print("====_____+++++=====",locations)
        carSpace = (dict["CarSpace"] as? NSNumber ?? 0).stringValue
        bedRooms = (dict["BedRooms"] as? NSNumber ?? 0).stringValue
        bathRooms = (dict["BathRooms"] as? NSNumber ?? 0).stringValue
        

    }
    
    
    func emptyValues () {
        
      
        
        stateId  = ""
        houseName  = ""
        houseSize = ""
        houseSize  = ""
        imageUrl  = ""
        facadeName  = ""
        brand = ""
        myplace3d = false
        housePrice = 0
        storey = 0
        id  = ""
        locations = []
        carSpace = ""
        bedRooms = "0"
        bathRooms = "0"
        IsFav = false
   
    }
    
    
}

class designLocations : NSObject{
    var eststeName : String?
    var latitude : String?
    var longitude : String?
    var lotStreet1 : String?
    var lotSuburb : String?
    var id : String?
    var isFav : Bool?
    
    override init() {
        super.init()
        
        
    }
    
    init(_ dict: [String: Any]) {
        super.init()
        
        if dict.keys.count == 0 {
            emptyValues()
            return
        }
        eststeName = dict["EstateName"] as? String ?? ""
        latitude = dict["Latitude"] as? String ?? ""
        longitude = dict["Longitude"] as? String ?? ""
        lotStreet1 = dict["LotStreet1"] as? String ?? ""
        lotSuburb = dict["LotSuburb"] as? String ?? ""
        id = (dict["Id"] as? NSNumber ?? 0).stringValue 
        isFav = dict["IsFavourite"] as? Bool ?? false
    }
    
    func emptyValues () {
        eststeName  = ""
        latitude  = ""
        longitude = ""
        id = ""
        isFav = false
   
    }
    
        
}



class houseDetailsByHouseType: NSObject {
    
    
    var favouritedUser: UserBean?
    
    
    var houseId_LandBank = ""
    var nodeGuid = ""
    var stateId = ""
    var houseName = ""
    var houseSize = ""
    var facade = ""
    var standardFacades = ""
    var facadeImage = ""
    var facadeImageGuid = ""
    var facadeImageName = ""
    var brand = ""
    var descriptions = ""
    var storey = ""
    var carSpace = ""
    var price = ""
    var study  = "0"
    var ensuite :   Bool?
    var bedRooms = ""
    var minLotWidth = ""
    var houseLength = ""
    var houseWidth = ""
    var minLotLength = ""
    var bathRooms = ""
    var livingAreasq = ""
    var livingAreasqm = ""
    var totalSizesq = ""
    var totalSizesqm = ""
    var alfrescosq = ""
    var alfrescosqm = ""
    var firstFloorsq = ""
    var firstFloorsqm = ""
    var garagesq = ""
    var garagesqm = ""
    var groundFloorsq = ""
    var groundFloorsqm = ""
    var porchsq = ""
    var porchsqm = ""
    var isShowOnWeb  :   Bool?
    var dateAvailable = ""
    var collectionUrl = ""
    var facadePermanentUrl = ""
    var houseDimensions_HouseName : NSArray?
    var homePlan = ""
    var facadeMediumImageUrls : NSArray?
    var edgeImages : NSArray?
    var sliderImages : NSArray?
    var displaysList : NSArray?
    var rooms = ""
    var videoURL = ""
    var visualisation   :   Bool?
    var isCompare   :   Bool?
    var isFav  :   Bool!
    var livingsqm = ""
    var mealssqm = ""
    var familysqm = ""
    var bed1sqm = ""
    var bed2sqm = ""
    var bed3sqm = ""
    var bed4sqm = ""
    var inclusionFileName = ""
    var validFacades = ""
    var visualiseFacade = ""
    var palettes = ""
    var defaultPalette = ""
    var salesCount = ""
    var isDisplay  :   Bool?
    var displayEstateName = ""
    var id = ""
    var openTimes = ""
    var street = ""
    var suburb = ""
    var longitude = ""
    var latitude = ""
    var displayId = ""
    var displayDesignCount : NSArray?
    override init() {
        super.init()
        
        
    }
    
    
    
    init(_ dict: [String: Any]) {
        super.init()
        
        if dict.keys.count == 0 {
            emptyValues()
            return
        }
        houseId_LandBank = (dict["HouseId_LandBank"] as? NSNumber ?? 0).stringValue
        nodeGuid = (dict["NodeGuid"] as? String ?? "")
        stateId = (dict["StateId"] as? NSNumber ?? 0).stringValue
        houseName = (dict["HouseName"] as? String ?? "")
        houseSize = (dict["HouseSize"] as? NSNumber ?? 0).stringValue
        facade = (dict["Facade"] as? String ?? "")
        standardFacades = (dict["StandardFacades"] as? String ?? "")
        facadeImage = (dict["FacadeImage"] as? String ?? "")
        facadeImageGuid = (dict["FacadeImageGuid"] as? String ?? "")
        facadeImageName = (dict["FacadeImageName"] as? String ?? "")
        brand = (dict["Brand"] as? String ?? "")
        descriptions = (dict["Description"] as? String ?? "")
        storey = (dict["Storey"] as? NSNumber ?? 0).stringValue
        carSpace = (dict["CarSpace"] as? NSNumber ?? 0).stringValue
        price = (dict["Price"] as? NSNumber ?? 0).stringValue
        study = (dict["Study"] as? NSNumber ?? 0).stringValue
        ensuite = (dict["Ensuite"] as? Bool ?? false)
        bedRooms =  (dict["BedRooms"] as? NSNumber ?? 0).stringValue
        minLotWidth =  (dict["MinLotWidth"] as? NSNumber ?? 0).stringValue
        houseLength =  (dict["HouseLength"] as? NSNumber ?? 0).stringValue
        houseWidth =  (dict["HouseWidth"] as? NSNumber ?? 0).stringValue
        minLotLength =  (dict["MinLotLength"] as? NSNumber ?? 0).stringValue
        bathRooms =  (dict["BathRooms"] as? NSNumber ?? 0).stringValue
        livingAreasq = (dict["LivingAreasq"] as? NSNumber ?? 0).stringValue
        livingAreasqm = (dict["LivingAreasqm"] as? NSNumber ?? 0).stringValue
        totalSizesq = (dict["TotalSizesq"] as? NSNumber ?? 0).stringValue
        totalSizesqm = (dict["TotalSizesqm"] as? NSNumber ?? 0).stringValue
        alfrescosq = (dict["Alfrescosq"] as? NSNumber ?? 0).stringValue
        alfrescosqm = (dict["Alfrescosqm"] as? NSNumber ?? 0).stringValue
        firstFloorsq = (dict["FirstFloorsq"] as? NSNumber ?? 0).stringValue
        firstFloorsqm = (dict["FirstFloorsqm"] as? NSNumber ?? 0).stringValue
        garagesq = (dict["Garagesq"] as? NSNumber ?? 0).stringValue
        garagesqm = (dict["Garagesqm"] as? NSNumber ?? 0).stringValue
        groundFloorsq = (dict["GroundFloorsq"] as? NSNumber ?? 0).stringValue
        groundFloorsqm = (dict["GroundFloorsqm"] as? NSNumber ?? 0).stringValue
        porchsq = (dict["Porchsq"] as? NSNumber ?? 0).stringValue
        porchsqm = (dict["Porchsqm"] as? NSNumber ?? 0).stringValue
        isShowOnWeb = (dict["IsShowOnWeb"] as? Bool ?? false)
        dateAvailable = (dict["DateAvailable"] as? String ?? "")
        collectionUrl = (dict["CollectionUrl"] as? String ?? "")
        facadePermanentUrl = (dict["FacadePermanentUrl"] as? String ?? "")
        houseDimensions_HouseName = (dict["HouseDimensions_HouseName"] ?? NSArray ()) as? NSArray
        homePlan = (dict["HomePlan"] as? String ?? "")
        facadeMediumImageUrls = (dict["FacadeMediumImageUrls"] ?? NSArray ()) as? NSArray
        edgeImages = (dict["EdgeImages"] ?? NSArray ()) as? NSArray
        sliderImages = (dict["SliderImages"] ?? NSArray ()) as? NSArray
        displaysList = (dict["DisplaysList"] ?? NSArray ()) as? NSArray
        rooms = (dict["Rooms"] as? String ?? "")
        videoURL = (dict["VideoURL"] as? String ?? "")
        visualisation = (dict["Visualisation"] as? Bool ?? false)
        isCompare = (dict["IsCompare"] as? Bool ?? false)
        isFav = (dict["IsFav"] as? Bool ?? false)
        livingsqm = (dict["Livingsqm"] as? NSNumber ?? 0).stringValue
        mealssqm = (dict["Mealssqm"] as? NSNumber ?? 0).stringValue
        familysqm = (dict["Familysqm"] as? NSNumber ?? 0).stringValue
        bed1sqm = (dict["Bed1sqm"] as? NSNumber ?? 0).stringValue
        bed2sqm = (dict["Bed2sqm"] as? NSNumber ?? 0).stringValue
        bed3sqm = (dict["Bed3sqm"] as? NSNumber ?? 0).stringValue
        bed4sqm = (dict["Bed4sqm"] as? NSNumber ?? 0).stringValue
        inclusionFileName = (dict["InclusionFileName"] as? String ?? "")
        validFacades = (dict["ValidFacades"] as? String ?? "")
        visualiseFacade = (dict["VisualiseFacade"] as? String ?? "")
        palettes = (dict["Palettes"] as? String ?? "")
        defaultPalette = (dict["DefaultPalette"] as? String ?? "")
        salesCount = (dict["SalesCount"] as? NSNumber ?? 0).stringValue
        isDisplay = (dict["IsDisplay"] as? Bool ?? false)
        displayEstateName = (dict["DisplayEstateName"] as? String ?? "")
        id = (dict["Id"] as? NSNumber ?? 0).stringValue
        openTimes = (dict["OpenTimes"] as? String ?? "")
        street = (dict["Street"] as? String ?? "")
        suburb = (dict["Suburb"] as? String ?? "")
        longitude = (dict["Longitude"] as? String ?? "")
        latitude = (dict["Latitude"] as? String ?? "")
        displayDesignCount = (dict["DisplayDesignCount"] ?? NSArray ()) as? NSArray
        displayId = (dict["DisplayId"] as? NSNumber ?? 0).stringValue
        
    }
    
    
    func emptyValues () {
        houseId_LandBank = ""
        nodeGuid = ""
        stateId = ""
        houseName = ""
        houseSize = ""
        facade = ""
        standardFacades = ""
        facadeImage = ""
        facadeImageGuid = ""
        facadeImageName = ""
        brand = ""
        descriptions = ""
        storey = ""
        carSpace = ""
        price = ""
        study = ""
        ensuite = false
        bedRooms = ""
        minLotWidth = ""
        houseLength = ""
        houseWidth = ""
        minLotLength = ""
        bathRooms = ""
        livingAreasq = ""
        livingAreasqm = ""
        totalSizesq = ""
        totalSizesqm = ""
        alfrescosq = ""
        alfrescosqm = ""
        firstFloorsq = ""
        firstFloorsqm = ""
        garagesq = ""
        garagesqm = ""
        groundFloorsq = ""
        groundFloorsqm = ""
        porchsq = ""
        porchsqm = ""
        isShowOnWeb  = false
        dateAvailable = ""
        collectionUrl = ""
        facadePermanentUrl = ""
        houseDimensions_HouseName  = []
        homePlan = ""
        facadeMediumImageUrls  = []
        edgeImages = []
        sliderImages = []
        displaysList = []
        rooms = ""
        videoURL = ""
        visualisation   = false
        isCompare   = false
        isFav  = false
        livingsqm = ""
        mealssqm = ""
        familysqm = ""
        bed1sqm = ""
        bed2sqm = ""
        bed3sqm = ""
        bed4sqm = ""
        inclusionFileName = ""
        validFacades = ""
        visualiseFacade = ""
        palettes = ""
        defaultPalette = ""
        salesCount = ""
        isDisplay  = false
        displayEstateName = ""
        id = ""
        suburb = ""
        street = ""
        longitude = ""
        latitude = ""
        displayId = ""
        displayDesignCount = []
    
    }
    
    
}

/*
 
 {
     Alfrescosq = "1.3";
     Alfrescosqm = "12.09";
     BathRooms = 3;
     Bed1sqm = "26.21";
     Bed2sqm = "12.85";
     Bed3sqm = "11.16";
     Bed4sqm = "11.68";
     BedRooms = 4;
     Brand = Eclipse;
     CarSpace = 2;
     CollectionUrl = "<null>";
     DateAvailable = "2016-03-18T00:00:00";
     DefaultPalette = Contemporary;
     Description = "<null>";
     DisplaysList =                 (
     );
     EdgeImages =                 (
     );
     Ensuite = 1;
     Facade = Urban;
     FacadeImage = "<null>";
     FacadeImageGuid = "00000000-0000-0000-0000-000000000000";
     FacadeImageName = "<null>";
     FacadeMediumImageUrls =                 (
     );
     FacadePermanentUrl = "~/getmedia/e9799781-c108-475f-a845-d966f1d91d4b/Lincoln_Urban.jpg";
     Familysqm = "48.19";
     FirstFloorsq = "24.47";
     FirstFloorsqm = "227.32";
     Garagesq = "3.99";
     Garagesqm = "37.06";
     GroundFloorsq = "18.55";
     GroundFloorsqm = "172.31";
     HomePlan = "<null>";
     "HouseDimensions_HouseName" =                 (
     );
     "HouseId_LandBank" = 102;
     HouseLength = "22.07";
     HouseName = Lincoln;
     HouseSize = 453;
     HouseWidth = "10.91";
     Id = 1329;
     InclusionFileName = "Inclusions_Eclipse_20200302.pdf";
     IsCompare = 0;
     IsFav = 0;
     IsShowOnWeb = 1;
     LivingAreasq = 0;
     LivingAreasqm = 0;
     Livingsqm = 0;
     Mealssqm = "37.2";
     MinLotLength = 25;
     MinLotWidth = 14;
     NodeGuid = "00000000-0000-0000-0000-000000000000";
     Palettes = "Coastal|Contemporary|Heritage|Scandi|Hamptons|Modern|Lux|Rustic|Bohemian|Classic";
     Porchsq = "0.5";
     Porchsqm = "4.6";
     Price = 325900;
     Rooms = "alfresco,Alfresco|Porch,Porch|bed 1,Bedroom 1|bed 2,Bedroom 2|bed 3,Bedroom 3|bed 4,Bedroom 4|Entry,Entry|Family,Family|Landing,Landing|Meals,Meals|Retreat,Retreat|Rumpus,Rumpus|Study,Study|w.i.l,Walk in Linen|w.i.p,Walk in Pantry|wc,WC|Kitchen,Kitchen|Ldry,Laundry|Bath,Bathroom|ENS,Ensuite|Pdr,Powder|Garage,Garage|str,Store|passage 1,Passage 1|w.i.r,Walk in Robe|w.i.l 1,Walk in Linen 1|Theatre,Theatre|Home Theatre,Home Theatre|wc 2,WC2|Void,Staircase|passage 2,Passage 2|passage 3,Passage 3|passage 4,Passage 4";
     SliderImages =                 (
     );
     StandardFacades = Traditional;
     StateId = 4;
     Storey = 2;
     Study = 1;
     TotalSizesq = "48.8";
     TotalSizesqm = "453.38";
     ValidFacades = "Kingston|Metro|Nouveau|Traditional|Urban";
     VideoURL = "";
     Visualisation = 1;
     VisualiseFacade = Traditional;
 }
 
 */
