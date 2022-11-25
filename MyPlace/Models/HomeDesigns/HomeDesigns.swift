//
//  HomeDesigns.swift
//  MyPlace
//
//  Created by Mohan Kumar on 20/07/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit

class HomeDesigns: NSObject {
    
    
    var favouritedUser: UserBean?
    
    
    var Id: String?
    var packageId: String?
    
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
    
   //Naveen changed for multiple regions
    var HouseId: Int?
    //Mohan
    var houseId_LandBank: String?

    var standardFacades: String?
    var facadeImageName: String?
    var houseDimensions_HouseName: NSArray?
    var validFacades: String?
    var visualiseFacade: String?
    var palettes: String?
    var defaultPalette: String?
    
    
    var houseLength: String?
    var houseWidth: String?
    var livingAreasq: String?
    var livingAreasqm: String?
    var totalSizesq: String?
    var totalSizesqm: String?
    var alfrescosqm: String?
    var firstFloorsq: String?
    var firstFloorsqm: String?
    var garagesq: String?
    var garagesqm: String?
    var groundFloorsq: String?
    var groundFloorsqm: String?
    var porchsq: String?
    var porchsqm: String?
    var livingsqm: String?
    var mealssqm: String?
    var familysqm: String?
    var bed1sqm: String?
    var bed2sqm: String?
    var bed3sqm: String?
    var bed4sqm: String?
   

    var visualisation: Bool = false

    var collectionUrl: String?
    var facadeMediumImageUrls: NSArray?
    var videoURL: String?
    
    
    var edgeImages: NSArray?
    var sliderImages: NSArray?
    var displaysList: NSArray?
    

    /*{
           "NodeGuid": "00000000-0000-0000-0000-000000000000",
           "FacadeImage": null,
           "FacadeImageGuid": "00000000-0000-0000-0000-000000000000",
           "HomePlan": null,
           "EdgeImages": (),
           "SliderImages": (),
           "DisplaysList": (),
           "Rooms": "alfresco,Alfresco|bed 1,Bedroom 1|bed 2,Bedroom 2|bed 3,Bedroom 3|Entry,Entry|Family,Family|Garage,Garage|Kitchen,Kitchen|Ldry,Laundry|Meals,Meals|Porch,Porch|Study Nook,Study Nook|w.i.r,Walk in Robe|wc,WC|Bath,Bathroom|Rear Passage,Rear Passage",

         }
    */

    override init() {
        super.init()
        
        
    }
    
    
    
    init(_ dict: [String: Any]) {
        super.init()
        
        if dict.keys.count == 0 {
            emptyValues()
            return
        }
        
                
        Id = (dict["Id"] as? NSNumber ?? 0).stringValue
        packageId = (dict["PackageId"] as? NSNumber ?? 0).stringValue
        print("---------------------------")
        print(packageId)
        print("=---------------------------")
        houseId_LandBank = (dict["HouseId_LandBank"] as? NSNumber ?? 0).stringValue
        
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
        
        
        //Mohan
        standardFacades = String.checkNullValue((dict["StandardFacades"] ?? "") as Any)
        facadeImageName = String.checkNullValue((dict["FacadeImageName"] ?? "") as Any)
//        houseDimensions_HouseName = String.checkNullValue((dict["HouseDimensions_HouseName"] ?? "") as Any)
        validFacades = String.checkNullValue((dict["ValidFacades"] ?? "") as Any)
        visualiseFacade = String.checkNullValue((dict["VisualiseFacade"] ?? "") as Any)
        palettes = String.checkNullValue((dict["Palettes"] ?? "") as Any)
        defaultPalette = String.checkNullValue((dict["DefaultPalette"] ?? "") as Any)

        houseLength = (dict["HouseLength"] as? NSNumber ?? 0).stringValue
        houseWidth = (dict["HouseWidth"] as? NSNumber ?? 0).stringValue
        livingAreasq = (dict["LivingAreasq"] as? NSNumber ?? 0).stringValue
        livingAreasqm = (dict["LivingAreasqm"] as? NSNumber ?? 0).stringValue
        totalSizesq = (dict["TotalSizesq"] as? NSNumber ?? 0).stringValue
        totalSizesqm = (dict["TotalSizesqm"] as? NSNumber ?? 0).stringValue
        alfrescosqm = (dict["Alfrescosqm"] as? NSNumber ?? 0).stringValue
        firstFloorsq = (dict["FirstFloorsq"] as? NSNumber ?? 0).stringValue
        firstFloorsqm = (dict["FirstFloorsqm"] as? NSNumber ?? 0).stringValue
        garagesq = (dict["Garagesq"] as? NSNumber ?? 0).stringValue
        garagesqm = (dict["Garagesqm"] as? NSNumber ?? 0).stringValue
        groundFloorsq = (dict["GroundFloorsq"] as? NSNumber ?? 0).stringValue
        groundFloorsqm = (dict["GroundFloorsqm"] as? NSNumber ?? 0).stringValue
        porchsq = (dict["Porchsq"] as? NSNumber ?? 0).stringValue
        porchsqm = (dict["Porchsqm"] as? NSNumber ?? 0).stringValue
        livingsqm = (dict["Livingsqm"] as? NSNumber ?? 0).stringValue
        mealssqm = (dict["Mealssqm"] as? NSNumber ?? 0).stringValue
        familysqm = (dict["Familysqm"] as? NSNumber ?? 0).stringValue
        bed1sqm = (dict["Bed1sqm"] as? NSNumber ?? 0).stringValue
        bed2sqm = (dict["Bed2sqm"] as? NSNumber ?? 0).stringValue
        bed3sqm = (dict["Bed3sqm"] as? NSNumber ?? 0).stringValue
        bed4sqm = (dict["Bed4sqm"] as? NSNumber ?? 0).stringValue

        
        collectionUrl = String.checkNullValue((dict["CollectionUrl"] ?? "") as Any)
        facadeMediumImageUrls = (dict["FacadeMediumImageUrls"] ?? NSArray ()) as? NSArray
        videoURL = String.checkNullValue((dict["VideoURL"] ?? "") as Any)
        
        visualisation = (dict["Visualisation"] as? NSNumber ?? 0).boolValue

        
        
        edgeImages = (dict["EdgeImages"] ?? NSArray ()) as? NSArray
        sliderImages = (dict["SliderImages"] ?? NSArray ()) as? NSArray
        displaysList = (dict["DisplaysList"] ?? NSArray ()) as? NSArray

        
        
    }
    
    
    func emptyValues () {
        
        Id = ""
        packageId = ""
        houseId_LandBank = ""
        
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
        
        //Mohan
        standardFacades = ""
        facadeImageName = ""
        houseDimensions_HouseName = NSArray ()
        validFacades = ""
        visualiseFacade = ""
        palettes = ""
        defaultPalette = ""
        
        houseLength = ""
        houseWidth = ""
        livingAreasq = ""
        livingAreasqm = ""
        totalSizesq = ""
        totalSizesqm = ""
        alfrescosqm = ""
        firstFloorsq = ""
        firstFloorsqm = ""
        garagesq = ""
        garagesqm = ""
        groundFloorsq = ""
        groundFloorsqm = ""
        porchsq = ""
        porchsqm = ""
        livingsqm = ""
        mealssqm = ""
        familysqm = ""
        bed1sqm = ""
        bed2sqm = ""
        bed3sqm = ""
        bed4sqm = ""
        
        collectionUrl = ""
        facadeMediumImageUrls = NSArray ()
        videoURL = ""
        
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
