//
//  TopVC.swift
//  BurbankApp
//
//  Created by dmss on 20/12/16.
//  Copyright © 216 MSS. All rights reserved.
//

import UIKit

class TopVC: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet weak var logoutLabel: UILabel!

    @IBOutlet weak var backIconImageView: UIImageView!
    @IBOutlet weak var logOutIconImageView: UIImageView!
    
    @IBOutlet weak var headerLabelCenterYConstraint: NSLayoutConstraint!
    
    
   // var isFromDashBoard : Bool?
    var isFromLaunchVC : Bool?
    var isFromLoginVC: Bool?
    var titleString: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        headerLabel.text = appDelegate.titleString
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        logoutButton.isUserInteractionEnabled = false
        logoutLabel.isHidden = true
        logOutIconImageView.isHidden = true
        
        checkAndChangViewStatus()

    }

    private func checkAndChangViewStatus()
    {
        if isFromLaunchVC == true {
            
            changeBackImageStatus()
        }
    }
    private func changeBackImageStatus()
    {
        backIconImageView.image = UIImage(named: "Ico-Burbank.png")
        headerLabelCenterYConstraint.constant = 2
        backButton.isUserInteractionEnabled = false

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
    // MARK: - Button Actions
    @IBAction func backButtonTapped(sender: AnyObject)
    {
        if isFromLoginVC == true
        {
            isFromLoginVC = false
        }
         _ = self.navigationController?.popViewController(animated: true)
    }
    


}
