//
//  ServiceSession.swift
//  Burbank
//
//  Created by Madhusudhan on 11/08/16.
//  Copyright © 2016 DMSS. All rights reserved.
//

import UIKit


class ServiceSessionMyPlace: NSObject {
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    class var sharedInstance: ServiceSessionMyPlace {
        struct Singleton {

            static let instance = ServiceSessionMyPlace()
        }
        return Singleton.instance
    }
    
    
        func checkNetAvailability() -> Bool {
        
        appDelegate.checkInternetConnection()
        
        if appDelegate.netAvailability == false
        {
            let alert = UIAlertController(title: "Burbank", message: "Internet not available, Please connect to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
            kWindow.rootViewController!.present(alert, animated: true, completion: nil)
            
            return false
        }
        
        appDelegate.showActivity()
        
        return true
    }
}
