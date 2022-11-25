//
//  CustomNSManagedObjectClass.swift
//  BurbankApp
//
//  Created by dmss on 18/01/18.
//  Copyright © 2018 DMSS. All rights reserved.
//

import Foundation
import CoreData

public class CustomNSManagedObject: NSManagedObject
{
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static var context: NSManagedObjectContext?
    {
        return appDelegate.persistentContainer.viewContext
    }
    static func saveContext()
    {
        context?.perform {
            self.appDelegate.saveContext()
        }
    }
    static func getJobNumber() -> String
    {
        let myplaceDetails = appDelegate.currentUser?.userDetailsArray?[0].myPlaceDetailsArray
        if myplaceDetails?.count == 0
        {
            return ""
        }
        return myplaceDetails![0].jobNumber ?? ""
    }
}
