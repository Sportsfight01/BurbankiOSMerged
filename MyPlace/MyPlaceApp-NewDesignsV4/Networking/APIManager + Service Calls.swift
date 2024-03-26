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
    
    var currentJobDetailsV3 : myContractJobDetailsV3?
    
    var selectedContractIDForV3 = ""
    
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
    
    
    //MARK: - clickHomeV2Login Service Calls
    private func clickHomeV2Login(completion : @escaping (Result<Bool,APIError>) ->())
    {
        guard let currentJobDetails = APIManager.shared.currentJobDetails else {debugPrint("currentJobDetailsNotAvailable");return}
        let url = "\(clickHomeV2BaseURL)/Login"
//        let postDict = ["contractNumber":currentJobDetails.jobNumber ?? "","userName":currentJobDetails.userName ,"password": currentJobDetails.password]
        // static data used with santhosh
        let postDict = ["username": "santhosh.rechintala","password": "Sa9030343907@#","rememberMe": false] as [String : Any]

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
    
    private func getJobStepsList(completion : @escaping(Result<[ProgressStruct],APIError>) -> ())
    {
        guard let currentJobDetails = APIManager.shared.currentJobDetails else {debugPrint("currentJobDetailsNotAvailable");return}
        let url = "\(clickHomeV2BaseURL)/MasterContracts/223421"
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        //Post Data
        let json = """
         {
             "PRECONSTRUCTIONCONTRACT": {
                 "TASKS": {
                     "LIST": {
                         "STAGE": {}
                     }
                 }
             },
            "CONSTRUCTIONCONTRACT": {
            "TASKS": {
                        "LIST": {
                        "STAGE": {}
                    }
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
                completion(.failure(.networkError(code: "\(httpResp?.statusCode ?? 400)")))
                return}
            guard let data else {
                completion(.failure(.other(err: error?.localizedDescription)))
                return }
            //:End Of Validation
            guard let jsonDict = try? JSONSerialization.jsonObject(with: data) as? NSDictionary else {
                completion(.failure(.other(err: "Json Serialization Failed")))
                return}
            print("MasterContract Json Data : ", jsonDict)
            guard let constructionContractList = jsonDict.value(forKeyPath: "constructionContract.tasks") as? [String : Any], let jsonData = try? JSONSerialization.data(withJSONObject: constructionContractList) else {
                completion(.failure(.other(err: "Json Serialization Failed")))
                return
            }
            guard let preconstructionContractList = jsonDict.value(forKeyPath: "preconstructionContract.tasks") as? [String : Any], let jsonDataForPreConst = try? JSONSerialization.data(withJSONObject: preconstructionContractList) else {
                completion(.failure(.other(err: "Json Serialization Failed")))
                return
            }
           
           
            
            do {
                var jsonContract = try JSONSerialization.jsonObject(with: jsonData) as! [String : Any]
//                print(log: jsonContract)
                let jsonPrecon = try JSONSerialization.jsonObject(with: jsonDataForPreConst) as! [String : Any]
//                print(log: jsonPrecon)
                var constructionContractArr = jsonContract["list"] as! Array<[String : Any]>
                let preconstructionContractArr = jsonPrecon["list"] as! Array<[String : Any]>
                
                let flattenArray = [constructionContractArr, preconstructionContractArr].flatMap({ (element: Array<[String : Any]>) -> Array<[String : Any]> in
                    return element
                })
                var progressdataArr = [ProgressStruct]()
                
               
                
                for i in 0..<preconstructionContractArr.count{
                    var status = ""
                    let data = preconstructionContractArr[i] as! [String : Any]
                    let stageData = data["stage"] as! [String : Any]
                    if let completDate = data["completedDate"] as? String {
                        status = "Completed"
//                        print("admin stage task completion :------- ",status)
                    }
                    let progressdata = ProgressStruct(taskid: data["taskId"] as? Int, resourcename: data["taskName"] as? String, phasecode:  "presite", sequence: 0, name: data["taskName"] as? String, status: status, datedescription: "", dateactual: data["completedDate"] as? String, comment: "", forclient: false, stageID: stageData["stageId"] as? Int, stageName: stageData["stageName"] as? String)
                    
                    progressdataArr.append(progressdata)
                }
                
                for i in 0..<constructionContractArr.count{
                    var status = ""
                    let data = constructionContractArr[i] as! [String : Any]
                    let stageData = data["stage"] as! [String : Any]
                    if let completDate = data["completedDate"] as? String {
                        status = "Completed"
//                        print("remaining stages task completion :------- ",status)
                    }
                    if stageData["stageName"] as? String != "All Stages" &&  stageData["stageName"] as? String != "Administration"{
                        let progressdata = ProgressStruct(taskid: data["taskId"] as? Int, resourcename: data["taskName"] as? String, phasecode:  stageData["stageName"] as? String, sequence: 0, name: data["taskName"] as? String, status: status, datedescription: "", dateactual: data["completedDate"] as? String, comment: "", forclient: false, stageID: stageData["stageId"] as? Int, stageName: stageData["stageName"] as? String)
                        
                        progressdataArr.append(progressdata)
                    }
                   
                }
                
//                let tableData = try JSONDecoder().decode([ProgressStruct].self, from: jsonData)
                completion(.success(progressdataArr))
                
            }catch let err {
                completion(.failure(.decodingError(err: err.localizedDescription)))
            }
         
        }.resume()

        
    }
    
    
    // for getting Job steps we are calling click home v2 login and master contract....
    func getProgressV3(completion : @escaping (Result<[ProgressStruct], APIError>) ->()){
        
        self.clickHomeV2Login { result in
            switch result{
                
            case .success(_):
                debugPrint("clickHomev2LoginAPISuccessful")
                self.getJobStepsList { result in
                    switch result{
                    case .success(let notes):
                        debugPrint("JobstepsV2 api got successful results")
                        completion(.success(notes))
                    case .failure(let err):
                        debugPrint(err.localizedDescription)
                        completion(.failure(err))
                    }
             
                }
            case .failure(let err):
                debugPrint("clickHomev2LoginAPIFailed")
                completion(.failure(err))
            }
        
        }

    }
        
    //MARK: - ClickHomeV3 Service Calls
    
    
    
    
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
            guard let data else {
                completion(.failure(.other(err: error?.localizedDescription)))
                return }
            guard let jsonDict = try? JSONSerialization.jsonObject(with: data) as? NSDictionary else {
                completion(.failure(.other(err: "Json Serialization Failed")))
                return}
            do {
                let json = try JSONSerialization.jsonObject(with: data)
//                print(log: json)
                
                self.currentJobDetailsV3 = try JSONDecoder().decode(myContractJobDetailsV3.self, from: data)
                completion(.success(true))
                
            }catch let err {
                completion(.failure(.decodingError(err: err.localizedDescription)))
            }
//            completion(.success(true))
              
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
            "AnyContract":{},
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
            
            if jsonDict.value(forKeyPath:"leadContract.contractStatus" )  != nil && jsonDict.value(forKeyPath:"leadContract.contractStatus" ) as! String != "\0" {
                self.selectedContractIDForV3 = "\(jsonDict.value(forKeyPath:"leadContract.contractId" ) ?? "")"
             }
            else if jsonDict.value(forKeyPath:"preconstructionContract.contractStatus" ) != nil && jsonDict.value(forKeyPath:"preconstructionContract.contractStatus" ) as! String != "\0" {
                self.selectedContractIDForV3 = "\(jsonDict.value(forKeyPath:"preconstructionContract.contractId" ) ?? "")"
            }
           else if jsonDict.value(forKeyPath:"constructionContract.contractStatus" ) != nil && jsonDict.value(forKeyPath:"constructionContract.contractStatus" ) as! String != "\0" {
               
               self.selectedContractIDForV3 = "\(jsonDict.value(forKeyPath:"constructionContract.contractId" ) ?? "")"


            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: jsonData)
//                print(log: json)
                
                let tableData = try JSONDecoder().decode([MyNotesStruct].self, from: jsonData)
                completion(.success(tableData))
                
            }catch let err {
                completion(.failure(.decodingError(err: err.localizedDescription)))
            }
         
        }.resume()

        
    }

    
    
    
    // getting contact us and Notes list
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
    
    // for my details
    func getMyDetails(completion : @escaping (Result<ContactDetialsV3, APIError>) ->()){
        
        self.contactUSLogin { result in
            switch result{
                
            case .success(_):
                debugPrint("loginAPISuccessful")
                self.getMyDetailsAPI { result in
                    switch result{
                    case .success(let myDetails):
                        debugPrint("my details api got successful results")
                        completion(.success(myDetails))
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
    
    
    
    private func getMyDetailsAPI(completion : @escaping(Result<ContactDetialsV3,APIError>) -> ())
    {
        let url = "\(clickHomeV3BaseURL)MasterContracts/Get"
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        //Post Data
        let json = """
         {
                "houseType": {
                "brand":{},
                "facade":{},
                "documents":{
                "list":{
                    "url":true
                    }
                 }
             },
             "facade":{}
          }
         """.data(using: .utf8)
        urlRequest.httpBody = json
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            //Validation
            //debugPrint(response.debugDescription)
            let httpResp = response as? HTTPURLResponse
            guard let httpResp, (200...299).contains(httpResp.statusCode) else {
//                completion(.success(ContactDetialsV3.self))
                completion(.failure(.networkError(code: "\(httpResp?.statusCode ?? 400)")))
                return}
            guard let data else {
                completion(.failure(.other(err: error?.localizedDescription)))
                return }
            //:End Of Validation
            
            guard let jsonDict = try? JSONSerialization.jsonObject(with: data) as? NSDictionary else {
                completion(.failure(.other(err: "Json Serialization Failed")))
                return}
            
            do {
                let json = try JSONSerialization.jsonObject(with: data)
//                print(log: json)
                
                let tableData = try JSONDecoder().decode(ContactDetialsV3.self, from: data)
                completion(.success(tableData))
                
            }catch let err {
                completion(.failure(.decodingError(err: err.localizedDescription)))
            }
         
        }.resume()

        
    }
    
    
    
    // for my Documents
    func getMyDocuments(isDocuments : Bool, completion : @escaping (Result<[DocumentsDetailsStructV3], APIError>) ->()){
        
        self.contactUSLogin { result in
            switch result{
                
            case .success(_):
                debugPrint("loginAPISuccessful")
                self.getMyDocumentsAPI(isDocuments: isDocuments) { result in
                    switch result{
                    case .success(let myDetails):
                        debugPrint("my details api got successful results")
                        completion(.success(myDetails))
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
    
    
    
    private func getMyDocumentsAPI(isDocuments : Bool,completion : @escaping(Result<[DocumentsDetailsStructV3],APIError>) -> ())
    {
        let url = "\(clickHomeV3BaseURL)MasterContracts/Get"
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        //Post Data
        var keyForDocAndPhotos = ""
        
        let json = """
         {    "documents": {
                     "list": {
                                 "url": true,
                                 "thumbnailUrl": true,
                                 "metaData": {
                                 }
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
//                completion(.success(ContactDetialsV3.self))
                completion(.failure(.networkError(code: "\(httpResp?.statusCode ?? 400)")))
                return}
            guard let data else {
                completion(.failure(.other(err: error?.localizedDescription)))
                return }
            //:End Of Validation
            
            guard let jsonDict = try? JSONSerialization.jsonObject(with: data) as? NSDictionary else {
                completion(.failure(.other(err: "Json Serialization Failed")))
                return}
           
            if isDocuments{
                keyForDocAndPhotos = "documents.list"
            }else{
                keyForDocAndPhotos = "photos.list"
            }
            guard let docList = jsonDict.value(forKeyPath: keyForDocAndPhotos) as? [[String : Any]], let jsonData = try? JSONSerialization.data(withJSONObject: docList) else {
                completion(.failure(.other(err: "Json Serialization Failed")))
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: jsonData)
//                print(log: json)
                
                let tableData = try JSONDecoder().decode([DocumentsDetailsStructV3].self, from: jsonData)
                completion(.success(tableData))
                
            }catch let err {
                completion(.failure(.decodingError(err: err.localizedDescription)))
            }
         
        }.resume()

        
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

extension Dictionary {
    mutating func mergingDict(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}
