//
//  SettingsVC.swift
//  BurbankApp
//
//  Created by Mohan Kumar on 25/04/17.
//  Copyright © 2017 DMSS. All rights reserved.
//

import UIKit


class SettingsVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate,profileScreenProtocol {
    
    
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var btnSave : UIButton!

    @IBOutlet weak var profileHeading : UILabel!
    @IBOutlet weak var btnEdit : UIButton!
    @IBOutlet weak var usernameLabel : UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var resetPasswordLabel : UILabel!

    @IBOutlet weak var btnProfile: UIButton!
    
    @IBOutlet weak var settingsTable : UITableView!
    
    @IBOutlet weak var profilePicImage: UIImageView!

    var titleString : NSString!
    
    var appDelegate : AppDelegate!
    
    
    var notificationArray = NSMutableArray()
    
    var aboutUsBool = false
    var termsBool = false
    var privacyBool = false

    var oldPassword = ""

    var notificationChanges = false

    let sectionTitles  = ["Notifications", "About Burbank App", "         "]
    
    let items = [["When new photos added", "Changes in construction status", "Stage Completion"], ["What is Burbank App", "Version", "Terms of Use", "Privacy Policy"], ["Logout"]]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        appDelegate=UIApplication.shared.delegate as? AppDelegate
        postDataToServerForGettingUserProfile()
        viewSetUp()
    
        
    }
    
    override  func viewWillAppear(_ animated: Bool) {
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - View
    func viewSetUp () {
     
        setAppearanceFor(view: titleLabel, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_HEADING(size: FONT_18))

        setAppearanceFor(view: btnSave, backgroundColor: APPCOLORS_3.Orange_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_SUB_HEADING(size: FONT_14))
        
        setAppearanceFor(view: profileHeading, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Orange_BG, textFont: FONT_LABEL_HEADING(size: FONT_14))

        setAppearanceFor(view: usernameLabel, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_BODY(size: FONT_12))
        setAppearanceFor(view: emailLabel, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_BODY(size: FONT_12))
        setAppearanceFor(view: resetPasswordLabel, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_BODY(size: FONT_12))
        
    }
    
    
    // MARK: - ShowProfile
    func showProfileVC()
    {
        let storyBoard  = UIStoryboard(name: "Main_OLD", bundle: nil)
        let profileVC = storyBoard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        profileVC.delegate = self
        profileVC.modalPresentationStyle = .overCurrentContext
        present(profileVC, animated: true, completion: nil)
    }
     // MARK: - ProfileScreem
    func profileScreenDismissed()
    {
        let user = appDelegate.currentUser
        if let  userName = (user?.userDetailsArray?[0].fullName)?.capitalized
        {
            usernameLabel.text = String(format: "%@", userName)
        }
    }
    // MARK: - Button Actions
    @IBAction func backButtonTapped(sender: AnyObject) {
        
        if notificationChanges == true {
            let alertController = UIAlertController(title: "", message: "Changes will not applied", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                self.notificationChanges = false
                _ = self.navigationController?.popViewController(animated: true)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
                UIAlertAction in
                self.notificationChanges = true
            }
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else {
            _ = self.navigationController?.popViewController(animated: true)

        }
        
    }
    @IBAction func editProfileTapped(sender: AnyObject?)
    {
        
        CodeManager.sharedInstance.sendScreenName(settings_edit_icon_touch)
        
        showProfileVC()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionTitles.count
    }
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//
//        return self.sectionTitles[section]
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0 {
            if notificationArray.count > 0 {
                return notificationArray.count
            }
            else {
                return self.items[section].count
                
            }
        }
        else {
            return self.items[section].count
        }
    }
    // MARK : Mohan Kumar  -- mohand@dmss.co.in
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCellIdentifier", for: indexPath) as! SettingsCell
        
        cell.nameLabel.text = (self.items[indexPath.section] as NSArray)[indexPath.row] as? String
        
        cell.nextButton.setImage(#imageLiteral(resourceName: "gray_tick"), for: .normal)
        cell.nextButton.setTitle("", for: .normal)
        
        cell.selectionStyle = .none
        cell.arrow.isHidden = true
        if indexPath.section == 0 {
          //  print(notificationArray.count)
            
            if notificationArray.count > 0 {
                var notifyBool = false
                notifyBool = (notificationArray.object(at: indexPath.row)as! NSDictionary).value(forKey: "IsUserOpted") as! Bool
                cell.nameLabel.text = (notificationArray.object(at: indexPath.row)as! NSDictionary).value(forKey: "Name") as? String
                
                if notifyBool == true {
                    cell.nextButton.setImage(#imageLiteral(resourceName: "tick_active"), for: .normal)
                }
                else {
                    cell.nextButton.setImage(#imageLiteral(resourceName: "gray_tick"), for: .normal)
                }
                if indexPath.row == notificationArray.count - 1
                {
                    updateUserSelectedNotificationTypes()
                }
            }
        }
//        if indexPath.section == 1
//        {
//            if indexPath.row == 0{
//                cell.nextButton.setImage(UIImage(named: ""), for: .normal)
//                cell.nextButton.setTitle("Disconnect", for: .normal)
//                cell.nextButton.backgroundColor = UIColor.lightGray
//                cell.nextButton.setTitleColor(UIColor.black, for: .normal)
//                cell.nextButton.layer.cornerRadius = 5
//                cell.nextButton.titleLabel?.font = burbankFont(size: 11)
//            }
//            else {
//
//
//                cell.nextButton.setImage(#imageLiteral(resourceName: "Ico-Select"), for: .normal)
//            }
//        }
        if indexPath.section == 1
        {
            if indexPath.row == 1{
                if let versionNum = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
                {
                    cell.nextButton.setTitle(versionNum, for: .normal)

                }
            }
            else {
                cell.arrow.isHidden = false
                
//               // cell.nextButton.setImage(#imageLiteral(resourceName: "rightarrow-gray"), for: .normal)
//                //cell.nextButton.alpha = 0
//                cell.nextButton.setTitle(">", for: .normal)
            }
            cell.nextButton.setImage(nil, for: .normal)
            //cell.nextButton.setTitleColor(UIColor.lightGray, for: .normal)
            setAppearanceFor(view: cell.nextButton, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Orange_BG, textFont: FONT_LABEL_SUB_HEADING(size: FONT_15))

        }
        
        
        
        cell.top = false
        cell.bottom = false
        
        let numberofRows = tableView.numberOfRows(inSection: indexPath.section)
        
        if indexPath.row == 0, numberofRows == indexPath.row+1 {
            cell.top = true
            cell.bottom = true
        }else if indexPath.row == 0 {
            
//            cell.top = true
        }else if numberofRows == indexPath.row+1 {
            cell.bottom = true
        }
        
        cell.layoutSubviews()
        
//        print("numberofRows: \(numberofRows), currentRow: \(indexPath.row), top: \(cell.top), bottom: \(cell.bottom)")
        
        if indexPath.section == 2 {
            cell.nameLabel.textAlignment = .center
            cell.nextButton.isHidden = true
            
            setAppearanceFor(view: cell.nameLabel, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Orange_BG, textFont: FONT_LABEL_HEADING(size: FONT_15))

        }else {
            
            cell.nameLabel.textAlignment = .left
            cell.nextButton.isHidden = false
            
            setAppearanceFor(view: cell.nameLabel, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_BODY(size: FONT_12))
        }
        

        
        cell.separatorInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        
        return cell
        
    }
       
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let cell = tableView.cellForRow(at: indexPath) as! SettingsCell

      if indexPath.section == 2 {
         logOutUser()
      }
        
        if indexPath.section == 0 {
            
            let dataDict : NSDictionary = notificationArray[indexPath.row] as! NSDictionary
            
            let modifyDict : NSMutableDictionary = (dataDict.mutableCopy()) as! NSMutableDictionary
            
            #if DEDEBUG
            print(modifyDict)
            #endif
            if cell.nextButton.currentImage == #imageLiteral(resourceName: "gray_tick")  {
                // Do fale here
                modifyDict.setValue(true, forKey: "IsUserOpted")
                cell.nextButton.setImage(#imageLiteral(resourceName: "tick_active"), for: .normal)
            }
            else {
                modifyDict.setValue(false, forKey: "IsUserOpted")
                cell.nextButton.setImage(#imageLiteral(resourceName: "gray_tick"), for: .normal)
            }
            
            #if DEDEBUG
            print(modifyDict)
            #endif
            
            notificationArray.replaceObject(at: indexPath.row, with: (modifyDict.copy()) as! NSDictionary)
            notificationChanges = true
            
            if indexPath.row == 0 {
                
                
                CodeManager.sharedInstance.sendScreenName(settings_photos_added_on_off_icon_touch)
        
            }
            else if indexPath.row == 1 {
                
                
                CodeManager.sharedInstance.sendScreenName(settings_stage_completion_added_on_off_icon_touch)
        
            }
            else if indexPath.row == 2 {
                
                
                CodeManager.sharedInstance.sendScreenName(settings_stages_changes_on_off_icon_touch)
        
            }
            
        }
        
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                aboutUsBool = true
                termsBool = false
                privacyBool = false
                
                
                CodeManager.sharedInstance.sendScreenName(settings_what_is_burbank_app_foward_arrow_touch)
        
            }
            else if indexPath.row == 1 {
                return
            }
            else if indexPath.row == 2 {
                aboutUsBool = false
                termsBool = true
                privacyBool = false
                
                
                CodeManager.sharedInstance.sendScreenName(settings_terms_of_use_foward_arrow_touch)
        
            }
            else if indexPath.row == 3 {
                aboutUsBool = false
                termsBool = false
                privacyBool = true
                
                
                CodeManager.sharedInstance.sendScreenName(settings_privacy_policy_forward_arrow_touch)
        
            }
            
            let aboutBurbank = kStoryboardMain_OLD.instantiateViewController(withIdentifier: "AboutBurbankVC") as! AboutBurbankVC
            
            aboutBurbank.isFromAboutUs = aboutUsBool
            aboutBurbank.isFromTerms = termsBool
            aboutBurbank.isFromPrivacy = privacyBool

            self.navigationController?.pushViewController(aboutBurbank, animated: true)
            
            
//            self.performSegue(withIdentifier: "ShowAboutBurbankVC", sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2 {
            return 0
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        if section == 2 {
            return UIView.init(frame: .zero)
        }
        
        let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        header.backgroundColor = APPCOLORS_3.Orange_BG

        let headersub = UIView(frame: CGRect(x: 0, y: 10, width: tableView.frame.size.width, height: header.frame.size.height-10))
        header.addSubview(headersub)

        let label = UILabel(frame: CGRect.init(x: 20, y: 0, width: headersub.frame.size.width-40, height: headersub.frame.size.height))
        headersub.addSubview(label)
        label.text = "\(self.sectionTitles[section])"

        setAppearanceFor(view: label, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Orange_BG, textFont: FONT_LABEL_HEADING(size: FONT_15))
        
        if section == 2 {
            headersub.backgroundColor = COLOR_CLEAR
        }else {
            headersub.backgroundColor = APPCOLORS_3.HeaderFooter_white_BG
        }

        let shape = CAShapeLayer()
        let rect = CGRect(x: 0, y: 0, width: headersub.frame.size.width, height: headersub.bounds.size.height)
        let corners: UIRectCorner = [.topLeft, .topRight]

        shape.path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: 10, height: 10)).cgPath
        headersub.layer.mask = shape
        headersub.layer.masksToBounds = true

        return header

    }
    
    
    
    func logOutUser()
    {
        
        CodeManager.sharedInstance.sendScreenName(settings_logout_button_touch)
        
        NotificationTypes.deleteNotificationType()
        CodeManager.sharedInstance.logOutCurrentUser()
        
        loadLoginView()
        appointmentsQLDDate = ["","","","",""]
        isAppointmentServiceCalled = false
        
        contactUsVICArray.removeAll()
        contactUsQLDSAArray.removeAll()
        isContactUsServiceCalled = false
        appDelegate.jobContacts = nil
        isContactUsServiceCalled = false
//        _ = self.navigationController?.popToRootViewController(animated: false)
    }
    // MARK: - SaveButton Action
    @IBAction func saveButtonTapped(sender: AnyObject?)
    {
        
        CodeManager.sharedInstance.sendScreenName(settings_save_button_touch)
        
        postDataToServerForUpdatingUserProfile()
        updateUserSelectedNotificationTypes()
    }
    func updateUserSelectedNotificationTypes()
    {
        //need to rewrite all the code. at the time of implementing of settings screen, complicated the data set.
        let photoAdded = (notificationArray.object(at: 0) as! NSDictionary).value(forKey: "IsUserOpted") as! Bool//["IsUserOpted"]
        let stageCompletion = (notificationArray.object(at: 1) as! NSDictionary).value(forKey: "IsUserOpted") as! Bool//["IsUserOpted"]
        let stageChanged = (notificationArray.object(at: 2) as! NSDictionary).value(forKey: "IsUserOpted") as! Bool//["IsUserOpted"]
        NotificationTypes.updatedSelectedNotificationType(photoAdded, stageCompletion, stageChanged: stageChanged)
    }
    
    /// posting data to server for getting user profile details
    func postDataToServerForUpdatingUserProfile() {
        
//        let urlString = String(format: "userProfile/UpdateUserProfile")
//        print(notificationArray)
        let userID = appDelegate.currentUser?.userDetailsArray?[0].id
        ServiceSession.shared.callToPostDataToServer(appendUrlString: updateProfileURL, postBodyDictionary: ["UserName": usernameLabel.text ?? "", "Email": emailLabel.text ?? "", "UserId": userID!, "NotificationTypes": notificationArray], completionHandler: {(json) in
            
            let jsonDic = json as! NSDictionary
            
            #if DEDEBUG
            print(jsonDic)
            #endif
            
            self.appDelegate.hideActivity()
            if let status = jsonDic.object(forKey: "Status") as? Bool
            {
                
                if status == true
                {
                    AlertManager.sharedInstance.alert(jsonDic.object(forKey: "Message")! as! String)
                    self.notificationChanges = false
                    
                }
                else{
                    
                    AlertManager.sharedInstance.alert(jsonDic.object(forKey: "Message")! as! String)
                    self.notificationChanges = true
                    
                }
            }
        })
        
    }
    /// posting data to server for getting user profile details
    func postDataToServerForGettingUserProfile() {
        
        let userID = appDelegate.currentUser?.userDetailsArray?[0].id
        //var myDate = ""
        ServiceSession.shared.callToPostDataToServer(appendUrlString: getProfileURL, postBodyDictionary: ["Id": userID!], completionHandler: {(json) in
            
            let jsonDic = json as! NSDictionary
            
            #if DEDEBUG
            print(jsonDic)
            #endif
            
            self.appDelegate.hideActivity()
            if let status = jsonDic.object(forKey: "Status") as? Bool
            {
            
                if status == true
                {
                    if let resultArray = jsonDic.object(forKey: "Result") as? NSDictionary
                    {
                        self.usernameLabel.text = resultArray.value(forKey: "UserName")as? String
                        
                        self.emailLabel.text = resultArray.value(forKey: "Email")as? String
                        
                        if let urlString = resultArray.value(forKey: "ProfilePicPath") as? String //URL(string: resultArray.value(forKey: "ProfilePicPath") as! String)
                        {
                            DispatchQueue.main.async {
                                self.profilePicImage.loadImageUsingCacheUrlString(urlString: urlString) //UIImage(data: data!)
                                imagesPickManager.sharedInstance.applyCornerRadiusForProfilePic(imageView: self.profilePicImage)
                                imagesPickManager.sharedInstance.profilePicURLString = urlString
                                
                                self.btnProfile.setImage(UIImage.init(named: ""), for: .normal)
//                                self.btnProfile.setBackgroundImage(self.profilePicImage.image, for: .normal)
                            }
                        }
//                        if let urlString = resultArray.value(forKey: "ProfilePicPath") as? String //URL(string: resultArray.value(forKey: "ProfilePicPath") as! String)
//                        {
//                            let url = URL(string: urlString)
//                            DispatchQueue.global().async {
//                                let data = try? Data(contentsOf: url!)
//                                DispatchQueue.main.async {
//                                    self.profilePicImage.image = UIImage(data: data!)
//                                    imagesPickManager.sharedInstance.applyCornerRadiusForProfilePic(imageView: self.profilePicImage)
//                                }
//                            }
//                        }
                        else
                        {
                            self.profilePicImage.image = #imageLiteral(resourceName: "Ico-EditProfile-1")
                        }
                        
                        if (resultArray.value(forKey: "NotificationTypes")as? NSArray) != nil {
                            
                            self.notificationArray = (resultArray.value(forKey: "NotificationTypes") as! NSArray).mutableCopy() as! NSMutableArray

                        }
                        self.settingsTable.reloadData()
                    }
                }
                else{
                    
                    AlertManager.sharedInstance.alert(jsonDic.object(forKey: "Message")! as! String)
                }
            }
        })
        
    }
  

    
    func updatePassword() {
        
        let urlString = String(format: "login/UpdatePassword/")
        
        ServiceSession.shared.callToPostDataToServer(appendUrlString: urlString, postBodyDictionary: ["JobNumber": usernameLabel.text!, "Email": emailLabel.text!, "Passcode": "", "CentralLoginPassword": notificationArray], completionHandler: {(json) in
            
            let jsonDic = json as! NSDictionary
            
            #if DEDEBUG
            print(jsonDic)
            #endif
            
            self.appDelegate.hideActivity()
            if let status = jsonDic.object(forKey: "Status") as? Bool
            {
                
                if status == true
                {
                    AlertManager.sharedInstance.alert(jsonDic.object(forKey: "Message")! as! String)
                    self.notificationChanges = false
                    
                }
                else{
                    
                    AlertManager.sharedInstance.alert(jsonDic.object(forKey: "Message")! as! String)
                    self.notificationChanges = true
                    
                }
            }
        })
    }
    
    // Reset Password Tapped
    
  @IBAction func resetPasswordTapped(Sender: AnyObject) {

    
    CodeManager.sharedInstance.sendScreenName(settings_edit_icon_touch)
    
    
        let postDic = ["Email":emailLabel.text!] as [String : Any]
            
            ServiceSession.shared.callToPostDataToServerWithGivenURLString(urlString: resetPasswordURL, postBodyDictionary: postDic as NSDictionary, completionHandler: { (json) in
                let jsonDic = json as! NSDictionary
                if let status = jsonDic.object(forKey: "Status") as? Bool {
                    
                    #if DEDEBUG
                    print(jsonDic)
                    #endif
                    
                    let message = jsonDic.object(forKey: "Message")as? String
                    if status == true {
                        if let _ = jsonDic.object(forKey: "Result") as? [String: Any]
                        {
                            if let userDic = jsonDic.object(forKey: "Result") as? [String: Any]
                            {
                                self.oldPassword = (userDic as NSDictionary).value(forKey: "Password") as? String ?? ""
                                self.performSegue(withIdentifier: "showResetPasswordVC", sender: nil)
                            }
                            else
                            {
                                AlertManager.sharedInstance.showAlert(alertMessage: message!, title: "")
                                return
                            }
                            
                        }
                    }
                    else
                    {
                        AlertManager.sharedInstance.showAlert(alertMessage: message!, title: "")
                        return
                    }
                }
            })
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAboutBurbankVC" {
            let destination = segue.destination as! AboutBurbankVC
            destination.isFromAboutUs = aboutUsBool
            destination.isFromTerms = termsBool
            destination.isFromPrivacy = privacyBool

        }else if segue.identifier == "showResetPasswordVC" {
            let destination = segue.destination as! ResetPasswordVC
            destination.currentPassword = oldPassword
            appDelegate.enteredEmailOrJob = emailLabel.text!
        }
     
    }
    
    // MARK: Add method action for adding image
    // MARK : Mohan Kumar  -- mohand@dmss.co.in
    @IBAction func profilePicTapped(sender: AnyObject) {
        
        imagesPickManager.sharedInstance.cameraOptionOpen(imageView: profilePicImage, button: (sender as? UIButton)!, view: self.view)
        
        imagesPickManager.sharedInstance.applyCornerRadiusForProfilePic(imageView: profilePicImage)
    }
    
}

