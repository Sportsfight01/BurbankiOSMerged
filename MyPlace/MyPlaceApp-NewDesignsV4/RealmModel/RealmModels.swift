//
//  RealmModels.swift
//  BurbankApp
//
//  Created by Naresh Banavath on 26/04/23.
//  Copyright © 2023 Sreekanth tadi. All rights reserved.
//

import Foundation
import RealmSwift

class RealmStageComplete : Object
{
    @Persisted var jobNumber : String
    @Persisted var taskName : String?
    @Persisted var taskId : Int?
    @Persisted var photoURl : String?
    @Persisted var date : Date
    @Persisted var isRead : Bool
    @Persisted var isPhoto : Bool
    @Persisted var stageName : String?
    
    convenience init(jobNumber: String = APIManager.shared.getJobNumberAndAuthorization().jobNumber ?? "", taskName: String, taskId: Int, photoURl: String, date: Date, isRead: Bool = false, isPhoto: Bool, stageName : String? = nil) {
        self.init()
        self.jobNumber = jobNumber
        self.taskName = taskName
        self.taskId = taskId
        self.photoURl = photoURl
        self.date = date
        self.isRead = isRead
        self.isPhoto = isPhoto
        self.stageName = stageName
    }
}


