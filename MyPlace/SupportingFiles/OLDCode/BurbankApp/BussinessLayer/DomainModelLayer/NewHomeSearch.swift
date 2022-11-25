//
//  NewHomeSearch.swift
//  BurbankApp
//
//  Created by imac on 09/01/17.
//  Copyright © 2017 DMSS. All rights reserved.
//

import UIKit

//enum Storey
//{
//    case Single(Bool)
//    case Double(Bool)
//}
//enum Bedrooms
//{
//    case bedroom3(Bool)
//    case bedroom4(Bool)
//    case bedroom5plus(Bool)
//}
//enum Bathrooms
//{
//    case bathroom2(Bool)
//    case bathroom3(Bool)
//}
//enum BlockWidth
//{
//    case MinBlockWidth(Double)
//    case MaxBlockWidth((Double))
//    case MinSelectedBlockWidth((Double))
//    case MaxSelectedBlockWidth(Double)
//}
//enum Collections
//{
//    case gen (Bool)
//    case elements (Bool)
//}
//
//enum Price
//{
//    case MinPrice(Double)
//    case MaxPrice(Double)
//    case MinSelectedPrice(Double)
//    case MaxSelectedPrice(Double)
//}

//class NewHomeSearch: NSObject {
//    
//    var singleStorey:Storey
//    var doubleStorey:Storey
//    override init() {
//        singleStorey = Storey.Single(false)
//        doubleStorey = Storey.Double(false)
//    }
//}
func getRegionName(_ regionName  : String) -> String{
    var region = ""
    
    if regionName == "VIC"{
        region = "Victoria"
    }
    else if regionName == "QLD"{
        region = "Queensland"
    }
    else if regionName == "SA"{
        region = "South-Australia"
    }
    else if regionName == "NSW"{
        region = "NSW"
    }
    return region
}
