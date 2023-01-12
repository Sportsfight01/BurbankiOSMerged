//
//  ResetPasswordVC.swift
//  MyPlace
//
//  Created by Mohan Kumar on 06/05/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit

class NewResetPasswordVC: UIViewController {
    
    @IBOutlet weak var btnIcon: UIButton!
    
    @IBOutlet weak var labelReset: UILabel!
    @IBOutlet weak var labelPassword: UILabel!
    @IBOutlet weak var labelHint: UILabel!
    
    
    @IBOutlet weak var viewOTPText: UIView!
    @IBOutlet weak var viewNewPasswordText: UIView!
    @IBOutlet weak var viewConfirmPasswordText: UIView!
    
    @IBOutlet weak var txtOTP: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnResend: UIButton!
    
    
    var isChangePassword: Bool = false
    
    var user: UserBean?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        handleUISetup ()
        
        if isChangePassword {
            labelReset.text = "Change"
            txtOTP.placeholder = "Enter Old Password"
            labelHint.text = "Change your password here"
            btnResend.isHidden = true
        }
        
        CodeManager.sharedInstance.sendScreenName(burbank_resetPassword_screen_loading)
    }
    
    
    //MARK: - View
    
    func handleUISetup () {
        
        setAppearanceFor(view: view, backgroundColor: AppColors.white)
        
        setAppearanceFor(view: labelReset, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_LABEL_SUB_HEADING(size: FONT_30))
        setAppearanceFor(view: labelPassword, backgroundColor: COLOR_CLEAR, textColor: AppColors.lightGray, textFont: FONT_LABEL_SUB_HEADING(size: FONT_30))
        setAppearanceFor(view: labelHint, backgroundColor: COLOR_CLEAR, textColor: AppColors.black, textFont: FONT_LABEL_BODY(size: FONT_13))
        
        setAppearanceFor(view: txtOTP, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_TEXTFIELD_BODY(size: FONT_13))
        setAppearanceFor(view: txtNewPassword, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_TEXTFIELD_BODY(size: FONT_13))
        setAppearanceFor(view: txtConfirmPassword, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_TEXTFIELD_BODY(size: FONT_13))
        
        
        setAppearanceFor(view: btnNext, backgroundColor: AppColors.appOrange, textColor: COLOR_WHITE, textFont: FONT_BUTTON_SUB_HEADING(size: FONT_15))
        setAppearanceFor(view: btnResend, backgroundColor: COLOR_CLEAR, textColor: AppColors.black, textFont: FONT_BUTTON_SUB_HEADING(size: FONT_13))
        
        
//        viewOTPText.layer.cornerRadius = radius_5
//        viewNewPasswordText.layer.cornerRadius = radius_5
//        viewConfirmPasswordText.layer.cornerRadius = radius_5
        
        [viewOTPText,viewNewPasswordText,viewConfirmPasswordText].forEach { view in
            if #available(iOS 13.0, *) {
                view?.cardView(cornerRadius: radius_5, shadowOpacity: 0.3, shadowColor: UIColor.systemGray3.cgColor)
            } else {
                // Fallback on earlier versions
                view?.cardView(cornerRadius: radius_5, shadowOpacity: 0.3)
            }
        }
        
        btnNext.layer.cornerRadius = radius_5
        
    }
    
    
    @IBAction func handleBackButtonAction (_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func handleNextButtonAction (sender: UIButton) {
        
        CodeManager.sharedInstance.sendScreenName(burbank_resetPassword_submit_button_touch)
                
        
        if txtOTP.text == "" {
            
            if isChangePassword {
                BurbankApp.showAlert("Please enter Old Password", self)
            }else {
                BurbankApp.showAlert("Please enter Passcode", self)
            }
            return
        }
        else if txtNewPassword.text == "" {
            
            BurbankApp.showAlert("Please enter New Password", self)
            return
        }
        else if txtConfirmPassword.text == "" {
            
            BurbankApp.showAlert("Please enter Confirm Password", self)
            return
        }
        else if txtNewPassword.text != txtConfirmPassword.text {
            BurbankApp.showAlert("New Password and Confirm Password should be same", self)
            return
        }
        
        changePassword ()
    }
    
    
    @IBAction func handleResendButtonAction (sender: UIButton) {
        
        if let email = self.user?.userEmail {
            handleForgot(email)
        }
        
        CodeManager.sharedInstance.sendScreenName (burbank_resetPassword_resendPasscode_button_touch)
    }
    
    
    func changePassword () {
        
        if isChangePassword {
            let params = NSMutableDictionary()
            params.setValue(txtOTP.text?.trim(), forKey: "Email")
            params.setValue(txtOTP.text?.trim(), forKey: "CurrentPassword")
            params.setValue(txtOTP.text?.trim(), forKey: "NewPassword")
            
            
            let _ = Networking.shared.POST_request(url: ServiceAPI.shared.URL_changePassword, parameters: params, userInfo: nil, success: { (json, response) in
                
                if let result: AnyObject = json {
                    
                    let result = result as! NSDictionary
                    
                    if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {

                        appDelegate.userData?.removeUserDetails()
                        loadLoginView()
                        
                    }else {
                        showToast((result.value(forKey: "message") ?? "") as! String, self)
                    }
                }else {
                    
                }
                
            }, errorblock: { (error, isJSONerror)  in
                
                if isJSONerror {
                    
                }else {
                    
                    alert.showAlert("Error", error?.localizedDescription ?? knoResponseMessage , self)
                }
                
            }, progress: nil)
            
            
        }else {
            
            let params = NSMutableDictionary()
            params.setValue(txtOTP.text?.trim(), forKey: "Passcode")
            params.setValue(txtNewPassword.text?.trim(), forKey: "NewPassword")
            params.setValue(self.user?.userEmail?.trim() ?? "", forKey: "EmailId")

            
            let _ = Networking.shared.POST_request(url: ServiceAPI.shared.URL_resetPassword, parameters: params, userInfo: nil, success: { (json, response) in
                
                if let result: AnyObject = json {
                    
                    let result = result as! NSDictionary
                    
                    if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {
                        
                        BurbankApp.showAlert(result.value(forKey: "message") as? String ?? "", self) { (str) in
                            
                            self.navigationController?.popToViewController((self.navigationController?.viewControllers[3])!, animated: true)
                        }
                        
                    }else {
                        
                        showToast("   \((result.value(forKey: "message") ?? "") as! String)   ", self)
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
    
    
    func handleForgot(_ email: String) {
                
                
        let _ = Networking.shared.POST_request(url: ServiceAPI.shared.URL_forgotPassword(email), parameters: NSDictionary(), userInfo: nil, success: { (json, response) in
            
            if let result: AnyObject = json {
                
                let result = result as! NSDictionary
                
                if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {
                    // showToast((result.value(forKey: "message") ?? "") as! String, self)
                    let info = result.value(forKey: "Info") as? NSDictionary
                    BurbankApp.showAlert((info?.value(forKey: "message") ?? "") as! String, self) { (str) in
                        
                    }
                    
                }else {
                    
                    if let Info = result.value(forKey: "message") as? NSDictionary {
                        showToast((Info.value(forKey: "message") ?? "") as! String, self)
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


extension NewResetPasswordVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField == txtNewPassword || textField == txtConfirmPassword), string == " " {
            
            return false
        }
        return true
    }
    
}
