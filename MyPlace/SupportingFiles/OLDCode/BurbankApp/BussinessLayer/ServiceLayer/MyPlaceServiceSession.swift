//
//  MyPlaceServiceSession.swift
//  BurbankApp
//
//  Created by dmss on 27/10/17.
//  Copyright © 2017 DMSS. All rights reserved.
//

import Foundation

class MyPlaceServiceSession
{
    class var shared : MyPlaceServiceSession{
        
        struct singleton{
            static let instance = MyPlaceServiceSession()
        }
        return singleton.instance
    }
    typealias successBlock = (_ data: Any?, _ resoponse: URLResponse?) -> Void
    typealias errorBlock = (_ error: Error?, _ isJSONError: Bool) -> Void
    let session = URLSession.shared
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func callToGetDataFromServer(_ appendingURL:String,showActivity : Bool = true, successBlock:@escaping successBlock, errorBlock:@escaping errorBlock,isResultEncodedString: Bool = false) // at this point of time we are assuming that jobNumber details are at first index of current user for authenticating
    {
        if !checkNetAvailabilityAndShowActivity(showActivity: showActivity)
        {
            return
        }
        if let url = URL(string: appendingURL)
        {
            var urlRequest = URLRequest(url: url) //NSMutableURLRequest(url: url)
            urlRequest.httpMethod = kGet
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            if selectedJobNumberRegion != .OLD
            {
                let jobAndAuth = APIManager.shared.getJobNumberAndAuthorization()
                guard let jobNumber = jobAndAuth.jobNumber else {debugPrint("Job Number is Null");return}
                let auth = jobAndAuth.auth
                
                urlRequest.addValue(auth, forHTTPHeaderField: "Authorization")
                urlRequest.addValue(jobNumber, forHTTPHeaderField: "ContractNumber")
            }
            session.dataTask(with: urlRequest, completionHandler: {(data, response, error) in
                
                    DispatchQueue.main.async(execute: {
                        self.appDelegate.hideActivity()
                    })
                if error != nil
                {
                    DispatchQueue.main.async(execute: {
                       errorBlock(error, false)
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
                        successBlock(json, response)
                        self.appDelegate.hideActivity()
                    }
                }catch
                {
                    if isResultEncodedString == true
                    {
                       // let data = (data).data(using: String.Encoding.utf8)
                        //let base64 = data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
                        DispatchQueue.main.async {
                            successBlock(data!, response)
                        }
                    }else
                    {
                        #if DEDEBUG
                        print("failed to Get Data from Server with error:%@",error)
                        #endif
                        DispatchQueue.main.async(execute: {
                            errorBlock(error, true)
                        })
                    }
                }
            }).resume()
            
        }

    }
    func callToPostDataToServer(_ appendingURL:String,_ postDic: [String: Any],successBlock:@escaping successBlock, errorBlock:@escaping errorBlock,isResultEncodedString: Bool = false)
    {
//        print("URL:- \(appendingURL)")
//        print("Params :- \(postDic)")
        if !checkNetAvailabilityAndShowActivity() || postDic.count == 0
        {
            return
        }
        if let url = URL(string: appendingURL)
        {
            var urlRequest = URLRequest(url: url) //NSMutableURLRequest(url: url)
            urlRequest.httpMethod = kPost
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: postDic, options:[])
                
            }
            catch {
                #if DEDEBUG
                print("JSON serialization failed:  \(error)")
                #endif
            }
            session.dataTask(with: urlRequest, completionHandler: {(data, response, error) in
              print("URL:- \(appendingURL)")
              print("Params :- \(postDic)")
                DispatchQueue.main.async(execute: {
                    self.appDelegate.hideActivity()
                })
                if error != nil
                {
                    DispatchQueue.main.async(execute: {
                        errorBlock(error, false)
                    })

                    return
                }
                do
                {
                    let json = try JSONSerialization.jsonObject(with: data!, options:[]) //as? NSDictionary
                    #if DEDEBUG
                    print(json)
                    #endif
                    DispatchQueue.main.async {
                        successBlock(json, response)
                        self.appDelegate.hideActivity()
                        
                    }
                }catch
                {
                    if isResultEncodedString == true
                    {
                        if let strData = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                        {
                            DispatchQueue.main.async {
                                successBlock(strData, response)
                            }
                        }
                    }else
                    {
                    #if DEDEBUG
                    print("failed to Get Data from Server with error:%@",error)
                    #endif
                    DispatchQueue.main.async(execute: {
                    errorBlock(error, true)
                    })
                    
                    }
                }
            }).resume()
            
        }
        
    }
    func foo()
    {
        callToGetDataFromServer("", successBlock: { (jSon,response) in
            //
        }, errorBlock: { (error, isJSon) in
            //
        })
    }
    func checkNetAvailabilityAndShowActivity(showActivity : Bool = true) -> Bool {
        
        appDelegate.checkInternetConnection()
        
        if appDelegate.netAvailability == false
        {
            AlertManager.sharedInstance.alert("Internet not available, Please connect to Internet")
            
            return false
        }
        if showActivity{
            DispatchQueue.main.async(execute: {
                self.appDelegate.showActivity()
            })
        }
        
        return true
    }
}
