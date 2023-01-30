//
//  AppManager.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 05/05/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import Foundation
import AVKit
import AVFoundation



//let googleAPIKey = "AIzaSyCMr5OI8HUQ30XAXg9_hcCORDUYOxm9uZ4"

//let googleAPIKey = "AIzaSyCaFEITNNUYmiDTFaTGn8daR3sHxSevRhY"

let googleAPIKey = "AIzaSyAKYbO0DYZjyfxR2bwBd60L_tWjc0bF0cg"
//"AIzaSyB9RrZKis2aLz33DPB2-Hdtv05fsVFAGto"
//


//AIzaSyCaFEITNNUYmiDTFaTGn8daR3sHxSevRhY
var kToken: String {
    if Int(kUserID)! > 0 {
        return appDelegate.userData?.accessToken ?? ""
    }
    return appDelegate.guestUserAccessToken ?? ""
}


var kUserState: String {
    return appDelegate.userData?.user?.userDetails?.userStateId ?? String.zero()
}

var kUserStateName: String {
    return appDelegate.userData?.user?.userDetails?.userState ?? ""
}

var kUserRegion: String {
    return appDelegate.userData?.user?.userDetails?.userRegionId ?? String.zero()
}



var kShareCount: Int {
    return appDelegate.userData?.user?.userDetails?.totalInvitationsCount ?? 0
}

var kHomeLandFavoritesCount: Int {
    let key = "state\(kUserState)" //with id
    print((kUserDefaults.value(forKey: key) as? NSDictionary)?.value(forKey: key_homeLandFavouritesCount) as? Int ?? 0)
    return ((kUserDefaults.value(forKey: key) as? NSDictionary)?.value(forKey: key_homeLandFavouritesCount) as? Int) ?? 0
//    return appDelegate.userData?.user?.userDetails?.searchHomeLandCount ?? 0
}
//    ((kUserDefaults.value(forKey: key) as? NSDictionary)?.value(forKey: key_homeDesignsFavoriteCount) as? Int) ?? 0


var kCollectionFavoritesCount: Int {
    let key = "state\(kUserState)" //with id
    return ((kUserDefaults.value(forKey: key) as? NSDictionary)?.value(forKey: key_collectionsCount) as? Int) ?? 0
//    return appDelegate.userData?.user?.userDetails?.searchCollectionCount ?? 0
}


var kDesignFavoritesCount: Int {
    let key = "state\(kUserState)" //with id
    return ((kUserDefaults.value(forKey: key) as? NSDictionary)?.value(forKey: key_homeDesignsFavoriteCount) as? Int) ?? 0
//    return appDelegate.userData?.user?.userDetails?.searchHomeDesignCount ?? 0
}
var kDisplayHomesFavoritesCount: Int {
    let key = "state\(kUserState)" //with id
    return ((kUserDefaults.value(forKey: key) as? NSDictionary)?.value(forKey: key_displayHomesFavouritesCount) as? Int) ?? 0
//    return appDelegate.userData?.user?.userDetails?.searchHomeLandCount ?? 0
}
//only for count on profile button
//var kDisplayHomesFavCount : Int = 0

var kStatesMyPlace : [State]? {
//    return kUserDefaults.value(forKey: "StatesMyPlace") as? NSArray
    if let statesSaved = kUserDefaults.value(forKey: "StatesMyPlace") as? NSArray {
       
        var st = [State]()
        
        let states2 = NSArray (array: statesSaved)
        
        for i in 0...statesSaved.count {
            for stat in states2 {
                if ((stat as! NSDictionary).value(forKey: "StateOrder") as? NSNumber ?? 0) == NSNumber (value: i+1) {
                    st.append(State (dict: stat as! NSDictionary))
                    break
                }
            }
        }
        
        return st
    }
    return nil
}


var kStateRegions : [RegionMyPlace]? {
    if let regionsSaved = kUserDefaults.value(forKey: "RegionsMyPlace") as? NSArray {
        var re = [RegionMyPlace]()
        for reg in regionsSaved {
            re.append(RegionMyPlace.init(dict: reg as! NSDictionary))
        }
        return re
    }
    return nil
//    return kUserDefaults.value(forKey: "RegionsMyPlace") as? NSArray
}

var kGetEstateDetails : [houseDetailsByHouseType]? {
     let regionsSaved = kUserDefaults.data(forKey: "estateDetails")
    if let estatesSaved =  NSKeyedUnarchiver.unarchiveObject(with: regionsSaved!) as? [NSDictionary]{
        var re = [houseDetailsByHouseType]()
        for reg in estatesSaved {
            print(estatesSaved)
            re.append(houseDetailsByHouseType.init(reg as! [String : Any]))
        }
        return re
    }
    return nil
//    return kUserDefaults.value(forKey: "RegionsMyPlace") as? NSArray
}
var kNearByPlaces : [NSDictionary]? {
    let outData = UserDefaults.standard.data(forKey: "DisplaysByRegionMap")
//    let dict =
    if let regionsSaved = NSKeyedUnarchiver.unarchiveObject(with: outData!) as? [NSDictionary] {
        
//        let re = regionsSaved
//        for reg in regionsSaved {
            print(regionsSaved)
//            re.append(DisplayHomeModel.init(reg as! [String : Any]))
//        }
        return regionsSaved
    }
    return nil
}

func saveRegionstoDefaults (_ regions: NSArray) {
    kUserDefaults.setValue(regions, forKey: "RegionsMyPlace")
    kUserDefaults.synchronize()
}

func removeRegionsfromDefaults () {
    kUserDefaults.removeObject(forKey: "RegionsMyPlace")
    kUserDefaults.synchronize()
}

//func removeRegionsfromDefaults () {
//    kUserDefaults.removeObject(forKey: "DisplaysByRegion")
//    kUserDefaults.synchronize()
//}

func saveStatestoDefaults (_ states: NSArray) {
    kUserDefaults.setValue(states, forKey: "StatesMyPlace")
    kUserDefaults.synchronize()
}


func noNeedofGuestUserToast (_ vc: UIViewController = kWindow.rootViewController!, message: String = "Please login to view/edit profile") -> Bool {
    
    if (Int(kUserID) ?? 0) > 0 {
        return true
    }else {
//        showToast(message, vc)
        showAlert(message, vc, ["OK", "Login"]) { (str) in
            if str == "Login" {
                appDelegate.userData?.removeUserDetails()
                
                appDelegate.userData?.user = UserBean()
                                
                appDelegate.userData?.saveUserDetails()
                
                removeFilterFromDefaults()
                
                loadSignInView()
            }else{
                
            }
        }
        return false
    }
}



func playVideoIn (_ VC: UIViewController, _ url: String) {
    
    if let URLa = URL (string: url) {
        if url.contains("www.youtube.com") {
            
            let yt = YoutubeVideoPlayerVC ()
            yt.url = url
            VC.present(yt, animated: true, completion: nil)
            
        }else {
            
            let playerAV = AVPlayer(url: URLa)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = playerAV
            playerViewController.view.backgroundColor = APPCOLORS_3.HeaderFooter_white_BG
            VC.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }
    }
}


class SearchType: NSObject {
    
    static let shared: SearchType = SearchType()

    
    var arrSearchTypes: [NSDictionary]? {
        didSet {
            kUserDefaults.setValue(arrSearchTypes, forKey: "searchTypes")
            kUserDefaults.synchronize()
        }
    }
    
    
    override init() {
        super.init()
        
        if let types = kUserDefaults.value(forKey: "searchTypes") {
            arrSearchTypes = types as? [NSDictionary]
        }
        
    }
    
    var homeLand: Int {
        
        var hom = 0
        
        if let arr = arrSearchTypes {
            for dict in arr {
                if String.checkNullValue(dict.value(forKey: "SearchTypeText") as Any).lowercased().contains("land") { //== "Home&Land"
                    hom = (dict.value(forKey: "TypeId") as? NSNumber)?.intValue ?? 0
                    break
                }
            }
        }
        return hom
    }
    
    
    var newHomes: Int {
        
        var hom = 0
        
        if let arr = arrSearchTypes {
            for dict in arr {
                if String.checkNullValue(dict.value(forKey: "SearchTypeText") as Any).lowercased().contains("new") { //== "NewHomes"
                    hom = (dict.value(forKey: "TypeId") as? NSNumber)?.intValue ?? 0
                    break
                }
            }
        }
        return hom
    }
    
    
    var myCollection: Int {
        
        var hom = 0
        
        if let arr = arrSearchTypes {
            for dict in arr {
                if String.checkNullValue(dict.value(forKey: "SearchTypeText") as Any).lowercased().contains("collection") { //== "MyCollection"
                    hom = (dict.value(forKey: "TypeId") as? NSNumber)?.intValue ?? 0
                    break
                }
            }
        }
        return hom
    }
    
    
    var dispalyHomes: Int {
        
        var hom = 0
        
        if let arr = arrSearchTypes {
            for dict in arr {
                if String.checkNullValue(dict.value(forKey: "SearchTypeText") as Any).lowercased().contains("display") { //== "DisplayHomes"
                    hom = (dict.value(forKey: "TypeId") as? NSNumber)?.intValue ?? 0
                    break
                }
            }
        }
        return hom
    }
}



let key_shareInvitationsCount = "shareInvitationsCount"
let key_collectionsCount = "collectionsCount"
let key_homeDesignsFavoriteCount = "homeDesignsFavouritesCount"
let key_homeLandFavouritesCount = "homeLandFavouritesCount"
let key_displayHomesFavouritesCount = "displayHomesFavouritesCount"



func updateHomeDesignsFavouritesCount (_ increase: Bool) {
    
    var count = kDesignFavoritesCount
    
    if increase {
        count = count + 1
    }else {
        if count > 0 {
            count = count - 1
        }else {
            count = 0
        }
    }
    
    setHomeDesignsFavouritesCount(count: count, state: kUserState)
}


func updateCollectionsCount (_ increase: Bool) {
    
    var count = kCollectionFavoritesCount
        
    if increase {
        count = count + 1
    }else {
        if count > 0 {
            count = count - 1
        }else {
            count = 0
        }
    }
    setCollectionsCount(count: count, state: kUserState)
}


func updateHomeLandFavouritesCount (_ increase: Bool) {
    var count = kHomeLandFavoritesCount
   if increase {
        count = count + 1
    }else {
        if count > 0 {
            count = count - 1
        }else {
            count = 0
        }
    }
    setHomeLandFavouritesCount(count: count, state: kUserState)
}


func setHomeDesignsFavouritesCount (count: Int, state: String) {
    
    print(log: "HomeDesignsFavouritesCount \(count) state \(state)")
    
    let key = "state\(state)" //with id
    var dict: NSMutableDictionary?
        
    if let savedDictForState = (kUserDefaults.value(forKey: key) as? NSDictionary)?.mutableCopy() as? NSMutableDictionary {
        dict = savedDictForState
    }else {
        dict = NSMutableDictionary ()
    }
        
    dict!.setValue(count, forKey: key_homeDesignsFavoriteCount)
    kUserDefaults.setValue(dict! as Dictionary, forKey: key)
    kUserDefaults.synchronize()
    NotificationCenter.default.post(name: NSNotification.Name("FavouritesUpdated"), object: nil)
}


func setCollectionsCount (count: Int, state: String) {
    
    print(log: "CollectionsCount \(count) state \(state)")
    
    
    let key = "state\(state)" //with id
    var dict: NSMutableDictionary?
    
    
    if let savedDictForState = (kUserDefaults.value(forKey: key) as? NSDictionary)?.mutableCopy() as? NSMutableDictionary {
        dict = savedDictForState
    }else {
        dict = NSMutableDictionary ()
    }
        
    dict!.setValue(count, forKey: key_collectionsCount)
    kUserDefaults.setValue(dict! as Dictionary, forKey: key)
    kUserDefaults.synchronize()
}


func setHomeLandFavouritesCount (count: Int, state: String) {
    
    print(log: "HomeLandFavouritesCount \(count) state \(state)")

    
    let key = "state\(state)" //with id
    var dict: NSMutableDictionary?
    
    if let savedDictForState = (kUserDefaults.value(forKey: key) as? NSDictionary)?.mutableCopy() as? NSMutableDictionary {
        dict = savedDictForState
    }else {
        dict = NSMutableDictionary ()
    }
    
    dict!.setValue(count, forKey: key_homeLandFavouritesCount)
    kUserDefaults.setValue(dict! as Dictionary, forKey: key)
    kUserDefaults.synchronize()
    NotificationCenter.default.post(name: NSNotification.Name("FavouritesUpdated"), object: nil)
}

func updateDisplayHomesFavouritesCount (_ increase: Bool) {
    
    var count = kDisplayHomesFavoritesCount
    
        
    if increase {
        count = count + 1
    }else {
        if count > 0 {
            count = count - 1
        }else {
            count = 0
        }
    }
    
    setDisplayHomesFavouritesCount(count: count, state: kUserState)
}


func setDisplayHomesFavouritesCount (count: Int, state: String) {
    
    print(log: "DisplayHomeFavouritesCount \(count) state \(state)")

    
    let key = "state\(state)" //with id
    var dict: NSMutableDictionary?
    
    if let savedDictForState = (kUserDefaults.value(forKey: key) as? NSDictionary)?.mutableCopy() as? NSMutableDictionary {
        dict = savedDictForState
    }else {
        dict = NSMutableDictionary ()
    }
    
    dict!.setValue(count, forKey: key_displayHomesFavouritesCount)
    kUserDefaults.setValue(dict! as Dictionary, forKey: key)
    kUserDefaults.synchronize()
    NotificationCenter.default.post(name: NSNotification.Name("FavouritesUpdated"), object: nil)
}


func status (_ dict: NSDictionary) -> Bool {
    if let _ = dict.value(forKey: "status"), (dict.value(forKey: "status") as? Bool) == true {
        return true
    }else if let _ = dict.value(forKey: "Status"), (dict.value(forKey: "Status") as? Bool) == true {
        return true
    }
    return false
}




var victoriaRegions = [
    "Not Sure Yet","West Region","North Region","South East Region","Regional South East","Geelong & Bellarine Region", "Ballarat Region","Bendigo Region"]
var queenslandRegions = [
    "Brisbane Metro","Gold Coast","North/Moreton","South/Logan","Sunshine Coast","West/Ipswich", "East/Redlands","Other or Unsure"]
var southaustraliaRegions = [
    "Adelaide Hills","East","North","South","West","Other or Unsure"]
var nswRegions = [
    "ACT & Surrounds","Newcastle/Hunter","North-West Sydney","South-West Sydney","Wollongong/Nowra","Other or Unsure"]
