//
//  SetCentralPasswordVC.swift
//  MyPlace
//
//  Created by Mohan Kumar on 05/06/17.
//  Copyright © 2017 dmss. All rights reserved.
//

import UIKit

//class SetCentralPasswordVC: BasicVC {

class SetCentralPasswordVCNew: BurbankAppVC {

    @IBOutlet weak var emailOrJobTextField: UITextField!
    @IBOutlet weak var passCodeTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
   
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passcodeView: UIView!
    @IBOutlet weak var newPasscodeView: UIView!
    @IBOutlet weak var confirmPasscodeView: UIView!
    @IBOutlet weak var infoTextLabel: UILabel!

    
    @IBOutlet weak var labelCentral: UILabel!
    @IBOutlet weak var labelPassword: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnResend: UIButton!

    
    var kPassCode = ""
    var myPlacePasswordFromLogin = ""
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var isFromResetPassword = false
    
    var alertMessage = ""
    var infoMessage = ""

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        handleUISetup()
        
        if alertMessage != "" {
            BurbankApp.showAlert(alertMessage)
        }
//        if infoMessage != "" {
//            infoTextLabel.text = infoMessage
//            infoMessage = ""
//        }
        checkEmail()
        if infoMessage == "Forgot Password" {
            labelCentral.text = "Forgot"

        }
        infoTextLabel.text = "Passcode will be sent to following Email to reset central login password"
        
    }
    
    @IBAction func passcodeButtonTapped(sender: AnyObject) {
        passCodeTextField.text = kPassCode
    }
    func checkEmail() {
        
        if appDelegate.currentUser?.email != nil {
            emailOrJobTextField.text = appDelegate.currentUser?.email
            emailOrJobTextField.isUserInteractionEnabled = false
            emailView.backgroundColor = UIColor.lightGray
        }
        else {
            emailOrJobTextField.isUserInteractionEnabled = true
            emailOrJobTextField.becomeFirstResponder()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitButtonTapped(sender: AnyObject) {
        
        emailOrJobTextField.text = emailOrJobTextField.text ?? "".trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        passCodeTextField.text = passCodeTextField.text ?? "".trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        passwordTextField.text = passwordTextField.text ?? "".trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        confirmPasswordTextField.text = confirmPasswordTextField.text ?? "".trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if emailOrJobTextField.text == ""
        {
            BurbankApp.showAlert("Please enter email id ")
            emailOrJobTextField.becomeFirstResponder()
            return
        }else if emailOrJobTextField.text?.trim().isValidEmail() == false
        {
            BurbankApp.showAlert("Please enter valid email id")
            emailOrJobTextField.becomeFirstResponder()
            return
        }else if passCodeTextField.text == ""
        {
            BurbankApp.showAlert("Please enter passcode")
            passCodeTextField.becomeFirstResponder()
            return
        }else if passwordTextField.text == ""
        {
            BurbankApp.showAlert("Please enter password")
            passCodeTextField.becomeFirstResponder()
            return
        }else if confirmPasswordTextField.text == ""
        {
            BurbankApp.showAlert("Please enter confirm password")
            confirmPasswordTextField.becomeFirstResponder()
            return
        }else if passwordTextField.text != confirmPasswordTextField.text
        {
            BurbankApp.showAlert("Password and Confirm Password are not same")
            confirmPasswordTextField.becomeFirstResponder()
            return
        }
        postUserEnteredDataToServerToValidate()

    }
    
    func postUserEnteredDataToServerToValidate()
    {
        if appDelegate.currentUser?.isNewUser == true
        {
            if let userEmail = appDelegate.currentUser?.email,let passCode = passCodeTextField.text,let password = passwordTextField.text
            {
                let postDataDic = ["Email":userEmail,"Passcode": passCode,"CentralLoginPassword":password] as NSDictionary
                
                #if DEDEBUG
                print(postDataDic)
                #endif
                
                postUserDateToServer(url: registerUserURL, postDic: postDataDic)
            }
            
        }else
        {
            
            let currentUser = appDelegate.currentUser
            
            // Direct scenario adding new guy
            if currentUser?.isCentralLoginUser == false {
                
            if let userEmail = currentUser?.email,let passCode = passCodeTextField.text,let password = passwordTextField.text,let jobNumber = currentUser?.jobNumber,let isMultipleEmails = currentUser?.isMultipleEmails,let isMutilpleJobNumbers = currentUser?.isMultipleJobs,let isEmailNotMapped = currentUser?.IsEmailNotMapped

            {
                if currentUser?.isMultipleEmails == false //for two cases
                {
                    if isUserHadUserDetails()
                    {
                        if let myPlacePassword = currentUser?.userDetailsArray?[0].myPlaceDetailsArray[0].password
                        {
                            myPlacePasswordFromLogin = myPlacePassword
                        }

                    }else
                    {
                        if let myPlacePassword = currentUser?.myPlacePassword
                        {
                            myPlacePasswordFromLogin = myPlacePassword
                        }
                        
                    }
                    
                }
                let postDataDic = ["Email":userEmail,
                                   "JobNumber":jobNumber,
                                   "MyPlacePassword":myPlacePasswordFromLogin,
                                   "Passcode": passCode,
                                   "CentralLoginPassword" :password,
                    "IsMultipleEmails": isMultipleEmails,
                    "IsMultipleJobs": isMutilpleJobNumbers,
                    "IsEmailNotMapped": isEmailNotMapped] as NSDictionary
                
                postUserDateToServer(url: verifyPasscodeURL, postDic: postDataDic)
            }
        }
                // This scenario if user comes form forgot password
            else {
                if let userEmail = currentUser?.email,let passCode = passCodeTextField.text,let password = passwordTextField.text,let jobNumber = currentUser?.jobNumber {
                    
                let postDataDic = ["Email":userEmail,
                                   "JobNumber":jobNumber,
                                   "Passcode": passCode,
                                   "CentralLoginPassword" :password] as NSDictionary
                
                postUserDateToServer(url: updatePasswordURL, postDic: postDataDic)
                }
            }
        }
    }

    func isUserHadUserDetails() -> Bool
    {
        let user = appDelegate.currentUser
        if user?.userDetailsArray?.count != 0
        {
            return true
        }
        return false
    }
    private func postUserDateToServer(url: String,postDic: NSDictionary)
    {
        ServiceSession.shared.callToPostDataToServerWithGivenURLString(urlString: url, postBodyDictionary: postDic, completionHandler: { (json) in
            //print(json)
            let jsonDic = json as! NSDictionary
            #if DEDEBUG
            print(jsonDic)
            #endif
            
            if let status = jsonDic.object(forKey: "Status") as? Bool {
                
                if status == true
                {
                    
                    if let resultDic = jsonDic.object(forKey: "Result") as? [String: Any]
                    {
                        
                        let user = User(dic: resultDic)
                        if user.isSuccess == true
                        {
                            self.postDataToServerForUpdatingUserProfile(user)
                          
                        }
                        else {
                            if let message = jsonDic.object(forKey: "Message") as? String
                            {
                                BurbankApp.showAlert(message)
                            return
                        }
                        }
                    }
                }else
                {
                    if let message = jsonDic.object(forKey: "Message") as? String
                    {
                        BurbankApp.showAlert(message)
                    }
                }
            }
            
        })
    }
    func postDataToServerForUpdatingUserProfile(_ userObj: User)
    {
        var userDetails: UserDetails?
        
        if (userObj.userDetailsArray?.count ?? 0) > 0 {
            userDetails = userObj.userDetailsArray![0]
        }
        
        let userID = userDetails?.id ?? 0
        let userName = userDetails?.fullName ?? ""
        let emailID = userObj.email ?? ""
        let photoAddedDic = ["Description":"Notification setting for the Site Photos Added","IsActive":true,"IsUserOpted":true,"Name":"Photo Added","NotificationTypeId": 1] as [String : Any]
        let stageCompletedDic = ["Description":"Notification setting for the Site Stage Completion","IsActive":true,"IsUserOpted":true,"Name":"Stage Completion","NotificationTypeId": 2] as [String : Any]
        let stageChangedDic = ["Description":"Notification setting for the Site Stage Completion","IsActive":true,"IsUserOpted":true,"Name":"Stage Change","NotificationTypeId": 3] as [String : Any]
        let notificationArray = [photoAddedDic,stageCompletedDic,stageChangedDic]
        ServiceSession.shared.callToPostDataToServer(appendUrlString: updateProfileURL, postBodyDictionary: ["UserName": userName, "Email": emailID, "UserId": userID, "NotificationTypes": notificationArray], completionHandler: {(json) in
            
            let jsonDic = json as! NSDictionary
            print(jsonDic)
            self.appDelegate.hideActivity()
            if let status = jsonDic.object(forKey: "Status") as? Bool
            {
                
                if status == true
                {
                    //AlertManager.sharedInstance.alert(jsonDic.object(forKey: "Message")! as! String)
                    CodeManager.sharedInstance.handleUserLoginSuccess(user: userObj, In: self)
                     NotificationTypes.updatedSelectedNotificationType()
                    
                }
                else{
                    BurbankApp.showAlert(jsonDic.object(forKey: "Message")! as! String)
                }
            }
        })
        
    }
    @IBAction func resendPasscodeTapped(Sender: AnyObject) {
        
        
//        let postDic = ["Email":(appDelegate.currentUser?.email)!] as [String : Any]
        let name = self.appDelegate.currentUser?.userDetailsArray?[0].firstName ?? ""
        let primaryEmail = self.appDelegate.currentUser?.email ?? ""

        let postDic = ["Email":primaryEmail,
                   "Name": name ,
                   "JobNumber":""] as [String : Any]
        
        ServiceSession.shared.callToPostDataToServerWithGivenURLString(urlString: resendPasscodeURL, postBodyDictionary: postDic as NSDictionary, completionHandler: { (json) in
            let jsonDic = json as! NSDictionary
            if let status = jsonDic.object(forKey: "Status") as? Bool {
                
                #if DEDEBUG
                print(jsonDic)
                #endif
                
                if status == true {
                    if let userDic = jsonDic.object(forKey: "Result") as? [String: Any]
                    {
                        if let message = userDic["Message"] as? String
                        {
                            let user = User(dic: userDic)
                            self.kPassCode = user.passCode ?? ""
                            BurbankApp.showAlert(message)
                            return

                        }
                        else
                        {
                            BurbankApp.showAlert(userDic["Message"] as? String ?? somethingWentWrong)
                                return
                        }
                        
                    }
                }
            }
        })

    }
    
    
    //MARK: - View
    
    @IBAction func handleBackButton(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }

    func handleUISetup () {
                
        setAppearanceFor(view: labelCentral, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_SUB_HEADING(size: FONT_30))
        setAppearanceFor(view: labelPassword, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_SUB_HEADING(size: FONT_30))
        setAppearanceFor(view: infoTextLabel, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_SUB_HEADING(size: FONT_13))
        
        setAppearanceFor(view: emailOrJobTextField, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_TEXTFIELD_BODY(size: FONT_13))
        setAppearanceFor(view: passCodeTextField, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_TEXTFIELD_BODY(size: FONT_13))
        setAppearanceFor(view: passwordTextField, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_TEXTFIELD_BODY(size: FONT_13))
        setAppearanceFor(view: confirmPasswordTextField, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_TEXTFIELD_BODY(size: FONT_13))
        
        
       // infoTextLabel.addCharacterSpacing(kernValue: -0.3)

        
        setAppearanceFor(view: btnSubmit, backgroundColor: APPCOLORS_3.Orange_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_SUB_HEADING(size: FONT_13))
        setAppearanceFor(view: btnResend, backgroundColor: APPCOLORS_3.Orange_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_SUB_HEADING(size: FONT_13))
        
        
        emailOrJobTextField.superview?.layer.cornerRadius = radius_5
        passCodeTextField.superview?.layer.cornerRadius = radius_5
        passwordTextField.superview?.layer.cornerRadius = radius_5
        confirmPasswordTextField.superview?.layer.cornerRadius = radius_5
        
        btnSubmit.layer.cornerRadius = radius_5
        btnResend.layer.cornerRadius = radius_5
        
        emailView.cardView()
        passcodeView.cardView()
        newPasscodeView.cardView()
        confirmPasscodeView.cardView()

    }
    
}
