//
//  SalesConsultantVC.swift
//  BurbankApp
//
//  Created by Mohan Kumar on 16/12/16.
//  Copyright © 2016 DMSS. All rights reserved.
//

import UIKit

/**
 - File:       SalesConsultantVC
 - Contains:   Sales Consultant view  for showing assigned sales consultant details
 */
class SalesConsultantVC: BurbankAppVC {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var mobileTextField : UITextField!
    @IBOutlet weak var emailTextField : UITextField!

    /// Mark:- View life cycle methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
//        if appDelegate.userDetails?.isSalesConsultantAsign == true { //UserDefaults.standard.value(forKey: "isSalesConsultantAsign") as! Bool
//            
//            nameLabel.text = appDelegate.userDetails?.salesPersonDictionary?.value(forKey: "Name") as! String?
//            mobileTextField.text = appDelegate.userDetails?.salesPersonDictionary?.value(forKey: "WorkPhone") as! String?
//            emailTextField.text = appDelegate.userDetails?.salesPersonDictionary?.value(forKey: "Email") as! String?
//
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  
    //MARK: -
    
    /// Method for close method action.
    @IBAction func closeTapped(sender: AnyObject)
    {
        self.dismiss(animated: true, completion: nil)
    }

}
