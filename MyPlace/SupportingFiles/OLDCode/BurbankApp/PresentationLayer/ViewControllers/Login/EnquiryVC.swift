

//
//  EnquiryVC.swift
//  BurbankApp
//
//  Created by dmss on 12/01/17.
//  Copyright © 2017 DMSS. All rights reserved.
//

import UIKit

/// Enquiry view protocol for hiding view in dashboard
protocol enquiryViewProtocal {
    func callToHideView()
}

/**
 - File:       EnquiryVC
 - Contains:   Enquiry view using in dashboard and house details view
 */
class EnquiryVC: BurbankAppVC
{
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var enquiryMailIDTextField : UITextField!
    @IBOutlet weak var enquiryTextView: UITextView!
    @IBOutlet weak var enquiryViewCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var enquiryViewBottomConstraint: NSLayoutConstraint!
    
    var delegate: enquiryViewProtocal?
    var isWantBottom : Bool!
    var houseName : String!
    var houseSize : String!
    
    /// Mark : - View life cycle methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        if let email = appDelegate.currentUser?.userDetailsArray?[0].primaryEmail
        {
             enquiryMailIDTextField.text = email
        }

        if isWantBottom == true {
            enquiryViewCenterYConstraint.isActive = false
            enquiryViewBottomConstraint.isActive = true
        }
        else
        {
            enquiryViewCenterYConstraint.isActive = true
            enquiryViewBottomConstraint.isActive = false
        }
        
        sendButton.isExclusiveTouch = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /// Method for cancel button action
    @IBAction func cancelButtonTapped(sender: AnyObject)
    {
        dismissVC()
    }
    
    /// Method for dismissing enquiry view
    func dismissVC()
    {
         dismiss(animated: true, completion: nil)
    }
    
    /// Method for send button action
    @IBAction func sendButtonTapped(sender: AnyObject)
    {
        let sendButton = sender as! UIButton
        sendButton.isEnabled = false
        
        if enquiryMailIDTextField.text == "" {
            AlertManager.sharedInstance.alert("Please Enter Mail ID")
            sendButton.isEnabled = true
            return
        }
        else if enquiryMailIDTextField.text!.trim().isValidEmail() == false
        {
            AlertManager.sharedInstance.alert("Please Enter Valid Mail ID")
            sendButton.isEnabled = true
            return
        }
        else if enquiryTextView.text == ""
        {
            AlertManager.sharedInstance.alert("Please Enter Your Requirement")
            sendButton.isEnabled = true
            return
        }
        
        if !ServiceSession.shared.checkNetAvailability()
        {
            sendButton.isEnabled = true
            return
        }
        appDelegate.hideActivity()
        
        // For particular house details enquiry
        
        if isWantBottom == true {
            
            // For Registered users
            if appDelegate.currentUser?.userDetailsArray?[0].primaryEmail != nil {
                
//                let firstName = appDelegate.userDetails?.firstName
//                let mobileNo = appDelegate.userDetails?.mobile
//                
//                CodeManager.sharedInstance.enquiryServiceCall(email: enquiryMailIDTextField.text!, message: enquiryTextView.text!, mobile: mobileNo!, name: firstName!, houseName: houseName, houseSize: houseSize, completionHandler: {(statusMsg) in
//                    
//                    if (statusMsg as! Bool) == true
//                    {
//                        self.dismissVC()
//                    }
//                    sendButton.isEnabled = true
//                })
                
            } // For Guest users
            else {

                CodeManager.sharedInstance.enquiryServiceCall(email: enquiryMailIDTextField.text!, message: enquiryTextView.text!, mobile: "", name: "", houseName: houseName, houseSize: houseSize, completionHandler: {(statusMsg) in
                    
                    if (statusMsg as! Bool) == true
                    {
                        self.dismissVC()
                    }
                    sendButton.isEnabled = true
                })
            }

        }
        // For dashboard general enquiry
        
        else {
            
            CodeManager.sharedInstance.enquiryServiceCall(email: enquiryMailIDTextField.text!, message: enquiryTextView.text!, mobile: "", name: "", houseName: "", houseSize: "", completionHandler: {(statusMsg) in
                
                if (statusMsg as! Bool) == true
                {
                    self.dismissVC()
                }
                sendButton.isEnabled = true
            })
        }
    }
}
