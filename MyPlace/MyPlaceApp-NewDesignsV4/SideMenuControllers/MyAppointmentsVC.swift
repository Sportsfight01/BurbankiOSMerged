//
//  MyAppointmentsVC.swift
//  BurbankApp
//
//  Created by Naresh Banavath on 23/03/22.
//  Copyright © 2022 DMSS. All rights reserved.
//

import UIKit

class MyAppointmentsVC: UIViewController {

    
    @IBOutlet weak var headerLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var notificationCountLBL: UILabel!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    var namesarray = ["Edge Appointment","Electrical Selection","Sign Building Contract","Tender Presentation","PC Inspection"]
    var appointmentDates = ["- -","- -","- -","- -","- -"]
    override func viewDidLoad() {
        super.viewDidLoad()
      //  self.view.backgroundColor = .blue
        // Do any additional setup after loading the view.
    
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        getAppointments()
        tableView.addRefressControl {[weak self] in
            self?.getAppointments()
        }
       // setupProfile()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBarButtons()
        setupProfile()
        headerLeadingConstraint.constant = self.getLeadingSpaceForNavigationTitleImage()
        
    }
    func setupProfile()
    {
        profileImgView.contentMode = .scaleToFill
        profileImgView.clipsToBounds = true
        profileImgView.layer.cornerRadius = profileImgView.bounds.width/2

        if let imgURlStr = CurrentUser.profilePicUrl
        {
           // profileImgView.sd_setImage(with: url, placeholderImage: UIImage(named: "icon_User"))
            profileImgView.image = imgURlStr
        }
        if appDelegate.notificationCount == 0{
            notificationCountLBL.isHidden = true
        }else{
            notificationCountLBL.text = "\(appDelegate.notificationCount)"
        }
        //        profileImgView.addBadge(number: appDelegate.notificationCount)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileClick(recognizer:)))
        profileImgView.addGestureRecognizer(tap)
        
    }
    @objc func handleProfileClick (recognizer: UIGestureRecognizer) {
        //        let vc = UIStoryboard(name: StoryboardNames.newDesing, bundle: nil).instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
                let vc = NotificationsVC.instace(sb: .newDesignV4)
                self.navigationController?.pushViewController(vc, animated: true)

    }
    //MARK: - Service Calls
    
    func getAppointments()
    {
        guard isNetworkReachable else { showAlert(message: checkInternetPullRefresh) {[weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.refreshControl?.endRefreshing()
            }
        }; return}
        let jobAndAuth = APIManager.shared.getJobNumberAndAuthorization()
        guard let jobNumber = jobAndAuth.jobNumber else {debugPrint("Job Number is Null");return}
        let auth = jobAndAuth.auth

       
        NetworkRequest.makeRequestArray(type: ProgressStruct.self, urlRequest: Router.progressDetails(auth: auth, contractNo: jobNumber)) { [weak self](result) in
            switch result
            {
            case .success(let data):
                print(data)
                self?.setupAppointments(progressData: data)
                
            case.failure(let err):
                print(err.localizedDescription)
                DispatchQueue.main.async {
                    self?.showAlert(message: err.localizedDescription)
                }
            }
            DispatchQueue.main.async {
                appDelegate.hideActivity()
                self?.tableView.refreshControl?.endRefreshing()
            }
            
        }
        
    }
    
    //MARK: - Helper Methods
    
    func setupAppointments(progressData : [ProgressStruct])
    {
        for progress in progressData
        {
            switch progress.name
            {
            case "Edge Appointment" , "Colour Selection":
                appointmentDates[0] =  progress.status?.lowercased() == "completed" ? progress.dateactual ?? "- -" : "- -"
            case "Electrical Selection":
                appointmentDates[1] =  progress.status?.lowercased() == "completed" ? progress.dateactual ?? "- -" : "- -"
            case "Sign Building Contract":
                appointmentDates[2] =  progress.status?.lowercased() == "completed" ? progress.dateactual ?? "- -" : "- -"
            case "Tender Presentation":
                appointmentDates[3] =  progress.status?.lowercased() == "completed" ? progress.dateactual ?? "- -" : "- -"
            case "PC INSPECTION":
                appointmentDates[4] =  progress.status?.lowercased() == "completed" ? progress.dateactual ?? "- -" : "- -"
            default:
                break;
                
            }
        }
        print(appointmentDates)
        tableView.reloadData()
    }

}
//MARK: - TableView Delegate & Datasource
extension MyAppointmentsVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return namesarray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {return UITableViewCell()}
        let containerView = cell.contentView.viewWithTag(100)
        if let appointmentTypelb = containerView?.viewWithTag(101) as? UILabel
        {
            appointmentTypelb.text = namesarray[indexPath.row]
        }
        if let appointmentDatelb = containerView?.viewWithTag(102) as? UILabel
        {
            let date = dateFormatter(dateStr: appointmentDates[indexPath.row].components(separatedBy: ".").first ?? "", currentFormate: "yyyy-MM-dd'T'HH:mm:ss", requiredFormate: "d MMMM, yyyy")
            appointmentDatelb.text = date ?? "- -"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 || indexPath.row == 3
        {
            return 0
        }
        return 65
    }
}
