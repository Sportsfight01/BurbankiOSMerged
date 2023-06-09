//
//  APIManager + Service Calls.swift
//  BurbankApp
//
//  Created by Naresh Banavath on 17/04/23.
//  Copyright © 2023 Sreekanth tadi. All rights reserved.
//

import Foundation

class APIManager{
    
    static let shared = APIManager()
    lazy var currentUserJobNumAndAuth = getJobNumberAndAuthorization()
    var currentJobDetails : MyPlaceDetails?
    private init() { self.getJobNumberAndAuthorization()}
    

    func getProgressDetails(onSuccess : (([ProgressStruct])->())?)
    {
        guard let jobNumber = APIManager.shared.getJobNumberAndAuthorization().jobNumber else {debugPrint("JobNumber of auth is Null");return}
        let auth = APIManager.shared.getJobNumberAndAuthorization().auth
        NetworkRequest.makeRequestArray(type: ProgressStruct.self, urlRequest: Router.progressDetails(auth: auth, contractNo: jobNumber)) { result in
            switch result
            {
            case .success(let data):
        
                let progressKeyWords = ["frame stage", "lockup stage","fixout stage","completion","base stage","handover"]
                var requiredProgressData : [ProgressStruct] = []
                for item in data
                {
                    if progressKeyWords.contains(item.stageName?.lowercased() ?? "") || item.phasecode?.lc.contains("presite") ?? false
                    {
                        requiredProgressData.append(item)
                    }
                }
                
//                let requiredProgressData = data.filter( { progressKeyWords.contains($0.stageName?.lowercased() ?? "") || $0.phasecode?.contains("presite") ?? false } )
                onSuccess?(requiredProgressData)
            case .failure(let err):
                debugPrint("ERROR OCCURED")
                AlertManager.sharedInstance.showAlert(alertMessage: err.localizedDescription)
            }
        }
    }
    
    func getPhotos(onSuccess :@escaping(([DocumentsDetailsStruct])->()))
    {
        guard let jobNumber = APIManager.shared.getJobNumberAndAuthorization().jobNumber else {debugPrint("JobNumber of auth is Null");return}
        let auth = APIManager.shared.getJobNumberAndAuthorization().auth
        NetworkRequest.makeRequestArray(type: DocumentsDetailsStruct.self, urlRequest: Router.documentsDetails(auth: auth, contractNo: jobNumber)){ result in
            switch result
            {
            case .success(let data):
                
                let imageTypes = ["jpg", "png","jpeg"]
                let photosList = data.filter( { imageTypes.contains( $0.type?.trim().lowercased() ?? "") } )
                onSuccess(photosList)
            case .failure(let err):
                debugPrint("ERROR OCCURED")
                AlertManager.sharedInstance.showAlert(alertMessage: err.localizedDescription)
                
            }
        }
    }
    
    func getUserSelectedNotificationTypes(completion : @escaping(((photoAdd : Bool,stageCompleted : Bool, stageChange : Bool)) -> Void))
    {
    
        let userID = APIManager.shared.currentJobDetails?.userId
        let parameters : [String : Any] = ["Id" : userID as Any]
        NetworkRequest.makeRequest(type: GetUserProfileStruct.self, urlRequest: Router.getUserProfile(parameters: parameters), showActivity: false) { result in
            switch result
            {
            case .success(let data):
               // print(data)
                guard data.status == true else { return }
              //  self?.profileData = data
                let notificationArray = data.result?.notificationTypes
                let photoAdd = notificationArray?[0].isUserOpted ?? false
                let stageCompleted = notificationArray?[1].isUserOpted ?? false
                let stageChange = notificationArray?[2].isUserOpted ?? false
                
                completion((photoAdd,stageCompleted,stageChange))
                
            case .failure(let err):
                print(err.localizedDescription)
//                DispatchQueue.main.async {
//                    self?.showAlert(message: err.localizedDescription)
//                }
            }
        }
    }
    
    
}

extension APIManager
{
    @discardableResult
    func getJobNumberAndAuthorization() -> (jobNumber : String?, auth : String)
    {
        //CurrentuserVars.jobNumber contain current selected jobNumber
        //if multipleJobNumbers are there
        CurrentUser.jobNumber = UserDefaults.standard.value(forKey: "selectedJobNumber") as? String
        
        if CurrentUser.jobNumber == nil || CurrentUser.jobNumber?.count == 0
        {
            if appDelegate.currentUser?.jobNumber?.count == 0 || appDelegate.currentUser?.jobNumber == nil
            {
                CurrentUser.jobNumber = appDelegate.currentUser?.userDetailsArray?.first?.myPlaceDetailsArray.first?.jobNumber
            }else {
                CurrentUser.jobNumber = appDelegate.currentUser?.jobNumber
            }
        }
        
        let currenUserJobDetails =  appDelegate.currentUser?.userDetailsArray?.first?.myPlaceDetailsArray.filter({ $0.jobNumber?.trim() == CurrentUser.jobNumber?.trim()}).first
        self.currentJobDetails = currenUserJobDetails

        let authorizationString = "\(currenUserJobDetails?.userName ?? ""):\(currenUserJobDetails?.password ?? "")"
        let encodeString = authorizationString.base64String
        let auth = "Basic \(encodeString)"
        return (jobNumber : CurrentUser.jobNumber, auth : auth)
    }
}

