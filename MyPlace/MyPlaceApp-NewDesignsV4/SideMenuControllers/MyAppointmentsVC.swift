//
//  MyAppointmentsVC.swift
//  BurbankApp
//
//  Created by Naresh Banavath on 23/03/22.
//  Copyright © 2022 DMSS. All rights reserved.
//

import UIKit

class MyAppointmentsVC: UIViewController {

    
    @IBOutlet weak var notificationCountLBL: UILabel!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    var namesarray = ["Edge Appointment","Electrical Selection","Sign Building Contract","Tender Presentation","PC Inspection"]
    var appointmentDates = ["- -","- -","- -","- -","- -"]
    override func viewDidLoad() {
        super.viewDidLoad()
      //  self.view.backgroundColor = .blue
        // Do any additional setup after loading the view.
        self.setupNavigationBarButtons(notificationIcon: false)
        tableView.delegate = self
        tableView.dataSource = self
        getAppointments()
       // setupProfile()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupProfile()
    }
    func setupProfile()
    {
        profileImgView.contentMode = .scaleToFill
        profileImgView.clipsToBounds = true
        profileImgView.layer.cornerRadius = profileImgView.bounds.width/2
//        if let imgURlStr = CurrentUservars.profilePicUrl , let url = URL(string: imgURlStr)
//        {
//           // profileImgView.sd_setImage(with: url, placeholderImage: UIImage(named: "icon_User"))
//            profileImgView.downloaded(from: url)
//        }
        
        if let imgURlStr = CurrentUservars.profilePicUrl
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
        let vc = UIStoryboard(name:StoryboardNames.newDesing, bundle: nil).instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
        self.navigationController?.pushViewController(vc, animated: true)

    }
    //MARK: - Service Calls
    
    func getAppointments()
    {
            var currenUserJobDetails : MyPlaceDetails?
            currenUserJobDetails = (UIApplication.shared.delegate as! AppDelegate).currentUser?.userDetailsArray![0].myPlaceDetailsArray[0]
            if selectedJobNumberRegionString == ""
            {
                let jobRegion = currenUserJobDetails?.region
                selectedJobNumberRegionString = jobRegion!
                print("jobregion :- \(jobRegion)")
            }
            let authorizationString = "\(currenUserJobDetails?.userName ?? ""):\(currenUserJobDetails?.password ?? "")"
            let encodeString = authorizationString.base64String
            let valueStr = "Basic \(encodeString)"
            let contractNo = currenUserJobDetails?.jobNumber ?? ""
            
            
            NetworkRequest.makeRequestArray(type: ProgressStruct.self, urlRequest: Router.progressDetails(auth: valueStr, contractNo: contractNo)) { [weak self](result) in
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
          let date = dateFormatter(dateStr: appointmentDates[indexPath.row], currentFormate: "yyyy-MM-dd'T'HH:mm:ss", requiredFormate: "d MMMM, yyyy")
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
