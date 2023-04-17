//
//  MyContactsVC.swift
//  BurbankApp
//
//  Created by Naresh Banavath on 24/03/22.
//  Copyright © 2022 DMSS. All rights reserved.
//



import UIKit
import SideMenu
import SkeletonView

class MyContactsVC: UIViewController {
    enum JobContactNames: Int
    {
        case SiteSupervisor = 0, CRO, SalesConsultant, ElecticalConsultant, ColorConsultant, StaffManager
    }
    @IBOutlet weak var notificationCountLBL: UILabel!
    @IBOutlet weak var profileImgView: UIImageView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var tableView: UITableView!
    var namesarray = ["Site Supervisor","New Home Coordinator","Interior Designer", "Electical Designer", "New Home Consultant"]
    var jobContacts : ContactDetailsStruct?
    
    var menu : SideMenuNavigationController!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
      
        setupProfile()
        sideMenuSetup()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        setupProfile()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.isSkeletonable = true
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showAnimatedGradientSkeleton()
        checkUserLogin1()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func sideMenuSetup()
    {
        let sideMenuVc = UIStoryboard(name: "NewDesignsV4", bundle: nil).instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menu = SideMenuNavigationController(rootViewController: sideMenuVc)
        menu.leftSide = true
        menu.menuWidth = 0.8 * UIScreen.main.bounds.width
        menu.presentationStyle = .menuSlideIn
        
        menu.setNavigationBarHidden(true, animated: false)
        SideMenuManager.default.leftMenuNavigationController = menu
        
        
    }
    
    func setupProfile()
    {
        profileImgView.contentMode = .scaleToFill
        profileImgView.clipsToBounds = true
        profileImgView.layer.cornerRadius = profileImgView.bounds.width/2
        if let imgURlStr = CurrentUservars.profilePicUrl
        {
            profileImgView.image = imgURlStr
        }
        if appDelegate.notificationCount == 0{
            notificationCountLBL.isHidden = true
        }else{
            notificationCountLBL.text = "\(appDelegate.notificationCount)"
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileClick(recognizer:)))
        profileImgView.addGestureRecognizer(tap)
        
    }
    @objc func handleProfileClick (recognizer: UIGestureRecognizer) {
        let vc = UIStoryboard(name: StoryboardNames.newDesing, bundle: nil).instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    @IBAction func didTappedOnMenuIcon(_ sender: UIButton) {
        
        present(menu, animated: true, completion: nil)
    }
    @IBAction func supportBtnTapped(_ sender: UIButton) {
        guard let vc = UIStoryboard(name: StoryboardNames.newDesing5, bundle: nil).instantiateViewController(withIdentifier: "ContactUsVC") as? ContactUsVC else {return}
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Service Calls
   func checkUserLogin1()
     {
         guard  let myPlaceDetails = self.appDelegate.currentUser?.userDetailsArray?[0].myPlaceDetailsArray[0] else {return }
         let region = myPlaceDetails.region ?? ""
         var contractNo : String = ""
     
             if let jobNum = appDelegate.currentUser?.jobNumber, !jobNum.trim().isEmpty
             {
                 contractNo = jobNum
             }
             else {
                 contractNo = appDelegate.currentUser?.userDetailsArray?.first?.myPlaceDetailsArray.first?.jobNumber ?? ""
             }
         let password = myPlaceDetails.password ?? ""
         let userName = myPlaceDetails.userName ?? ""
         let postDic =  ["Region": region, "JobNumber":contractNo, "UserName":userName, "Password":password]
         //callMyPlaceLoginServie(myPlaceDetails)
         let url = URL(string: checkUserLogin())
         var urlRequest = URLRequest(url: url!)
         urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
         urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
         urlRequest.httpMethod = kPost
         do {
             urlRequest.httpBody = try JSONSerialization.data(withJSONObject: postDic, options:[])
         }
         catch {
 #if DEDEBUG
             print("JSON serialization failed:  \(error)")
 #endif
         }
//         appDelegate.showActivity()
         URLSession.shared.dataTask(with: urlRequest, completionHandler: { [weak self](data, response, error) in
//             DispatchQueue.main.async {
//                 self?.appDelegate.hideActivity()
//             }
             print("URL:- \(response?.url) postData :- \(postDic)")
             if error != nil
             {
#if DEDEBUG
                 print("fail to Logout")
#endif
                 return
             }
             if let strData = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
             {
                 print(strData)
                 guard strData == "true" || strData.contains("true") else {return}
                 self?.getContacts()
                 
                 
             }
         }).resume()
     }
   func getContacts()
   {
       var contractNo : String = ""
   
           if let jobNum = appDelegate.currentUser?.jobNumber, !jobNum.trim().isEmpty
           {
               contractNo = jobNum
           }
           else {
               contractNo = appDelegate.currentUser?.userDetailsArray?.first?.myPlaceDetailsArray.first?.jobNumber ?? ""
           }
       NetworkRequest.makeRequest(type: ContactDetailsStruct.self, urlRequest: Router.getClientInfoForContractNumber(jobNumber: contractNo), showActivity: false) {[weak self] (result) in
           
           DispatchQueue.main.async {
               self?.tableView.stopSkeletonAnimation()
               self?.tableView.hideSkeleton()
           }
           
           switch result
           {
           case .success(let data):
              // print(data)
               self?.jobContacts = data
               DispatchQueue.main.async {
                   
                   self?.tableView.reloadData()
                   
               }
               
           case .failure(let err):
               print(err.localizedDescription)
               DispatchQueue.main.async {
                   self?.showAlert(message: "No Data Found")
               }
           }
       }
   }
    
    func getContactNameEmailPhone(rowNo : Int) -> (contactName : String, contactEmail : String, contactPhone : String)
    {
        let jobContact = JobContactNames(rawValue: rowNo)
        var contactName = ""
        var contactEmail = ""
        var contactPhone = ""
        let jobContacts = self.jobContacts
        if jobContact == .SiteSupervisor
        {
            contactName = jobContacts?.siteSupervisor ?? ""
            contactEmail = jobContacts?.siteSupervisorEmail ?? ""
            contactPhone = jobContacts?.siteSupervisorPhone ?? ""
            
        }else if jobContact == .CRO
        {
            contactName = jobContacts?.cro ?? ""
            contactEmail = jobContacts?.croEmail ?? ""
            contactPhone = jobContacts?.croPhone ?? ""
            
        }else if jobContact == .ColorConsultant
        {
            contactName = jobContacts?.newHomeConsultant ?? ""
            contactEmail = jobContacts?.newHomeConsultantEmail ?? ""
            contactPhone = jobContacts?.newHomeConsultantPhone ?? ""
         
        }else if jobContact == .ElecticalConsultant
        {
            contactName = jobContacts?.electricalConsultant ?? ""
            contactEmail = jobContacts?.electricalConsultantEmail ?? ""
            contactPhone = jobContacts?.electricalConsultantPhone ?? ""
        }else if jobContact == .SalesConsultant
        {
            contactName = jobContacts?.interiorDesigner ?? ""
            contactEmail = jobContacts?.interiorDesignerEmail ?? ""
            contactPhone = jobContacts?.interiorDesignerPhone ?? ""
            
        }else if jobContact == .StaffManager
        {
            contactName = jobContacts?.staffManager ?? ""
            //contactEmail = jobContacts?.staffManagerEmail ?? ""
            //contactPhone = jobContacts?.staffManagerPhone ?? ""
        }
        
        
        if contactPhone == "" {
            contactPhone = "NA"
        }
        
        if contactEmail == "" {
            contactEmail = "NA"
        }
        
        return (contactName : contactName , contactEmail : contactEmail, contactPhone : contactPhone)
    }
    
    

}
extension MyContactsVC : UITableViewDelegate, SkeletonTableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return namesarray.count
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "MyContactsTBCell"
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyContactsTBCell") as! MyContactsTBCell
        cell.nameLabel.text = namesarray[indexPath.row]
        let data = getContactNameEmailPhone(rowNo: indexPath.row)
        cell.fullNameLabel.text = data.contactName
        cell.emailLabel.text = data.contactEmail
        cell.mobileLabel.text = data.contactPhone
        
        cell.emailBackGroundView.alpha = 1.0
        cell.emailBackGroundView.isUserInteractionEnabled = true
        
        cell.callBackGroundView.alpha = 1.0
        cell.callBackGroundView.isUserInteractionEnabled = true
        
        if data.contactEmail == "NA" || data.contactEmail == "" {
            cell.emailBackGroundView.alpha = 0.5
            cell.emailBackGroundView.isUserInteractionEnabled = false
        }
        
        if data.contactPhone == "NA" || data.contactPhone == "" {
            cell.callBackGroundView.alpha = 0.5
            cell.callBackGroundView.isUserInteractionEnabled = false
        }
        
        return cell
    }
}
// MARK: - ContactDetails
struct ContactDetailsStruct: Codable {
    let buyerType, homeType, propertyAddress, relocatingSuburb: String?
    let methodOfContact, siteSupervisor, cro, interiorDesigner: String?
    let electricalConsultant, newHomeConsultant: String?
    let staffManager: String?
    let mobileNumber, phoneNumber, email, colorDate: String?
    let jobRegion: String?
    let callback: String?
    let newHomeConsultantEmail, interiorDesignerEmail, electricalConsultantEmail, siteSupervisorEmail: String?
    let croEmail, newHomeConsultantPhone, electricalConsultantPhone, interiorDesignerPhone: String?
    let croPhone, siteSupervisorPhone: String?
    let contractName: [String]?

    enum CodingKeys: String, CodingKey {
        case buyerType, homeType, propertyAddress, relocatingSuburb, methodOfContact, siteSupervisor
        case cro = "CRO"
        case interiorDesigner, electricalConsultant, newHomeConsultant, staffManager, mobileNumber, phoneNumber, email, colorDate, jobRegion, callback
        case newHomeConsultantEmail = "NewHomeConsultantEmail"
        case interiorDesignerEmail = "InteriorDesignerEmail"
        case electricalConsultantEmail = "ElectricalConsultantEmail"
        case siteSupervisorEmail = "SiteSupervisorEmail"
        case croEmail = "CROEmail"
        case newHomeConsultantPhone = "NewHomeConsultantPhone"
        case electricalConsultantPhone = "ElectricalConsultantPhone"
        case interiorDesignerPhone = "InteriorDesignerPhone"
        case croPhone = "CROPhone"
        case siteSupervisorPhone = "SiteSupervisorPhone"
        case contractName
    }
}
