//
//  JobNumberVC.swift
//  MyPlace
//
//  Created by Sreekanth tadi on 18/03/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit

class JobNumberVC: UIViewController {
    
    @IBOutlet weak var btnIcon: UIButton!
    
    @IBOutlet weak var labelSign: UILabel!
    @IBOutlet weak var labelIn: UILabel!
    @IBOutlet weak var labelHint: UILabel!
    
    
    @IBOutlet weak var viewText: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnNewUser: UIButton!
    @IBOutlet weak var btnCreate: UIButton!
    
    
    //MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        handleUISetup()
        
        #if DEDEBUG
        txtEmail.text = "sreekanthreddy@gmail.com"
        txtEmail.text = "sreekanth.t.bs@gmail.com"
        txtEmail.text = "test666@gmail.com"
        txtEmail.text = "naveenkaurampallydigitalminds@gmail.com"
        #endif
        
        CodeManager.sharedInstance.sendScreenName(burbank_signIn_password_screen_loading)

    }
    
    
    //MARK: - View
    
    func handleUISetup () {
        
        setAppearanceFor(view: view, backgroundColor: AppColors.white)
        
        setAppearanceFor(view: labelSign, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_SUB_HEADING(size: FONT_30))
        setAppearanceFor(view: labelIn, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_SUB_HEADING(size: FONT_30))
        setAppearanceFor(view: labelHint, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_SUB_HEADING(size: FONT_13))
        
        setAppearanceFor(view: txtEmail, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_TEXTFIELD_BODY(size: FONT_13))
        
        
        setAppearanceFor(view: btnNext, backgroundColor: APPCOLORS_3.Orange_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_SUB_HEADING(size: FONT_15))
        setAppearanceFor(view: btnNewUser, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_BUTTON_SUB_HEADING(size: FONT_13))
        setAppearanceFor(view: btnCreate, backgroundColor: APPCOLORS_3.Orange_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_SUB_HEADING(size: FONT_14))
        
        
//        let _ = setAttributetitleFor(view: btnCreate, title: "Are you a new user? Create account", rangeStrings: ["Are you a new user?", " Create account"], colors: [APPCOLORS_3.Black_BG, APPCOLORS_3.HeaderFooter_white_BG], fonts: [FONT_LABEL_BODY(size: FONT_13), FONT_BUTTON_SUB_HEADING(size: FONT_13)], alignmentCenter: true)
        
        //New user? Create Account
        
                
        viewText.cardView()
        btnNext.layer.cornerRadius = radius_5
        btnCreate.layer.cornerRadius = radius_5
    }
    
    
    
    
    @IBAction func handleBackButtonAction (_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func handleNextButtonAction (sender: UIButton) {
        
        CodeManager.sharedInstance.sendScreenName(burbank_signIn_login_button_touch)
        
        let email = txtEmail.text?.trim() ?? ""
        
        if email == "" {
            
            BurbankApp.showAlert("Please enter email", self)
            return
        }else if email.isValidEmail() == false {
            
            BurbankApp.showAlert("Please enter valid email", self)
            return
        }
        
        if let token = appDelegate.guestUserAccessToken {
            if token.count > 0 {
                checkEmailExists(email)
                return
            }
        }
        
        LoginDataManagement.shared.handleDefaultLoginforToken {
            self.checkEmailExists(email)
        }
        
    }
    
    
    @IBAction func handleCreateButtonAction (sender: UIButton) {
        
        CodeManager.sharedInstance.sendScreenName (burbank_signIn_createAccount_button_touch)
        
        moveToCreateAcctount()
    }
    
    
    func moveToCreateAcctount () {
        
        let email = txtEmail.text?.trim() ?? ""
        
        
        let createVC = kStoryboardLogin.instantiateViewController(withIdentifier: "CreateAccountVC") as! CreateAccountVC
        
        if email.isValidEmail() {
            let userSignUp = UserBean()
            userSignUp.userEmail = txtEmail.text?.trim()
            
            createVC.user = userSignUp
            
        }
        
        createVC.createAccountReturn = { user in
            
            self.navigationController?.popViewController(animated: false)
            
            self.txtEmail.text = user.userEmail
            
            let passwordVC = kStoryboardLogin.instantiateViewController(withIdentifier: "PasswordVC") as! PasswordVC
            passwordVC.userSignUp = user
            self.navigationController?.pushViewController(passwordVC, animated: true)

        }
        
        self.navigationController?.pushViewController(createVC, animated: true)
        
    }
    
}


extension JobNumberVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}


extension JobNumberVC {
    
    func checkEmailExists (_ email: String) {
        
        
        let _ = Networking.shared.POST_request(url: ServiceAPI.shared.URL_checkUserExists(email), parameters: NSDictionary(), userInfo: nil, success: { (json, response) in

            if let result: AnyObject = json {
                
                let result = result as! NSDictionary
                
                if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {
                    
                    let userSignUp = UserBean()
                    userSignUp.userEmail = email
                    
                    let passwordVC = kStoryboardLogin.instantiateViewController(withIdentifier: "PasswordVC") as! PasswordVC
                    passwordVC.userSignUp = userSignUp
                    self.navigationController?.pushViewController(passwordVC, animated: true)
                }else {
                    
                    alert.showAlert("Email Does not exist", "Do you want to create account with this email.", self, ["No", "Yes"]) { (str) in
                        
                        if str == "Yes" {
                            self.moveToCreateAcctount()
                        }
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
