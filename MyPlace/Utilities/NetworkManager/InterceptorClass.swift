//
//  InterceptorClass.swift
//  BurbankApp
//
//  Created by Naveen Kourampalli on 25/03/24.
//  Copyright © 2024 Sreekanth tadi. All rights reserved.
//

import Foundation


protocol Interceptors {
    func intercept(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void)
}

class LoggingInterceptor: Interceptors {
    var nextinterceptor: Interceptors?
    func intercept(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        print("Logging request: \(request)")
        URLSession.shared.dataTask(with: request, completionHandler: completion).resume()
    }
}

class AuthorizationInterceptor: Interceptors {
    var retryCount = 0
    let maxRetryCount = 3
    
    func intercept(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        var modifiedRequest = request
        Networking.shared.handleDefaultAuthforToken(completion: {result in
            self.modifyRequest(&modifiedRequest)
            
            URLSession.shared.dataTask(with: modifiedRequest) { data, response, error in
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
                    if self.retryCount < self.maxRetryCount {
                        print("Received 401, retrying...")
                        self.retryCount += 1
                        self.intercept(request: request, completion: completion)
                    } else {
                        print("Max retry limit reached")
                        completion(data, response, error)
                    }
                } else {
                    completion(data, response, error)
                }
            }.resume()
        })
        // Implement your logic to modify the request, e.g., adding authentication headers
        
       
    }
    
    private func modifyRequest(_ request: inout URLRequest) {
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(kToken)", forHTTPHeaderField: "Authorization")
        print("------- Modified Bearer \(kToken)")
        // Implement logic to modify the request, e.g., adding authentication headers
    }
}
