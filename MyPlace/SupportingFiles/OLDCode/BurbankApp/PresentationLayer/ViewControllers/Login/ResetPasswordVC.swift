//
//  ResetPasswordVC.swift
//  BurbankApp
//
//  Created by Mohan Kumar on 20/12/16.
//  Copyright © 2016 DMSS. All rights reserved.
//

import UIKit

/**
 - File:       ResetPasswordVC
 - Contains:   Reset Password view  for setting new password by user.
 */
class ResetPasswordVC: BurbankAppVC {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var currentPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    
    @IBOutlet weak var labelReset: UILabel!
    @IBOutlet weak var labelPassword: UILabel!

    
    @IBOutlet weak var btnSubmit: UIButton!

    
    var currentPassword = ""
    /// Mark:- View life cycle methods.
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        emailTextField.text = appDelegate.enteredEmailOrJob
        
        handleUISetup()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Button Actions
    @IBAction func backButtonTapped(sender: AnyObject) {
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    /// TextField Delegate methods
    ///
    /// - Parameter textField: textField
    /// - Returns: bool value
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
         AlertManager.sharedInstance.alert("Please enter current password")
        }
        else if currentPasswordTextField.text != currentPassword {
            AlertManager.sharedInstance.alert("Current password is incorrect.")
        }
        else if newPasswordTextField.text == "" {
            AlertManager.sharedInstance.alert("Please enter new password")
        }
        else if confirmPasswordTextField.text == "" {
            AlertManager.sharedInstance.alert("Please enter confirm password")
        }
        else if newPasswordTextField.text != confirmPasswordTextField.text {
            AlertManager.sharedInstance.alert("New and Confirm Password does not  match")
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
        
        let urlString = String(format: "login/updatepassword/")
        
        ServiceSession.shared.callToPostDataToServer(appendUrlString: urlString, postBodyDictionary: ["Email":emailTextField.text!, "CentralLoginPassword":newPasswordTextField.text!], completionHandler: {(json) in
            
            let jsonDic = json as! NSDictionary
            print(jsonDic)
            
            if let status = jsonDic.object(forKey: "Status") as? Bool
            {
                if status == true
                {
                   // self.performSegue(withIdentifier: "ShowLoginVC", sender: nil)
//                    _ = self.navigationController?.popViewController(animated: true)
                    
                    NotificationTypes.deleteNotificationType()
                    CodeManager.sharedInstance.logOutCurrentUser()
                    
                    UserDefaults.standard.set("", forKey: "EnteredEmailOrJob")

                    loadLoginView()

                    AlertManager.sharedInstance.alert(jsonDic.object(forKey: "Message")! as! String)
                }
                else{
                    
                    AlertManager.sharedInstance.alert(jsonDic.object(forKey: "Message")! as! String)
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
                    AlertManager.sharedInstance.alert(jsonDic.object(forKey: "Message")! as! String)
                    
                }
                else{
                    
                    AlertManager.sharedInstance.alert(jsonDic.object(forKey: "Message")! as! String)
                }
            }
        })
        
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

    
    
    //MARK: - View
    
    func handleUISetup () {
                
        setAppearanceFor(view: labelReset, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_LABEL_HEADING(size: FONT_30))
        setAppearanceFor(view: labelPassword, backgroundColor: COLOR_CLEAR, textColor: COLOR_WHITE, textFont: FONT_LABEL_HEADING(size: FONT_30))
        
        setAppearanceFor(view: emailTextField, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_TEXTFIELD_BODY(size: FONT_13))
        setAppearanceFor(view: currentPasswordTextField, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_TEXTFIELD_BODY(size: FONT_13))
        setAppearanceFor(view: newPasswordTextField, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_TEXTFIELD_BODY(size: FONT_13))
        setAppearanceFor(view: confirmPasswordTextField, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_TEXTFIELD_BODY(size: FONT_13))

        
        setAppearanceFor(view: btnSubmit, backgroundColor: COLOR_BLACK, textColor: COLOR_WHITE, textFont: FONT_BUTTON_SUB_HEADING(size: FONT_15))
        
        
        emailTextField.superview?.layer.cornerRadius = radius_5
        currentPasswordTextField.superview?.layer.cornerRadius = radius_5
        newPasswordTextField.superview?.layer.cornerRadius = radius_5
        confirmPasswordTextField.superview?.layer.cornerRadius = radius_5

        btnSubmit.layer.cornerRadius = radius_5
        
    }
    
    
}
