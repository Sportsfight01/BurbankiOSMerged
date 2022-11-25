//
//  UserData.swift
//  MyPlace
//
//  Created by Sreekanth tadi on 18/03/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit

class UserData: NSObject {
    
    var user: UserBean?
    
    var accessToken: String?

    
    var sharingUsers: [UserBean] = [UserBean(dict: [:]), UserBean(dict: [:])]
        
    
    
    override init() {
        super.init()
        
        user = UserBean()
        

        loadUserDetails()
    }
    
    
    func loadUserDetails () {
        
        accessToken = kUserDefaults.value(forKey: key_accessToken) as? String
        
        
        user?.userID = kUserDefaults.value(forKey: key_userID) as? String
        user?.userFacebookID = kUserDefaults.value(forKey: key_userFacebookID) as? String
        user?.userGoogleID = kUserDefaults.value(forKey: key_userGoogleID) as? String
        
        user?.userEmail = kUserDefaults.value(forKey: key_userEmail) as? String
        user?.userFirstName = kUserDefaults.value(forKey: key_userFirstName) as? String
        user?.userLastName = kUserDefaults.value(forKey: key_userLastName) as? String
//        user?.userFullName = kUserDefaults.value(forKey: key_userFullName) as? String

        user?.userPassword = kUserDefaults.value(forKey: key_userPassword) as? String
        user?.userProfileImageURL = kUserDefaults.value(forKey: key_userProfileImageURL) as? String

        user?.userPhoneCountryCode = kUserDefaults.value(forKey: key_userPhoneCountryCode) as? String
        user?.userPhoneNumber = kUserDefaults.value(forKey: key_userPhoneNumber) as? String

//        user?.userDetails?.locationServices.isOn = Bool(truncating: (kUserDefaults.value(forKey: key_locationServices) as? NSNumber) ?? 0)
//        user?.userDetails?.notificationServices.isOn = Bool(truncating: (kUserDefaults.value(forKey: key_notificationServices) as? NSNumber) ?? 0)

        
        user?.userDetails?.userState = ((kUserDefaults.value(forKey: key_userState) as? String) ?? "")
        user?.userDetails?.userRegion = ((kUserDefaults.value(forKey: key_userRegion) as? String) ?? "")

        
        user?.userDetails?.userStateId = ((kUserDefaults.value(forKey: key_userStateId) as? String) ?? "")
        user?.userDetails?.userRegionId = ((kUserDefaults.value(forKey: key_userRegionId) as? String) ?? "")

        
        user?.userDetails?.searchCollectionCount = ((kUserDefaults.value (forKey: key_collectionsCount) as? Int) ?? 0)
        user?.userDetails?.searchHomeDesignCount = ((kUserDefaults.value(forKey: key_homeDesignsFavoriteCount) as? Int) ?? 0)
        user?.userDetails?.searchHomeLandCount = ((kUserDefaults.value(forKey: key_homeLandFavouritesCount) as? Int) ?? 0)
        user?.userDetails?.totalInvitationsCount = ((kUserDefaults.value(forKey: key_shareInvitationsCount) as? Int) ?? 0)
    
        
        
        kUserDefaults.synchronize()
        
    }
    
    
    func saveUserDetails () {
        
        kUserDefaults.setValue(accessToken, forKey: key_accessToken)
        
        
        kUserDefaults.setValue(user?.userID, forKey: key_userID)
        kUserDefaults.setValue(user?.userFacebookID, forKey: key_userFacebookID)
        kUserDefaults.setValue(user?.userGoogleID, forKey: key_userGoogleID)
        
        kUserDefaults.setValue(user?.userEmail, forKey: key_userEmail)
        kUserDefaults.setValue(user?.userFirstName, forKey: key_userFirstName)
        kUserDefaults.setValue(user?.userLastName, forKey: key_userLastName)
//        kUserDefaults.setValue(user?.userFullName, forKey: key_userFullName)
        
        kUserDefaults.setValue(user?.userPassword, forKey: key_userPassword)
        kUserDefaults.setValue(user?.userProfileImageURL, forKey: key_userProfileImageURL)

        kUserDefaults.setValue(user?.userPhoneCountryCode, forKey: key_userPhoneCountryCode)
        kUserDefaults.setValue(user?.userPhoneNumber, forKey: key_userPhoneNumber)

//        kUserDefaults.setValue(NSNumber(value: user?.userDetails?.locationServices.isOn ?? false), forKey: key_locationServices)
//        kUserDefaults.setValue(NSNumber(value: user?.userDetails?.notificationServices.isOn ?? false), forKey: key_notificationServices)


        kUserDefaults.setValue(user?.userDetails?.userState, forKey: key_userState)
        kUserDefaults.setValue(user?.userDetails?.userRegion, forKey: key_userRegion)

        kUserDefaults.setValue(user?.userDetails?.userStateId, forKey: key_userStateId)
        kUserDefaults.setValue(user?.userDetails?.userRegionId, forKey: key_userRegionId)

        
        kUserDefaults.setValue(user?.userDetails?.searchCollectionCount, forKey: key_collectionsCount)
        kUserDefaults.setValue(user?.userDetails?.searchHomeDesignCount, forKey: key_homeDesignsFavoriteCount)
        kUserDefaults.setValue(user?.userDetails?.searchHomeLandCount, forKey: key_homeLandFavouritesCount)
        kUserDefaults.setValue(user?.userDetails?.totalInvitationsCount, forKey: key_shareInvitationsCount)
        
        
        kUserDefaults.synchronize()
        
    }
    
    func removeUserDetails () {
                
        kUserDefaults.removeObject(forKey: key_accessToken)
        
        
        kUserDefaults.removeObject(forKey: key_userID)
        kUserDefaults.removeObject(forKey: key_userFacebookID)
        kUserDefaults.removeObject(forKey: key_userGoogleID)
        
        kUserDefaults.removeObject(forKey: key_userEmail)
        kUserDefaults.removeObject(forKey: key_userFirstName)
        kUserDefaults.removeObject(forKey: key_userLastName)
//        kUserDefaults.removeObject(forKey: key_userFullName)
        
        kUserDefaults.removeObject(forKey: key_userPassword)
        kUserDefaults.removeObject(forKey: key_userProfileImageURL)

        kUserDefaults.removeObject(forKey: key_userPhoneCountryCode)
        kUserDefaults.removeObject(forKey: key_userPhoneNumber)

        kUserDefaults.removeObject(forKey: key_locationServices)
        kUserDefaults.removeObject(forKey: key_notificationServices)

        
        kUserDefaults.removeObject(forKey: key_userState)
        kUserDefaults.removeObject(forKey: key_userRegion)

        kUserDefaults.removeObject(forKey: key_userStateId)
        kUserDefaults.removeObject(forKey: key_userRegionId)

        
        kUserDefaults.removeObject(forKey: key_collectionsCount)
        kUserDefaults.removeObject(forKey: key_homeDesignsFavoriteCount)
        kUserDefaults.removeObject(forKey: key_homeLandFavouritesCount)
        kUserDefaults.removeObject(forKey: key_shareInvitationsCount)

        
        removeStateValues ()
        
        kUserDefaults.synchronize()
    }
    
    
    private func removeStateValues () {
        
        for key in Array(kUserDefaults.dictionaryRepresentation().keys) {
//            if (key as AnyObject).isKind(of: String) {
//                if (key as! String) {
                    kUserDefaults.removeObject(forKey: key)
//                }
//            }
        }
    }

    
    
    
    private let key_accessToken = "accessToken"
    
    
    private let key_userID = "userID"
    private let key_userFacebookID = "userFacebookID"
    private let key_userGoogleID = "userGoogleID"
    
    private let key_userEmail = "userEmail"
    private let key_userFirstName = "userFirstName"
    private let key_userLastName = "userLastName"
//    private let key_userFullName = "userFullName"
    
    private let key_userPassword = "userPassword"
    
    private let key_userProfileImageURL = "userProfileImageURL"

    private let key_userPhoneCountryCode = "userPhoneCountryCode"
    private let key_userPhoneNumber = "userPhoneNumber"

    private let key_locationServices = "userlocationServices"
    private let key_notificationServices = "usernotificationServices"
    
    private let key_userState = "UserState"
    private let key_userRegion = "UserRegion"
    
    private let key_userStateId = "UserStateId"
    private let key_userRegionId = "UserRegionId"

    
//    private let key_collectionsCount = "collectionsCount"
//    private let key_homeDesignsFavoriteCount = "homeDesignsFavouritesCount"
//    private let key_homeLandFavouritesCount = "homeLandFavouritesCount"
//    private let key_shareInvitationsCount = "shareInvitationsCount"

}
