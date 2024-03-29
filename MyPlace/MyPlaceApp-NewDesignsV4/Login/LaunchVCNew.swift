//
//  LaunchVC.swift
//  MyPlace
//
//  Created by dmss on 30/05/17.
//  Copyright © 2017 dmss. All rights reserved.
//

import UIKit
class LaunchVCNew: BurbankAppVC {
    
    //MARK: - Properties
    @IBOutlet weak var lbSign: UILabel!
    @IBOutlet weak var lbIn: UILabel!
    @IBOutlet weak var lbHint: UILabel!
    @IBOutlet weak var inputFieldContainerView: UIView!
    @IBOutlet weak var tfInputField: UITextField!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnCreate: UIButton!
    
    
    var message = ""
    var isNeedToLoginMyPlace = false
//    override var preferredStatusBarStyle: UIStatusBarStyle
//     {
//         return .default
//     }
    
    //MARK: - ViewLifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        if appDelegate.loginStatus == true
        {
            CodeManager.sharedInstance.handleUserLoginSuccess(user: appDelegate.currentUser!, In: self)

//            self.performSegue(withIdentifier: "showMyPlaceDashboardVC", sender: nil)
            // CodeManager.sharedInstance.callServiceAndUpdateUser()
            return
        }

        handleUISetup()
        btnCreate.isHidden = true
        tfInputField.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        CodeManager.sharedInstance.sendScreenName(landing_screen_loading)
        tfInputField.text = appDelegate.enteredEmailOrJob
        tfInputField.autocorrectionType = .no
        tfInputField.resignFirstResponder()
        
    }
    //MARK: - View
    func handleUISetup () {
                
        setAppearanceFor(view: lbSign, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_SUB_HEADING(size: FONT_30))
        setAppearanceFor(view: lbIn, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_SUB_HEADING(size: FONT_30))
        setAppearanceFor(view: lbHint, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_SUB_HEADING(size: FONT_13))
        
        setAppearanceFor(view: tfInputField, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_TEXTFIELD_BODY(size: FONT_13))
        
        
        setAppearanceFor(view: btnNext, backgroundColor: APPCOLORS_3.Orange_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_SUB_HEADING(size: FONT_15))
        setAppearanceFor(view: btnCreate, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Orange_BG, textFont: FONT_BUTTON_SUB_HEADING(size: FONT_13))
        
        
        let _ = setAttributetitleFor(view: btnCreate, title: "Are you a new user? Create account", rangeStrings: ["Are you a new user?", " Create account"], colors: [APPCOLORS_3.Black_BG, APPCOLORS_3.HeaderFooter_white_BG], fonts: [FONT_LABEL_BODY(size: FONT_13), FONT_BUTTON_SUB_HEADING(size: FONT_13)], alignmentCenter: true)
        
        //New user? Create Account
        inputFieldContainerView.layer.cornerRadius = radius_5
        inputFieldContainerView.cardView()
        btnNext.layer.cornerRadius = radius_5
        
    }
    
    
    
    
    @IBAction func handleBackButtonAction (_ sender: UIButton) {
        
        loadLoginView()
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showMyPlaceDashboardVC"
        {
            let destination = segue.destination as! MyPlaceDashBoardVC
            destination.isFromLaunchVC = true
            
        }else if segue.identifier == "showSetCentralPasswordVC"
        {
            let destination = segue.destination as! SetCentralPasswordVCNew
            if message != "" {
                destination.alertMessage = message
                destination.kPassCode = appDelegate.passcodeStr
            }
        }
    }
    
    // MARK: - Button Actions
    @IBAction func nextButtonTapped(sender: AnyObject?)
    {
        
        CodeManager.sharedInstance.sendScreenName(landing_screen_next_button_touch)
        //Form Validation
        guard tfInputField.text?.trim().count ?? 0 > 0 else {AlertManager.sharedInstance.showAlert(alertMessage : "Please enter email or job number");return}
        
        if let emailText = tfInputField.text
        {
            if (tfInputField.text?.contains("@"))! || (tfInputField.text?.contains("."))!
            {
                if emailText.trim().isValidEmail()
                {
                    let  bodyDict = ["Email":emailText]
                    checkUserExistInServer(emailStr: emailText, body: bodyDict)
                }else
                {
                    AlertManager.sharedInstance.showAlert(alertMessage: "Please enter valid email" )
                    tfInputField.becomeFirstResponder()
                }
            }
            else {
                
                #if DEDEBUG
                print("entered text is not an email")
                #endif
                
                //AlertManager.sharedInstance.alert("Please enter valid email")
                let  bodyDict = ["jobNumber":emailText]
                checkUserExistInServer(emailStr: emailText,body: bodyDict)
            }
            tfInputField.resignFirstResponder()
        }
    }
    
}


extension LaunchVCNew: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        nextButtonTapped(sender: nil)
        return false
    }
}


extension LaunchVCNew {
    
    func checkUserExistInServer(emailStr: String,body: [String: Any]) {
        
        #if DEDEBUG
        print(loginURL)
        #endif
        
        ServiceSession.shared.callToPostDataToServerWithGivenURLString(urlString: loginURL, postBodyDictionary: body as NSDictionary, completionHandler: {(json) in
            
            let jsonDic = json as! NSDictionary
            if let status = jsonDic.object(forKey: "Status") as? Bool {
                
                #if DEDEBUG
                print(jsonDic)
                #endif
                
                appDelegate.hideActivity()
                if status == true {
                    
                    if let resultDic = jsonDic.object(forKey: "Result") as? [String: Any]
                    {
                        
                        let user = User(dic: resultDic)
                        if user.isSuccess == true
                        {
                            appDelegate.currentUser = user
                            self.message = (jsonDic.object(forKey: "Message")as? String)!
                            
                            self.handleUserSignUpOrLoginScenarios(user: user)
                        }else
                        {
                            // For jobnumbers in which email is not mapped but the success is false
                            if user.isCentralLoginUser == false && user.IsEmailNotMapped == true {
                                appDelegate.currentUser = user//Need To Check whethere we need to fill user data here or not
                                self.handleUserSignUpOrLoginScenarios(user: user)
                            }
                            else {
                                AlertManager.sharedInstance.showAlert(alertMessage: (jsonDic["Message"] as? String)!, title: "")
                            }
                        }
                    }
                }
                else {
                    
                    AlertManager.sharedInstance.showAlert(alertMessage: (jsonDic["Message"] as? String)!, title: "")
                    return
                }
                
                
            }
            
        })
        
    }
    private func handleUserSignUpOrLoginScenarios(user: User)
    {
        appDelegate.enteredEmailOrJob = (tfInputField.text ?? "")
        if !isEmail()
        {
            appDelegate.enteredEmailOrJob = appDelegate.enteredEmailOrJob.capitalized
        }
        
        if user.isCentralLoginUser == false
        {
            //Need To SignUp
            appDelegate.passcodeStr = user.passCode!
            
            if user.isNewUser == true
            {
                // User is Brand New User, he dont have any JobNumber with him
                //Redirect user to set Password Screen
               // self.performSegue(withIdentifier: "showSetCentralPasswordVC", sender: nil)
                self.showAlert(message: "Email address is not found. Please contact your New Home Coordinator for assistance.")
                
            }else
            {
                if (user.isMultipleEmails == false && user.isMultipleJobs == false) || (user.isMultipleEmails == false && user.isMultipleJobs == true)
                {
                    if user.IsEmailNotMapped == true {
                        //Job Number is avilable but no mailid is mapped in DB
                        self.performSegue(withIdentifier: "showLoginVC", sender: nil)
                        
                    }else {
                        //One email with one job number or multiple jobs.
                        //It is a most common Scenario. Most of the users comes under this.
                        //Redirect user to set Password Screen
                        self.performSegue(withIdentifier: "showSetCentralPasswordVC", sender: nil)
                        
                    }
                    
                }else
                {
                    //(user.isMultipleEmails == true && user.isMultipleJobs == false) || (user.isMultipleEmails == true && user.isMultipleJobs == true)
                    
                    //user has either mutlipleJobs or mutlipleEmails or both or Mutilple
                    //User has to Navigate to enter jobnumber and Password.
                    //Redirect user to enter job Number and MyPlace Password
                    
                    self.performSegue(withIdentifier: "showLoginVC", sender: nil)
                }
            }
            
        }else
        {
            //Need To Login
            //Redirect to enter central login password.
            self.performSegue(withIdentifier: "showLoginVC", sender: nil)
        }
    }
}

