//
//  MyPlaceStoredPhotoInfo+CoreDataClass.swift
//  
//
//  Created by dmss on 30/01/18.
//
//

import Foundation
import CoreData

@objc(MyPlaceStoredPhotoInfo)
public class MyPlaceStoredPhotoInfo: CustomNSManagedObject
{
    private typealias `self` = MyPlaceStoredPhotoInfo
    static var entityName = "MyPlaceStoredPhotoInfo"
    static func fetchAllStoredPhotoInfo() -> [MyPlaceStoredPhotoInfo]?
    {
        let fetchRequest: NSFetchRequest<MyPlaceStoredPhotoInfo> = MyPlaceStoredPhotoInfo.fetchRequest()
        let predicate = NSPredicate(format: "jobNumber == %@", "\(getJobNumber())")
        fetchRequest.predicate = predicate
        do {
            let fetchResult = try self.context?.fetch(fetchRequest)
            return fetchResult
        }catch
        {
            #if DEDEBUG
            print("fail to fetch notification:")
            #endif
        }
        //user not selected any notification type, so it is in default state which all are true
        return nil
    }
    static func fetchPhotoInfo(_ urlID: Int) -> MyPlaceStoredPhotoInfo?
    {
        let fetchRequest: NSFetchRequest<MyPlaceStoredPhotoInfo> = MyPlaceStoredPhotoInfo.fetchRequest()
        let urlID = Int16(truncatingIfNeeded: urlID)
        let predicate = NSPredicate(format: "urlId == %@", "\(urlID)")
        fetchRequest.predicate = predicate
        do {
            let fetchResult = try self.context?.fetch(fetchRequest)
            if let progressDetail = fetchResult?.first
            {
                return progressDetail
            }
        }catch
        {
            #if DEDEBUG
            print("fail to fetch notification:")
            #endif
        }
        return nil
    }
    static func addPhotoInfo(_ photoInfo: MyPlaceDocuments)
    {
        let description = NSEntityDescription.entity(forEntityName: entityName, in: context!)
        let newPhoto = NSManagedObject(entity: description!, insertInto: context) as! MyPlaceStoredPhotoInfo
        newPhoto.isRead = false
        newPhoto.authorName = photoInfo.authorName
        newPhoto.byClient = Int16(truncatingIfNeeded: photoInfo.byClient)
        newPhoto.current = Int16(truncatingIfNeeded: photoInfo.current)
        newPhoto.urlId = Int16(truncatingIfNeeded: photoInfo.urlId) //Int16(progressDetails.taskid)
        newPhoto.docDate = photoInfo.docDate
        newPhoto.title = photoInfo.title
        newPhoto.type = photoInfo.type
        newPhoto.jobNumber = getJobNumber()
        saveContext()
    }
    static func updatePhotoInfo(_ photoInfo: MyPlaceStoredPhotoInfo,_ isRead: Bool)
    {
         photoInfo.isRead = isRead
         saveContext()
 //       let fetchRequest: NSFetchRequest<MyPlaceStoredPhotoInfo> = MyPlaceStoredPhotoInfo.fetchRequest()
//        let urlID = Int16(truncatingBitPattern: photoInfo.urlId)
//        let predicate = NSPredicate(format: "urlId == %@", "\(urlID)")
//        fetchRequest.predicate = predicate
//        do
//        {
//            let fetchResults = try self.context?.fetch(fetchRequest)
//            if let progressDetailsStored = fetchResults?.first
//            {
//                progressDetailsStored.isRead = isRead
//            }
//            saveContext()
//        }
//        catch {
//            print("fail to fetch myplace fav photos from core data")
//        }
    }
    static func deleteAllPhotos()
    {
        let fetchRequest: NSFetchRequest<MyPlaceStoredPhotoInfo> = MyPlaceStoredPhotoInfo.fetchRequest()
        let predicate = NSPredicate(format: "jobNumber == %@", "\(getJobNumber())")
        fetchRequest.predicate = predicate
        do {
            guard  let fetchResult = try self.context?.fetch(fetchRequest) else {return}
            for progressDetails in fetchResult
            {
                context?.delete(progressDetails)
            }
            saveContext()
        }catch
        {
            #if DEDEBUG
            print("fail to fetch notification:")
            #endif
        }
    }
}
