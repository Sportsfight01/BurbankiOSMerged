//
//  Router.swift
//  BurbankApp
//
//  Created by naresh banavath on 02/12/21.
//  Copyright © 2021 DMSS. All rights reserved.
//

import UIKit
import Alamofire
//let baseURL = "https://www.burbank.com.au/CentralLogin.WebApi/api/"
//let baseUrl = "https://www.burbank.com.au/CentralLogin.WebApi/api/"
typealias Parameters = [String : Any]
enum HTTPMethod : String
{
    case get = "GET"
    case post = "POST"
}

//let addCoBurbankURL = String(format: "%@coburbank/AddCoBurbank", baseURL)
//let getCoBurbankInvitationsListURL = String(format: "%@coburbank/GetCoBurbankNotifications", baseURL)
//let acceptInvitationURL = String(format: "%@coburbank/AcceptInvitation", baseURL)
//let rejectInvitationURL = String(format: "%@coburbank/RejectInvitation", baseURL)
//let sendInvitationURL = String(format: "%@coburbank/SendInvitation", baseURL)
//let deleteInvitationURL = String(format: "%@coburbank/Delete", baseURL)
//let faqURL = String(format: "%@coburbank/Delete", baseURL)


enum Router:URLRequestConvertible{
   
    
    // case login(username : String , password : String, deviceId: String, IMEI: String,fcmToken: String ,deviceType:String)
    
    case progressDetails(auth : String , contractNo : String)
    case contractDetails(auth : String, contractNo : String)
    case documentsDetails(auth : String, contractNo : String)
    case getNotes(auth : String, contractNo : String)
    case postNotes(auth : String, contractNo : String, parameters : Parameters)
    case getFinanceDetails(jobNumber : String)
    case login(parameters : Parameters)
    case getUserProfile(parameters : Parameters)
    case updateUserProfile(parameters : Parameters)
    case updateProfilePic(parameters : Parameters)
    case infoCentreDetails
    case faqsQuestionAndAnswers
    case getClientInfoForContractNumber(jobNumber : String)
    case getCoBurbankInfo(parameters : Parameters)
    case addCoBurbankData(parameters : Parameters)
    case getCoBurbankNotifications(parameters : Parameters)
    case acceptIntivtationCoBurbank(parameters : Parameters)
    case rejectCoBurbank(parameters : Parameters)
    case sendInvitationCoBurbank(parameters : Parameters)
    case deleteInvitationCoBurbank(parameters : Parameters)
    
    var method:HTTPMethod{
        
        switch self {
            
            //loginWithUserName
        case .login ,.getUserProfile, .getCoBurbankInfo, .addCoBurbankData, .getCoBurbankNotifications, .acceptIntivtationCoBurbank , .rejectCoBurbank , .sendInvitationCoBurbank, .deleteInvitationCoBurbank , .updateUserProfile, .updateProfilePic, .postNotes:
            return .post
            
        case .progressDetails , .contractDetails , .documentsDetails , .getFinanceDetails, .infoCentreDetails, .faqsQuestionAndAnswers , .getClientInfoForContractNumber, .getNotes:
            return .get
            
        }
    }
    var path:String {
        
        switch self {
            
            //Login
        case .login:
            return "login/getUserDetails"
        case .getUserProfile:
            return "userProfile/getUserProfile"
        case .updateUserProfile:
            return "userProfile/UpdateUserProfile"
        case .updateProfilePic:
            return "userProfile/UpdateProfilePic"
       
        case .progressDetails:
            return myPlaceProgressDetailsURLString()
        case .contractDetails:
            return myPlaceContractDetailsURLString()
        case .documentsDetails:
            return myPlaceDocumentsDetailsURLString()
        case .getNotes:
            return myPlaceNotesURLString()
        case .postNotes:
            return myPlaceNotesURLString()
        case .getFinanceDetails:
            return "\(getMyPlaceURL())finance/GetFinance?financialTicketId="
        case .infoCentreDetails:
            return getInfoCentreDetails()
        case .faqsQuestionAndAnswers:
            return getFaq()
        case .getClientInfoForContractNumber:
            return "\(getMyPlaceURL())survey/GetClientInfoForContractNumber?jobNumber="
        case .getCoBurbankInfo:
            return "coburbank/GetCoBurbanks"
        case .addCoBurbankData :
            return "coburbank/AddCoBurbank"
        case .getCoBurbankNotifications :
            return "coburbank/GetCoBurbankNotifications"//hold
        case .acceptIntivtationCoBurbank :
            return "coburbank/AcceptInvitation" //hold
        case .rejectCoBurbank :
            return "coburbank/RejectInvitation" //hold
        case .sendInvitationCoBurbank :
            return "coburbank/SendInvitation"
        case .deleteInvitationCoBurbank :
            return "coburbank/Delete"
        }
    }
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        // urlRequest.timeoutInterval = TimeInterval(urlRequestTimeOutInterval)
        switch self {
            //OTP
            //        case .getOTP4DeviceResetorReg(let userName):
            //            let pathString = path
            //            urlRequest = URLRequest(url: url.appendingPathComponent(pathString))
            //            urlRequest.setValue(userName, forHTTPHeaderField: "userName")
            //            urlRequest.httpMethod = method.rawValue
            //            urlRequest = try JSONEncoding.default.encode(urlRequest)
            //        //Device ResetOrReg
            //        case .deviceResetorRegistration(let userName, let deviceId, let isReset):
            //            let pathString = path
            //            urlRequest = URLRequest(url: url.appendingPathComponent(pathString))
            //            urlRequest.setValue(userName, forHTTPHeaderField: "userName")
            //            urlRequest.setValue(deviceId, forHTTPHeaderField: "deviceId")
            //            urlRequest.setValue(isReset, forHTTPHeaderField: "isReset")
            //            urlRequest.httpMethod = method.rawValue
            //            urlRequest = try JSONEncoding.default.encode(urlRequest)
            
            //Login
        case .login (let parameters):
            let pathString = path
            urlRequest = URLRequest(url: url.appendingPathComponent(pathString))
            urlRequest.httpMethod = method.rawValue
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            urlRequest = try JSONEncoding.default.encode(urlRequest)
            print(urlRequest)
            
        case .getUserProfile(let parameters) , .updateUserProfile(let parameters), .updateProfilePic(let parameters):
            
            let pathString = path
            urlRequest = URLRequest(url: url.appendingPathComponent(pathString))
            urlRequest.httpMethod = method.rawValue
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            urlRequest = try JSONEncoding.default.encode(urlRequest)
            print(urlRequest)
            
            //    case .getOfficeCoordinates:
            //      //urlRequest = URLRequest(url: url.appendingPathComponent(pathString))
            //      urlRequest.httpMethod = method.rawValue
            //      urlRequest = try JSONEncoding.default.encode(urlRequest)
            //    case .updateTaskDetails(let parameters):
            //      // urlRequest = URLRequest(url: url.appendingPathComponent(pathString))
            //      urlRequest.httpMethod = method.rawValue
            //      urlRequest = try JSONEncoding.default.encode(urlRequest)
            
        case .postNotes(let auth, let contractNo, let parameters):
            let url = URL(string: path)
            urlRequest = URLRequest(url: url!)
            
            if selectedJobNumberRegion != .OLD
            {
                urlRequest.addValue(auth, forHTTPHeaderField: "Authorization")
                urlRequest.addValue(contractNo, forHTTPHeaderField: "ContractNumber")
                
            }
            urlRequest.httpMethod = method.rawValue
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            urlRequest = try JSONEncoding.default.encode(urlRequest)
            
        case .progressDetails(let auth , let contractNo) , .contractDetails(let auth, let contractNo) , .documentsDetails(let auth, let contractNo) , .getNotes(let auth, let contractNo):
            // let pathString = path
            let url = URL(string: path)
            urlRequest = URLRequest(url: url!)
            
            if selectedJobNumberRegion != .OLD
            {
                urlRequest.addValue(auth, forHTTPHeaderField: "Authorization")
                urlRequest.addValue(contractNo, forHTTPHeaderField: "ContractNumber")
                
            }
            urlRequest.httpMethod = method.rawValue
            urlRequest = try JSONEncoding.default.encode(urlRequest)
            //  print(urlRequest)
            
        case .getFinanceDetails(let jobNumber) , .getClientInfoForContractNumber(let jobNumber):
            let urlStr = path + jobNumber
            let url = URL(string: urlStr)
            urlRequest = URLRequest(url: url!)
            urlRequest.httpMethod = method.rawValue
            urlRequest = try JSONEncoding.default.encode(urlRequest)
        case .infoCentreDetails :
            let url = URL(string: path)
            urlRequest = URLRequest(url: url!)
            urlRequest.httpMethod = method.rawValue
            urlRequest = try JSONEncoding.default.encode(urlRequest)
        case .faqsQuestionAndAnswers :
            let url = URL(string: path)
            urlRequest = URLRequest(url: url!)
            urlRequest.httpMethod = method.rawValue
            urlRequest = try JSONEncoding.default.encode(urlRequest)
            
        case .getCoBurbankInfo(parameters: let parameters):
            let pathString = path
            urlRequest = URLRequest(url: url.appendingPathComponent(pathString))
            urlRequest.httpMethod = method.rawValue
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            urlRequest = try JSONEncoding.default.encode(urlRequest)
            print(urlRequest)
        case .addCoBurbankData(parameters: let parameters):
            let pathString = path
            urlRequest = URLRequest(url: url.appendingPathComponent(pathString))
            urlRequest.httpMethod = method.rawValue
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            urlRequest = try JSONEncoding.default.encode(urlRequest)
            print(urlRequest)
        case .getCoBurbankNotifications(parameters: let parameters):
            let pathString = path
            urlRequest = URLRequest(url: url.appendingPathComponent(pathString))
            urlRequest.httpMethod = method.rawValue
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            urlRequest = try JSONEncoding.default.encode(urlRequest)
            print(urlRequest)
        case .acceptIntivtationCoBurbank(parameters: let parameters):
            let pathString = path
            urlRequest = URLRequest(url: url.appendingPathComponent(pathString))
            urlRequest.httpMethod = method.rawValue
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            urlRequest = try JSONEncoding.default.encode(urlRequest)
            print(urlRequest)
        case .rejectCoBurbank(parameters: let parameters):
            let pathString = path
            urlRequest = URLRequest(url: url.appendingPathComponent(pathString))
            urlRequest.httpMethod = method.rawValue
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            urlRequest = try JSONEncoding.default.encode(urlRequest)
            print(urlRequest)
        case .sendInvitationCoBurbank(parameters: let parameters):
            let pathString = path
            urlRequest = URLRequest(url: url.appendingPathComponent(pathString))
            urlRequest.httpMethod = method.rawValue
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            urlRequest = try JSONEncoding.default.encode(urlRequest)
            print(urlRequest)
        case .deleteInvitationCoBurbank(parameters: let parameters):
            let pathString = path
            urlRequest = URLRequest(url: url.appendingPathComponent(pathString))
            urlRequest.httpMethod = method.rawValue
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            urlRequest = try JSONEncoding.default.encode(urlRequest)
            print(urlRequest)
        }
        return urlRequest
    }
}

