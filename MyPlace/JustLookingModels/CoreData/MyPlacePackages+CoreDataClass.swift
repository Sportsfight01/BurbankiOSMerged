//
//  HomeLandPackages+CoreDataClass.swift
//  
//
//  Created by sreekanth reddy Tadi on 13/05/20.
//
//

import Foundation
import CoreData

@objc(MyPlacePackages)
public class MyPlacePackages: CustomNSManagedObject {
    
    
    static let entityName = "MyPlacePackages"
    
    //MARK: - Save
    
    static func savePackage (_ package: HomeLandPackage) -> Bool {
        
        if let result : [MyPlacePackages] = MyPlacePackages.fetchSinglePackage(package) {
            if result.count > 0 {
                
                let response = MyPlacePackages.updatePackage(package, with: result[0])
                #if DEDEBUG
                if response { print("packageId: " + (package.packageId ?? "") + " updated successfully") }
                #endif
                return response
            }
            let response = MyPlacePackages.saveNewPackage(package)
            #if DEDEBUG
            if response { print("PackageId: " + (package.packageId ?? "") + " saved successfully") }
            #endif
            return response
        }else {
            let response = MyPlacePackages.saveNewPackage(package)
            #if DEDEBUG
            if response { print("PackageId: " + (package.packageId ?? "") + " saved successfully") }
            #endif
            return response
        }
    }
    
    
    static private func saveNewPackage (_ Package: HomeLandPackage) -> Bool {
        let description = NSEntityDescription.entity(forEntityName: MyPlacePackages.entityName, in: CustomNSManagedObject.context!)
        let newPackage = NSManagedObject(entity: description!, insertInto: CustomNSManagedObject.context!) as! MyPlacePackages

        return MyPlacePackages.updatePackage(Package, with: newPackage)
    }
    
    
    
    //MARK: - Fetch

    static func fetchPackages (page: Int, limit: Int, completionHandler: ((_ fetchedPackages: [HomeLandPackage]?) -> Void)) {
        
        let request: NSFetchRequest<MyPlacePackages> = MyPlacePackages.fetchRequest()
        if limit > 0 {
            request.fetchOffset = page*limit
            request.fetchLimit = limit
        }
        
        do {
            let fetchedResults: [MyPlacePackages] = try CustomNSManagedObject.context!.fetch(request)
            
            if fetchedResults.count > 0 {
                let PackagesResults = MyPlacePackages.PackagesWithFetchResult(fetchedResults)
                completionHandler(PackagesResults)
            }else {
                completionHandler([HomeLandPackage]())
            }
            
        } catch let error as NSError {
            // something went wrong, print the error.
            print(error.description)
            completionHandler(nil)
        }
    }
    
    static private func fetchSinglePackage (_ package: HomeLandPackage) -> [MyPlacePackages]? {
         
         let request: NSFetchRequest<MyPlacePackages> = MyPlacePackages.fetchRequest()
         request.predicate = NSPredicate(format: "packageId == %@", package.packageId ?? "")

         do {
             let fetchedResult: [MyPlacePackages] = try CustomNSManagedObject.context!.fetch(request)
             return fetchedResult
         } catch let error {
             print(error.localizedDescription)
             return nil
         }
     }
    
    
    //MARK: - Update

    static func updatePackage (_ package: HomeLandPackage) -> Bool {
        
        if let result: [MyPlacePackages] = MyPlacePackages.fetchSinglePackage(package) {
            if result.count > 0 {
                return MyPlacePackages.updatePackage(package, with: result[0])
            }
            return false
        }else {
            #if DEDEBUG
            print("failed to fetch")
            #endif
            return false
        }
    }
    
    
    static private func updatePackage (_ package: HomeLandPackage, with packageObject: MyPlacePackages) -> Bool {
        
        //        var Id: Stri
        
        packageObject.packageId = package.packageId
        packageObject.packageId_LandBank = package.packageId_LandBank
        packageObject.state = package.state


        packageObject.stateId = package.stateId
        packageObject.address = package.address
        packageObject.estateName = package.estateName
        packageObject.region = package.region
        packageObject.latitude = package.latitude
        packageObject.longitude = package.longitude
        
        
        packageObject.inclusions = package.inclusions
        packageObject.inclusionFileName = package.inclusionFileName
        packageObject.facadePermanentUrl = package.facadePermanentUrl
        
        
        packageObject.houseName = package.houseName
        packageObject.facade = package.facade
        packageObject.housePrice = package.housePrice
        packageObject.landSizeSqm = package.landSizeSqm
        packageObject.houseSize = package.houseSize
        packageObject.brand = package.brand
        packageObject.packageDescription = package.packageDescription
        packageObject.storey = package.storey
        packageObject.bedRooms = package.bedRooms
        packageObject.bathRooms = package.bathRooms
        packageObject.carSpace = package.carSpace
        packageObject.price = package.price
        packageObject.minLotWidth = package.minLotWidth
        packageObject.minLotLength = package.minLotLength
        
        packageObject.study = package.study
        packageObject.ensuite = package.ensuite
        
        
        // Other Boolean tags
        packageObject.isFav = package.isFav
        packageObject.isShowOnWeb = package.isShowOnWeb
        packageObject.isCompare = package.isCompare
        packageObject.isDisplay = package.isDisplay
        packageObject.alfrescosq = package.alfrescosq

        //Dates
        packageObject.dateAvailable = package.dateAvailable
        packageObject.landTitleDate = package.landTitleDate
        
       
        do {
            try CustomNSManagedObject.context!.save()
            return true
        } catch _ {
            print("Something went wrong.")
            return false
        }
    }
    
    
    //MARK: - Delete
    
    static func deletePackage (_ package: HomeLandPackage) -> Bool {
        
        if let packagefetched: [MyPlacePackages] = MyPlacePackages.fetchSinglePackage(package) {
            
            for packageFe in packagefetched {
                CustomNSManagedObject.context!.delete(packageFe)
            }
            
            do {
                try CustomNSManagedObject.context!.save()
                return true
            } catch _ {
                print("Something went wrong.")
                return false
            }
            
        }
        return false
    }
    
    static func deleteAllPackages () -> Bool {
        
        let request: NSFetchRequest<MyPlacePackages> = MyPlacePackages.fetchRequest()
//        let batchRequest = NSBatchDeleteResult
        
        request.includesPropertyValues = false
        
        
        do {
            _ = try CustomNSManagedObject.context!.execute(request)
            return true
        } catch let error {
            print(error.localizedDescription)
            return false
        }
      //  return false
    }

    
    
    //MARK: - Package
    
    static private func PackagesWithFetchResult (_ fetchedResult: [MyPlacePackages]) -> [HomeLandPackage] {
        
        var fetchedPackages = [HomeLandPackage]()

        for packageObject : MyPlacePackages in fetchedResult {
            
            let package = HomeLandPackage()
            

            package.packageId = packageObject.packageId
            package.packageId_LandBank = packageObject.packageId_LandBank

            
            package.state = packageObject.state
            package.stateId = packageObject.stateId
            package.address = packageObject.address
            package.estateName = packageObject.estateName
            package.region = packageObject.region
            package.latitude = packageObject.latitude
            package.longitude = packageObject.longitude
            
            
            package.inclusions = packageObject.inclusions
            package.inclusionFileName = packageObject.inclusionFileName
            package.facadePermanentUrl = packageObject.facadePermanentUrl
            
            
            package.houseName = packageObject.houseName
            package.facade = packageObject.facade
            package.housePrice = packageObject.housePrice
            package.landSizeSqm = packageObject.landSizeSqm
            package.houseSize = packageObject.houseSize
            package.brand = packageObject.brand
            package.packageDescription = packageObject.packageDescription
            package.storey = packageObject.storey
            package.bedRooms = packageObject.bedRooms
            package.bathRooms = packageObject.bathRooms
            package.carSpace = packageObject.carSpace
            package.price = packageObject.price
            package.minLotWidth = packageObject.minLotWidth
            package.minLotLength = packageObject.minLotLength
            
            package.study = packageObject.study
            package.ensuite = packageObject.ensuite
            
            
            // Other Boolean tags
            package.isFav = packageObject.isFav
            package.isShowOnWeb = packageObject.isShowOnWeb
            package.isCompare = packageObject.isCompare
            package.isDisplay = packageObject.isDisplay
            package.alfrescosq = packageObject.alfrescosq

            //Dates
            package.dateAvailable = packageObject.dateAvailable
            package.landTitleDate = packageObject.landTitleDate
            
            
            fetchedPackages.append(package)
        }
        return fetchedPackages
    }
    
    
    

}
