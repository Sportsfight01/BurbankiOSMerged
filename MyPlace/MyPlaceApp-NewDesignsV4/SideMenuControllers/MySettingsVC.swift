//
//  MySettingsVC.swift
//  BurbankApp
//
//  Created by Naresh Banavath on 24/03/22.
//  Copyright © 2022 DMSS. All rights reserved.
//

import UIKit

class MySettingsVC: UIViewController, profileScreenProtocol {
    
    //MARK: - Properties
    
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet var notificationTypeBtns: [UIButton]!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var notificationCountLBL: UILabel!
    @IBOutlet weak var userNameLb: UILabel!
    @IBOutlet weak var emailLb: UILabel!
    @IBOutlet weak var changePasswordView: UIView!
    @IBOutlet weak var shareapartnerView: UIView!
    @IBOutlet weak var whatisburbankAppView: UIView!
    @IBOutlet weak var versionLb: UILabel!
    @IBOutlet weak var termsofuseView: UIView!
    @IBOutlet weak var privacyPolicyView: UIView!
   
    @IBOutlet weak var profileImage: ImagePickeredView!

    @IBOutlet weak var profileEditBtn: UIButton!
    var profileData : GetUserProfileStruct?
    var oldPassword : String = ""
    
    var notificationArray : [GetUserProfileStruct.Result.NotificationType]?
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserProfile()
        whatisburbankAppView.tag = 100
        termsofuseView.tag = 101
        privacyPolicyView.tag = 102
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(aboutBurbankViewTapped(_:)))
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(aboutBurbankViewTapped(_:)))
        let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(aboutBurbankViewTapped(_:)))
        
        let tapGesture4 = UITapGestureRecognizer(target: self, action: #selector(didTappedOnshareaPartner(_:)))
        
        let tapGesture5 = UITapGestureRecognizer(target: self, action: #selector(didTapOnChangePassword))
        changePasswordView.addGestureRecognizer(tapGesture5)
        
        whatisburbankAppView.addGestureRecognizer(tapGesture1)
        termsofuseView.addGestureRecognizer(tapGesture2)
        privacyPolicyView.addGestureRecognizer(tapGesture3)
        shareapartnerView.addGestureRecognizer(tapGesture4)
        setupProfile()
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBarButtons(notificationIcon: false)
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    //MARK: - Helper Funcs
    
    func setupUI()
    {
        self.userNameLb.text = profileData?.result?.userName
        self.emailLb.text = profileData?.result?.email
        if let imgURlStr = CurrentUservars.profilePicUrl
        {
            profileImage.image = imgURlStr
        }
        if let versionNum = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        {
            versionLb.text = versionNum
        }
        
        if let notifcationArray = notificationArray
        {
            for (i ,notification) in notifcationArray.enumerated()
            {
                notificationTypeBtns.forEach { btn in
                    if btn.tag == i+300
                    {
                        btn.isSelected = notification.isUserOpted! ? true : false
                    }
                }
            }
        }
        self.setupCurrentUserVars()
      
        
       
    }
    
    
    func setupProfile()
    {
        debugPrint("CurrentUserVarUrl :- \(CurrentUservars.profilePicUrl), serviceUrl :- \(profileData?.result?.profilePicPath)")
        profileImgView.contentMode = .scaleToFill
        profileImgView.layer.cornerRadius = profileImgView.bounds.width/2
//        if let imgURlStr = CurrentUservars.profilePicUrl , let url = URL(string: imgURlStr)
//        {
//            print(imgURlStr)
//            profileImgView.sd_setImage(with: url, placeholderImage: UIImage(named: "icon_User") ,options : .continueInBackground)
//            //profileImgView.downloaded(from: url)
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
        let vc = UIStoryboard(name: StoryboardNames.newDesing, bundle: nil).instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
        self.navigationController?.pushViewController(vc, animated: true)

    }
    func setupCurrentUserVars()
    {
        CurrentUservars.userName = profileData?.result?.userName
        CurrentUservars.email = profileData?.result?.email
    //    CurrentUservars.profilePicUrl = profileData?.result?.profilePicPath
        self.setupProfile()
    }
    
    
    //MARK: - BtnActions
    
    @IBAction func profileImgEditBtnClicked(_ sender: UIButton) {
      imagesPickManager.sharedInstance.cameraOptionOpen(imageView: profileImage, button: (sender), view: self.view)
        imagesPickManager.sharedInstance.didFinishPickingImage = {(image) in
            
            self.profileImgView.image = image
        }
//        profileImage.parentViewController = self
//        profileImage.imagePickeredDelegate = self
//        profileImage.handleClickOnImageview()
    }
    //Below Method called after profileImage Picked
//    func didFinishPicking(_ image: UIImage, imageView: UIImageView?) {
//       // print("profileImagePicked")
//                let compressedImageData = image.compressImage(image: image)
//
//                Base64.initialize()
//
//                let imageBaseString = Base64.encode(compressedImageData as Data)
//        updateProfilePic(imageContent: imageBaseString!)
//    }
    @IBAction func editBtnClicked(_ sender: UIButton) {
        let storyBoard  = UIStoryboard(name: StoryboardNames.newDesing5, bundle: nil)
        let profileVC = storyBoard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        profileVC.delegate = self
        profileVC.modalPresentationStyle = .overCurrentContext
        present(profileVC, animated: true, completion: nil)
    }
    func profileScreenDismissed(){
        getUserProfile()
    }
    
    @IBAction func notificationBtnClicked(_ sender: UIButton) {
        sender.isSelected.toggle()
        switch sender.tag
        {
        case 300: // Photo Added
            print("Photo Added")
            notificationArray?[0].isUserOpted = sender.isSelected
        case 301: // Stage Completion
            print("Stage Completion")
            notificationArray?[1].isUserOpted = sender.isSelected
        case 302: // Stage Change
            print("Stage Change")
            notificationArray?[2].isUserOpted = sender.isSelected
        default:
            print("default");
                    
        }
    }
    
    @IBAction func logOutClicked(_ sender: UIButton) {
        resetUserDefaultsForOlderVerion()
        CurrentUservars.profilePicUrl = nil
        CurrentUservars.userName = nil
        CurrentUservars.mobileNo = nil
        CurrentUservars.email = nil
        appDelegate.notificationCount = 0
        let vc = UIStoryboard(name: "MyPlaceLogin", bundle: nil).instantiateInitialViewController()
        if #available(iOS 13.0, *) {
            let delegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
            delegate.window?.rootViewController = vc
            delegate.window?.makeKeyAndVisible()
        } else {
            // Fallback on earlier versions
        }
        
       
    }
    @IBAction func btnSaveClicked(_ sender: UIButton) {
//        UIView.animate(withDuration: 0.250, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseInOut) {
//
//        }
        
        UIView.animate(withDuration: 0.125, delay: 0, options: .curveEaseInOut) {
            sender.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        } completion: { flag in
            UIView.animate(withDuration: 0.125, delay: 0, options: .curveEaseInOut) {
                sender.transform = .identity
            }
        
        }

        
        postDataToServerForUpdatingUserProfile()
    }
    func resetUserDefaultsForOlderVerion () {
        
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return
        }
        
        if let savedVersion = UserDefaults.standard.value(forKey: "applicatoinVerion") as? String {
            if version == savedVersion {
                return
            }
        }
        
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
        
        UserDefaults.standard.setValue("applicatoinVerion", forKey: version)
        UserDefaults.standard.synchronize()
        appDelegate.loginStatus = false
    }
    @objc func didTapOnChangePassword()
    {
        
        let postDic = ["Email":emailLb.text!] as [String : Any]
        
        ServiceSession.shared.callToPostDataToServerWithGivenURLString(urlString: resetPasswordURL, postBodyDictionary: postDic as NSDictionary, completionHandler: { [weak self] (json) in
            guard let self = self else {return}
            let jsonDic = json as! NSDictionary
            if let status = jsonDic.object(forKey: "Status") as? Bool {
                
#if DEDEBUG
                print(jsonDic)
#endif
                
                let message = jsonDic.object(forKey: "Message")as? String
                if status == true {
                    if let userDic = jsonDic.object(forKey: "Result") as? [String: Any]
                    {
                        if let userDic = jsonDic.object(forKey: "Result") as? [String: Any]
                        {
                            self.oldPassword = (userDic as NSDictionary).value(forKey: "Password") as? String ?? ""
                            let vc = UIStoryboard(name: StoryboardNames.newDesing, bundle: nil).instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
                            vc.currentPassword = self.oldPassword
                            appDelegate.enteredEmailOrJob = self.emailLb.text!
                            self.navigationController?.pushViewController(vc, animated: true)
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
    @objc func didTappedOnshareaPartner(_ sender : UITapGestureRecognizer)
    {
        let vc = UIStoryboard(name: StoryboardNames.newDesing, bundle: nil).instantiateViewController(withIdentifier: "CoBurbankVC") as! CoBurbankVC
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @objc func aboutBurbankViewTapped(_ sender : UITapGestureRecognizer)
    {
        let tag = sender.view?.tag
        
        let vc = UIStoryboard(name: StoryboardNames.newDesing, bundle: nil).instantiateViewController(withIdentifier: "AboutBurbankWebVC") as! AboutBurbankWebVC
        switch tag
        {
        case 100:
            debugPrint("aboutBurBankTapped")
            vc.isFromAboutUs = true
            self.navigationController?.pushViewController(vc, animated: true)
        case 101:
            debugPrint("termsofuse")
            vc.isFromTerms = true
            self.navigationController?.pushViewController(vc, animated: true)
        case 102:
            debugPrint("privacyPolicy")
            openBurbankPrivacyPolocyPortal()
            
        default:
            break;
        }
        
        
    }
    
    func openBurbankPrivacyPolocyPortal()
    {
        var currenUserJobDetails : MyPlaceDetails?
        currenUserJobDetails = (UIApplication.shared.delegate as! AppDelegate).currentUser?.userDetailsArray![0].myPlaceDetailsArray[0]
        if selectedJobNumberRegionString == ""
        {
            let jobRegion = currenUserJobDetails?.region
            selectedJobNumberRegionString = jobRegion!
            print("jobregion :- \(jobRegion)")
        }
        
        var urlString = "https://www.burbank.com.au/victoria/terms-conditions#privacypolicy"
        if selectedJobNumberRegion == .QLD
        {
            urlString = "https://www.burbank.com.au/queensland/terms-conditions#privacypolicy"
        }else if selectedJobNumberRegion == .SA
        {
            urlString = "https://www.burbank.com.au/south-australia/terms-conditions#privacypolicy"
        }else if selectedJobNumberRegion == .NSW
        {
            urlString = "https://www.burbank.com.au/nsw/terms-conditions#privacypolicy"
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
    //MARK: - Service Calls
    func updateProfilePic(imageContent : String)
    {

//
//
        let userID = appDelegate.currentUser?.userDetailsArray?[0].id
        
        let params = ["UserId":userID!, "ImageContent": imageContent] as [String : Any]
        print(params)
        
        NetworkRequest.makeRequest(type: GetUserProfileStruct.self, urlRequest: Router.updateProfilePic(parameters: params)) { [weak self] result in
            switch result
            {
            case .success(let data):
                guard data.status == true else {self?.showAlert(message: data.message, okCompletion: nil);return}
               // CurrentUservars.profilePicUrl = data.result?.profilePicPath
                self?.setupProfile()
                
            case .failure(let err):
                self?.showAlert(message: err.localizedDescription, okCompletion: nil)
                
            }
        }
    }
    func postDataToServerForUpdatingUserProfile() {
        
//        let urlString = String(format: "userProfile/UpdateUserProfile")
//        print(notificationArray)
        var notificationArrayStr = [[String : Any]]()
        
        for notification in notificationArray!
        {
           let dict = notification.dictionary
            notificationArrayStr.append(dict)
        }
//        let compressedImageData = UIImage().compressImage(image: profileImage.image!)
//
//        Base64.initialize()
//
//        let imageBaseString = Base64.encode(compressedImageData as Data)
  
        let userID = appDelegate.currentUser?.userDetailsArray?[0].id
        let parameters : [String : Any] = ["UserName": userNameLb.text ?? "", "Email": emailLb.text ?? "", "UserId": userID!, "NotificationTypes": notificationArrayStr]
        
        NetworkRequest.makeRequest(type: UpdateProfileResponseStruct.self, urlRequest: Router.updateUserProfile(parameters: parameters)) { [weak self] result in
            switch result
            {
            case .success(let data):
                print(data)
                if data.Status == true
                {
                    self?.showAlert(message: data.Message ?? "something went wrong")
                    {_ in
                        self?.getUserProfile()
                    }
                }
                else {
                    self?.showAlert(message: data.Message ?? "something went wrong", okCompletion: nil)
                }
            case .failure(let err):
                print(err)
                self?.showAlert(message: "something went wrong", okCompletion: nil)
            }
        }
    }
    
    func getUserProfile()
    {
    
        let userID = appDelegate.currentUser?.userDetailsArray?.first?.id
        let parameters : [String : Any] = ["Id" : userID as Any]
        NetworkRequest.makeRequest(type: GetUserProfileStruct.self, urlRequest: Router.getUserProfile(parameters: parameters)) { [weak self]result in
            switch result
            {
            case .success(let data):
                print(data)
                guard data.status == true else {
                    DispatchQueue.main.async {
                        self?.showAlert(message: data.message ?? somethingWentWrong)
                    };return}
                self?.profileData = data
                self?.notificationArray = data.result?.notificationTypes
                self?.setupUI()
          
                
            case .failure(let err):
                print(err.localizedDescription)
                DispatchQueue.main.async {
                    self?.showAlert(message: err.localizedDescription)
                }
            }
        }
    }
    
 
}

// MARK: - GetUserProfileStruct
struct GetUserProfileStruct: Codable {
    let status: Bool?
    let message: String?
    let result: Result?

    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case message = "Message"
        case result = "Result"
    }
    
    // MARK: - Result
    struct Result: Codable {
        let userName, email: String
        let userID: Int?
        let notificationTypes: [NotificationType]?
        let imageContent: String?
        let profilePicPath: String?
        let updatedDate: String?

        enum CodingKeys: String, CodingKey {
            case userName = "UserName"
            case email = "Email"
            case userID = "UserId"
            case notificationTypes = "NotificationTypes"
            case imageContent = "ImageContent"
            case profilePicPath = "ProfilePicPath"
            case updatedDate = "UpdatedDate"
        }
        
        
        // MARK: - NotificationType
        struct NotificationType: Codable {
            let notificationTypeID: Int?
            let name, notificationTypeDescription: String?
            var isActive, isUserOpted: Bool?

            var dictionary : [String : Any]
            {
                return ["NotificationTypeId" : notificationTypeID! , "Name" : name! , "Description" : notificationTypeDescription! , "IsActive" : isActive! , "IsUserOpted" : isUserOpted!]
            }
            enum CodingKeys: String, CodingKey {
                case notificationTypeID = "NotificationTypeId"
                case name = "Name"
                case notificationTypeDescription = "Description"
                case isActive = "IsActive"
                case isUserOpted = "IsUserOpted"
            }
        }

    }
}

struct UpdateProfileResponseStruct : Codable
{
    let Status : Bool?
    let Message : String?
}

