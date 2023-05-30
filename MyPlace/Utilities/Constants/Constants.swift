//
//  Constants.swift
//  MyPlace
//
//  Created by Sreekanth tadi on 18/03/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import Foundation
import UIKit


let kAPPNAME = "MyPlace"

let IS_IPAD : Bool = UIDevice.current.userInterfaceIdiom == .pad
let IS_IPHONE : Bool = UIDevice.current.userInterfaceIdiom == .phone


let appDelegate = UIApplication.shared.delegate as! AppDelegate
var kWindow: UIWindow = currentWindow
var kNavigationController: UINavigationController?

let kStoryboardMain: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
let kStoryboardLogin: UIStoryboard = UIStoryboard(name: "Login", bundle: Bundle.main)
let kStoryboardStoryFilter: UIStoryboard = UIStoryboard(name: "SortFilter", bundle: nil)

let kStoryboardHomeDesigns: UIStoryboard = UIStoryboard(name: "HomeDesign", bundle: nil)




let kStoryboardMain_OLD: UIStoryboard = UIStoryboard(name: "Main_OLD", bundle: Bundle.main)



let kUserDefaults = UserDefaults.standard



let SCREEN_WIDTH =  UIScreen.main.bounds.size.width
let SCREEN_HEIGHT =  UIScreen.main.bounds.size.height
let SCREEN_MAX_LENGTH = max(SCREEN_WIDTH, SCREEN_HEIGHT)
let SCREEN_MIN_LENGTH = min(SCREEN_WIDTH, SCREEN_HEIGHT)


let kGet = "GET"
let kPost = "POST"




//MARK: - Alert Messages
let knetworkErrorMessage = "Internet Connection Not Available"
let knoResponseMessage = "No response from server"

//let kServerErrorMessage = "Something went wrong!! Please try again later"

let kServerErrorMessage = "Loading. Please Wait...!"

//let kuserNamePasswordNotMatched = "Email or Password is incorrect"

let kuserNamePasswordNotMatched = "Email or Password is incorrect"


//let googleApiKey = "AIzaSyDf3eyRvZoh1C4UYLtQOlcYKSMj3NtczGk"



enum AppStoryBoards : String
{
    case newDesignV4 = "NewDesignsV4"
    case supportAndHelp = "SupportAndHelp"
    case myPlaceLogin = "MyPlaceLogin"
    
    //Home Care storyboard IDs
    
    case homeScreenSb = "HomeScreenStoryBoard"
    case homeCareFilesTVC = "HomeCareFilesTVC"
    case homeCareProfile = "HomeCareProfileScreen"
}
