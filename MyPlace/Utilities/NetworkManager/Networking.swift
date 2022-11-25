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
        print(url)
        let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        print(urlString)
        guard let _ = URL(string: urlString) else { return nil }
        
        let request = createRequest(url: urlString, method: kGet)
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
                    
                    if returnJSON {
                        if let jsonObj: AnyObject = self.jsonResponse(data) {
                            
                            print(log: "WEBURL ==\n\n" + urlString)
                            if let da = data {
                                print(log: String.init(data: da, encoding: .utf8) as Any)
                            }
                            print(log: jsonObj)
                            
                            if jsonObj is Error {
                                if self.isSessionExpired(data as AnyObject, response: response) { }
                                else { errorblock(jsonObj as? Error, true) }
                            }else {
                                if self.isSessionExpired(jsonObj, response: response) { }
                                else { success(jsonObj, response as! HTTPURLResponse) }
                            }
                        }
                    }else {
                        
                        if let jsonObj: AnyObject = self.jsonResponse(data) {
                            
                            print(log: "WEBURL ==\n\n" + urlString)
                            print(log: jsonObj)
                            
                            if jsonObj is Error {
                                if self.isSessionExpired(data as AnyObject, response: response) { }
                                else { errorblock(jsonObj as? Error, true) }
                            }else {
                                if self.isSessionExpired(jsonObj, response: response) { }
                                else { success(data as AnyObject, response as! HTTPURLResponse) }
                            }
                        }else {
                            success(data as AnyObject, response as! HTTPURLResponse)
                        }
                    }
                }
            }
        }
        datatask.resume()
        
        return datatask
    }
    
    
    func POST_request (url: String, parameters: NSDictionary, userInfo: NSDictionary?, success: @escaping successBlock, errorblock: @escaping errorBlock, progress: progressBlock?, showActivity: Bool = true, returnJSON: Bool = true) -> Any? {
        
         if url.trim().count == 0 {
            assertionFailure("url shouldn't empty")
        }
        
        if isNetworkConnectionAvailable { print(log: "network available") }
        else {
            if showActivity { showAlert(knetworkErrorMessage) }
            return nil
        }
        
        guard let _ = URL(string: url) else { return nil }

        var request = createRequest(url: url, method: kPost)
        
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
                                if self.isSessionExpired(data as AnyObject, response: response) { }
                                else { errorblock(jsonObj as? Error, true) }
                            }else {
                                if self.isSessionExpired(jsonObj, response: response) { }
                                else { success(jsonObj, response as! HTTPURLResponse) }
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
                                if self.isSessionExpired(data as AnyObject, response: response) { }
                                else { errorblock(jsonObj as? Error, true) }
                            }else {
                                if self.isSessionExpired(jsonObj, response: response) { }
                                else { success(data as AnyObject, response as! HTTPURLResponse) }
                            }
                        }else {
                            success(data as AnyObject, response as! HTTPURLResponse)
                        }
                    }
                }
            }
        }
        
        datatask.resume()
        
        return datatask
    }
    
    
    
    
    private func createRequest (url: String, method: String) -> URLRequest {
        var request = URLRequest(url: URL(string: url)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 120)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        if ServiceAPI.shared.authorizationRequired(url), kToken.count > 0 {
            print(log: kToken)
            request.setValue("Bearer \(kToken)", forHTTPHeaderField: "Authorization")
        }else {
//            request.setValue("Bearer ", forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
    
    
    func jsonResponse (_ responseData: Data?) -> AnyObject? {
        if let data = responseData {
            do {
                return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            } catch let jsonError {
                print(log: jsonError)
                return jsonError as AnyObject
            }
        }else {
            return nil
        }
    }
    
    
    //MARK: - Session Expiration
    
    func isSessionExpired (_ jsonObj: AnyObject, response: URLResponse?) -> Bool {
        
        if (response as? HTTPURLResponse)?.statusCode == 401 { //Authorization has been denied for this request.
            if (((jsonObj as? NSDictionary)?.allKeys as? [String])?.contains("message") ?? false) || (((jsonObj as? NSDictionary)?.allKeys as? [String])?.contains("Message") ?? false) {
                if let message = ((jsonObj as? NSDictionary)?.value(forKey: "message") as? String) ?? ((jsonObj as? NSDictionary)?.value(forKey: "Message") as? String)  {
                    if message.lowercased().contains("denied") {
                        // "message": "Authorization has been denied for this request."
                        if Int(kUserID)! > 0 {
                            alert.showAlert(kAPPNAME, "Session Expired, Please login Again!", kWindow.rootViewController!, ["OK"]) { (str) in
                                logoutUser ()
                            }
                        }
                        return true
                    }
                }
            }else if jsonObj is Data {
                if let str = String (data: jsonObj as! Data, encoding: .utf8) {
                    if str.lowercased().contains("expired") {
                        if Int(kUserID)! > 0 {
                            alert.showAlert(kAPPNAME, "Session Expired, Please login Again!", kWindow.rootViewController!, ["OK"]) { (str) in
                                logoutUser ()
                            }
                        }
                        return true
                    }
                }
            }
        }
        return false
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
