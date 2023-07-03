//
//  CustomersUserpreferrenceVC.swift
//  BurbankApp
//
//  Created by Naresh Banavath on 29/05/23.
//  Copyright © 2023 Sreekanth tadi. All rights reserved.
//
import UIKit

class CustomersUserpreferrenceVC: UIViewController {
   
    
    @IBOutlet weak var nameLBL: UILabel!
    @IBOutlet weak var helloLBL: UILabel!
    
    @IBOutlet weak var buildProgressBTN: UIButton!
    @IBOutlet weak var buildProgressView: UIView!
    
    @IBOutlet weak var homeCareView: UIView!
    @IBOutlet weak var homeCareBTN: UIButton!

    var userData : User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        setStatusBarColor(color: .white)
    }

    @IBAction func didTappedOnBuildProgress(_ sender: UIButton) {
        CodeManager.sharedInstance.handleUserLoginSuccess(user: appDelegate.currentUser!, In: self)
    }
    
    @IBAction func didTappedOnHomeCare(_ sender: UIButton) {
        let isLoggedIssueCompleted = UserDefaults.standard.string(forKey: "issueLoged")
        if isLoggedIssueCompleted == "1"{
            CodeManager.sharedInstance.handleLoggedUserHomecare(user: appDelegate.currentUser!, In: self)
            UserDefaults.standard.set("0", forKey: "issueLoged")
            
        }else{
            CodeManager.sharedInstance.handleUserHomecareModule(user: appDelegate.currentUser!, In: self)
        }
        
        
    }
 
}
