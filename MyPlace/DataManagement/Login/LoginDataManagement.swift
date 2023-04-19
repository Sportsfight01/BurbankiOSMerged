//
//  LoginDataManagement.swift
//  MyPlace
//
//  Created by Sreekanth tadi on 18/03/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn



//enum LoginType {
//    case Google
//    case Facebook
//    case Apple
//}



class LoginDataManagement: NSObject {
    
//    static var shared1: LoginDataManagement = {
//
//        let lo = LoginDataManagement()
//
//        return lo
//    }()
    
    static let shared = LoginDataManagement()
    
    private static let manager = LoginManager.init()
    
    var viewContr: UIViewController?
    
    
    
    func handleGoogleSignIn () {
        
        if let googleuser = GIDSignIn.sharedInstance()?.currentUser?.userID {
            print(googleuser)
//            GIDSignIn.sharedInstance()?.restorePreviousSignIn()
            if let profileimageURL = GIDSignIn.sharedInstance()?.currentUser.profile.imageURL(withDimension: 1024) {
               print(profileimageURL)
                appDelegate.userData?.user?.userProfileImageURL = profileimageURL.absoluteString
                appDelegate.userData?.saveUserDetails()
            }
            
        }else {
            
            GIDSignIn.sharedInstance()?.clientID = "976988441990-81uf7ih5t60qqot2uss6t6jfh83r9ho5.apps.googleusercontent.com"
            
            GIDSignIn.sharedInstance()?.presentingViewController = viewContr
            
            GIDSignIn.sharedInstance()?.delegate = self
            GIDSignIn.sharedInstance()?.shouldFetchBasicProfile = true
            GIDSignIn.sharedInstance().signIn()
            
        }
        
    }
    
    func logoutGoogle () {
        
        if let googleuser = GIDSignIn.sharedInstance()?.currentUser?.userID {

            print(googleuser)
            GIDSignIn.sharedInstance()?.signOut()
        }
    }
    
}


extension LoginDataManagement {
    
    func handleFacebookSignIn () {  
        
        if AccessToken.isCurrentAccessTokenActive {
            self.getUserDetailsFromFacebook(nil)
            return
        }
        
        LoginDataManagement.manager.logIn(permissions: ["public_profile", "email"], from: viewContr) { (response, error) in
            
            if let err = error {
                #if DEDEBUG
                print(err)
                #endif
                print(log: err)
                
            }else {
                
                if let result = response {
                    if result.isCancelled {
                        
                    }else {
                        self.getUserDetailsFromFacebook { (user) in
                            if let email = user.userEmail {
                                if email.count > 0 {
                                    self.createAccount(user, success: nil)
                                }else {
                                    
                                    appDelegate.userData?.user?.userFirstName = ""
                                    appDelegate.userData?.user?.userLastName = ""
                                    appDelegate.userData?.user?.userFacebookID = ""
                                    appDelegate.userData?.user?.userEmail = ""
                                    appDelegate.userData?.user?.userProfileImageURL = ""
                                    
                                    appDelegate.userData?.saveUserDetails()
                                    
                                    showAlert("This Facebook account is not linked with Email. Please try other login options.", kWindow.rootViewController!, ["OK"]) { (str) in
                                        self.logoutFacebook ()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    func logoutFacebook () {
        
        if AccessToken.isCurrentAccessTokenActive {
                    
            let deletepermission = GraphRequest (graphPath: "/me/permissions", httpMethod: .delete)
                        
            deletepermission.start {(connection,result,error)-> Void in
                
              //  print ("the delete permission is \(result)")
                
                Profile.current = nil
                AccessToken.current = nil
                
                LoginDataManagement.manager.logOut()
                //            LoginDataManagement.manager.
                
            }
        }
    }
    
    func getUserDetailsFromFacebook (_ handler: ((_ user: UserBean) -> Void)?) {
        
        if AccessToken.isCurrentAccessTokenActive {

        }else {
//            handleFacebookSignIn()
        }
        
        GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email, gender, birthday, about"]).start { (connection, result, error) in
            
            if let err = error {
                print(log: err)
                return
            }
            
            print(log: result as Any)
            print(log: (result as! NSDictionary).value(forKey: "name") as Any)
            
            let user = appDelegate.userData!.user!
            user.userFirstName = (result as! [String: Any])["first_name"] as? String ?? ""
            user.userLastName = (result as! [String: Any])["last_name"] as? String ?? ""
            user.userFacebookID = (result as! [String: Any])["id"] as? String ?? ""
            user.userEmail = (result as! [String: Any])["email"] as? String ?? ""

            if let picture = (result as! [String: Any])["picture"] {
                if let data = (picture as! [String: Any])["data"] {
                    user.userProfileImageURL = (data as! [String: Any])["url"] as? String ?? ""
                }
            }
            
//            local service
            if let completion = handler {
                completion(user)
            }
            
//            showAlert("Successfully LoggedIn", self.viewContr!) { (str) in
//
//                appDelegate.userData?.saveUserDetails()
//                loadMainView()
//            }
            
        }

    }
    
    
}


extension LoginDataManagement: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let err = error {
            print(log: err.localizedDescription)
            return
        }
        
        print(log: user.userID ?? "")
        
        print(log: user.profile.name ?? "")
        print(log: user.profile.familyName ?? "")
        print(log: user.profile.givenName ?? "")
        print(log: user.profile.email ?? "")
        print(log: user.profile.hasImage)
        print(log: user.profile.imageURL(withDimension: 1024) ?? "")
        
        print(log: user.authentication.accessTokenExpirationDate ?? "")
        print(log: user.authentication.accessToken ?? "")
        

        let userapp = appDelegate.userData!.user!
        userapp.userFirstName = user.profile.givenName
        userapp.userLastName = user.profile.familyName
        userapp.userGoogleID = user.userID
        userapp.userEmail = user.profile.email
        userapp.userProfileImageURL = user.profile.imageURL(withDimension: 1024)?.absoluteString ?? ""
        
//        local service
        createAccount((appDelegate.userData?.user)!, success: nil)
        
        
//        showAlert("Successfully LoggedIn", self.viewContr!) { (str) in
////            appDelegate.userData?.user = userapp //no need, as we are operationg on same memory
//            appDelegate.userData?.saveUserDetails()
//            loadMainView()
//        }

        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
        print(log: error.localizedDescription)
    }
    
}



extension LoginDataManagement {
    
    func createAccount (_ userNew: UserBean, success: (() -> Void)?) {
        
        var params = [String: Any]()
        params["FirstName"] = userNew.userFirstName
        params["LastName"] = userNew.userLastName
        params["Email"] = userNew.userEmail
        params["Password"] = userNew.userPassword
        params["PhoneNumber"] = userNew.userPhoneNumber
        params["FacebookId"] = userNew.userFacebookID
        params["GoogleId"] = userNew.userGoogleID
        params["AppleId"] = userNew.userAppleID
        if userNew.userGoogleID?.count ?? 0 > 0 {
            params["LoginType"] = "google"
        }else if userNew.userFacebookID?.count ?? 0 > 0 {
            params["LoginType"] = "facebook"
        }else if userNew.userAppleID?.count ?? 0 > 0 {
            params["LoginType"] = "apple"
        }else {
            params["LoginType"] = "email"
        }
        if userNew.userProfileImageURL != nil{
            if let profileurl = URL(string: userNew.userProfileImageURL ?? ""){
                do{
                    
                    let imageData = try Data(contentsOf: profileurl as URL)
                    let image : UIImage = UIImage(data: imageData)!
                    let base64Str = image.base64
                    print("Base64StringOfImg-=-=-=-=-",base64Str ?? "")
                    params["ImageContent"] = base64Str
                    let decodedImage = base64Str?.imageFromBase64
                    print(decodedImage)
                }
                catch{
                    print(log: "Unable to load Data")
                }
              }
          }else{
            params["ImageContent"] = ""
        }
        
        
       
        
        
        
        let _ = Networking.shared.POST_request(url: ServiceAPI.shared.URL_registration, parameters: params as NSDictionary, userInfo: nil, success: { (json, response) in
            if let result: AnyObject = json {
                let result = result as! NSDictionary
                if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {
                    userNew.userID = String.checkNumberNull(result.value(forKey: "Userinfo") as Any)// as? String
                    //                    userNew.userFullName = (userNew.userFirstName ?? "") + (userNew.userLastName ?? "")
                    if (params["LoginType"] as! String) == "apple" || (params["LoginType"] as! String) == "google" || (params["LoginType"] as! String) == "facebook" {
                        
                        appDelegate.userData?.user = userNew
                        appDelegate.userData?.accessToken = String.checkNullValue(result.value(forKey: "token") as Any)
                        
                        
                        appDelegate.userData?.saveUserDetails()
                        loadMainView()
                        
                        showToast(result.value(forKey: "message") as? String ?? "")
                        
                    }else {
                        
                        if let succ = success {
                            succ ()
                        }
                        showToast(result.value(forKey: "message") as? String ?? "")
                    }
                    
                }else {
                    
                    showToast((result.value(forKey: "message") ?? "") as! String)
                }
            }else {
                
            }
            
        }, errorblock: { (error, isJSONerror)  in
            
            if isJSONerror {
                
            }else {
                
                alert.showAlert("Error", error?.localizedDescription ?? knoResponseMessage)
            }
            
        }, progress: nil)
        
    }
    
    //MARK: - API
        
    func handleDefaultLoginforToken (_ noparamsBlock: noParamsBlock?) {
            
            let params = ["Username" : defaultLoginEmail, "Password" : defaultLoginPassword]
            
            
            let _ = Networking.shared.POST_request(url: ServiceAPI.shared.URL_userLogin, parameters: params as NSDictionary, userInfo: nil, success: { (json, response) in
                
                if let result: AnyObject = json {
                    
                    let result = result as! NSDictionary
                    
                    if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {
                        
    //                    appDelegate.userData?.user?.userID = String.checkNumberNull(result.value(forKey: "Userid") as Any)
    //
    //                    if (appDelegate.userData?.user?.userID?.count)! > 0 {
    //
    //                        appDelegate.userData?.user?.userEmail = email
    //                        appDelegate.userData?.user?.userPassword = password
    //                    }else {
    //                        assertionFailure("UserID shouldn't empty")
    //                    }
    //
    //                    print(log: appDelegate.userData?.user?.userID! ?? "0")
    //                    print(log: "\(appDelegate.userData?.user?.userID ?? "0")")
                        
                        appDelegate.guestUserAccessToken = String.checkNullValue(result.value(forKey: "token") as Any)
                        
//                        appDelegate.userData?.saveUserDetails()
                        
                        if let bloc = noparamsBlock {
                            bloc ()
                        }                        
//                        showToast("Logged in Successfully")
                    }else {
                        
                        if (result.value(forKey: "message") ?? "") as! String == "Email or Password is incorrect" {
                            
                            showToast(kuserNamePasswordNotMatched)
                        }else {
                            
                            showToast((result.value(forKey: "message") ?? "") as! String)
                        }
                    }
                }else {
                    
                }
                
            }, errorblock: { (error, isJSONerror)  in
                
                if isJSONerror {
                    
                }else {
                    
                    alert.showAlert("Error", error?.localizedDescription ?? knoResponseMessage)
                }
                
            }, progress: nil)
            
            
        }
    
}
