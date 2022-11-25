//
//  NotificationTypes+CoreDataClass.swift
//  
//
//  Created by dmss on 18/01/18.
//
//

import Foundation
import CoreData

@objc(NotificationTypes)
public class NotificationTypes: CustomNSManagedObject
{
    private typealias `self` = NotificationTypes
    static var entityName = "NotificationTypes"
    
  
    static func updatedSelectedNotificationType(_ photoAdded: Bool = true, _ stageCompleted: Bool = true, stageChanged: Bool = true)
    {
        let fetchRequest: NSFetchRequest<NotificationTypes> = NotificationTypes.fetchRequest()
        do {
            let fetchResult = try self.context?.fetch(fetchRequest)
            if let firstNotification = fetchResult?.first
            {
                firstNotification.photoAdded = photoAdded
                firstNotification.stageComplete = stageCompleted
                firstNotification.stageChange = stageChanged
                saveContext()
                return
            }
            
            let description = NSEntityDescription.entity(forEntityName: entityName, in: context!)
            let newNotificationType = NSManagedObject(entity: description!, insertInto: context) as! NotificationTypes
            newNotificationType.photoAdded = photoAdded
            newNotificationType.stageComplete = stageCompleted
            newNotificationType.stageChange = stageChanged
            saveContext()
        } catch  {
            #if DEDEBUG
            print("fail to fetch notification:")
            #endif
        }
    }
    static func getSelectedNotificationType() -> NotificationTypes?
    {
        let fetchRequest: NSFetchRequest<NotificationTypes> = NotificationTypes.fetchRequest()
        do {
            let fetchResult = try self.context?.fetch(fetchRequest)
            if let firstNotification = fetchResult?.first
            {
                return firstNotification
            }
        }catch
        {
            #if DEDEBUG
            print("fail to fetch notification:")
            #endif
        }
        //user not selected any notification type, so it is in default state which all are true
        return nil
    }
    static func deleteNotificationType()
    {
        let fetchRequest: NSFetchRequest<NotificationTypes> = NotificationTypes.fetchRequest()
        do {
            let fetchResult = try self.context?.fetch(fetchRequest)
            if let firstNotification = fetchResult?.first
            {
                context?.performAndWait {
                    self.context?.delete(firstNotification)
                    self.saveContext()
                }
                
            }
        }catch
        {
            #if DEDEBUG
            print("fail to fetch notification:")
            #endif
        }
        //user not selected any notification type, so it is in default state which all are true
       
    }
    
}
