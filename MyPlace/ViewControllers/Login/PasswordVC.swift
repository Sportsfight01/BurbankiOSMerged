//
//  PasswordVC.swift
//  MyPlace
//
//  Created by Mohan Kumar on 06/05/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit

class PasswordVC: UIViewController {
    
    
    var userSignUp: UserBean?
    
    
    @IBOutlet weak var btnIcon: UIButton!
    
    @IBOutlet weak var labelEnter: UILabel!
    @IBOutlet weak var labelPassword: UILabel!
    @IBOutlet weak var labelHint: UILabel!
    
    
    @IBOutlet weak var viewEmailText: UIView!
    @IBOutlet weak var viewPasswordText: UIView!
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnForgot: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        // Do any additional setup after loading the view.
        handleUISetup()
        
        fillEmail ()
        
        #if DEDEBUG
        txtPassword.text = "Abc@1234"
        txtPassword.text = "123456"
        #endif
        
        CodeManager.sharedInstance.sendScreenName(burbank_password_screen_loading)
        
    }
    
    func handleUISetup () {
        
        setAppearanceFor(view: view, backgroundColor: AppColors.white)
        
        setAppearanceFor(view: labelEnter, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_SUB_HEADING(size: FONT_30))
        setAppearanceFor(view: labelPassword, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_SUB_HEADING(size: FONT_30))
        setAppearanceFor(view: labelHint, backgroundColor: COLOR_CLEAR, textColor: AppColors.black, textFont: FONT_LABEL_BODY(size: FONT_13))
        
        setAppearanceFor(view: txtEmail, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_TEXTFIELD_BODY(size: FONT_13))
        setAppearanceFor(view: txtPassword, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_TEXTFIELD_BODY(size: FONT_13))
        
        
        setAppearanceFor(view: btnLogin, backgroundColor: AppColors.appOrange, textColor: COLOR_WHITE, textFont: FONT_BUTTON_SUB_HEADING(size: FONT_15))
        setAppearanceFor(view: btnForgot, backgroundColor: COLOR_CLEAR, textColor: AppColors.black, textFont: FONT_BUTTON_SUB_HEADING(size: FONT_13))
        
        [viewEmailText , viewPasswordText].forEach({ view in
            if #available(iOS 13.0, *) {
                view?.cardView(cornerRadius: radius_5, shadowOpacity: 0.3, shadowColor: UIColor.systemGray3.cgColor)
            } else {
                // Fallback on earlier versions
                view?.cardView(cornerRadius: radius_5, shadowOpacity: 0.3)
            }
        })
        btnLogin.layer.cornerRadius = radius_5
        
    }
    
    func fillEmail () {
        
        self.txtEmail.text = self.userSignUp?.userEmail ?? ""
        
        if txtEmail.text!.count > 0 {
            self.viewEmailText.isUserInteractionEnabled = false
            if #available(iOS 13.0, *) {
                self.viewEmailText.backgroundColor = APPCOLORS_3.LightGreyDisabled_BG
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    
    
    @IBAction func handleBackButtonAction (_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func handleLoginButtonAction (sender: UIButton) {
        
        CodeManager.sharedInstance.sendScreenName(burbank_password_login_button)

        //validations
        
        if txtPassword.text?.trim() == "" {
            
            AlertManager.sharedInstance.showAlert(alertMessage: "Please enter password")
            return
        }
        
        handleLogin((txtEmail.text?.trim())!, (txtPassword.text?.trim())!)
                
    }
        
    @IBAction func handleForgotButtonAction (sender: UIButton) {
        
        CodeManager.sharedInstance.sendScreenName(burbank_password_forgotPassword_button)
        
        let forgotVC = kStoryboardLogin.instantiateViewController(withIdentifier: "NewForgotPasswordVC") as! NewForgotPasswordVC
        forgotVC.userSignUp = userSignUp
        self.navigationController?.pushViewController(forgotVC, animated: true)
        
    }
}


extension PasswordVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtPassword, string == " " {
            
            return false
        }
        return true
    }
    
}


extension PasswordVC {
    
    func handleLogin (_ email: String, _ password: String) {
        
        let params = ["Username" : email, "Password" : password]
        
        
        let _ = Networking.shared.POST_request(url: ServiceAPI.shared.URL_userLogin, parameters: params as NSDictionary, userInfo: nil, success: { (json, response) in
            
            if let result: AnyObject = json {
                
                let result = result as! NSDictionary
                
                if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {
                    
                    appDelegate.userData?.user?.userID = String.checkNumberNull(result.value(forKey: "Userid") as Any)
                    
                    if (appDelegate.userData?.user?.userID?.count)! > 0 {
                        
                        appDelegate.userData?.user?.userEmail = email
                        appDelegate.userData?.user?.userPassword = password
                    }else {
                        assertionFailure("UserID shouldn't empty")
                    }
                    
                    print(log: appDelegate.userData?.user?.userID! ?? "0")
                    print(log: "\(appDelegate.userData?.user?.userID ?? "0")")
                    
                    appDelegate.userData?.accessToken = String.checkNullValue(result.value(forKey: "token") as Any)
                    
                    appDelegate.userData?.saveUserDetails()
                    loadMainView()
                    
                    showToast(result.value(forKey: "message") as? String ?? "")
                }else {
                    
                    if (result.value(forKey: "message") ?? "") as! String == "Email or Password is incorrect" {
                        
                        showToast(kuserNamePasswordNotMatched, self)
                    }else {
                        
                        showToast((result.value(forKey: "message") ?? "") as! String, self)
                    }
                }
            }else {
                
            }
            
        }, errorblock: { (error, isJSONerror)  in
            
            if isJSONerror {
                
            }else {
                
                alert.showAlert("Error", error?.localizedDescription ?? knoResponseMessage , self)
            }
            
        }, progress: nil)
        
        
    }
    
    
}
