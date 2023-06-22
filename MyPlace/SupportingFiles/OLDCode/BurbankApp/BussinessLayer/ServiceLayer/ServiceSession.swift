//
//  ServiceSession.swift
//  BurbankApp
//
//  Created by dmss on 13/12/16.
//  Copyright © 2016 DMSS. All rights reserved.
//

import UIKit

class ServiceSession: NSObject
{
    class var shared : ServiceSession{
        
        struct singleton{
            static let instance = ServiceSession()
        }
        return singleton.instance
    }
    
    
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let session = URLSession.shared
    var urlRequest : URLRequest! = nil
//    var isJSONArray : Bool = false
    var cactheKey : String!
    
    var noNeedActivity = false
    
    
    
    func callToGetDataFromServerWithOutNetActivity(appendUrlString: String ,completionHandler: @escaping CompletionHandler)
    {
        appDelegate.checkInternetConnection()
        
        if appDelegate.netAvailability == false
        {
            AlertManager.sharedInstance.alert("Internet Connection Not Available")
            
            return
        }
        noNeedActivity = true
        getDataFromServer(appendUrlString: appendUrlString, completionHandler: completionHandler)
    }
    
    func callToGetDataFromServer(appendUrlString: String ,completionHandler: @escaping CompletionHandler)//(_ data: NSDictionary) -> Void
    {
        //
        if !checkNetAvailability()
        {
            return
        }
        getDataFromServer(appendUrlString: appendUrlString, completionHandler: completionHandler)
    }
    
    fileprivate func getDataFromServer(appendUrlString: String ,completionHandler: @escaping CompletionHandler)
    {
        var urlString = ""
        urlString  = String(format: "%@%@", baseURL,appendUrlString)
        getDataFromServerWithGivenURLString(urlString: urlString, completionHandler: completionHandler)

    }
    func callToGetDataFromServerWithGivenURLString(_ urlString: String,withactivity: Bool, completionHandler: @escaping CompletionHandler)
    {
        if withactivity == true //escaping condition, we need to check net availability if we want get data in backend
        {
            if !checkNetAvailability()
            {
                return
            }
        }
        getDataFromServerWithGivenURLString(urlString: urlString, completionHandler: completionHandler)
    }
    fileprivate func getDataFromServerWithGivenURLString(urlString: String ,completionHandler: @escaping CompletionHandler)
    {
        if let url = URL(string: urlString)
        {
            urlRequest = URLRequest(url: url) //NSMutableURLRequest(url: url)
            urlRequest.httpMethod = kGet
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
            session.dataTask(with: urlRequest, completionHandler: {(data, response, error) in
                
                if !self.noNeedActivity
                {
                    DispatchQueue.main.async(execute: {
                        appDelegate.hideActivity()
                    })
                }
                
                if error != nil
                {
                    DispatchQueue.main.async(execute: {
                        AlertManager.sharedInstance.alert((error?.localizedDescription)!)
                    })
//                    #if DEDEBUG
//                    print("fail to connect with error:\(error?.localizedDescription)")
//                    #endif
                    return
                }
                do
                {
                    let json = try JSONSerialization.jsonObject(with: data!, options:[]) //as? NSDictionary
                    
                    DispatchQueue.main.async {
                        completionHandler(json)
                        appDelegate.hideActivity()
                        
                    }
                    
                }catch
                {
                    #if DEDEBUG
                    print("failed to Get Data from Server with error:%@",error)
                    #endif

                    DispatchQueue.main.async(execute: {
                        appDelegate.hideActivity()
                    //    AlertManager.sharedInstance.alert(error.localizedDescription)
                    })
                    
                }
                
                
            }).resume()
            
        }
        
    }
   
    
    func callToPostDataToServer(appendUrlString: String , postBodyDictionary: NSDictionary, completionHandler: @escaping CompletionHandler)
    {
        
        let urlString = String(format: "%@%@", baseURL,appendUrlString)
        callToPostDataToServerWithGivenURLString(urlString: urlString, postBodyDictionary: postBodyDictionary, completionHandler: completionHandler)
    }
    func callToPostDataToServerWithGivenURLString(urlString: String , postBodyDictionary: NSDictionary, completionHandler: @escaping CompletionHandler)
    {
 //     print("url:-",urlString)
        #if DEDEBUG
        print(urlString)
        print(postBodyDictionary)
        #endif
        
        if postBodyDictionary.allKeys.count == 0 {
            return
        }
        if let url = URL(string: urlString)
        {
            if !checkNetAvailability()
            {
                return
            }
            
            urlRequest = URLRequest(url: url) //NSMutableURLRequest(url: url)
            urlRequest.httpMethod = kPost
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: postBodyDictionary, options:[])
                
            }
            catch {
                #if DEDEBUG
                print("JSON serialization failed:  \(error)")
                #endif
            }
            session.dataTask(with: urlRequest, completionHandler: {(data, response, error) in
                
                DispatchQueue.main.async(execute: {
                    appDelegate.hideActivity()
                })
                
                if error != nil
                {
                    AlertManager.sharedInstance.alert((error?.localizedDescription)!)
//                    #if DEDEBUG
//                    print("fail to connect with error:\(error?.localizedDescription)")
//                    #endif
                    return
                }
                
                do
                {
                     if let json = try JSONSerialization.jsonObject(with: data!, options:[]) as? NSDictionary
                     {
                        DispatchQueue.main.async {
                            completionHandler(json)
                        }
                        
                    }
                }catch let jsonError
                {
                    //AlertManager.sharedInstance.alert(error as! String)
                    
                    #if DEDEBUG
                    print("failed to format with JSON error:%@",jsonError)
                    #endif
                }
                
            }).resume()
        }
    }

    func callTogetWithoutActivity(appendUrlString: String ,completionHandler: @escaping CompletionHandler)
    {
        var urlString = ""
        urlString  = String(format: "%@%@", baseURL,appendUrlString)
        
        if let url = URL(string: urlString)
        {
            if !checkNetAvailability()
            {
                return
            }
            if UserDefaults.standard.value(forKey: "isFirstTimeInstall") == nil
            {
                UserDefaults.standard.set(true, forKey: "isFirstTimeInstall")
                
            }else
            {
                DispatchQueue.main.async(execute: {
                    appDelegate.hideActivity()
                })
            }
            
            urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = kGet
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
          
            session.dataTask(with: urlRequest, completionHandler: {(data, response, error) in
                
                DispatchQueue.main.async(execute: {
                    appDelegate.hideActivity()
                })
                
                if error != nil
                {
                    AlertManager.sharedInstance.alert((error?.localizedDescription)!)
//                    #if DEDEBUG
//                    print("fail to connect with error:\(error?.localizedDescription)")
//                    #endif
                    return
                }
                
                do
                {
                    let json = try JSONSerialization.jsonObject(with: data!, options:[]) //as? NSDictionary
                    
                    DispatchQueue.main.async {
                        completionHandler(json)
                    }
                }catch
                {
                    #if DEDEBUG
                    print("failed to Get Data from Server with error:%@",error)
                    #endif
                   // AlertManager.sharedInstance.alert(error as! String)
                    AlertManager.sharedInstance.alert(error.localizedDescription)


                }
                
            }).resume()
        }
    }
    
        
    func checkNetAvailability() -> Bool {
        
        appDelegate.checkInternetConnection()
        
        if isNetworkReachable == false
        {
            AlertManager.sharedInstance.alert("Internet Connection Not Available")
            
            return false
        }
        
            DispatchQueue.main.async(execute: {
                appDelegate.showActivity()
            })
       
        return true
    }
}
