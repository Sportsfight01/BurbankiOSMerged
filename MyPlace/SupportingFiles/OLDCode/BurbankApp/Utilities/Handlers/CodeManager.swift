//
//  CodeManager.swift
//  Burbank
//
//  Created by Madhusudhan on 26/07/16.
//  Copyright © 2016 DMSS. All rights reserved.
//

import UIKit
import FirebaseAnalytics
import LocalAuthentication


class CodeManager: NSObject, UIScrollViewDelegate {
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    class var sharedInstance: CodeManager {
        struct Singleton {
            static let instance = CodeManager()
        }
        return Singleton.instance
    }
    
    
    
    
    /**
     Increasing the Label height based on Text
     
     - parameter text: label Text
     - parameter font: font
     - parameter width: Fixed width
     
     - returns: float of Label height
     */
    func heightForView(_ text: String, font: UIFont, width: CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    // MARK: - Font related functions
    
    /**
     increasing font size based on device
     
     - parameter fontName: font
     - parameter fontSize: Receiving font size of UIElement
     
     - returns: Font of UIElement
     
     */
    func fontWithSize(_ fontName: String ,fontSize: CGFloat) -> UIFont
    {
        var font: UIFont!
        
        let preferedFontSize = fontSizeOf(size: fontSize)
        font = UIFont(name: fontName,size: preferedFontSize)!
        return font
    }
    
    /**
     increasing font size for every subview from self.view
     
     - parameter kView: self.view
     
     */
    func setLabelsFontInView(_ kView: UIView)
    {
        for vw in kView.subviews
        {
            if vw .isKind(of: UIView.self)
            {
                if vw .isKind(of: UILabel.self)
                {
                    let label = vw as! UILabel
                    label.font = fontWithSize(label.font.fontName, fontSize: label.font.pointSize)
                }
                else if vw .isKind(of: UITextField.self)
                {
                    let txtFiled = vw as! UITextField
                    txtFiled.font = fontWithSize(txtFiled.font!.fontName, fontSize: txtFiled.font!.pointSize)
                }else if vw.isKind(of: UITextView.self)
                {
                    let txtVw = vw as! UITextView
                    #if DEDEBUG
                    print(txtVw)
                    #endif
                    txtVw.font = fontWithSize(txtVw.font!.fontName, fontSize: txtVw.font!.pointSize)
                }
                else if vw.isKind(of: UIButton.self)
                {
                    let btn = vw as! UIButton
                    btn.titleLabel?.font = fontWithSize((btn.titleLabel?.font.fontName)!, fontSize: (btn.titleLabel?.font.pointSize)!)
                }else if vw .isKind(of: UIView.self)
                {
                    setLabelsFontInView(vw)
                }
            }
            else if vw .isKind(of: UILabel.self)
            {
                let label = vw as! UILabel
                label.font = fontWithSize(label.font.fontName, fontSize: label.font.pointSize)
            }else if vw .isKind(of: UITextField.self)
            {
                let txtFiled = vw as! UITextField
                txtFiled.font = fontWithSize(txtFiled.font!.fontName, fontSize: txtFiled.font!.pointSize)
            }else if vw.isKind(of: UITextView.self)
            {
                let txtVw = vw as! UITextView
                txtVw.font = fontWithSize(txtVw.font!.fontName, fontSize: txtVw.font!.pointSize)
            }else if vw.isKind(of: UIButton.self)
            {
                let btn = vw as! UIButton
                btn.titleLabel?.font = fontWithSize((btn.titleLabel?.font.fontName)!, fontSize: (btn.titleLabel?.font.pointSize)!)
            }
        }
    }
    
    // MARK: - Email Validation
    
    /**
     checking validation for Email
     
     - parameter testStr: Email value
     
     returns: it returnts whether Email is correct format or not.
     
     */
    func isValidEmail(testStr:String) -> Bool {
        
        if testStr.count == 0 {
            
            return false
        }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    // MARK: - share
    
    /**
     Presenting the window like Action sheet to show Login apps [Ex: Email, Faceboook, Twitter, Linkedin]
     
     - parameter activityItems: Link for share to other's
     
     */
    func defaultShare(activityItems: String)
    {
        if activityItems == "" {
            AlertManager.sharedInstance.alert("Document not available to share")
            return
        }
        
        let activityVC = UIActivityViewController(activityItems: [activityItems], applicationActivities: [])
        kWindow.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
    
    // MARK: unselect the Tabbar
    func changeTheTabBarUnSelectedColor(currentTabar : UITabBar) {
                
        if #available(iOS 10.0, *) {
            UITabBar.appearance().unselectedItemTintColor = UIColor.black

        } else {
            // Fallback on earlier versions
            
            for item in currentTabar.items! as [UITabBarItem] {
                if let image = item.image {
                    item.image = image.withRenderingMode(.alwaysOriginal)
                }
            }
        }
    }
    
    
    func  enquiryServiceCall(email: String,message: String,mobile: String,name: String,houseName: String,houseSize: String, completionHandler: @escaping CompletionHandler) {
        
        let urlString = String(format: "home/sendhomeenquiry/")
        
        ServiceSession.shared.callToPostDataToServer(appendUrlString: urlString, postBodyDictionary: ["Email":email, "Message":message, "Mobile":mobile, "Name":name, "HouseName":houseName, "HouseSize":houseSize], completionHandler: {(json) in
            
            let jsonDic = json as! NSDictionary
            #if DEDEBUG
            print(jsonDic)
            #endif
            if let status = jsonDic.object(forKey: "Status") as? Bool
            {
                if status == true
                {
                    AlertManager.sharedInstance.alert(jsonDic.object(forKey: "Message")! as! String)
                    
                    DispatchQueue.main.async {
                        completionHandler(true)
                    }
                }
                else{
                    AlertManager.sharedInstance.alert(jsonDic.object(forKey: "Message")! as! String)
                }
            }
        })
    }
    //MARK: - MyPlaceProgress methods
    //we are using this method in two different cases
    func fillAndGetMyPlaceProgressDetails(_ jsonArray: NSArray) -> [String: [MyPlaceProgressDetails]]
    {
        var stagesProgressDetailsDic = [String: [MyPlaceProgressDetails]]()// for QLD and SA Region
        var adminStageArray = [MyPlaceProgressDetails]()
        var frameStageArray = [MyPlaceProgressDetails]()
        var lockupStageArray = [MyPlaceProgressDetails]()
        var fixoutStageArray = [MyPlaceProgressDetails]()
        var finishingStageArray = [MyPlaceProgressDetails]()
        #if DEDEBUG
//        print("---->")
//        print(jsonArray)
        #endif
        for obj in jsonArray
        {
            if let jsonDic = obj as? [String: Any]
            {
                let progressDetails = MyPlaceProgressDetails(dic: jsonDic)
                
                if progressDetails.phasecode == adminStagePhaseCode
                {
                    //which is adminstage
                    adminStageArray.append(progressDetails)
                }else
                {
                    //we need to check with stage name
                    if progressDetails.stageName == kFrameStage
                    {
                        frameStageArray.append(progressDetails)
                    }else if progressDetails.stageName == kLockUpStage
                    {
                        lockupStageArray.append(progressDetails)
                    }else if progressDetails.stageName == kFixoutStage
                    {
                        fixoutStageArray.append(progressDetails)
                    }else if progressDetails.stageName == kCompletion || progressDetails.stageName == kHandover
                    {
                        finishingStageArray.append(progressDetails)
                    }
                }
            }
        }
        stagesProgressDetailsDic.removeAll()
        stagesProgressDetailsDic[kAdminStage] = adminStageArray
        stagesProgressDetailsDic[kFrameStage] = frameStageArray
        stagesProgressDetailsDic[kLockUpStage] = lockupStageArray
        stagesProgressDetailsDic[kFixoutStage] = fixoutStageArray
        stagesProgressDetailsDic[kFinishingStage] = finishingStageArray
        return stagesProgressDetailsDic
    }
    func calculateProgressValue(_ progressDetailArray: [MyPlaceProgressDetails]?) -> CGFloat
    {
        var completedStageCount = 0
        var progress: CGFloat = 0
        if let progressDetailArray = progressDetailArray
        {
            for progresDetails in progressDetailArray
            {
                if progresDetails.status == kStageCompleted //"Completed"
                {
                    completedStageCount += 1
                }
            }
            progress = CGFloat((completedStageCount * 100))/CGFloat(max(progressDetailArray.count, 1))
        }
        return progress
    }
    //MARK: - Login and Logout methods
    func handleUserLoginSuccess(user: User,In viewController: UIViewController)
    {
        //print(user)
//        handleUserHomecareModule(user: user, In: viewController)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //        viewController.performSegue(withIdentifier: "showMyPlaceDashboardVC", sender: nil)
        appDelegate.currentUser = user //Need To Check whethere we need to fill user data here or not
        removeIsShownProfileKey() //Need to Place here before set the key "EnteredEmailOrJob"
        UserDefaults.standard.set(appDelegate.enteredEmailOrJob, forKey: "EnteredEmailOrJob")
        saveUserInUserDefaults(user)

        let rootVc = UIStoryboard(name : "NewDesignsV4" , bundle : nil).instantiateInitialViewController()
        //viewController.performSegue(withIdentifier: "showMyPlaceDashboardVC", sender: nil)
        appDelegate.currentUser = user //Need To Check whethere we need to fill user data here or not
         //Need to Place here before set the key "EnteredEmailOrJob"
        if #available(iOS 13.0, *) {
            let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
            sceneDelegate.window?.rootViewController = rootVc
            sceneDelegate.window?.makeKeyAndVisible()
        } else {
            // Fallback on earlier versions
            appDelegate.window?.rootViewController = rootVc
            appDelegate.window?.makeKeyAndVisible()
        }
        
    }

    func handleUserHomecareModule(user: User,In viewController: UIViewController)
    {
        
        //print(user)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.currentUser = user //Need To Check whethere we need to fill user data here or not
        
        removeIsShownProfileKey() //Need to Place here before set the key "EnteredEmailOrJob"
        
        UserDefaults.standard.set(appDelegate.enteredEmailOrJob, forKey: "EnteredEmailOrJob")
        
        saveUserInUserDefaults(user)
        let rootVc = UIStoryboard(name : AppStoryBoards.homeScreenSb.rawValue, bundle : nil).instantiateInitialViewController()
        
        //viewController.performSegue(withIdentifier: "showMyPlaceDashboardVC", sender: nil)
        
        appDelegate.currentUser = user //Need To Check whethere we need to fill user data here or not
        
        //Need to Place here before set the key "EnteredEmailOrJob"
        kWindow.rootViewController = rootVc
        kWindow.makeKeyAndVisible()
    }
    
    func handleLoggedUserHomecare(user: User,In viewController: UIViewController)
    {
        
        //print(user)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.currentUser = user //Need To Check whethere we need to fill user data here or not
        
        removeIsShownProfileKey() //Need to Place here before set the key "EnteredEmailOrJob"
        
        UserDefaults.standard.set(appDelegate.enteredEmailOrJob, forKey: "EnteredEmailOrJob")
        
        saveUserInUserDefaults(user)
        let rootVc = UIStoryboard(name : AppStoryBoards.reports.rawValue, bundle : nil)
//        rootVc.instantiateViewController(identifier: "SubmittedIsuuesVC") as? SubmittedIsuuesVC
//        
        //viewController.performSegue(withIdentifier: "showMyPlaceDashboardVC", sender: nil)
        
        appDelegate.currentUser = user //Need To Check whethere we need to fill user data here or not
        
        //Need to Place here before set the key "EnteredEmailOrJob"
        kWindow.rootViewController = rootVc.instantiateViewController(withIdentifier: "SubmittedIsuuesVC")
        kWindow.makeKeyAndVisible()
    }



    func saveUserInUserDefaults(_ user: User)
    {
        let userDefaults = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: user)
        userDefaults.set(encodedData, forKey: "currentUser")
        userDefaults.synchronize()
    }
    func removeIsShownProfileKey()
    {
        let storedEmailOrJob = UserDefaults.standard.value(forKey: "EnteredEmailOrJob") as? String
        let enteredEmail = appDelegate.enteredEmailOrJob
        if enteredEmail == storedEmailOrJob
        {
            //Same user Login Again
        }else
        {
            //Different User Came to Login
            UserDefaults.standard.removeObject(forKey: "isShwonProfile")
        }
    }
    func callServiceAndUpdateUser()
    {
        var bodyDic = NSDictionary()
        if appDelegate.enteredEmailOrJob.isValidEmail()
        {
            bodyDic = ["Email":appDelegate.enteredEmailOrJob]
        }else
        {
            bodyDic = ["jobNumber":appDelegate.enteredEmailOrJob]
        }
        // let  bodyDict = ["Email":appDelegate.enteredEmailOrJob]//jobNumber
        ServiceSession.shared.callToPostDataToServerWithGivenURLString(urlString: loginURL, postBodyDictionary: bodyDic as NSDictionary) { (json) in
            //
            let jsonDic = json as! NSDictionary
            if let status = jsonDic.object(forKey: "Status") as? Bool
            {
                self.appDelegate.hideActivity()
                if status == true {
                    
                    if let resultDic = jsonDic.object(forKey: "Result") as? [String: Any]
                    {
                        
                        let user = User(dic: resultDic)
                        if user.isSuccess == true
                        {
                            self.appDelegate.currentUser = user
                            self.saveUserInUserDefaults(user)
                        }
                    }
                }
            }
        }
    }
      /**
     PopUp View event triggers
     */
    func sendButtonTapped(sender: AnyObject)
    {
        alertVC.dismiss(animated: true, completion: nil)
        (kWindow.rootViewController?.children[0].parent as! UINavigationController).popToRootViewController(animated: true)
    }
  
    
    func logOutCurrentUser()
    {
      
//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        let launchVC = storyBoard.instantiateViewController(withIdentifier: "LaunchVC")
//        let nav = UINavigationController(rootViewController: launchVC)
//        nav.isNavigationBarHidden = true
//        appDelegate.window?.rootViewController = nav
        
//        (self.appDelegate.window?.rootViewController?.childViewControllers[1] as! UINavigationController).popToRootViewController(animated: false)
        UserDefaults.standard.removeObject(forKey: "currentUser")
        UserDefaults.standard.synchronize()
        
        appDelegate.currentUser = nil
        appDelegate.loginStatus = false
        
    }
    //MARK:- delete notifications
    func deleteJobNotifications()
    {
        MyPlaceStageCompleteDetails.deleteProgressDetails()
        MyPlaceStoredProgressDetails.deleteProgressDetails()
        MyPlaceStoredPhotoInfo.deleteAllPhotos()
    }
    
    
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return zoomScrollView.subviews[0]
//    }
    
    // MARK: downloadandShowImage methods
    func downloadandShowImage(_ photoInfo: MyPlaceDocuments, _ imgView: UIImageView)
    {
        let urlId = photoInfo.urlId
        let url = photoInfo.url
        downloadAndShowImage("\(url)","\(urlId)",imgView)
    }
    func downloadandShowImageForNewFlow(_ photoInfo: DocumentsDetailsStruct, _ imgView: UIImageView)
    {
      
      //        let urlId = photoInfo.urlId
      let url = photoInfo.url
      let urlId = (url ?? "").components(separatedBy: "?")[0].components(separatedBy: "/").last!
      
      downloadAndShowImage("\(url ?? "")","\(urlId)",imgView)
    }
    func downloadAndShowImage(_ url:String,_ urlId:String,_ imgView:UIImageView)
    {
        let documentURL = "\(clickHomeBaseImageURL)/\(url)"
      //  let jobNumber = appDelegate.myPlaceStatusDetails?.jobNumber ?? ""
        let filePath = "\(documentsPath)/\(urlId).jpg"
        let fileURL = URL(fileURLWithPath: filePath)
      //  let fileURLString = fileURL.absoluteString
        func showImage(_ pathString: String)
        {
            imgView.image = UIImage(contentsOfFile: pathString) //UIImage(data: jsosData)
        }
        
        func downloadAndShowImage()
        {
            MyPlaceServiceSession.shared.callToGetDataFromServer(documentURL, successBlock: { (json, response) in

                if let jsosData = json as? Data
                {
                    #if DEDEBUG
                    //.appendingPathExtension("pdf")
                    print("imageData:---->",jsosData)
                    #endif
                    do
                    {
                        try jsosData.write(to: fileURL, options: .atomic) //jsosData.write(to: fileURL)
                        showImage(fileURL.path)
                    }catch
                    {
                        #if DEDEBUG
                        print("fail to write file")
                        #endif
                    }
                    
                }
            }, errorBlock: { (error, isJson) in
                //
            }, isResultEncodedString: true)
        }
        FileManager.default.fileExists(atPath: fileURL.path) ? showImage(fileURL.path) : downloadAndShowImage()
    }
    
    
      
    
    var mainView : UIView!
    var mainScrollView : UIScrollView!
    var profileImageView : UIImageView!
    var selectedImageFrame : CGRect!
    
    //MARK: Profile Picture POPUP
    @objc func openImageLikePop(frame : CGRect, imageObj : UIImage) {
                
        selectedImageFrame = frame
        
        var barView : UIView!
        
        var y_Origin : CGFloat = 22
        
        if IS_IPHONE_X {
            barView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 64+25))
            y_Origin = y_Origin+25
        }
        else {
            barView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 64))
        }
        barView.backgroundColor = UIColor.black.withAlphaComponent(1.0)
        
        mainView = UIView()
        mainView.frame = frame
        mainView.backgroundColor = UIColor.black
        mainView.isUserInteractionEnabled = true
        mainView.isMultipleTouchEnabled = true
        mainView.clipsToBounds = true
        kWindow.rootViewController?.view.addSubview(mainView)
        mainView.addSubview(barView)

        
        mainScrollView = UIScrollView()
        mainScrollView.frame = CGRect(x: 0, y: IS_IPHONE_X ? 64+25 : 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-(IS_IPHONE_X ? 140 : 100))
        mainScrollView.backgroundColor = UIColor.black
        mainScrollView.clipsToBounds = true
        mainView.addSubview(mainScrollView)

        
        profileImageView = UIImageView()
        profileImageView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: mainScrollView.frame.size.height)
        profileImageView.image = imageObj// #imageLiteral(resourceName: "video-view-image")
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.clipsToBounds = true
        mainScrollView.addSubview(profileImageView)
        
        applyZoomInZoomOut(scrollView: mainScrollView)

        
//        let lineView = UIView(frame: CGRect(x: 0, y: barView.frame.size.height-0.5, width: SCREEN_WIDTH, height:0.5))
//        lineView.backgroundColor = UIColor(red: 215/255.0, green: 215/255.0, blue: 215/255.0, alpha: 1.0)
      //  mainView.addSubview(lineView)
        
        let backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: SCREEN_WIDTH - 70, y: y_Origin-5, width: 35+10, height: 35+10)
        backButton.setImage(#imageLiteral(resourceName: "Ico-Close-big"), for: .normal)
        backButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 4, right: 5)
        backButton.addTarget(self, action: #selector(CodeManager.popUpBackTapped(_:)), for: .touchDown)
        barView.addSubview(backButton)
        
        /* Remove Right Button share option
         Available in BeforeCleaning Project
         */
        
        UIView.animate(withDuration: 0.1) {
            self.mainView.frame = UIScreen.main.bounds
        }
    }
    
    @objc func popUpBackTapped(_ sender : UIButton) {
        
        UIView.animate(withDuration: 0.1, animations: {
            self.mainView.frame = self.selectedImageFrame
        }) { (isRemove) in
            self.mainView.removeFromSuperview()
            self.mainView = nil
        }
    }
    
    // MARK:
    /*
     MARK:- zoom in and zoom out  funtionality
     */
    var zoomScrollView: UIScrollView!
    
    /**
     Applying zoom functionality with double touch and pinch for ScrollView of imageView
     
     - parameter scrollView: passing zoom scale
     
     */
    func applyZoomInZoomOut(scrollView : UIScrollView) {
        
        zoomScrollView = scrollView
        
        zoomScrollView.delegate = self;

        zoomScrollView.alwaysBounceVertical = false
        zoomScrollView.alwaysBounceHorizontal = false
        zoomScrollView.showsVerticalScrollIndicator = true
        zoomScrollView.flashScrollIndicators()
        
        zoomScrollView.minimumZoomScale = 1.0
        zoomScrollView.maximumZoomScale = 10.0
        zoomScrollView.zoomScale = 1.0
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onDoubleTap(gestureRecognizer:)))
        tapRecognizer.numberOfTapsRequired = 2
        zoomScrollView.addGestureRecognizer(tapRecognizer)
    }
    
    /**
     Action for scrollView Tap gesture
     
     - parameter scrollView: passing zoom scale
     
     */
    @objc func onDoubleTap(gestureRecognizer: UITapGestureRecognizer) {
        
        let scale = min(zoomScrollView.zoomScale * 2, zoomScrollView.maximumZoomScale)
        
        if scale != zoomScrollView.zoomScale {
            let point = gestureRecognizer.location(in: zoomScrollView.subviews[0])
            
            let scrollSize = zoomScrollView.frame.size
            let size = CGSize(width: scrollSize.width / scale,
                              height: scrollSize.height / scale)
            let origin = CGPoint(x: point.x - size.width / 2,
                                 y: point.y - size.height / 2)
            zoomScrollView.zoom(to:CGRect(origin: origin, size: size), animated: true)
        }
    }
    
    // MARK: ScrollView Delegate methods
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        print(zoomScrollView.subviews[0])
        
        return profileImageView
    }
    
    
    // MARK: save and get defalut/selected notification type  methods
//    func saveSelectedNotificationTypes(_ selectedNotificationType: NotificationTypes)
//    {
//        
//    }
//    func getSelectedNotificationTypes()
//    {
//        
//    }
    
    @objc func sendScreenName(_ screenName: String) {
        
        #if GOOGLELOGS
        Analytics.logEvent(screenName, parameters: nil)
        Analytics.logEvent(screenName, parameters: nil)
        #endif
    }
    
   
    func biometricType() -> BiometricType {
        let authContext = LAContext()
        if #available(iOS 11, *) {
            let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
            switch(authContext.biometryType) {
            case .none:
                return .none
            case .touchID:
                return .touch
            case .faceID:
                return .face
            @unknown default:
                return .none
            }
        } else {
            return authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touch : .none
        }
    }
    
    enum BiometricType {
        case none
        case touch
        case face
    }
    
}
