//
//  CreateAccountVC.swift
//  MyPlace
//
//  Created by Sreekanth tadi on 18/03/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {
    
    @IBOutlet weak var btnIcon: UIButton!
    
    
    @IBOutlet weak var labelSign: UILabel!
    @IBOutlet weak var labelIn: UILabel!
    @IBOutlet weak var labelHint: UILabel!
    
    
    @IBOutlet weak var viewLastNameText: UIView!
    @IBOutlet weak var viewFirstNameText : UIView!
    @IBOutlet weak var viewEmailText : UIView!
    @IBOutlet weak var viewNewPasswordText : UIView!
    @IBOutlet weak var viewConfirmPasswordText : UIView!
    
    
    @IBOutlet weak var firstNameTF : UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    
    @IBOutlet weak var emailTF : UITextField!
    @IBOutlet weak var newPasswordTF : UITextField!
    @IBOutlet weak var confirmPasswordTF : UITextField!
    
    
    
    @IBOutlet weak var labelAlready: UILabel!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnCreate: UIButton!
    
    
    
    var createAccountReturn: ((_ user: UserBean) -> Void)?

    
    var user: UserBean!
    
    
    
    //MARK: - ViewLife Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        handleUISetup()
        
        if let userRegi = user {
            
            self.emailTF.text = userRegi.userEmail ?? ""
            
            #if DEDEBUG
            self.firstNameTF.text = "test"
            self.lastNameTF.text = "4036"
            self.newPasswordTF.text = "123456"
            self.confirmPasswordTF.text = "123456"
            #endif

        }
        
        CodeManager.sharedInstance.sendScreenName (burbank_signUp_screen_loading)
        
    }
    

    
    //MARK: - View
    
    func handleUISetup () {
        
        setAppearanceFor(view: view, backgroundColor: AppColors.white)
        
        setAppearanceFor(view: labelSign, backgroundColor: COLOR_CLEAR, textColor: AppColors.black, textFont: FONT_LABEL_SUB_HEADING(size: FONT_30))
        setAppearanceFor(view: labelIn, backgroundColor: COLOR_CLEAR, textColor: AppColors.lightGray, textFont: FONT_LABEL_SUB_HEADING(size: FONT_30))
        setAppearanceFor(view: labelHint, backgroundColor: COLOR_CLEAR, textColor: AppColors.black, textFont: FONT_LABEL_BODY(size: FONT_13))
        
        setAppearanceFor(view: emailTF, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_TEXTFIELD_BODY(size: FONT_13))
        setAppearanceFor(view: firstNameTF, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_TEXTFIELD_BODY(size: FONT_13))

        setAppearanceFor(view: newPasswordTF, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_TEXTFIELD_BODY(size: FONT_13))
        setAppearanceFor(view: confirmPasswordTF, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_TEXTFIELD_BODY(size: FONT_13))
        
        
        
        setAppearanceFor(view: labelAlready, backgroundColor: COLOR_CLEAR, textColor: AppColors.darkGray, textFont: FONT_LABEL_BODY(size: FONT_13))
        
        setAppearanceFor(view: btnSignIn, backgroundColor: COLOR_CLEAR, textColor: AppColors.darkGray, textFont: FONT_BUTTON_HEADING (size: FONT_14))
        setAppearanceFor(view: btnCreate, backgroundColor: COLOR_ORANGE, textColor: COLOR_WHITE, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_15))
        
//
//        viewEmailText.layer.cornerRadius = radius_5
//        viewFirstNameText.layer.cornerRadius = radius_5
//        viewLastNameText.layer.cornerRadius = radius_5
//        viewNewPasswordText.layer.cornerRadius = radius_5
//        viewConfirmPasswordText.layer.cornerRadius = radius_5
        
        
        let textFieldsArr = [viewEmailText,viewFirstNameText,viewLastNameText,viewLastNameText,viewNewPasswordText,viewConfirmPasswordText]
        textFieldsArr.forEach { view in
          
            view?.layer.cornerRadius = 10.0
            
            view?.layer.shadowColor = UIColor.lightGray.cgColor
            view?.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            view?.layer.shadowRadius = 3.0
            view?.layer.shadowOpacity = 0.5
          //  view?.layer.masksToBounds = true
        }
      
        
      // viewFirstNameText.cardView()
//        viewLastNameText.cardView()
//        viewNewPasswordText.cardView()
//        viewConfirmPasswordText.cardView()
        
        btnCreate.layer.cornerRadius = radius_5
        
    }
    
    
    //MARK: - Button Actions

    @IBAction func handleBackButtonAction (_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func handleSignInButton (_ sender: UIButton) {
        
        CodeManager.sharedInstance.sendScreenName(burbank_signUp_signIn_button_touch)
        
        if let userFacebookID = user?.userFacebookID {
            print(log: userFacebookID)
            self.navigationController?.popViewController(animated: true)
        }else if let userGoogleID = user?.userGoogleID {
            print(log: userGoogleID)
            self.navigationController?.popViewController(animated: true)
        }else {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    @IBAction func createAccountTapped() {
        
        
        CodeManager.sharedInstance.sendScreenName (burbank_signUp_createAccount_button_touch)
        
        
        if firstNameTF.text?.trim() == "" {
                        
            BurbankApp.showAlert("Please enter your name", self)
        }else if lastNameTF.text?.trim() == "" {
            
            BurbankApp.showAlert("Please enter last name", self)
        }else if emailTF.text?.trim() == "" {
            
            BurbankApp.showAlert("Please enter email", self)
        }else if emailTF.text?.trim().isValidEmail() == false {
            
            BurbankApp.showAlert("Please enter valid email id", self)
        }else if newPasswordTF.text?.trim() == "" {
            
            BurbankApp.showAlert("Please enter new password", self)
        }else if (newPasswordTF.text?.trim().count)! < 6 {
            
            BurbankApp.showAlert("Please enter minimum 6 characters for new password", self)
        }else if confirmPasswordTF.text?.trim() == "" {
            
            BurbankApp.showAlert("Please enter confirm password", self)
        }else if confirmPasswordTF.text?.trim() != newPasswordTF.text?.trim() {
            
            BurbankApp.showAlert("New password & Confirm passwords are not matching", self)
        }else {
            
            if let _ = user { }else {
                user = UserBean(dict: [:])
            }
            
            user.userFirstName = firstNameTF.text?.trim()
            user.userLastName = lastNameTF.text?.trim()
            user.userPassword = newPasswordTF.text?.trim()
            user.userEmail = emailTF.text?.trim()
            
            
            LoginDataManagement.shared.createAccount(user) {
                if let created = self.createAccountReturn {
                    created (self.user)
                }
            }
        }
    }
}
    


extension CreateAccountVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField == newPasswordTF || textField == confirmPasswordTF), string == " " {
            
            return false
        }
        return true
    }

    
}




extension CreateAccountVC {
    
    
    func checkEmailExists (_ user: UserBean) {
                
        let _ = Networking.shared.POST_request(url: ServiceAPI.shared.URL_checkUserExists(user.userEmail!), parameters: NSDictionary(), userInfo: nil, success: { (json, response) in
            
            if let result: AnyObject = json {
                
                let result = result as! NSDictionary
                
                if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {
                                        
                    let str = "Email already Exists!!" + "\n" + "Please login or reset password"
                    
                    showToast(str, self)
                    
                }else {

                    LoginDataManagement.shared.createAccount(user) {
                        
                    }
                }
            }else {
                
            }
            
        }, errorblock: { (error, isJSONerror)  in
            
            if isJSONerror {
                
            }else {
                
            }
            
        }, progress: nil)
        
    }
    
    
}
