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
    
    func callToGetDataFromServer(_ appendingURL:String, successBlock:@escaping successBlock, errorBlock:@escaping errorBlock,isResultEncodedString: Bool = false) // at this point of time we are assuming that jobNumber details are at first index of current user for authenticating
    {
        if !checkNetAvailabilityAndShowActivity()
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
                let currenUserJobDetails = (UIApplication.shared.delegate as! AppDelegate).currentUser?.userDetailsArray![0].myPlaceDetailsArray[0]//// at this point of time we are assuming that jobNumber details are at first index of current user
                let authorizationString = "\(currenUserJobDetails?.userName ?? ""):\(currenUserJobDetails?.password ?? "")"
                let encodeString = authorizationString.base64String
                let valueStr = "Basic \(encodeString)"
                
                var contractNo : String = ""
            
                    if let jobNum = appDelegate.currentUser?.jobNumber, !jobNum.trim().isEmpty
                    {
                        contractNo = jobNum
                    }
                    else {
                        contractNo = appDelegate.currentUser?.userDetailsArray?.first?.myPlaceDetailsArray.first?.jobNumber ?? ""
                    }
                
                urlRequest.addValue(valueStr, forHTTPHeaderField: "Authorization")
                urlRequest.addValue(contractNo, forHTTPHeaderField: "ContractNumber")
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
    func checkNetAvailabilityAndShowActivity() -> Bool {
        
        appDelegate.checkInternetConnection()
        
        if appDelegate.netAvailability == false
        {
            AlertManager.sharedInstance.alert("Internet Connection Not Available")
            
            return false
        }
        
        DispatchQueue.main.async(execute: {
            self.appDelegate.showActivity()
        })
        
        return true
    }
}
