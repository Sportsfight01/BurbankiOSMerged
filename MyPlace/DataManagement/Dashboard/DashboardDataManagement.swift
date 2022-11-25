//
//  DashboardDataManagement.swift
//  MyPlace
//
//  Created by Sreekanth tadi on 18/03/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit

class DashboardDataManagement: NSObject {
    
    
    static let shared = DashboardDataManagement()
    typealias packagesBlock = (_ packages: [HomeLandPackage]?) -> Void
    
    var arrPackagesBlocks = [packagesBlock]()
    
    // Method is for get all the packages based on state
    func getAllPackages (_ state: Int, _ activity: Bool = false , success: packagesBlock? = nil) {
        
        if let suc = success {
            arrPackagesBlocks.append(suc)
        }
        
        if NetworkingManager.shared.arrayPackagesTasks.count > 0 {
            return
        }
        
        
        let datatask = Networking.shared.POST_request(url: ServiceAPI.shared.URL_HomeLandAllPackages(kUserID, NSNumber(value: state).stringValue, page: 0), parameters: NSDictionary(), userInfo: nil, success: { (json, response) in
            
            if let result: AnyObject = json {
                
                let result = result as! NSDictionary
                
                if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {
                    
                    var homeLandPackages = [HomeLandPackage]()
                    
                    if (result.allKeys as! [String]).contains("lstpackages") {
                        
                        let lstPackages = result.value(forKey: "lstpackages") as! NSDictionary
                        
                        _ = lstPackages.value(forKey: "Filter") as! NSDictionary
                        let packagesResult = lstPackages.value(forKey: "Packages") as! [NSDictionary]
                        
                        
                        for package: NSDictionary in packagesResult {
                            
                            let homeLandPackage = HomeLandPackage(package as! [String : Any])
                            homeLandPackages.append(homeLandPackage)
                            
                            if MyPlacePackages.savePackage(homeLandPackage) {
                                
                            }else { print(log: "Package saving failed") }
                        }
                        
                    }
                    for suc in self.arrPackagesBlocks {
                        suc(homeLandPackages)
                    }
                    
                    self.arrPackagesBlocks.removeAll()
                    NetworkingManager.shared.arrayPackagesTasks.removeAllObjects()
                    
                }else { print(log: "no packages found") }
                
            }else {
                
            }
            
        }, errorblock: { (error, isJSONerror)  in
            
            if isJSONerror {
                
            }else {
                
            }
            
        }, progress: nil, showActivity: activity)
        
        
        
        if let task = datatask {
            NetworkingManager.shared.arrayPackagesTasks.add(task as Any)
        }
        
    }
    
    // Method is for get all the packages based on state and filter options
    func packagesWith (_ state: Int, _ page: Int, filter: SortFilter, success: packagesBlock? = nil) {
        
        var params: NSMutableDictionary = filter.serviceModal()
        params.setValue(state, forKey: "StateId")
        params.setValue(page, forKey: "PageNo")
        
        if filter.priceRange.priceStart == 0 || filter.priceRange.priceEnd == 1 {
            params = NSMutableDictionary ()
        }
        
        
        _ = Networking.shared.POST_request(url: ServiceAPI.shared.URL_HomeLandAllPackages(kUserID, NSNumber(value: state).stringValue, page: page), parameters: params, userInfo: nil, success: { (json, response) in
            
            if let result: AnyObject = json {
                
                let result = result as! NSDictionary
                
                if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {
                    
                    var homeLandPackages = [HomeLandPackage]()
                    
                    
                    if (result.allKeys as! [String]).contains("lstpackages") {
                        
                        
                        let lstPackages = result.value(forKey: "lstpackages") as! NSDictionary
                        
                        _ = lstPackages.value(forKey: "Filter") as! NSDictionary
                        let packagesResult = lstPackages.value(forKey: "Packages") as! [NSDictionary]
                        
                        
                        for package: NSDictionary in packagesResult {
                            
                            let homeLandPackage = HomeLandPackage(package as! [String : Any])
                            
                            if let region = homeLandPackage.region {
                                
                                print(log: region.lowercased())
                                //                            print(log: filter.region.rawValue.lowercased())
                                
                                //                            if filter.region.rawValue.lowercased().contains(region.lowercased()) {
                                homeLandPackages.append(homeLandPackage)
                                //                            }
                            }
                        }
                    }
                    if page == 1, homeLandPackages.count > 0 {
                        ProfileDataManagement.shared.saveRecentSearch (filter.serviceModal(), SearchType.shared.homeLand, kUserID, nil)
                    }
                    
                    if let succ = success {
                        succ(homeLandPackages)
                    }
                    
                }else {
                    print(log: "no packages found")
                    if let succ = success {
                        succ([])
                    }
                }
                
            }else {
                if let succ = success {
                    succ([])
                }
            }
            
        }, errorblock: { (error, isJSONerror)  in
            
            if isJSONerror {
                
            }else {
                
            }
            
            if let succ = success {
                succ([])
            }
            
        }, progress: nil)
        
        
    }
    
    
    //MARK: - Regions
    
    // Method is for get all the regions
    func getRegions (stateId: String, showActivity: Bool, _ succe: ((_ regions: [RegionMyPlace]?) -> Void)?) {
        
        _ = Networking.shared.POST_request(url: ServiceAPI.shared.URL_regions(stateId), parameters: NSDictionary (), userInfo: nil, success: { (json, response) in
            
            if let result: AnyObject = json {
                
                let result = result as! NSDictionary
                
                if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {
                    
                    let resultRegions = result.value(forKey: "States") as! [NSDictionary]
                    
                    if stateId == kUserState {
//
//                        var re = [RegionMyPlace]()
//                        for reg in resultRegions {
//                            re.append(RegionMyPlace.init(dict: reg))
//                        }
                        saveRegionstoDefaults(resultRegions as NSArray)
                        if let succ = succe {
                            succ(kStateRegions)
                        }
                    }else {
                        var re = [RegionMyPlace]()
                        for reg in resultRegions {
                            re.append(RegionMyPlace.init(dict: reg))
                        }
                        if let succ = succe {
                            succ(kStateRegions)
                        }
                    }
                    
                    
                }else {
                    print(log: "regions not found")
                    
                    if let succ = succe {
                        succ(nil)
                    }
                }
                
            }else {
                
                if let succ = succe {
                    succ(nil)
                }
            }
            
        }, errorblock: { (error, isJSONerror)  in
            
            if isJSONerror {
                
            }else {
                
            }
            
            if let succ = succe {
                succ(nil)
            }
            
        }, progress: nil, showActivity: showActivity)
        
    }
    
    
    
    //MARK: - Price Range
    // Method is for get all the minimum nd maximum price range
    func getPriceRanges (filter: SortFilter, succe: @escaping ((_ priceRange: PriceRange?) -> Void)) {
        
        //        let params = NSMutableDictionary()
        //        params.setValue(region, forKey: "Region")
        //        params.setValue(storeys, forKey: "Storeys")
        //        params.setValue(bedrooms, forKey: "Bedrooms")
        //        params.setValue(state, forKey: "StateId")
        
        let region = filter.region.regionName
        var storeys: Int {
            if filter.storeysCount == .one { return 1 }
            else if filter.storeysCount == .two { return 2 }
            else { return 0 }
        }
        
        //        var bedrooms: Int {
        //            if filter.bedRoomsCount == .three { return 3 }
        //            else if filter.bedRoomsCount == .four { return 4 }
        //            else if filter.bedRoomsCount == .five { return 5 }
        //            else { return 0 }
        //        }
        
        var bedrooms: [Int] {
            if filter.bedRoomsCount == .three { return [3,4,5,6] }
            else if filter.bedRoomsCount == .four { return [4,5,6] }
            else if filter.bedRoomsCount == .five { return [5,6] }
            else if filter.bedRoomsCount == .six { return [6] }
            
            else { return [3,4,5,6] }
        }
        
        var minPrice: String {
            return "0"
            
            //            if filter.priceRange.priceStart > 0 {
            //                return NSNumber(value: Int(filter.priceRange.priceStart)).stringValue + "000"
            //            }else {
            //            }
        }
        
        var maxPrice: String {
            return "0"
            //            if filter.priceRange.priceEnd > 1 {
            //                return NSNumber(value: Int(filter.priceRange.priceEnd)).stringValue + "000"
            //            }else {
            //            }
        }
        
        
        let params1 = NSMutableDictionary()
        params1.setValue(region, forKey: "Region")
        params1.setValue(storeys, forKey: "Storey")
        params1.setValue(bedrooms, forKey: "BedRooms")
        params1.setValue(kUserState, forKey: "StateId")
        params1.setValue(minPrice, forKey: "Minvalue")
        params1.setValue(maxPrice, forKey: "Maxvalue")
        
        
        let params = NSDictionary.init(objects: [params1 as Any], forKeys: ["homeAndLandQuiz" as NSCopying])
        
        _ = Networking.shared.POST_request(url: ServiceAPI.shared.URL_priceRanges, parameters: params, userInfo: nil, success: { (json, response) in
            
            if let result: AnyObject = json {
                
                let result = result as! NSDictionary
                
                if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {
                    
                    if (result.allKeys as! [String]).contains("Price") {
                        
                        let resultPrices = result.value(forKey: "Price") as! NSDictionary
                        
                        let range = PriceRange(dict: resultPrices, recentSearch: false)
                        
                        succe (range)
                    }else {
                        print(log: "Price not found")
                        
                        succe (nil)
                    }
                    
                }else {
                    print(log: "Price not found")
                    
                    succe (nil)
                }
                
            }else {
                
                succe (nil)
            }
            
        }, errorblock: { (error, isJSONerror) in
            
            if isJSONerror {
                
            }else {
                
            }
            succe (nil)
            
        }, progress: nil)
        
        
    }
    
    
    //MARK: - Designs Count
    // Method is for get all the packages based on filter
    func getHomeLandFilterValues (with filter: SortFilter, succe: @escaping ((_ newFilter: SortFilter) -> Void)) -> Any? {
        
        let region = filter.region.regionName
        let regionsArr =  filter.regionsArr.map{ $0.regionName }
        print("----1-1-1-1-1,",regionsArr)
        let regions = regionsArr.joined(separator: ",")
        print("----1-1-1-1-1,",regions)
        var storeys: [Int] {
            if filter.storeysCount == .one { return [1] }
            else if filter.storeysCount == .two { return [2] }
            else { return [1, 2] }
        }
        
        var bedrooms: [Int] {
            //            if filter.bedRoomsCount == .three { return [3,4,5,6] }
            //            else if filter.bedRoomsCount == .four { return [4,5,6] }
            if filter.bedRoomsCount == .three { return [3] }
            else if filter.bedRoomsCount == .four { return [4] }
            else if filter.bedRoomsCount == .five { return [5,6] }
            else if filter.bedRoomsCount == .six { return [6] }
            
            else { return [3,4,5,6] }
        }
        
        var carSpaces: [Int] {
            if filter.CarSpacesCount == .one { return [1] }
            else if filter.CarSpacesCount == .two { return [2] }
            else { return [1,2] }
        }
        
        var bathrooms: [Int] {
            if filter.BathRoomsCount == .two { return [2] }
            else if filter.BathRoomsCount == .three { return [3,4,5,6] }
            else { return [1,2,3,4,5,6] }
        }
        
        
        var minPrice: String {
            if filter.priceRange.priceStart > 0 {
                return filter.priceRange.priceStartStringValue + "000"
                //                return NSNumber(value: Int(filter.priceRange.priceStart)).stringValue + "000"
            }else {
                return "0"
            }
        }
        
        var maxPrice: String {
            if filter.priceRange.priceEnd > 1 {
                return filter.priceRange.priceEndStringValue + "000"
                //                return NSNumber(value: Int(filter.priceRange.priceEnd)).stringValue + "000"
            }else {
                return "0"
            }
        }
        
        let params1 = NSMutableDictionary()
        params1.setValue(regions, forKey: "Region")
        
        // params1.setValue(bedrooms > 0 ? NSArray (object: bedrooms) : NSArray (), forKey: "BedRooms")
        // params1.setValue(bathrooms > 0 ? NSArray (object: bathrooms) : NSArray (), forKey: "Bathrooms")
        
        params1.setValue(storeys, forKey: "Storey")
        params1.setValue(bedrooms, forKey: "BedRooms")
        params1.setValue(carSpaces, forKey: "CarSpaces")
        params1.setValue(bathrooms, forKey: "Bathrooms")
        
        params1.setValue(kUserState, forKey: "StateId")
        params1.setValue(minPrice, forKey: "SelectedMinValue")
        params1.setValue(maxPrice, forKey: "SelectedMaxValue")
        params1.setValue(0, forKey: "IncludePackages")
        params1.setValue(0, forKey: "PageNo")
        params1.setValue(filter.priceSorting == .hightoLow ? 1 : 0 , forKey: "SortByPrice")
        
        
        let params = NSDictionary.init(objects: [params1 as Any], forKeys: ["HnLQuizItems" as NSCopying])
        
        
        let datatask = Networking.shared.POST_request(url: ServiceAPI.shared.URL_packagesFilter (kUserID), parameters: params, userInfo: nil, success: { (json, response) in
            
            if let result: AnyObject = json {
                
                let result = result as! NSDictionary
                
                if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {
                    
                    let filterNew = SortFilter (values: result)
                    succe (filterNew)
                    
                    //                    if (result.allKeys as! [String]).contains("HomeAndLandQuizCount") {
                    
                    //                        let count = String.checkNumberNull(result.value(forKey: "HomeAndLandQuizCount") as Any)
                    
                    //                        filterNew.
                    //                    fatalError()
                    
                    
                    //                        succe (Int(count)!)
                    //                    }else {
                    //                        print(log: "count not found")
                    //
                    ////                        succe (0)
                    //                    }
                    
                }else {
                    print(log: "count not found")
                    
                    succe (SortFilter ())
                }
                
            }else {
                
                succe ( SortFilter ())
            }
            
        }, errorblock: { (error, isJSONerror) in
            
            if isJSONerror {
                
            }else {
                
            }
            succe (SortFilter ())
            
        }, progress: nil)
        
        
        if let task = datatask {
            return task
        }else {
            return nil
        }
        
    }
    
    // Method is for get all the packages based on filter
    func getHomeLandPackagesWithFilterValues (with filter: SortFilter, _ page: Int, succe: packagesBlock? = nil) {
        
        let region = filter.region.regionName
        let regionsArr =  filter.regionsArr.map{ $0.regionName }
        print("----1-1-1-1-1,",regionsArr)
        let regions = regionsArr.joined(separator: ",")
        print("----1-1-1-1-1,",regions)
        
        var storeys: Int {
            if filter.storeysCount == .one { return 1 }
            else if filter.storeysCount == .two { return 2 }
            else { return 0 }
        }
        
        var bedrooms: [Int] {
            if filter.bedRoomsCount == .three { return [3] }
            else if filter.bedRoomsCount == .four { return [4] }
            else if filter.bedRoomsCount == .five { return [5,6] }
            else if filter.bedRoomsCount == .six { return [6] }
            
            else { return [3,4,5,6] }
        }
        
        var carSpaces: [Int] {
            if filter.CarSpacesCount == .one { return [1] }
            else if filter.CarSpacesCount == .two { return [2] }
            
            else { return [1,2] }
        }
        
        var bathrooms: [Int] {
            if filter.BathRoomsCount == .two { return [2] }
            else if filter.BathRoomsCount == .three { return [3, 4, 5, 6] }
            
            else { return [1,2,3,4,5,6] }
        }
        
        var minPrice: String {
            if filter.priceRange.priceStart > 0 {
                return filter.priceRange.priceStartStringValue + "000"
                //                return NSNumber(value: Int(filter.priceRange.priceStart)).stringValue + "000"
            }else {
                return "0"
            }
        }
        
        var maxPrice: String {
            if filter.priceRange.priceEnd > 1 {
                return filter.priceRange.priceEndStringValue + "000"
                //                return NSNumber(value: Int(filter.priceRange.priceEnd)).stringValue + "000"
            }else {
                return "0"
            }
        }
        
        
        
        let params1 = NSMutableDictionary()
        params1.setValue(regions, forKey: "Region")
        
        params1.setValue(storeys > 0 ? NSArray (object: storeys) : NSArray (), forKey: "Storey")
        params1.setValue(bedrooms, forKey: "BedRooms")
        params1.setValue(carSpaces, forKey: "CarSpaces")
        params1.setValue(bathrooms, forKey: "Bathrooms")
        
        params1.setValue(kUserState, forKey: "StateId")
        params1.setValue(minPrice, forKey: "SelectedMinValue")
        params1.setValue(maxPrice, forKey: "SelectedMaxValue")
        params1.setValue(1, forKey: "IncludePackages")
        params1.setValue(page, forKey: "PageNo")
        params1.setValue(filter.priceSorting == .hightoLow ? 1 : 0 , forKey: "SortByPrice")
        
        
        let params = NSDictionary.init(objects: [params1 as Any], forKeys: ["HnLQuizItems" as NSCopying])
        
        
        _ = Networking.shared.POST_request(url: ServiceAPI.shared.URL_packagesFilter (kUserID), parameters: params, userInfo: nil, success: { (json, response) in
            
            if let result: AnyObject = json {
                
                let result = result as! NSDictionary
                
                if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {
                    
                    var homeLandPackages = [HomeLandPackage]()
                    
                    if (result.allKeys as! [String]).contains("HnLQuizPackages") {
                        
                        let packagesResult = result.value(forKey: "HnLQuizPackages") as! [NSDictionary]
                        
                        for package: NSDictionary in packagesResult {
                            
                            let homeLandPackage = HomeLandPackage(package as! [String : Any])
                            
                            if let region = homeLandPackage.region {
                                
                                print(log: region.lowercased())
                                
                                homeLandPackages.append(homeLandPackage)
                            }
                        }
                        
                        if page == 1, homeLandPackages.count > 0 {
                            ProfileDataManagement.shared.saveRecentSearch(filter.serviceModal(), SearchType.shared.homeLand, kUserID, nil)
                        }
                        
                    }
                    
                    if let succ = succe {
                        succ(homeLandPackages)
                    }
                    
                    
                }else {
                    print(log: "count not found")
                    
                    if let succ = succe {
                        succ([])
                    }
                }
                
            }else {
                
                if let succ = succe {
                    succ([])
                }
            }
            
        }, errorblock: { (error, isJSONerror) in
            
            if isJSONerror {
                
            }else {
                
            }
            
            if let succ = succe {
                succ([])
            }
            
        }, progress: nil)
        
        
    }
    
    
    
    //MARK: - For Sort Filter
    
    // Method is for get all the packages based on filter
    func getHomeLandPackagesCountForSortFilter (with filter: SortFilter, succe: @escaping ((_ newFilter: SortFilter) -> Void)) -> Any? {
        
        let datatask = Networking.shared.POST_request(url: ServiceAPI.shared.URL_packagesFilter (kUserID), parameters: parametersForHomeLandSortFilter(filter, page: 0), userInfo: nil, success: { (json, response) in
            
            if let result: AnyObject = json {
                
                let result = result as! NSDictionary
                
                if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {
                    
                    //                    if (result.allKeys as! [String]).contains("HomeAndLandQuizCount") {
                    
                    //                        let count = String.checkNumberNull(result.value(forKey: "HomeAndLandQuizCount") as Any)
                    
                    let filterNew = SortFilter (values: result)
                    //                        filterNew.
                    
                    succe (filterNew)
                    
                    //                        succe (Int(count)!)
                    //                    }else {
                    //                        print(log: "count not found")
                    //
                    ////                        succe (0)
                    //                    }
                    
                }else {
                    print(log: "count not found")
                    
                    succe (SortFilter ())
                }
                
            }else {
                
                succe ( SortFilter ())
            }
            
        }, errorblock: { (error, isJSONerror) in
            
            if isJSONerror {
                
            }else {
                
            }
            succe (SortFilter ())
            
        }, progress: nil)
        
        
        if let task = datatask {
            return task
        }else {
            return nil
        }
        
    }
    
    
    
    // Method is for get all the packages based on filter
    func getHomeLandPackagesForSortFilter (with filter: SortFilter, _ page: Int, succe: packagesBlock? = nil) {
        
        _ = Networking.shared.POST_request(url: ServiceAPI.shared.URL_packagesFilter (kUserID), parameters: parametersForHomeLandSortFilter(filter, page: page), userInfo: nil, success: { (json, response) in
            
            if let result: AnyObject = json {
                
                let result = result as! NSDictionary
                
                if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {
                    
                    var homeLandPackages = [HomeLandPackage]()
                    
                    if (result.allKeys as! [String]).contains("HnLQuizPackages") {
                        
                        let packagesResult = result.value(forKey: "HnLQuizPackages") as! [NSDictionary]
                        
                        for package: NSDictionary in packagesResult {
                            
                            let homeLandPackage = HomeLandPackage(package as! [String : Any])
                            
                            if let region = homeLandPackage.region {
                                
                                print(log: region.lowercased())
                                
                                homeLandPackages.append(homeLandPackage)
                            }
                        }
                        
                        if page == 1, homeLandPackages.count > 0 {
                            ProfileDataManagement.shared.saveRecentSearch(filter.serviceModal(), SearchType.shared.homeLand, kUserID, nil)
                        }
                        
                    }
                    
                    if let succ = succe {
                        succ(homeLandPackages)
                    }
                    
                    
                }else {
                    print(log: "count not found")
                    
                    if let succ = succe {
                        succ([])
                    }
                }
                
            }else {
                
                if let succ = succe {
                    succ([])
                }
            }
            
        }, errorblock: { (error, isJSONerror) in
            
            if isJSONerror {
                
            }else {
                
            }
            
            if let succ = succe {
                succ([])
            }
            
        }, progress: nil)
        
    }
    
    
    private func parametersForHomeLandSortFilter (_ filter: SortFilter, page: Int) -> NSDictionary {
        
        let region = filter.region.regionName
        var storeys: Int {
            if filter.storeysCount == .one { return 1 }
            else if filter.storeysCount == .two { return 2 }
            else { return 0 }
        }
        
        
        var bedrooms: [Int] {
            if filter.bedRoomsCount == .three { return [3] }
            else if filter.bedRoomsCount == .four { return [4] }
            else if filter.bedRoomsCount == .five { return [5,6] }
            else if filter.bedRoomsCount == .six { return [6] }
            
            else { return [3,4,5,6] }
        }
        
        var bathrooms: [Int] {
            if filter.BathRoomsCount == .two { return [2] }
            else if filter.BathRoomsCount == .three { return [3, 4, 5, 6, 7] }
            
            else { return [1, 2, 3, 4, 5, 6] }
        }
        
        var carSpaces: [Int] {
            if filter.CarSpacesCount == .one { return [1] }
            else if filter.CarSpacesCount == .two { return [2] }
            
            else { return [1, 2] }
        }
        
        
        var minPrice: String {
            if filter.priceRange.priceStart > 0 {
                return filter.priceRange.priceStartStringValue + "000"
                //                return NSNumber(value: Int(filter.priceRange.priceStart)).stringValue + "000"
            }else {
                return "0"
            }
        }
        
        var maxPrice: String {
            if filter.priceRange.priceEnd > 1 {
                return filter.priceRange.priceEndStringValue + "000"
                //                return NSNumber(value: Int(filter.priceRange.priceEnd)).stringValue + "000"
            }else {
                return "0"
            }
        }
        
        let params1 = NSMutableDictionary()
        params1.setValue(region, forKey: "Region")
        
        params1.setValue(storeys > 0 ? NSArray (object: storeys) : NSArray (), forKey: "Storey")
        params1.setValue(bedrooms, forKey: "BedRooms")
        params1.setValue(carSpaces, forKey: "CarSpaces")
        params1.setValue(bathrooms, forKey: "Bathrooms")
        
        params1.setValue(kUserState, forKey: "StateId")
        params1.setValue(minPrice, forKey: "SelectedMinValue")
        params1.setValue(maxPrice, forKey: "SelectedMaxValue")
        params1.setValue(1, forKey: "IncludePackages")
        params1.setValue(page, forKey: "PageNo")
        params1.setValue(filter.priceSorting == .hightoLow ? 1 : 0 , forKey: "SortByPrice")
        
        
        return NSDictionary.init(objects: [params1 as Any], forKeys: ["HnLQuizItems" as NSCopying])
    }
    
    
    
    //MARK: - Get DisplaysForRegionAndMap
    
    // Method is for get all the regions
    func getDisplaysForRegionAndMap (stateId: String,regionName: String, popularFlag:Bool,userId: String, showActivity: Bool, _ succe: ((_ nearbyPlaces: [NSDictionary]?) -> Void)?) {
        let params1 = NSMutableDictionary()
        params1.setValue(kUserID, forKey: "UserId")
        params1.setValue(regionName, forKey: "RegionName")
        params1.setValue(true, forKey: "PopularFlag")
        params1.setValue(kUserState, forKey: "StateId")
        
        
        //        let params = NSDictionary.init(objects: [params1 as Any], forKeys: ["" as NSCopying])
        
        _ = Networking.shared.POST_request(url: ServiceAPI.shared.URL_DisplaysForRegionAndMap(), parameters: params1, userInfo: nil, success: { (json, response) in
            
            if let result: AnyObject = json {
                
                let result = result as! NSDictionary
                
                if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {
                    
                    if let result: AnyObject = json {
                        if (result.allKeys as! [String]).contains("DisplaysByRegion") {
                            
                            let packagesResult = result.value(forKey: "DisplaysByRegion") as! [NSDictionary]
                            let data = NSKeyedArchiver.archivedData(withRootObject: packagesResult)
                            kUserDefaults.set(data, forKey: "DisplaysByRegionMap")
                            if let succ = succe {
                                succ(kNearByPlaces)
                            }
                        }else { print(log: "no SuggestedHomesData found") }
                        
                    }else {
                        
                    }
                }
            }
        }, errorblock: { (error, isJSONerror) in
            
            if isJSONerror { }
            else { }
            
        }, progress: nil)
    }
    
    //MARK: - Get NearByDisplays
    func getNearByDisplays(stateId: String,lat: String,long: String,UserID: Int, showActivity: Bool, _ succe: ((_ nearByDisplays: [NSDictionary]?) -> Void)?) {
        _ = Networking.shared.GET_request(url: ServiceAPI.shared.URL_DisplayNearByHomes(Int(kUserState) ?? 0, lat, long, UserID), userInfo: nil, success: { (json, response) in
            if let result: AnyObject = json {
                
                let result = result as! NSDictionary
                if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {
                    if let result: AnyObject = json {
                        if (result.allKeys as! [String]).contains("DisplaysByRegion") {
                            if (result.value(forKey: "DisplaysByRegion") as AnyObject).isKind(of: NSArray.self){
                            let packagesResult = result.value(forKey: "DisplaysByRegion") as! [NSDictionary]
                            let data = NSKeyedArchiver.archivedData(withRootObject: packagesResult)
                            kUserDefaults.set(data, forKey: "DisplaysByRegionMap")
                            if let succ = succe {
                                succ(kNearByPlaces)
                            }
                            }else if (result.value(forKey: "DisplaysByRegion") as AnyObject).isKind(of: NSString.self){
                                
                            }
                        }else { print(log: "no SuggestedHomesData found") }
                        
                    }else {
                        
                    }
                }
            }
        }, errorblock: { (error, isJSONerror) in
            
            if isJSONerror { }
            else { }
            
        }, progress: nil)
        
    }
    
    //MARK: - Get estate Details
    func getestateDetailsData (stateId: String,estateName: String, showActivity: Bool, _ succe: ((_ estateDetail: [houseDetailsByHouseType]?) -> Void)?) {
        _ = Networking.shared.GET_request(url: ServiceAPI.shared.URL_HouseDetailsByEstate(Int(kUserState) ?? 0, estateName ), userInfo: nil, success: { (json, response) in
            if let result: AnyObject = json {
                
                let result = result as! NSDictionary
                
                if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {
                    if let result: AnyObject = json {
                        if (result.allKeys as! [String]).contains("houseDetailsByHouseType") {
                            if (result.value(forKey: "houseDetailsByHouseType") as AnyObject).isKind(of: NSArray.self){
                            let packagesResult = result.value(forKey: "houseDetailsByHouseType") as! [NSDictionary]
                            let data = NSKeyedArchiver.archivedData(withRootObject: packagesResult)
                            kUserDefaults.set(data, forKey: "estateDetails")
                            if let succ = succe {
                                succ(kGetEstateDetails)
                            }
                            }else { print(log: "No HouseDetail found") }
                        }else { print(log: "No HouseDetail found") }
                        
                    }else {
                        
                    }
                }
            }
        }, errorblock: { (error, isJSONerror) in
            
            if isJSONerror { }
            else { }
            
        }, progress: nil)
        
    }
}


    
    
//}


/*
 //sample json data
 {
 ActualMaxHomeSize = 321;
 ActualMaxLotWidth = 13;
 ActualMaxPrice = 659000;
 ActualMinHomeSize = "160.38";
 ActualMinLotWidth = 8;
 ActualMinPrice = 385500;
 BathRoomFilters =         (
 {
 DisplayName = 2;
 IsChecked = 0;
 Value = 2;
 },
 {
 DisplayName = "3+";
 IsChecked = 0;
 Value = 3;
 }
 );
 BedRoomFilters =         (
 {
 DisplayName = 3;
 IsChecked = 0;
 Value = 3;
 },
 {
 DisplayName = "5+";
 IsChecked = 0;
 Value = 5;
 }
 );
 CarSpaces =         (
 {
 DisplayName = Single;
 IsChecked = 0;
 Value = 1;
 },
 {
 DisplayName = Double;
 IsChecked = 0;
 Value = 2;
 }
 );
 CollectionFilters =         (
 {
 CollectionImage = "<null>";
 DisplayName = Botanical;
 IsChecked = 0;
 Value = Botanical;
 }
 );
 Estates =         (
 "Aldinga Beach",
 Angus,
 Campbelltown,
 "Ferryden Park",
 "Happy Valley",
 "Kidman Park",
 Klemzig,
 "McCarron Estate",
 "Morphett Vale"
 );
 HouseNames =         (
 Bowden,
 Brompton,
 Prospect
 );
 IncludeSurroundingSuburbs =         {
 DisplayName = "<null>";
 IsChecked = 0;
 Value = 0;
 };
 MaxHomeSize = 321;
 MaxLotWidth = 13;
 MaxPrice = 659000;
 MinHomeSize = "160.38";
 MinLotWidth = 8;
 MinPrice = 385500;
 PageNo = 0;
 Regions = "<null>";
 SearchText = "<null>";
 SelectedEstates = "<null>";
 SelectedSuburbs = "<null>";
 SortBy = "<null>";
 StateId = 0;
 StoreyFilters =         (
 {
 DisplayName = Single;
 IsChecked = 0;
 Value = 1;
 },
 {
 DisplayName = Double;
 IsChecked = 0;
 Value = 2;
 }
 );
 Suburbs =         (
 "Aldinga Beach",
 Campbelltown,
 "Croydon Park",
 "Ferryden Park",
 "Happy Valley",
 "Kidman Park",
 Klemzig,
 "Mansfield Park",
 "Morphett Vale"
 );
 
 */

/*
 Filter =         {
 ActualMaxHomeSize = 300;
 ActualMaxLotWidth = 15;
 ActualMaxPrice = 477000;
 ActualMinHomeSize = "141.07";
 ActualMinLotWidth = 8;
 ActualMinPrice = 286900;
 BathRoomFilters =             (
 {
 DisplayName = 2;
 IsChecked = 0;
 Value = 2;
 },
 {
 DisplayName = "3+";
 IsChecked = 0;
 Value = 3;
 }
 );
 BedRoomFilters =             (
 {
 DisplayName = 3;
 IsChecked = 0;
 Value = 3;
 },
 {
 DisplayName = "4+";
 IsChecked = 0;
 Value = 4;
 }
 );
 CarSpaces =             (
 {
 DisplayName = Single;
 IsChecked = 0;
 Value = 1;
 },
 {
 DisplayName = Double;
 IsChecked = 0;
 Value = 2;
 }
 );
 CollectionFilters =             (
 {
 CollectionImage = "<null>";
 DisplayName = Botanical;
 IsChecked = 0;
 Value = Botanical;
 }
 );
 Estates =             (
 Aspire,
 "Christies Beach",
 Eyre,
 "Ferryden Park",
 Freeling,
 "Happy Valley",
 "Hepenstal Park",
 "Morphett Vale",
 "Sturt Ridge"
 );
 HouseNames =             (
 Brompton,
 Brooklyn,
 Medindie,
 Mitchell,
 Osmond,
 Prospect
 );
 IncludeSurroundingSuburbs =             {
 DisplayName = "<null>";
 IsChecked = 0;
 Value = 0;
 };
 MaxHomeSize = 300;
 MaxLotWidth = 15;
 MaxPrice = 477000;
 MinHomeSize = "141.07";
 MinLotWidth = 8;
 MinPrice = 286900;
 PageNo = 0;
 Regions = "<null>";
 SearchText = "<null>";
 SelectedEstates = "<null>";
 SelectedSuburbs = "<null>";
 SortBy = "<null>";
 StateId = 0;
 StoreyFilters =             (
 {
 DisplayName = Single;
 IsChecked = 0;
 Value = 1;
 },
 {
 DisplayName = Double;
 IsChecked = 0;
 Value = 2;
 }
 );
 Suburbs =             (
 "Christies Beach",
 Elizabeth,
 "Evanston South",
 "Ferryden Park",
 Freeling,
 Hackham,
 "Happy Valley",
 "Hindmarsh Island",
 "Morphett Vale"
 );
 }
 */

