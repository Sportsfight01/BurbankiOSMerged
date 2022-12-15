//
//  AppleSignIn.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 09/10/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import Foundation
import AuthenticationServices



@available(iOS 13.0, *)
class SignInWithApple: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    static let shared = SignInWithApple ()
    
    var controllerVC: UIViewController?
    
    var appleSigninSuccess: ((_ result: ASAuthorizationAppleIDCredential?) -> Void)?
    var appleSigninFailure: ((_ result: Error?) -> Void)?

    
    
    func signInWithAppleButton (in VC: UIViewController) -> UIView {
        
        controllerVC = VC
        
      //  let authorizationButton = ASAuthorizationAppleIDButton()
      let authorizationButton = signInWithAppleBtn()
      authorizationButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleAppleSignInButton)))
    //    authorizationButton.addTarget(self, action: #selector(handleAppleSignInButton), for: .touchUpInside)
        
        return authorizationButton
    }
    
  func signInWithAppleBtn() -> UIView{
    
    let view = UIView(frame: .zero)
      view.backgroundColor = .lightGray.withAlphaComponent(0.6)
    view.layer.cornerRadius = 10.0
    
    //imgView
    let imgView = UIImageView(image: UIImage(named: "Ico-Apple"))
    imgView.contentMode = .scaleAspectFit
    imgView.tintColor = .white
//    imgView.backgroundColor = .clear
    view.addSubview(imgView)
    imgView.translatesAutoresizingMaskIntoConstraints = false
    //addConstraints to imgView
    NSLayoutConstraint.activate([
        NSLayoutConstraint(item: imgView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1.0, constant: view.frame.size.height - 10),
      NSLayoutConstraint(item: imgView, attribute: .width, relatedBy: .equal, toItem: imgView, attribute: .height, multiplier: 1.0, constant: view.frame.size.height - 10),
      NSLayoutConstraint(item: imgView, attribute: .centerY, relatedBy: .equal, toItem: view , attribute: .centerY, multiplier: 1.0, constant: 0),
      NSLayoutConstraint(item: imgView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 30)
    ])
    //titleLabel
    let titleLabel = UILabel()
    titleLabel.text = "Sign in with Apple"
      titleLabel.font = UIFont.systemFont(ofSize: FONT_signin , weight: .regular)
    titleLabel.textColor = .black
   
    view.addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    //add constraints to label
    NSLayoutConstraint.activate([
      NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: imgView, attribute: .trailing, multiplier: 1.0, constant: 15.0),
      NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0)
      
    ])
    
    
    
    return view
    
    
    
    
//    let button = UIButton(frame: .zero)
//    button.layer.cornerRadius = 5.0
//    button.backgroundColor = .black
//    button.setImage(UIImage(named: "Ico-Apple"), for: .normal)
//    button.setTitle("Sign in with Apple", for: UIControl.State())
//    button.semanticContentAttribute = .forceLeftToRight
//    return button
  }
    
    //MARK: - Action
    
    @IBAction func handleAppleSignInButton () {
        
        if let vc = controllerVC {
            alert.showAlert(kAPPNAME, "Please allow email to continue!!", vc, ["NO", "YES"]) { (str) in
                if str == "YES" {
                    
                    let appleIDProvider = ASAuthorizationAppleIDProvider()
                    let request = appleIDProvider.createRequest()
                    request.requestedScopes = [.fullName, .email]
                    
                    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
                    authorizationController.delegate = self
                    authorizationController.presentationContextProvider = self
                    authorizationController.performRequests()
                }
            }
        }
    }
    
    
    
    
    //MARK: - Delegate

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return controllerVC?.view.window ?? kWindow
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            
            if let action = self.appleSigninSuccess {
                action (appleIDCredential)
            }

            
//            let appleIDProvider = ASAuthorizationAppleIDProvider()
            
//            appleIDProvider.getCredentialState(forUserID: appleIDCredential.user) { (state, error) in
//
//                switch state {
//                case .authorized:
//                    if let action = self.appleSigninSuccess {
//                        action (appleIDCredential)
//                    }
//                    break // The Apple ID credential is valid.
//                case .revoked, .notFound:
//                    // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
//                    DispatchQueue.main.async {
//                        showAlert("The Apple ID credential is either revoked or was not found")
//                    }
//                default:
//                    break
//                }
//            }
                                    
        }else {

            if let action = appleSigninFailure {
                action (nil)
            }
        }
        
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
        if let action = appleSigninFailure {
            action (error)
        }
    }
    
}



