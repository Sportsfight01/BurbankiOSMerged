//
//  ServiceAPI.swift
//  MyPlace
//
//  Created by Sreekanth tadi on 18/03/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import Foundation


//let BaseURL = "http://test.burbank.com.au/MyLandTest/webapi/api/"  //Done by Amritha

// Using VPN
//let Base = "http://172.17.0.40:7777"
//For Live / UAT
let My_Place3DBASEURL = "https://www.burbank.com.au"
//let My_Place3DBASEURL = "http://10.6.45.14:8085"  // Test

//let Base = "http://dev.burbank.com.au" //Test

let Base = "https://www.burbank.com.au"
//let Base = "http://10.6.45.14:8085" // test
//    "http://10.6.45.14:8081" //Test

let BaseURL = Base + "/api/api/"

var defaultLoginEmail: String {
    return "mobileuser@gmail.com"
}
var defaultLoginPassword: String {
    //return Base == "https://www.burbank.com.au" ? "MobileUser@123" : "mobileuser@123"
    return "MobileUser@123"
}


struct ServiceAPI {
    
    static let shared = ServiceAPI()
    
    
    let videoURLBurBank = "https://video.fhyd2-1.fna.fbcdn.net/v/t39.24130-2/91322273_150807242882411_7532882588583815186_n.mp4?_nc_cat=105&_nc_sid=985c63&efg=eyJ2ZW5jb2RlX3RhZyI6Im9lcF9oZCJ9&_nc_ohc=-3uPcpulU5UAX87w3-5&_nc_ht=video.fhyd2-1.fna&oh=ffba6cf148a2c369842092142db1f810&oe=5EFDD5F4"
    
    
    let URL_config = Base + "/CentralLogin.WebApi/api/config/getall"

    
    
    //MARK: - Login
    
    func URL_checkUserExists (_ email: String) -> String { return BaseURL + "Account/CheckEmailExists?EmailId=" + email }
    
    let URL_userLogin = BaseURL + "Account/UserLogin"
    let URL_registration = BaseURL + "Account/CreateUser"
    func URL_forgotPassword (_ email: String) -> String { return BaseURL + "Account/ForgotPassword?EmailId=" + email }

    
    let URL_sendOTP = BaseURL + ""
    let URL_resetPassword = BaseURL + "Account/ResetPassword"
    let URL_changePassword = BaseURL + "Account/ChangePassword"
    
    
    
    
    //MARK: - Dashboard
    
    func URL_imageUrl (_ imagePath: String) -> String {
        if imagePath.contains("https://www.burbank.com.au"){
            print(imagePath)
            return imagePath
        }else{
            print(log: Base + imagePath.replacingOccurrences(of: "~", with: ""))
            return Base + imagePath.replacingOccurrences(of: "~", with: "")
        }
        
       
        
    }

    //PROFILE
    
    func URL_userDetails (_ userId: String) -> String {
        return BaseURL + "Account/GetUserDetails?UserId=" + userId
    }
    
    let URL_updateProfileImage = BaseURL + "Account/UpdateProfileImage"

    let URL_updateUser = BaseURL + "Account/UpdateUser"

        //share
    func URL_checkUserExistsForShare (_ email: String) -> String { return BaseURL + "Common/CheckEmailForSharing?EmailId=" + email }
    
    func URL_User_Share (_ userId: String) -> String { return BaseURL + "Common/ShareAccount?UserId=" + userId }

    
    let URL_states = BaseURL + "Common/GetStates"
    
    func URL_regions (_ st: String) -> String { return BaseURL + "Common/GetRegions?StateId=" + st }
    
//    let URL_priceRanges = BaseURL + "HomeAndLand/PriceByQuiz"
    
    let URL_priceRanges = BaseURL + "HomeAndLand/GetMinimumMaximumPrice"
    
    
    let URL_priceRangeValues = BaseURL + "NewHomes/GetPriceRange" //7 values
    
    let URL_designsCount = BaseURL + "HomeAndLand/HomeAndLandQuiz"

    
    
//    POST /api/HomeAndLand/GetMinimumMaximumPrice
    
    
    
    //HOMELAND
    
    func URL_HomeLandAllPackages (_ userId: String, _ stateId: String, page: Int) -> String {
        return page == 0 ? (BaseURL + "HomeAndLand/GetHnLAllPackages?UserId=" + userId + "&StateId=" + stateId) : (BaseURL + "HomeAndLand/GetHnLAllPackages?UserId=" + userId + "&StateId=" + stateId + "&PageNo=" + NSNumber(value: page).stringValue)
    }
    
    func URL_packageDetails (_ packageId: String) -> String {
        return BaseURL + "HomeAndLand/GetHnLPackageDetails?packageId_Landbank=\(packageId)"
    }
    
    
    func URL_packagesFilter (_ userId: String) -> String { return BaseURL + "HomeAndLand/GetHnLPackages?UserId=" + userId }
    
    

//    /api/HomeAndLand/GetHnLPackageDetails
    
    
    
    let URL_getSearchTypes = BaseURL + "Common/GetSearchType"
    
    let URL_saveSearchTypes = BaseURL + "Common/SetRecentSearch"
    
    func URL_recentSearchesData (_ userId: String, _ stateId: String, _ searchType: String) -> String { return BaseURL + "Common/GetRecentSearchData?" + "UserId=" + userId + "&StateId=" + stateId + "&TypeId=" + searchType }
    

    let URL_Favorite = BaseURL + "Common/Favourites"

    let URL_User_Favorites = BaseURL + "Common/GetUserFavouriteDesigns"

    
    let URL_Enquiry = BaseURL + "Common/EnquiryForm"

    
    //MARK: - HomeDesign
    
//    http://172.17.0.40:7777/api/api/NewHomes/NewHomesQuiz

//    let URL_HomeDesignQuiz = BaseURL + "NewHomes/NewHomesQuiz?StateId="
    func URL_HomeDesignQuiz () -> String { return BaseURL + "NewHomes/NewHomesQuiz?StateId=\(kUserState)" }

    let URL_HomeDesignDesignCount = BaseURL + "NewHomes/NewHomesNextFeatures"
    
   // http://dev.burbank.com.au/api/api/NewHomes/NewHomesFeaturesNext

    func URL_HomeDesignDetails (_ stateId: String, _ houseName: String, _ houseSize: String) -> String { BaseURL + "NewHomes/GetHouseDetailsByName?StateId=\(stateId)&HouseName=\(houseName)&HouseSize=\(houseSize)" }

    
    func URL_HomeLandPackagesWithDesign (_ stateId: String, _ houseName: String) -> String { BaseURL + "HomeAndLand/GetHnLPackageDetailsByName?StateId=\(stateId)&HouseName=\(houseName)" }


//    http://172.17.0.40:7777/api/api/HomeAndLand/GetHnLPackageDetailsByName?StateId=11&HouseName=Alexander


    //MARK: - Display Homes
    
    let locaValues = LocationServices.shared.K_GETlocationCORD
    func URL_HomeDisplay (_ stateID :Int, _ lat : String, _ long : String, _ userid :Int, _ storey : String, _ houseName : String,_ houseSize : String) -> String {
        return BaseURL + "DisplayHomes/GetDisplaysByStateId?stateId=\(stateID)&latitude=\(lat)&longitude=\(long)&userId=\(userid)&storey=\(storey)&houseName=\(houseName)&houseSize=\(houseSize)"
    }
    func URL_DisplaysForRegionAndMap() -> String{
        return BaseURL + "DisplayHomes/DisplaysForRegionAndMap"
    }
    
    func URL_DisplayNearByHomes(_ stateID :Int, _ lat : String, _ long : String, _ userid :Int) -> String{
        return BaseURL + "DisplayHomes/GetNearByDisplays?stateId=\(stateID)&latitude=\(lat)&longitude=\(long)&userId=\(userid)"
    }
    func URL_HouseDetailsByEstate(_ stateID :Int, _ estateName : String) -> String{
        return BaseURL + "DisplayHomes/HouseDetailsByEstate?stateId=\(stateID)&estateName=\(estateName)&userId=\(kUserID)"
    }

    func URL_HouseAppointment() -> String{
        return BaseURL + "DisplayHomes/HouseAppointment"
    }
   
    func URL_getRegionsByStateID(_ stateID :Int) -> String{
        return BaseURL + "DisplayHomes/GetRegionsByStateId?stateId=\(stateID)"
    }
    
    func URL_DesignHomes (_ stateID :Int, _ lat : String, _ long : String, _ userid :Int) -> String {
        return BaseURL + "DisplayHomes/GetNearByDisplays?stateId=\(stateID)&latitude=\(lat)&longitude=\(long)&userId=\(userid)" }
 
    func URL_FavoriteDisplayHomes(_ userId : Int, _ StateId : Int) -> String{
        return BaseURL + "DisplayHomes/GetUserFavouriteDisplays?userId=\(userId)&StateId=\(StateId)"
    }
//    http://localhost:5567/swagger/ui/index#!/Common/Common_SaveFavourites
   
    
    //MARK: - Put it last
    func authorizationRequired (_ url: String) -> Bool {
        if url == URL_userLogin /*|| url == URL_registration || url == URL_resetPassword || url == URL_changePassword*/ {
            return false
        }
//        if url.contains(URL_forgotPassword("")) {
//            return false
//        }
        return true
    }
    
    
    
    
    
}



