//
//  SuburbEstateList.swift
//  BurbankApp
//
//  Created by dmss on 28/02/17.
//  Copyright © 2017 DMSS. All rights reserved.
//

import UIKit

class SuburbEstateList: NSObject,NSCoding
{
    var estateList: [String]?
    var suburbList: [String]?
    var minPrice: Int?
    var maxPrice: Int?
    
    init(dic: [String: Any])
    {
        //
        estateList = dic["EstateList"] as? [String]
        suburbList = dic["SuburbList"] as? NSArray as! [String]?
        minPrice = dic["minPrice"] as? Int
        maxPrice = dic["maxPrice"] as? Int
    
    }
    required convenience init(coder aDecoder: NSCoder)
    {

        let estateList = aDecoder.decodeObject(forKey: "EstateList") as! [String]
        let suburbList = aDecoder.decodeObject(forKey: "SuburbList") as! [String]
        let minPrice = aDecoder.decodeObject(forKey: "minPrice") as! Int
        let maxPrice = aDecoder.decodeObject(forKey: "maxPrice") as! Int        
        
        let dic = ["EstateList":estateList ,"SuburbList":suburbList,"minPrice":minPrice,"maxPrice":maxPrice] as [String : Any]
        self.init(dic: dic)
        
        
    }
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(estateList, forKey: "EstateList")
        aCoder.encode(suburbList, forKey: "SuburbList")
        aCoder.encode(minPrice, forKey: "minPrice")
        aCoder.encode(maxPrice, forKey: "maxPrice")
        
    }
}
