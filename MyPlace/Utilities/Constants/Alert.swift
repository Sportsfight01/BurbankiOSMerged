//
//  Alert.swift
//  MyPlace
//
//  Created by Sreekanth tadi on 23/03/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift


public typealias handler = (_ string: String) -> Void

let alert = Alert()



func showAlert (_ message: String, _ vc: UIViewController = kWindow.rootViewController ?? UIViewController(), _ buttons: [String] = ["OK"], _ actionReturnHandler: handler? = nil) {

    alert.showAlert(kAPPNAME, message, vc, buttons, actionReturnHandler)
}

func s {
    let alertController = UIAlertController(
        title: "Update Available",
        message: "A new version (\(appStoreVersion)) of the app is available. Please update to enjoy the latest features.",
        preferredStyle: .alert
    )
    alertController.addAction(UIAlertAction(title: "Update", style: .default, handler: { _ in
        if let url = URL(string: "itms-apps://itunes.apple.com/app/id1437771849") {
            UIApplication.shared.open(url)
//            resetUserDefaultsForOlderVerion()
            if let bundleID = Bundle.main.bundleIdentifier {
                UserDefaults.standard.removePersistentDomain(forName: bundleID)
            }
            CurrentUser.profilePicUrl = nil
            CurrentUser.userName = nil
            CurrentUser.mobileNo = nil
            CurrentUser.email = nil
            CurrentUser.jobNumber = nil
            appDelegate.notificationCount = 0
            let realm = try! Realm()
            try! realm.write {
                realm.deleteAll()
            }
            
        }

        
    }))
    if let rootVC = UIApplication.shared.windows.first?.rootViewController {
        rootVC.present(alertController, animated: true, completion: nil)
    }
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
            let titleFont = UIFont(name: "Montserrat-Medium", size: 18) ?? UIFont.systemFont(ofSize: 20)
            let messageFont = UIFont(name: "Montserrat-Regular", size: 14) ?? UIFont.systemFont(ofSize: 16)

            alert.setValue(NSAttributedString(string: title, attributes: [NSAttributedString.Key.font : titleFont]), forKey: "attributedTitle")

            alert.setValue(NSAttributedString(string: message, attributes: [NSAttributedString.Key.font : messageFont ,NSAttributedString.Key.foregroundColor : APPCOLORS_3.Black_BG]), forKey: "attributedMessage")

            action.setValue( buttons.count > 1 ? (index == 0 ? APPCOLORS_3.Black_BG : APPCOLORS_3.Orange_BG) : APPCOLORS_3.Orange_BG, forKey: "titleTextColor")
           
//            alert.setValue(FONT_LABEL_SUB_HEADING(size: FONT_12),forKey: "titleTextFont")
            alert.addAction(action)
        }
        
        vc.self.present(alert, animated: true, completion: nil)
    }
    
}
