//
//  MyPlaceDashBoardVC+MyPlaceServiceCalls.swift
//  BurbankApp
//
//  Created by dmss on 26/10/17.
//  Copyright © 2017 DMSS. All rights reserved.
//

import Foundation
import MessageUI


let adminStagePhaseCode = "Presite"
let kAdminStage = "Administration"
let kFrameStage = "Frame Stage"
let kLockUpStage = "Lockup Stage"
let kFixoutStage = "Fixout Stage"
let kCompletion = "Completion"
let kHandover = "Handover"
let kBaseStage = "Base Stage"
let kFinishingStage = "Finishing stage"//finishing stage is combination of completion and handover stage
let myPlaceStagesColorArray: [UIColor] =  [.init(r: 236, g: 209, b: 2),
                                           .init(r: 0, g: 176, b: 76),
                                           .init(r: 236, g: 50, b: 148),
                                           .init(r: 3, g: 161, b: 230),
                                           .init(r: 139, g: 102, b: 171),
                                           .init(r: 187, g: 78, b: 18),
                                           .init(r: 223, g: 112, b: 28),
                                           .init(r: 17, g: 96, b: 39)]
let myPlaceStageNames = [kAdminStage,kFrameStage,kLockUpStage,kFixoutStage,kFinishingStage]
let kStageCompleted = "Completed"
extension MyPlaceDashBoardVC : MFMailComposeViewControllerDelegate
{
    // MARK: MyPlace Service methods
    /**
     Calling GET service for MYPLACE successful logged in USER full details
     
     - parameter data:
     */
  
    func callMyPlaceLoginServie(_ myPlaceDetails: MyPlaceDetails)
    {
//            isForLoggedInService = true
//            callLogoutService()
        self.callAndGetMyPlaceLogin(myPlaceDetails)
    }
    fileprivate func callAndGetMyPlaceLogin(_ myPlaceDetails: MyPlaceDetails)
    {
        let region = myPlaceDetails.region ?? ""
        let jobNumber = myPlaceDetails.jobNumber ?? ""
        let password = myPlaceDetails.password ?? ""
        let userName = myPlaceDetails.userName ?? ""
        selectedJobNumberRegionString = region
        // ServiceSessionMyPlace.sharedInstance.serviceConnection("POST", url: url, postBodyDictionary: ["Region": region, "JobNumber":jobNumber, "UserName":userName, "Password":password], serviceModule:"PropertyStatusService")
        let postDic = selectedJobNumberRegion == .OLD ? ["Region": region, "JobNumber":jobNumber, "UserName":userName, "Password":password] : ["job":jobNumber, "username":userName, "password":password]
       print(checkUserLoginurl())
        MyPlaceServiceSession.shared.callToPostDataToServer(checkUserLoginurl(), postDic, successBlock: { (json, response) in
            func userFailedToLoggedIn(_ message: String)
            {
                self.isUserHasData = false
                AlertManager.sharedInstance.alert(message)
                self.menuCV.isHidden = true
            }
            
            func handleForVLCRegion()
            {
                if let jsonString = json as? String
                {
                    if jsonString == "true"
                    {
                        self.isUserHasData = true
                        self.getMyPlaceLoggedinUser()
                    }else
                    {
                        userFailedToLoggedIn("Cannot access MyPlace data for this Job")
                        return
                    }
                }else
                {
                    userFailedToLoggedIn("we are unable to get data for this job")
                }
            }
            func handleForQLDSARegion()
            {
                if let jsonDic = json as? [String: Any]
                {
                    if let status = jsonDic["status"] as? String
                    {
                        if status == "OK"
                        {
                            self.appDelegate.hideActivity()
                            self.menuCV.isUserInteractionEnabled = true
                            self.appDelegate.jobContacts = nil
                            self.isUserHasData = true
                            self.updateViewForMyPlace()
                        }
                    }else
                    {
                          let message = jsonDic["Message"] as? String ?? (jsonDic["message"] as? String ?? "Invalid Credentials")
                            userFailedToLoggedIn(message)
                            return
                    }
                }
            }
            selectedJobNumberRegion == .OLD ? handleForVLCRegion() : handleForQLDSARegion()
            
        }, errorBlock: { (error, isJSon) in
        }, isResultEncodedString: true)
    }
    func getMyPlaceLoggedinUser() {
       // ServiceSessionMyPlace.sharedInstance.myDelegate = self
        //  let url = String(format: "%@login/getLoggedinUser",getMyPlaceURL())//"http://test.burbank.com.au/myplace-new/api/login/getLoggedinUser"
        //ServiceSessionMyPlace.sharedInstance.serviceConnection("GET", url: url, postBodyDictionary: ["":""], serviceModule:"GetPropertyStatusDetails" )
        MyPlaceServiceSession.shared.callToGetDataFromServer(getLoggedInUser(), successBlock: { (json, response) in
            
            if let jsonDic = json as? [String: Any]
            {
                let myPlaceStatusDetails = MyPlaceStatusDetails(dic: jsonDic)
                self.myPlaceRegion = myPlaceStatusDetails.region
                //                self.appDelegate.constructionID = self.myPLaceConstructionID as String
                //                self.appDelegate.officeID = self.myPlaceOfficeID as String
                self.appDelegate.myPlaceStatusDetails = myPlaceStatusDetails
                self.updateViewForMyPlace()
            }
        }, errorBlock: { (error, isJSONError) in
            //
            if isJSONError == false
            {
                AlertManager.sharedInstance.alert((error?.localizedDescription)!)
            }
        })
    }
    
    /**
     GET service for All Progress bar values in MY Place
     
     - parameter data:
     */
    func getMyPlaceProgressDetails() {
        //ServiceSessionMyPlace.sharedInstance.myDelegate = self
        //  ServiceSessionMyPlace.sharedInstance.serviceConnection("GET", url: NSString(format: "") as String, postBodyDictionary: ["ConstructionID":constructionID,"OfficeID":officeID], serviceModule:"GetMyPlaceProgressDetails")
        
        func checkAndShowProgressVC()
        {
            if self.stagesProgressDetailsDic.count == 0
            {
                callServerToGetProgressDeatils()
            }else
            {
                showProgressVC()
            }
        }
        func callServerToGetProgressDeatils()
        {
            MyPlaceServiceSession.shared.callToGetDataFromServer(myPlaceProgressDetailsURLString(), successBlock: { (json, response) in
                if let jsonArray = json as? NSArray
                {
                   
                    func handleForVLCRegion()
                    {
                      //  print("----->")
                     //   print(jsonArray)
                        self.myPlaceResponseArray = jsonArray.mutableCopy() as! NSMutableArray
                        self.progressTempDictionary = self.test()
                        self.showProgressVC()
                    }
                    func handleForQLDSARegion()
                    {
                        self.stagesProgressDetailsDic = CodeManager.sharedInstance.fillAndGetMyPlaceProgressDetails(jsonArray)
                        self.showProgressVC()
                    }
                    
                    selectedJobNumberRegion == .OLD ? handleForVLCRegion() : handleForQLDSARegion()
                }
            }, errorBlock: { (error, isJson) in
                AlertManager.sharedInstance.alert("Progress Not Available")
            })
        }
       selectedJobNumberRegion == .OLD ? callServerToGetProgressDeatils() : checkAndShowProgressVC()
    }
    func showProgressVC()
    {
        self.performSegue(withIdentifier: "showProgressVC", sender: nil)
    }
    func test() -> NSMutableDictionary
    {
        //tempArray.addObjectsFromArray(myPlaceResponseArray as [AnyObject])
        
        for i in 0..<myPlaceResponseArray.count {
            //let myValue = myPlaceResponseArray.objectAtIndex(i).valueForKey("StageName")
            if ((myPlaceResponseArray.object(at: i) as AnyObject).value(forKey: "StageName") is NSNull)
            {
                let value = "Administration"
                
                let dic = (myPlaceResponseArray.object(at: i) as! NSDictionary).mutableCopy()
                (dic as AnyObject).setValue(value, forKey: "StageName")
                myPlaceResponseArray.replaceObject(at: i, with: dic)
            }
            
        }
        #if DEDEBUG
        print(myPlaceResponseArray)
        #endif
        let stageNamesArray = NSMutableArray()
        
        for i in 0..<myPlaceResponseArray.count {
            
            stageNamesArray.add((myPlaceResponseArray.object(at: i) as AnyObject).value(forKey: "StageName")!)
        }
        
        stageNamesArray.remove("Base Stage")
        stageNamesArray.remove("Handover")
        
        appDelegate.myPlaceStagesArray = NSSet(array: stageNamesArray as [AnyObject])
        #if DEDEBUG
        print("Stage Names:%@",appDelegate.myPlaceStagesArray)
        #endif
        
        let allStructureDictionary = NSMutableDictionary()
        
        for i in 0..<appDelegate.myPlaceStagesArray.count {
            
            let stageArray = NSMutableArray()
            
            for j in 0..<myPlaceResponseArray.count {
                if (myPlaceResponseArray.object(at: j) as! NSDictionary).value(forKey: "StageName") as! String == (appDelegate.myPlaceStagesArray.allObjects as NSArray).object(at: i) as! String {
                    stageArray.add(myPlaceResponseArray.object(at: j) as! NSDictionary)
                }
            }
            
            allStructureDictionary.setObject(stageArray, forKey: (appDelegate.myPlaceStagesArray.allObjects as NSArray).object(at: i) as! String as NSCopying)
            
        }
       // print("allStructureDictionary:%@",allStructureDictionary)
        
        
        return allStructureDictionary
    }
    
    /**
     GET service for contract detail values in MY Place
     
     - parameter data:
     */
    func getMyPlaceContractDetails() {
        
        //ServiceSessionMyPlace.sharedInstance.myDelegate = self
       // ServiceSessionMyPlace.sharedInstance.serviceConnection("GET", url: NSString(format: "") as String, postBodyDictionary: ["ConstructionID":constructionID,"OfficeID":officeID,"Region": myPlaceRegion!], serviceModule:"GetMyPlaceContractDetails")
        func showContractVC()
        {
            self.performSegue(withIdentifier: "showContractVC", sender: nil)
        }
        if  selectedJobNumberRegion == .OLD || (selectedJobNumberRegion != .OLD && myPlaceContractDetails == nil)//myPlaceContractDetails == nil
        {
            #if DEDEBUG
            print("ContractDetails URL-->\(myPlaceContractDetailsURLString())")
            #endif
            MyPlaceServiceSession.shared.callToGetDataFromServer(myPlaceContractDetailsURLString(), successBlock: { (json, response) in
               func handleForVICRegion()
               {
                    if let jsonDic = json as? NSDictionary
                    {
                        self.appDelegate.myPlaceTempDictionary = (jsonDic).mutableCopy() as! NSMutableDictionary
                        showContractVC()
                    }
                }
                func handleForQLDSARegion()
                {
                    if let jsonDic = json as? [String: Any]
                    {
                        #if DEDEBUG
                        print("contract details--->:\(jsonDic)")
                        #endif
                        self.myPlaceContractDetails = nil
                        self.myPlaceContractDetails = MyPlaceContractDetails(jsonDic)
                    }
                    showContractVC()
                }
                selectedJobNumberRegion == .OLD ? handleForVICRegion() : handleForQLDSARegion()
            }, errorBlock: { (error, isJson) in
                //
            })
        }else
        {
            showContractVC()
        }
      
       
    }/**
     GET service for All Photos in MY Place
     
     - parameter data:
     */
    func getMyPlacePhotosDetails() {
       // ServiceSessionMyPlace.sharedInstance.myDelegate = self
      //  ServiceSessionMyPlace.sharedInstance.serviceConnection("GET", url: NSString(format: "") as String, postBodyDictionary: ["ConstructionID":constructionID], serviceModule:"GetMyPlacePhotosDetails")
    }
    /**
     GET service for Documents in MY Place
     
     - parameter data:
     */
    func getMyPlaceDocumentDetails() {
        //ServiceSessionMyPlace.sharedInstance.myDelegate = self
      //  ServiceSessionMyPlace.sharedInstance.serviceConnection("GET", url: NSString(format: "") as String, postBodyDictionary: ["ConstructionID":constructionID,"OfficeID":officeID], serviceModule:"GetMyPlaceDocumentDetails")
        if documentTempArray == nil
        {
           
            MyPlaceServiceSession.shared.callToGetDataFromServer(myPlaceDocumentsDetailsURLString(), successBlock: { (json,response) in
               
                if let jsonArray = json as? NSArray
                {
                    self.documentTempArray = ((jsonArray).mutableCopy() as! NSMutableArray)
                    self.performSegue(withIdentifier: "showDocumentsVC", sender: nil)
                }
            }, errorBlock: { (error, isJson) in
                //
            })
        }else
        {
            self.performSegue(withIdentifier: "showDocumentsVC", sender: nil)
        }
       
    }
    /**
     GET service for Financial details in MY Place
     
     - parameter data:
     */
    func getMyPlaceFinanceDetails() {
        //ServiceSessionMyPlace.sharedInstance.myDelegate = self
       // ServiceSessionMyPlace.sharedInstance.serviceConnection("GET", url: NSString(format: "") as String, postBodyDictionary: ["FinancialID":jobID], serviceModule:"GetMyPlaceFinanceDetails")
    
        if financeTempDictionary == nil
        {
           callLogoutService(3)
        }else
        {
            showFinanceVC()
        }
    }
    func callLogoutService(_ index: Int)
    {
        if !ServiceSession.shared.checkNetAvailability()
        {
            return
        }
        let logoutURL = "\(getMyPlaceURL())login/logout/"
        
        var urlRequest = URLRequest(url: URL(string: logoutURL)!)
        urlRequest.httpMethod = kGet
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
           // print(data,response,error)
            if error != nil
            {
                #if DEDEBUG
                print("fail to Logout")
                #endif
                return
            }
            if let httpResponse = response as? HTTPURLResponse
            {
                #if DEDEBUG
                print("--->",httpResponse.statusCode)
                #endif
                DispatchQueue.main.async {
                    if httpResponse.statusCode == 200
                    {
                        //sucess
//                        func callLoginService()
//                        {
//                            guard  let myPlaceDetails = self.appDelegate.currentUser?.userDetailsArray?[0].myPlaceDetailsArray[0] else {return }
//                            self.callAndGetMyPlaceLogin(myPlaceDetails)
//                        }
//                        self.isForLoggedInService ? callLoginService() : self.callGetLogedSericeForFinance()
//                        self.isForLoggedInService = false
                        
                        self.callGetLogedSericeForFinance(index)
                        
                        
                    }
                }
            }
        }).resume()
    }
   
    func callGetLogedSericeForFinance(_ index: Int)
    {
        guard  let myPlaceDetails = self.appDelegate.currentUser?.userDetailsArray?[0].myPlaceDetailsArray[0] else {return }
        let region = myPlaceDetails.region ?? ""
        let jobNumber = myPlaceDetails.jobNumber ?? ""
        let password = myPlaceDetails.password ?? ""
        let userName = myPlaceDetails.userName ?? ""
        // ServiceSessionMyPlace.sharedInstance.serviceConnection("POST", url: url, postBodyDictionary: ["Region": region, "JobNumber":jobNumber, "UserName":userName, "Password":password], serviceModule:"PropertyStatusService")
        let postDic =  ["Region": region, "JobNumber":jobNumber, "UserName":userName, "Password":password]
        //callMyPlaceLoginServie(myPlaceDetails)
        let url = URL(string: checkUserLogin())
        var urlRequest = URLRequest(url: url!)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.httpMethod = kPost
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: postDic, options:[])
        }
        catch {
            #if DEDEBUG
            print("JSON serialization failed:  \(error)")
            #endif
        }
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if error != nil
            {
                #if DEDEBUG
                print("fail to Logout")
                #endif
                return
            }
            if let strData = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            {
                DispatchQueue.main.async {
                    if strData == "true"
                    {
                        //  self.getMyPlaceLoggedinUser()
                        ServiceSession.shared.callToGetDataFromServerWithGivenURLString(getLoggedInUser(), withactivity: true, completionHandler: { (json) in
                            if let jsonDic = json as? [String: Any]
                            {
                                let myPlaceStatusDetails = MyPlaceStatusDetails(dic: jsonDic)
                                self.myPlaceRegion = myPlaceStatusDetails.region
                                self.appDelegate.myPlaceStatusDetails = myPlaceStatusDetails
                                
                                if index == 3 {
                                    self.callToGetFinanceDetails()
                                }
                                
                                if index == 4 {
                                    self.callToBurbank()
                                }
                                
                            }
                        })
                        
                    }
                }
                
            }
        }).resume()
    }
    func callToGetFinanceDetails()
    {
        let financeURLString = "\(getMyPlaceURL())finance/GetFinance?financialTicketId=\(self.appDelegate.myPlaceStatusDetails?.jobNumber ?? "")"
//        let financeURLString = "\(getMyPlaceURL(isCon tactUs: true))contact/GetContactDetails?jobNumber=\(self.appDelegate.myPlaceStatusDetails?.jobNumber ?? "")"

        #if DEDEBUG
        print("FinanceDetailsURL URL-->\(financeURLString)")
        #endif
        
        ServiceSession.shared.callToGetDataFromServerWithGivenURLString(financeURLString, withactivity: true) { (json) in
            if let jsonDic = json as? NSDictionary
            {
                self.financeTempDictionary = ((jsonDic).mutableCopy() as! NSMutableDictionary)
                self.showFinanceVC()
            }
        }

    }
    
    
    func callToBurbank()
    {
//        let financeURLString = "\(getMyPlaceURL())contact/GetContactDetails?jobNumber=\(self.appDelegate.myPlaceStatusDetails?.jobNumber ?? "")"
//        //        let financeURLString = "\(getMyPlaceURL(isContactUs: true))contact/GetContactDetails?jobNumber=\(self.appDelegate.myPlaceStatusDetails?.jobNumber ?? "")"
//
//        #if DEDEBUG
//        print("FinanceDetailsURL URL-->\(financeURLString)")
//        #endif
//
//        #if DEDEBUG
//        //print(clientInfoForContract(jobNumber))
//        #endif
        
        if appDelegate.currentUser?.userDetailsArray?.count == 0 {
            jobNumberBackGroundView.alpha = 0
            return
        }
        
        let jobNumberObj = getJobNumber()
        
        ServiceSession.shared.callToGetDataFromServerWithGivenURLString(clientInfoForContract((jobNumberObj == "" ? self.appDelegate.myPlaceStatusDetails?.jobNumber ?? jobNumberObj : jobNumberObj)), withactivity: true, completionHandler: { (json) in
            if let jsonDic =  json as? [String: Any]
            {
                #if DEDEBUG
                print(jsonDic)
                #endif
                
                self.appDelegate.jobContacts = JobContacts(jsonDic)
                
                self.passingSupportHelp()
            }
        })
        
        /*
         ServiceSession.shared.callToGetDataFromServerWithGivenURLString(financeURLString, withactivity: true) { (json) in
         if let jsonDic = json as? NSDictionary
         {
         
         #if DEDEBUG
         print(jsonDic)
         #endif
         
         self.support_Help_View.isHidden = false
         
         self.jobNoLabel.text = "SUPPORT / HELP - JOB NO : \(self.appDelegate.myPlaceStatusDetails?.jobNumber ?? "")"
         
         self.nameLabel.text = "Name : N/A"
         self.designationLabel.text = "Designation : N/A"
         self.emailLabel.text = "Email ID : N/A"
         self.mobileNoLabel.text = "Mobile No : N/A"
         
         if let nameText = jsonDic["ContactPerson"] as? String {
         self.nameLabel.text = nameText
         }
         
         if let designationText = jsonDic["Designation"] as? String {
         self.designationLabel.text = designationText
         }
         
         if let emailText = jsonDic["Email"] as? String {
         self.emailLabel.text = emailText
         }
         
         if let mobileNoText = jsonDic["Mobile"] as? String {
         self.mobileNoLabel.text = mobileNoText
         }
         
         }
         }
         
         */
        
    }
    
    func getJobNumber() -> String {
        
        let userDetails = appDelegate.currentUser?.userDetailsArray?[0]
        let myPlaceDetails = userDetails?.myPlaceDetailsArray[0]
        var jobNumberObj = ""
        
        if let jobNumber = myPlaceDetails?.jobNumber {
            jobNumberObj = jobNumber
        }
        
        return jobNumberObj
    }
    
    func passingSupportHelp() {
        
        self.support_Help_View.isHidden = false
        
        let jobNumberObj = getJobNumber()
        
        self.jobNoLabel.text = "SUPPORT / HELP - JOB NO : \((jobNumberObj == "" ? self.appDelegate.myPlaceStatusDetails?.jobNumber ?? jobNumberObj : jobNumberObj))"
        
        self.nameLabel.text = "Name : N/A"
        self.designationLabel.text = "Designation : N/A"
        self.emailLabel.text = "Email ID : N/A"
        self.mobileNoLabel.text = "Mobile No : N/A"
        
        self.nameLabel.text = self.appDelegate.jobContacts?.cro
        self.designationLabel.text = "New Home Coordinator"
        self.emailLabel.text = self.appDelegate.jobContacts?.croEmail
        self.mobileNoLabel.text = self.appDelegate.jobContacts?.croPhone
        
    }
    
    @IBAction func callTapped(_ sender: UIButton) {
        
        
        CodeManager.sharedInstance.sendScreenName(dashboard_supporthelp_call_button_touch)
        
        
        if self.mobileNoLabel.text == "" || self.mobileNoLabel.text == "Mobile No : N/A" {
            return
        }
        
        let number = self.mobileNoLabel.text?.replacingOccurrences(of: " ", with: "")
        let removeSpacesInNumber = Int((number?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""))
        guard let url = URL(string: "tel://+61\(removeSpacesInNumber!)") ?? URL(string: "") else { AlertManager.sharedInstance.showAlert(alertMessage: "Your device not supported to make a call.", title: "")
            return }
        // check whether device is supported to call or not
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        else {
            
            AlertManager.sharedInstance.showAlert(alertMessage: "Your device not supported to make a calls.", title: "")
        }

    }
    
    @IBAction func emailTapped(_ sender: UIButton) {
        
        CodeManager.sharedInstance.sendScreenName(dashboard_supporthelp_email_button_touch)
        
        
        if self.emailLabel.text == "" || self.emailLabel.text == "Email ID : N/A" {
            
            showToast("Email is empty", self)
            
            return
        }
        
        showMailOption(to: self.emailLabel.text!)

    }
    
    
    
    func configureMailComposer() -> MFMailComposeViewController{
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients([self.emailLabel.text!])
        mailComposeVC.setSubject("MyPlace - \((appDelegate.currentUser?.userDetailsArray?[0].myPlaceDetailsArray[0].jobNumber)!) - \(fillUserName1())")
        mailComposeVC.setMessageBody("\n\n\n * Kindly do not change the subject to track your queries!", isHTML: false)
        return mailComposeVC
    }
    
//    private func createEmailUrl(to: String, subject: String, body: String) -> URL? {
//        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
//        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
//
//        let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
//        let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
//        let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
//        let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
//        let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
//
//        if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
//            return outlookUrl
//        }
//        else if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
//            return gmailUrl
//        } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
//            return yahooMail
//        } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
//            return sparkUrl
//        }
//
//        return defaultUrl
//    }
//
//    func configureMailComposer() -> MFMailComposeViewController{
//        let mailComposeVC = MFMailComposeViewController()
//        mailComposeVC.mailComposeDelegate = self
//        mailComposeVC.setToRecipients([self.emailLabel.text!])
//        mailComposeVC.setSubject("")
//        mailComposeVC.setMessageBody("", isHTML: false)
//        return mailComposeVC
//    }
//
//    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//        controller.dismiss(animated: true)
//    }
    
    func showFinanceVC()
    {
        self.performSegue(withIdentifier: "showFinanceVC", sender: nil)
    }
}



func showMailOption(to: String) {
        
//    mailComposeVC.setSubject("MyPlace - \((appDelegate.currentUser?.userDetailsArray?[0].myPlaceDetailsArray[0].jobNumber)!) - \(fillUserName1())")

    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    let subject: String! = "MyPlace - \((appDelegate.currentUser?.userDetailsArray?[0].myPlaceDetailsArray[0].jobNumber)!) - \(fillUserName1())"
    
    print(subject!)
    
    let body = "\n\n\n * Kindly do not change the subject to track your queries!"

    let alertVC = UIAlertController(title: "", message: "Choose Email", preferredStyle: .actionSheet)
    alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    alertVC.addAction(UIAlertAction(title: "Mail", style: .default, handler: { (mailAction) in
        let openURL = "mailto:\(to)?subject=\(subject!)&body=\(body)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        openSelectedMail(emailUrl: URL(string: openURL!)!,emailType: "Mail")
    }))
    alertVC.addAction(UIAlertAction(title: "Gmail", style: .default, handler: { (gmailAction) in
        let openURL = "googlegmail://co?to:\(to)&subject=\(subject!)&body=\(body)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

        openSelectedMail(emailUrl: URL(string: openURL!)!,emailType: "Gmail App")
    }))
    alertVC.addAction(UIAlertAction(title: "Outlook", style: .default, handler: { (outboxAction) in
        let openURL = "ms-outlook://compose?to:\(to)&subject=\(subject!)&body=\(body)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        openSelectedMail(emailUrl: URL(string: openURL!)!,emailType: "Outlook App")
    }))
    
    kWindow.rootViewController?.present(alertVC, animated: true, completion: nil)
    
}

func fillUserName1() -> String {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    let user = appDelegate.currentUser
    if let  userName = (user?.userDetailsArray?[0].fullName)?.capitalized
    {
        return String(format: "%@", userName)
        
    }
    
    return ""
}


func openSelectedMail(emailUrl: URL,emailType: String) {
    
    if UIApplication.shared.canOpenURL(emailUrl) {
        if #available(iOS 10, *) {
            UIApplication.shared.open(emailUrl, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(emailUrl)
        }
    }
    else {
        AlertManager.sharedInstance.showAlert(alertMessage: emailType + " not configured in your device", title: "")
    }
}
    


