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
    class func makeRequest<T : Decodable>(type : T.Type , urlRequest : Router , completion : @escaping (Swift.Result<T , NetworkError>)->())
    {
      DispatchQueue.main.async {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showActivity()
      }
  
        print("url :- \(urlRequest.urlRequest?.url?.absoluteString)")
        print("headers :- \(String(describing: urlRequest.urlRequest?.allHTTPHeaderFields))")
//        print("Url:- ",urlRequest.urlRequest?.url?.absoluteString as Any)
        if let jsonData = urlRequest.urlRequest?.httpBody
        {
            if let params = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
            {
                print("parameters :- ", params)
            }
        }
        
        
//        let configuration = URLSessionConfiguration.default
//        configuration.timeoutIntervalForRequest = urlRequestTimeOutInterval
//        configuration.timeoutIntervalForResource = urlRequestTimeOutInterval
//        let alamoFireManager = Alamofire.SessionManager(configuration: configuration) // not in this line
        //guard Reachability.isConnectedToNetwork() else { self.showAlert(message: NoInternet) ; return }
//        DispatchQueue.main.async {
//            self.showLoading(text: "Loading")
//        }
        AF.request(urlRequest).responseData { (response) in
            
          DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.hideActivity()
          }
          //  print(response)
          //  print(try! JSONSerialization.jsonObject(with: response.data!, options: .allowFragments))
            guard let data = response.data, response.error == nil else {

                if let error = response.error as NSError? {
                print(error)
                    DispatchQueue.main.async {
                      //  self.hideLoading()
                    }
                     completion(.failure(.domainError(error)))
                }
                return
            }
            
            if let JSONString = String(data: data, encoding: String.Encoding.utf8)
            {
                print("response:p- ", JSONString)
            }
        
           
            do {
                let modelData = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                   //  self.hideLoading()
                }
                completion(.success(modelData))
            } catch let err{
                DispatchQueue.main.async {
                    //self.hideLoading()
                    debugPrint(err.localizedDescription)
                }
                completion(.failure(.decodingError(err)))
            }
        }
    }
    class func makeRequestArray<T : Decodable>(type : T.Type , urlRequest : Router , completion : @escaping (Swift.Result<[T] , NetworkError>)->())
    {
      print("url :- \(urlRequest.urlRequest?.url?.absoluteString)")
      print("headers :- \(String(describing: urlRequest.urlRequest?.allHTTPHeaderFields))")
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
     
        DispatchQueue.main.async {
           // self.showLoading(text: "Loading")
          appDelegate.showActivity()
        }
        AF.request(urlRequest).responseJSON { (response) in
          print(response)
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
                DispatchQueue.main.async {
                   // self.hideLoading()
                }
                completion(.success(modelData))
            } catch let err{
              print(err.localizedDescription)
                DispatchQueue.main.async {
                   // self.hideLoading()
                }
                completion(.failure(.decodingError(err)))
            }

        }

    }
}
