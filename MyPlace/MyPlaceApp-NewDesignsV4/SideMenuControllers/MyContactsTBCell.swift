//
//  MyContactsTBCell.swift
//  BurbankApp
//
//  Created by Naresh Banavath on 28/03/22.
//  Copyright © 2022 DMSS. All rights reserved.
//

import UIKit
import MessageUI

class MyContactsTBCell: UITableViewCell , MFMailComposeViewControllerDelegate {

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
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(callTapped))
        callBackGroundView.addGestureRecognizer(tap1)
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(handleMailTapped))
        emailBackGroundView.addGestureRecognizer(tap2)
        
    }

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupFonts()
    {
        nameLabel.font = FONT_LABEL_SUB_HEADING(size: FONT_14)
        [fullNameLabel,emailLabel,mobileLabel].forEach({ $0?.font = FONT_LABEL_SUB_HEADING(size: FONT_12) })
    }
    @objc func handleMailTapped()
    {
        
        print("MyPlace - \((appDelegate.currentUser?.userDetailsArray?[0].myPlaceDetailsArray[0].jobNumber)!)")
        
        print("MyPlace - \((appDelegate.currentUser?.userDetailsArray?[0].myPlaceDetailsArray[0].jobNumber)!) - \(fillUserName1())")
        
       // showMailOption(to: emailLabel.text ?? "example@gmail.com")
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        
        let mail = configureMailComposer()
        if MFMailComposeViewController.canSendMail()
        {
        kWindow.rootViewController?.present(mail, animated: true, completion: nil)
        }else {
            debugPrint("Current device can not send email")
        }
        
        
        
    }
        
    func configureMailComposer() -> MFMailComposeViewController{
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients([self.emailLabel.text ?? ""])
        mailComposeVC.setSubject("MyPlace - \((appDelegate.currentUser?.userDetailsArray?[0].myPlaceDetailsArray[0].jobNumber)!) - \(fillUserName1())")
        mailComposeVC.setMessageBody("", isHTML: false)
        mailComposeVC.setMessageBody("Kindly do not change the subject", isHTML: false)
        return mailComposeVC
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    @objc func callTapped() {
        
        guard let phoneNumber = mobileLabel.text?.replacingOccurrences(of: " ", with: "") else {return}
        debugPrint("Phone No:- \(phoneNumber)")
        guard let url = URL(string: "telprompt://\(phoneNumber)"),
              UIApplication.shared.canOpenURL(url) else {
              return
          }
          UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
//        let number = mobileLabel.text?.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
//        let removeSpacesInNumber = Int((number?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""))
//        guard let url = URL(string: "tel://+61\(removeSpacesInNumber!)") ?? URL(string: "") else { AlertManager.sharedInstance.showAlert(alertMessage: "Your device not supported to make a call.", title: "")
//            return }
//        // check whether device is supported to call or not
//        if UIApplication.shared.canOpenURL(url) {
//            if #available(iOS 10, *) {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            } else {
//                UIApplication.shared.openURL(url)
//            }
//        }
//        else {
//
//            AlertManager.sharedInstance.showAlert(alertMessage: "Your device not supported to make a calls.", title: "")
//        }
    }

}
