//
//  ChangePasswordVC.swift
//  BurbankApp
//
//  Created by Naresh Banavath on 05/04/22.
//  Copyright © 2022 DMSS. All rights reserved.
//

import UIKit

class ChangePasswordVC: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var currentPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var passwordLBL: UILabel!
    @IBOutlet weak var changeLBL: UILabel!
    @IBOutlet weak var helpTextLBL: UILabel!
    @IBOutlet weak var confirmPasswordView: UIView!
    @IBOutlet weak var newPasswordView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var emailView: UIView!
    var currentPassword = ""
    /// Mark:- View life cycle methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBarButtons(shouldShowNotification: false)
        // Do any additional setup after loading the view.
        emailTextField.text = appDelegate.enteredEmailOrJob
        handleUISetup()
        fillEmail()
    }
    
    func handleUISetup () {
        
        setAppearanceFor(view: changeLBL, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_SUB_HEADING(size: FONT_30))
        setAppearanceFor(view: passwordLBL, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_SUB_HEADING(size: FONT_30))
        setAppearanceFor(view: helpTextLBL, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_SUB_HEADING(size: FONT_13))
        
        setAppearanceFor(view: emailTextField, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_TEXTFIELD_BODY(size: FONT_13))
        setAppearanceFor(view: newPasswordTextField, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_TEXTFIELD_BODY(size: FONT_13))
        setAppearanceFor(view: currentPasswordTextField, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_TEXTFIELD_BODY(size: FONT_13))
        setAppearanceFor(view: confirmPasswordTextField, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_TEXTFIELD_BODY(size: FONT_13))
        emailView.cardView()
        passwordView.cardView()
        newPasswordView.cardView()
        confirmPasswordView.cardView()
        
        
    }
    func fillEmail () {
        
        self.emailTextField.text = appDelegate.enteredEmailOrJob
        
        if emailTextField.text!.count > 0 {
            self.emailView.isUserInteractionEnabled = false
            self.emailView.backgroundColor = APPCOLORS_3.LightGreyDisabled_BG
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
 
    /// TextField Delegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    /// Method for submit button action.
    @IBAction func submitButtonTapped(sender : AnyObject) {
        
        currentPasswordTextField.text = currentPasswordTextField.text ?? "".trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        newPasswordTextField.text = newPasswordTextField.text ?? "".trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        confirmPasswordTextField.text = confirmPasswordTextField.text ?? "".trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        emailTextField.text = emailTextField.text ?? "".trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        
        if currentPasswordTextField.text == "" {
            AlertManager.sharedInstance.showAlert(alertMessage: "Please enter current password")
        }
        else if currentPasswordTextField.text != currentPassword {
            AlertManager.sharedInstance.showAlert(alertMessage: "Current password is incorrect.")
        }
        else if newPasswordTextField.text == "" {
            AlertManager.sharedInstance.showAlert(alertMessage: "Please enter new password")
        }
        else if (newPasswordTextField.text?.trim().count)! < 6 {
            
            AlertManager.sharedInstance.showAlert(alertMessage: "Please enter minimum 6 characters for new password")
        }
        else if confirmPasswordTextField.text == "" {
            AlertManager.sharedInstance.showAlert(alertMessage: "Please enter confirm password")
        }
        else if newPasswordTextField.text != confirmPasswordTextField.text {
            AlertManager.sharedInstance.showAlert(alertMessage: "New and Confirm Password does not  match")
        }
        else {
            postDataToServerForResetPassword()
        }
        
    }
    
    /// Methoid for resend OTP button action
    @IBAction func resendOTPButtonTapped(sender : AnyObject) {
        
        postDataToServerForForgotPassword()
    }
    
    /// posting data to server for resetting password.
    func postDataToServerForResetPassword() {
        
        let urlString = String(format: "login/UpdatePassword")
        
        ServiceSession.shared.callToPostDataToServer(appendUrlString: urlString, postBodyDictionary: ["Email":emailTextField.text!, "CentralLoginPassword":newPasswordTextField.text!], completionHandler: {(json) in
            
            let jsonDic = json as! NSDictionary
            print(jsonDic)
            
            if let status = jsonDic.object(forKey: "Status") as? Bool
            {
                if status == true
                {
                    // self.performSegue(withIdentifier: "ShowLoginVC", sender: nil)
                    
                    NotificationTypes.deleteNotificationType()
                    CodeManager.sharedInstance.logOutCurrentUser()
                    
                    UserDefaults.standard.set("", forKey: "EnteredEmailOrJob")
                    
                    //                    loadLoginView()
                    
                    //  _ = self.navigationController?.popToRootViewController(animated: true)
                    DispatchQueue.main.async {
                        self.showAlert(message: jsonDic.object(forKey: "Message") as? String ?? somethingWentWrong) { action in
                            let vc = UIStoryboard(name: "MyPlaceLogin", bundle: nil).instantiateInitialViewController()
                            kWindow.rootViewController = vc
                            kWindow.makeKeyAndVisible()
                        }
                    }
                    
                    
                }
                else{
                    
                    AlertManager.sharedInstance.showAlert(alertMessage : jsonDic.object(forKey: "Message") as? String ?? somethingWentWrong)
                }
            }
        })
        
    }
    
    /// posting data to server for checking email id is present or not.
    func postDataToServerForForgotPassword() {
        
        let urlString = String(format: "login/forgotpassword/")
        
        ServiceSession.shared.callToPostDataToServer(appendUrlString: urlString, postBodyDictionary: ["Email":""], completionHandler: {(json) in
            
            //print(jsonDic)
            let jsonDic = json as! NSDictionary
            if let status = jsonDic.object(forKey: "Status") as? Bool
            {
                if status == true
                {
                    AlertManager.sharedInstance.showAlert(alertMessage : jsonDic.object(forKey: "Message") as? String ?? somethingWentWrong)
                    
                }
                else{
                    
                    AlertManager.sharedInstance.showAlert(alertMessage : jsonDic.object(forKey: "Message") as? String ?? somethingWentWrong)
                }
            }
        })
        
    }
    
}
