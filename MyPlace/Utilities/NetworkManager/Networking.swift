//
//  Service.swift
//  MyPlace
//
//  Created by Sreekanth tadi on 18/03/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit
import Foundation

typealias successBlock = (_ data: AnyObject?, _ response: URLResponse) -> Void

typealias errorBlock = (_ error: Error?, _ jsonError: Bool) -> Void

typealias progressBlock = (_ progress: Float?) -> Void

typealias noParamsBlock = () -> Void




class Networking: NSObject {
    static let shared: Networking = Networking()
}


class NetworkClient {
    var interceptor: Interceptors?
    
    func sendRequest(_ request: URLRequest,success: @escaping successBlock, errorblock: @escaping errorBlock) {
        guard let interceptor = interceptor else {
            print("No interceptor set")
            return
        }
        
        interceptor.intercept(request: request) { data, response, error in
            // Handle response or error here
            if let httpResponse = response as? HTTPURLResponse {
                print("Response status code: \(httpResponse.statusCode)")
                DispatchQueue.main.async {
                    success(data as? AnyObject, response as! HTTPURLResponse)
                    print("Response Json Object from service after 401:")
                }
            }else{
                errorblock(error, true)
            }
        }
    }
}

extension Networking {
    
    
    
    
    func GET_request(url: String, userInfo: NSDictionary?, success: @escaping successBlock, errorblock: @escaping errorBlock, progress: progressBlock?, showActivity: Bool = true, returnJSON: Bool = true) -> Any? {
        
        if url.trim().count == 0 {
            assertionFailure("url shouldn't empty")
        }
        
        if isNetworkConnectionAvailable { print(log: "network available") }
        else {
            if showActivity { showAlert(knetworkErrorMessage) }
            return nil
        }
        
        let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let _ = URL(string: urlString) else { return nil }
        
        let request = createRequest(url: urlString, method: kGet, authKey: appDelegate.guestUserAccessToken ?? "")

        let session = URLSession.init(configuration: .default, delegate: nil, delegateQueue: .main)
        
        if showActivity { showActivityManager() }
        
        print(log: "WEBURL ==\n\n" + urlString)
        
        print(log: request)
        
        
        let datatask = session.dataTask(with: request) { (data, response, error) in
            
            if showActivity { hideActivityManager() }
            
            if let err = error {
                if err.localizedDescription.lowercased() != "cancelled" {
                    errorblock(err, false)
                }
            }else {
                
                if response is HTTPURLResponse, (response as! HTTPURLResponse).statusCode > 499 {
                    
                    print(log: "WEBURL ==\n\n" + urlString + "\n")
                    print(log: response ?? "")
                    
                    ActivityManager.showToast(kServerErrorMessage)
                    
                }else {
                    
                    DispatchQueue.main.async {
                        
                        if returnJSON {
                            if let jsonObj: AnyObject = self.jsonResponse(data) {
                                
                                print(log: "WEBURL ==\n\n" + urlString)
                                if let da = data {
                                    print(log: String.init(data: da, encoding: .utf8) as Any)
                                }
                                print(log: jsonObj)
                                
                                if jsonObj is Error {
                                    if self.isSessionExpired(data as AnyObject, response: response) {
                                        let client = NetworkClient()
                                        let loggingInterceptor = LoggingInterceptor()
                                        let authorizationInterceptor = AuthorizationInterceptor()
                                        loggingInterceptor.nextinterceptor = authorizationInterceptor
                                        client.interceptor = authorizationInterceptor
                                        client.sendRequest(request, success: {data,response in
                                            if let jsonObj: AnyObject = self.jsonResponse(data as? Data){
                                                success(jsonObj, response as! HTTPURLResponse)
                                            }
                                        }, errorblock: {error,jsonError in
                                            errorblock(jsonObj as? Error, true)
                                        })
                                    }
                                    
                                    else { errorblock(jsonObj as? Error, true) }
                                }else {
                                    if self.isSessionExpired(jsonObj, response: response) {
                                        let client = NetworkClient()
                                        let loggingInterceptor = LoggingInterceptor()
                                        let authorizationInterceptor = AuthorizationInterceptor()
                                        loggingInterceptor.nextinterceptor = authorizationInterceptor
                                        client.interceptor = authorizationInterceptor
                                        client.sendRequest(request, success: {data,response in
                                            if let jsonObj: AnyObject = self.jsonResponse(data as? Data){
                                                success(jsonObj, response as! HTTPURLResponse)
                                            }
                                        }, errorblock: {error,jsonError in
                                            errorblock(jsonObj as? Error, true)
                                        })
                                    }
                                    else {
                                        success(jsonObj, response as! HTTPURLResponse) }
                                }
                            }
                        }else {
                            
                            if let jsonObj: AnyObject = self.jsonResponse(data) {
                                
                                print(log: "WEBURL ==\n\n" + urlString)
                                print(log: jsonObj)
                                
                                if jsonObj is Error {
                                    if self.isSessionExpired(data as AnyObject, response: response) {
                                        let client = NetworkClient()
                                        let loggingInterceptor = LoggingInterceptor()
                                        let authorizationInterceptor = AuthorizationInterceptor()
                                        loggingInterceptor.nextinterceptor = authorizationInterceptor
                                        client.interceptor = authorizationInterceptor
                                        client.sendRequest(request, success: {data,response in
                                            if let jsonObj: AnyObject = self.jsonResponse(data as? Data){
                                                success(jsonObj, response as! HTTPURLResponse)
                                            }
                                        }, errorblock: {error,jsonError in
                                            errorblock(jsonObj as? Error, true)
                                        })
                                    }
                                    else { errorblock(jsonObj as? Error, true) }
                                }else {
                                    if self.isSessionExpired(data as AnyObject, response: response) {
                                        let client = NetworkClient()
                                        let loggingInterceptor = LoggingInterceptor()
                                        let authorizationInterceptor = AuthorizationInterceptor()
                                        loggingInterceptor.nextinterceptor = authorizationInterceptor
                                        client.interceptor = authorizationInterceptor
                                        client.sendRequest(request, success: {data,response in
                                            if let jsonObj: AnyObject = self.jsonResponse(data as? Data){
                                                success(jsonObj, response as! HTTPURLResponse)
                                            }
                                        }, errorblock: {error,jsonError in
                                            errorblock(jsonObj as? Error, true)
                                        })
                                    }
                                    else {
                                        success(data as AnyObject, response as! HTTPURLResponse) }
                                }
                            }else {
                                print("success Data after Authentication")
                                success(data as AnyObject, response as! HTTPURLResponse)
                            }
                        }
                    }
                }
            }
        }
        datatask.resume()
        
        return datatask
    }
    
    
    func POST_request (url: String, parameters: NSDictionary, userInfo: NSDictionary?, success: @escaping successBlock, errorblock: @escaping errorBlock, progress: progressBlock?, showActivity: Bool = true, returnJSON: Bool = true)  -> Any? {
        
       
        
        if url.trim().count == 0 {
            assertionFailure("url shouldn't empty")
        }
        
        if isNetworkConnectionAvailable { print(log: "network available") }
        else {
            if showActivity { showAlert(knetworkErrorMessage) }
            return nil
        }
    
        guard let _ = URL(string: url) else { return nil }
        var request =  createRequest(url: url, method: kPost, authKey :  appDelegate.guestUserAccessToken ?? "")
        if parameters.allKeys.count > 0 {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                
                if let bodyData = request.httpBody {
                    print(log: "WEBURL ==\n\n" + url + String.init(data: bodyData, encoding: .utf8)! + "\n")
                }
            }catch let jsonError {
                print(log: "jsonError: " + jsonError.localizedDescription)
            }
        }
        
        let session = URLSession.init(configuration: .default, delegate: nil, delegateQueue: .main)
        
        if showActivity { showActivityManager() }
//        print(log: String(format: "WEBURL ==\n\n %@ \n %@ \n", url, getJSONString(fromDictnary:parameters as? [AnyHashable : Any])!))
        let datatask = session.dataTask(with: request) { (data, response, error) in
            
            if showActivity { hideActivityManager() }
            
            if let err = error {
                if err.localizedDescription.lowercased() != "cancelled" {
                    alert.showAlert("Error", err.localizedDescription)
                }else {
                    errorblock(err, false)
                }
            }else {
                
                if response is HTTPURLResponse, (response as! HTTPURLResponse).statusCode > 499 {
                    
                    print(log: "WEBURL ==\n\n" + url + "\n\n")
                    print(log: response ?? "")
                    
                    ActivityManager.showToast(kServerErrorMessage)

                    
                }else {
                    
                    DispatchQueue.main.async {
                        
                        if returnJSON {
                            if let jsonObj: AnyObject = self.jsonResponse(data) {
                                
                                print(log: "WEBURL ==\n\n" + url)
                                if let bodyData = request.httpBody {
                                    print(log: String.init(data: bodyData, encoding: .utf8)! + "\n")
                                }
                                if let da = data {
                                    print(log: String.init(data: da, encoding: .utf8) as Any)
                                }
                                print(log: jsonObj)
                                
                                if jsonObj is Error {
                                    if self.isSessionExpired(data as AnyObject, response: response) {
                                        let client = NetworkClient()
                                        let loggingInterceptor = LoggingInterceptor()
                                        let authorizationInterceptor = AuthorizationInterceptor()
                                        loggingInterceptor.nextinterceptor = authorizationInterceptor
                                        client.interceptor = authorizationInterceptor
                                        client.sendRequest(request, success: {data,response in
                                            if let jsonObj: AnyObject = self.jsonResponse(data as? Data){
                                                success(jsonObj, response as! HTTPURLResponse)
                                            }
                                        }, errorblock: {error,jsonError in
                                            errorblock(jsonObj as? Error, true)
                                        })
                                    }else { errorblock(jsonObj as? Error, true) }
                                }else {
                                    if self.isSessionExpired(data as AnyObject, response: response) {
                                        let client = NetworkClient()
                                        let loggingInterceptor = LoggingInterceptor()
                                        let authorizationInterceptor = AuthorizationInterceptor()
                                        loggingInterceptor.nextinterceptor = authorizationInterceptor
                                        client.interceptor = authorizationInterceptor
                                        client.sendRequest(request, success: {data,response in
                                            if let jsonObj: AnyObject = self.jsonResponse(data as? Data){
                                                success(jsonObj, response as! HTTPURLResponse)
                                            }
                                        }, errorblock: {error,jsonError in
                                            errorblock(jsonObj as? Error, true)
                                        })                                }
                                    else { print("success Data after Authentication")
                                        success(jsonObj, response as! HTTPURLResponse) }
                                }
                            }
                        }else {
                            
                            if let jsonObj: AnyObject = self.jsonResponse(data) {
                                
                                print(log: "WEBURL ==\n\n" + url)
                                if let bodyData = request.httpBody {
                                    print(log: String.init(data: bodyData, encoding: .utf8)! + "\n")
                                }
                                print(log: jsonObj)
                                if jsonObj is Error {
                                    if self.isSessionExpired(data as AnyObject, response: response) {
                                        let client = NetworkClient()
                                        let loggingInterceptor = LoggingInterceptor()
                                        let authorizationInterceptor = AuthorizationInterceptor()
                                        loggingInterceptor.nextinterceptor = authorizationInterceptor
                                        client.interceptor = authorizationInterceptor
                                        client.sendRequest(request, success: {data,response in
                                            if let jsonObj: AnyObject = self.jsonResponse(data as? Data){
                                                success(jsonObj, response as! HTTPURLResponse)
                                            }
                                        }, errorblock: {error,jsonError in
                                            errorblock(jsonObj as? Error, true)
                                        })
                                    }
                                    else { errorblock(jsonObj as? Error, true) }
                                }else {
                                    if self.isSessionExpired(jsonObj, response: response) {
                                        let client = NetworkClient()
                                        let loggingInterceptor = LoggingInterceptor()
                                        let authorizationInterceptor = AuthorizationInterceptor()
                                        loggingInterceptor.nextinterceptor = authorizationInterceptor
                                        client.interceptor = authorizationInterceptor
                                        client.sendRequest(request, success: {data,response in
                                            if let jsonObj: AnyObject = self.jsonResponse(data as? Data){
                                                success(jsonObj, response as! HTTPURLResponse)
                                            }
                                        }, errorblock: {error,jsonError in
                                            errorblock(jsonObj as? Error, true)
                                        })
                                    }
                                    else {
                                        success(data as AnyObject, response as! HTTPURLResponse) }
                                }
                            }else {
                                success(data as AnyObject, response as! HTTPURLResponse)
                            }
                        }
                    }
                }
            }
        }
        
        datatask.resume()
        
        return datatask
}
    
    
    
    
    private func createRequest (url: String, method: String, authKey : String) -> URLRequest {
        var request = URLRequest(url: URL(string: url)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 120)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(authKey)", forHTTPHeaderField: "Authorization")
        print("------- Bearer \(authKey)")
        return request
    }
    
    
    func jsonResponse (_ responseData: Data?) -> AnyObject? {
        if let data = responseData {
            do {
                return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            } catch let jsonError {
                
                return jsonError as AnyObject
            }
        }else {
            return nil
        }
    }
    
    
    //MARK: - Session Expiration
    
//    func isSessionExpired (_ jsonObj: AnyObject, response: URLResponse?) -> Bool {
//    
//        if (response as? HTTPURLResponse)?.statusCode == 401 { //Authorization has been denied for this request.
//            if (((jsonObj as? NSDictionary)?.allKeys as? [String])?.contains("message") ?? false) || (((jsonObj as? NSDictionary)?.allKeys as? [String])?.contains("Message") ?? false) {
//                if let message = ((jsonObj as? NSDictionary)?.value(forKey: "message") as? String) ?? ((jsonObj as? NSDictionary)?.value(forKey: "Message") as? String)  {
//                    if message.lowercased().contains("unauthorized") {
////                        appDelegate.guestUserAccessToken = " "
//                    // in V3.6 changed Authentication process
//                        return true
//                    }
//                }
//            }else if jsonObj is Data {
//                if let str = String (data: jsonObj as! Data, encoding: .utf8) {
//                    if let message = ((str as? NSDictionary)?.value(forKey: "Message") as? String) {
//                        if message.lowercased().contains("unauthorized") {
//                                return true
//                            }
//                    }
//                    }
//                }
//            }
//            return false
//        }
    
    func isSessionExpired (_ jsonObj: AnyObject, response: URLResponse?) -> Bool {
        if (response as? HTTPURLResponse)?.statusCode == 401 {
            return true
        }else{
            return false
        }
    }
    

    
   // MARK: -  User Authentication
    // From V3.6 Added Authentication for all API's
    
    func handleDefaultAuthforToken (completion: @escaping (String) -> Void) {
        let params1 = [
            "Username": "burbank_minad",
            "Password": "401b09eab3c013d4ca54922bb802bec8fd5318192b0a75f201d8b3727429090fb337591abd3e44453b954555b7a0812e1081c39b740293f765eae731f5a65ed1"
          ]
        let urls =  URL(string: ServiceAPI.shared.URl_authanticate)!
        var request = URLRequest(url:urls)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        if params1.count > 0 {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: params1, options: [])

                if let bodyData = request.httpBody {
//                    print(log: "WEBURL ==\n\n" + ServiceAPI.shared.URl_authanticate + String.init(data: bodyData, encoding: .utf8)! + "\n")
                }
            }catch let jsonError {
//                print(log: "jsonError: " + jsonError.localizedDescription)
            }
        }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Check for errors
            if let error = error {
//                print("Error: \(error)")
                return
            }
            guard let jsonData = data else {
//                print("No data received")
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
//                    print("-------Json Data For auth Key",json)
                    appDelegate.guestUserAccessToken = json["Token"] as? String ?? ""
                    completion(appDelegate.guestUserAccessToken ?? "")
                }
            } catch {
//                print("Error deserializing JSON: \(error)")
            }
        }
        task.resume()
            
        }

    
}


func getJSONString(fromDictnary Dictw: [AnyHashable : Any]?) -> String? {
    let Dict = Dictw
    
    var jsonData: Data? = nil
    if let aDict = Dict {
        jsonData = try? JSONSerialization.data(withJSONObject: aDict, options: [])
    }
    var myString: String? = nil
    if let aData = jsonData {
        myString = String(data: aData, encoding: .utf8)
    }
    return myString
    
}


//Usage

/*
 
 let params = NSMutableDictionary ()
    
    _ = Networking.shared.POST_request(url: ServiceAPI.shared.URL_, parameters: params, userInfo: nil, success: { (json, response) in
        
        if let result: AnyObject = json {
            
            let result = result as! NSDictionary
            
            if let _ = result.value(forKey: "statusCode"), (result.value(forKey: "statusCode") as? NSNumber) == 200 {
                                
                if (result.allKeys as! [String]).contains("Data") {
                    
                                        
                }
                
            }else {
                
                print(log: "no data found")
            }
        }else {
            
        }
        
    }, errorblock: { (error, isJsonError) in
    
        if isJsonError { }
        else { }
        
    }, progress: nil)
 
 */
