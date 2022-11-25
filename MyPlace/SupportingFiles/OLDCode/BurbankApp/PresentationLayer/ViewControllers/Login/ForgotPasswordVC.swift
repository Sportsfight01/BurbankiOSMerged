//
//  ForgotPasswordVC.swift
//  BurbankApp
//
//  Created by Mohan Kumar on 20/12/16.
//  Copyright © 2016 DMSS. All rights reserved.
//

import UIKit

/**
 - File:       ForgotPasswordVC
 - Contains:   Forgot Password view  for entering email id by user for creating new password
 */
class ForgotPasswordVC: BurbankAppVC {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var emailTextField: UITextField!

    /// Mark:- View life cycle methods.
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        emailTextField.text = UserDefaults.standard.value(forKey: "EmailID") as! String?
        
        
    }
    
    /// Setting title for the particular view which returns in TOPVC.
    private func setTitle()
    {
        appDelegate.titleString = "Forgot Password"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /// Method for cancel button action
    @IBAction func cancelButtonTapped(sender : AnyObject) {
        _  = self.navigationController?.popViewController(animated: true)
    }
    
    /// TextField Delegate methods
    ///
    /// - Parameter textField: textField
    /// - Returns: bool value
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    /// Method for send button action
    @IBAction func sendButtonTapped(sender : AnyObject) {
        
        emailTextField.text = emailTextField.text ?? "".trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if emailTextField.text == "" {
            AlertManager.sharedInstance.alert("Please enter emailID")
        }
        else {
            postDataToServerForForgotPassword()
            //appDelegate.forgotEmail = emailTextField.text! as NSString
        }
        
    }
    
    /// posting data to server for checking email id is present or not.
    func postDataToServerForForgotPassword() {
        
        let urlString = String(format: "login/forgotpassword/")
        
        ServiceSession.shared.callToPostDataToServer(appendUrlString: urlString, postBodyDictionary: ["Email":emailTextField.text!], completionHandler: {(json) in
            
            let jsonDic = json as! NSDictionary
            print(jsonDic)
            
            if let status = jsonDic.object(forKey: "Status") as? Bool
            {
                if status == true
                {
                    //self.performSegue(withIdentifier: "ShowResetPasswordVC", sender: nil)
                    self.resetPasswordConfirmation()
                }
                else{
                    
                    AlertManager.sharedInstance.alert(jsonDic.object(forKey: "Message")! as! String)
                }
            }
        })
        
    }
    
    /// Method for confirming from user for resetting the password.
    func resetPasswordConfirmation() {
        
        let alert = UIAlertController(title: "", message: "OTP sent to registered Email:- XXXX@gmail.com and Phone :- XXXX0567", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        let yesAction = UIAlertAction(title: "Ok", style: .default, handler: { action -> Void in
            self.performSegue(withIdentifier: "ShowResetPasswordVC", sender: nil)

        })
        alert.addAction(yesAction)
        kWindow.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        setTitle()
    }
 
}
