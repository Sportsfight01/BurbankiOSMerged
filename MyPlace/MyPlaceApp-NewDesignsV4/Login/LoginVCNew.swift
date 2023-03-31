//
//  LoginVC.swift
//  MyPlace
//
//  Created by Mohan Kumar on 05/06/17.
//  Copyright © 2017 dmss. All rights reserved.
//

import UIKit
import LocalAuthentication


//class LoginVC: BasicVC {
    
class LoginVCNew: BurbankAppVC {
    
    @IBOutlet weak var labelEnter: UILabel!
    @IBOutlet weak var labelPassword: UILabel!
    //       @IBOutlet weak var labelHint: UILabel!
    //
    //
    @IBOutlet weak var viewEmailText: UIView!
    @IBOutlet weak var viewPasswordText: UIView!
    //
    //       @IBOutlet weak var txtEmail: UITextField!
    //       @IBOutlet weak var txtPassword: UITextField!
    //
    @IBOutlet weak var btnLogin: UIButton!
    //       @IBOutlet weak var btnForgot: UIButton!
    
    @IBOutlet weak var viewOR: UIView!
    
    
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var jobNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userInfoLabel: UILabel!
    @IBOutlet weak var stackViewHeightConstraint: NSLayoutConstraint!
    //    @IBOutlet weak var fieldsViewVerticalConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var touchIDButton: UIButton!
    @IBOutlet weak var touchIDImageButton: UIButton!
    
    
    @IBOutlet weak var jobNumberBackGroundView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var backGroundStackView: UIStackView!
    var forgotMessage = ""
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //    let pickerView = UIPickerView()
    @IBOutlet weak var labelHint: UILabel!
    
    let yourAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 15),
        .foregroundColor: UIColor.black,
        .underlineStyle: NSUnderlineStyle.single.rawValue]
    
    var pickerDataSource = [""]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        forgotPasswordButton.alpha = 0
        
        touchIDButton.isHidden = true
        touchIDImageButton.isHidden = true
        viewOR.isHidden = true
        handleUISetup()
        updateLoginFields()
        setAsNonEditColour()
        
        //        pickerDataSource = (appDelegate.currentUser?.userDetailsArray?[0].myPlaceDetailsArray.map({$0.jobNumber ?? ""}))!
    }
    
    func handleUISetup () {
        
        setAppearanceFor(view: labelEnter, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_SUB_HEADING(size: FONT_30))
        setAppearanceFor(view: labelPassword, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_SUB_HEADING(size: FONT_30))
        setAppearanceFor(view: userInfoLabel, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_SUB_HEADING(size: FONT_13))
        setAppearanceFor(view: userInfoLabel, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_SUB_HEADING(size: FONT_13))
        setAppearanceFor(view: labelHint, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_SUB_HEADING(size: FONT_13))
        
        setAppearanceFor(view: emailTextField, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_TEXTFIELD_BODY(size: FONT_13))
        setAppearanceFor(view: passwordTextField, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_TEXTFIELD_BODY(size: FONT_13))
        setAppearanceFor(view: jobNumberTextField, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_TEXTFIELD_BODY(size: FONT_13))
        
        
        setAppearanceFor(view: btnLogin, backgroundColor: APPCOLORS_3.Orange_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_SUB_HEADING(size: FONT_15))
        setAppearanceFor(view: forgotPasswordButton, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_BUTTON_SUB_HEADING(size: FONT_13))
        setAppearanceFor(view: touchIDButton, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_SUB_HEADING(size: FONT_13))
        
        viewEmailText.layer.cornerRadius = radius_5
        jobNumberTextField.superview?.layer.cornerRadius = radius_5
        viewPasswordText.layer.cornerRadius = radius_5
        btnLogin.layer.cornerRadius = radius_5
        
        //        jobNumberTextField.inputView = pickerView
        //        pickerView.delegate =  self
        //        pickerView.dataSource = self
        
        viewEmailText.cardView()
        viewPasswordText.cardView()
        jobNumberBackGroundView.cardView()
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        userInfoLabel.isHidden = true
        CodeManager.sharedInstance.sendScreenName(login_screen_loading)
        //        pickerView.reloadAllComponents()
        
    }
    
    func updateLoginFields()
    {
        let user = appDelegate.currentUser
        
        // For showing forgotpassword button when user comes with email. As per satya
        //        if isEmail() {
        forgotPasswordButton.alpha = 1
        //        }else  {
        //            forgotPasswordButton.alpha = 0
        //        }
        
        //        touchIDButton.isHidden = false
        
        //        var touchText = ""
        //        var touchImage: UIImage = UIImage(named: "Ico-Fingerprint")!
        if CodeManager.sharedInstance.biometricType() == .face {
            //            touchText = "Login with Face ID"
            //            touchImage = UIImage(named: "Ico-FaceId")!
        }
        else if CodeManager.sharedInstance.biometricType() == .touch {
            //            touchText = "Login with Touch ID"
            //            touchImage = UIImage(named: "Ico-Fingerprint")!
        }
        else {
            touchIDButton.isHidden = true
            touchIDImageButton.isHidden = true
            viewOR.isHidden = true
        }
        
        //        let attributeString = NSMutableAttributedString(string: touchText,
        //                                                        attributes: yourAttributes)
        //        touchIDButton.setAttributedTitle(attributeString, for: .normal)
        
        //        touchIDButton.setTitle(touchText, for: .normal)
        touchIDButton.setTitle("Login with Touch / Face ID", for: .normal)
        
        //        touchIDButton.setImage(touchImage, for: .normal)
        
        //        Ico-TouchID
        
        if isCentralLoginUser() == false
        {
            // Need to change the text in future in both places, temporary solution by satya
            passwordTextField.placeholder = "Enter Password"
            userInfoLabel.isHidden = false
            userInfoLabel.text = user?.message
            stackViewHeightConstraint.constant = SCREEN_HEIGHT * 0.0616
            
            //            fieldsViewVerticalConstraint.constant = 0
            
            if user?.isMultipleJobs == true && user?.isMultipleEmails == true
            {
                if isEmail()
                {
                    emailTextField.text = appDelegate.enteredEmailOrJob
                    emailTextField.isUserInteractionEnabled = false
                    
                    jobNumberTextField.text = ""
                    jobNumberTextField.placeholder = "Enter JobNumber"
                    jobNumberTextField.isUserInteractionEnabled = true
                }else
                {
                    emailTextField.text = ""
                    emailTextField.placeholder = "Enter Email ID"
                    emailTextField.isUserInteractionEnabled = true
                    
                    jobNumberTextField.text = appDelegate.enteredEmailOrJob
                    jobNumberTextField.isUserInteractionEnabled = false
                }
                
                return
            }
            if (user?.isMultipleJobs == false && user?.isMultipleEmails == true)
            {
                //                jobNumberTextField.text = appDelegate.enteredEmailOrJob
                //                jobNumberTextField.isUserInteractionEnabled = false
                if isEmail()
                {
                    emailTextField.text = appDelegate.enteredEmailOrJob
                    emailTextField.isUserInteractionEnabled = false
                    
                    jobNumberTextField.text = appDelegate.currentUser?.jobNumber
                    jobNumberTextField.isUserInteractionEnabled = false
                }else
                {
                    emailTextField.text = ""
                    emailTextField.placeholder = "Enter Email ID"
                    emailTextField.isUserInteractionEnabled = true
                    
                    jobNumberTextField.text = appDelegate.enteredEmailOrJob
                    jobNumberTextField.isUserInteractionEnabled = false
                }
                return
            }else if (user?.isMultipleJobs == true && user?.isMultipleEmails == false)
            {
                if isEmail()
                {
                    emailTextField.text = appDelegate.enteredEmailOrJob
                    emailTextField.isUserInteractionEnabled = false
                    
                    jobNumberTextField.text = ""
                    jobNumberTextField.placeholder = "Enter JobNumber"
                    jobNumberTextField.isUserInteractionEnabled = true
                    
                }else
                {
                    emailTextField.text = appDelegate.currentUser?.email
                    emailTextField.isUserInteractionEnabled = false
                    
                    jobNumberTextField.text = appDelegate.enteredEmailOrJob
                    jobNumberTextField.isUserInteractionEnabled = false
                }
            }
            // Exclusively for job numbers which are not mapped with email id's. This scenario for Multiple jobs & emails both are false.
            else if user?.IsEmailNotMapped == true {
                
                emailTextField.text = ""
                emailTextField.placeholder = "Enter Email ID"
                emailTextField.isUserInteractionEnabled = true
                
                jobNumberTextField.text = appDelegate.enteredEmailOrJob
                jobNumberTextField.isUserInteractionEnabled = false
            }
            
        }
        else
        {
            emailView.isHidden = true
            
            jobNumberTextField.text = appDelegate.enteredEmailOrJob
            jobNumberTextField.isUserInteractionEnabled = false
            jobNumberBackGroundView.backgroundColor = UIColor.lightGray
            passwordTextField.placeholder = "Enter Password"
            
            userInfoLabel.isHidden = true
            setUpinfoLabelTextForCentralLogin()
            guard let emailOrJob = UserDefaults.standard.object(forKey: "EnteredEmailOrJob") as? String else { return }
            if self.jobNumberTextField.text == emailOrJob
            {
                touchIDButton.isHidden = false
                touchIDImageButton.isHidden = false
                viewOR.isHidden = false
            }else
            {
                touchIDButton.isHidden = true
                touchIDImageButton.isHidden = true
                viewOR.isHidden = true
            }
        }
        
        
        
    }
    func setUpinfoLabelTextForCentralLogin()
    {
        let constant = SCREEN_HEIGHT * 0.0616
        self.view.constraints.forEach { (constraint) in
            if constraint.identifier == "bottomConstraint"
            {
                constraint.constant = constant - 18
            }
        }
    }
    func setAsNonEditColour()
    {
        if emailTextField.isUserInteractionEnabled == false//
        {
            emailView.backgroundColor = UIColor.lightGray
        }
        
        if jobNumberTextField.isUserInteractionEnabled == false
        {
            jobNumberBackGroundView.backgroundColor = UIColor.lightGray
        }
        if isCentralLoginUser() == false
        {
            if isEmail() == false
            {
                backGroundStackView.removeArrangedSubview(emailView)
                backGroundStackView.removeArrangedSubview(jobNumberBackGroundView)
                backGroundStackView.insertArrangedSubview(jobNumberBackGroundView, at: 0)
                backGroundStackView.insertArrangedSubview(emailView, at: 2)
                backGroundStackView.reloadInputViews()
            }
        }
        
    }
    func isCentralLoginUser() -> Bool
    {
        let user = appDelegate.currentUser
        if user?.isCentralLoginUser == true
        {
            return true
        }
        
        return false
    }
    
    @IBAction func handleBackButton(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func loginButtonTapped(sender: AnyObject)
    {
        
        CodeManager.sharedInstance.sendScreenName(login_screen_login_button_touch)
        
        
        emailTextField.text = emailTextField.text ?? "".trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        
        if isCentralLoginUser() == false {
            if emailTextField.text == ""
            {
                if isCentralLoginUser() == false
                {
                    AlertManager.sharedInstance.showAlert(alertMessage: "Plase enter email id", title: "")
                    emailTextField.resignFirstResponder()
                    return
                }
                
            }else if emailTextField.text?.trim().isValidEmail() == false
            {
                AlertManager.sharedInstance.showAlert(alertMessage: "Plase enter valid email id", title: "")
                emailTextField.resignFirstResponder()
                return
            }else if jobNumberTextField.text == ""
            {
                AlertManager.sharedInstance.showAlert(alertMessage: "Please enter job number", title: "")
                jobNumberTextField.resignFirstResponder()
                return
                
            }else if passwordTextField.text == ""
            {
                AlertManager.sharedInstance.showAlert(alertMessage: "Please enter password", title: "")
                passwordTextField.resignFirstResponder()
                return
            }
        }
        if jobNumberTextField.text == ""
        {
            AlertManager.sharedInstance.showAlert(alertMessage: "Please select job number", title: "")
            jobNumberTextField.resignFirstResponder()
            return
            
        }
        if passwordTextField.text == ""
        {
            AlertManager.sharedInstance.showAlert(alertMessage: "Please enter password", title: "")
            passwordTextField.resignFirstResponder()
            return
        }
        
        if isCentralLoginUser()
        {
            handleUserCentralLogin()
        }else
        {
            let user = appDelegate.currentUser
            
            if user?.IsEmailNotMapped == true {
                validateEmailandSendPasscode()
                
            }
            else {
                handleUserMyPlaceLogin()
                
            }
        }
        
    }
    
    func handleUserCentralLogin()
    {
        // let postDic =  ["Email": jobNumberTextField.text!,"CentralLoginPassword": passwordTextField.text!] as! NSDictionary
        
        //Passing only Job number because of multiple Job number coming with email
        let postDic = isEmail() ? ["Email": jobNumberTextField.text!,"CentralLoginPassword": passwordTextField.text!] as NSDictionary : ["jobNumber": jobNumberTextField.text!,"CentralLoginPassword": passwordTextField.text!] as NSDictionary
        
#if DEDEBUG
        print(postDic)
#endif
        
        ServiceSession.shared.callToPostDataToServerWithGivenURLString(urlString: authenticateCentralLoginUserURL, postBodyDictionary: postDic) { (json) in
            let jsonDic = json as! NSDictionary
            
#if DEDEBUG
            print(jsonDic)
#endif
            
            if let status = jsonDic.object(forKey: "Status") as? Bool {
                
                if status == true {
                    if let userDic = jsonDic.object(forKey: "Result") as? [String: Any]
                    {
                        let user = User(dic: userDic)
                        if user.isSuccess == true
                        {
                            // let userID = user.userDetailsArray?[0].id ?? -1
                            CodeManager.sharedInstance.handleUserLoginSuccess(user: user, In: self)
                            
                        }else
                        {
                            if let message = jsonDic["Message"] as? String
                            {
                                AlertManager.sharedInstance.showAlert(alertMessage: message, title: "")
                                self.passwordTextField.becomeFirstResponder()
                                return
                            }
                        }
                    }
                }
                else
                {
                    if let message = jsonDic["Message"] as? String
                    {
                        AlertManager.sharedInstance.showAlert(alertMessage: message, title: "")
                    }
                }
            }else
            {
                if let message = jsonDic["Message"] as? String
                {
                    AlertManager.sharedInstance.showAlert(alertMessage: message, title: "")
                }
            }
        }
    }
    
    func handleUserMyPlaceLogin()
    {
        
        let postDic = ["Email":emailTextField.text!,
                       "JobNumber":jobNumberTextField.text!,
                       "MyPlacePassword":passwordTextField.text!,
                       "IsMultipleEmails": (appDelegate.currentUser?.isMultipleEmails)!,
                       "IsMultipleJobs": (appDelegate.currentUser?.isMultipleJobs)!] as [String : Any]
        
        ServiceSession.shared.callToPostDataToServerWithGivenURLString(urlString: validateMyPlaceURL, postBodyDictionary: postDic as NSDictionary, completionHandler: { (json) in
            let jsonDic = json as! NSDictionary
            if let status = jsonDic.object(forKey: "Status") as? Bool {
                
#if DEDEBUG
                print(jsonDic)
#endif
                
                if status == true {
                    if let userDic = jsonDic.object(forKey: "Result") as? [String: Any]
                    {
                        let user = User(dic: userDic)
                        if user.isSuccess  == true
                        {
                            //need to change,it's may cause error in future for corrupt current user object data
                            self.appDelegate.currentUser = user
                            
                            self.appDelegate.passcodeStr = user.passCode!
                            
                            //Entered Email is already Registered in Central DB, so we need to direclt allow user to dashboard
                            if user.isCentralLoginUser == true
                            {
                                CodeManager.sharedInstance.handleUserLoginSuccess(user: user, In: self)
                            }else
                            {
                                self.performSegue(withIdentifier: "showSetCentralPasswordVC", sender: nil)
                            }
                        }else
                        {
                            if let message = userDic["Message"] as? String
                            {
                                AlertManager.sharedInstance.showAlert(alertMessage: message, title: "")
                                return
                            }
                            
                        }
                        
                    }
                }
            }else
            {
                if let message = jsonDic["Message"] as? String
                {
                    AlertManager.sharedInstance.showAlert(alertMessage: message, title: "")
                }
            }
        })
        
        
    }
    func validateEmailandSendPasscode() {
        
        let postDic = ["Email":emailTextField.text!,
                       "JobNumber":jobNumberTextField.text!,
                       "MyPlacePassword":passwordTextField.text!,
                       "IsMultipleEmails": (appDelegate.currentUser?.isMultipleEmails)!,
                       "IsMultipleJobs": (appDelegate.currentUser?.isMultipleJobs)!,
                       "IsEmailNotMapped":(appDelegate.currentUser?.IsEmailNotMapped)!] as [String : Any]
        
        ServiceSession.shared.callToPostDataToServerWithGivenURLString(urlString: validateEmailSendPassCodeURL, postBodyDictionary: postDic as NSDictionary, completionHandler: { (json) in
            let jsonDic = json as! NSDictionary
            if let status = jsonDic.object(forKey: "Status") as? Bool {
                
#if DEDEBUG
                print(jsonDic)
#endif
                
                if status == true {
                    if let userDic = jsonDic.object(forKey: "Result") as? [String: Any]
                    {
                        let user = User(dic: userDic)
                        if user.isSuccess  == true
                        {
                            self.appDelegate.currentUser = user//need to change,it's may cause error in future for corrupt current user object data
                            
                            self.appDelegate.passcodeStr = user.passCode!
                            
                            if user.isCentralLoginUser == true//Entered Email is already Registered in Central DB, so we need to direclt allow user to dashboard
                            {
                                CodeManager.sharedInstance.handleUserLoginSuccess(user: user, In: self)
                            }else
                            {
                                self.performSegue(withIdentifier: "showSetCentralPasswordVC", sender: nil)
                            }
                            
                        }else
                        {
                            if let message = userDic["Message"] as? String
                            {
                                AlertManager.sharedInstance.showAlert(alertMessage: message, title: "")
                                return
                            }else
                            {
                                AlertManager.sharedInstance.showAlert(alertMessage: "unknown error", title: "")
                                return
                            }
                            
                        }
                        
                    }
                    // self.showSignUpView()
                    
                    
                }
            }
        })
    }
    var isForgotPasswordTapped = false
    
    @IBAction func forgotPasswordTapped(Sender: AnyObject) {
        
        
        CodeManager.sharedInstance.sendScreenName(login_screen_forgot_password_button_touch)
        
        if isEmail() == false{
            self.performSegue(withIdentifier: "showValidatedEmail", sender: nil)
        }else{
            passwordTextField.resignFirstResponder()
            if isCentralLoginUser()
            {
                
                //                let postDic = ["Email":jobNumberTextField.text!,
                //                               "JobNumber":""] as [String : Any]
                
                let name = appDelegate.currentUser?.userDetailsArray?[0].firstName ?? ""
                let primaryEmail = appDelegate.currentUser?.jobNumber ?? ""
                
                let postDic = ["Email":jobNumberTextField.text ?? "",
                               "Name": name ,
                               "JobNumber":primaryEmail ] as [String : Any]
                
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
                                    self.appDelegate.currentUser = user//need to change,it's may cause error in future for corrupt current user object data
                                    
                                    self.appDelegate.passcodeStr = user.passCode!
                                    
                                    self.forgotMessage = message!
                                    self.isForgotPasswordTapped = true
                                    self.performSegue(withIdentifier: "showSetCentralPasswordVC", sender: nil)
                                }else {
                                    AlertManager.sharedInstance.showAlert(alertMessage: message!, title: "")
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
    }
    
    @IBAction func touchIDTapped(sender: AnyObject) {
        
        
        CodeManager.sharedInstance.sendScreenName(login_screen_usetouch_id_touch)
        
        
        if touchIDButton.isHidden == false {
            authenticationWithTouchID()
        }
    }
    
    
    // MARK: FINGER PRINT AUTHENTICATION
    func fingerPrintAccess() {
        
        let context = LAContext()
        
        var error: NSError?
        
        if context.canEvaluatePolicy(
            LAPolicy.deviceOwnerAuthentication,
            error: &error) {
            
            
            // Device can use TouchID
            context.evaluatePolicy(
                LAPolicy.deviceOwnerAuthentication,
                localizedReason: "Use TouchID to login",
                reply: {(success, error) in
                    
                    DispatchQueue.main.async(execute: {
                        self.passwordTextField.isUserInteractionEnabled = true
                    })
                    
                    
                    print(success)
                    
                    
                    if error != nil {
                        
                        switch error!._code {
                            
                            /*
                             case LAError.Code.systemCancel.rawValue:
                             self.notifyUser(msg: "Session cancelled", err: error?.localizedDescription)
                             
                             case LAError.Code.authenticationFailed:
                             self.notifyUser(msg: "Session cancelled", err: error?.localizedDescription)
                             
                             
                             case LAError.Code.userCancel.rawValue:
                             self.notifyUser(msg: "Please try again", err: error?.localizedDescription)
                             
                             case LAError.Code.userFallback.rawValue:
                             self.notifyUser(msg: "Authentication", err: "Password option selected")
                             */
                            // Custom code to obtain password here
                        default:
                            print(error?.localizedDescription as Any)
                            
                            // Alert for wrong finger print which exceeds 3 times
                            if error?.localizedDescription == "Application retry limit exceeded."
                            {
                                self.notifyUser(msg: "Authentication failed", err: error?.localizedDescription)
                                
                            }
                            else if error?.localizedDescription == "Biometry is locked out."
                            {
                                self.notifyUser(msg: "Authentication failed", err: error?.localizedDescription)
                                
                            }
                            //self.notifyUser(msg: "Authentication failed", err: error?.localizedDescription)
                        }
                        
                    }else {
                        //self.notifyUser(msg: "Authentication Successful", err: "You now have full access")
                        
                        DispatchQueue.main.async {
                            
                            if let user = self.appDelegate.currentUser
                            {
                                CodeManager.sharedInstance.handleUserLoginSuccess(user: user, In: self)
                            }
                        }
                        
                        
                    }
                })
            
        } else {
            
            self.passwordTextField.isUserInteractionEnabled = true
            
            // Device cannot use TouchID
            switch error!.code{
                
            case LAError.Code.touchIDNotEnrolled.rawValue:
                self.notifyUser(msg: "No TouchID Enrolled", err: "Add a fingerprint (Setting -> TouchID -> Add Finger)")
                
            case LAError.Code.passcodeNotSet.rawValue:
                self.notifyUser(msg: "A passcode has not been set", err: error?.localizedDescription)
                
            default:
#if DEDEBUG
                print(" TouchID not available")
#endif
                // self.notifyUser(msg: "TouchID not available", err: error?.localizedDescription)
            }
        }
    }
    
    
    /// Notifying user regarding error raised in fingerprint authentication
    ///
    /// - Parameters:
    ///   - msg: message description
    ///   - err: error description
    func notifyUser(msg: String, err: String?) {
        
        DispatchQueue.main.async {
            // Perform your async code here
            
            let alert = UIAlertController(title: msg, message: err, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            kWindow.rootViewController!.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "showSetCentralPasswordVC"
        {
            let destination = segue.destination as! SetCentralPasswordVCNew
            destination.myPlacePasswordFromLogin = passwordTextField.text!
            destination.alertMessage = forgotMessage
            if isForgotPasswordTapped
            {
                isForgotPasswordTapped = !isForgotPasswordTapped
                destination.infoMessage = "Forgot Password"
            }
            
            destination.kPassCode = appDelegate.passcodeStr
        }else if segue.identifier == "showValidatedEmail"
        {
            let destination = segue.destination as! ValidateEmailVC
            //           if forgotMessage != "" {
            destination.jobId = jobNumberTextField.text ?? ""
            destination.message = forgotMessage
            //                destination.kPassCode = appDelegate.passcodeStr
            //           }
        }
        
    }
}


//class CenteredButton: UIButton
//{
//    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
//        let rect = super.titleRect(forContentRect: contentRect)
//        
//        return CGRect(x: 0, y: contentRect.height - rect.height + 5,
//                      width: contentRect.width, height: rect.height)
//    }
//    
//    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
//        let rect = super.imageRect(forContentRect: contentRect)
//        let titleRect = self.titleRect(forContentRect: contentRect)
//        
//        return CGRect(x: contentRect.width/2.0 - rect.width/2.0,
//                      y: (contentRect.height - titleRect.height)/2.0 - rect.height/2.0,
//                      width: rect.width, height: rect.height)
//    }
//    
//    override var intrinsicContentSize: CGSize {
//        let size = super.intrinsicContentSize
//        
//        if let image = imageView?.image {
//            var labelHeight: CGFloat = 0.0
//            
//            if let size = titleLabel?.sizeThatFits(CGSize(width: self.contentRect(forBounds: self.bounds).width, height: CGFloat.greatestFiniteMagnitude)) {
//                labelHeight = size.height
//            }
//            
//            return CGSize(width: size.width, height: image.size.height + labelHeight + 5)
//        }
//        
//        return size
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        centerTitleLabel()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        centerTitleLabel()
//    }
//    
//    private func centerTitleLabel() {
//        self.titleLabel?.textAlignment = .center
//    }
//}

extension LoginVCNew {

    func authenticationWithTouchID() {
        let localAuthenticationContext = LAContext()
        localAuthenticationContext.localizedFallbackTitle = "Use Passcode"

        var authError: NSError?
        let reasonString = "To access the secure data"

        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError) {

            localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reasonString) { success, evaluateError in

                DispatchQueue.main.async(execute: {
                    self.passwordTextField.isUserInteractionEnabled = true
                })
                
                if success {

                    //TODO: User authenticated successfully, take appropriate action
                    DispatchQueue.main.async {
                        if let user = self.appDelegate.currentUser {
                            CodeManager.sharedInstance.handleUserLoginSuccess(user: user, In: self)
                        }
                    }
                }
                else {
                    //TODO: User did not authenticate successfully, look at error and take appropriate action
                    guard let error = evaluateError else {
                        return
                    }
//                    print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error._code))
                    self.notifyUser(msg: "", err: self.evaluateAuthenticationPolicyMessageForLA(errorCode: error._code))
                    
                    //TODO: If you have choosen the 'Fallback authentication mechanism selected' (LAError.userFallback). Handle gracefully
                }
            }
        }
        else {

            guard let error = authError else {
                return
            }
            //TODO: Show appropriate alert if biometry/TouchID/FaceID is lockout or not enrolled
//            print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error.code))
            self.notifyUser(msg: "", err: self.evaluateAuthenticationPolicyMessageForLA(errorCode: error.code))
        }
    }

    func evaluatePolicyFailErrorMessageForLA(errorCode: Int) -> String {
        var message = ""
        if #available(iOS 11.0, macOS 10.13, *) {
            switch errorCode {
            case LAError.biometryNotAvailable.rawValue:
                message = "Authentication could not start because the device does not support biometric authentication."

            case LAError.biometryLockout.rawValue:
                message = "Authentication could not continue because the user has been locked out of biometric authentication, due to failing authentication too many times."

            case LAError.biometryNotEnrolled.rawValue:
                message = "Authentication could not start because the user has not enrolled in biometric authentication."

            default:
                message = "Did not find error code on LAError object"
            }
        } else {
            switch errorCode {
            case LAError.touchIDLockout.rawValue:
                message = "Too many failed attempts."

            case LAError.touchIDNotAvailable.rawValue:
                message = "TouchID is not available on the device"

            case LAError.touchIDNotEnrolled.rawValue:
                message = "TouchID is not enrolled on the device"

            default:
                message = "Did not find error code on LAError object"
            }
        }

        return message;
    }

    func evaluateAuthenticationPolicyMessageForLA(errorCode: Int) -> String {

        var message = ""

        switch errorCode {

        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"

        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"

        case LAError.invalidContext.rawValue:
            message = "The context is invalid"

        case LAError.notInteractive.rawValue:
            message = "Not interactive"

        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"

        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"

        case LAError.userCancel.rawValue:
            message = "The user did cancel"

        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"

        default:
            message = evaluatePolicyFailErrorMessageForLA(errorCode: errorCode)
        }

        return message
    }
}
