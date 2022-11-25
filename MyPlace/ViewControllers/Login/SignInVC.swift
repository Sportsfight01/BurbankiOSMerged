//
//  SignInVC.swift
//  MyPlace
//
//  Created by Sreekanth tadi on 18/03/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit
//import FirebaseCrashlytics

class SignInVC: UIViewController {

    
    @IBOutlet weak var btnIcon: UIButton!
    
    
    @IBOutlet weak var labelSign: UILabel!
    @IBOutlet weak var labelIn: UILabel!
    @IBOutlet weak var labelChooseMethod: UILabel!
    
    
    @IBOutlet weak var viewGoogle: UIView!
    @IBOutlet weak var imageGoogle: UIImageView!
    @IBOutlet weak var labelGoogle: UILabel!
    @IBOutlet weak var btnGoogle: UIButton!
    
    @IBOutlet weak var viewFacebook: UIView!
    @IBOutlet weak var imageFacebook: UIImageView!
    @IBOutlet weak var labelFacebook: UILabel!
    @IBOutlet weak var btnFacebook: UIButton!
    
    
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var imageEmail: UIImageView!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var btnEmail: UIButton!

    var btnAppleSignIn: UIView?

    @IBOutlet weak var stackviewRatio: NSLayoutConstraint!
    var stackviewRatio2: NSLayoutConstraint?

    
    
    
    @IBOutlet weak var btnSkip: UIButton!

    
    
    @IBOutlet weak var viewPopUP: UIView!
    @IBOutlet weak var viewPopUpMain: UIView!
    
    @IBOutlet weak var labelNoteHeading: UILabel!
    @IBOutlet weak var labelNote: UILabel!
    @IBOutlet weak var labelNoteAlert: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnSignIn: UIButton!

    let burbank_signIn_password_screen_loading = "burbank_signIn_password_screen_loading"
    let burbank_signIn_createAccount_button_touch = "burbank_signIn_createAccount_button_touch"
    let burbank_signIn_login_button_touch = "burbank_signIn_login_button_touch"

    
    //MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        viewPopUP.isHidden = true
        
        addAppleSignInButton ()
        handleUISetup()
        addGestures()
        
        CodeManager.sharedInstance.sendScreenName(burbank_signIn_screen_loading)
    }
    
    //MARK: - View
    
    func addAppleSignInButton () {
        
        if #available(iOS 13.0, *) {
            
            btnAppleSignIn = SignInWithApple.shared.signInWithAppleButton(in: self)
            
            if let stackView = viewGoogle.superview, let appleButton = btnAppleSignIn {
                                
                (stackView as! UIStackView).insertArrangedSubview(appleButton, at: 0)
                stackviewRatio.isActive = false //0.201
                
                if let _ = stackviewRatio2 {
                    
                }else {
                    stackviewRatio2 = stackView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.273)
                    
                    NSLayoutConstraint.activate([
                        stackviewRatio2!
                    ])
                }
                
                
                
//                appleButton.translatesAutoresizingMaskIntoConstraints = false
//                view.addSubview(appleButton)
//
//
//                NSLayoutConstraint.activate ([
//                    btnAppleSignIn!.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: 0),
//                    btnAppleSignIn!.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: 0),
//                    btnAppleSignIn!.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
//                    btnAppleSignIn!.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.33, constant: -15)
//                ])
            }
            
            
            SignInWithApple.shared.appleSigninSuccess = { (result) in
                
                if let _ = result {
                    
                    print(log: result?.user as Any)
                    print(log: result?.email as Any)
                    print(log: result?.fullName?.givenName as Any)
                    print(log: result?.fullName?.familyName as Any)
                    print(log: result?.realUserStatus as Any)
                    print(log: result?.state as Any)
                    print(log: result?.authorizationCode as Any)
                    print(log: result?.authorizedScopes as Any)
                    print(log: result?.identityToken as Any)
                    
                    if let code = result?.authorizationCode {
                        print(log: String.init(data: code, encoding: .utf8) as Any)
                    }
                    if let token = result?.identityToken {
                        print(log: String.init(data: token, encoding: .utf8) as Any)
                    }
                    
                    
                    if let email = result?.email {
                     
                        let user = UserBean ()
                        user.userEmail = email
                        user.userFirstName = result?.fullName?.givenName ?? ""
                        user.userLastName = result?.fullName?.familyName ?? ""
                        user.userAppleID = result?.user
                        
                        LoginDataManagement.shared.createAccount(user) {
                            
                        }
                        
                    }else {
                        
                        alert.showAlert ("Email is empty", "Please try other options or tap on 'Share My Email' to signIn", self, ["OK"], nil)
                    }
                    
                }
            }
            
            SignInWithApple.shared.appleSigninFailure = { (result) in
//                if let _ = result {
//                    ActivityManager.showToast(result!.localizedDescription, self, .top)
//                }else {
                    ActivityManager.showToast("SignIn failed", self, .top)
//                }
            }
            
        } else {
            // Fallback on earlier versions
        }
                
    }
    

    func handleUISetup () {
        
        setAppearanceFor(view: view, backgroundColor: COLOR_ORANGE)
        
        
        setAppearanceFor(view: labelSign, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_LABEL_HEADING(size: FONT_30))
        setAppearanceFor(view: labelIn, backgroundColor: COLOR_CLEAR, textColor: COLOR_WHITE, textFont: FONT_LABEL_HEADING(size: FONT_30))
        
        setAppearanceFor(view: labelChooseMethod, backgroundColor: COLOR_CLEAR, textColor: COLOR_WHITE, textFont:  FONT_LABEL_SUB_HEADING(size: FONT_13))
        
        
        setAppearanceFor(view: labelGoogle, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: systemRegularFont(size: FONT_signin))
        setAppearanceFor(view: labelFacebook, backgroundColor: COLOR_CLEAR, textColor: COLOR_WHITE, textFont: systemRegularFont(size: FONT_signin))
        setAppearanceFor(view: labelEmail, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: systemRegularFont(size: FONT_signin))
        
        viewEmail.backgroundColor = COLOR_WHITE
        
        
//        setAppearanceFor(view: labelGoogle, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_LABEL_SUB_HEADING(size: FONT_14))
//        setAppearanceFor(view: labelFacebook, backgroundColor: COLOR_CLEAR, textColor: COLOR_WHITE, textFont: FONT_LABEL_SUB_HEADING(size: FONT_14))
//        setAppearanceFor(view: labelEmail, backgroundColor: COLOR_CLEAR, textColor: COLOR_WHITE, textFont: FONT_LABEL_SUB_HEADING(size: FONT_14))
        
        setAppearanceFor(view: btnSkip, backgroundColor: COLOR_ORANGE_LIGHT, textColor: COLOR_WHITE, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_15))


        
        
        setAppearanceFor(view: labelNoteHeading, backgroundColor: COLOR_CLEAR, textColor: COLOR_ORANGE, textFont: FONT_LABEL_HEADING(size: FONT_30))

        setAppearanceFor(view: labelNote, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_LABEL_SUB_HEADING (size: FONT_14))

        setAppearanceFor(view: labelNoteAlert, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_LABEL_SUB_HEADING (size: FONT_14))

        labelNoteAlert.addCharacterSpacing(kernValue: -0.3)
        
        
        setAppearanceFor(view: btnContinue, backgroundColor: COLOR_BLACK, textColor: COLOR_WHITE, textFont: FONT_BUTTON_SUB_HEADING(size: FONT_16))
        setAppearanceFor(view: btnSignIn, backgroundColor: COLOR_ORANGE, textColor: COLOR_WHITE, textFont: FONT_BUTTON_SUB_HEADING(size: FONT_16))

        
        viewGoogle.layer.cornerRadius = radius_5
        viewFacebook.layer.cornerRadius = radius_5
        viewEmail.layer.cornerRadius = radius_5
        btnSkip.layer.cornerRadius = radius_5

        
        viewPopUpMain.layer.cornerRadius = radius_10
        
        btnContinue.layer.cornerRadius = radius_5
        btnSignIn.layer.cornerRadius = radius_5
        
    }
    

    func addGestures () {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleGestureRecognizer(recognizer:)))
        viewPopUP.addGestureRecognizer(tap)
    }
    


    
    @IBAction func handleSigInButtonsActions (sender: UIButton) {
        
        if sender == btnGoogle {

            CodeManager.sharedInstance.sendScreenName(burbank_signIn_google_button_touch)

            LoginDataManagement.shared.viewContr = self
            LoginDataManagement.shared.handleGoogleSignIn()

        }else if sender == btnFacebook {
            
            CodeManager.sharedInstance.sendScreenName(burbank_signIn_facebook_button_touch)

            LoginDataManagement.shared.viewContr = self
            LoginDataManagement.shared.handleFacebookSignIn()

        }else if sender == btnEmail {
           

            CodeManager.sharedInstance.sendScreenName(burbank_signIn_email_button_touch)

            let jobNumberView = kStoryboardLogin.instantiateViewController(withIdentifier: "JobNumberVC") as! JobNumberVC
            self.navigationController?.pushViewController(jobNumberView, animated: true)

        }        
    }
    
    @IBAction func handleBackButtonAction (_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func handleSkipButton (sender: UIButton) {

        CodeManager.sharedInstance.sendScreenName (burbank_signIn_skip_button_touch)
        
        viewPopUP.isHidden = false
        view.bringSubviewToFront(viewPopUP)
        
    }
    
    @IBAction func handleContinueButton (sender: UIButton) {
                
        CodeManager.sharedInstance.sendScreenName (burbank_signIn_next_button_touch)

        if let token = appDelegate.guestUserAccessToken {
            if token.count > 0 {
                loadMainView()
                return
            }
        }
        
        LoginDataManagement.shared.handleDefaultLoginforToken {
            loadMainView()
        }
    }
    
    @IBAction func handleSignInButton (sender: UIButton) {
        
        CodeManager.sharedInstance.sendScreenName(burbank_signIn_sign_button_touch)
        
        viewPopUP.isHidden = true

        let jobNumberView = kStoryboardLogin.instantiateViewController(withIdentifier: "JobNumberVC") as! JobNumberVC
        self.navigationController?.pushViewController(jobNumberView, animated: true)
    }
    
}



extension SignInVC {
 
    @objc func handleGestureRecognizer (recognizer: UIGestureRecognizer) {
        
        if viewPopUpMain.frame.contains(recognizer.location(in: viewPopUP)) {

        }else {
            viewPopUP.isHidden = true
        }
            
    }
}


