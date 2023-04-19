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
    private init() {}
    

    func getProgressDetails()
    {
        guard let jobNumber = currentUserJobNumAndAuth.jobNumber else {debugPrint("JobNumber of auth is Null");return}
        let auth = currentUserJobNumAndAuth.auth
        NetworkRequest.makeRequestArray(type: ProgressStruct.self, urlRequest: Router.progressDetails(auth: auth, contractNo: jobNumber)) { result in
            switch result
            {
            case .success(let data):
                debugPrint("data received")
            case .failure(let err):
                debugPrint("ERROR OCCURED")
            }
        }
    }
    
    
}

extension APIManager
{
    func getJobNumberAndAuthorization() -> (jobNumber : String?, auth : String)
    {
        //CurrentuserVars.jobNumber contain current selected jobNumber
        if CurrentUservars.jobNumber == nil || CurrentUservars.jobNumber?.count == 0
        {
            if appDelegate.currentUser?.jobNumber?.count == 0 || appDelegate.currentUser?.jobNumber == nil
            {
                CurrentUservars.jobNumber = appDelegate.currentUser?.userDetailsArray?.first?.myPlaceDetailsArray.first?.jobNumber
            }else {
                CurrentUservars.jobNumber = appDelegate.currentUser?.jobNumber
            }
        }
        
        let currenUserJobDetails =  appDelegate.currentUser?.userDetailsArray?.first?.myPlaceDetailsArray.filter({ $0.jobNumber?.trim() == CurrentUservars.jobNumber?.trim()}).first
        self.currentJobDetails = currenUserJobDetails

        let authorizationString = "\(currenUserJobDetails?.userName ?? ""):\(currenUserJobDetails?.password ?? "")"
        let encodeString = authorizationString.base64String
        let auth = "Basic \(encodeString)"
        return (jobNumber : CurrentUservars.jobNumber, auth : auth)
    }
}

