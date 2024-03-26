//
//  User.swift
//  BurbankApp
//
//  Created by dmss on 14/12/16.
//  Copyright ©ba 2016 DMSS. All rights reserved.
//

import UIKit

class User: NSObject,NSCoding {
    
    
    var passCode: String?
    var message: String?
    var isNewUser: Bool?
    var passCodeAlreadySent: Bool?
    var passCodeExpired: Bool?
    var isMultipleEmails: Bool?
    var isMultipleJobs: Bool?
    var IsEmailNotMapped: Bool?
    var isCentralLoginUser: Bool?
    var email: String?
    var jobNumber: String?
    var userDetailsArray : [UserDetails]?
    var isSuccess: Bool?
    var myPlacePassword: String?
    
    init(dic: [String : Any]) {
        super.init()
        
        passCode = NSString.checkNullValue(dic["PassCode"] as? String)
        message = NSString.checkNullValue(dic["Message"] as? String)
        isNewUser = dic["IsNewUser"] as? Bool
        passCodeAlreadySent = dic["PassCodeAlreadySent"] as? Bool
        passCodeExpired = dic["PassCodeExpired"] as? Bool
        isMultipleEmails = dic["IsMultipleEmails"] as? Bool
        isMultipleJobs = dic["IsMultipleJobs"] as? Bool
        IsEmailNotMapped = dic["IsEmailNotMapped"] as? Bool
        isCentralLoginUser = dic["IsCentralLoginUser"] as? Bool
        email = NSString.checkNullValue(dic["Email"] as? String)
        jobNumber = dic["JobNumber"] as? String //NSString.checkNullValue(dic["JobNumber"] as? String)
        isSuccess = dic["Success"] as? Bool
        myPlacePassword = dic["MyPlacePassword"] as? String
        
        if let userDetailsAry = dic["UserDetails"] as? NSArray
        {
            var tempUserDetailsArray = [UserDetails]()
            for userDetailsObj in userDetailsAry
            {
                if userDetailsObj is UserDetails
                {
                    let userDetails = userDetailsObj as! UserDetails
                    tempUserDetailsArray.append(userDetails)
                }else
                {
                    let userDetailsDic = userDetailsObj as! [String: Any]
                    let myPlaceDetails = UserDetails(dic: userDetailsDic)
                    tempUserDetailsArray.append(myPlaceDetails)
                }
               
            }
            userDetailsArray = tempUserDetailsArray
        }
        
        
    }
    
    func encode(with aCoder: NSCoder)
    {
//        aCoder.encode(passCode, forKey: "PassCode")
//        aCoder.encode(message, forKey: "Message")
        aCoder.encode(isNewUser, forKey: "IsNewUser")
 //       aCoder.encode(passCodeAlreadySent, forKey: "PassCodeAlreadySent")
 //       aCoder.encode(passCodeExpired, forKey: "PassCodeExpired")
        aCoder.encode(isMultipleEmails, forKey: "IsMultipleEmails")
        aCoder.encode(isMultipleJobs, forKey: "IsMultipleJobs")
        aCoder.encode(IsEmailNotMapped, forKey: "IsEmailNotMapped")
        aCoder.encode(isCentralLoginUser, forKey: "IsCentralLoginUser")
        aCoder.encode(email, forKey: "Email")
        aCoder.encode(jobNumber, forKey: "JobNumber")
        aCoder.encode(isSuccess, forKey: "isSuccess")
        aCoder.encode(userDetailsArray, forKey: "UserDetails")
    }
     required convenience init(coder aDecoder: NSCoder)
     {

        let isNewUser = aDecoder.decodeObject(forKey: "IsNewUser") as? Bool
        let isMultipleEmails = aDecoder.decodeObject(forKey: "IsMultipleEmails") as? Bool
        let isMultipleJobs = aDecoder.decodeObject(forKey: "IsMultipleJobs") as? Bool
        let isEmailNotMapped = aDecoder.decodeObject(forKey: "IsEmailNotMapped") as? Bool
        let isCentralLoginUser = aDecoder.decodeObject(forKey: "IsCentralLoginUser") as? Bool
        let email = aDecoder.decodeObject(forKey: "Email") as? String
        let jobNumber = aDecoder.decodeObject(forKey: "JobNumber") as? String
        let isSuccess = aDecoder.decodeObject(forKey: "Success") as? Bool
        let userDetailsArray = aDecoder.decodeObject(forKey: "UserDetails") as? [UserDetails]
        #if DEDEBUG
        print(userDetailsArray?.count as Any)
        #endif
        let userDic : [String : Any]  = ["IsNewUser": isNewUser ?? false,
                        "IsMultipleEmails": isMultipleEmails ?? false,
                        "IsMultipleJobs": isMultipleJobs ?? false,
                        "IsEmailNotMapped": isEmailNotMapped ?? false,
                        "IsCentralLoginUser": isCentralLoginUser ?? false,
                        "Email": email ?? "",
                        "JobNumber": jobNumber ?? "",
                        "Success": isSuccess ?? false,
                        "UserDetails": userDetailsArray ?? []]
        self.init(dic: userDic)
        
    }
}


class UserDetails: NSObject,NSCoding
{
    var id: Int?
    var region: String?
    var primaryJobNumber: String?
    var primaryEmail: String?
    var isActive: Bool?
    var isMyPlaceAccessible: Bool?
    var fullName: String?
    var firstName: String?
    var lastName: String?
    var mobile: String?
    var myPlaceDetailsArray = [MyPlaceDetails]()
   
    init(dic: [String: Any])
    {
        id = dic["Id"] as? Int
        region = dic["Region"] as? String
        primaryEmail = dic["Email"] as? String
        primaryJobNumber = dic["JobNo"] as? String
        isActive = dic["IsActive"] as? Bool
        isMyPlaceAccessible = dic["isMyPlaceAccessible"] as? Bool
        fullName = dic["FullName"] as? String
        firstName = dic["FirstName"] as? String
        lastName = dic["LastName"] as? String
        mobile = dic["Mobile"] as? String
        if let myPlaceDetailsAry = dic["MyPlaceDetails"] as? NSArray
        {
            for myplaceDetailObj in myPlaceDetailsAry
            {
                if myplaceDetailObj is MyPlaceDetails
                {
                    let myplaceDetails = myplaceDetailObj as! MyPlaceDetails
                    myPlaceDetailsArray.append(myplaceDetails)
                }else
                {
                    if let myPlaceDetailDic = myplaceDetailObj as? [String: Any]
                    {
                        let myPlaceDetail = MyPlaceDetails(dic: myPlaceDetailDic)
                        myPlaceDetailsArray.append(myPlaceDetail)
                    }
                }
                
            }
            
        }
        
        
    }
    func isPrimary() -> Bool
    {
        var isPrimary = false
        if primaryEmail != nil
        {

            myPlaceDetailsArray[0].myPlaceEmailsArray.forEach({ (myPlaceEmails: MyPlaceEmails?) in

                print(myPlaceEmails?.email)

                if myPlaceEmails?.email == primaryEmail
                {
                    if let myPlaceIsPrimary =  myPlaceEmails?.isPrimary
                    {
                        isPrimary = myPlaceIsPrimary
                    }
                }
            })
        }

        return isPrimary
    }
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(id, forKey: "Id")
        aCoder.encode(region, forKey: "Region")
        aCoder.encode(primaryEmail, forKey: "Email")
        aCoder.encode(primaryJobNumber, forKey: "JobNo")
        aCoder.encode(isActive, forKey: "IsActive")
        aCoder.encode(isMyPlaceAccessible, forKey: "isMyPlaceAccessible")
        aCoder.encode(fullName, forKey: "FullName")
        aCoder.encode(firstName, forKey: "FirstName")
        aCoder.encode(lastName, forKey: "LastName")
        aCoder.encode(mobile, forKey: "Mobile")
        aCoder.encode(myPlaceDetailsArray, forKey: "MyPlaceDetails")
    }
    required convenience init(coder aDecoder: NSCoder)
    {
        let id = aDecoder.decodeObject(forKey: "Id") as? Int
        let region = aDecoder.decodeObject(forKey: "Region") as? String
        let primaryEmail = aDecoder.decodeObject(forKey: "Email") as? String
        let primaryJobNumber = aDecoder.decodeObject(forKey: "JobNo") as? String
        let isActive = aDecoder.decodeObject(forKey: "IsActive") as? Bool
        let isMyPlaceAccessible = aDecoder.decodeObject(forKey: "isMyPlaceAccessible") as? Bool
        let fullName = aDecoder.decodeObject(forKey: "FullName") as? String
        let firstName = aDecoder.decodeObject(forKey: "FirstName") as? String
        let lastName = aDecoder.decodeObject(forKey: "LastName") as? String
        let mobile = aDecoder.decodeObject(forKey: "Mobile") as? String
        
        
        let myPlaceDetailsArray = aDecoder.decodeObject(forKey: "MyPlaceDetails") as? [MyPlaceDetails]
        
        let detailsDic : [String : Any] = ["Id": id ?? 0,
                          "Region": region ?? "",
                          "Email": primaryEmail ?? "",
                          "JobNo": primaryJobNumber ?? "",
                          "IsActive": isActive ?? false,
                          "isMyPlaceAccessible": isMyPlaceAccessible ?? false,
                          "FullName": fullName ?? "",
                          "MyPlaceDetails": myPlaceDetailsArray ?? [],
                          "FirstName": firstName ?? "",
                          "LastName": lastName ?? "",
                          "Mobile": mobile ?? ""]
        self.init(dic: detailsDic)
    }
}
class MyPlaceDetails:NSObject,NSCoding
{
    var isPrimary: Bool?
    var jobNumber: String?
    var password: String?
    var userName: String?
    var userId: Int?
    var region: String?
    var myPlaceEmailsArray = [MyPlaceEmails]()
    init(dic: [String: Any])
    {
        isPrimary = dic["IsPrimary"] as? Bool
        jobNumber = dic["JobNo"] as? String
        password = dic["Password"] as? String
        userName = dic["UserName"] as? String
        userId = dic["UserId"] as? Int
        region = dic["Region"] as? String
        if let myPlaceEmailArray = dic["MyPlaceEmails"] as? NSArray
        {
            for myplaceEmailObj in myPlaceEmailArray
            {
                if myplaceEmailObj is MyPlaceEmails
                {
                    let myplaceEmails = myplaceEmailObj as! MyPlaceEmails
                    myPlaceEmailsArray.append(myplaceEmails)
                    
                }else
                {
                    if let myPlaceEmailDic = myplaceEmailObj as? [String: Any]
                    {
                        let myPlaceEmail = MyPlaceEmails(dic: myPlaceEmailDic)
                        myPlaceEmailsArray.append(myPlaceEmail)
                    }

                }
            }
            
        }
    }
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(isPrimary, forKey: "IsPrimary")
        aCoder.encode(jobNumber, forKey: "JobNo")
        aCoder.encode(password, forKey: "Password")
        aCoder.encode(userName, forKey: "UserName")
        aCoder.encode(userId, forKey: "UserId")
        aCoder.encode(region, forKey: "Region")
        aCoder.encode(myPlaceEmailsArray, forKey: "MyPlaceEmails")
    }
    required convenience init(coder aDecoder: NSCoder)
    {
        let isPrimary = aDecoder.decodeObject(forKey: "IsPrimary") as? Bool
        let jobNumber = aDecoder.decodeObject(forKey: "JobNo") as? String
        let password = aDecoder.decodeObject(forKey: "Password") as? String
        let userName = aDecoder.decodeObject(forKey: "UserName") as? String
        let userId = aDecoder.decodeObject(forKey: "UserId") as? Int
        let region = aDecoder.decodeObject(forKey: "Region") as? String
        let myPlaceEmailsArray = aDecoder.decodeObject(forKey: "MyPlaceEmails") as? [MyPlaceEmails]
        
        let detailsDic = ["IsPrimary": isPrimary ?? false,"JobNo": jobNumber ?? "","Password": password ?? "","UserName": userName ?? "","UserId": userId ?? 0,"Region": region ?? "","MyPlaceEmails": myPlaceEmailsArray ?? []] as [String : Any]
        self.init(dic: detailsDic)
    }
    
}
class MyPlaceEmails: NSObject,NSCoding
{
    var contactId: String?
    var email : String?
    var password : String?
    var isPrimary: Bool?
    init(dic: [String: Any])
    {
        contactId = dic["ContactId"] as? String
        email = dic["Email"] as? String
        password = dic["Password"] as? String
        isPrimary = dic["IsPrimaryUser"] as? Bool
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(contactId, forKey: "ContactId")
        aCoder.encode(email, forKey: "Email")
        aCoder.encode(password, forKey: "Password")
        aCoder.encode(isPrimary, forKey: "IsPrimaryUser")
    }
    required convenience init(coder aDecoder: NSCoder)
    {
        let contactId = aDecoder.decodeObject(forKey: "ContactId") as? String
        let email = aDecoder.decodeObject(forKey: "Email") as? String
        let password = aDecoder.decodeObject(forKey: "Password") as? String
        let isPrimary = aDecoder.decodeObject(forKey: "IsPrimaryUser") as? Bool
        let detailsDic = ["ContactId": contactId ?? "","Email": email ?? "","Password": password ?? "" ,"IsPrimaryUser": isPrimary ?? false] as [String : Any]
        self.init(dic: detailsDic)
    }
}


struct myContractJobDetailsV3 : Codable{
    let myHomeUsername : String
    let clientTitle : String
    let letterTitle : String
    let myHomeUserName : String
    let myHomePassword : String
    let contactDetails : ContactDetailsOfV3
    
    
}

struct ContactDetailsOfV3 : Codable{
    let mobilePhone : String
    let emailAddress : String
}
