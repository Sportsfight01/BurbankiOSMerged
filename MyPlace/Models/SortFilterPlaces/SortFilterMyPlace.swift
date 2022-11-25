//
//  SortFilterMyPlace.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 02/04/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import Foundation

extension String {
    static func none () -> String {
        return "--"
    }
    static func zero () -> String {
        return "0"
    }
    static func empty () -> String {
        return ""
    }
}


enum Storeys : String {
    case none = "", one = "SINGLE", two = "DOUBLE", ALL = "ALL"
}

enum BedRooms: String {
    case none = "", three = "3", four = "4", five = "5+", six = "6+", ALL = "ALL"
}

enum CarSpaces: String {
    case none = "", one = "1", two = "2", ALL = "ALL"
}

enum Bathrooms_New: String {
    case none = "", two = "2", three = "3+", ALL = "ALL"
}

enum PriceSort : String {
    case lowtoHigh = "lowtoHigh", hightoLow = "hightoLow", Estate = "Estate", Suburb = "Suburb"
}


class State: NSObject {

    var stateName: String = String.empty()
    var stateId: String = String.zero()
    
    override init() {
        super.init()
    }
    
    init(dict: NSDictionary) {
        super.init()

        stateName = String.checkNullValue (dict.value(forKey: "Name") as Any)
        stateId = String.checkNumberNull(dict.value(forKey: "Id") as Any)
    }
    
}


class RegionMyPlace: NSObject {
    
    var regionName: String = String.empty()
    var regionId: String = String.zero()
    var regionLatitude: String = ""
    var regionLongitude: String = ""
    var regionStateFolderName : String = ""
    var regionStateShortName : String = ""
    
    var state = State.init()
    var isSelected = false
        
    override init() {
        super.init()
    }
    
    
    init(dict: NSDictionary) {
        super.init()
        
        regionId = String.checkNumberNull (dict.value(forKey: "RegionId") as Any)

        regionName = String.checkNullValue (dict.value(forKey: "RegionName") as Any)
        regionLatitude = String.checkNullValue (dict.value(forKey: "Latitudefield") as Any)
        regionLongitude = String.checkNullValue (dict.value(forKey: "Longitudefield") as Any)
        regionStateFolderName = String.checkNullValue (dict.value(forKey: "StateFolderName") as Any)
        regionStateShortName = String.checkNullValue (dict.value(forKey: "StateShortName") as Any)
        state.stateId = String.checkNumberNull (dict.value(forKey: "") as Any)
    }
    
    
    init(recentSearch: NSDictionary) {
        super.init()
        
        regionId = String.checkNumberNull (recentSearch.value(forKey: "Id") as Any)

        regionName = String.checkNullValue (recentSearch.value(forKey: "RegionName") as Any)
        
        let address = recentSearch.value(forKey: "RegionAddress") as? [String: Any]
        
        if let add = address {
            regionLatitude = (add["Latitudefield"] as! NSNumber).stringValue
            regionLongitude = (add["Longitudefield"] as! NSNumber).stringValue
        }
        
        regionStateFolderName = String.checkNullValue (recentSearch.value(forKey: "StateFolderName") as Any)
        regionStateShortName = String.checkNullValue (recentSearch.value(forKey: "StateShortName") as Any)
    }
    

}




class PriceRange: NSObject {
    
//    var priceStart: String?
//    var priceEnd: String?
    
    var priceStart: Double = 0
    var priceEnd: Double = 1
    
    
    var priceRangeCounts = [0, 0, 0, 0, 0, 0, 0]
    var priceRangeList = [NSDictionary]()
    
    var totalCount = 0
    
    
    var priceDivisionCount1 = 0
    var priceDivisionCount2 = 0
    var priceDivisionCount3 = 0
    var priceDivisionCount4 = 0
    var priceDivisionCount5 = 0
    var priceDivisionCount6 = 0
    var priceDivisionCount7 = 0
    
    
    var priceStartStringValue: String {
        return NSNumber(value: Int(priceStart)).stringValue
    }

    var priceEndStringValue: String {
        return NSNumber(value: Int(priceEnd)).stringValue
    }

    
    func newPriceRange () -> PriceRange {
        
        let newprice = PriceRange ()
        
        newprice.priceStart = priceStart
        newprice.priceEnd = priceEnd
        
        newprice.priceRangeCounts = priceRangeCounts
        newprice.totalCount = totalCount
        newprice.priceRangeList = priceRangeList
        
        return newprice
    }
    
    
    override init() {
        super.init()
    }
    
    init(dict: NSDictionary, recentSearch: Bool) {
        super.init()
        
        priceStart = Double(exactly: (dict.value(forKey: "MinPrice") ?? 0) as! NSNumber)! //NSNumber(value: dict.value(forKey: "MinPrice")).doubleValue
        priceEnd = Double(exactly: (dict.value(forKey: "MaxPrice") ?? 0) as! NSNumber)! //dict.value(forKey: "MaxPrice")

        
        if priceStart == priceEnd {
            priceEnd = priceEnd + 1000
        }
        
        if recentSearch {
            
        }else {
            priceEnd = priceEnd + 1000
        }
        
        if priceStart > 999 {
            priceStart = Double(Int(priceStart/1000))
        }
        
        if priceEnd > 999 {
            priceEnd = Double(Int(priceEnd/1000))
        }
        
    }
    
    
    init(dict: NSDictionary) {
        super.init()
        
        priceStart = Double(exactly: ((dict.value(forKey: "PriceRange") as! NSDictionary).value(forKey: "MinPrice") ?? 0) as! NSNumber)! //NSNumber(value: dict.value(forKey: "MinPrice")).doubleValue
        priceEnd = Double(exactly: ((dict.value(forKey: "PriceRange") as! NSDictionary).value(forKey: "MaxPrice") ?? 0) as! NSNumber)! //dict.value(forKey: "MaxPrice")
        
        if priceStart == priceEnd {
            priceEnd = priceEnd + 1000
        }
//        priceEnd = priceEnd + 10
        
        if priceStart > 1000 {
            priceStart = Double(Int(priceStart/1000))
        }
        
        if priceEnd > 1000 {
            priceEnd = Double(Int(priceEnd/1000))
        }
        
        
        totalCount = (dict.value(forKey: "HnLQuizResults") as? NSNumber ?? 0).intValue
        priceRangeCounts = dict.value(forKey: "CountDistribution") as! [Int]
        priceRangeList = dict.value(forKey: "PriceListRange") as! [NSDictionary]
        
        
//        "HnLQuizResults": 3043,
//          "PriceRange": {
//            "MinPrice": 321805,
//            "MaxPrice": 1318400
//          },
//          "CountDistribution": [
//            426,
//            1880,
//            591,
//            113,
//            26,
//            5,
//            2
//          ],
//          "Storeys": [
//            1,
//            2
//          ],
//          "Bedrooms": [
//            3,
//            4,
//            5
//          ],
//          "carspaces": [
//            2,
//            1
//          ],
//          "Bathrooms": [
//            2,
//            4,
//            1
//          ]
//        }
    
    }
        
    
    
}




class SortFilter: NSObject {
        
//    var region: Region_MyPlace = .none
    
    var searchType: Int = 0
    
    var region: RegionMyPlace = RegionMyPlace.init()
    var regionsArr = [RegionMyPlace]()
    
    var storeysCount: Storeys = .none
    var bedRoomsCount: BedRooms = .none
    var CarSpacesCount: CarSpaces = .none
    var BathRoomsCount: Bathrooms_New = .none

    
    var priceSorting: PriceSort = .lowtoHigh


    var priceRange: PriceRange = PriceRange()
    var defaultPriceRange: PriceRange = PriceRange()
    
    
    
    func newFilter () -> SortFilter {
        
        let newfilter = SortFilter ()
        
        newfilter.region = RegionMyPlace ()
        newfilter.region.regionId = self.region.regionId
        newfilter.region.regionName = self.region.regionName
        newfilter.region.regionLatitude = self.region.regionLatitude
        newfilter.region.regionLongitude = self.region.regionLongitude
        
        
        newfilter.searchType = self.searchType
        newfilter.regionsArr = self.regionsArr
        
        
        newfilter.storeysCount = self.storeysCount
        newfilter.bedRoomsCount = self.bedRoomsCount
        newfilter.CarSpacesCount = self.CarSpacesCount
        newfilter.BathRoomsCount = self.BathRoomsCount

        
        newfilter.priceSorting = self.priceSorting


        newfilter.priceRange = priceRange.newPriceRange()
        newfilter.defaultPriceRange = defaultPriceRange.newPriceRange()
        
        
        return newfilter
    }
    
    
    override init() {
        super.init()
        
    }
    
    init(dict: NSDictionary, recentsearch: Bool) {
        super.init()

        if let regions = dict.value(forKey: "Regions") as? [NSDictionary] {
            if regions.count > 0 {
                region = RegionMyPlace (recentSearch: regions[0])
                for i in regions{
                    regionsArr.append(RegionMyPlace (recentSearch: i))
                }
                
            }
        }
        
        var bathroomChecks = 0
        
        for bathroomFilters in dict.value(forKey: "BathRoomFilters") as! [NSDictionary] {
            if (bathroomFilters.value(forKey: "IsChecked") as? Bool) == true {
                
                let value = String.checkNumberNull (bathroomFilters.value(forKey: "Value") as Any)
                
                if value == "2" {
                    BathRoomsCount = .two
                }else if value == "3" {
                    BathRoomsCount = .three
                }
                
                bathroomChecks = bathroomChecks + 1
                
                if bathroomChecks > 1 {
                    BathRoomsCount = .ALL
                    break
                }
            }
        }
        
        
        
//        var bedroomChecks = 0
        
        var bedroom3 = false
        var bedroom4 = false
        var bedroom5 = false
        var bedroom6 = false
        
        for bedroomFilters in dict.value(forKey: "BedRoomFilters") as! [NSDictionary] {
            
            if (bedroomFilters.value(forKey: "IsChecked") as? Bool) == true {
                
                let value = String.checkNumberNull (bedroomFilters.value(forKey: "Value") as Any)
                
                if value == "3" {
                    bedroom3 = true
                }else if value == "4" {
                    bedroom4 = true
                }else if value == "5" {
                    bedroom5 = true
                }else if value == "6" {
                    bedroom6 = true
                }
            }
        }
        
//        if bedroom6 {
//            bedRoomsCount = .six
//        }
//        if bedroom5 {
//            bedRoomsCount = .five
//        }
//        if bedroom4 {
//            bedRoomsCount = .four
//        }
//        if bedroom3 {
//            bedRoomsCount = .ALL
//        }
      if bedroom3 && bedroom4 && bedroom5 && bedroom6 {
        bedRoomsCount = .ALL
      }
        else if bedroom3 {
            bedRoomsCount = .three
        }
        else if bedroom4 {
            bedRoomsCount = .four
        }        
        else if bedroom5, bedroom6 {
            bedRoomsCount = .five
        }else if bedroom6 {
            bedRoomsCount = .six
        }
        
        
        
        var carSpacesChecks = 0
        
        for carSpacesFilter in dict.value(forKey: "CarSpaces") as! [NSDictionary] {
            if (carSpacesFilter.value(forKey: "IsChecked") as? Bool) == true {
                
                let value = String.checkNumberNull (carSpacesFilter.value(forKey: "Value") as Any)
                
                if value == "1" {
                    CarSpacesCount = .one
                }else if value == "2" {
                    CarSpacesCount = .two
                }
                
                carSpacesChecks = carSpacesChecks + 1
                
                if carSpacesChecks > 1 {
                    CarSpacesCount = .ALL
                    break
                }
            }
        }
        
        
        var storeyChecks = 0
        
        for storeysFilter in dict.value(forKey: "StoreyFilters") as! [NSDictionary] {
            if (storeysFilter.value(forKey: "IsChecked") as? Bool) == true {
                
                let value = String.checkNumberNull (storeysFilter.value(forKey: "Value") as Any)
                
                if value == "1" {
                    storeysCount = .one
                }else if value == "2" {
                    storeysCount = .two
                }
                
                storeyChecks = storeyChecks + 1
                
                if storeyChecks > 1 {
                    storeysCount = .ALL
                    break
                }
            }
        }
        
        
        defaultPriceRange = PriceRange(dict: dict, recentSearch: recentsearch)
        priceRange = PriceRange(dict: dict, recentSearch: recentsearch)
        
        
        
//        {
//            ActualMaxHomeSize = 0;
//            ActualMaxLotWidth = 0;
//            ActualMaxPrice = 0;
//            ActualMinHomeSize = 0;
//            ActualMinLotWidth = 0;
//            ActualMinPrice = 0;
//            BathRoomFilters =         (
//                            {
//                    DisplayName = 2;
//                    IsChecked = 1;
//                    Value = 2;
//                },
//                            {
//                    DisplayName = "3+";
//                    IsChecked = 1;
//                    Value = 3;
//                }
//            );
//            BedRoomFilters =         (
//                            {
//                    DisplayName = 3;
//                    IsChecked = 1;
//                    Value = 3;
//                },
//                            {
//                    DisplayName = 4;
//                    IsChecked = 1;
//                    Value = 4;
//                },
//                            {
//                    DisplayName = "5+";
//                    IsChecked = 1;
//                    Value = 5;
//                }
//            );
//            CarSpaces =         (
//                            {
//                    DisplayName = 1;
//                    IsChecked = 1;
//                    Value = 1;
//                },
//                            {
//                    DisplayName = 2;
//                    IsChecked = 1;
//                    Value = 2;
//                }
//            );
//            CollectionFilters = "<null>";
//            Estates = "<null>";
//            HouseNames = "<null>";
//            IncludeSurroundingSuburbs = "<null>";
//            MaxHomeSize = 458;
//            MaxLotWidth = 0;
//            MaxPrice = 350000;
//            MinHomeSize = 140;
//            MinLotWidth = 0;
//            MinPrice = 150000;
//            PageNo = 0;
//            Regions = "<null>";
//            SearchText = "<null>";
//            SelectedEstates = "<null>";
//            SelectedSuburbs = "<null>";
//            SortBy = price;
//            StateId = 0;
//            StoreyFilters =         (
//                            {
//                    DisplayName = Single;
//                    IsChecked = 1;
//                    Value = 1;
//                },
//                            {
//                    DisplayName = Double;
//                    IsChecked = 1;
//                    Value = 2;
//                }
//            );
//            Suburbs = "<null>";
//        }
    }
    
    init (values: NSDictionary) {
        super.init()
        
        self.defaultPriceRange = PriceRange (dict: values)
        self.priceRange = PriceRange (dict: values)

    }
    
    
    func serviceModal () -> NSMutableDictionary {
                
        let carSpaces = NSMutableArray()//Single    Double
        carSpaces.add(self.filterWith(value: 1, checked: true, name: "1"))
        carSpaces.add(self.filterWith(value: 2, checked: true, name: "2"))
        
        if CarSpacesCount == .one {
            carSpaces.replaceObject(at: 1, with: self.filterWith(value: 2, checked: false, name: "1"))
        }else if CarSpacesCount == .two {
            carSpaces.replaceObject(at: 0, with: self.filterWith(value: 1, checked: false, name: "2"))
        }

        
        let storeyFil = NSMutableArray()
        storeyFil.add(self.filterWith(value: 1, checked: true, name: "Single"))
        storeyFil.add(self.filterWith(value: 2, checked: true, name: "Double"))

        if storeysCount == .one {
            storeyFil.replaceObject(at: 1, with: self.filterWith(value: 2, checked: false, name: "Double"))
        }else if storeysCount == .two {
            storeyFil.replaceObject(at: 0, with: self.filterWith(value: 1, checked: false, name: "Single"))
        }


        let bedroomFil = NSMutableArray()
        bedroomFil.add(self.filterWith(value: 3, checked: true, name: "3"))
        bedroomFil.add(self.filterWith(value: 4, checked: true, name: "4"))
        bedroomFil.add(self.filterWith(value: 5, checked: true, name: "5"))
        bedroomFil.add(self.filterWith(value: 6, checked: true, name: "6"))


        if bedRoomsCount == .three {
            bedroomFil.replaceObject(at: 1, with: self.filterWith(value: 4, checked: false, name: "4"))
            bedroomFil.replaceObject(at: 2, with: self.filterWith(value: 5, checked: false, name: "5"))
            bedroomFil.replaceObject(at: 3, with: self.filterWith(value: 6, checked: false, name: "6"))

        }else if bedRoomsCount == .four {
            bedroomFil.replaceObject(at: 0, with: self.filterWith(value: 3, checked: false, name: "3"))
            
            bedroomFil.replaceObject(at: 2, with: self.filterWith(value: 5, checked: false, name: "5"))
            bedroomFil.replaceObject(at: 3, with: self.filterWith(value: 6, checked: false, name: "6"))

        }else if bedRoomsCount == .five { //5+ , so not doing false for 6
            bedroomFil.replaceObject(at: 0, with: self.filterWith(value: 3, checked: false, name: "3"))
            bedroomFil.replaceObject(at: 1, with: self.filterWith(value: 4, checked: false, name: "4"))
        }
        else if bedRoomsCount == .six {
            bedroomFil.replaceObject(at: 0, with: self.filterWith(value: 3, checked: false, name: "3"))
            bedroomFil.replaceObject(at: 1, with: self.filterWith(value: 4, checked: false, name: "4"))
            bedroomFil.replaceObject(at: 2, with: self.filterWith(value: 5, checked: false, name: "5"))

        }

       
        let bathroomFil = NSMutableArray()
        bathroomFil.add(self.filterWith(value: 2, checked: true, name: "2"))
        bathroomFil.add(self.filterWith(value: 3, checked: true, name: "3+"))

        if BathRoomsCount == .two {
            bathroomFil.replaceObject(at: 1, with: self.filterWith(value: 3, checked: false, name: "3+"))
        }else if BathRoomsCount == .three {
            bathroomFil.replaceObject(at: 0, with: self.filterWith(value: 2, checked: false, name: "2"))
        }

        
        let regions = NSMutableArray ()
        
        for i in 0..<regionsArr.count{
            let address = NSMutableDictionary ()
            address.setValue(regionsArr[i].regionLatitude, forKey: "Latitudefield")
            address.setValue(regionsArr[i].regionLongitude, forKey: "Longitudefield")
            let regionDict = NSMutableDictionary()
            regionDict.setValue(regionsArr[i].regionName, forKey: "RegionName")
            regionDict.setValue(address, forKey: "RegionAddress")
            
            regions.add(regionDict)

        }
        /* Naveen Commented this for multiple regions feature
         
        if self.region.regionName.count > 0 {
            
            let address = NSMutableDictionary ()
            address.setValue(self.region.regionLatitude, forKey: "Latitudefield")
            address.setValue(self.region.regionLongitude, forKey: "Longitudefield")

            let regionDict = NSMutableDictionary()
            regionDict.setValue(self.region.regionName, forKey: "RegionName")
            regionDict.setValue(address, forKey: "RegionAddress")
            
            regions.add(regionDict)
        }
       */
        
        let dict = NSMutableDictionary.init(dictionary: NSDictionary(objects: [carSpaces, storeyFil, bedroomFil, bathroomFil, regions], forKeys: ["CarSpaces", "StoreyFilters", "BedRoomFilters", "BathRoomFilters", "Regions"] as [NSCopying]))
        
        
        dict.setValue(priceRange.priceStartStringValue.components(separatedBy: ".")[0] + "000", forKey: "MinPrice")
        dict.setValue(priceRange.priceEndStringValue.components(separatedBy: ".")[0] + "000", forKey: "MaxPrice")

        
        dict.setValue("140", forKey: "MinHomeSize")
        dict.setValue("458", forKey: "MaxHomeSize")

//        dict.setValue("0", forKey: "MinHomeSize")
//        dict.setValue("0", forKey: "MaxHomeSize")

        
        if priceSorting == .hightoLow || priceSorting == .lowtoHigh {
            dict.setValue("price", forKey: "SortBy")
        }else {
            dict.setValue(priceSorting.rawValue, forKey: "SortBy")
        }

        return dict
    }
    
    /*
     { "CarSpaces": [ { "Value": 1, "IsChecked": true, "DisplayName": "Single" }, { "Value": 2, "IsChecked": false, "DisplayName": "Double" } ], "MinHomeSize": 140, "MaxHomeSize": 454, "SortBy": "price", "PageNo": 1, "StoreyFilters": [ { "Value": 1, "IsChecked": false, "DisplayName": "Double" }, { "Value": 2, "IsChecked": true, "DisplayName": "Single" } ], "BedRoomFilters": [ { "Value": 3, "IsChecked": true, "DisplayName": "3" }, { "Value": 4, "IsChecked": false, "DisplayName": "4+" } ], "BathRoomFilters": [ { "Value": 2, "IsChecked": true, "DisplayName": "3" }, { "Value": 4, "IsChecked": false, "DisplayName": "4" }, { "Value": 5, "IsChecked": false, "DisplayName": "5+" }, ], "MinPrice": 364000, "MaxPrice": 782000, "StateId": 11 }
     */
    
    private func filterWith (value: Int, checked: Bool, name: String) -> NSDictionary {
        return NSDictionary(objects: [value, checked, name], forKeys: ["Value", "IsChecked", "DisplayName"] as [NSCopying])
    }
    
}









/*
 ViewController
 presenter/viewmodal
 serviceModal
 modal
 */
