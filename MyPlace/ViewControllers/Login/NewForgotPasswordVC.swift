//
//  ForgotPasswordVC.swift
//  MyPlace
//
//  Created by Mohan Kumar on 06/05/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit

class NewForgotPasswordVC: UIViewController {
    
    
    var userSignUp: UserBean?

    
    @IBOutlet weak var btnIcon: UIButton!
    @IBOutlet weak var labelForgot: UILabel!
    @IBOutlet weak var labelPassword: UILabel!
    @IBOutlet weak var labelHint: UILabel!
    @IBOutlet weak var viewText: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnNext: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        handleUISetup ()
        
        fillEmail()
        
        CodeManager.sharedInstance.sendScreenName(burbank_forgotPassword_screen_loading)
    }
    
    
    
    //MARK: - View
    
    func handleUISetup () {
        
        setAppearanceFor(view: view, backgroundColor: AppColors.white)
        
        setAppearanceFor(view: labelForgot, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_LABEL_SUB_HEADING(size: FONT_30))
        setAppearanceFor(view: labelPassword, backgroundColor: COLOR_CLEAR, textColor: AppColors.lightGray, textFont: FONT_LABEL_SUB_HEADING(size: FONT_30))
        setAppearanceFor(view: labelHint, backgroundColor: COLOR_CLEAR, textColor: AppColors.black, textFont: FONT_LABEL_BODY(size: FONT_13))
        
        setAppearanceFor(view: txtEmail, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_TEXTFIELD_BODY(size: FONT_13))
        
        
        setAppearanceFor(view: btnNext, backgroundColor: AppColors.appOrange, textColor: COLOR_WHITE, textFont: FONT_BUTTON_SUB_HEADING(size: FONT_15))
        
        
        if #available(iOS 13.0, *) {
            viewText?.cardView(cornerRadius: radius_5, shadowOpacity: 0.3, shadowColor: UIColor.systemGray3.cgColor)
        } else {
            // Fallback on earlier versions
            viewText?.cardView(cornerRadius: radius_5, shadowOpacity: 0.3)
        }
        btnNext.layer.cornerRadius = radius_5
        
        
        labelHint.text = "Passcode will be sent to following \n Email to reset password"
    }
    
    
    func fillEmail () {
        
        self.txtEmail.text = self.userSignUp?.userEmail ?? ""
        
        if txtEmail.text!.count > 0 {
            self.viewText.isUserInteractionEnabled = false
            if #available(iOS 13.0, *) {
                self.viewText.backgroundColor = .systemGray4
            } else {
                self.viewText.backgroundColor = COLOR_LIGHT_GRAY
            }
        }
    }

    
    @IBAction func handleBackButtonAction (_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func handleNextButtonAction (sender: UIButton) {

        CodeManager.sharedInstance.sendScreenName (burbank_forgotPassword_next_button_touch)
        
        //validations not required due to user unable to change emailid
        let email = txtEmail.text?.trim() ?? ""
        handleForgot(email)
    }
}

extension NewForgotPasswordVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func handleForgot(_ email: String) {
                                
        let _ = Networking.shared.POST_request(url: ServiceAPI.shared.URL_forgotPassword(email), parameters: NSDictionary(), userInfo: nil, success: { (json, response) in
            
            if let result: AnyObject = json {
                
                let result = result as! NSDictionary
                
                if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {

                    BurbankApp.showAlert("Please check your email for Passcode", self) { (str) in
                        
                        let resetVC = kStoryboardLogin.instantiateViewController(withIdentifier: "NewResetPasswordVC") as! NewResetPasswordVC
                        resetVC.user = self.userSignUp
                        self.navigationController?.pushViewController(resetVC, animated: true)
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
