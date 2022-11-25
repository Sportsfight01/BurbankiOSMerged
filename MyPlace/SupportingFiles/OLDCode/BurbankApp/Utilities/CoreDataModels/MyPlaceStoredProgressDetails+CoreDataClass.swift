//
//  MyPlaceStoredProgressDetails+CoreDataClass.swift
//  
//
//  Created by dmss on 23/01/18.
//
//

import Foundation
import CoreData

@objc(MyPlaceStoredProgressDetails)
public class MyPlaceStoredProgressDetails: CustomNSManagedObject
{
    private typealias `self` = MyPlaceStoredProgressDetails
    static var entityName = "MyPlaceStoredProgressDetails"
   
    static func fetchAllStoredProgressDetails() -> [MyPlaceStoredProgressDetails]?
    {
        let fetchRequest: NSFetchRequest<MyPlaceStoredProgressDetails> = MyPlaceStoredProgressDetails.fetchRequest()
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
    static func fetchStoredProgressDetails(_ taskID: Int) -> MyPlaceStoredProgressDetails?
    {
        let fetchRequest: NSFetchRequest<MyPlaceStoredProgressDetails> = MyPlaceStoredProgressDetails.fetchRequest()
        let taskID = Int16(truncatingIfNeeded: taskID)
        let predicate = NSPredicate(format: "taskID == %@", "\(taskID)")
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
    static func addStoredProgressDetails(_ progressDetails: MyPlaceProgressDetails,_ previousStatus: String, _ currentStatus: String)
    {
        let description = NSEntityDescription.entity(forEntityName: entityName, in: context!)
        let newStoredProgressDetails = NSManagedObject(entity: description!, insertInto: context) as! MyPlaceStoredProgressDetails
        newStoredProgressDetails.status = progressDetails.status
        newStoredProgressDetails.stageName = progressDetails.stageName
        newStoredProgressDetails.previousStatus = previousStatus
        newStoredProgressDetails.currentStatus = currentStatus
        newStoredProgressDetails.name = progressDetails.name
        newStoredProgressDetails.taskID = Int16(truncatingIfNeeded: progressDetails.taskid) //Int16(progressDetails.taskid)
        newStoredProgressDetails.dateActual = progressDetails.dateActual
        newStoredProgressDetails.jobNumber = getJobNumber()
        saveStoredProgressDetails()
    }
    static func updateStoredProgressDetails(_ progressDetails: MyPlaceProgressDetails,_ previousStatus: String, _ currentStatus: String)
    {
         let fetchRequest: NSFetchRequest<MyPlaceStoredProgressDetails> = MyPlaceStoredProgressDetails.fetchRequest()
        let predicate = NSPredicate(format: "taskID == %@", "\(Int16(truncatingIfNeeded: progressDetails.taskid)))")
         fetchRequest.predicate = predicate
        do
        {
            let fetchResults = try self.context?.fetch(fetchRequest)
            if let progressDetailsStored = fetchResults?.first
            {
                progressDetailsStored.status = progressDetails.status
                progressDetailsStored.stageName = progressDetails.stageName
                progressDetailsStored.previousStatus = previousStatus
                progressDetailsStored.currentStatus = currentStatus
                progressDetailsStored.name = progressDetails.name
                progressDetailsStored.taskID = Int16(truncatingIfNeeded: progressDetails.taskid)
                progressDetailsStored.dateActual = progressDetails.dateActual
            }
            saveStoredProgressDetails()
        }
        catch {
            #if DEDEBUG
            print("fail to fetch myplace fav photos from core data")
            #endif
        }
    }
    static func updateProgressDetailsToRead(_ progressDetails: MyPlaceStoredProgressDetails,_ isRead: Bool)
    {
        progressDetails.isRead = isRead
        saveContext()
        //        let fetchRequest: NSFetchRequest<MyPlaceStageCompleteDetails> = MyPlaceStageCompleteDetails.fetchRequest()
        //        let predicate = NSPredicate(format: "taskid == %@", "\(Int16(truncatingBitPattern: progressDetails.taskid)))")
        //        fetchRequest.predicate = predicate
        //        do
        //        {
        //            let fetchResults = try self.context?.fetch(fetchRequest)
        //            if let progressDetailsStored = fetchResults?.first
        //            {
        //              progressDetailsStored.isRead = isRead
        //            }
        //
        //        }
        //        catch {
        //            print("fail to fetch myplace fav photos from core data")
        //        }
    }
    static func saveStoredProgressDetails()
    {
       saveContext()
    }
    static func deleteProgressDetails()
    {
        let fetchRequest: NSFetchRequest<MyPlaceStoredProgressDetails> = MyPlaceStoredProgressDetails.fetchRequest()
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
