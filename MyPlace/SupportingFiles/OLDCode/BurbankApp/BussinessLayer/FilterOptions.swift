//
//  FilterOptions.swift
//  BurbankApp
//
//  Created by dmss on 30/01/17.
//  Copyright © 2017 DMSS. All rights reserved.
//

import UIKit
class Storey: NSObject
{
    var  single: Bool = false
    var  double: Bool = false
   
}

class Bedrooms: NSObject
{
    var bedroom3: Bool = false
    var bedroom4: Bool = false
    var bedroom5plus: Bool = false
    
}
class Bathrooms: NSObject
{
    var bathroom2: Bool = false
    var bathroom3: Bool = false
    
}
class BlockWidth: NSObject
{
    var minBlockWidth: Double = 0
    var maxBlockWidth: Double = 0
    var minSelectedBlockWidth: Double = 155.0
    var maxSelectedBlockWidth: Double = 395.0
   
}
class Price: NSObject
{
    var minPrice: Double = 155.0
    var maxPrice: Double = 395.0
    var minSelectedPrice: Double = 155.0
    var maxSelectedPrice: Double = 395.0
    
}
class Collections: NSObject
{
    var gen: Bool = false
    var elements: Bool = false
}
class HLFilterOptions: FilterOptions
{
    var suburb: String?
    var estate: String?
    
    required  convenience init(coder aDecoder: NSCoder)
    {
        self.init()
        
        storey.single = aDecoder.decodeBool(forKey: "singleStorey")
        storey.double = aDecoder.decodeBool(forKey: "doubleStorey")
        
        bedRooms.bedroom3 = aDecoder.decodeBool(forKey: "bedRoom3")
        bedRooms.bedroom4 = aDecoder.decodeBool(forKey: "bedRoom4")
        bedRooms.bedroom5plus = aDecoder.decodeBool(forKey: "bedRoom5Plus")
        
        bathRooms.bathroom2 = aDecoder.decodeBool(forKey: "bathRoom2")
        bathRooms.bathroom3 = aDecoder.decodeBool(forKey: "bathRoom3")
        
        price.minSelectedPrice =  aDecoder.decodeDouble(forKey: "minSelectedPrice")
        price.maxSelectedPrice =  aDecoder.decodeDouble(forKey: "maxSelectedPrice")
        
        price.minPrice =  aDecoder.decodeDouble(forKey: "minPrice")
        price.maxPrice =  aDecoder.decodeDouble(forKey: "maxPrice")
        
        suburb = aDecoder.decodeObject(forKey: "Suburb") as? String
        estate = aDecoder.decodeObject(forKey: "Estate") as? String
        
    }
    override func encode(with aCoder: NSCoder)
    {
        super.encode(with: aCoder)
        aCoder.encode(suburb, forKey: "Suburb")
        aCoder.encode(estate, forKey: "Estate")
        
        aCoder.encode(price.minPrice, forKey: "minPrice")
        aCoder.encode(price.maxPrice, forKey: "maxPrice")
        
        
    }

    
}

class FilterOptions: NSObject,NSCoding
{
    var storey = Storey()
    var bedRooms = Bedrooms()
    var bathRooms = Bathrooms()
    var blockWidth = BlockWidth()
    var price = Price()
    var collections = Collections()
    
    override init() {
        
        super.init()
     
        
        
    }
    required  convenience init(coder aDecoder: NSCoder)
    {
         self.init()

        storey.single = aDecoder.decodeBool(forKey: "singleStorey")
        storey.double = aDecoder.decodeBool(forKey: "doubleStorey")
        
        bedRooms.bedroom3 = aDecoder.decodeBool(forKey: "bedRoom3")
        bedRooms.bedroom4 = aDecoder.decodeBool(forKey: "bedRoom4")
        bedRooms.bedroom5plus = aDecoder.decodeBool(forKey: "bedRoom5Plus")
        
        bathRooms.bathroom2 = aDecoder.decodeBool(forKey: "bathRoom2")
        bathRooms.bathroom3 = aDecoder.decodeBool(forKey: "bathRoom3")
        price.minSelectedPrice =    aDecoder.decodeDouble(forKey: "minSelectedPrice")
        price.maxSelectedPrice =  aDecoder.decodeDouble(forKey: "maxSelectedPrice")
        
       
        
    
        
//         bathRooms = aDecoder.decodeObject(forKey: "bathRooms") as? Bathrooms
//         blockWidth = aDecoder.decodeObject(forKey: "blockWidth") as? BlockWidth
//         price  = aDecoder.decodeObject(forKey: "price") as? Price
//         collections = aDecoder.decodeObject(forKey: "collections") as? Collections

    }
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(self.storey.single, forKey: "singleStorey")
        aCoder.encode(self.storey.double, forKey: "doubleStorey")
        aCoder.encode(self.bedRooms.bedroom3, forKey: "bedRoom3")
        aCoder.encode(self.bedRooms.bedroom4, forKey: "bedRoom4")
        aCoder.encode(self.bedRooms.bedroom5plus, forKey: "bedRoom5Plus")
        
    
        aCoder.encode(bathRooms.bathroom2, forKey: "bathRoom2")
        aCoder.encode(bathRooms.bathroom3, forKey: "bathRoom3")
        
        aCoder.encode(price.minSelectedPrice, forKey: "minSelectedPrice")
        aCoder.encode(price.maxSelectedPrice, forKey: "maxSelectedPrice")
   
        
//        aCoder.encode(storey, forKey: "storey")
//        aCoder.encode(bedRooms, forKey: "firstName")
//        aCoder.encode(bathRooms, forKey: "bathRooms")
//        aCoder.encode(blockWidth, forKey: "blockWidth")
//        aCoder.encode(price, forKey: "price")
//        aCoder.encode(collections, forKey: "isActive")
        
    }
}
