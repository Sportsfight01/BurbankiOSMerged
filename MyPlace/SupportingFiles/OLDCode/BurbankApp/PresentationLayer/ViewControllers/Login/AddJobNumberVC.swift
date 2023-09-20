//
//  AddJobNumberVC.swift
//  BurbankApp
//
//  Created by dmss on 11/07/17.
//  Copyright © 2017 DMSS. All rights reserved.
//

import UIKit
protocol addJobProtocol
{
    func hideAddJobView()
    func userAddedJobSuccessfully()
}

class AddJobNumberVC: UIViewController
{
    //IBOutlets
    @IBOutlet weak var jobNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var addJobTitle: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    
    
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var delegate: addJobProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.65)
        
        
        setAppearanceFor(view: addJobTitle, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Orange_BG, textFont: FONT_LABEL_SUB_HEADING(size: FONT_16))
        
        setAppearanceFor(view: jobNumberTextField, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_TEXTFIELD_BODY(size: FONT_12))
        setAppearanceFor(view: passwordTextField, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_TEXTFIELD_BODY(size: FONT_12))
        
        
        setAppearanceFor(view: btnCancel, backgroundColor: APPCOLORS_3.BTN_DarkGray, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_LABEL_SUB_HEADING(size: FONT_15))
        setAppearanceFor(view: btnAdd, backgroundColor: APPCOLORS_3.Orange_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_LABEL_SUB_HEADING(size: FONT_15))
        
        btnCancel.layer.cornerRadius = radius_5
        btnAdd.layer.cornerRadius = radius_5
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    // MARK: - IBActions
    @IBAction func cancelButtonTapped(sender: AnyObject?)
    {
        jobNumberTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        jobNumberTextField.text = ""
        passwordTextField.text = ""
        delegate?.hideAddJobView()
    }
    @IBAction func addJobTapped(sender: AnyObject?)
    {
        if jobNumberTextField.text == ""
        {
            AlertManager.sharedInstance.showAlert(alertMessage: "Please enter JobNumber", title: "")
            jobNumberTextField.becomeFirstResponder()
            return
        }
        
        if passwordTextField.text == ""
        {
            AlertManager.sharedInstance.showAlert(alertMessage: "Please enter Password", title: "")
            passwordTextField.becomeFirstResponder()
            return
        }
        var isJobNumberAlreadyExist = false
        appDelegate.currentUser?.userDetailsArray?[0].myPlaceDetailsArray.forEach({ (myPlaceDetails) in
            if myPlaceDetails.jobNumber == jobNumberTextField.text
            {
                isJobNumberAlreadyExist = true
            }
        })
        if isJobNumberAlreadyExist == true
        {
            AlertManager.sharedInstance.showAlert(alertMessage: "JobNumber already exists", title: "")
            jobNumberTextField.becomeFirstResponder()
            return
        }
        let userId = appDelegate.currentUser?.userDetailsArray?[0].id
        let postDic: NSDictionary = ["LoginUserId": userId ?? -1,"JobNumber":jobNumberTextField.text ?? "","MyPlacePassword": passwordTextField.text ?? ""]
        ServiceSession.shared.callToPostDataToServerWithGivenURLString(urlString: addJobURL, postBodyDictionary: postDic) { (json) in
            let jsonDic = json as! NSDictionary
            let message = jsonDic.object(forKey: "Message")as? String
            if let status = jsonDic.object(forKey: "Status") as? Bool {
                
                // print(jsonDic)
                
                if status == true {
                    if let userDic = jsonDic.object(forKey: "Result") as? [String: Any]
                    {
                        let user = User(dic: userDic)
                        if user.isSuccess  == true
                        {
                            self.appDelegate.currentUser = user
                            self.jobNumberTextField.text = ""
                            self.passwordTextField.text = ""
                            self.jobNumberTextField.resignFirstResponder()
                            self.passwordTextField.resignFirstResponder()
                            self.delegate?.userAddedJobSuccessfully()
                        }else {
                            AlertManager.sharedInstance.showAlert(alertMessage: message!, title: "")
                            return
                        }
                    }
                }else
                {
                    AlertManager.sharedInstance.showAlert(alertMessage: message!, title: "")
                    return
                }
                
            }else
            {
                AlertManager.sharedInstance.showAlert(alertMessage: message!, title: "")
                return
            }
            
        }
    }
}
