//
//  NotificationServices.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 03/09/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit


let identifier_action = "ACTION"
let identifier_clear = "CLEAR"



class NotificationServices: NSObject {
    
    static let shared = NotificationServices ()
    
    override init() {
        super.init()
    }
    
    
    func onNotificationsServices () {
        
        notificationServicesSettings { (settings) in
            
            if settings.authorizationStatus == .authorized {
                
            }else if settings.authorizationStatus == .notDetermined {
                DispatchQueue.main.async {
                    self.registerForPushNotifications()
                }
            }else if settings.authorizationStatus == .denied {
                DispatchQueue.main.async {
                    self.offNotificationsServices ()
                }
            }
        }
    }
    
    
    func offNotificationsServices () {
        
        if let url = URL (string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:]) { (succ) in
                
            }
        }
    }
    
    
    func isNotificationServicesEnabled  (completionHandler: @escaping (_ enabled: Bool) -> Void) {
        
        self.notificationServicesSettings { (settings) in
            
            completionHandler (settings.authorizationStatus == .authorized)

            if settings.authorizationStatus == .authorized {
                
                self.registerForRemoteNotifications()
            }else if settings.authorizationStatus == .denied {
                
                self.unRegisterForRemoteNotifications ()
            }
        }
    }
    
    
    private func notificationServicesSettings  (completionHandler: @escaping (_ setting: UNNotificationSettings) -> Void) {
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            DispatchQueue.main.async {
                completionHandler (settings)
            }
        }
    }
    
    
    
    
    
    func registerForPushNotifications() {
        
        //        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            
            if granted { } else { return }
            
            //            let action = UNNotificationAction (identifier: identifier_action, title: "Action", options: [.authenticationRequired])
            //            let clear = UNNotificationAction (identifier: identifier_clear, title: "Clear", options: [.destructive])
            //
            //            let clearIdentifier = UNNotificationCategory (identifier: identifier_clear, actions: [clear], intentIdentifiers: [], options: [])
            //
            //
            //            UNUserNotificationCenter.current().setNotificationCategories([clearIdentifier])
                        
            self.notificationServicesSettings { (settings) in
                if settings.authorizationStatus == .authorized {
                    self.registerForRemoteNotifications()
                }
            }
        }
        
    }
    
    // MARK: - Remote notifications
    
    private func registerForRemoteNotifications () {
        UIApplication.shared.registerForRemoteNotifications ()
    }
    
    private func unRegisterForRemoteNotifications () {
        UIApplication.shared.unregisterForRemoteNotifications()
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        
        NotificationCenter.default.post(name: NSNotification.Name (kLocationPermissionChanges), object: nil)

    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
        
        NotificationCenter.default.post(name: NSNotification.Name (kLocationPermissionChanges), object: nil)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        guard let _ = userInfo["aps"] as? [String: AnyObject] else {
            completionHandler(.failed)
            return
        }
    }
}




// MARK: - UNUserNotificationCenterDelegate

extension LocationServices: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // 1
        let userInfo = response.notification.request.content.userInfo
        
        // 2
        if let _ = userInfo["aps"] as? [String: AnyObject] {
            
        }
        
        // 4
        completionHandler()
    }
    
}

