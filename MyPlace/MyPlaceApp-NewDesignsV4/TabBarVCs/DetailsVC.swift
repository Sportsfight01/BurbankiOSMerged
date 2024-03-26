//
//  DetailsVC.swift
//  BurbankApp
//
//  Created by naresh banavath on 24/11/21.
//  Copyright © 2021 DMSS. All rights reserved.
//

import UIKit
import SideMenu

class DetailsVC: UIViewController {
    
    
    @IBOutlet weak var headerLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var notificationCountLBL: UILabel!
    @IBOutlet weak var profileImgView: UIImageView!
    //ProfileDetails
    @IBOutlet weak var emailLb: UILabel!
    @IBOutlet weak var phoneLb: UILabel!
    @IBOutlet weak var nameLb: UILabel!
    //My Build Details
    @IBOutlet weak var jobNumberLb: UILabel!
    @IBOutlet weak var fullJobAddressLb: UILabel!
    @IBOutlet weak var homeDesignLb: UILabel!
    @IBOutlet weak var facadeNameLb: UILabel!
    @IBOutlet weak var contractValueLb: UILabel!
    @IBOutlet weak var superVisorLb: UILabel!
    @IBOutlet weak var newHomeConsultant: UILabel!

    
    var contactDetialsData : ContactDetialsV3?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getContractDetailsV3()
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGestue))
        swipeDownGesture.direction = .down
        view.addGestureRecognizer(swipeDownGesture)
        view.isUserInteractionEnabled = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.setupNavigationBarButtons()
        setupProfile()
        headerLeadingConstraint.constant = self.getLeadingSpaceForNavigationTitleImage()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
      //  self.navigationController?.navigationBar.isHidden = false
    }

    //MARK: - Helper Methods
    @objc func handleSwipeGestue(_ sender : UISwipeGestureRecognizer)
    {
        if sender.state == .ended
        {
            self.getContractDetailsV3()
        }
    }
    func setupProfile()
    {
        profileImgView.contentMode = .scaleToFill
        print("profile bounds",profileImgView.bounds.height , profileImgView.bounds.width)
        profileImgView.layer.cornerRadius = 30
        self.profileImgView.layoutIfNeeded()
        if let imgURlStr = CurrentUser.profilePicUrl
        {
            // profileImgView.sd_setImage(with: url, placeholderImage: UIImage(named: "icon_User"))
            profileImgView.image = imgURlStr
        }
        //        profileImgView.addBadge(number: appDelegate.notificationCount)
       
        let contactDetialsData = APIManager.shared.currentJobDetailsV3
        nameLb.text = contactDetialsData?.clientTitle ?? ""
        
        let emailFirstStr = NSMutableAttributedString(string: "Email ", attributes: [.foregroundColor : UIColor(red: 209/255, green: 211/255, blue: 212/255, alpha: 1.0)])
        let emailAttrStr = NSAttributedString(string: "\(contactDetialsData?.contactDetails.emailAddress ?? "")" , attributes: [.foregroundColor : UIColor.white , .font : UIFont.systemFont(ofSize: 13, weight: .semibold)])
        emailFirstStr.append(emailAttrStr)
        // emailLb.lineBreakMode = .byWordWrapping
        emailLb.attributedText = emailFirstStr
        
        let phoneFirstStr = NSMutableAttributedString(string: "Phone ", attributes: [.foregroundColor : UIColor(red: 209/255, green: 211/255, blue: 212/255, alpha: 1.0)])
        let phoneAttrStr = NSAttributedString(string: "\(contactDetialsData?.contactDetails.mobilePhone ?? "")" , attributes: [.foregroundColor : UIColor.white , .font : UIFont.systemFont(ofSize: 13, weight: .semibold)])
        phoneFirstStr.append(phoneAttrStr)
        phoneLb.attributedText = phoneFirstStr
        if appDelegate.notificationCount == 0{
            notificationCountLBL.isHidden = true
        }else{
            notificationCountLBL.text = "\(appDelegate.notificationCount)"
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileClick(recognizer:)))
        profileImgView.addGestureRecognizer(tap)
        
    }
    @objc func handleProfileClick (recognizer: UIGestureRecognizer) {
        let vc = NotificationsVC.instace(sb: .newDesignV4)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    //MARK:- Helper Methods
    func setupData(data : ContactDetialsV3)
    {
        
        
        //My Build Details
        jobNumberLb.text = "\(data.contractNumber ?? "--")"
        //  print(data.lotaddress)
        fullJobAddressLb.text = data.lotAddress.address.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\r", with: " ")
        homeDesignLb.text = "\(data.houseType.houseName)"
        facadeNameLb.text = "\(data.facade.packageName )"
//        contractValueLb.text = dollarCurrencyFormatter(value: Double(data.contractvalue ?? 0))
//        superVisorLb.text = data.supervisor ?? "--"
//        newHomeConsultant.text = data.clientliaison ?? "--"
        //        siteStartDateLb.text = data.sitestartdate
    }

    @IBAction func supportBtnTapped(_ sender: UIButton) {
        let vc = ContactUsVC.instace(sb: .supportAndHelp)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Service Calls
    func getContractDetailsV3(){
        guard isNetworkReachable else { showAlert(message: checkInternetPullRefresh) {[weak self] _ in
            
        }; return}
        appDelegate.showActivity()
        APIManager.shared.getMyDetails {[weak self] result in
            DispatchQueue.main.async {
                appDelegate.hideActivity()
            }
            guard let self else { return }
            switch result{
            case .success(let myDetails):
                DispatchQueue.main.async {
                    self.contactDetialsData = myDetails
                    self.setupData(data: myDetails)
//                    self.setupSerivceData(notes: notes)
                }
            case .failure(let err):
                debugPrint(err.localizedDescription)
                DispatchQueue.main.async {
                    self.showAlert(message: err.description)
                    return}
                }
            }
        
        
    }
    
    
    
    func getContractDetails()
    {
        guard isNetworkReachable else { showAlert(message: checkInternetPullRefresh); return}
        let jobAndAuth = APIManager.shared.getJobNumberAndAuthorization()
        guard let jobNumber = jobAndAuth.jobNumber else {debugPrint("Job Number is Null");return}
        let auth = jobAndAuth.auth
        
        NetworkRequest.makeRequest(type: ContractDetailsStruct.self, urlRequest: Router.contractDetails(auth: auth, contractNo: jobNumber)) { [weak self](result) in
            switch result{
            case .success(let data): break
//                self?.setupData(data: data)
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    
}


// MARK: - Contract Details struct
struct ContractDetailsStruct: Decodable {
    let id: Int?
    let job, surname, clienttitle, contactname: String?
    let contactphone, contactemail: String?
    let contactagent: Bool?
    let agentname, agentcompany, agentphone, agentemail: String?
    let lotaddress, lotno: String?
    let lotstreetno, lotunitno, lotlevelno: String?
    let lotstreet1: String?
    let lotstreet2: String?
    let lotsuburb, lotstate, lotpostcode: String?
    let directions, clientadiseddate, handoverdate: String?
    let businessunit, brand, salesperson, clientliaison: String?
    let constructionliaison, supervisor: String?
    let housetype, facade, jobstatuscode, jobstatus: String?
    let contractvalue: Int?
    let sitestartdate, homephone, homephone1, homephone2: String?
    let workphone, workphone1, workphone2, contractType: String?
    let salesContact: SalesContact?
}

// MARK: - SalesContact
struct SalesContact: Codable {
    let name, firstName, surname: String?
    let profilePhoto: ProfilePhoto?
}

// MARK: - ProfilePhoto
struct ProfilePhoto: Codable {
    let original, thumb: String?
}


// MARK: - Contact Details Struct for V3

struct ContactDetialsV3 : Codable{
    let contractNumber : String
    let facade : facadeDetails
    let lotAddress : LotDetails
    let houseType : houseTypeDetails
}
struct houseTypeDetails : Codable{
    let houseName : String
}
struct facadeDetails : Codable{
    let packageName : String
}
struct LotDetails : Codable{
    let lotNo : String
    let streetNo : String
    let address : String
    let street1 : String
    let suburb : String
    let state : String
    let postCode : String
}
