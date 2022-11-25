//
//  MyPlaceContactsCell.swift
//  BurbankApp
//
//  Created by Mohan Kumar on 27/04/17.
//  Copyright © 2017 DMSS. All rights reserved.
//

import UIKit
import MessageUI

class MyPlaceContactsCell: UITableViewCell, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var mobileLabel: UILabel!
   // @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var callBackGroundView: UIView!
    @IBOutlet weak var emailBackGroundView: UIView!
    var emailString = ""
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setAppearanceFor(view: nameLabel, backgroundColor: COLOR_CLEAR, textColor: COLOR_WHITE, textFont: FONT_LABEL_SUB_HEADING(size: FONT_15))
        
        setAppearanceFor(view: fullNameLabel, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_LABEL_BODY (size: FONT_13))
        setAppearanceFor(view: emailLabel, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_LABEL_BODY (size: FONT_12))
        setAppearanceFor(view: mobileLabel, backgroundColor: COLOR_CLEAR, textColor: COLOR_DARK_GRAY, textFont: FONT_LABEL_BODY (size: FONT_12))

        
        
        callBackGroundView.layer.cornerRadius = callBackGroundView.frame.size.height/2
        emailBackGroundView.layer.cornerRadius = emailBackGroundView.frame.size.height/2


    }

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func handleMailTapped()
    {

        print("MyPlace - \((appDelegate.currentUser?.userDetailsArray?[0].myPlaceDetailsArray[0].jobNumber)!)")

        print("MyPlace - \((appDelegate.currentUser?.userDetailsArray?[0].myPlaceDetailsArray[0].jobNumber)!) - \(fillUserName1())")
        
        showMailOption(to: emailLabel.text!)
        
        

    }
        
    func configureMailComposer() -> MFMailComposeViewController{
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients([self.emailLabel.text!])
        mailComposeVC.setSubject("MyPlace - \((appDelegate.currentUser?.userDetailsArray?[0].myPlaceDetailsArray[0].jobNumber)!) - \(fillUserName1())")
        mailComposeVC.setMessageBody("", isHTML: false)
        mailComposeVC.setMessageBody("Kindly do not change the subject", isHTML: false)
        return mailComposeVC
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    @IBAction func callTapped(_ sender: UIControl) {
        
        let number = mobileLabel.text?.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
        let removeSpacesInNumber = Int((number?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""))
        guard let url = URL(string: "tel://+61\(removeSpacesInNumber!)") ?? URL(string: "") else { AlertManager.sharedInstance.showAlert(alertMessage: "Your device not supported to make a call.", title: "")
            return }
        // check whether device is supported to call or not
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        else {
            
            AlertManager.sharedInstance.showAlert(alertMessage: "Your device not supported to make a calls.", title: "")
        }
    }
}
