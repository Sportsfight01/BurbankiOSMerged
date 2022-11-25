//
//  MyPlacePhotoNote+CoreDataClass.swift
//  
//
//  Created by dmss on 06/12/17.
//
//

import Foundation
import CoreData

@objc(MyPlacePhotoNote)
public class MyPlacePhotoNote: NSManagedObject {
    private typealias `self` = MyPlaceFavPhoto
    static var entityName = "MyPlacePhotoNote"
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    static var context: NSManagedObjectContext?
    {
        return appDelegate.persistentContainer.viewContext
    }
    static func addNotetoPhotoForQLDSA(_ imageId: String,_ noteDescription: String)
    {
        let fetchRequest: NSFetchRequest<MyPlacePhotoNote> = MyPlacePhotoNote.fetchRequest()
        let predicate = NSPredicate(format: "urlID == %@", "\(imageId)")
        fetchRequest.predicate = predicate
        do
        {
            let fetchResults = try self.context?.fetch(fetchRequest)
            if let note = fetchResults?.first
            {
               // print("photo already added")
                 note.noteDescription = noteDescription
            }else
            {
                let description = NSEntityDescription.entity(forEntityName: entityName, in: context!)
                let newNote = NSManagedObject(entity: description!, insertInto: context) as! MyPlacePhotoNote
                let currenUserJobDetails = appDelegate.currentUser?.userDetailsArray![0].myPlaceDetailsArray[0]
                newNote.jobNumber  = currenUserJobDetails?.jobNumber
                //newNote.photoTitle = photoInfo.title
                newNote.urlID = "\(imageId)"
               // newNote.authorName = photoInfo.authorName
                newNote.noteDescription = noteDescription
              
            }
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
    static func fetchPhotoNote(_ urlID: String) -> MyPlacePhotoNote?
    {
        //
        let fetchRequest: NSFetchRequest<MyPlacePhotoNote> = MyPlacePhotoNote.fetchRequest()
        let currenUserJobDetails = appDelegate.currentUser?.userDetailsArray![0].myPlaceDetailsArray[0]
        let predicate = NSPredicate(format: "jobNumber == %@", currenUserJobDetails?.jobNumber ?? "")
        let urlPredicate = NSPredicate(format: "urlID == %@", urlID)
        let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [predicate,urlPredicate])
        fetchRequest.predicate = andPredicate
        do
        {
            let fetchResults = try self.context?.fetch(fetchRequest)
            return fetchResults?.first
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
