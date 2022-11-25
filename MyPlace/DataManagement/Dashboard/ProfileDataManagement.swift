//
//  ProfileDataManagement.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 08/06/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit

class ProfileDataManagement: NSObject {
    
    static let shared = ProfileDataManagement()
    
    
    func getProfileDetails (_ user: UserBean, succe: (() -> Void)? ) {
        
        let params = NSMutableDictionary()
        
        
        let datatask = Networking.shared.POST_request(url: ServiceAPI.shared.URL_userDetails(user.userID ?? ""), parameters: params, userInfo: nil, success: { (json, response) in
            
            if let result: AnyObject = json {
                
                let result = result as! NSDictionary
                
                if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {
                    
                    let UserInfo = result.value(forKey: "UserInfo") as? NSDictionary
                    
                    appDelegate.userData?.user?.userFirstName = String.checkNullValue(UserInfo?.value(forKey: "FirstName") as Any)
                    appDelegate.userData?.user?.userLastName = String.checkNullValue(UserInfo?.value(forKey: "LastName") as Any)
                    appDelegate.userData?.user?.userEmail = String.checkNullValue(UserInfo?.value(forKey: "Email") as Any)
                    appDelegate.userData?.user?.userPhoneNumber = String.checkNullValue(UserInfo?.value(forKey: "PhoneNumber") as Any)
                    
                    let profileImage = String.checkNullValue(UserInfo?.value(forKey: "ProfileImage") as Any)
                    
                    if profileImage.contains("No Image") {
                    
                        if let facebookId = appDelegate.userData?.user?.userFacebookID {
                            if facebookId.count > 0 { } else {
                                appDelegate.userData?.user?.userProfileImageURL = ""
                            }
                        }else if let googleId = appDelegate.userData?.user?.userGoogleID {
                            if googleId.count > 0 { } else {
                                appDelegate.userData?.user?.userProfileImageURL = ""
                            }
                        }else {
                            appDelegate.userData?.user?.userProfileImageURL = ""
                        }
                    }else {
                        
                        appDelegate.userData?.user?.userProfileImageURL = ServiceAPI.shared.URL_imageUrl(profileImage)
                    }
                    
                    
                    if UserInfo?.value(forKey: "ShareAccountWith") != nil {
                        
                        if String.checkNullValue(UserInfo?.value(forKey: "ShareAccountWith") as Any).count > 0 {
                            
                            let share = String.checkNullValue(UserInfo?.value(forKey: "ShareAccountWith") as Any).components(separatedBy: ",")
                            
                            for str: String in share {
                                let use = UserBean.init()
                                use.userEmail = str
                                
                                appDelegate.userData?.sharingUsers.append(use)
                            }
                        }
                    }
                    
                    appDelegate.userData?.saveUserDetails()
                    
                    if let succ = succe {
                        succ()
                    }
                }else { print(log: "failed to get userdetails") }
                
            }else {
                
            }
            
        }, errorblock: { (error, isJSONerror)  in
            
            if isJSONerror {
                
            }else {
                
            }
            
        }, progress: nil)
        
        
        if let _ = datatask {
            //            NetworkingManager.shared.arrayProfileTasks.add(task as Any)
        }
        
    }
    
    
    func updateProfileDetails (_ user: UserBean, succe: @escaping (() -> Void)) {
        
        var params = [String: Any]()
        
        params["FirstName"] = user.userFirstName
        params["LastName"] = user.userLastName
        
        params["Email"] = user.userEmail
        params["Password"] = user.userPassword
        params["PhoneNumber"] = user.userPhoneNumber
        params["FacebookId"] = user.userFacebookID
        params["GoogleId"] = user.userGoogleID
        
        if user.userGoogleID?.count ?? 0 > 0 {
            params["LoginType"] = "google"
        }else if user.userFacebookID?.count ?? 0 > 0 {
            params["LoginType"] = "facebook"
        }else {
            params["LoginType"] = "email"
        }
        
        params["ImageContent"] = ""
        
        
        _ = Networking.shared.POST_request(url: ServiceAPI.shared.URL_updateUser, parameters: params as NSDictionary, userInfo: nil, success: { (json, response) in
            
            if let result: AnyObject = json {
                
                let result = result as! NSDictionary
                
                if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {
                    
//                    user.userID = String.checkNumberNull(result.value(forKey: "Userinfo") as Any)// as? String
//                    appDelegate.userData?.user = user
//                    appDelegate.userData?.saveUserDetails()
                    
                    showToast("Profile Updated Successfully")
                    
                    succe()
                    
                }else {
                    
                    showToast((result.value(forKey: "message") ?? "") as! String)
                }
            }else {
                
            }
            
        }, errorblock: { (error, isJSONerror) in
            
            if isJSONerror {
                
            }else {
                
                alert.showAlert("Error", error?.localizedDescription ?? knoResponseMessage)
            }
            
        }, progress: nil)
        
        
    }
    
    
    //MARK: - Search Types
    
    func getSearchTypes (succe: (() -> Void)?) { //for
                
        _ = Networking.shared.GET_request(url: ServiceAPI.shared.URL_getSearchTypes, userInfo: nil, success: { (json, response) in
        
            if let result: AnyObject = json {
                
                let result = result as! NSDictionary
                
                if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {
                    
                    let UserInfo = result.value(forKey: "FetchListSearchText") as? NSArray
                    
                    SearchType.shared.arrSearchTypes = UserInfo as? [NSDictionary]
                    
                    if let succ = succe {
                        succ()
                    }
                }else { print(log: "search types not found") }
                
            }else {
                
            }

            
        }, errorblock: { (error, isJSONerror) in
            
            if isJSONerror {
                
            }else {
                
            }
            
        }, progress: nil)
                        
    }
    
    
    //MARK: - Save Search Filters
    
    func saveRecentSearch (_ searchJson: Any , _ searchType: Int, _ userId: String, _ succ: ((_ success: Bool) -> Void)?) {
        
        if Int(kUserID)! > 0 {
            
        }else {
            return
        }        
        
//        let filterModal = filter.serviceModal()
//        if filter.bedRoomsCount == .none {
//            filterModal.setValue("0", forKey: "MinPrice")
//            filterModal.setValue("1", forKey: "MaxPrice")
//        }

//        (filter.priceRange.priceStart == filter.priceRange.priceStart && filter.defaultPriceRange.priceEnd == filter.priceRange.priceEnd)
        
        
        
        let params = NSMutableDictionary ()
        params.setValue(userId, forKey: "UserId")
        params.setValue(searchType, forKey: "TypeId")
        params.setValue(kUserState, forKey: "StateId")
        params.setValue(searchJson, forKey: "SearchTextJson")
        
        
        _ = Networking.shared.POST_request(url: ServiceAPI.shared.URL_saveSearchTypes, parameters: params, userInfo: nil, success: { (json, response) in
            
            if let result: AnyObject = json {
                
                let result = result as! NSDictionary
                
                if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {
                    
                    if let succee = succ {
                        succee(true)
                    }
                }else {
                    print(log: "saving filter failed")
                    if let succee = succ {
                        succee(false)
                    }
                }
                
            }else {
                if let succee = succ {
                    succee(false)
                }
            }
            
        }, errorblock: { (error, isJSONerror)  in
            
            if isJSONerror {
            }else {
            }
            if let succee = succ {
                succee(false)
            }

        }, progress: nil)
        
    }
    
    //MARK: - recent Searches
    
    func recentSearchData (_ searchType: Int, _ stateId: Int, _ userId: String, succe: @escaping ((_ recentSearchJson: NSDictionary?) -> Void)) {
        
        let params = NSMutableDictionary ()
        
        
        _ = Networking.shared.POST_request(url: ServiceAPI.shared.URL_recentSearchesData(userId, NSNumber(value: stateId).stringValue, NSNumber(value: searchType).stringValue), parameters: params, userInfo: nil, success: { (json, response) in
            
            if let result: AnyObject = json {
                
                let result = result as! NSDictionary
                
                if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {
                    
//                    if searchType == SearchType.shared.homeLand {
//                        let filter = SortFilter.init(dict: result.value(forKey: "SearchJson") as! NSDictionary, recentsearch: true)
//
//                        succe((result.value(forKey: "UserFavourites") as! NSNumber).intValue, filter)
//                    }else {
//
//                    }
                    
                    succe (result)
                                        
                }else {
                    
                    print(log: "couldn't get recent searches")
                    succe(nil)
                }
                
            }else {
                
                succe(nil)
            }

        }, errorblock: { (error, isJSONerror)  in
            
            if isJSONerror {
                
            }else {
                
            }
            
            succe(nil)

        }, progress: nil)
        
    }
    
    
    //MARK: - Recent search count
    
    func getProfileDetails () {
        
        self.recentSearchData(SearchType.shared.homeLand, Int(kUserState)!, kUserID) { (recentSearchResult) in
            
            if let recent = recentSearchResult {
                                
                appDelegate.userData?.user?.userDetails?.homeLandSortFilter = SortFilter (dict: recent.value(forKey: "SearchJson") as! NSDictionary, recentsearch: true)
                
                
                setHomeLandFavouritesCount(count: (recent.value(forKey: "UserFavourites") as! NSNumber).intValue, state: kUserState)
            }else {
                
                setHomeLandFavouritesCount(count: 0, state: kUserState)
            }
        }
        
        self.recentSearchData(SearchType.shared.newHomes, Int(kUserState)!, kUserID) { (recentSearchResult) in
            
            if let recent = recentSearchResult {
                
                guard let resultFeatures = recent.value(forKey: "SearchJson") as? NSArray else {
                                                            
                    setHomeDesignsFavouritesCount(count: (recent.value(forKey: "UserFavourites") as? NSNumber)?.intValue ?? 0, state: kUserState)
                    
                    return
                }
                
                var rece = [NSDictionary] ()
                
                for item in resultFeatures as! [NSDictionary] {
                                        
                    if String.checkNullValue(item.value(forKey: "feature") as Any).contains("resultsCount") {
                                                
                        setCollectionsCount(count: (String.checkNullValue(item.value(forKey: "Answer") as Any) as NSString).integerValue, state: kUserState)
                        
                    }else {
                        
                        rece.append(item)
                    }
                }
                                
                appDelegate.userData?.user?.userDetails?.collectionRecentSearch = rece as NSArray
                                
                setHomeDesignsFavouritesCount(count: (recent.value(forKey: "UserFavourites") as? NSNumber)?.intValue ?? 0, state: kUserState)
            }else {
                
                setHomeDesignsFavouritesCount(count: 0, state: kUserState)
            }
            
        }
        
    }
        
}
