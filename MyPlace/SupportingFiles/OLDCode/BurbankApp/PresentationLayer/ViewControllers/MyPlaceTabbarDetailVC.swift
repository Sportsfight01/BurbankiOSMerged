//
//  MyPlaceTabbarDetailVC.swift
//  BurbankApp
//
//  Created by Mohan Kumar on 27/04/17.
//  Copyright © 2017 DMSS. All rights reserved.
//

import UIKit

class MyPlaceTabbarDetailVC: BurbankAppVC/*MyPlaceWithTabBarVC*/,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource  {
    
    
    @IBOutlet weak var tabbarMenuCV: UICollectionView!

    @IBOutlet weak var contactsTable: UITableView!

    @IBOutlet weak var headerNameLabel: UILabel!
    
    var menuarray : NSMutableArray!
    
    var namesarray = ["Site Supervisor","New Home Coordinator","Interior Designer", "Electical Designer", "New Home Consultant"]
    
    var selectedTag : Int!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let contactsCellHeight:CGFloat = 106 //SCREEN_HEIGHT * 0.16
    lazy var customView: UIView! = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCustomeViewTapped)))
        return view
    }()
    @objc func handleCustomeViewTapped()
    {
        if selectedTag == 125
        {
            let alertVC = UIAlertController(title: "Feedback", message: "To complete survey, you have to login to myplace and you will be redirected to myplace portal. Proceed?", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            alertVC.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action) in
                self.openBurbankWebPortal()
            }))
            self.present(alertVC, animated: true, completion: nil)
            
        }
    }
    func openBurbankWebPortal()
    {
        var urlString = "https://www.burbank.com.au/victoria/myplace/"
        if selectedJobNumberRegion == .QLD
        {
            urlString = "https://www.burbank.com.au/myplace/?region=qld"
        }else if selectedJobNumberRegion == .SA
        {
            urlString = "https://www.burbank.com.au/myplace/?region=sa"
        }else if selectedJobNumberRegion == .NSW
        {
            urlString = "https://www.burbank.com.au/myplace/?region=nsw"
        }
        guard let url = URL(string: urlString) else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    var customLabel: UILabel! = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = ProximaNovaSemiBold(size: 18.0)
        return label
    }()
    var surveyImageView: UIImageView! = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "Ico-Survey")
        return imageView
    }()
    func setUpCustomView()
    {
        self.view.addSubview(customView)
        customView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        customView.centerYAnchor.constraint(equalTo: contactsTable.centerYAnchor, constant: 0).isActive = true
        let height = SCREEN_HEIGHT * 0.225
        customView.heightAnchor.constraint(equalToConstant: height).isActive = true
        customView.widthAnchor.constraint(equalToConstant: height).isActive = true
        
        customView.layer.cornerRadius = height/2
        customView.layer.masksToBounds = true
    }
    func setUpSurveyImageView()
    {
        self.view.addSubview(surveyImageView)
        surveyImageView.centerXAnchor.constraint(equalTo: self.customView.centerXAnchor, constant: 0).isActive = true
        surveyImageView.centerYAnchor.constraint(equalTo: self.customView.centerYAnchor, constant: -10).isActive = true
        surveyImageView.heightAnchor.constraint(equalTo: self.customView.heightAnchor, multiplier: 0.455, constant: 0).isActive = true
        surveyImageView.widthAnchor.constraint(equalTo: surveyImageView.heightAnchor, constant: 0).isActive = true
    }
    func setUpCustomLabel()
    {
        self.customView.addSubview(customLabel)
        customLabel.centerXAnchor.constraint(equalTo: self.customView.centerXAnchor, constant: 0).isActive = true
        customLabel.topAnchor.constraint(equalTo: self.surveyImageView.bottomAnchor, constant: 10).isActive = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabbarMenuCV.isHidden = true
        contactsTable.isHidden = true
        setUpCustomView()
        setUpSurveyImageView()
        setUpCustomLabel()
        surveyImageView.alpha = 0
        
        setAppearanceFor(view: headerNameLabel, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_LABEL_HEADING(size: FONT_18))
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if selectedTag == 124 {
            
            headerNameLabel.text = "My Appointments"
            //  menuarray = ["View My Appointments","Book An Appointment"]
            //            menuTabBar.selectedItem = menuTabBar.items?[1]
            contactsTable.isHidden = true
            customLabel.text = "View My Appointments"
            tabbarMenuCV.isHidden = false
            
            
        }
        else if selectedTag == 125 {
            
            headerNameLabel.text = "Help Us Improve"
            //menuarray = ["Provide a Feedback","Complete a survey"]
            //            menuTabBar.selectedItem = menuTabBar.items?[1]
            contactsTable.isHidden = true
            customLabel.text = "Survey"
            surveyImageView.alpha = 1
            //tabbarMenuCV.isHidden = false
            
        }
        else if selectedTag == 127 {
            
            headerNameLabel.text = "Contacts"
            //            menuTabBar.selectedItem = menuTabBar.items?[3]
            tabbarMenuCV.isHidden = true
            
            customView.isHidden = true
            menuarray = []
            contactsTable.constraints.forEach({ (constraint) in
                if constraint.identifier == "HeightConstraintID"
                {
                    constraint.constant = CGFloat(namesarray.count) * contactsCellHeight
                }
            })
            if appDelegate.jobContacts == nil
            {
                contactsTable.isHidden = true
                callLogoutService()
            }
            else {
                contactsTable.isHidden = false
            }
        }
        //tabbarMenuCV.dataSource = self
        // tabbarMenuCV.delegate = self
        
        contactsTable.isHidden = true
        
        
        if selectedTag == 127
        {
            
            if appDelegate.jobContacts != nil {
                contactsTable.isHidden = false
            }
            
            self.reloadContactsTable()
        }
    }
    
    
    func callLogoutService()
    {
        if !ServiceSession.shared.checkNetAvailability()
        {
            return
        }
        let logoutURL = "\(getMyPlaceURL())login/logout/"
        var urlRequest = URLRequest(url: URL(string: logoutURL)!)
        urlRequest.httpMethod = kGet
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            // print(data,response,error)
            if error != nil
            {
                #if DEDEBUG
                print("fail to Logout")
                #endif
                
                return
            }
            if let httpResponse = response as? HTTPURLResponse
            {
                #if DEDEBUG
                print("--->",httpResponse.statusCode)
                #endif
                
                DispatchQueue.main.async {
                    if httpResponse.statusCode == 200
                    {
                        //sucess
                       self.callToCheckUser()
                    }
                }
            }
        }).resume()
    }
    func callToCheckUser()
    {
        guard  let myPlaceDetails = self.appDelegate.currentUser?.userDetailsArray?[0].myPlaceDetailsArray[0] else {return }
        let region = myPlaceDetails.region ?? ""
        let jobNumber = myPlaceDetails.jobNumber ?? ""
        let password = myPlaceDetails.password ?? ""
        let userName = myPlaceDetails.userName ?? ""
        // ServiceSessionMyPlace.sharedInstance.serviceConnection("POST", url: url, postBodyDictionary: ["Region": region, "JobNumber":jobNumber, "UserName":userName, "Password":password], serviceModule:"PropertyStatusService")
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
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if error != nil
            {
                #if DEDEBUG
                print("fail to Logout")
                #endif
                
                return
            }
            if let strData = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            {
                DispatchQueue.main.async {
                    if strData == "true"
                    {
                        //  self.getMyPlaceLoggedinUser()
                        self.callToGetDataFromUser()
                    }
                }
                
            }
        }).resume()
    }
    
    func callToGetDataFromUser()
    {
        ServiceSession.shared.callToGetDataFromServerWithGivenURLString(getLoggedInUser(), withactivity: false) { (json) in
            if let jsonDic = json as? [String: Any]
            {
                let myPlaceStatusDetails = MyPlaceStatusDetails(dic: jsonDic)
                let jobNumber = myPlaceStatusDetails.jobNumber

                
                self.perform(#selector(self.getContractDetails), with: jobNumber, afterDelay: 0.1)
                
            }
        }
//            MyPlaceServiceSession.shared.callToGetDataFromServer(getLoggedInUser(), successBlock: { (json, response) in
//
//                if let jsonDic = json as? [String: Any]
//                {
//                    let myPlaceStatusDetails = MyPlaceStatusDetails(dic: jsonDic)
//                    let jobNumber = myPlaceStatusDetails.jobNumber
//                    DispatchQueue.main.async(execute: {
//                        self.appDelegate.showActivity()
//                    })
//                    ServiceSession.shared.callToGetDataFromServerWithGivenURLString(clientInfoForContract(jobNumber), withactivity: true, completionHandler: { (json) in
//                        if let jsonDic =  json as? [String: Any]
//                        {
//                            self.appDelegate.jobContacts = JobContacts(jsonDic)
//                            self.reloadContactsTable()
//                        }
//                    })
////                    MyPlaceServiceSession.shared.callToGetDataFromServer(clientInfoForContract(jobNumber), successBlock: { (json, response) in
////                        //
////                        if let jsonDic =  json as? [String: Any]
////                        {
////                            self.appDelegate.jobContacts = JobContacts(jsonDic)
////                            self.reloadContactsTable()
////                        }
////
////                    }, errorBlock: { (error, isJSON) in
////                        //
////                    })
//                }
//            }, errorBlock: { (error, isJSONError) in
//                //
//                if isJSONError == false
//                {
//                    AlertManager.sharedInstance.alert((error?.localizedDescription)!)
//                }else
//                {
//                }
//            })
    }
    @objc func getContractDetails(_ jobNumber: String)
    {
        #if DEDEBUG
        print(clientInfoForContract(jobNumber))
        #endif
        
        ServiceSession.shared.callToGetDataFromServerWithGivenURLString(clientInfoForContract(jobNumber), withactivity: true, completionHandler: { (json) in
            if let jsonDic =  json as? [String: Any]
            {
                #if DEDEBUG
                print(jsonDic)
                #endif
                
                self.appDelegate.jobContacts = JobContacts(jsonDic)
                self.contactsTable.isHidden = false
                self.reloadContactsTable()
            }
        })
    }
    fileprivate func reloadContactsTable()
    {
        
         contactsTable.reloadData()
    }
    // MARK: - Button Actions
    @IBAction func backButtonTapped(sender: AnyObject) {
        
        if self.navigationController?.viewControllers.count == 1 {
            
            self.tabBarController?.selectedIndex = 0
        }else {
            
            self.navigationController?.popViewController(animated: true)
        }
        
//        for vc: UIViewController in (navigationController?.viewControllers)! {
//            if (vc.isKind(of: MyPlaceDashBoardVC.self)) {
//                navigationController?.popToViewController(vc, animated: false)
//            }
//        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - CollectionView DataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return menuarray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellID = "CellID"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MyPlaceTabbarDetailCVCell

        cell.menuNameLabel.text = menuarray.object(at: indexPath.row) as? String
        
        return cell
    }
    //Mark :- CollectionView Delegate Methods
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        AlertManager.sharedInstance.alert("Work in Progress")
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = collectionView.frame.size.height
        let width = collectionView.frame.size.width/2
        return CGSize(width: width, height: height)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.separatorStyle = .none
        return namesarray.count
    }
    enum JobContactNames: Int
    {
        case SiteSupervisor = 0, CRO, SalesConsultant, ElecticalConsultant, ColorConsultant, StaffManager
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsCell")as! MyPlaceContactsCell
        cell.selectionStyle = .none
        let mutableText = NSMutableAttributedString(string: "\(namesarray[indexPath.row])", attributes: [:])
        let jobContact = JobContactNames(rawValue: indexPath.row)
        var contactName = ""
        var contactEmail = ""
        var contactPhone = ""
        let jobContacts = appDelegate.jobContacts
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
            contactName = jobContacts?.colourConsultant ?? ""
            contactEmail = jobContacts?.colourConsultantEmail ?? ""
            contactPhone = jobContacts?.colourConsultantPhone ?? ""
        }else if jobContact == .ElecticalConsultant
        {
            contactName = jobContacts?.electicalConsultant ?? ""
            contactEmail = jobContacts?.electicalConsultantEmail ?? ""
            contactPhone = jobContacts?.electicalConsultantPhone ?? ""
        }else if jobContact == .SalesConsultant
        {
            contactName = jobContacts?.salesConsultant ?? ""
            contactEmail = jobContacts?.salesConsultantEmail ?? ""
            contactPhone = jobContacts?.salesConsultantPhone ?? ""
        }else if jobContact == .StaffManager
        {
            contactName = jobContacts?.staffManager ?? ""
            contactEmail = jobContacts?.staffManagerEmail ?? ""
            contactPhone = jobContacts?.staffManagerPhone ?? ""
        }
        
        
        if contactPhone == "" {
            contactPhone = "NA"
        }
        
        if contactEmail == "" {
            contactEmail = "NA"
        }
        
        
//        mutableText.append(NSAttributedString(string: "\nName: \(contactName)", attributes: [NSFontAttributeName: ProximaNovaRegular(size: 14)]))
        
//        cell.callBackGroundView.alpha = 0
//        if contactEmail.isValidEmail()
//        {
//            cell.callBackGroundView.alpha = 1
//        }

        cell.nameLabel.attributedText = mutableText
        cell.fullNameLabel.text = contactName
        cell.emailLabel.text = contactEmail
        cell.mobileLabel.text = contactPhone
        
        cell.emailBackGroundView.alpha = 1.0
        cell.emailBackGroundView.isUserInteractionEnabled = true
        
        cell.callBackGroundView.alpha = 1.0
        cell.callBackGroundView.isUserInteractionEnabled = true
        
        if contactEmail == "NA" || contactEmail == "" {
            cell.emailBackGroundView.alpha = 0.5
            cell.emailBackGroundView.isUserInteractionEnabled = false
        }
        
        if contactPhone == "NA" || contactPhone == "" {
            cell.callBackGroundView.alpha = 0.5
            cell.callBackGroundView.isUserInteractionEnabled = false
        }
        
//        cell.nameLabel.text = contactName
        
    //    mutableText.append(NSAttributedString(string: "\nEmail: \(contactEmail)", attributes: [NSFontAttributeName: ProximaNovaRegular(size: 14)]))
//        cell.nameLabel.attributedText = mutableText
        return cell
    }//HeightConstraintID
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return contactsCellHeight
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
class MyPlaceTabbarDetailCVCell: BurbankAppCVCell
{
    @IBOutlet weak var blackBackGroundView: UIView!
    @IBOutlet weak var menuNameLabel: UILabel!
    
    override func draw(_ rect: CGRect)
    {
        super.draw(rect)
        
        blackBackGroundView.layer.cornerRadius =  120/2
        blackBackGroundView.layer.masksToBounds = true

    }
    
    override func prepareForReuse()
    {
        super.prepareForReuse()
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
//        setAppearanceFor(view: appointmentType, backgroundColor: COLOR_CLEAR, textColor: COLOR_WHITE, textFont: FONT_LABEL_SUB_HEADING(size: FONT_16))
//        setAppearanceFor(view: appointmentDate, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_LABEL_BODY(size: FONT_13))

    }
    
}
