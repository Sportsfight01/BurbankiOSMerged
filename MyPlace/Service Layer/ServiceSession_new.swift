//
//  ServiceSession.swift
//  MyLand
//
//  Created by dmss on 05/02/18.
//  Copyright © 2018 dmss. All rights reserved.
// Test

import Foundation
import UIKit
//import Alamofire


class ServiceSession_new
{
    static let sharedSession = ServiceSession_new()
    
    class var shared : ServiceSession_new {
        return sharedSession
//        struct singleton{
//            static let instance = ServiceSession()
//        }
//        return singleton.instance
    }
    
    typealias successBlock = (_ data: Any?, _ resoponse: URLResponse?) -> Void
    typealias errorBlock = (_ error: Error?, _ isJSONError: Bool) -> Void
    let session = URLSession.shared
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    private func showServiceActivity() {
        DispatchQueue.main.async(execute: {
//            self.appDelegate.showActivity()
            showActivityManager()
        })
    }
    
    private func hideServiceActivity() {
        DispatchQueue.main.async(execute: {
//            self.appDelegate.hideActivity()
            hideActivityManager()
        })
    }
    
    
//    func requestWith(urlString: String, imageData: Data?, parameters: [String : Any],fileName:String,isVideo:Bool, onCompletion: (() -> Void)? = nil, onError: ((Error?) -> Void)? = nil){
//
//        print(parameters,urlString,fileName)//http://192.168.100.92:8099/documentapi/estate/UpdateEstateVideosMobile
//        //let url = "http://192.168.100.92:8099/documentapi/estate/UpdateEstateVideosMobile" /* your API url */
//        if !checkNetAvailabilityAndShowActivity()
//        {
//            return
//        }
//        let headers: HTTPHeaders = [
//            /* "Authorization": "your_access_token",  in case you need authorization header */
//            "Content-type": "multipart/form-data"
//        ]
//
//        Alamofire.upload(multipartFormData: { (multipartFormData) in
//            for (key, value) in parameters {
//                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
//            }
//            let mediaName = isVideo == true ? "StageVideo.mov" : "DMSS.png"
//            //let fileName = "galleryEstateVideo_testVideo_almorfire_present_12062018_testVide0_sampleVideo"
//            if let data = imageData{
//                multipartFormData.append(data, withName: "\(fileName)", fileName: mediaName, mimeType: "video/mov")
//            }
//
//        }, usingThreshold: UInt64.init(), to: urlString, method: .post, headers: headers) { (result) in
//
//            switch result{
//            case .success(let upload, _, _):
//                upload.responseJSON { response in
//
//                    self.hideServiceActivity()
//
//                    if let err = response.error{
//                         print("Error in upload: \(err.localizedDescription)")
//                        onError?(err)
//                        return
//                    }
//                    print("Succesfully uploaded")
//
//                    onCompletion?()
//                    self.hideServiceActivity()
//                }
//            case .failure(let error):
//                print("Error in upload: \(error.localizedDescription)")
//                onError?(error)
////                self.hideServiceActivity()()
//            }
//        }
//    }
    
    func callToPostDataToServerWithFormData(_ videoURL: URL)
    {
        let headers = [
            "content-type": "multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW",
            "cache-control": "no-cache",
            "postman-token": "fd3db44e-1856-f25f-5a34-43deb05c3b71"
        ]
        
        print(headers)
        
        let parameters = [
            [
                "name": "estateId",
                "value": 4
            ],
            [
                "name": "estateName",
                "value": "kallo"
            ],
            [
                "name": "userId",
                "value": 1
            ],
            [
                "name": "description",
                "value": "testVideo"
            ],
            [
                "name": "dateTaken",
                "value": "18-04-2018"
            ],
            [
                "name": "videoName",
                "value": "12062018_sampleVideo"
            ],
            [
                "name": "galleryEstateVideo_testVideo_12062018_sampleVideo",
                "fileName": "samplevideo.mp4"
            ]
        ]
        
        let boundary = "----WebKitFormBoundary7MA4YWxkTrZu0gW"
        
        let body = NSMutableData()
        let error: NSError? = nil
        for param in parameters {
            let paramName = param["name"]!
            body.appendString(string: "--\(boundary)\r\n")
            //body += "--\(boundary)\r\n"
            //body += "Content-Disposition:form-data; name=\"\(paramName)\""
            body.appendString(string: "Content-Disposition:form-data; name=\"\(paramName)\"")
            if let filename = param["fileName"] {
                let contentType = "video/mov"
                do {
                    let fileContent = try  Data(contentsOf: videoURL)
                    //do {
                   // let imageData = try Data(contentsOf: theProfileImageUrl as URL)
                   // body += "; filename=\"\(filename)\"\r\n"
                    body.appendString(string: "; filename=\"\(filename)\"\r\n")
                    //body += "Content-Type: \(contentType)\r\n\r\n"
                    body.appendString(string: "Content-Type: \(contentType)\r\n\r\n")
                    //body += fileContent
                    body.append(fileContent)
                }
                catch
                {
                    print("fail to convert..")
                }
                if (error != nil) {
                    print(error as Any)
                }
            } else if let paramValue = param["value"] {
                //body += "\r\n\r\n\(paramValue)"
                body.appendString(string: "\r\n\r\n\(paramValue)\r\n")
            }
        }
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://mylanddocapitest:8099/documentapi/estate/UpdateEstateVideosMobile")! as URL)//,
                                        //  cachePolicy: .useProtocolCachePolicy,
                                         // timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        //request.allHTTPHeaderFields = headers
        
//        if let postData = body.data(using: .utf8)
//        {
//            print("cames--->")
//            request.httpBody = postData as Data
//        }
//
        request.httpBody = body as Data
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse as Any)
                print(data as Any)
            }
        })
        
        dataTask.resume()
    }
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
           
            session.dataTask(with: urlRequest, completionHandler: {(data, response, error) in
                
                self.hideServiceActivity()

                if error != nil
                {
                    DispatchQueue.main.async(execute: {
                        errorBlock(error, false)
                    })
                    print("fail to connect with error:\(String(describing: error?.localizedDescription))")
                    return
                }
                do
                {
                    let json = try JSONSerialization.jsonObject(with: data!, options:[]) //as? NSDictionary
                    DispatchQueue.main.async {
                        successBlock(json, response)
                        self.hideServiceActivity()
                    }
                }catch
                {
                     //let data = (data).data(using: String.Encoding.utf8)
                    //let base64 = data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
                    DispatchQueue.main.async {
                        successBlock(data!, response)
                    }
                    if isResultEncodedString == true
                    {
                        // let data = (data).data(using: String.Encoding.utf8)
                        //let base64 = data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
                        DispatchQueue.main.async {
                            successBlock(data!, response)
                        }
                    }else
                    {
                        //print(data!)
                        print("failed to Get Data from Server with error:%@",error)
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
        if !checkNetAvailabilityAndShowActivity() //|| postDic.count == 0
        {
//            self.hideServiceActivity()
            return
        }
        print(appendingURL)
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
                print("JSON serialization failed:  \(error)")
            }
            session.dataTask(with: urlRequest, completionHandler: {(data, response, error) in
                
                    self.hideServiceActivity()

                if error != nil
                {
                    DispatchQueue.main.async(execute: {
                        errorBlock(error, false)
                    })
                    print("fail to connect with error:\(error?.localizedDescription ?? "unknown error")")
                    return
                }
                do
                {
                    let json = try JSONSerialization.jsonObject(with: data!, options:[]) //as? NSDictionary
                    print(json)
                    DispatchQueue.main.async {
                        successBlock(json, response)
                        self.hideServiceActivity()
                        
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
                        print("failed to Get Data from Server with error:%@",error)
                        DispatchQueue.main.async(execute: {
                            errorBlock(error, true)
                        })
                        
                    }
                }
            }).resume()
            
        }else
        {
            self.hideServiceActivity()
            print("Fail to convert URL")
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
    
    private func checkNetAvailabilityAndShowActivity() -> Bool {
                    
        if isNetworkConnectionAvailable {
            showServiceActivity()
            return true
        }else {

            showAlert("Internet Connection Not Available")
            return false
        }
        
    }
    
    
//    private func alert(_ alertMessage: String,_ title: String = "") {
//
//        showAlert(alertMessage, title: title)
//
////        let alert = UIAlertView(title: "", message: alertMessage, delegate: nil, cancelButtonTitle: "Ok")
////        alert.show()
//    }
//
//    private func showAlert(_ alertMessage: String, title: String = "")
//    {
//        let alertVC = UIAlertController(title: title, message: alertMessage, preferredStyle: .alert)
//        alertVC.view.backgroundColor = UIColor.white
//        alertVC.view.layer.cornerRadius = radius_5
//
//        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
//        let window = UIApplication.shared.windows.last //(UIApplication.shared.delegate as! AppDelegate
//        window?.rootViewController?.present(alertVC, animated: true, completion: nil)
//    }
}

extension NSMutableData {
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
