//
//  Alert.swift
//  MyPlace
//
//  Created by Sreekanth tadi on 23/03/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import Foundation
import UIKit


public typealias handler = (_ string: String) -> Void

let alert = Alert()



func showAlert (_ message: String, _ vc: UIViewController = kWindow.rootViewController!, _ buttons: [String] = ["OK"], _ actionReturnHandler: handler? = nil) {

    alert.showAlert(kAPPNAME, message, vc, buttons, actionReturnHandler)
}





struct Alert {
    
    func showAlert (_ title: String = kAPPNAME, _ message: String, _ vc: UIViewController = kWindow.rootViewController!,  _ buttons: [String] = ["OK"], _ actionReturnHandler: handler? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.view.backgroundColor = UIColor.white
        alert.view.layer.cornerRadius = UIScreen.main.bounds.size.width/32.0 //10 -->> 320/32
        
        for (index,str) in buttons.enumerated() {
            let action = UIAlertAction(title: str.uppercased(), style: UIAlertAction.Style.default, handler: { (action) in
                if let han = actionReturnHandler {
                    han(str)
                }
            })

                action.setValue(index == 0 ? APPCOLORS_3.Black_BG : APPCOLORS_3.Orange_BG, forKey: "titleTextColor")

            alert.addAction(action)
        }
        
        vc.self.present(alert, animated: true, completion: nil)
    }
    
}
