//
//  NotificationsViewModel.swift
//  BurbankApp
//
//  Created by Naresh Banavath on 27/04/23.
//  Copyright © 2023 Sreekanth tadi. All rights reserved.
//

import Foundation
import RealmSwift

class NotificationsViewModel
{
    //MARK: - Properties
    let realm : Realm
    
    //MARK: - Init
    
    init() {
        self.realm = try! Realm()
    }
    
    //MARK: - Methods
    func setupLocalStorageForNotification(completion :@escaping((Int) -> ()))
    {
       
   
        debugPrint("realmLocation :- \(realm.configuration.fileURL as Any)")
        let currentjobNumber = CurrentUser.jobNumber ?? APIManager.shared.getJobNumberAndAuthorization().jobNumber
        let LocalStorageNotifications = realm.objects(RealmStageComplete.self).filter({$0.jobNumber.contains(currentjobNumber!)})
        
        //STEP 1 :- Check what type of notifications UserOpted for
        APIManager.shared.getUserSelectedNotificationTypes { notificationTypes in
            if notificationTypes.photoAdd == false && notificationTypes.stageCompleted == false && notificationTypes.stageChange == false { return }
            
            //STEP 2 :- Add data for selected notification type
            let group = DispatchGroup()

                group.enter()
                APIManager.shared.getProgressDetails { result in
                    defer { group.leave() }
                    switch result
                    {
                    case .success(let progressArray):
                        let serviceCompletedStages = progressArray.filter({$0.status?.lc == "completed"})
                        let localCompletedStages = LocalStorageNotifications.filter({$0.isPhoto == false})
                        //add new progress data came from service
                        if serviceCompletedStages.count > localCompletedStages.count
                        {
                            //Looping through every stages
                            for serviceItem in serviceCompletedStages {
                                if localCompletedStages.contains(where: { $0.taskName == serviceItem.name }) { continue }
                                self.createAndAddRealmObject(
                                    taskName: serviceItem.name ?? "--",
                                    taskId: serviceItem.taskid ?? 0,
                                    photoURL: nil, date: serviceItem.date,
                                    isPhoto: false, stageName: serviceItem.stageName)
                                
                            }
                            
                    }
                    case .failure(let err):
                        debugPrint(err.localizedDescription)
                    }
         
            }
                //add photos
                group.enter()
                APIManager.shared.getPhotos { servicePhotosArray in
                    defer { group.leave() }
                    
                    let localStoragePhotos = LocalStorageNotifications.filter({$0.isPhoto == true})
                    
                    
                    //Add New data came from service
                    if servicePhotosArray.count > localStoragePhotos.count
                    {
                        for serviceItem in servicePhotosArray
                        {
                            if localStoragePhotos.contains(where: { $0.photoURl == serviceItem.url }) { continue }
                            else {
                                self.createAndAddRealmObject(taskName: "", taskId: 0, photoURL: serviceItem.url ?? "no url", date: serviceItem.date, isPhoto: true)
                            }
                        }
                    }
                }

            group.notify(queue: .main)
            {
                let LocalStorageNotifications = self.realm.objects(RealmStageComplete.self).filter({$0.jobNumber == currentjobNumber && $0.isRead == false})
            
                debugPrint("Notification Count :- \(LocalStorageNotifications.count) for jobNumber :- \(String(describing: currentjobNumber))")
                completion(LocalStorageNotifications.count)
                
            }
        }

    }
    
    func createAndAddRealmObject(taskName : String?, taskId : Int?, photoURL : String?, date : Date, isPhoto : Bool, stageName : String? = nil)
    {
        let realmObj = RealmStageComplete(taskName: taskName ?? "",
                                          taskId: taskId ?? 0,
                                          photoURl: photoURL ?? "",
                                          date: date,
                                          isPhoto: isPhoto,
                                          stageName: stageName)
        
        try! realm.write {
            realm.add(realmObj)
        }
    }
    
}
