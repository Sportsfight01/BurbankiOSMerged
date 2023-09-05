//
//  APIManager + Service Calls.swift
//  BurbankApp
//
//  Created by Naresh Banavath on 17/04/23.
//  Copyright © 2023 Sreekanth tadi. All rights reserved.
//

import Foundation

enum APIError : Error, Equatable
{
    case networkError(code : String)
    case decodingError(err : String)
    case other(err : String?)
    var description : String
    {
        switch self
        {
        case .networkError(code: let code):
            return "error occured status code \(code)"
        case .decodingError(err: _):
            return "error decoding json"
        case .other(err: let err):
            return err ?? somethingWentWrong
        }
    }
    
}
class APIManager{
    
    static let shared = APIManager()
    lazy var currentUserJobNumAndAuth = getJobNumberAndAuthorization()
    var currentJobDetails : MyPlaceDetails?
    private init() { self.getJobNumberAndAuthorization()}
    

    func getProgressDetails(showActivity : Bool = false, completion : ((Result<[ProgressStruct],APIError>)->())?)
    {
        guard let jobNumber = APIManager.shared.getJobNumberAndAuthorization().jobNumber else {debugPrint("JobNumber of auth is Null");return}
        let auth = APIManager.shared.getJobNumberAndAuthorization().auth
        if showActivity { appDelegate.showActivity() }
        NetworkRequest.makeRequestArray(type: ProgressStruct.self, urlRequest: Router.progressDetails(auth: auth, contractNo: jobNumber), showActivity: showActivity) { result in
            DispatchQueue.main.async { appDelegate.hideActivity() }
            switch result
            {
            case .success(let data):
        
                let requiredStages = ["frame stage", "lockup stage","fixout stage","completion","base stage","handover"]
                /// - We need data from api whose stageNames fall under requiredStages or phasecode == "presite"(for admin stage)
                let requiredProgressData = data.filter {
                   requiredStages.contains($0.stageName?.lowercased() ?? "") || $0.phasecode?.lc.contains("presite") ?? false
                }
                completion?(.success(requiredProgressData))
            case .failure(let err):
                #if DEBUG
                debugPrint("ERROR OCCURED")
                #endif
                DispatchQueue.main.async {
                    AlertManager.sharedInstance.showAlert(alertMessage: err.localizedDescription)
                }
                completion?(.failure(.other(err: err.localizedDescription)))
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
    
    //MARK: - ContactUS Service Calls
    private func contactUSLogin(completion : @escaping (Result<Bool,APIError>) ->())
    {
        guard let currentJobDetails = APIManager.shared.currentJobDetails else {debugPrint("currentJobDetailsNotAvailable");return}
        let url = "\(clickHomeV3BaseURL)Accounts/Login"
        let postDict = ["contractNumber":currentJobDetails.jobNumber ?? "","userName":currentJobDetails.userName ,"password": currentJobDetails.password]

        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: postDict)
        
        //LoginService
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            let httpResp = response as? HTTPURLResponse
            guard let httpResp, (200...299).contains(httpResp.statusCode) else {
//                completion(.failure(.networkError(code: "\(httpResp?.statusCode ?? 400)")));
                completion(.success(false))
                return}
           // debugPrint("contactUsLoginSuccessFull")
            //Get Notes service
            completion(.success(true))
              
        }.resume()

    }
    private func getNotesList(completion : @escaping(Result<[MyNotesStruct],APIError>) -> ())
    {
        let url = "\(clickHomeV3BaseURL)MasterContracts/Get"
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        //Post Data
        let json = """
         {
             "Notes": {
               "List": {
                    "author" : {
                            "fullUser" : {}
         },
                 "MetaData": {}
               }
             }
         }
         """.data(using: .utf8)
        urlRequest.httpBody = json
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            //Validation
            //debugPrint(response.debugDescription)
            let httpResp = response as? HTTPURLResponse
            guard let httpResp, (200...299).contains(httpResp.statusCode) else {
                completion(.success([]))
//                completion(.failure(.networkError(code: "\(httpResp?.statusCode ?? 400)")))
                return}
            guard let data else {
                completion(.failure(.other(err: error?.localizedDescription)))
                return }
            //:End Of Validation
            
            guard let jsonDict = try? JSONSerialization.jsonObject(with: data) as? NSDictionary else {
                completion(.failure(.other(err: "Json Serialization Failed")))
                return}
            guard let notesList = jsonDict.value(forKeyPath: "notes.list") as? [[String : Any]], let jsonData = try? JSONSerialization.data(withJSONObject: notesList) else {
                completion(.failure(.other(err: "Json Serialization Failed")))
                return
            }
            
            do {
                let json = try? JSONSerialization.jsonObject(with: jsonData)
                print(log: json)
                let tableData = try JSONDecoder().decode([MyNotesStruct].self, from: jsonData)
                completion(.success(tableData))
                
            }catch let err {
                completion(.failure(.decodingError(err: err.localizedDescription)))
            }
         
        }.resume()

        
    }

    func getNotes(completion : @escaping (Result<[MyNotesStruct], APIError>) ->()){
        
        self.contactUSLogin { result in
            switch result{
                
            case .success(_):
                debugPrint("ContactUsloginAPISuccessful")
                self.getNotesList { result in
                    switch result{
                    case .success(let notes):
                        debugPrint("notes api got successful results")
                        completion(.success(notes))
                    case .failure(let err):
                        debugPrint(err.localizedDescription)
                        completion(.failure(err))
                    }
             
                }
            case .failure(let err):
                debugPrint("ContactUsloginAPIFailed")
                completion(.failure(err))
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

