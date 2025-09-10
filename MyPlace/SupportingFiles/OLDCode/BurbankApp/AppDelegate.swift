
//  AppDelegate.swift
//  BurbankApp
//
//  Created by imac on 01/12/16.
//  Copyright © 2016 DMSS. All rights reserved.
//
import UIKit
import MBProgressHUD
import CoreData
import Firebase
import FBSDKCoreKit
import GoogleMaps
import IQKeyboardManagerSwift
import FirebaseCore
import IQKeyboardToolbarManager
import FirebaseMessaging
import FirebaseFirestore
import FirebaseAuth
/**
 - important: Make sure you read this
 - File:       AppDelegate
 - Contains:   Main app controller.
 
 Here IQKeyboardManager, NotificationCenter, CoreData, CheckingInternetConnection , ActivityIndicator are also using which helps in various ways throughout the app.
 */
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {
    
    var userData: UserData?
    var guestUserAccessToken: String?
    var userAuthToken : String?
    var notificationCount = 0
    var window: UIWindow!
    var netAvailability : Bool!
    var reachability:Reachability?
    
    //var userDetails: User?
    var loginStatus : Bool = false
    var titleString: String = ""
    
    var isFavouriteTouched = false
    var isFavouriteDetails : NSMutableArray!
    
    var replaceAsFav : String = ""
    
    var selectedModuleName : String!
    
    //    var constructionID : String!
    //    var officeID : String!
    
    var currentUser: User?
    var enteredEmailOrJob = ""
    
    //Myplace
    var myPlaceTempDictionary = NSMutableDictionary()
    var myPlaceStagesArray = NSSet()
    
    //For temporary purpose
    var passcodeStr = ""
    
    //For MyPlaceStatusDetails
    var myPlaceStatusDetails: MyPlaceStatusDetails?//storing myPlaceStatusDetails to write logic for getting url for different Regions
    var jobContacts: JobContacts? //for displaying contacts in menu bar
    
    //    for myAppointments
    var appointmentData = [appointmentsData]()
    
    var pushnotificatonsData = pushNtfcnModelInfo()
    
    private var getFcmtokenCompletion: ((String?) -> Void)?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Thread.sleep(forTimeInterval: 5.0)
        //        IQKeyboardToolbarManager.shared.isEnabled = true
        IQKeyboardManager.shared.toolbarConfiguration.tintColor = APPCOLORS_3.Orange_BG
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = APPCOLORS_3.Orange_BG
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        //        #if GOOGLELOGS
        FirebaseConfiguration().setLoggerLevel(FirebaseLoggerLevel.min)
        //Configure Firebase
        
        let googleServicesFileName = "GoogleService-Info"
//        "GoogleService-Info-BurbankMyplace"
        //        "GoogleService-MyPlace-burbank-Info" //"GoogleService-MyPlace-Info"
        
        if let filePath = Bundle.main.path(forResource: googleServicesFileName, ofType: "plist") {
            if let options = FirebaseOptions (contentsOfFile: filePath) {
                FirebaseApp.configure(options: options)
            }
        }
        GMSServices.provideAPIKey(googleAPIKey)
        //To enable the IQKeyboard manager
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardToolbarManager.shared.isEnabled = true
        //Rechability Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(checkInternetConnection), name: Notification.Name.reachabilityChanged, object: nil)
        reachability = Reachability(hostName: "www.apple.com")
        reachability?.startNotifier()
        loginStatus = isUserLoggedIn()
        fillUserEmailOrJob()
        UIApplication.shared.statusBarStyle = .lightContent
        
        appDelegate.checkAppUpdateAvailability { (status, version ) in
            //When status == true show popup.
            if status{
                showUpdatePopup(appStoreVersion: version)
            }
        } onError: { (status) in
            // Handle error
        }
        
        if #available(iOS 13.0, *) {
            // for above iOS 13 scenedelegate is calling
        } else {
            // Fallback on earlier versions
            appStartUpSetup()
        }
//        UIApplication.shared.applicationIconBadgeNumber = 0

        sleep(1)
        UNUserNotificationCenter.current().delegate = self
        requestNotificationAuthorization()
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = true
        
        
        return true
    }
    
    func requestNotificationAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.sound]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else if let error = error {
                print("Notification permission error: \(error)")
            }
        }
    }

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("Device Token: \(token)")
        Messaging.messaging().apnsToken = deviceToken
        // Send token to your server here
    }
    func application(_ application: UIApplication,
                         didFailToRegisterForRemoteNotificationsWithError error: Error) {
            print("Failed to register: \(error)")
        }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
    }
    func application(_ app: UIApplication,open url: URL,options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        
    }
    
    func checkAppUpdateAvailability(onSuccess: @escaping (Bool,String) -> Void, onError: @escaping (Bool) -> Void) {
        guard let info = Bundle.main.infoDictionary,
              let curentVersion = info["CFBundleShortVersionString"] as? String,
              let url = URL(string: "https://itunes.apple.com/au/lookup?id=1437771849") else {
            return onError(true)
            //            https://apps.apple.com/app/id1437771849
            //            https://apps.apple.com/us/app/burbank-myplace/id1437771849
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Error handling...
            guard let jsonDict = try? JSONSerialization.jsonObject(with: data!) as? NSDictionary else {
                print(error)
                
                return onError(false)}
            
            if let result = (jsonDict["results"] as? [Any])?.first as? [String: Any], let appStoreVersion = result["version"] as? String{
                DispatchQueue.main.async {
                    
                    print("version in app store", appStoreVersion," current Version ",curentVersion);
                    let versionCompare = curentVersion.compare(appStoreVersion, options: .numeric)
                    
                    if versionCompare == .orderedSame {
                        onSuccess(false, appStoreVersion)
                    } else if versionCompare == .orderedAscending {
                        onSuccess(true, appStoreVersion)
                        // 2.0.0 to 3.0.0 is ascending order, so ask user to update
                    }
                    
                }
            }
        }.resume()
    }
 
    
    func isUserLoggedIn() -> Bool
    {
        if let decoded  = UserDefaults.standard.object(forKey: "currentUser") as? NSData
        {
            let decodedUser = NSKeyedUnarchiver.unarchiveObject(with: decoded as Data)
            let user  = decodedUser as? User
            if user != nil
            {
                currentUser = user
                return true
            }
        }
        
        return false
    }
    func fillUserEmailOrJob()
    {
        if let emailOrJob = UserDefaults.standard.object(forKey: "EnteredEmailOrJob") as? String
        {
            enteredEmailOrJob = emailOrJob
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
#if DEDEBUG
        print("is Enter Foreground called.....?/")
#endif
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("is Enter background called.....?/")
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name.reachabilityChanged, object: nil)
        
        if loginStatus == false
        {
            UserDefaults.standard.removeObject(forKey: "isFirstTimeShown")
            UserDefaults.standard.removeObject(forKey: kIsHLMainFilterShown)
            UserDefaults.standard.removeObject(forKey: "filterOption")
            UserDefaults.standard.removeObject(forKey: "CurrentSuburb")
            UserDefaults.standard.removeObject(forKey: "CurrentEstate")
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print("is Enter Foreground called.....?/")
        
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("is applicationDidBecomeActive.....?/")
        
        
        
        checkInternetConnection()
        
        NotificationCenter.default.post(name: NSNotification.Name (rawValue: kLocationPermissionChanges), object: nil)
    }
    
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
    }
    
    /// Method for checking whether device has internet connection or not.
    @objc func checkInternetConnection() {
        /// This method will at any state if net on mobile and off the mobile.
        let internetStatus: NetworkStatus = reachability!.currentReachabilityStatus()
        
        if (internetStatus.rawValue != ReachableViaWiFi.rawValue) && (internetStatus.rawValue != ReachableViaWWAN.rawValue) {
            // print("Network unavailable")
            self.netAvailability = false
        }
        else {
            //  print("Network available")
            self.netAvailability = true
        }
    }
    
    /// Method for showing activity indicator.
    func showActivity() {
        
        showActivityManager ()
        
        //        DispatchQueue.main.async(execute: {
        //
        //            MBProgressHUD.showAdded(to: (self.window?.rootViewController?.view)!, animated: true)
        //            self.window?.rootViewController?.view.bringSubviewToFront(MBProgressHUD())
        //        })
    }
    
    /// Method for hiding activity indicator.
    func hideActivity() {
        
        hideActivityManager()
        
        //        DispatchQueue.main.async(execute: {
        //
        //            MBProgressHUD.hide(for: (self.window?.rootViewController?.view)!, animated: false)
        ////            MBProgressHUD.hideAllHUDs(for: (self.window?.rootViewController?.view)!, animated: true)
        //        })
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "BurbankApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    // MARK: ********** CALL BACK METHODS ***********
    
    /// MARK: --- FACEBOOK RETURN TO APPLICATION ---
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        /**
         *  Asks the delegate to open a resource specified by a URL, and provides a dictionary of launch options.
         true if the delegate successfully handled the request or false if the attempt to open the URL resource failed.
         */
        return ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: nil)
        
        
        // return false;
    }
    
    /*
     private func application(application: UIApplication, openURL url: URL, options: [String: AnyObject]) -> Bool {
     
     /**
      *  Asks the delegate to open a resource specified by a URL, and provides a dictionary of launch options.
      true if the delegate successfully handled the request or false if the attempt to open the URL resource failed.
      */
     
     if FBSDKApplicationDelegate.sharedInstance().application(application, open: url, options: options[UIApplicationOpenURLOptionsSourceApplicationKey] as! String) {
     return true
     }
     else
     {
     return false;
     }
     }
     
     */
    ///Asks the delegate for the interface orientations to use for the view controllers in the specified window.
    //    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask
    //    {
    //        return UIInterfaceOrientationMask.portrait;
    //    }
    
    /// MARK: - Core Data stack
    /// The directory the application uses to store the Core Data store file.
    lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    
}
// MARK: UISceneSession Lifecycle

@available(iOS 13.0, *)
extension AppDelegate {
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
// MARK: Push Notifications Handling
extension AppDelegate: UNUserNotificationCenterDelegate {
    // Called when a notification is delivered while app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
    // Called when the user taps the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("Notification received with info: \(userInfo)")
        
        pushnotificatonsData.houseSize = userInfo["HouseSize"] as? String ?? ""
        pushnotificatonsData.newHomesHouseId = userInfo["NewHomesHouseId"] as? String ?? ""
        pushnotificatonsData.facade = userInfo["Facade"] as? String ?? ""
        pushnotificatonsData.state = userInfo["State"] as? String ?? ""
        pushnotificatonsData.displaysHouseId = userInfo["DisplaysHouseId"] as? String ?? ""
        pushnotificatonsData.houseName = userInfo["HouseName"] as? String ?? ""
        pushnotificatonsData.handLPackageId = userInfo["HandLPackageId"] as? String ?? ""
        pushnotificatonsData.moduleType = userInfo["ModuleType"] as? String ?? ""
        pushnotificatonsData.isMultiple = userInfo["IsMultiple"] as? String ?? ""
        pushnotificatonsData.stateId = userInfo["StateId"] as? String ?? ""
        
        LoginDataManagement.shared.handleDefaultLoginforToken {
            loadDependencies{
                handleNotificationNavigation(pushnotificatons: self.pushnotificatonsData)
            }
        }
//        handleNotificationNavigation(pushnotificatons: pushnotificatonsData)
        
        
        completionHandler()
    }
    
}



extension AppDelegate {
   
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("📱 FCM Token: \(fcmToken ?? "")")
      print("Firebase registration token: \(String(describing: fcmToken))")
        fcmTokenID = fcmToken ?? ""
       
        

      let dataDict: [String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(
        name: Notification.Name("FCMToken"),
        object: nil,
        userInfo: dataDict
      )
        LocationServices.shared.requestUsertoAllowLocationPermissions(completion: { coordinates in
            var lat = coordinates?.latitude ?? 0.0
            var long = coordinates?.longitude  ?? 0.0
            if deviceUDID == UserDefaults.standard.string(forKey: "deviceUDID") ?? "" {
                lat = -20.9176
                long = 142.7028
            }
            print("------Latitude : \(lat), ------Longtitude: \(long)")
           
            LoginDataManagement.shared.saveDeviceDataForPushnotification(lat: "\(lat)", long: "\(long)", fcmTokenID: fcmTokenID)
        })
    }
}

//extension UIApplication {
//
//    var visibleViewController: UIViewController? {
//
//        guard let rootViewController = keyWindow?.rootViewController else {
//            return nil
//        }
//
//        return getVisibleViewController(rootViewController)
//    }
//
//    private func getVisibleViewController(_ rootViewController: UIViewController) -> UIViewController? {
//
//        if let presentedViewController = rootViewController.presentedViewController {
//            return getVisibleViewController(presentedViewController)
//        }
//
//        if let navigationController = rootViewController as? UINavigationController {
//            return navigationController.visibleViewController
//        }
//
//        if let tabBarController = rootViewController as? UITabBarController {
//            return tabBarController.selectedViewController
//        }
//
//        return rootViewController
//    }
//}

class pushNtfcnModelInfo {
    var houseSize : String = ""
    var newHomesHouseId : String  = ""
    var facade : String  = ""
    var state : String   = ""
    var displaysHouseId : String  = ""
    var houseName : String  = ""
    var handLPackageId : String  = ""
    var moduleType : String  = ""
    var isMultiple : String = ""
    var stateId : String = ""
}
