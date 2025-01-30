//
//  MyCollection.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 26/03/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import Foundation


let key_myPlaceQuiz = "MyPlaceQuiz"


class MyPlaceQuiz: NSObject, NSCoding {
    
    
//    var sortfilter = SortFilter()
    
    var haveLand: String?
    var lotWidth: String?
    var storeysCount: String?
    var priceRangeLow, priceRangeHigh: String?
    var frontBedRoom: String?
    var bedRoomCount: String?
    var need_ALFRESCO: String?
    var need_STUDY: String?
    
    
    var region: String?
    
    
    override init() {
        super.init()
        
    }
    
    init(dic: [String : Any]) {
        super.init()
        haveLand = (dic["haveLand"] ?? "") as? String
        lotWidth = (dic["lotWidth"] ?? "") as? String
        storeysCount = (dic["storeysCount"] ?? "") as? String
        priceRangeLow = (dic["priceRangeLow"] ?? "") as? String
        priceRangeHigh = (dic["priceRangeHigh"] ?? "") as? String
        frontBedRoom = (dic["frontBedRoom"] ?? "") as? String
        bedRoomCount = (dic["bedRoomCount"] ?? "") as? String
        need_ALFRESCO = (dic["need_ALFRESCO"] ?? "") as? String
        need_STUDY = (dic["need_STUDY"] ?? "") as? String
        region = (dic["region"] ?? "") as? String
    }
    
    
    required convenience init(coder aDecoder: NSCoder) {
        
        let haveLand1 = aDecoder.decodeObject(forKey: "haveLand") as? String
        let lotWidth1 = aDecoder.decodeObject(forKey: "lotWidth") as? String
        let storeysCount1 = aDecoder.decodeObject(forKey: "storeysCount") as? String
        let priceRangeLow1 = aDecoder.decodeObject(forKey: "priceRangeLow") as? String
        let priceRangeHigh1 = aDecoder.decodeObject(forKey: "priceRangeHigh") as? String
        let frontBedRoom1 = aDecoder.decodeObject(forKey: "frontBedRoom") as? String
        let bedRoomCount1 = aDecoder.decodeObject(forKey: "bedRoomCount") as? String
        let need_ALFRESCO1 = aDecoder.decodeObject(forKey: "need_ALFRESCO") as? String
        let need_STUDY1 = aDecoder.decodeObject(forKey: "need_STUDY") as? String
        
        let region1 = aDecoder.decodeObject(forKey: "region") as? String
        
        
        let dic:[String : Any] = ["haveLand" : haveLand1 ?? "", "lotWidth" : lotWidth1 ?? "", "storeysCount" : storeysCount1 ?? "", "priceRangeLow" : priceRangeLow1 ?? "", "priceRangeHigh" : priceRangeHigh1 ?? "", "frontBedRoom" : frontBedRoom1 ?? "", "bedRoomCount": bedRoomCount1 ?? "", "need_ALFRESCO" : need_ALFRESCO1 ?? "", "need_STUDY" : need_STUDY1 ?? "", "region" : region1 ?? ""] //as [String : Any]
        
        self.init(dic:dic)
        
    }
    
    
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(haveLand ?? "", forKey: "haveLand")
        aCoder.encode(lotWidth ?? "", forKey: "lotWidth")
        aCoder.encode(storeysCount ?? "", forKey: "storeysCount")
        aCoder.encode(priceRangeLow ?? "", forKey: "priceRangeLow")
        aCoder.encode(priceRangeHigh ?? "", forKey: "priceRangeHigh")
        aCoder.encode(frontBedRoom ?? "", forKey: "frontBedRoom")
        aCoder.encode(bedRoomCount ?? "", forKey: "bedRoomCount")
        aCoder.encode(need_ALFRESCO ?? "", forKey: "need_ALFRESCO")
        aCoder.encode(need_STUDY ?? "", forKey: "need_STUDY")
        aCoder.encode(region ?? "", forKey: "region")
        
    }
    
    
    private func addSpaceandnewValue (_ toValue: String, _ newValue: String?) -> String {
        if let value = newValue, newValue != "" {
            if toValue.trim().count > 0 {
                return toValue + " | " + value
            }else {
                return  value
            }
        }
        return toValue
    }
    
    
    func filterString () -> String {
        
        var filterString = ""
        
        filterString = addSpaceandnewValue(filterString, haveLand)
        filterString = addSpaceandnewValue(filterString, lotWidth)
        filterString = addSpaceandnewValue(filterString, storeysCount)
        if priceRangeLow != nil, priceRangeLow != "" {
            filterString = filterString + " | "
            filterString = filterString + priceRangeLow!
            filterString = filterString + "-" + priceRangeHigh!
        }
        filterString = addSpaceandnewValue(filterString, frontBedRoom)
        filterString = addSpaceandnewValue(filterString, bedRoomCount)
        filterString = addSpaceandnewValue(filterString, need_ALFRESCO)
        filterString = addSpaceandnewValue(filterString, haveLand)
     
        if filterString.count == 0 {
            filterString = "..."
            if let ss = haveLand {
                print(log: ss)
            }else {
                filterString = "Take a quick survey to find your perfect design"
            }
        }
        
        return filterString
    }
    
    
    
    
    func filterStringDisplayHomes () -> String {
        
        var filterString = ""
        filterString = addSpaceandnewValue(filterString, region?.capitalized)
        
       
        if priceRangeLow != nil, priceRangeLow != "" {
            if filterString.count > 0 {
                filterString = filterString + " | "
            }
            filterString = filterString + priceRangeLow!
            filterString = filterString + "-" + priceRangeHigh!
        }
        
        filterString = addSpaceandnewValue(filterString, storeysCount?.capitalized)
        filterString = addSpaceandnewValue(filterString, bedRoomCount?.capitalized)

        if filterString.count == 0 {
            //                filterString = "..."
            //                if let ss = haveLand {
            //                    print(log: ss)
            //                }else {
            filterString = infoStaicText
            //                }
        }
        
        return filterString
    }
        
}




func saveFilterToDefaults (filter: MyPlaceQuiz, key: String = key_myPlaceQuiz) {
    
    kUserDefaults.set(NSKeyedArchiver.archivedData(withRootObject: filter), forKey: key)
    kUserDefaults.synchronize()
}

func getFilterFromDefaults (key: String = key_myPlaceQuiz) -> MyPlaceQuiz? {
    
    guard let data = kUserDefaults.object(forKey: key) as? NSData else { return nil }
    
    guard let filterCollection = NSKeyedUnarchiver.unarchiveObject(with: data as Data) else { return nil }
    
    
    return filterCollection as? MyPlaceQuiz
}


func removeFilterFromDefaults (_ key: String = key_myPlaceQuiz) {
    
    kUserDefaults.removeObject(forKey: key)
    kUserDefaults.synchronize()
}



