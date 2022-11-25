//
//  DisplayHomeDataModels.swift
//  BurbankApp
//
//  Created by dmss on 21/04/17.
//  Copyright © 2017 DMSS. All rights reserved.
//

import Foundation
class Suburb
{
    var suburbName: String?
    var estates: [Estate]?
    init(dic: [String: Any])
    {
        suburbName = dic["Suburb"] as? String
        if let estatesDicArray = dic["EstateNames"] as? NSArray
        {
            estates = [Estate]()
            for i in 0 ...  estatesDicArray.count - 1
            {
                let estate = Estate(dic: estatesDicArray[i] as! [String : Any])
                estates?.append(estate)
            }
            
        }
        
    }
}
class Estate
{
    var estateName: String?
    var houseNames: [String]?
    
    init(dic: [String: Any])
    {
        estateName = dic["Estate"] as? String
        if  let houseNamesArray = dic["HouseNames"] as? [String]
        {
            houseNames = [String]()
            for i in 0 ... houseNamesArray.count - 1
            {
                houseNames?.append(houseNamesArray[i])
            }
        }
        
    }
}
