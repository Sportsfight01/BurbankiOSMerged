//
//  ActivityManager.swift
//  MyPlace
//
//  Created by Sreekanth tadi on 19/03/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
// I am at UAT branch = Mohan

import Foundation
import UIKit
import MBProgressHUD
import IQKeyboardManagerSwift
import AFNetworking


class ActivityManager {

    class func showToast(_ message: String, _ vc: UIViewController = kWindow.rootViewController!, _ position: ToastPosition = .center) {
        
        vc.view.hideAllToasts();

        ToastManager.shared.position = position;
        
        vc.view.makeToast(message, duration: 2)
    }
    
}


//MARK: - Rechability

var isNetworkConnectionAvailable: Bool {
    return isNetworkReachable
//    let network = AFNetworkReachabilityManager.init(forDomain: "www.apple.com")
//    return network.isReachableViaWiFi || network.isReachableViaWWAN
}


var isNetworkReachable: Bool {
    let reachabilityStatus = Reachability(hostName: "www.apple.com").currentReachabilityStatus()
    if reachabilityStatus == ReachableViaWiFi || reachabilityStatus == ReachableViaWWAN {
        return true
    }
    return false
}


//MARK: - Window Activity

func appStartUpSetup () {
    
    IQKeyboardManager.shared.enable = true

    appDelegate.userData = UserData()
    
    if let userID = appDelegate.userData?.user?.userID {
        print(log: userID)
        //load dashboard
        
        let userGoogleId = appDelegate.userData?.user?.userGoogleID
        let userFacebookId = appDelegate.userData?.user?.userFacebookID
        
        if appDelegate.userData?.user?.userFacebookID != "", appDelegate.userData?.user?.userFacebookID != nil, (appDelegate.userData?.user?.userFacebookID?.count)! > 0 {
            LoginDataManagement.shared.getUserDetailsFromFacebook { (user) in
                appDelegate.userData?.saveUserDetails()
            }
        }
        
        if userFacebookId != "", userFacebookId != nil, (userFacebookId?.count)! > 0 {
            LoginDataManagement.shared.getUserDetailsFromFacebook { (user) in
                appDelegate.userData?.saveUserDetails()
            }
        }

        if userGoogleId != "", userGoogleId != nil, (userGoogleId?.count)! > 0 {
//            LoginDataManagement.shared.handleGoogleSignIn()
        }

        loadMainView()
    }else {
        
        //load login
        loadLoginView()
        //already welcome(login module) screen is initial screen
    }
    
    
    AppConfigurations.shared.getAppConfigurations()
    
}


func loadLoginView () {
        
//    let login = kStoryboardMain.instantiateViewController(withIdentifier: "") as? SignInVC
    let login = kStoryboardLogin.instantiateInitialViewController()
    currentWindow.rootViewController = login
    currentWindow.makeKeyAndVisible()
}

func loadMainView () {
    
//    let dashBoard = kStoryboardMain.instantiateViewController(withIdentifier: "DashboardVC") as? DashboardVC

//    if #available(iOS 13.0, *) {
//        let dashBoard = kStoryboardMain.instantiateViewController(identifier: "") as? DashboardVC
//    } else {
//        // Fallback on earlier versions
//    }
    
//    let myPlaceHomeVC = kStoryboardMain.instantiateViewController(withIdentifier: "MyPlaceHomeVC") as? MyPlaceHomeVC

    kWindow.rootViewController = kStoryboardMain.instantiateInitialViewController()
    kWindow.makeKeyAndVisible()
    
}

func setStatusBarColor (color: UIColor? = COLOR_ORANGE) {
    
    UIApplication.shared.statusBarView?.backgroundColor = color
}


//MARK: - MBProgressHUD

func showActivityManager () {
    
    DispatchQueue.main.async(execute: {
        
        let progress = MBProgressHUD.showAdded(to: kWindow, animated: true)
        kWindow.bringSubviewToFront(progress)
        setShadow(view: progress, color: .darkGray, shadowRadius: 10)
        
            
    })
}

func hideActivityManager () {
    
    DispatchQueue.main.async(execute: {
        
        MBProgressHUD.hide(for: kWindow, animated: true)
    })
}

func showActivityFor (view: UIView) {
    
    DispatchQueue.main.async(execute: {

        let progress = MBProgressHUD.showAdded(to: view, animated: true)
        
        setShadow(view: progress, color: .lightGray, shadowRadius: 10)
    
        kWindow.bringSubviewToFront(progress)
    })
}

func hideActivityFor (view: UIView) {
    
    DispatchQueue.main.async(execute: {
        MBProgressHUD.hide(for: view, animated: true)
    })
}

//MARK: - Toast

func showToast(_ message: String, _ vc: UIViewController = kWindow.rootViewController!, _ position: ToastPosition = .center)
{
    vc.view.hideAllToasts();

    ToastManager.shared.position = position;
    
    vc.view.makeToast(message, duration: 2)
    
//    vc.view.makeToast(message);
}





//MARK: - User Activity

var kUserID: String {
    return appDelegate.userData?.user?.userID ?? "0"
}

func logoutUser () {
        
    appDelegate.userData?.removeUserDetails()
        
    appDelegate.userData = UserData ()
    
    appDelegate.userData?.saveUserDetails()
    
    removeFilterFromDefaults()
    
    LoginDataManagement.shared.logoutGoogle()
    LoginDataManagement.shared.logoutFacebook()
    let domain = Bundle.main.bundleIdentifier!
    UserDefaults.standard.removePersistentDomain(forName: domain)
    UserDefaults.standard.synchronize()
    
    loadLoginView()
}

func downloadImage (url: String) {
    
//    ImageDownloader.downloadImage(withUrl: url, withFilePath: nil, with: { (image, success, error) in
//
//        if success, let ima = image {
//
//        }
//
//    }) { (progress) in
//
//
//    }
    
}


//MARK: - DEBUG Log

func print (log: Any) {
    
    #if DEDEBUG
    print(log)
    #endif
}

//}


//MARK: - StatusBar

extension UIApplication {
    
    var statusBarView: UIView? {
        
        if #available(iOS 13, *)
        {
            let statusBar = UIView(frame: UIApplication.shared.windows.last?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
            UIApplication.shared.windows.last?.addSubview(statusBar)
            return statusBar
        }else {
            if responds(to: Selector(("statusBar"))) {
                return value(forKey: "statusBar") as? UIView
            }
            return nil
        }
    }
}

