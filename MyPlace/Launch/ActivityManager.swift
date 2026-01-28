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
    
    class func getPromos(completion: @escaping ([[String: Any]]) -> Void) {

        _ = Networking.shared.GET_request(
            url: ServiceAPI.shared.URL_promos(kUserStateName),
            userInfo: nil,
            success: { (json, response) in

                guard
                    let result = json as? NSDictionary,
                    let isSuccess = result["Code"] as? Bool,
                    isSuccess,
                    let promos = result["Data"] as? [[String: Any]]
                else {
                    completion([])
                    return
                }

                completion(promos)
            },
            errorblock: { _, _ in
                completion([])
            },
            progress: nil
        )
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

@MainActor func appStartUpSetup () {
    
    
//    IQKeyboardManagertool.shared.isEnabled = true

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

//        loadMainView()
        loadLoginView()
        
    }else {
        
        //load login
        loadLoginView()
        //already welcome(login module) screen is initial screen
    }
    
    
//    AppConfigurations.shared.getAppConfigurations()
    
}


func loadLoginView () {
        
    //let login = kStoryboardLogin.instantiateViewController(withIdentifier: "SignInVC") as? SignInVC
    let login = kStoryboardLogin.instantiateInitialViewController()
    currentWindow.rootViewController = login
    currentWindow.makeKeyAndVisible()
}

func loadSignInView()
{
    let login = kStoryboardLogin.instantiateViewController(withIdentifier: "SignInVC") as? SignInVC
    let nav = UINavigationController(rootViewController: login!)
    currentWindow.rootViewController = nav
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

func loadDependencies(completion: @escaping () -> Void) {
//    LocationServices.shared.requestUsertoAllowLocationPermissions()
    
    
    if kUserState == String.zero() || kUserState == String.empty() {
        getStates ()
    }else {
        
//        setRegionText() //state
        
        DashboardDataManagement.shared.getRegions(stateId: kUserState, showActivity: false) { (regions) in
            
        }
    }
    
    
    if (Int(kUserID) ?? 0) > 0 {
        ProfileDataManagement.shared.getProfileDetails(appDelegate.userData?.user ?? UserBean.init()) {
            //                            if let url = appDelegate.userData?.user?.userProfileImageURL {
            //                                self.addProfileImage(url)
            //                            }
        }
        
        ProfileDataManagement.shared.getSearchTypes {
            
        }
        
    }
    completion()
}

func getStates () {
    
    _ = Networking.shared.GET_request(url: ServiceAPI.shared.URL_states, userInfo: nil, success: { (json, response) in
        
        if let result: AnyObject = json {
            
            let result = result as! NSDictionary
            
            if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {
                
                let resultStates = result.value(forKey: "States") as! [NSDictionary]
                
                saveStatestoDefaults(resultStates as NSArray)
                
//                if let states = kStatesMyPlace {
//                    if states.count > 0 {
//                        self.showStateSelectionView(states)
//                    }
//                }
            }else {
                print(log: "states not found")
//                ActivityManager.showToast(result.value(forKey: "message") as? String ?? "", self)
            }
            
        }else {
            
        }
        
    }, errorblock: { (error, isJSONerror)  in
        
        if isJSONerror {
            
        }else {
            
        }
    }, progress: nil)
    
}



func handleNotificationNavigation(pushnotificatons: pushNtfcnModelInfo) {
    appDelegate.userData = UserData()
    
          let rootVC = currentWindow.rootViewController
    
    appDelegate.userData?.user?.userDetails?.userStateId = pushnotificatons.stateId
    appDelegate.userData?.user?.userDetails?.userState  = pushnotificatons.state
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    if pushnotificatons.isMultiple == "true"{
        if pushnotificatons.moduleType == "NewHomes_Main"{
           
            let targetVC = storyboard.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
            (targetVC as UITabBarController).selectedIndex = 0
            let nav = UINavigationController(rootViewController: targetVC)
            currentWindow.rootViewController = nav
        }
        else if pushnotificatons.moduleType == "HomeAndLand_Main"{
            
            let targetVC = storyboard.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
            (targetVC as UITabBarController).selectedIndex = 1
            let nav = UINavigationController(rootViewController: targetVC)
            currentWindow.rootViewController = nav
            
        }else{

            let targetVC = storyboard.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
            (targetVC as UITabBarController).selectedIndex = 2
            let nav = UINavigationController(rootViewController: targetVC)
            currentWindow.rootViewController = nav
            
        }
    }else{
        if pushnotificatons.moduleType == "NewHomes"{
            let targetVC = storyboard.instantiateViewController(withIdentifier: "HomeDesignsAndDisplayHomeDetailsVC") as? HomeDesignsAndDisplayHomeDetailsVC
            targetVC?.isFromProfile = false
            targetVC?.isFromFavorites = false
            targetVC?.pushnotificatonsDetails = pushnotificatons
            targetVC?.headerTitle = "HomeDesigns"
            let nav = UINavigationController(rootViewController: targetVC!)
            currentWindow.rootViewController = nav
        }
        else if pushnotificatons.moduleType == "HomeAndLand"{
                let targetVC = storyboard.instantiateViewController(withIdentifier: "HomeLandPushNotifiactionVC") as? HomeLandPushNotifiactionVC
                targetVC?.isFromProfile = false
                targetVC?.isFromFavorites = false
                targetVC?.pushnotificatonsDetails = pushnotificatons
                targetVC?.packageIdFromNotifications = pushnotificatons.handLPackageId
                let nav = UINavigationController(rootViewController: targetVC!)
                currentWindow.rootViewController = nav
            
        }else{
                let targetVC = storyboard.instantiateViewController(withIdentifier: "HomeDesignsAndDisplayHomeDetailsVC") as? HomeDesignsAndDisplayHomeDetailsVC
                targetVC?.isFromProfile = false
                targetVC?.isFromFavorites = false
                targetVC?.pushnotificatonsDetails = pushnotificatons
                targetVC?.headerTitle = "DisplayHomes"
                let nav = UINavigationController(rootViewController: targetVC!)
                currentWindow.rootViewController = nav
            
        }
    }
    
    currentWindow.makeKeyAndVisible()
    
    
}


func setStatusBarColor (color: UIColor? = APPCOLORS_3.Orange_BG) {
    
    UIApplication.shared.statusBarView?.backgroundColor = color
}


//MARK: - MBProgressHUD

func showActivityManager () {
    
    DispatchQueue.main.async(execute: {
       // if kWindow.subviews.contains(<#T##other: Collection##Collection#>)
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

