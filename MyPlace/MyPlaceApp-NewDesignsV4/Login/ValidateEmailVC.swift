//
//  ValidateEmailVC.swift
//  BurbankApp
//
//  Created by Naveen Kourampalli on 17/03/22.
//  Copyright © 2022 Sreekanth tadi. All rights reserved.
//

import UIKit

class ValidateEmailVC: UIViewController {

    //var userSignUp: UserBean?

    
    @IBOutlet weak var btnIcon: UIButton!
    @IBOutlet weak var labelForgot: UILabel!
    @IBOutlet weak var labelPassword: UILabel!
    @IBOutlet weak var labelHint: UILabel!
    @IBOutlet weak var viewText: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnNext: UIButton!
    var message = ""
    var jobId = ""
    var isForgotPasswordTapped = false
    var forgotMessage = " "

    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleUISetup ()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - View
    
    func handleUISetup () {
        
        setAppearanceFor(view: view, backgroundColor: AppColors.white)
        
        setAppearanceFor(view: labelForgot, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_SUB_HEADING(size: FONT_30))
        setAppearanceFor(view: labelPassword, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_SUB_HEADING(size: FONT_30))
        setAppearanceFor(view: labelHint, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_BODY(size: FONT_13))
        
        setAppearanceFor(view: txtEmail, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_TEXTFIELD_BODY(size: FONT_13))
        
        setAppearanceFor(view: viewText, backgroundColor: AppColors.lightGray)
        setAppearanceFor(view: btnNext, backgroundColor: APPCOLORS_3.Orange_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_SUB_HEADING(size: FONT_15))        
        viewText.layer.cornerRadius = radius_5
        btnNext.layer.cornerRadius = radius_5
        viewText.cardView()
        fillEmail()
        
        
    }
    
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
            if forgotMessage != "" {
                destination.alertMessage = forgotMessage
                destination.kPassCode = appDelegate.passcodeStr
            }
        }else if segue.identifier == "showValidatedEmail"
        {
            let destination = segue.destination as! ValidateEmailVC
            if message != "" {
//                destination.alertMessage = message
//                destination.kPassCode = appDelegate.passcodeStr
            }
        }
    }

    
    func fillEmail () {
        
        self.txtEmail.text = appDelegate.currentUser?.userDetailsArray?[0].primaryEmail
        
        if txtEmail.text!.count > 0 {
            self.viewText.isUserInteractionEnabled = false
            self.viewText.backgroundColor = APPCOLORS_3.LightGreyDisabled_BG
            let title = "Registered email assigned to the job number \(jobId)"
           // labelHint.text = title
            setAttributetitleFor(view: labelHint, title: title, rangeStrings: ["Registered email assigned to the job number", jobId], colors: [APPCOLORS_3.Black_BG, APPCOLORS_3.Orange_BG], fonts: [FONT_LABEL_SUB_HEADING(size: FONT_13),FONT_LABEL_SUB_HEADING(size: FONT_13)], alignmentCenter: false)
        }
        else{
            labelHint.text = "Enter registered email assigned to the job number \(jobId)"

        }
    }

    
    @IBAction func handleBackButtonAction (_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func handleNextButtonAction (sender: UIButton) {
        CodeManager.sharedInstance.sendScreenName(landing_screen_next_button_touch)
    
    if txtEmail.text == ""
    {
        AlertManager.sharedInstance.alert("Please enter email or job number")
        return
    }
    
    if let emailText = txtEmail.text
    {
        // Validation for testfield containing white spaces
        let whitespaceSet = NSCharacterSet.whitespaces
        if txtEmail.text?.trimmingCharacters(in: whitespaceSet) == "" {
            AlertManager.sharedInstance.alert("Please enter Valid email or job number")
            return
        }
        
        if (txtEmail.text?.contains("@"))! || (txtEmail.text?.contains("."))!
        {
            if emailText.trim().isValidEmail()
            {
                let  bodyDict = ["Email":emailText]
                checkUserExistInServer(emailStr: emailText, body: bodyDict)
            }else
            {
                AlertManager.sharedInstance.alert("Please enter valid email")
                txtEmail.becomeFirstResponder()
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
        txtEmail.resignFirstResponder()
    }
}



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
                        appDelegate.currentUser = user//Need To Check whethere we need to fill user data here or not
                       // self.message = (jsonDic.object(forKey: "Message")as? String)!
                        self.forgotPasssWord(user: user)
//                        self.handleUserSignUpOrLoginScenarios(user: user)
                    }else
                    {
                        // For jobnumbers in which email is not mapped but the success is false
                        if user.isCentralLoginUser == false && user.IsEmailNotMapped == true {
                            appDelegate.currentUser = user//Need To Check whethere we need to fill user data here or not
                            self.forgotPasssWord(user: user)
//                            self.handleUserSignUpOrLoginScenarios(user: user)
                        }
                        else {
                            AlertManager.sharedInstance.showAlert(alertMessage: (jsonDic["Message"] as? String)!, title: "")
                        }
                    }
                }
            }
            else {
                
                AlertManager.sharedInstance.showAlert(alertMessage: (jsonDic["Message"] as? String ?? ""), title: "")
                return
            }
            
            
        }
        
    })
    
}
   
    func forgotPasssWord(user: User){
        
        
        CodeManager.sharedInstance.sendScreenName(login_screen_forgot_password_button_touch)
        if user.isCentralLoginUser == true
        {
            let name = appDelegate.currentUser?.userDetailsArray?[0].firstName ?? ""
            let primaryEmail = appDelegate.currentUser?.userDetailsArray?[0].primaryEmail ?? ""

        let postDic = ["Email":primaryEmail,
                       "Name": name ,
                       "JobNumber":""] as [String : Any]
        
            
            
        ServiceSession.shared.callToPostDataToServerWithGivenURLString(urlString: forgotPasswordURL, postBodyDictionary: postDic as NSDictionary, completionHandler: { (json) in
            let jsonDic = json as! NSDictionary
            if let status = jsonDic.object(forKey: "Status") as? Bool {
                
                #if DEDEBUG
                print(jsonDic)
                #endif
                let message = jsonDic.object(forKey: "Message")as? String
                if status == true {
//                    if let _ = jsonDic.object(forKey: "Result") as? [String: Any]
//                    {
                        if let userDic = jsonDic.object(forKey: "Result") as? [String: Any]
                        {
                            let user = User(dic: userDic)
                                    if user.isSuccess  == true
                                    {
                                        appDelegate.currentUser = user//need to change,it's may cause error in future for corrupt current user object data
                                        
                                        appDelegate.passcodeStr = user.passCode!

                                        self.forgotMessage = message!
                                        self.isForgotPasswordTapped = true
                                         self.performSegue(withIdentifier: "showSetCentralPasswordVC", sender: nil)
                                    }else {
                                        AlertManager.sharedInstance.showAlert(alertMessage: message ?? "", title: "")
                                        return
                                }
                            }
                        else
                        {
                            AlertManager.sharedInstance.showAlert(alertMessage: message!, title: "")
                            return
                        }
                        
//                    }
                }
            }
        })
        }
        else {
            AlertManager.sharedInstance.showAlert(alertMessage: "Please contact CRO.", title: "")
            return
        }

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ValidateEmailVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
       // handleNextButtonAction(sender: nil)
        return false
    }
}
extension ValidateEmailVC{
    
    private func handleUserSignUpOrLoginScenarios(user: User)
    {
        appDelegate.enteredEmailOrJob = (txtEmail.text ?? "")
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
                showAlert(message: "Email address is not found. Please contact your New Home Coordinator for assistance.")
//                self.performSegue(withIdentifier: "showSetCentralPasswordVC", sender: nil)
                
            }else
            {
                if (user.isMultipleEmails == false && user.isMultipleJobs == false) || (user.isMultipleEmails == false && user.isMultipleJobs == true)
                {
//                    if user.IsEmailNotMapped == true {
//                        //Job Number is avilable but no mailid is mapped in DB
//                        self.performSegue(withIdentifier: "showLoginVC", sender: nil)
//
//                    }else {
                        //One email with one job number or multiple jobs.
                        //It is a most common Scenario. Most of the users comes under this.
                        //Redirect user to set Password Screen
                        self.performSegue(withIdentifier: "showSetCentralPasswordVC", sender: nil)
                        
//                    }
                    
                }else
                {
                    //(user.isMultipleEmails == true && user.isMultipleJobs == false) || (user.isMultipleEmails == true && user.isMultipleJobs == true)
                    
                    //user has either mutlipleJobs or mutlipleEmails or both or Mutilple
                    //User has to Navigate to enter jobnumber and Password.
                    //Redirect user to enter job Number and MyPlace Password
                    
                    self.performSegue(withIdentifier: "showSetCentralPasswordVC", sender: nil)
                }
            }
            
        }else
        {
            //Need To Login
            //Redirect to enter central login password.
            self.performSegue(withIdentifier: "showSetCentralPasswordVC", sender: nil)
        }
    }
}
