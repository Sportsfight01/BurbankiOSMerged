//
//  MyPlaceURLs.swift
//  BurbankApp
//
//  Created by dmss on 21/11/17.
//  Copyright © 2017 DMSS. All rights reserved.
//

import Foundation

let kOLD = "OLD"
let kVLC = "VIC"
let kQLD = "QLD"
let kSA = "SA"

var selectedJobNumberRegion: Region
{
    var region: Region = .None
    if selectedJobNumberRegionString == kOLD
    {
        region = .OLD
    }
    else if selectedJobNumberRegionString == kVLC
    {
        region = .VLC
    }else if selectedJobNumberRegionString == kQLD
    {
        region = .QLD
    }else if selectedJobNumberRegionString == kSA
    {
        region = .SA
    }
    return region
}
var selectedJobNumberRegionString = ""//we are setting this variable in MyPlaceDasBoard when ever user clicking on new job
let clickHomeBaseImageURL = "https://nationalclickhome.burbankgroup.com.au/clickhome3webservice/"
let clickHomeBaseImageURLForTesting = "http://10.6.45.14:8085/getattachment/"
let clickHomeBaseImageURLForLive = "https://www.burbank.com.au/getattachment/"


let clickHomeV3BaseURL = "https://nationalclickhome.burbankgroup.com.au/clickhome3webservice/myhome/V3/"
let clickHomeBaseURL = "https://nationalclickhome.burbankgroup.com.au/clickhome3webservice/ClickHome.myhome/v3/"
let myPlaceVICBaseURL = "https://www.burbank.com.au/victoria/myplace/api/"


let clickHomeV2BaseURL = "https://nationalclickhome.burbankgroup.com.au/clickhome3webservice/V2"



//let checkUserLoginurl = String(format: "%@login/CheckUserlogin",getMyPlaceURL())//http://nationalclickhome.burbankgroup.com.au/clickhome3webservice/ClickHome.myhome/v2/clientlogin

func  checkUserLoginurl() -> String
{
    return selectedJobNumberRegion == .OLD ?  "\(myPlaceVICBaseURL)login/CheckUserlogin" : "\(clickHomeBaseURL)clientlogin"
}
//let getLoggedInUser = String(format: "%@login/getLoggedinUser",getMyPlaceURL())
func getLoggedInUser() -> String
{
    return "\(getMyPlaceURL())login/getLoggedinUser"
} /*selectedJobNumberRegion == .VLC ? "\(myPlaceVICBaseURL)login/getLoggedinUser" : "\(clickHomeBaseURL)jobsteps/"*/ //getLoggedInuser calling only for VIC Region
func  myPlaceProgressDetailsURLString() -> String
{
    return selectedJobNumberRegion == .OLD ? "\(myPlaceVICBaseURL)progress/GetAdminProgress?constructionTicketID=\(selectedJobconstrucntionID())&officeTicketID=\(selectedJobOfficeID())" : "\(clickHomeBaseURL)jobsteps/"
}
func myPlaceDocumentsDetailsURLString() -> String
{
    return selectedJobNumberRegion == .OLD ? "\(myPlaceVICBaseURL)documents/GetAllDocuments?constructionTicketID=\(selectedJobconstrucntionID())&officeTicketID=\(selectedJobOfficeID())" : "\(clickHomeBaseURL)documents"
}
func  myPlaceContractDetailsURLString() -> String
{
    return selectedJobNumberRegion == .OLD ? "\(myPlaceVICBaseURL)contract/GetContract?constructionTicketID=\(selectedJobconstrucntionID())&officeTicketID=\(selectedJobOfficeID())&region=VIC" : "\(clickHomeV3BaseURL)job"
}
func  myPlaceNotesURLString() -> String
{
    let selctedID = APIManager.shared.selectedContractIDForV3
    return selectedJobNumberRegion == .OLD ? "\(myPlaceVICBaseURL)contact/GetContact?constructionTicketID=\(selectedJobconstrucntionID())&region=VIC" : "\(clickHomeV3BaseURL)Contracts/\(selctedID)/AddNote"
}
func myPlaceFinanceDetailsURLString() -> String
{
    return "\(getMyPlaceURL())finance/GetFinance?financialTicketId=\(selectedJobNumber())"
}
func clientInfoForContract(_ jobNumber: String) -> String
{
    return "\(getMyPlaceURL())survey/GetClientInfoForContractNumber?jobNumber=\(jobNumber)"//https://www.burbank.com.au/victoria/myplace/api/survey/GetClientInfoForContract?jobNumber=13923
}
func  checkUserLogin() -> String
{
    return "\(getMyPlaceURL())login/CheckUserlogin"
}
func selectedJobconstrucntionID() -> String
{
    return (UIApplication.shared.delegate as! AppDelegate).myPlaceStatusDetails?.constructionID ?? "0"
}
func selectedJobOfficeID() -> String
{
    return (UIApplication.shared.delegate as! AppDelegate).myPlaceStatusDetails?.officeID ?? "0"
}
func selectedJobNumber() -> String
{
    return (UIApplication.shared.delegate as! AppDelegate).myPlaceStatusDetails?.jobNumber ?? "0"
}
func getMyPlaceURL(isContactUs : Bool = false) -> String
{
    var myPlaceURL = String(format: "http://test.burbank.com.au/myplace-new/api/")
//    if selectedJobNumberRegion == .OLD
//    {
//        myPlaceURL = String(format: "https://www.burbank.com.au/victoria/myplace/api/")
//    }else if selectedJobNumberRegion == .QLD || selectedJobNumberRegion == .SA || selectedJobNumberRegion == .VLC || selectedJobNumberRegion == .NSW
//    {
//         //http://192.168.100.92:8989/api/contact/GetContactDetails?jobNumber=Q1410
        
        myPlaceURL = String(format: "https://www.burbank.com.au/myplace/api/")
//     https://www.burbank.com.au/myplace/api/finance/GetFinance?financialTicketId=130736
    
//        myPlaceURL = String(format: "http://192.168.100.92:8989/api/")
        
//    }
    
//    TS00620170007537
    return myPlaceURL
}

//MARK: - infoCentre Url

func getInfoCentreDetails() -> String{
    return BaseURL + "myplace/infocentre"
}

//MARK: - FAQ'S Url
func getFaq() -> String{
    return BaseURL + "myplace/faq"
}
