//
//  UserBean.swift
//  MyPlace
//
//  Created by Sreekanth tadi on 18/03/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit

class UserBean: NSObject {
    
    var userID: String?
    var userFacebookID: String?
    var userGoogleID: String?
    var userAppleID: String?
    
    var userEmail: String?
    var userFirstName: String?
    var userLastName: String?
    var userFullName: String?

    
    var userPassword: String?
    
    var userProfileImageURL: String?
    
    
    //LEVEL 2
    var userPhoneCountryCode: String?
    var userPhoneNumber: String?
    
    var userPhone: String {
        get {
            return  "\(self.userPhoneCountryCode ?? "")\((self.userPhoneCountryCode ?? "").count > 0 ? " " : "")\(self.userPhoneNumber ?? "")"
        }
        set {
            assertionFailure("cannot set UserBean.userPhone")
        }
    }
    
    
    var userDetails: UserDetailsMyPlace?
        
    
    
    
    override init() {
        super.init()
        
        userDetails = UserDetailsMyPlace.init()
        
    }
    
    init(dict: NSDictionary) {
        super.init()
        
        if dict.allKeys.count == 0 { setEmptyValues() }
        
        userDetails = UserDetailsMyPlace.init()

    }
    
    
    func setEmptyValues () {
        
        userID = ""
        userFacebookID = ""
        userGoogleID = ""
        
        userEmail = ""
        userFirstName = ""
        userLastName = ""
        userFullName = ""
        
        userPassword = ""
        
        userProfileImageURL = ""
        
        //LEVEL 2
        userPhoneCountryCode = ""
        userPhoneNumber = ""
        
    }
    
}



//class UserLocationServices: NSObject {
//
//    var isOn: Bool = false
//
//    override init() {
//        super.init()
//    }
//}
//
//class UserNotificationServices: NSObject {
//
//    var isOn: Bool = false
//
//    override init() {
//        super.init()
//    }
//}

class UserDetailsMyPlace: NSObject {
    
//    var userState: State_MyPlace = State_MyPlace.none
//    var userRegion: Region_MyPlace = Region_MyPlace.none

    
    var favorite: Bool = false
    var invitationStatus: Int = 1
    
    var totalInvitationsCount: Int = 0
    

    var userStateId: String = ""
    var userRegionId: String = ""

    
    var userState: String = ""
    var userRegion: String = ""

    
//    var locationServices = UserLocationServices()
//    var notificationServices = UserNotificationServices()

    
    var collectionRecentSearch: NSArray?
    var homeLandSortFilter: SortFilter?

    
    var searchCollectionCount = 0
    var searchHomeDesignCount = 0
    var searchHomeLandCount = 0
    
    var myDayCount = 0

    
    
    override init() {
        super.init()
        
        collectionRecentSearch = NSArray ()
        homeLandSortFilter = SortFilter()

    }
    
}
