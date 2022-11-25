//
//  MyPlaceFavPhoto+CoreDataClass.swift
//  
//
//  Created by dmss on 05/12/17.
//
//

import Foundation
import CoreData

@objc(MyPlaceFavPhoto)
public class MyPlaceFavPhoto: NSManagedObject {
    
    private typealias `self` = MyPlaceFavPhoto
    static var entityName = "MyPlaceFavPhoto"
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    static var context: NSManagedObjectContext?
    {
        return appDelegate.persistentContainer.viewContext
    }
    static func addFavPhotoForQLDSA(_ photoInfo: MyPlaceDocuments)
    {
        let fetchRequest: NSFetchRequest<MyPlaceFavPhoto> = MyPlaceFavPhoto.fetchRequest()
        let predicate = NSPredicate(format: "urlID == %@", "\(photoInfo.urlId)")
        fetchRequest.predicate = predicate
        do
        {
            let fetchResults = try self.context?.fetch(fetchRequest)
            if let _ = fetchResults?.first
            {
                #if DEDEBUG
                print("photo already added")
                #endif
                return
            }
            let description = NSEntityDescription.entity(forEntityName: entityName, in: context!)
            let newPhoto = NSManagedObject(entity: description!, insertInto: context) as! MyPlaceFavPhoto
            let currenUserJobDetails = appDelegate.currentUser?.userDetailsArray![0].myPlaceDetailsArray[0]
            newPhoto.jobNumber  = currenUserJobDetails?.jobNumber
            newPhoto.title = photoInfo.title
            newPhoto.urlID = "\(photoInfo.urlId)"
            newPhoto.url = "\(photoInfo.url)"
            newPhoto.uploadedDate = photoInfo.docDate
            newPhoto.authorName = photoInfo.authorName
            context?.perform({
                self.appDelegate.saveContext()
            })
        }
         catch {
                #if DEDEBUG
            print("fail to fetch myplace fav photos from core data")
            #endif
        }
    }
    static func addFavPhotoForVIC(_ photoInfo: MyPlacePhotos)
    {
        let fetchRequest: NSFetchRequest<MyPlaceFavPhoto> = MyPlaceFavPhoto.fetchRequest()
        let predicate = NSPredicate(format: "imageID == %@", "\(photoInfo.imageId)")
        fetchRequest.predicate = predicate
        do
        {
            let fetchResults = try self.context?.fetch(fetchRequest)
            if let _ = fetchResults?.first
            {
                #if DEDEBUG
                print("photo already added")
                #endif
                return
            }
            let description = NSEntityDescription.entity(forEntityName: entityName, in: context!)
            let newPhoto = NSManagedObject(entity: description!, insertInto: context) as! MyPlaceFavPhoto
            let currenUserJobDetails = appDelegate.currentUser?.userDetailsArray![0].myPlaceDetailsArray[0]
            newPhoto.jobNumber  = currenUserJobDetails?.jobNumber
            newPhoto.imageID = "\(photoInfo.imageId)"
            newPhoto.uploadedDate = photoInfo.dateUploaded
            newPhoto.imagePathForVLC = photoInfo.imagePath
            context?.perform({
                self.appDelegate.saveContext()
            })
        }
        catch {
                #if DEDEBUG
                print("fail to fetch myplace fav photos from core data")
                #endif
        }
    }
 
    static func deleteFavPhotoForQLDSA(_ photoInfo: MyPlaceDocuments)
    {
       deleteFavPhotoWithImageID("\(photoInfo.urlId)")
    }
    static func deleteFavPhotoForVLC(_ photoInfo: MyPlacePhotos)
    {
//        let fetchRequest: NSFetchRequest<MyPlaceFavPhoto> = MyPlaceFavPhoto.fetchRequest()
//        let predicate = NSPredicate(format: "imageID == %@", "\(photoInfo.imageId)")
//        fetchRequest.predicate = predicate
        deleteFavPhotoWithImageID("\(photoInfo.imageId)")
    }
    static func deleteFavPhotoWithImageID(_ imageID: String)
    {
        let fetchRequest: NSFetchRequest<MyPlaceFavPhoto> = MyPlaceFavPhoto.fetchRequest()
        let predicateString = selectedJobNumberRegion == .OLD ? "imageID" : "urlID"
        let predicate = NSPredicate(format: "\(predicateString) == %@", "\(imageID)")
        fetchRequest.predicate = predicate
        do
        {
            let fetchResults = try self.context?.fetch(fetchRequest)
            if let photo = fetchResults?.first
            {
                context?.performAndWait {
                    context?.delete(photo)
                    appDelegate.saveContext()
                }
            }
        }catch {
                #if DEDEBUG
            print("fail to fetch myplace fav photos from core data")
            #endif
        }
    }
    static func fetchFavPhotos() -> [MyPlaceFavPhoto]? //for both QLD and SA we are fetching Fav Photos with job Number only.
    {
        //
         let fetchRequest: NSFetchRequest<MyPlaceFavPhoto> = MyPlaceFavPhoto.fetchRequest()
        let currenUserJobDetails = appDelegate.currentUser?.userDetailsArray![0].myPlaceDetailsArray[0]
        let predicate = NSPredicate(format: "jobNumber == %@", currenUserJobDetails?.jobNumber ?? "")
        fetchRequest.predicate = predicate
        do
        {
            let fetchResults = try self.context?.fetch(fetchRequest)
            return fetchResults
        }
        catch
        {
            #if DEDEBUG
            print("fail to fetch fav photos")
            #endif
        }
        return nil
    }

}
