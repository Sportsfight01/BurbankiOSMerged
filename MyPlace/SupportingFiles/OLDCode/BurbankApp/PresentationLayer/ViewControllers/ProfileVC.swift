//
//  ProfileVC.swift
//  BurbankApp
//
//  Created by Mohan Kumar on 16/12/16.
//  Copyright © 2016 DMSS. All rights reserved.
//

import UIKit

/// Profile view dismiss protocol for hiding view in dashboard
protocol profileScreenProtocol {
    
    func profileScreenDismissed()
    
}

class ProfileVC: BurbankAppVC {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var delegate: profileScreenProtocol?
    
    @IBOutlet weak var firstNameTextField : UITextField!
    @IBOutlet weak var lastNameTextField : UITextField!
    @IBOutlet weak var mobileTextField : UITextField!
    var myDelegate: MyPlaceDashBoardVC?
    
    ///MArk : - View life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        fillUserData()
    }
    func fillUserData()
    {
        let userDetails = appDelegate.currentUser?.userDetailsArray?[0]
        guard let firstName = userDetails?.firstName else {
            return
        }
        firstNameTextField.text = firstName
        if let lastName = userDetails?.lastName
        {
            lastNameTextField.text = lastName
        }
        if let mobile = userDetails?.mobile
        {
            mobileTextField.text = mobile
        }
        
       
        

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Method for skip button action
    @IBAction func skipTapped(sender: AnyObject) {
        
        //self.dismiss(animated: true, completion: nil)
        
        self.dismiss(animated: false, completion: {()->Void in
            self.delegate?.profileScreenDismissed()
        });
    }
    
    /// TextField Delegate methods
    ///
    /// - Parameter textField: textField
    /// - Returns: bool value
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    /// TextField Delegate methods
    ///
    /// - Parameters:
    ///   - textField: replacing characters in range
    ///   - range: range
    ///   - string: changing string
    /// - Returns: bool value
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newString : NSString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
        
        // Allow Numbers, () parenthesis, +
        if textField == mobileTextField {
            
            if newString.length <= 9 || newString.length >= 13 {
                return false
            }
            
            let aSet = NSCharacterSet(charactersIn:"0123456789()+ ").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            return string == numberFiltered
        }
        
        // LENGTH LIMIT FIRSTNAME AND LASTNAME == 50 Characters
        if textField == firstNameTextField || textField == lastNameTextField {
            if newString.length > 50 {
                return false
            }
        }
        
        return true
    }
    
    /// Method for save button action
    @IBAction func saveButtonTapped(sender : AnyObject) {
        
        if firstNameTextField.text == "" {
            AlertManager.sharedInstance.alert("Please enter first name")
        }
        else if ((firstNameTextField.text)! as NSString).length > 20 {
            AlertManager.sharedInstance.alert("First name should contain 20 characters")
        }
        else if lastNameTextField.text == "" {
            AlertManager.sharedInstance.alert("Please enter last name")
        }
        else if ((lastNameTextField.text)! as NSString).length > 20 {
            AlertManager.sharedInstance.alert("Last name should contain 20 characters")
        }
        else if mobileTextField.text == "" {
            AlertManager.sharedInstance.alert("Please enter phone number")
        }
        else if ((mobileTextField.text)! as NSString).length < 10 {
            
            AlertManager.sharedInstance.alert("Phone number should contain minimum 10 digits")
        }else if ((mobileTextField.text)! as NSString).length >= 14 {
            
            AlertManager.sharedInstance.alert("Phone number should contain maximum 13 digits")
        }
        else
        {
            let button = sender as! UIButton
            button.backgroundColor = UIColor(red: 224/255, green: 128/255, blue: 31/255, alpha: 1)
            button.setTitleColor(UIColor.white, for: .normal)
            button.borderColor = UIColor.white
            button.isEnabled = false
            postDataToServerForUpdatingProfile()
        }
    }
    
    /// posting data to server for updating profile details
    func postDataToServerForUpdatingProfile() {
    
        let userDetails = appDelegate.currentUser?.userDetailsArray?[0]
        let id = userDetails?.id
        let email = userDetails?.primaryEmail
        let firstName = firstNameTextField.text
        let lastName = lastNameTextField.text
        let mobile = mobileTextField.text
        let region = userDetails?.region
        let postDic: NSDictionary = ["Id": id,"Email": email,"FirstName":firstName,"LastName":lastName,"Mobile":mobile,"Region": region]
        
        ServiceSession.shared.callToPostDataToServerWithGivenURLString(urlString: updateCentralLoginUserURL, postBodyDictionary: postDic) { (json) in
            
            let jsonDic = json as! NSDictionary
            
            if let status = jsonDic["Status"] as? Bool
            {
                if status == true
                {
                    //Need to Update in Local User
                    self.dismiss(animated: false, completion: {()->Void in
                       
                       //Need to Update in Local User
                        let user = self.appDelegate.currentUser
                        user?.userDetailsArray?[0].firstName = self.firstNameTextField.text
                        user?.userDetailsArray?[0].lastName = self.lastNameTextField.text
                        user?.userDetailsArray?[0].fullName = String(format: "%@ %@",self.firstNameTextField.text!,self.lastNameTextField.text!)
                        user?.userDetailsArray?[0].mobile = self.mobileTextField.text
                        CodeManager.sharedInstance.saveUserInUserDefaults(user!)
                
                        self.myDelegate?.fillUserName()
                        self.myDelegate = nil
                
                        self.delegate?.profileScreenDismissed()
                    });
                }else
                {
                    if let message = jsonDic["Message"] as? String
                    {
                        AlertManager.sharedInstance.showAlert(alertMessage: message, title: "")
                        return
                    }
                }
                
             }
        }

        
    }
    
//    /// Method for storing user details locally.
//    func setUserDetailsLocally()
//    {
//        print("-------->\(firstNameTextField.text)")
//        appDelegate.userDetails?.firstName = firstNameTextField.text
//        print("-------->appDelegate.userDetails?.firstName\(appDelegate.userDetails?.firstName)")
//        appDelegate.userDetails?.lastName = lastNameTextField.text
//        appDelegate.userDetails?.mobile = mobileTextField.text
//    }
    
}
