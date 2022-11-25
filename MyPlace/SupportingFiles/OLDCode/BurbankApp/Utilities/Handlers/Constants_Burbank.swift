//
//  Constants.swift
//  BurbankApp
//
//  Created by dmss on 13/12/16.
//  Copyright © 2016 DMSS. All rights reserved.
//

import Foundation
import UIKit

//let IS_IPAD = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad) ? true : false
//let IS_IPHONE =  UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone ? true : false
//
//let SCREEN_WIDTH =  UIScreen.main.bounds.size.width
//let SCREEN_HEIGHT =  UIScreen.main.bounds.size.height
//let SCREEN_MAX_LENGTH = max(SCREEN_WIDTH, SCREEN_HEIGHT)
//let SCREEN_MIN_LENGTH = min(SCREEN_WIDTH, SCREEN_HEIGHT)

let IS_IPHONE_4  = (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0) ? true : false
let IS_IPHONE_5  = (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0) ? true : false
let IS_IPHONE_6  = (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0) ? true : false
let IS_IPHONE_6P = (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0) ? true : false
let IS_IPHONE_X = (IS_IPHONE && SCREEN_MAX_LENGTH >= 812.0) ? true : false


let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]

//for Photos
let topViewHeight: CGFloat = SCREEN_HEIGHT * 0.065
let numOfPhotosToDisplay = 4

let CellID = "CellID"
//let kGet = "GET"
//let kPost = "POST"

let newHomesTitle = "New Homes"
let hlHomesTitle = "H & L Packages"
let kIsHLMainFilterShown = "isHLMainFilterShown"

var lowerPrice = 155.0
var upperPrice = 395.0

 typealias CompletionHandler = (_ data: Any) -> Void

 typealias CompletionHandlerAny = (_ data: Any) -> Void

var alertVC = BurbankAlertVC(title: "", message: "")

enum nameOfMonths: Int
{
    case NoName = 0,January = 1,February,March,April,May,June,July,August,September,October,November,December,None
}
func fontSizeOf(size: CGFloat) -> CGFloat
{
    var preferredSize: CGFloat!
    if IS_IPAD
    {
        preferredSize = size + 3.5
    }else if IS_IPHONE
    {
        if IS_IPHONE_6P
        {
            preferredSize = size + 2
        }else
        {
            preferredSize = size
        }
    }
     return preferredSize
}

func ProximaNovaRegular(size: CGFloat) -> UIFont
{
    return UIFont(name: "ProximaNova-Regular", size: fontSizeOf(size: size))!
}
func ProximaNovaSemiBold(size: CGFloat) -> UIFont
{
    return UIFont(name: "ProximaNova-Semibold", size: fontSizeOf(size: size))!
}
func getWeekName(weekNum : Int) -> String
{
    switch weekNum
    {
    case 1 :
        return "Sunday"
        
    case 2 :
        return "Monday"
        
    case 3 :
        return "Tuesday"
        
    case 4 :
        return "Wednesday"
        
    case 5 :
        return "Thursday"
        
    case 6 :
        return "Friday"
        
    case 7 :
        return "Saturday"
        
    default :
        return ""
    }
}
func getMonthNameWith(id: Int) -> String
{
    var month: nameOfMonths = .None //= nameOfMonths(rawValue: id)
    month = nameOfMonths(rawValue: id) ?? .None
    switch month
    {
    case .January:
        return "January"
    case .February:
        return "February"
    case .March:
        return "March"
    case .April:
        return "April"
    case .May:
        return "May"
    case .June:
        return "June"
    case .July:
        return "July"
    case .August:
        return "August"
    case .September:
        return "September"
    case .October:
        return "October"
    case .November:
        return "November"
    case .December:
        return "December"
    default:
        return ""
    }
}

let kPDF = "PDF"
// WEB SERVICES URL

// Dev
//let baseURL = "http://192.168.100.92:9999/api/"

//Server
//let baseURL = "https://www.burbank.com.au/CentralLoginSystem/api/"//"http://test.burbank.com.au/CentralLoginSystem/api/"
let baseURL = "https://www.burbank.com.au/CentralLogin.WebApi/api/"

//Naveen test
//let baseURL = "http://172.17.0.13/CentralLoginSystem/api/"
let toLoginURL = String(format: "%@login/", baseURL)
let loginURL = String(format: "%@getUserDetails", toLoginURL)
let registerUserURL = String(format: "%@VerifyAddNewRegisteredUser", toLoginURL)
let validateMyPlaceURL = String(format: "%@ValidateMyPlaceDetails", toLoginURL)
let validateEmailSendPassCodeURL = String(format: "%@ValidateEmailSendPassCode", toLoginURL)
let verifyPasscodeURL = String(format: "%@VerifyPasscodeAddMyPlaceUser", toLoginURL)//VerifyPasscodeAddMyPlaceUser
let authenticateCentralLoginUserURL = String(format: "%@AuthenticateCentralUserLogin",toLoginURL)
let updateCentralLoginUserURL = String(format: "%@UpdateCentralLoginUser", toLoginURL)//UpdateCentralLoginUser
let resendPasscodeURL = String(format: "%@ResendPasscode", toLoginURL)
let forgotPasswordURL = String(format: "%@ForgotPassword", toLoginURL)
let updatePasswordURL = String(format: "%@UpdatePassword", toLoginURL)
let resetPasswordURL = String(format: "%@ResetPassword", toLoginURL)
let profilePicURL = String(format: "%@userProfile/UpdateProfilePic", baseURL)
let getProfileURL = String(format: "userProfile/getUserProfile")
let updateProfileURL = String(format: "userProfile/UpdateUserProfile")
let addJobURL = String(format: "%@AddJob", toLoginURL)
let contactUsURL = String(format: "%@contact/GetContactDetails?jobNumber=", baseURL)


//CoBurbank Service URL's
let getCoBurbankListURL = String(format: "%@coburbank/GetCoBurbanks", baseURL)
let addCoBurbankURL = String(format: "%@coburbank/AddCoBurbank", baseURL)
let getCoBurbankInvitationsListURL = String(format: "%@coburbank/GetCoBurbankNotifications", baseURL)
let acceptInvitationURL = String(format: "%@coburbank/AcceptInvitation", baseURL)
let rejectInvitationURL = String(format: "%@coburbank/RejectInvitation", baseURL)
let sendInvitationURL = String(format: "%@coburbank/SendInvitation", baseURL)
let deleteInvitationURL = String(format: "%@coburbank/Delete", baseURL)
let faqURL = String(format: "%@coburbank/Delete", baseURL)





//http://test.burbank.com.au/CentralLoginSystem/api/coburbank/GetCoBurbankNotifications
//URL's for getting new homes, H&L , Display Homes list based on region
let homesURL = String(format: "%@home/newhomeslist",baseURL)

let HLURL = String(format: "%@home/homelandlist",baseURL)

let DisplayHomesLocationsURL = String(format: "home/getAllDisplayLocations")

let DisplayHomesForSalesURL = String(format: "home/getAllDisplayHomesforSale")



//URL's for getting new homes, H&L , Display Homes  detail based on Home
let newHomesDetailURL = String(format: "home/newhomedetail")

let HLHomesDetailsURL = String(format: "home/homelanddetail")

let DisplayHomesDetailsURL = String(format: "home/getDisplayHomeforSaleById")
let DisplayLocationDetailsURL = String(format: "home/getDisplayLocationById")



//MyPlace
//let myPlaceURL = String(format: "http://test.burbank.com.au/myplace-new/api/")
//let MyPlacePhotosURL = String(format: "%@photos/GetAllPhotosByConstructionId/",getMyPlaceURL()) //http://test.burbank.com.au/myplace-new/api/photos/GetAllPhotosByYearMonth/10155/10/2016//http://test.burbank.com.au/myplace-new/api/photos/GetAllPhotosByConstructionId/10155
//let myPlaceProgressDetails = String(format: "%@progress/GetAdminProgress?", getMyPlaceURL())
//let myPlaceContractDetails = String(format: "%@contract/GetContract?", getMyPlaceURL())
//let myPlacePhotos = String(format: "%@photos/GetAllPhotos?", getMyPlaceURL())
//let myPlaceDocumentDetails = String(format: "%@documents/GetAllDocuments?", getMyPlaceURL())
//let myPlaceFinanceDetails = String(format: "%@finance/GetFinance?", getMyPlaceURL())
//let loginUserDetails = String(format: "%@login/getLoggedinUser", getMyPlaceURL())

enum Region
{
    case OLD
    case VLC
    case QLD
    case SA
    case NSW
    case None
}

//let myPlaceDocumnetsDetailsURLString = selectedJobNumberRegion == .VLC ? "\(myPlaceVICBaseURL)documents/GetAllDocuments?constructionTicketID=\((UIApplication.shared.delegate as! AppDelegate).myPlaceStatusDetails?.constructionID ?? "0")&officeTicketID=\((UIApplication.shared.delegate as! AppDelegate).myPlaceStatusDetails?.officeID ?? "0")" : "\(clickHomeBaseURL)documents"
//var checkUserLoginurl : String
//{
//    var url = ""
//    if selectedJobNumberRegion == .VLC
//    {
//        url =  "\(myPlaceVICBaseURL)login/CheckUserlogin"//String(format: "%@login/CheckUserlogin",myPlaceVICBaseURL)
//    }else if selectedJobNumberRegion == .QLD || selectedJobNumberRegion == .SA
//    {
//        url = "\(clickHomeBaseURL)clientlogin"
//    }
//    return url
//}
//var myPlaceProgressDetailsURLString: String
//{
//    get
//    {
//        var url = ""
//        if selectedJobNumberRegion == .VLC//String(format:"%@constructionTicketID=%@&officeTicketID=%@",myPlaceProgressDetails,postBodyDictionary.value(forKey: "ConstructionID")as! NSString,postBodyDictionary.value(forKey: "OfficeID")as! NSString))!)
//        {
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            if let myPlaceStatusDetails = appDelegate.myPlaceStatusDetails
//            {
//               url = "\(getMyPlaceURL())progress/GetAdminProgress?constructionTicketID=\(myPlaceStatusDetails.constructionID)&officeTicketID=\(myPlaceStatusDetails.officeID)"
//            }
//
//        }else if selectedJobNumberRegion == .QLD || selectedJobNumberRegion == .SA
//        {
//            url = "\(getMyPlaceURL())progress/GetProgressWorkItems"
//        }
//        return url
//    }
//}
//var myPlaceContractDetailsURLString: String
//{
//    var url = ""
//    if selectedJobNumberRegion == .VLC
//    {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        if let myPlaceStatusDetails = appDelegate.myPlaceStatusDetails
//        {
//            url = "\(getMyPlaceURL())contract/GetContract?constructionTicketID=\(myPlaceStatusDetails.constructionID)&officeTicketID=\(myPlaceStatusDetails.officeID)"
//        }
//    }else if selectedJobNumberRegion == .QLD || selectedJobNumberRegion == .SA
//    {
//        url = "\(getMyPlaceURL())contract/GetContracts"
//    }
//    return url
//}
//var myPlaceDocumentsDetailsURLString: String
//{
//    var url = ""
//    if selectedJobNumberRegion == .VLC
//    {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        if let myPlaceStatusDetails = appDelegate.myPlaceStatusDetails
//        {
//            url = "\(getMyPlaceURL())documents/GetAllDocuments?constructionTicketID=\(myPlaceStatusDetails.constructionID)&officeTicketID=\(myPlaceStatusDetails.officeID)"
//        }
//    }else if selectedJobNumberRegion == .QLD || selectedJobNumberRegion == .SA
//    {
//        url = "\(getMyPlaceURL())documents/GetAllDocument"
//    }
//    return url
//}
//var myPlaceFinanceDetailsURLString: String
//{
//    var url = ""
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//    guard let myPlaceStatusDetails = appDelegate.myPlaceStatusDetails else{  return url }
//    if selectedJobNumberRegion == .VLC
//    {
//        //https://www.burbank.com.au/myplace/api/finance/GetFinance?financialTicketId=Q1034
//         url = "\(getMyPlaceURL())finance/GetFinance?financialTicketId=\(myPlaceStatusDetails.jobNumber)"
//    }else if selectedJobNumberRegion == .QLD || selectedJobNumberRegion == .SA
//    {
//        url = "\(getMyPlaceURL())finance/GetFinance?financialTicketId=\(myPlaceStatusDetails.jobNumber)"
//    }
//    return url
//}

//func myPlaceProgressDetailsURL() -> String
//{
//    var myPlaceProgressDetailsURL = ""
//    let myPlaceQLDSABaseURL = "https://www.burbank.com.au/myplace/api/"
//    if selectedJobNumberRegion == .VLC
//    {
//        myPlaceProgressDetailsURL = String(format: "%@progress/GetAdminProgress?",myPlaceVICBaseURL)
//    }else if selectedJobNumberRegion == .QLD || selectedJobNumberRegion == .SA
//    {
//        myPlaceProgressDetailsURL = String(format: "%@progress/GetProgressWorkItems",myPlaceQLDSABaseURL)
//    }
//    return myPlaceProgressDetailsURL
//}






func isEmail() -> Bool
{
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let email = appDelegate.enteredEmailOrJob
    if email.trim().isValidEmail()
    {
        return true
    }
    
    return false
}


