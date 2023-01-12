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
        
        var currentPassword = ""
        /// Mark:- View life cycle methods.
        override func viewDidLoad() {
            super.viewDidLoad()
            self.setupNavigationBarButtons(title: "", backButton: true, notificationIcon: false)
            // Do any additional setup after loading the view.
            emailTextField.text = appDelegate.enteredEmailOrJob
        }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
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
            
            let urlString = String(format: "login/updatepassword/")
            
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
                                self.appDelegate.window?.rootViewController = vc
                                self.appDelegate.window?.makeKeyAndVisible()
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
