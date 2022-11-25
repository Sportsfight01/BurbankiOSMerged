//
//  MyPlaceDashBoardVC+ViewCycles.swift
//  BurbankApp
//
//  Created by dmss on 26/10/17.
//  Copyright © 2017 DMSS. All rights reserved.
//

import Foundation
import UIKit


extension MyPlaceDashBoardVC
{
//    func foo(_ number: Int) -> Int {
//        func bar(_ number: Int) -> Int {
//            return number * 5
//        }
//
//        return number * bar(3)
//    }
//    func fooooo(_ function: (Int) -> Int) -> Int {
//        return function(function(5))
//    }
//
//    func bar<T: BinaryInteger>(_ number: T) -> T {
//        return number * 3
//    }
//    func square<T>(_ value: T) -> T {
//        return value * value
//    }
    struct Spaceship {
        fileprivate(set) var name = "Serenity"
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()

        support_Help_View.isHidden = true
//        jobNumberBackGroundView.layer.masksToBounds = true
//        jobNoLabel.superview?.roundCorners(corners: [.topLeft, .topRight], radius: 5.0)
        
        /**
         *  Reveal controller to open Left side menu panel with dragging or Tapping on Menu button
         *
         *  @return
         */
        menuCV.isHidden = true
//        menuTabBar.isHidden = true
//        menuTabBar.items?[0].tag = 130
//        menuTabBar.selectedItem = menuTabBar.items?[0]

        showProfileVC()
        if revealViewController() != nil
        {
            notificationsButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControl.Event.touchUpInside)
            
            self.revealViewController().delegate=self
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        menuCV.dataSource = self
        menuCV.delegate = self
        
//        let formatter  = DateFormatter()
//        formatter.dateFormat = "dd MMMM YYYY"
//        let today = Date()
//       // let displayString = formatter.string(from: today)
//        if let weekNum = today.dayNumberOfWeek()
//        {
//           // let weekName = getWeekName(weekNum: weekNum)
//           // dateLabel.text = ""//String(format: "%@ %@", weekName,displayString)
//        }
        
        
        getMyPlaceJobListCount()
        callMyPlaceLoginWebServie()
        fillUserPrimaryJobNumber()
        setUpJobListView()
        
        self.view.bringSubviewToFront(jobInvitationsView)
        
        callGetInvitationsService(false)
        setUpmenuViewForiphoneX()
       // checkAndAddNotificationType()
                
        

        setUpUI ()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        jobNoLabel.superview?.roundCorners(corners: [.topLeft, .topRight], radius: 6.0)
        
        menuCVHeight.constant = 2*heightCell() + 15
//        menuCVBottom.constant = tabbarHeight-5
        
        tableWidth.constant = jobNumberBackGroundView.frame.size.width - jobNumberBackGroundView.frame.size.height
        
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        jobNoLabel.superview?.roundCorners(corners: [.topLeft, .topRight], radius: 3.0)
//    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        
       
        CodeManager.sharedInstance.sendScreenName("dashboard_loading")
        
        
//        menuTabBar.selectedItem = menuTabBar.items?[0]
        updateNotificationIcon()
        fillUserName()
        updateNotificationIconImageView()
    }
    func checkAndAddNotificationType()
    {
        let notificationType = NotificationTypes.getSelectedNotificationType()
        if notificationType == nil
        {
            NotificationTypes.updatedSelectedNotificationType()
        }
    }
    func updateNotificationIcon()
    {
        if jobNumberTextFiled.text == ""
        {
            self.revealViewController().panGestureRecognizer().isEnabled = false
            self.notificationsButton.isHidden = true
        //    self.notificationsCountIcon.isHidden = true
            self.notificationsButtonIcon.isHidden = true
        }else
        {
            self.revealViewController().panGestureRecognizer().isEnabled = true
            self.notificationsButton.isHidden = false
   //         self.notificationsCountIcon.isHidden = false
            self.notificationsButtonIcon.isHidden = false
        }
    }
    func callToGetUserNotifications()
    {
        let userID = appDelegate.currentUser?.userDetailsArray?[0].id ?? -1
        
        ServiceSession.shared.callToGetDataFromServer(appendUrlString: getProfileURL, completionHandler: {(json) in
            
            let jsonDic = json as! NSDictionary
            
            #if DEDEBUG
            print(jsonDic)
            #endif
            
            if let status = jsonDic.object(forKey: "Status") as? Bool
            {
                if status == true
                {
                    if let resultArray = jsonDic.object(forKey: "Result") as? NSDictionary
                    {
                        if (resultArray.value(forKey: "NotificationTypes")as? NSArray) != nil {
                            
                            let notificationArray = (resultArray.value(forKey: "NotificationTypes") as! NSArray).mutableCopy() as! NSMutableArray
                            let photoAdded = (notificationArray.object(at: 0) as! NSDictionary).value(forKey: "IsUserOpted") as! Bool//["IsUserOpted"]
                            let stageCompletion = (notificationArray.object(at: 1) as! NSDictionary).value(forKey: "IsUserOpted") as! Bool//["IsUserOpted"]
                            let stageChanged = (notificationArray.object(at: 2) as! NSDictionary).value(forKey: "IsUserOpted") as! Bool//["IsUserOpted"]
                            NotificationTypes.updatedSelectedNotificationType(photoAdded, stageCompletion, stageChanged: stageChanged)
                            self.updateNotificationIconImageView()
                        }
                    }
                    
                }
            }
        })
    }
    func updateNotificationIconImageView(_ isFromJobAdded: Bool = false)
    {
        if selectedJobNumberRegion == .OLD
        {
            self.notificationsButtonIcon.image = #imageLiteral(resourceName: "Ico-Notification")
            return
        }
        let selectedNotificationType = NotificationTypes.getSelectedNotificationType()
        if selectedNotificationType == nil
        {
            callToGetUserNotifications()
            return
        }
        let photoAdded = selectedNotificationType?.photoAdded
        let stageComplete = selectedNotificationType?.stageComplete
        let stageChange = selectedNotificationType?.stageChange
        if photoAdded == false && stageComplete == false && stageChange == false
        {
            self.notificationsButtonIcon.image = #imageLiteral(resourceName: "Ico-NoAlert") //.setImage(#imageLiteral(resourceName: "Ico-NoAlert"), for: .normal)
            return
        }else
        {
            self.notificationsButtonIcon.image = #imageLiteral(resourceName: "Ico-Notification") //.setImage(#imageLiteral(resourceName: "Ico-Notifications"), for: .normal)
        }
        var photoListCount = 0
        var stageCompleteCount = 0
        var stageChangeCount = 0
      
        var photoAddedUnreadCount = 0
        if let photoAddedList = MyPlaceStoredPhotoInfo.fetchAllStoredPhotoInfo()
        {
            photoAddedList.forEach({ (photoInfo) in
                if photoInfo.isRead == false
                {
                    photoAddedUnreadCount += 1
                }
            })
            photoListCount = photoAddedList.count
//            if photoAddedList.count == 0
//            {
//                photoAddedUnreadCount = 1
//            }
        }else
        {
            photoAddedUnreadCount = 1
        }
        var stageCompletUnreadCount = 0
        if let stageCompleteList = MyPlaceStageCompleteDetails.fetchAllProgressDetails()
        {
            stageCompleteList.forEach({ (progressDetails) in
                if progressDetails.isRead == false
                {
                    stageCompletUnreadCount += 1
                }
            })
//            if stageCompleteList.count == 0
//            {
//                stageCompletUnreadCount = 1
//            }
            stageCompleteCount = stageCompleteList.count
        }else{
            stageCompletUnreadCount = 1
        }
        var stageChangeUnreadCount = 0
        if let stageChangeList = MyPlaceStoredProgressDetails.fetchAllStoredProgressDetails()
        {
            stageChangeList.forEach({ (progressDetails) in
                if progressDetails.currentStatus != progressDetails.status && progressDetails.isRead == false
                {
                    stageChangeUnreadCount += 1
                }
//                if stageChangeList.count == 0
//                {
//                    stageChangeUnreadCount = 1
//                }
                stageChangeCount = stageChangeList.count
            })
        }else
        {
            stageChangeUnreadCount = 1
        }
       
        if (photoAdded == true && photoAddedUnreadCount > 0) || (stageComplete == true && stageCompletUnreadCount > 0) ||  (stageChange == true && stageChangeUnreadCount > 0)
        {
           self.notificationsButtonIcon.image = #imageLiteral(resourceName: "Ico-Notification")
        }else
        {
            self.notificationsButtonIcon.image = #imageLiteral(resourceName: "Ico-NoAlert")
        }
        if photoListCount == 0 && stageCompleteCount == 0 && stageChangeCount == 0
        {
            //means user came first time.
            if isFromJobAdded
            {
                self.notificationsButtonIcon.image = #imageLiteral(resourceName: "Ico-Notification")
            }
            if !isFromLaunchVC
            {
                self.notificationsButtonIcon.image = #imageLiteral(resourceName: "Ico-Notification")
            }
        }
        photoAddedUnreadCount = 0
        stageCompletUnreadCount = 0
        stageChangeUnreadCount = 0
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.revealViewController().panGestureRecognizer().isEnabled = false
    }
    func setUpmenuViewForiphoneX()
    {
        if IS_IPHONE_X
        {
            self.view.constraints.forEach { (constraint) in
                if constraint.identifier == "menuVCLeadingConstraintID" || constraint.identifier == "menuVCTrailingConstraintID"
                {
                    constraint.constant = 12
                }
            }
        }
    }
    func hideJobListTableView()
    {
        jobListTableView.alpha = 0
    }
    func setUpJobListView()
    {
        jobListTableView.dataSource = self
        jobListTableView.delegate = self
        jobListTableView.isScrollEnabled = false
        jobListTableView.alpha = 0
        self.view.bringSubviewToFront(jobListTableView)
        jobListTableViewHeightAnchor.constant = 4 * jobListCellHeight
    }
    func fillUserName()
    {
        let user = appDelegate.currentUser
        if let  userName = (user?.userDetailsArray?[0].fullName)?.capitalized
        {
            welcomeUsername.text = String(format: "%@", userName)
        } else if welcomeUsername.text == "" {
            
            if let emailName = (user?.userDetailsArray?[0].primaryEmail) {
                let name = emailName.components(separatedBy: "@")
                welcomeUsername.text = String(format: "%@", name[0])
            }
        }
    }
    
    func callMyPlaceLoginWebServie()
    {
        let user = appDelegate.currentUser
        if user?.isNewUser == true
        {
            showBlankDashboard()
            AlertManager.sharedInstance.alert("New Burbank Customer")
        }else
        {
                        
            if user?.userDetailsArray?[0].isMyPlaceAccessible == true
            {
                myPlaceLoginWebService()
            }
            else {
                showBlankDashboard()
            }
        }
        
    }
    func fillUserPrimaryJobNumber()
    {
        if appDelegate.currentUser?.userDetailsArray?.count == 0
        {
            jobNumberBackGroundView.alpha = 0
            return
        }
        let userDetails = appDelegate.currentUser?.userDetailsArray?[0]
        if userDetails?.myPlaceDetailsArray.count == 0
        {
            // jobNumberBackGroundView.alpha = 0
            jobNumberTextFiled.placeholder = "No Job"
            jobListDropDownButton.isHidden = true
            return
        }
        let myPlaceDetails = userDetails?.myPlaceDetailsArray[0]
        if let jobNumber = myPlaceDetails?.jobNumber , let region = myPlaceDetails?.region
        {
            jobNumberTextFiled.text = String(format: "%@ (%@)",jobNumber,region)
            
            if appDelegate.netAvailability == false { return }
            
            // Get contact details
            callLogoutServiceForGetContactDetails()
        }
        
    }
    func showProfileVC()
    {
        if isFromLaunchVC == false
        {
            if (UserDefaults.standard.value(forKey: "isShwonProfile") as? Bool) != nil
            {
                //Nothing to do now
                let user = appDelegate.currentUser
                if user?.userDetailsArray?[0].firstName == nil || user?.userDetailsArray?[0].lastName == nil
                {
                    needToShowProfileVC()
                }
            }else
            {
                needToShowProfileVC()
            }
            
        }
    }
    func needToShowProfileVC()
    {
        UserDefaults.standard.setValue(true, forKey: "isShwonProfile")
//        let storyBoard  = UIStoryboard(name: "Main", bundle: nil)
        let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        profileVC.myDelegate = self
        profileVC.modalPresentationStyle = .overCurrentContext
        //profileVC.delegate = self
        present(profileVC, animated: true, completion: nil)
    }
    func showBlankDashboard() {
        
        
        menuCV.isHidden = true
//        menuTabBar.isHidden = true
        //        notificationsButton.isHidden = true
        //        notificationsButtonIcon.isHidden = true
        //        notificationsCountIcon.isHidden = true
        settingsButton.setImage(#imageLiteral(resourceName: "Ico-LogoutBlack"), for: .normal)
        settingsButton.tag = lOGOUTTAG
        UIView.animate(withDuration: 0.75) {
            self.addJobInfoView.alpha = 1
        }
    }
    func updateViewForMyPlace()
    {
        DispatchQueue.main.async {
            self.menuCV.isHidden = false
//            self.menuTabBar.isHidden = false
            self.settingsButton.setImage(#imageLiteral(resourceName: "Ico-Setting"), for: .normal)
            self.settingsButton.tag = self.SETTINGSTAG
            
            self.jobNumberBackGroundView.alpha = 1.0
            self.addJobInfoView.alpha = 0
            self.fillUserPrimaryJobNumber()
            self.getMyPlaceJobListCount()
            self.updateNotificationIcon()
        }
        
    }
    
    @IBAction func settingsButtonTapped(sender: UIButton) {
        if sender.tag == lOGOUTTAG {
            CodeManager.sharedInstance.logOutCurrentUser()
//            _ = self.navigationController?.popToRootViewController(animated: false)
            loadLoginView()
        }
        else {
//            self.performSegue(withIdentifier: "ShowSettingsVC", sender: nil)
            self.tabBarController?.navigationController?.pushViewController(kStoryboardMain_OLD.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC, animated: true)
        }
    }
    //Results-oriented iOS developer with 4.6 years of experience in development of both iPhone and iPad Apps. I make it my goal to create applications with the user in mind, creating applications with a useable and intuitive user interface experience. I also understand the importance of creating highly readable and easily maintainable source code. I am constantly striving to learn new technologies and look to ways to better myself in this rapidly changing industry.
    func myPlaceLoginWebService() {
        
       // ServiceSessionMyPlace.sharedInstance.myDelegate = self
        let user = appDelegate.currentUser
        var enteredUserDetails: MyPlaceDetails!
        if isFromLaunchVC == false //means first time user coming to DashBoard
        {
            if isEmail()
            {
                enteredUserDetails = user?.userDetailsArray?[0].myPlaceDetailsArray[0]
                
            }else
            {
                user?.userDetailsArray?[0].myPlaceDetailsArray.forEach({ (myplaceDetails) in
                    if myplaceDetails.jobNumber == appDelegate.enteredEmailOrJob
                    {
                        enteredUserDetails = myplaceDetails
                        let index = user?.userDetailsArray?[0].myPlaceDetailsArray.firstIndex(of: enteredUserDetails)
                        user?.userDetailsArray?[0].myPlaceDetailsArray.rearrange(from: index!, to: 0)
                        CodeManager.sharedInstance.saveUserInUserDefaults(user!)
                    }
                })
            }
        }else
        {
            enteredUserDetails = user?.userDetailsArray?[0].myPlaceDetailsArray[0]
        }
        
        
        callMyPlaceLoginServie(enteredUserDetails)
    }
    
    // MARK: TextFiled methods
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
    // MARK: TableView DataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobListCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // To display the data in the cell , Name, Designation, MobileNumber, Email Id
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellId", for: indexPath) as! MyPlaceJobListTVCell
        let myPlaceDetails = appDelegate.currentUser?.userDetailsArray?[0].myPlaceDetailsArray[indexPath.row]
        let jobNo = String(format: "%@ (%@)", (myPlaceDetails?.jobNumber)!,(myPlaceDetails?.region)!)
        cell.jobNumberTextFiled.text = jobNo

        if indexPath.row == 0
        {
            cell.selectedImageView.isHidden = false
        }else
        {
            cell.selectedImageView.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        return jobListCellHeight
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        /**** My Appointment *****/
//        appointmentsVICDate = ["","","","",""]
        appointmentsQLDDate = ["","","","",""]
        
        isAppointmentServiceCalled = false
        
        /***** History Log ******/
        
        contactUsVICArray.removeAll()
        contactUsQLDSAArray.removeAll()
        isContactUsServiceCalled = false
        appDelegate.jobContacts = nil

        
        if let myPlaceDetails = appDelegate.currentUser?.userDetailsArray?[0].myPlaceDetailsArray[indexPath.row]
        {
            self.menuCV.isUserInteractionEnabled = false
            callMyPlaceLoginServie(myPlaceDetails)
            jobNumberTextFiled.text = myPlaceDetails.jobNumber
            appDelegate.currentUser?.userDetailsArray?[0].myPlaceDetailsArray.rearrange(from: indexPath.row, to: 0)
            CodeManager.sharedInstance.saveUserInUserDefaults(appDelegate.currentUser!)
            UIView.animate(withDuration: 0.5, animations: {
                self.jobListTableView.alpha = 0
            })
            
        }
        jobListBackGroundViewTapped()
        updateNotificationIcon()
        self.stagesProgressDetailsDic.removeAll()
        self.myPlaceContractDetails = nil
        self.financeTempDictionary = nil

       // CodeManager.sharedInstance.deleteJobNotifications()
        updateNotificationIconImageView()
        UserDefaults.standard.removeObject(forKey: "GET_FAQ_LIST")
    }
   
    //MARK: - InvitationProtocol Methods
    func hideInvitationView()
    {
        UIView.animate(withDuration: 0.5) {
            self.jobInvitationsView.alpha = 0
        }
    }
    func updateUserProfile()
    {
        var postDic: NSDictionary!
        if isEmail()
        {
            postDic = ["Email": appDelegate.enteredEmailOrJob]
        }else
        {
            postDic = ["JobNumber": appDelegate.enteredEmailOrJob]
        }
        
        ServiceSession.shared.callToPostDataToServerWithGivenURLString(urlString: loginURL, postBodyDictionary: postDic, completionHandler: {(json) in
            
            let jsonDic = json as! NSDictionary
            if let status = jsonDic.object(forKey: "Status") as? Bool {
                
                #if DEDEBUG
                print(jsonDic)
                #endif
                
                self.appDelegate.hideActivity()
                if status == true {
                    
                    if let resultDic = jsonDic.object(forKey: "Result") as? [String: Any]
                    {
                        
                        let user = User(dic: resultDic)
                        if user.isSuccess == true
                        {
                            self.appDelegate.currentUser = user//Need To Check whethere we need to fill user data here or not
                            CodeManager.sharedInstance.saveUserInUserDefaults(user)
                            self.callMyPlaceLoginWebServie()
                            
                        }else
                        {
                            // For jobnumbers in which email is not mapped but the success is false
                            AlertManager.sharedInstance.showAlert(alertMessage: (jsonDic["Message"] as? String)!, title: "")
                            return
                        }
                    }
                }
                else {
                    
                    AlertManager.sharedInstance.showAlert(alertMessage: (jsonDic["Message"] as? String)!, title: "")
                    return
                }
                
                
            }
            
        })
        
    }
    
    // MARK: - Response Methods
    func responpseFromRequest(_ data: AnyObject, serviceModule: String) {
        
        //  print(data)
        if serviceModule == "PropertyStatusService" {
            if data as! String == "true"
            {
                // GET service for MyPlace successful login
                isUserHasData = true
                getMyPlaceLoggedinUser()
            }else
            {
                isUserHasData = false
                AlertManager.sharedInstance.alert("Cannot access MyPlace data for this Job")
                return
            }
        }
        else if serviceModule == "GetPropertyStatusDetails" {
           // let dataDic = data as! NSDictionary
            //            if data.count != 0
            //            {
            //                myPLaceConstructionID = dataDic.object(forKey: "ConstructionID") as! String
            //                myPlaceOfficeID = dataDic.object(forKey: "OfficeID")as! String
            //                myPlaceJobID = dataDic.object(forKey: "JobNumber")as! String
            //                myPlaceRegion = dataDic.object(forKey: "Region") as? String
            //                appDelegate.constructionID = myPLaceConstructionID as String!
            //                appDelegate.officeID = myPlaceOfficeID as String!
            //                updateViewForMyPlace()
            //            }
            
        }
        else if serviceModule == "GetMyPlaceProgressDetails" {
            
            myPlaceResponseArray = (data as! NSArray).mutableCopy() as! NSMutableArray
            
            progressTempDictionary = test()
            
            self.performSegue(withIdentifier: "showProgressVC", sender: nil)
            
        }
            
        else if serviceModule == "GetMyPlaceContractDetails" {
            
            appDelegate.myPlaceTempDictionary = (data as! NSDictionary).mutableCopy() as! NSMutableDictionary
            
            self.performSegue(withIdentifier: "showContractVC", sender: nil)
            
            
        }
        else if serviceModule == "GetMyPlacePhotosDetails" {
            
            #if DEDEBUG
            print(data)
            #endif
            
            if data is NSArray {
                photosTempArray = (data as! NSArray).mutableCopy() as? NSMutableArray
            }
            DispatchQueue.main.async {
                self.appDelegate.showActivity()
                
            }
            self.performSegue(withIdentifier: "showStatusVC", sender: nil)
            
        }
        else if serviceModule == "GetMyPlaceDocumentDetails" {
            
            documentTempArray = (data as! NSArray).mutableCopy() as? NSMutableArray
            self.performSegue(withIdentifier: "showDocumentsVC", sender: nil)
        }
        else if serviceModule == "GetMyPlaceFinanceDetails" {
            #if DEDEBUG
            print(data)
            #endif
            financeTempDictionary = (data as! NSDictionary).mutableCopy() as? NSMutableDictionary
            self.performSegue(withIdentifier: "showFinanceVC", sender: nil)
        }
        appDelegate.hideActivity()
        
    }
    
    
    
    // MARK: - Button Actions
    @IBAction func backButtonTapped(sender: AnyObject) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
  
  
    @IBAction func jobListDropDownTapped(sender: AnyObject?)
    {
        
       
        CodeManager.sharedInstance.sendScreenName(dashboard_dropdown_job_arrow_touch)
        
        
        if jobListCount <= 1
        { return }
        var heightFactor = jobListCount
        if jobListCount >= 5
        {
            heightFactor = 5
            jobListTableView.isScrollEnabled = true
        }
        
        jobListTableView.reloadData()
        setUpJobListBackGroundView()
        UIView.animate(withDuration: 0.5, animations: {
            
            self.jobListTableViewHeightAnchor.constant = CGFloat(heightFactor) * self.jobListCellHeight
            self.jobListTableView.changeAlpha()
        })
    }
    func setUpJobListBackGroundView()
    {
        self.view.addSubview(jobListBackGroundView)
        self.view.bringSubviewToFront(self.jobListTableView)
        jobListBackGroundView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        jobListBackGroundView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        jobListBackGroundView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        jobListBackGroundView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    func getMyPlaceJobListCount()
    {
        let userDetails = appDelegate.currentUser?.userDetailsArray?[0]
        if let myplaceDetailArrayCount = userDetails?.myPlaceDetailsArray.count
        {
            jobListCount = myplaceDetailArrayCount
        }
        if jobListCount == 1
        {
            jobListDropDownButton.isHidden = true
        }else
        {
            jobListDropDownButton.isHidden = false
        }
    }
    @IBAction func addJobNumberTapped(sender: AnyObject)
    {
       
        CodeManager.sharedInstance.sendScreenName(dashboard_plus_button_touch)
        
        
        self.view.bringSubviewToFront(self.addJobView)
        UIView.animate(withDuration: 0.25) {
            self.addJobView.alpha = 1.0
        }
    }
    
    @IBAction func invitationsButtonTapped(sender: AnyObject?)
    {
       
        CodeManager.sharedInstance.sendScreenName(dashboard_inivitation_button_touch)
       
        
        hideJobListTableView()
        callGetInvitationsService(true)
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - addjob method
    func hideAddJobView()
    {
        UIView.animate(withDuration: 0.25) {
            self.addJobView.alpha = 0
        }
        self.view.sendSubviewToBack(addJobView)
    }
    func userAddedJobSuccessfully()
    {
        if let user = appDelegate.currentUser
        {
            let lastIndex = (user.userDetailsArray?[0].myPlaceDetailsArray.count)! - 1
            user.userDetailsArray?[0].myPlaceDetailsArray.rearrange(from: lastIndex, to: 0)
            callMyPlaceLoginServie((user.userDetailsArray?[0].myPlaceDetailsArray[0])!)
            CodeManager.sharedInstance.saveUserInUserDefaults(user)
            self.hideAddJobView()
            updateViewForMyPlace()
            updateNotificationIconImageView(true)
        }
        
    }
    // MARK: - GetInvitations method
    func callGetInvitationsService(_ isInvitationButtonTapped: Bool)
    {
        let user = appDelegate.currentUser
        if let email = user?.userDetailsArray?[0].primaryEmail
        {
            if appDelegate.netAvailability == false { return }
            
            let postDic = ["Email":email] as NSDictionary
            ServiceSession.shared.callToPostDataToServerWithGivenURLString(urlString: getCoBurbankInvitationsListURL, postBodyDictionary: postDic) { (json) in
                if let jsonDic = json as? NSDictionary
                {
                    #if DEDEBUG
                    print(jsonDic)
                    #endif
                    if let status = jsonDic.object(forKey: "Status") as? Bool {
                        
                        if status == true
                        {
                            if let resultArray = jsonDic.object(forKey: "Result") as? NSArray
                            {
                                if isInvitationButtonTapped == true
                                {
                                    UIView.animate(withDuration: 0.5) {
                                        self.jobInvitationsView.alpha = 1
                                    }
                                    self.jobInvitationsVC?.loadBurbankListAndShow(resultArray)
                                }else
                                {
                                    //Calling from ViewDidLoad
                                    self.loadBurbankListAndShow(resultArray)
                                }
                                
                            }
                        }
                    }
                }
            }
        }
        
    }
    func loadBurbankListAndShow(_ resultArray: NSArray)
    {
       // var isCoBurbank = false
        if resultArray.count == 0
        {
            return
        }
        for resultDicObj in resultArray
        {
            let resultDic = resultDicObj as! [String: Any]
            let isCoBurbank = resultDic["CoBurbank"] as? Bool
            if isCoBurbank == false
            {
                invitationsButtonTapped(sender: nil)
                return
            }
            // let coBurbankUser = CoBurbankUser(dic: resultDic)
        }
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showProgressVC"
        {
            let destinaton = segue.destination as! ProgressStatusVC
            destinaton.delegateProgress = self
            func fillVICData()
            {
                destinaton.progressDataDictionary = progressTempDictionary.mutableCopy() as? NSMutableDictionary
            }
            func fillQLDSAData()
            {
                destinaton.progressDetailsDic = stagesProgressDetailsDic
            }
            selectedJobNumberRegion == .OLD ? fillVICData() : fillQLDSAData()
           
        }else if segue.identifier == "showStatusVC"
        {
            let destinaton = segue.destination as! SiteStatusVC
            destinaton.imagesArray = photosTempArray.mutableCopy() as? NSMutableArray
            
        }else if segue.identifier == "showContractVC"
        {
            let destinaton = segue.destination as! MyPlaceContractVC
            func fillDataForVLC()
            {
                destinaton.myPlaceContractDictionary = appDelegate.myPlaceTempDictionary.mutableCopy() as? NSMutableDictionary
            }
            func fillDataForQLDSA()
            {
                destinaton.contractDetails = myPlaceContractDetails
            }
            selectedJobNumberRegion == .OLD ? fillDataForVLC() : fillDataForQLDSA()
        }else if segue.identifier == "showFinanceVC"
        {
            let destinaton = segue.destination as! FInanceViewController
            destinaton.financeDataDictionary = financeTempDictionary
            
        }else if segue.identifier == "showDocumentsVC"
        {
            let destinaton = segue.destination as! MyPlaceDocumentVC
            destinaton.delegateDocVc = self
            destinaton.myPlaceDocumentsArray = documentTempArray.mutableCopy() as? NSMutableArray
        }else if segue.identifier == "showMoreOptionsVC"
        {
            _ = segue.destination as! MyPlaceMoreOptionsVC
            // destinaton.delegate = self
            //            destinaton.myPlaceDocumentsArray = documentTempArray.mutableCopy() as! NSMutableArray
        }else if segue.identifier == "showMyPlaceVC"
        {
            _ = segue.destination as! MyPlacePhotosVC
          //  destinaton.constructionID = Int(myPLaceConstructionID)!
        }else if segue.identifier == "showJobInvitationListVC"
        {
            let destinaton = segue.destination as! JobInvitationsVC
            destinaton.delegate = self
            jobInvitationsVC = destinaton
        }else if segue.identifier == "showAddJobNumberVC"
        {
            let destination = segue.destination as! AddJobNumberVC
            destination.delegate = self
        }
        //showMoreOptionsVC
    }
    internal func selectedDocument(_ index: Int) {
        OperationQueue.main.addOperation({
            // Your code here
            self.appDelegate.showActivity()
        })
        
        var extenSionType : String = (documentTempArray.object(at: index) as! NSDictionary).value(forKey: "Extension") as! String
        
        extenSionType = extenSionType.replacingOccurrences(of: " ", with: "")
        
        var urlString = (documentTempArray.object(at: index) as! NSDictionary).value(forKey: "DocumentPath") as! String
        
        urlString = urlString.replacingOccurrences(of: " ", with: "")
        
        self.navigationController?.isNavigationBarHidden = false
        
        let pdfViewController = PDFViewController()
        pdfViewController.pathName = urlString
        pdfViewController.pathExtension = extenSionType
        
        let temp1 = documentTempArray.object(at: index) as AnyObject
        let value1 = temp1.value(forKey: "Title") as! String
        
        _ = documentTempArray.object(at: index) as AnyObject
        let value2 = temp1.value(forKey: "Extension") as! String
        
        pdfViewController.title = NSString(format: "%@%@",value1, value2) as String//By Pranith
        self.navigationController!.pushViewController(pdfViewController, animated: true)
        
        self.appDelegate.hideActivity()
        
    }
    
    internal func selectedItemValues(_ index: Int, valuesArray: NSArray) {
        
        let progressStatusDetailVC = UIStoryboard(name: "Main_OLD", bundle: nil).instantiateViewController(withIdentifier: "ProgressStatusDetailVCIdentifier") as! ProgressStatusDetailVC
        let selectedValueDic = valuesArray[index] as! NSMutableDictionary
        #if DEDEBUG
        print(selectedValueDic)
        #endif
        progressStatusDetailVC.valuesDictionary = selectedValueDic
        if let selectedStage = selectedValueDic["stageName"] as? String
        {
            if let stagepDic = progressTempDictionary.value(forKey: selectedStage) as? NSMutableArray
            {
                progressStatusDetailVC.dataArray = stagepDic
            }
        }
        
        if let stageDic = progressTempDictionary.value(forKey: "Administration") as? NSMutableArray
        {
            progressStatusDetailVC.administrationDataArray = stageDic
        }
        if let frameDic = progressTempDictionary.value(forKey: "Frame Stage") as? NSMutableArray
        {
            progressStatusDetailVC.frameStageDataArray = frameDic
        }
        
        if let lockUpDic = progressTempDictionary.value(forKey: "Lockup Stage") as? NSMutableArray
        {
            progressStatusDetailVC.lockUpStageDataArray = lockUpDic
        }
        if let fixOutStage = progressTempDictionary.value(forKey: "Fixout Stage") as? NSMutableArray
        {
            progressStatusDetailVC.fixingStageDataArray = fixOutStage
        }
        if let completion = progressTempDictionary.value(forKey: "Completion") as? NSMutableArray
        {
            progressStatusDetailVC.finishingStageDataArray = completion
        }
        
        progressStatusDetailVC.allStageValuesArray = valuesArray
        if index == 0
        {
            progressStatusDetailVC.stageName = .adminStage
        }else if index == 1
        {
            progressStatusDetailVC.stageName = .frameStage
        }else if index == 2
        {
            progressStatusDetailVC.stageName = .lockUpStage
        }else if index == 3
        {
            progressStatusDetailVC.stageName = .fixingStage
        }else if index == 4
        {
            progressStatusDetailVC.stageName = .finishStage
        }
        self.navigationController!.pushViewController(progressStatusDetailVC, animated: true)
    }
    
    // MARK: - CollectionView DataSource Methods
    
    func widthCell () -> CGFloat { return (SCREEN_WIDTH - 30 - 30)/3 }

    func heightCell () -> CGFloat {
        var height = (menuCV.frame.size.height-15)/2
        let width = widthCell()
        
        print(log: height)
        print(log: width)
        
        if height > width {
            height = width
        }
        return height
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellID = "CellID"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MyPlaceMenuCVCell
        
        let menuDic = menuArray[indexPath.row]
        cell.menuImageView.image = UIImage(named: menuDic["imageName"]!)
        cell.menuNameLabel.text = menuDic["name"]
        cell.tag = indexPath.row
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: widthCell () , height: heightCell ())
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 15
    }
    
    
    //Mark :- CollectionView Delegate Methods
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isUserHasData == false
        {
            AlertManager.sharedInstance.alert("Cannot access MyPlace data for this Job")
            return
        }
        //        if myPLaceConstructionID == "" || myPlaceOfficeID == "" {
        //            AlertManager.sharedInstance.alert("My Place Construction or Office ID is not available")
        //            return
        //        }
        if indexPath.row == 0 {
            
           
            CodeManager.sharedInstance.sendScreenName(dashboard_progress_icon_button_touch)
        
            
            // GET service for MyPlace Progress Details
            getMyPlaceProgressDetails()
        }
        else if indexPath.row == 1 {
            
           
            CodeManager.sharedInstance.sendScreenName(dashboard_photos_icon_button_touch)
        
            
            // GET service for MyPlace Photos
            self.performSegue(withIdentifier: "showMyPlaceVC", sender: nil)
            //  getMyPlacePhotosDetails(myPLaceConstructionID)
        }
        else if indexPath.row == 2 {
            
           
            CodeManager.sharedInstance.sendScreenName(dashboard_details_icon_touch)
        
            
            // GET service for MyPlace Contract Details
            getMyPlaceContractDetails()
        }
        else if indexPath.row == 3 {
            
           
            CodeManager.sharedInstance.sendScreenName(dashboard_finance_icon_touch)
        
            
            // GET service for MyPlace Finance Details
            getMyPlaceFinanceDetails()
        }
        else if indexPath.row == 4 {
            
           
            CodeManager.sharedInstance.sendScreenName(dashboard_support_help_button_touch)
        
            
            //            // GET service for MyPlace Document Details
            //            getMyPlaceDocumentDetails(myPLaceConstructionID, officeID: myPlaceOfficeID)
           // AlertManager.sharedInstance.alert("Work in progress")
            support_Help_View.superview?.bringSubviewToFront(support_Help_View)
            
            if self.appDelegate.jobContacts != nil {
                
                self.passingSupportHelp()
                
            }
            else {
                callLogoutService(4)
            }
            
        }
        else {
            
           
            CodeManager.sharedInstance.sendScreenName(dashboard_more_button_touch)
        
            
            self.performSegue(withIdentifier: "showMoreOptionsVC", sender: nil)
            
        }
        
        
        
        //        let menuDic = menuArray[indexPath.row]
        //        if let segueIdentifier = menuDic["segueIndetifier"]
        //        {
        //            if segueIdentifier == ""
        //            {
        //                return
        //            }
        //             self.performSegue(withIdentifier: segueIdentifier, sender: nil)
        //        }
        
    }
    
    @IBAction func supportViewTapped(_ sender: UIControl) {
        
       
        CodeManager.sharedInstance.sendScreenName(dashboard_supporthelp_close_icon_touch)
        
        
        support_Help_View.isHidden = true
    }
    
    func callLogoutServiceForGetContactDetails()
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
                
            }
        })
    }

}

var contactUsVICArray:[ContactUsVIC] = []
var contactUsQLDSAArray:[ContactUsQLDSA] = []
var isContactUsServiceCalled = false


//var appointmentsVICDate:[String] = ["","","","",""]
var appointmentsQLDDate:[String] = ["","","","",""]
var isAppointmentServiceCalled = false

