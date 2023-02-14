//
//  AlertManager.swift
//  Burbank
//
//  Created by Mohan Kumar on 16/12/16.
//  Copyright © 2016 DMSS. All rights reserved.
//

import UIKit



class AlertManager: NSObject {

    class var sharedInstance: AlertManager {
        struct Singleton {
            static let instance = AlertManager()
        }
        return Singleton.instance
    }
    
    func alert(_ alertMessage: String) {
        
        showAlert(alertMessage: alertMessage, title: "")
//        let alert = UIAlertView(title: "", message: alertMessage, delegate: nil, cancelButtonTitle: "Ok")
//        alert.show()
    }
    func showAlert(alertMessage: String,title: String = "Burbank")
    {
        
        BurbankApp.showAlert(alertMessage)
//        let alertVC = UIAlertController(title: title, message: alertMessage, preferredStyle: .alert)
//        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
////        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        kWindow.rootViewController?.present(alertVC, animated: true, completion: nil)
    }
   
}
