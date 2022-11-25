//
//  MyPlaceStageCompleteDetails+CoreDataClass.swift
//  
//
//  Created by dmss on 29/01/18.
//
//

import Foundation
import CoreData

@objc(MyPlaceStageCompleteDetails)
public class MyPlaceStageCompleteDetails: CustomNSManagedObject {
    private typealias `self` = MyPlaceStageCompleteDetails
    static var entityName = "MyPlaceStageCompleteDetails"
    static func fetchAllProgressDetails() -> [MyPlaceStageCompleteDetails]?
    {
        let fetchRequest: NSFetchRequest<MyPlaceStageCompleteDetails> = MyPlaceStageCompleteDetails.fetchRequest()
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
    static func fetchProgressDetails(_ taskID: Int) -> MyPlaceStageCompleteDetails?
    {
        let fetchRequest: NSFetchRequest<MyPlaceStageCompleteDetails> = MyPlaceStageCompleteDetails.fetchRequest()
        let taskID = Int16(truncatingIfNeeded: taskID)
        let predicate = NSPredicate(format: "taskid == %@", "\(taskID)")
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
    static func addProgressDetails(_ progressDetails: MyPlaceProgressDetails)
    {
        let description = NSEntityDescription.entity(forEntityName: entityName, in: context!)
        let newStoredProgressDetails = NSManagedObject(entity: description!, insertInto: context) as! MyPlaceStageCompleteDetails
        newStoredProgressDetails.isRead = false
        newStoredProgressDetails.status = progressDetails.status
        newStoredProgressDetails.stageName = progressDetails.stageName
        newStoredProgressDetails.name = progressDetails.name
        newStoredProgressDetails.taskid = Int16(truncatingIfNeeded: progressDetails.taskid) //Int16(progressDetails.taskid)
        newStoredProgressDetails.dateActual = progressDetails.dateActual
        newStoredProgressDetails.jobNumber = getJobNumber()
        saveContext()
    }
    static func updateProgressDetails(_ progressDetails: MyPlaceStageCompleteDetails,_ isRead: Bool)
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
    static func deleteProgressDetails()
    {
        let fetchRequest: NSFetchRequest<MyPlaceStageCompleteDetails> = MyPlaceStageCompleteDetails.fetchRequest()
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
