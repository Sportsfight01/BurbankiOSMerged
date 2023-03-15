//
//  MyProgressVC.swift
//  BurbankApp
//
//  Created by naresh banavath on 17/11/21.
//  Copyright © 2021 DMSS. All rights reserved.
//

import UIKit
import Alamofire
//import PagingCollectionViewLayout
import PagingCollectionViewLayout
import SideMenu

enum StageName : String {
    case administration = "Administration"
    case frame = "Frame Stage"
    case lockup = "Lockup Stage"
    case fixout = "Fixout Stage"
    case completion = "Completion"
    case base = "Base Stage"
    case none = "none"
}


class MyProgressVC: UIViewController {
    
    //MARK: - Properties
    
    @IBOutlet weak var burbankLogo: UIImageView!
    @IBOutlet weak var homeProgressLb: UILabel!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var notificationCountLBL: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var progressBar: UIProgressView!
    {
        didSet{
            progressBar.transform = CGAffineTransform(scaleX: 1.0, y: 2.0)
        }
    }
    @IBOutlet weak var yourOverallProgressLb: UILabel!
    
    //Variables
    let gradientLayer = CAGradientLayer()
    var progressColors : [UIColor] = [
        AppColors.appOrange,
        AppColors.StageColors.admin,
        AppColors.StageColors.base,
        AppColors.StageColors.frame ,
        AppColors.StageColors.lockup ,
        AppColors.StageColors.fixing ,
        AppColors.StageColors.finishing
    ]
    lazy var clItems : [CLItem] = prepareCollectionViewItems()
    
    //* CollectionViewMeasuremets
    var cellWidth = (3/4) * UIScreen.main.bounds.width
    var spacing = (1/8) * UIScreen.main.bounds.width
    var cellSpacing = (1/16) * UIScreen.main.bounds.width
    
    var menu : SideMenuNavigationController!
    
    
    var selectedStageName = ""
    var stageName: StageName = .none
    var progressDetailsDic = [String:[MyPlaceProgressDetails]]()
    //For QLD and SA
     var selectedIndex = 1
     var progressValues = [CGFloat]()
    
    //MARK: - notifications Data
    var dayWisePhotoList = [DayWisePhotoList<MyPlaceDocuments>]()
    var storedDayWisePhotoList = [DayWisePhotoList<MyPlaceStoredPhotoInfo>]()
    var completedStageListArray = [MyPlaceProgressDetails]()
    var completedStageList = [MyPlaceStageCompleteDetails]()
    var stageChangeList = [MyPlaceStoredProgressDetails]()
  //  var photoListWithDocDate = [String:[MyPlaceDocuments]]()
    var stagesProgressDetailsDic = [String: [MyPlaceProgressDetails]]()
    var notificationListArray = NSMutableArray()
    var currentJobNumber = ""
    
    
    
    //MARK: - LifeCycleMethods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Collection View Setup
        let layout = PagingCollectionViewLayout()
       // let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: cellWidth, height: collectionView.frame.height - 20)
        layout.scrollDirection = .horizontal
       // layout.collectionView?.decelerationRate = .fast
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        layout.minimumLineSpacing = cellSpacing
        collectionView.decelerationRate = .fast
        collectionView.collectionViewLayout = layout
        
        
//        if #available(iOS 13.0, *)
//        {
//            collectionView.collectionViewLayout = compositionalLayout()
//        }else {
            collectionView.collectionViewLayout = layout
     //   }
        collectionView.delegate = self
        collectionView.dataSource = self
      //  collectionView.isPagingEnabled = true
       

        
//        addGradientLayer()
        getProgressDetails()
        getUserProfile()
        sideMenuSetup()
        getNotification()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "StagesBackground_Image")!)

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        notificationCountLBL.isHidden = true
        setupProfile()
      
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: - Helper Funcs
    
    
    /// layout design for future versions
    @available(iOS 13.0, *)
    func compositionalLayout() -> UICollectionViewLayout
    {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(3/4), heightDimension: .fractionalHeight(1)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = 16.0
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    
    func prepareCollectionViewItems() -> [CLItem]
    {
         return [
            CLItem(title: "Admin Stage", imageName: "icon_Details_Dark", detailText: "We’re gathering the paperwork ready for approvals."),
            CLItem(title: "Base Stage", imageName: "icon_Base", detailText: "We will pour the foundation for your new home."),
            CLItem(title: "Frame Stage", imageName: "icon_Frame",detailText: "The frame forms the skeleton of your new home."),
            CLItem(title: "Lockup Stage", imageName: "icon_Lockup",detailText: "Your home will now be prepared for locking up."),
            CLItem(title: "Fixing Stage", imageName: "icon_Fixout",detailText: "All the internal design features will now be fitted into your home."),
            CLItem(title: "Finishing Stage", imageName: "icon_Complete", detailText: "As the name suggests, we’re almost there.")
         ]
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
    
    @IBAction func didTappedOnMenuIcon(_ sender: UIButton) {
        
        present(menu, animated: true, completion: nil)
        
//        guard let vc = UIStoryboard(name: StoryboardNames.newDesing5, bundle: nil).instantiateInitialViewController() else {return}
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func didTappedOnSupport(_ sender: UIButton) {
        guard let vc = UIStoryboard(name: StoryboardNames.newDesing5, bundle: nil).instantiateViewController(withIdentifier: "ContactUsVC") as? ContactUsVC else {return}
        self.navigationController?.pushViewController(vc, animated: true)
  
    }
    
    //MARK:- Helper Methods
    func addGradientLayer()
    {
        
        gradientLayer.locations = [0,1]
        gradientLayer.colors = [AppColors.appOrange.cgColor , AppColors.appOrange.cgColor]
        gradientLayer.frame = view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    //below method is to group values with their respected stages
    //
    func setupProgressDetails(progressData : [ProgressStruct])
    {
        var stagesDictionary : [StageName : [ProgressStruct]] = [:]
      
        
        for item in progressData
        {
            if item.phasecode == "Presite" // AdminStage
            {
                if stagesDictionary[.administration] == nil
                {
                    stagesDictionary[.administration] = [item]
                }else {
                    stagesDictionary[.administration]?.append(item)
                }
            }
            else {
                switch item.stageName
                {
                case StageName.base.rawValue: // Base Stage
                    if stagesDictionary[.base] == nil
                    {
                        stagesDictionary[.base] = [item] //if values not present initially adding first item
                    }else {
                        stagesDictionary[.base]?.append(item)
                    }
                case StageName.frame.rawValue: // Frame Stage
                    if stagesDictionary[.frame] == nil
                    {
                        stagesDictionary[.frame] = [item]
                    }else {
                        stagesDictionary[.frame]?.append(item)
                    }
                case StageName.lockup.rawValue: // Lockp Stage
                    if stagesDictionary[.lockup]?.count == nil
                    {
                        stagesDictionary[.lockup] = [item]
                    }else {
                        stagesDictionary[.lockup]?.append(item)
                    }
                case StageName.fixout.rawValue: // Fixing Stage
                    if stagesDictionary[.fixout]?.count == nil
                    {
                        stagesDictionary[.fixout] = [item]
                    }else {
                        stagesDictionary[.fixout]?.append(item)
                    }
                case StageName.completion.rawValue , "Handover": // Finishing Stage
                    if stagesDictionary[.completion]?.count == nil
                    {
                        stagesDictionary[.completion] = [item]
                    }else {
                        stagesDictionary[.completion]?.append(item)
                    }
                default:
                    // print("default")
                    break
                }
            }
        }
        
        for key in stagesDictionary.keys
        {
            let completedTasks = stagesDictionary[key]?.filter({$0.status == "Completed"}).count //completed tasks count in particular stage(ex: BaseStage 11/13 tasks completed)
            let totalTasks = stagesDictionary[key]!.count // total records in particular stage
            let progress =  Double(completedTasks ?? 0)/Double(totalTasks) // progress of particular stage
            
            print("Key :- \(key.rawValue) progress :- \(progress)")
            switch key
            {
            case .administration:
                self.clItems[0].progress = CGFloat(progress)
                self.clItems[0].progressDetails = stagesDictionary[key]
            case .base:
                self.clItems[1].progress = CGFloat(progress)
                self.clItems[1].progressDetails = stagesDictionary[key]
            case .frame:
                self.clItems[2].progress = CGFloat(progress)
                self.clItems[2].progressDetails = stagesDictionary[key]
                
            case .lockup:
                self.clItems[3].progress = CGFloat(progress)
                self.clItems[3].progressDetails = stagesDictionary[key]
            case .fixout:
                self.clItems[4].progress = CGFloat(progress)
                self.clItems[4].progressDetails = stagesDictionary[key]
            case .completion:
                self.clItems[5].progress = CGFloat(progress)
                self.clItems[5].progressDetails = stagesDictionary[key]
            case .none:
                self.clItems[0].progress = CGFloat(progress)
                self.clItems[0].progressDetails = stagesDictionary[key]
      
            }
        }
        
        //Calculating whole home progress
        let totalHomeProgress = Double(clItems.compactMap({$0.progress}).reduce(0.0, +)) / 6.0
        
        let totalHomeProgressPercentage = Int(Double(totalHomeProgress * 100).rounded(.toNearestOrAwayFromZero))
        let newClItem = CLItem(title: "Your New Home", imageName: "icon_house", progress: CGFloat(Double(totalHomeProgressPercentage)/100.0), progressDetails: nil)
        clItems.insert(newClItem, at: 0)
        progressBar.progress = Float(totalHomeProgress)
        let attrStr = NSMutableAttributedString(string: "Your home is currently ")
        let percentageAttrStr = NSAttributedString(string: "\(totalHomeProgressPercentage)%", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14.0 , weight: .semibold) , .foregroundColor : UIColor.black])
        let cmpletedStr = NSAttributedString(string: " completed. Swipe to see your stages.")
        attrStr.append(percentageAttrStr)
        attrStr.append(cmpletedStr)
        homeProgressLb.attributedText = attrStr
        // homeProgressLb.attributedText
        //  print(clItems.count)
        collectionView.reloadData()
        collectionView.contentSize.width = collectionView.contentSize.width + 50 // to make last item of collectionView visible properly
        CurrentUservars.currentHomeBuildProgress = "\(totalHomeProgressPercentage)%"
        
    }
    func setupProfile()
    {
        //        if let imgURlStr = CurrentUservars.profilePicUrl , let url = URL(string: imgURlStr)
        //        {
        ////            profileImgView.sd_setImage(with: url, placeholderImage: UIImage(named: "icon_User"))
        //            profileImgView.downloaded(from: url)
        //        }
        if let imgURlStr = CurrentUservars.profilePicUrl
        {
            // profileImgView.sd_setImage(with: url, placeholderImage: UIImage(named: "icon_User"))
            profileImgView.image = imgURlStr
        }
        let mobileNo = (UIApplication.shared.delegate as! AppDelegate).currentUser?.userDetailsArray?[0].mobile
        CurrentUservars.mobileNo = mobileNo
        //        profileView.profileImage.addBadge(number: appDelegate.notificationCount)
        if appDelegate.notificationCount == 0{
            notificationCountLBL.isHidden = true
        }else{
            notificationCountLBL.isHidden = false
            notificationCountLBL.text = "\(appDelegate.notificationCount)"
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileClick(recognizer:)))
        profileImgView.addGestureRecognizer(tap)
        
        //jobnumber to currentuservars
        var currenUserJobDetails : MyPlaceDetails?
        currenUserJobDetails = (UIApplication.shared.delegate as! AppDelegate).currentUser?.userDetailsArray![0].myPlaceDetailsArray[0]
        var contractNo : String = ""
    
            if let jobNum = appDelegate.currentUser?.jobNumber, !jobNum.trim().isEmpty
            {
                contractNo = jobNum
            }
            else {
                contractNo = appDelegate.currentUser?.userDetailsArray?.first?.myPlaceDetailsArray.first?.jobNumber ?? ""
            }
        CurrentUservars.jobNumber = contractNo
        
        
    }
@objc func handleProfileClick (recognizer: UIGestureRecognizer) {
    let vc = UIStoryboard(name: StoryboardNames.newDesing, bundle: nil).instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
    self.navigationController?.pushViewController(vc, animated: true)

}
    //MARK: - Service Calls
    
    func getProgressDetails()
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
        
        
//        let contractNo = appDelegate.currentUser?.jobNumber?.trim().isEmpty || appDelegate.currentUser?.jobNumber == nil ? appDelegate.currentUser?.userDetailsArray?.first?.myPlaceDetailsArray.first?.jobNumber ?? "" : ""
        
        var contractNo : String = ""
    
            if let jobNum = appDelegate.currentUser?.jobNumber, !jobNum.trim().isEmpty
            {
                contractNo = jobNum
            }
            else {
                contractNo = appDelegate.currentUser?.userDetailsArray?.first?.myPlaceDetailsArray.first?.jobNumber ?? ""
            }
        
            
        
        
        NetworkRequest.makeRequestArray(type: ProgressStruct.self, urlRequest: Router.progressDetails(auth: valueStr, contractNo: contractNo)) { [weak self](result) in
            switch result
            {
            case .success(let data):
               // print(data)
                self?.setupProgressDetails(progressData: data)
                
            case.failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    func getUserProfile()
    {
    
        let userID = appDelegate.currentUser?.userDetailsArray?[0].id
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
                CurrentUservars.email = data.result?.email
                CurrentUservars.userName = data.result?.userName
                //let imgdata = try! Data.init(contentsOf: URL(string: data.result?.profilePicPath ?? "")!)
                //self?.profileImgView.image = UIImage(data: imgdata)
                self?.profileImgView.downloaded(from: data.result?.profilePicPath ?? "")
            
                self?.setupProfile()
                
            case .failure(let err):
                print(err.localizedDescription)
                DispatchQueue.main.async {
                    self?.showAlert(message: err.localizedDescription)
                }
            }
        }
    }
    
    //MARK: - NotificationSection
    
    func getNotification()
    {
        //Getting UserSelectedNotifications(user can chose which kind notifications has to get. in MySettings Page) from coredata
        let notificationType = NotificationTypes.getSelectedNotificationType()
        if notificationType == nil // No notification added locally so adding it
        {
            notificationListArray.removeAllObjects()
            getUserSelectedNotificationTypes { [weak self] status in
                if status == true
                {
                    self?.getNotificationListForQLDSA()
                }
            }
        }
        else {
            let jobNumber = appDelegate.currentUser?.userDetailsArray?[0].myPlaceDetailsArray[0].jobNumber ?? ""
            if notificationListArray.count == 0 || currentJobNumber != jobNumber
            {
                notificationListArray.removeAllObjects()
                dayWisePhotoList.removeAll()
                //  photoListArray.removeAll()
                completedStageListArray.removeAll()
                stageChangeList.removeAll()
                
                storedDayWisePhotoList.removeAll()
                completedStageList.removeAll()
                stageChangeList.removeAll()
                currentJobNumber = jobNumber
                getNotificationListForQLDSA()
            }else
            {
                reloadNotificationList()
            }
        }
    }
    
    func getUserSelectedNotificationTypes(completion : @escaping ((Bool) -> Void))
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
              //  self?.profileData = data
                let notificationArray = data.result?.notificationTypes
                let photoAdded = notificationArray?[0].isUserOpted ?? false
                let stageCompleted = notificationArray?[1].isUserOpted ?? false
                let stageChange = notificationArray?[2].isUserOpted ?? false
                NotificationTypes.updatedSelectedNotificationType(photoAdded, stageCompleted, stageChanged: stageChange)
                completion(true) // call
          
                
            case .failure(let err):
                print(err.localizedDescription)
                DispatchQueue.main.async {
                    self?.showAlert(message: err.localizedDescription)
                }
            }
        }
    }
    
    
    
//    func callServerAndUpdateUserSelectedNotificationTypes()
//    {
//        let userID = appDelegate.currentUser?.userDetailsArray?[0].id
//        ServiceSession.shared.callToPostDataToServer(appendUrlString: getProfileURL, postBodyDictionary: ["Id": userID!], completionHandler: {(json) in
//
//            let jsonDic = json as! NSDictionary
//
//            DispatchQueue.main.async(execute: {
//                appDelegate.hideActivity()
//            })
//
//            if let status = jsonDic.object(forKey: "Status") as? Bool
//            {
//
//                if status == true
//                {
//                    if let resultArray = jsonDic.object(forKey: "Result") as? NSDictionary
//                    {
//                        if let notificationType = resultArray.value(forKey: "NotificationTypes") as? NSArray {
//                            //  self.notificationArray = (resultArray.value(forKey: "NotificationTypes") as! NSArray).mutableCopy() as! NSMutableArray
//                            let photoAdded = (notificationType[0] as? NSDictionary)?.value(forKey: "IsUserOpted") as? Bool ?? true
//                            let stageCompleted = (notificationType[1] as? NSDictionary)?.value(forKey: "IsUserOpted") as? Bool ?? true
//                            let stageChange = (notificationType[2] as? NSDictionary)?.value(forKey: "IsUserOpted") as? Bool ?? true
//                            NotificationTypes.updatedSelectedNotificationType(photoAdded, stageCompleted, stageChanged: stageChange)
//
//                        }
//                    }
//                }
//                else{
//
//                    AlertManager.sharedInstance.alert(jsonDic.value(forKey: "Message") as? String ?? somethingWentWrong)
//                }
//            }
//        })
//    }
    func getNotificationListForQLDSA()
    {
        let notificationType = NotificationTypes.getSelectedNotificationType()
        let photoAdded = notificationType?.photoAdded
        let stageComplete = notificationType?.stageComplete
        let stageChange = notificationType?.stageChange
        if photoAdded == false && stageComplete == false && stageChange == false
        {
            showAlert(message: "Notifications Settings are not Enabled, Please enable preferred Notifications from Settings.", okCompletion: nil)
            return
        }
        //noNotificationsLabel.alpha = 0
        getPhotosNotificationListForQLDSA() //for photos Notifications
        
    }
    func getPhotosNotificationListForQLDSA()
    {
        MyPlaceServiceSession.shared.callToGetDataFromServer(myPlaceDocumentsDetailsURLString(), successBlock: { (json, response) in
           
            if let jsonArray = json as? NSArray
            {
               // var photoInfoList = [MyPlaceDocuments]()
                
                #if DEDEBUG
                print("++++++++")
                print(jsonArray)
                #endif
                
                for obj in jsonArray
                {
                    if let jsonDic = obj as? [String: Any]
                    {
                        let photoInfo = MyPlaceDocuments(jsonDic)
                        if photoInfo.type.uppercased() == "JPG" || photoInfo.type.uppercased() == "PNG"
                        {
                           // photoInfoList.append(photoInfo)
                            
                            let date = photoInfo.docDate.stringToDateConverter()//dateFormater.date(from: photoInfo.docDate)
                            let month = date?.monthNumber ?? 1
                            let monthStr = month < 10 ? String(format:"%02d",month) : "\(month)"
                            let dayValue = date?.dayValue ?? 1
                            let day = dayValue < 10 ? String(format:"%02d",dayValue) : "\(dayValue)"
                            let presetnYearStr = "\(date?.presentYear ?? 1)\(monthStr)\(day)"
                            // let presentYearInt = Int(presetnYearStr) ?? 0
 //                           var isAdded = false
                            var isPhotoAdded = false

                            self.dayWisePhotoList.forEach({ (photo) in
                                if photo.yyyymmddString == presetnYearStr
                                {
                                    isPhotoAdded = true
                                    var list = photo.list
                                    list.append(photoInfo)
                                    photo.list = list
                                }
                            })
                            if isPhotoAdded == false
                            {
                                let photo = DayWisePhotoList(dayValue,[photoInfo],presetnYearStr)
                                self.dayWisePhotoList.append(photo)
                            }
                            let storedPhotoInfo = MyPlaceStoredPhotoInfo.fetchPhotoInfo(photoInfo.urlId)
                            if storedPhotoInfo == nil
                            {
                                MyPlaceStoredPhotoInfo.addPhotoInfo(photoInfo)
                            }
                        }
                    }
                }
               
               
                self.getStageCompleteNotificationListForQLDSA() //for Stage Complete Notifications
            }
        }, errorBlock: { (error, isJSON) in
            //
            self.getStageCompleteNotificationListForQLDSA()
        })
        
    }
    func getStageCompleteNotificationListForQLDSA()
    {
        #if DEDEBUG
        print(myPlaceProgressDetailsURLString())
        #endif
        
        MyPlaceServiceSession.shared.callToGetDataFromServer(myPlaceProgressDetailsURLString(), successBlock: { (json, response) in
            if let jsonArray = json as? NSArray
            {
                #if DEDEBUG
                print("------")
                print(jsonArray)
                #endif
                
                for obj in jsonArray
                {
                    if let jsonDic = obj as? [String: Any]
                    {
                        let progressDetails = MyPlaceProgressDetails(dic: jsonDic)
                        self.stagesProgressDetailsDic = CodeManager.sharedInstance.fillAndGetMyPlaceProgressDetails(jsonArray)
//                        self.calculateProgressValues()
                        if progressDetails.status == kStageCompleted
                        {
                            //  let stage = StageList(stageName: progressDetails.stageName, completedStages: progressDetails)
                            if progressDetails.phasecode == adminStagePhaseCode || progressDetails.stageName == kFrameStage || progressDetails.stageName == kLockUpStage || progressDetails.stageName == kFixoutStage || progressDetails.stageName == kCompletion || progressDetails.stageName == kHandover || progressDetails.stageName == kBaseStage
                            {
                                self.completedStageListArray.append(progressDetails)
                                let completedStageDetails = MyPlaceStageCompleteDetails.fetchProgressDetails(progressDetails.taskid)
                                if completedStageDetails == nil
                                {
                                    MyPlaceStageCompleteDetails.addProgressDetails(progressDetails)
                                }
                            }

                        }
                        let stroredProgressResult = MyPlaceStoredProgressDetails.fetchStoredProgressDetails(progressDetails.taskid)
                        if stroredProgressResult == nil
                        {
                            //need to add stages
                            // MyPlaceStoredProgressDetails.addNotetoPhotoForQLDSA(progressDetails, "", "")
                            MyPlaceStoredProgressDetails.addStoredProgressDetails(progressDetails, progressDetails.status, progressDetails.status)
                        }else
                        {
                            //need to check whether stage is changed or not
                           // progressDetails.status = "toTestPlan"//kCompletion
                            if stroredProgressResult?.currentStatus != progressDetails.status
                            {
                                MyPlaceStoredProgressDetails.updateStoredProgressDetails(progressDetails, stroredProgressResult?.currentStatus ?? "", progressDetails.status)
                            }
                        }
                    }
                }
                
           
                self.reloadNotificationList()
            }
        }, errorBlock: { (error, isJson) in
//            self.presentAlert("No Notifications available")
        })
        
    }
    
    func reloadNotificationList()
    {
        notificationListArray.removeAllObjects()
        self.stageChangeList.removeAll()
        self.completedStageList.removeAll()
        self.storedDayWisePhotoList.removeAll()
        //        dayWisePhotoList.sort { (list1, list2) -> Bool in
        //            return list1.yyyymmddString > list2.yyyymmddString
        //        }
        if let storedProgressDetails = MyPlaceStoredProgressDetails.fetchAllStoredProgressDetails()
        {
            for progressDetails in storedProgressDetails
            {
                if progressDetails.previousStatus != progressDetails.currentStatus
                {
                    //need to add in stage
                    self.stageChangeList.append(progressDetails)
                }
            }
        }
        self.completedStageList = MyPlaceStageCompleteDetails.fetchAllProgressDetails()!
        guard let photoList = MyPlaceStoredPhotoInfo.fetchAllStoredPhotoInfo() else {return}
        photoList.forEach { (photoInfo) in
            let dateString = photoInfo.docDate ?? ""
            let date = dateString.stringToDateConverter()//dateFormater.date(from: photoInfo.docDate)
            let month = date?.monthNumber ?? 1
            let monthStr = month < 10 ? String(format:"%02d",month) : "\(month)"
            let dayValue = date?.dayValue ?? 1
            let day = dayValue < 10 ? String(format:"%02d",dayValue) : "\(dayValue)"
            let presetnYearStr = "\(date?.presentYear ?? 1)\(monthStr)\(day)"
            // let presentYearInt = Int(presetnYearStr) ?? 0
            //                           var isAdded = false
            var isPhotoAdded = false
            
            self.storedDayWisePhotoList.forEach({ (photo) in
                if photo.yyyymmddString == presetnYearStr
                {
                    isPhotoAdded = true
                    var list = photo.list
                    list.append(photoInfo)
                    photo.list = list
                }
            })
            if isPhotoAdded == false
            {
                let photo = DayWisePhotoList(dayValue,[photoInfo],presetnYearStr)
                self.storedDayWisePhotoList.append(photo)
            }
        }
        // notificationListArray.addObjects(from: photoListArray)
        let notificationTypes = NotificationTypes.getSelectedNotificationType()
        let photoAdded = notificationTypes?.photoAdded
        let stageCompleted = notificationTypes?.stageComplete
        let stageChange = notificationTypes?.stageChange
        if photoAdded == false && stageCompleted == false && stageChange == false
        {
//            presentAlert("Notifications Settings are not Enabled, Please enable preffered Notifications from Settings.")
            //            reloadList()
            //            return
        }
        storedDayWisePhotoList.sort { (list1, list2) -> Bool in
            return list1.yyyymmddString > list2.yyyymmddString
        }
        
        
        if photoAdded == true
        {
            let cout = storedDayWisePhotoList.count
            notificationListArray.addObjects(from: storedDayWisePhotoList)
        }
        if stageCompleted == true
        {
            notificationListArray.addObjects(from: completedStageList)//completedStageListArray
        }
        if stageChange == true
        {
            notificationListArray.addingObjects(from: stageChangeList)
        }
        
        
//        let datesArray = NSMutableArray()
        
        
        
        let sortedNames = notificationListArray.sorted { (list1, list2) -> Bool in

            if let photoList1 = list1 as? DayWisePhotoList<MyPlaceStoredPhotoInfo> {

                if let photoList2 = list2 as? DayWisePhotoList<MyPlaceStoredPhotoInfo> {

                    return photoList1.yyyymmddString > photoList2.yyyymmddString
                }
                else if let completedStage2 = list2 as? MyPlaceStageCompleteDetails {

                    return ((photoList1.list[0]).docDate)! > (completedStage2.dateActual)!
                }
                else if let stageChange2 = list2 as? MyPlaceStoredProgressDetails {
                    
                    return ((photoList1.list[0]).docDate)! > (stageChange2.dateActual)!
                }
            }
            else if let completedStage1 = list1 as? MyPlaceStageCompleteDetails {
                #if DEDEBUG
                print(completedStage1.dateActual as Any)
                #endif
                if let photoList2 = list2 as? DayWisePhotoList<MyPlaceStoredPhotoInfo> {
                    
                    return (completedStage1.dateActual)! > ((photoList2.list[0]).docDate)!
                }
                else if let completedStage2 = list2 as? MyPlaceStageCompleteDetails {
                    
                    return (completedStage1.dateActual)! > (completedStage2.dateActual)!
                }
                else if let stageChange2 = list2 as? MyPlaceStoredProgressDetails {
                    
                    return (completedStage1.dateActual)! > (stageChange2.dateActual)!
                }
            }
            else if let stageChange1 = list1 as? MyPlaceStoredProgressDetails {
                
                if let photoList2 = list2 as? DayWisePhotoList<MyPlaceStoredPhotoInfo> {
                    
                    return (stageChange1.dateActual)! > ((photoList2.list[0]).docDate)!
                }
                else if let completedStage2 = list2 as? MyPlaceStageCompleteDetails {
                    
                    return (stageChange1.dateActual)! > (completedStage2.dateActual)!
                }
                else if let stageChange2 = list2 as? MyPlaceStoredProgressDetails {
                    
                    return (stageChange1.dateActual)! > (stageChange2.dateActual)!
                }
            }


            return false
        }
        
        #if DEDEBUG
        print(sortedNames)
        #endif
        
        notificationListArray = (sortedNames as NSArray).mutableCopy() as! NSMutableArray
        
        
//        'Swift._SwiftDeferredNSArray' (0x10558e410) to 'NSMutableArray' (0x10451cea8).
//        2019-03-26 17:30:02.663199+0530 BurbankApp[13605:208279] Could not cast value of type 'Swift._SwiftDeferredNSArray' (0x10558e410) to 'NSMutableArray' (0x10451cea8).
        
//        for value in notificationListArray {
//            if let photoList = value as? DayWisePhotoList<MyPlaceStoredPhotoInfo> {
//                print("++++++++")
//                print(photoList.yyyymmddString)
//            }
//
//            else if let completedStage = value as? MyPlaceStageCompleteDetails {
//                print("------")
//                print(completedStage.dateActual as Any)
//            }
//            else if let stageChange = value as? MyPlaceStoredProgressDetails {
//                print("//////////")
//                print(stageChange.dateActual as Any)
//            }
//        }
        
        
        
        
        //        notificationListArray.addObjects(from: stageChangeList)
        //        struct ListWithDate
        //        {
        //            var dateString: String
        //            var list: NSMutableArray
        //        }
        if notificationListArray.count == 0
        {
//            presentAlert("No Notifications to Display")
        }
        else {
            
            #if DEDEBUG
            print(notificationListArray.count)
            #endif
            
           // notificationCountLBL.text = "\(appDelegate.notificationCount)"
            let tempNotificationArray = NSMutableArray()
            
            // remove Read notification from List
            for i in 0..<notificationListArray.count {
                
                let value = notificationListArray[i]
                
                if let photoList = value as? DayWisePhotoList<MyPlaceStoredPhotoInfo> {
                    let photoInfo = photoList.list[0]
                    if photoInfo.isRead == false {
                        tempNotificationArray.add(value)
                    }
                }
                else if let completedStage = value as? MyPlaceStageCompleteDetails {
                    if completedStage.isRead == false {
                        tempNotificationArray.add(value)
                    }
                }
                else if let stageChange = value as? MyPlaceStoredProgressDetails {
                    if stageChange.isRead == false {
                        tempNotificationArray.add(value)
                    }
                }
            }
            
            notificationListArray = tempNotificationArray
            
            #if DEDEBUG
            print(notificationListArray.count)
            #endif
            appDelegate.notificationCount = notificationListArray.count
            if appDelegate.notificationCount == 0{
                notificationCountLBL.isHidden = true
            }else{
                notificationCountLBL.isHidden = false
                notificationCountLBL.text = "\(appDelegate.notificationCount)"
            }
        }
        //reloadList()
    }
}
extension MyProgressVC : UICollectionViewDelegate , UICollectionViewDataSource
{
    //MARK:-  CollectionView Delegate Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return clItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyProgressCVCell", for: indexPath) as! MyProgressCVCell
        //cell.lastUpdatedLb
        cell.appalyShadow()
        cell.titleLb.text = clItems[indexPath.row].title
        cell.seeMoreBtn.setTitleColor(progressColors[indexPath.row], for: .normal)
        cell.seeMoreBtn.tag = indexPath.row
        cell.seeMoreBtn.addTarget(self, action: #selector(seemoreBtnTapped(_:)), for: .touchUpInside)
        cell.titleLb.superview?.layer.cornerRadius = 10.0
        cell.titleLb.superview?.layer.masksToBounds = true
        if indexPath.row > 0 {
            cell.lastUpdatedLb.isHidden = false
            cell.seeMoreBtn.isHidden = false
            cell.lastUpdatedLb.text = self.setupLastUpdateDate(progressData: clItems[indexPath.row].progressDetails).lastUpdate
            cell.detailLb.text = clItems[indexPath.row].detailText
        }
        else {
            cell.detailLb.text = "We're now on the way to building your new home. All you have to do is swipe to see your build progress."
            cell.lastUpdatedLb.isHidden = true
            cell.seeMoreBtn.isHidden = true
            
          
        }
        cell.setupCircularBar(progressColor: progressColors[indexPath.row], progress: clItems[indexPath.row].progress ?? 0 , cicleImage: UIImage(named : clItems[indexPath.row].imageName))
        //self.view.backgroundColor = progressColors[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "NewDesignsV4", bundle: nil).instantiateViewController(withIdentifier: "MyProgressDetailVC") as! MyProgressDetailVC
        vc.progressData = clItems[indexPath.row]
        vc.progressColor = progressColors[indexPath.row]
        vc.progressImgName = clItems[indexPath.row].imageName
        //  vc.stageTitleLb.text = clItems[indexPath.row].title
        guard indexPath.row > 0 else {return} // 
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func seemoreBtnTapped(_ sender : UIButton)
    {
        let rowNo = sender.tag
        let vc = UIStoryboard(name: "NewDesignsV4", bundle: nil).instantiateViewController(withIdentifier: "MyProgressDetailVC") as! MyProgressDetailVC
        vc.progressData = clItems[rowNo]
        vc.progressColor = progressColors[rowNo]
        vc.progressImgName = clItems[rowNo].imageName
        //  vc.stageTitleLb.text = clItems[indexPath.row].title
        guard rowNo > 0 else {return} //
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func setupLastUpdateDate(progressData : [ProgressStruct]?) -> (lastUpdate : String , overallProgress : String)
    {
        guard progressData != nil else {return (lastUpdate : "0 Tasks to Complete" , overallProgress : "PENDING PREVIOUS STAGE") }// progressData nill means we are not getting any data of that stage
        let totalTaks = progressData?.count ?? 0
        let completedTaks = progressData?.filter({$0.status == "Completed"}).count ?? 0
        
        if totalTaks == completedTaks && totalTaks > 0
        {
           // yourOverallProgressLb.text = "COMPLETED STAGE"
            let date = dateFormatter(dateStr: progressData?.last?.dateactual ?? "", currentFormate: "yyyy-MM-dd'T'HH:mm:ss", requiredFormate: "dd/MM/yyyy")
            return (lastUpdate : "Completed \(date ?? "")" , overallProgress : "COMPLETED STAGE")
        }
        else if completedTaks == 0
        {
           // yourOverallProgressLb.text = "PENDING PREVIOUS STAGE"
            return (lastUpdate : "\(totalTaks) Tasks to Complete" , overallProgress : "PENDING PREVIOUS STAGE")
           
        }
        else if completedTaks < totalTaks
        {
           // yourOverallProgressLb.text = "YOUR CURRENT STAGE"
            return (lastUpdate : "\(completedTaks ) of \(totalTaks ) Tasks Complete" , overallProgress : "YOUR CURRENT STAGE")
           
        }
        return (lastUpdate : "no data" , overallProgress : "no data")
        
        //  noOfTaskCompletedLb.text = "\(completedTaks ?? 0) of \(totalTaks ?? 0) Tasks Completed"
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let indexOfPage = scrollView.contentOffset.x / scrollView.frame.size.width * 1.1;
         print(indexOfPage)
        
        // print(indexOfPage.rounded())
        let index = indexOfPage.rounded(.up)
        let currentIndex : Int = Int(index)
        print(currentIndex)
        guard currentIndex < 7 && currentIndex >= 0 else {return}
        if currentIndex == 0
        {
            yourOverallProgressLb.text = "YOUR OVERALL PROGRESS"
        }
        else
        {
            yourOverallProgressLb.text = self.setupLastUpdateDate(progressData: clItems[currentIndex].progressDetails).overallProgress
        }
        
        //      let cell = collectionView.cellForItem(at: IndexPath(item: Int(indexOfPage.rounded(.down)), section: 0))
        //      let scale = index - indexOfPage
        //      cell?.transform = CGAffineTransform(scaleX: scale, y: scale)
        // self.view.backgroundColor = progressColors[currentIndex]
        guard currentIndex >= 0 else {return}
        gradientLayer.colors = [AppColors.appOrange.cgColor,progressColors[currentIndex].cgColor]
        
    }
    
}
extension MyProgressVC : UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //  print("size of item :- \(CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height))")
      //  let width = UIScreen.main.bounds.width * 0.8
        return CGSize(width: cellWidth , height: collectionView.frame.size.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
}
///Structs

struct CLItem
{
    let title : String
    let imageName : String
    var progress : CGFloat?
    var progressDetails : [ProgressStruct]?
    var detailText : String?
}

// MARK: - ProgressStruct
struct ProgressStruct: Codable {
    let taskid: Int?
    let resourcename, phasecode: String?
    let sequence: Int?
    let name, status, datedescription, dateactual: String?
    let comment: String?
    let forclient: Bool?
    let stageID: Int?
    let stageName: String?
    
    enum CodingKeys: String, CodingKey {
        case taskid, resourcename, phasecode, sequence, name, status, datedescription, dateactual, comment, forclient
        case stageID = "stageId"
        case stageName
    }
}
