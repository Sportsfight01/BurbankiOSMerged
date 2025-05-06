//
//  BookAnAppointmentWebViewVC.swift
//  BurbankApp
//
//  Created by Naveen Kourampalli on 05/05/25.
//  Copyright © 2025 Sreekanth tadi. All rights reserved.
//

import UIKit
import WebKit

class BookAnAppointmentWebViewVC: HeaderVC {

    @IBOutlet weak var webView: WKWebView!
    
    var displayHomeData: [houseDetailsByHouseType]?
    var prefferedDate : String = ""
    var prefferdTime : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let firstName = appDelegate.userData?.user?.userFirstName ?? ""
        let lastName = appDelegate.userData?.user?.userLastName ?? ""
        let email = appDelegate.userData?.user?.userEmail ?? ""
        let phoneNumber = appDelegate.userData?.user?.userPhoneNumber ?? ""
        headerLogoText = "DisplayHomes"
        self.addBreadCrumb(from: "Book an appointment")
        isFromProfile = false
        if btnBack.isHidden {
            showBackButton()
            btnBack.addTarget(self, action: #selector(handleBackButton(_:)), for: .touchUpInside)
            btnBackFull.addTarget(self, action: #selector(handleBackButton(_:)), for: .touchUpInside)
        }
        
        WebCacheCleaner.clean()
        if kUserStateName.contains("Victoria"){
        webView.load(URLRequest(url: URL(string:  "https://share.hsforms.com/1-TKf7PdBTD-7spKw6PJGYwr78x7?firstname=\(firstName)&lastname=\(lastName)&email=\(email)&phone=\(phoneNumber )&where_would_you_like_to_live_=SANorth&preferred_day_week=&preferred_date=\(prefferedDate)&preferred_time=\(prefferdTime)&description=&i_accept_burbank_s_privacy_policy_and_collection_statement_=&original_marketing_activity=MyPlace App&build_address=\(self.displayHomeData?[0].displayEstateName ?? "")&housename=\(self.displayHomeData?[0].houseName ?? "")-\(self.displayHomeData?[0].houseSize ?? "")")!))
    }else if kUserStateName.contains("South"){
        webView.load(URLRequest(url: URL(string:  "https://share.hsforms.com/1X-_VKq7JSEGwI0VfXd0q5Ar78x7?firstname=\(firstName)&lastname=\(lastName)&email=\(email)&phone=\(phoneNumber )&where_would_you_like_to_live_=SANorth&preferred_day_week=&preferred_date=\(prefferedDate)&preferred_time=\(prefferdTime)&description=&i_accept_burbank_s_privacy_policy_and_collection_statement_=&original_marketing_activity=MyPlace App&build_address=\(self.displayHomeData?[0].displayEstateName ?? "")&housename=\(self.displayHomeData?[0].houseName ?? "")-\(self.displayHomeData?[0].houseSize ?? "")")!))
    }else if kUserStateName.contains("Queensland"){
        webView.load(URLRequest(url: URL(string:  "https://share.hsforms.com/1bpMyjx4USeqYrbYHzKzS0Qr78x7?firstname=\(firstName)&lastname=\(lastName)&email=\(email)&phone=\(phoneNumber )&where_would_you_like_to_live_=SANorth&preferred_day_week=&preferred_date=\(prefferedDate)&preferred_time=\(prefferdTime)&description=&i_accept_burbank_s_privacy_policy_and_collection_statement_=&original_marketing_activity=MyPlace App&build_address=\(self.displayHomeData?[0].displayEstateName ?? "")&housename=\(self.displayHomeData?[0].houseName ?? "")-\(self.displayHomeData?[0].houseSize ?? "")")!))

    }else if kUserStateName.contains("NSW & ACT"){
        webView.load(URLRequest(url: URL(string:  "https://share.hsforms.com/15Wvs5_a9S7WK6kQvEshtNwr78x7?firstname=\(firstName)&lastname=\(lastName)&email=\(email)&phone=\(phoneNumber )&where_would_you_like_to_live_=SANorth&preferred_day_week=&preferred_date=\(prefferedDate)&preferred_time=\(prefferdTime)&description=&i_accept_burbank_s_privacy_policy_and_collection_statement_=&original_marketing_activity=MyPlace App&build_address=\(self.displayHomeData?[0].displayEstateName ?? "")&housename=\(self.displayHomeData?[0].houseName ?? "")-\(self.displayHomeData?[0].houseSize ?? "")")!))
    }

    
        showBackButton()
    }
    
    @IBAction func handleBackButton (_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
