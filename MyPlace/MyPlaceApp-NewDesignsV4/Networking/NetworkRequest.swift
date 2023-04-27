//
//  NetworkRequest.swift
//  BurbankApp
//
//  Created by naresh banavath on 02/12/21.
//  Copyright © 2021 DMSS. All rights reserved.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case domainError(_ msg : Error)
    case decodingError(_ msg : Error)
}
class NetworkRequest
{
    class func makeRequest<T : Decodable>(type : T.Type, urlRequest : Router, showActivity : Bool = true,  completion : @escaping (Swift.Result<T, NetworkError>)->())
    {
        if showActivity{
            DispatchQueue.main.async {
                appDelegate.showActivity()
            }
        }
        AF.request(urlRequest).responseData { (response) in
            #if DEDEBUG
             response.debugPrintReqResponse()
            #endif
            
            DispatchQueue.main.async {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.hideActivity()
            }
            guard let data = response.data, response.error == nil else {
                if let error = response.error as NSError? {
                    debugPrint(error)
                    completion(.failure(.domainError(error)))
                }
                return
            }
            do {
                let modelData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(modelData))
            } catch let err{
                debugPrint("Decoding Error :- \(err.localizedDescription)")
                completion(.failure(.decodingError(err)))
            }
        }
    }
    class func makeRequestArray<T : Decodable>(type : T.Type, urlRequest : Router, showActivity : Bool = true, completion : @escaping (Swift.Result<[T] , NetworkError>)->())
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if showActivity
        {
            DispatchQueue.main.async {
                appDelegate.showActivity()
            }
        }
        AF.request(urlRequest).responseData { (response) in
            #if DEDEBUG
             response.debugPrintReqResponse()
            #endif
            
            DispatchQueue.main.async {
                appDelegate.hideActivity()
            }
            guard let data = response.data, response.error == nil else {
                if let error = response.error as NSError?, error.domain == NSURLErrorDomain {
                    completion(.failure(.domainError(error)))
                }
                return
            }
            do {
                let modelData = try JSONDecoder().decode([T].self, from: data)
                completion(.success(modelData))
            } catch let err{
                debugPrint("Decoding Error :- \(err.localizedDescription)")
                completion(.failure(.decodingError(err)))
            }
            
        }
        
    }
}


extension AFDataResponse<Data>
{
    func debugPrintReqResponse()
    {
        let url = self.request?.url?.absoluteString ?? "No URL"
        let headers = self.request?.allHTTPHeaderFields ?? [:]
      //  let response = String(data: self.data ?? Data(), encoding: .utf8) ?? "Unable to Serialize Response"
        if let jsonData = self.request?.httpBody{
            if let params = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
            {
                debugPrint("parameters :- ", params)
            }
        }
        
        debugPrint("Service URL :- \(url)", "Header Fields:- \(headers)", separator: "\n")
//        print("Service Response :- \(response)")
        
    }
}


