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

class MyContactsVC: BaseProfileVC {
    enum JobContactNames: Int
    {
        case SiteSupervisor = 0, CRO, SalesConsultant, ElecticalConsultant, ColorConsultant, StaffManager
    }
//    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var tableView: UITableView!
    var namesarray = ["Site Manager","Customer Care Coordinator","Interior Designer", "Electrical Designer", "New Home Consultant"]
    var jobContacts : ContactDetailsStruct?
    
   // var menu : SideMenuNavigationController!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isSkeletonable = true
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        
         checkUserLogin1()
        tableView.addRefressControl {[weak self] in
            self?.checkUserLogin1()
        }
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        setupTitles()
    }
    func setupTitles()
    {
        profileView.titleLb.text = "MyContacts"
        profileView.helpTextLb.text = "Find all the contacts related to your home build."
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
     
      
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
      
    }
    @IBAction func didTappedOnMenuIcon(_ sender: UIButton) {
        
        present(menu, animated: true, completion: nil)
    }
//    @IBAction func supportBtnTapped(_ sender: UIButton) {
//        guard let vc = ContactUsVC
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    
    //MARK: - Service Calls
   func checkUserLogin1()
     {
     
         let jobAndAuth = APIManager.shared.getJobNumberAndAuthorization()
         guard let jobNumber = jobAndAuth.jobNumber else {debugPrint("Job Number is Null");return}
         let password = APIManager.shared.currentJobDetails?.password ?? ""
         let userName = APIManager.shared.currentJobDetails?.userName ?? ""
         let region = APIManager.shared.currentJobDetails?.region ?? ""
         
         let postDic =  ["Region": region, "JobNumber":jobNumber, "UserName":userName, "Password":password]
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
         guard isNetworkReachable else { showAlert(message: "Check your internet and pull to refresh again") {[weak self] _ in
             DispatchQueue.main.async {
                appDelegate.hideActivity()
                 self?.tableView.refreshControl?.endRefreshing()
             }
         }
        
             return}
         tableView.showAnimatedGradientSkeleton()
         URLSession.shared.dataTask(with: urlRequest, completionHandler: { [weak self](data, response, error) in

             print("URL:- \(response?.url) postData :- \(postDic)")
             if error != nil
             {
                 DispatchQueue.main.async {
                     self?.tableView.stopSkeletonAnimation()
                     self?.view.hideSkeleton()
                 }
                 return
             }
             if let strData = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
             {
                 print(strData)
                 guard strData == "true" || strData.contains("true") else {
                     DispatchQueue.main.async {
                         self?.tableView.stopSkeletonAnimation()
                         self?.view.hideSkeleton()
                     };return}
                 
                 self?.getContacts()
                
                 
             }
             DispatchQueue.main.async {
                appDelegate.hideActivity()
                 self?.tableView.refreshControl?.endRefreshing()
             }
             
         }).resume()
     }
   func getContacts()
   {
       let jobAndAuth = APIManager.shared.getJobNumberAndAuthorization()
       guard let jobNumber = jobAndAuth.jobNumber else {debugPrint("Job Number is Null");return}
       
       NetworkRequest.makeRequest(type: ContactDetailsStruct.self, urlRequest: Router.getClientInfoForContractNumber(jobNumber: jobNumber), showActivity: false) {[weak self] (result) in
           
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
        //font setup
        cell.setupFonts()
        //
        cell.nameLabel.text = namesarray[indexPath.row]
        let data = getContactNameEmailPhone(rowNo: indexPath.row)
        cell.fullNameLabel.text = data.contactName.trim() == "" ? "NA" : data.contactName
        cell.emailLabel.text = data.contactEmail
        cell.mobileLabel.text = data.contactPhone
        [cell.emailBackGroundView.subviews.first, cell.callBackGroundView.subviews.first].forEach { view in
            view?.isUserInteractionEnabled = true
            view?.tintColor = APPCOLORS_3.Orange_BG
        }
//        cell.emailBackGroundView.alpha = 1.0
//        cell.emailBackGroundView.isUserInteractionEnabled = true
//
//        cell.callBackGroundView.alpha = 1.0
//        cell.callBackGroundView.isUserInteractionEnabled = true
        
        if data.contactEmail == "NA" || data.contactEmail == "" {
            cell.emailBackGroundView.subviews.first?.tintColor = APPCOLORS_3.LightGreyDisabled_BG
            cell.emailBackGroundView.isUserInteractionEnabled = false
        }
        
        if data.contactPhone == "NA" || data.contactPhone == "" {
            cell.callBackGroundView.subviews.first?.tintColor = APPCOLORS_3.LightGreyDisabled_BG
            cell.callBackGroundView.isUserInteractionEnabled = false
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
