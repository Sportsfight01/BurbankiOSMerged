//
//  MyProgressVC.swift
//  BurbankApp
//
//  Created by naresh banavath on 17/11/21.
//  Copyright © 2021 DMSS. All rights reserved.
//

import UIKit
import Alamofire
import SideMenu
import SkeletonView

enum StageName : String {
    case administration = "Administration"
    case frame = "Frame Stage"
    case lockup = "Lockup Stage"
    case fixout = "Fixout Stage"
    case completion = "Completion"
    case base = "Base Stage"
    case none = "none"
}


class MyProgressVC: BaseProfileVC {
    
    //MARK: - Properties
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var progressBar: HorizontalProgressBar!
    @IBOutlet weak var yourOverallProgressLb: UILabel!
    
    //Variables
    var progressColors : [UIColor] = [
        APPCOLORS_3.Orange_BG,
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
 
    //MARK: - LifeCycleMethods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMultipleJobVc()
        setupTitles()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
      
        profileView.notificationCountLb.isHidden = appDelegate.notificationCount == 0 ? true : false
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //MARK: - Helper Funcs
    
    func setupTitles()
    {
        profileView.titleLb.text = "MyProgress"
        profileView.helpTextLb.text = "--"
        profileView.profilePicImgView.tintColor = .darkGray
        profileView.titleLb.textColor = .black
        profileView.helpTextLb.textColor = .black
        profileView.profilePicImgView.borderColor = .darkGray
        [profileView.menubtn,profileView.contactUsBtn,profileView.navBarTitleImg].forEach({$0?.tintColor = .black})
    }
    
    func setupUI()
    {
        setupCollectionView()
        getProgressDetails()
        getUserProfile()
        sideMenuSetup()
        getNotification()
        //        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "StagesBackground_Image")!)
        let imgeView = UIImageView(image: UIImage(named: "StagesBackground_Image"))
        imgeView.frame = view.frame
        view.insertSubview(imgeView, at: 0)
    }
    
    func setupMultipleJobVc()
    {
        
        let myplaceDetailsArray = appDelegate.currentUser?.userDetailsArray?.first?.myPlaceDetailsArray
        //*** Users With Multiple Job Numbers ***//
        if myplaceDetailsArray?.count ?? 0 > 1
        {// user has multiple job numbers
            let selectedJobNum = UserDefaults.standard.value(forKey: "selectedJobNumber") as? String
            if selectedJobNum == nil // when user first come to select Job Number
            {
                self.tabBarController?.tabBar.isUserInteractionEnabled = false
                let vc = MultipleJobNumberVC.instace()
                vc.tableDataSource = myplaceDetailsArray?.compactMap({$0.jobNumber}) ?? []
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .coverVertical
                if !isEmail(){
                    vc.previousJobNum = appDelegate.enteredEmailOrJob
                }
                vc.selectionClosure = {[weak self] selectedJobNumber in
                    UserDefaults.standard.set(selectedJobNumber, forKey: "selectedJobNumber")
                    self?.setupUI()
                   
                    self?.tabBarController?.tabBar.isUserInteractionEnabled = true
                    
                }
                self.present(vc, animated: true)
            }else { // when user already selected a job from his multiple jobNums go with normal Flow
                CurrentUservars.jobNumber = selectedJobNum
                self.setupUI()
            }
            
        }
        //*** Users with single JobNumber ***//
        else
        {
            setupUI()
        }
    }
    
    func checkFinanceVisibility(with progressData : [ProgressStruct])
    {
        let contracts = ["Sign Building Contract", "Contract Signed"].map({$0.trim().lc})
        var showFinanceTab : Bool = false
        for item in progressData where item.phasecode?.trim().lc == "presite"
        {
            if contracts.contains(item.name?.trim().lc ?? "") && item.status?.trim().lc.contains("completed") == true
            {
                showFinanceTab = true
                break
            }
        }
        if showFinanceTab
        {
            let vc = UINavigationController(rootViewController: FinanceVC.instace())
            vc.tabBarItem = UITabBarItem(title: "FINANCE", image: UIImage(named : "Finance_grey") , selectedImage: UIImage(named : "Finance_orange"))
            
            self.tabBarController?.viewControllers?.append(vc)
        }
        
    }
    
    
    
    func setupCollectionView()
    {
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
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    /// layout design for future versions
//    @available(iOS 13.0, *)
//    func compositionalLayout() -> UICollectionViewLayout
//    {
//        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
//
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(3/4), heightDimension: .fractionalHeight(1)), subitems: [item])
//        let section = NSCollectionLayoutSection(group: group)
//        section.orthogonalScrollingBehavior = .groupPagingCentered
//        section.interGroupSpacing = 16.0
//        let layout = UICollectionViewCompositionalLayout(section: section)
//        return layout
//    }
    
    
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
    
    
    //below method is to group the values with their respected stages
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
            
            //print("Key :- \(key.rawValue) progress :- \(progress)")
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
        progressBar.progress = CGFloat(totalHomeProgress)
        
        let yourHomeBuild = "Your home \(CurrentUservars.jobNumber ?? "") is currently \(totalHomeProgressPercentage)% completed. Swipe to see your stages."
        
        setAttributetitleFor(view: profileView.helpTextLb, title: yourHomeBuild, rangeStrings: ["Your home" , CurrentUservars.jobNumber ?? "", "is currently", "\(totalHomeProgressPercentage)%" , "completed. Swipe to see your stages."], colors: [APPCOLORS_3.Black_BG,APPCOLORS_3.Orange_BG,APPCOLORS_3.Black_BG,APPCOLORS_3.Black_BG,APPCOLORS_3.Black_BG], fonts: [ProximaNovaRegular(size: FONT_10), ProximaNovaSemiBold(size: FONT_10),ProximaNovaRegular(size: FONT_10),ProximaNovaSemiBold(size: FONT_10),ProximaNovaRegular(size: FONT_10)], alignmentCenter: false)
        
  
        collectionView.reloadData()
        collectionView.contentSize.width = collectionView.contentSize.width + 50 // to make last item of collectionView visible properly
        CurrentUservars.currentHomeBuildProgress = "\(totalHomeProgressPercentage)%"
        
    }
    
    
    //MARK: - Service Calls
    
    func getProgressDetails()
    {
        
        let jobAndAuth = APIManager.shared.getJobNumberAndAuthorization()
        self.collectionView.showAnimatedGradientSkeleton()
        NetworkRequest.makeRequestArray(type: ProgressStruct.self, urlRequest: Router.progressDetails(auth: jobAndAuth.auth, contractNo: jobAndAuth.jobNumber ?? ""), showActivity: false) { [weak self](result) in
            DispatchQueue.main.async{
                self?.collectionView.stopSkeletonAnimation()
                self?.view.hideSkeleton()
            }
            switch result
            {
            case .success(let data):
                // print(data)
                self?.setupProgressDetails(progressData: data)
                self?.checkFinanceVisibility(with: data)
                
            case.failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    func getUserProfile()
    {
        
        let userID = appDelegate.currentUser?.userDetailsArray?[0].id
        let parameters : [String : Any] = ["Id" : userID as Any]
        NetworkRequest.makeRequest(type: GetUserProfileStruct.self, urlRequest: Router.getUserProfile(parameters: parameters), showActivity: false) { [weak self]result in
            switch result
            {
            case .success(let data):
                //print(data)
                guard data.status == true else {
                    DispatchQueue.main.async {
                        self?.showAlert(message: data.message ?? somethingWentWrong)
                    };return}
                CurrentUservars.email = data.result?.email
                CurrentUservars.userName = data.result?.userName
                //let imgdata = try! Data.init(contentsOf: URL(string: data.result?.profilePicPath ?? "")!)
                //self?.profileImgView.image = UIImage(data: imgdata)
                self?.profileView.profilePicImgView.downloaded(from: data.result?.profilePicPath ?? "")
                
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
        let viewModel = NotificationsViewModel()
        viewModel.setupLocalStorageForNotification { [weak self] localNotificationsCount in
            appDelegate.notificationCount = localNotificationsCount
            DispatchQueue.main.async {
                self?.profileView.notificationCountLb.text = "\(localNotificationsCount)"
                self?.profileView.notificationCountLb.isHidden = localNotificationsCount == 0 ? true : false
            }
        }
    }
    
}
extension MyProgressVC : UICollectionViewDelegate , SkeletonCollectionViewDataSource
{
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "MyProgressCVCell"
    }
    //MARK: -  CollectionView Delegate Datasource
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
            cell.detailLb.numberOfLines = 2
        }
        else {
            cell.detailLb.text = "We're now on the way to building your new home. All you have to do is swipe to see your build progress."
            cell.detailLb.numberOfLines = 0
            cell.lastUpdatedLb.isHidden = true
            cell.seeMoreBtn.isHidden = true
            
          
        }
        cell.setupCircularBar(progressColor: progressColors[indexPath.row], progress: clItems[indexPath.row].progress ?? 0 , cicleImage: UIImage(named : clItems[indexPath.row].imageName), index: indexPath.item)
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
        let vc = MyProgressDetailVC.instace(sb: .newDesignV4)
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
      //   print(indexOfPage)
        
        // print(indexOfPage.rounded())
        let index = indexOfPage.rounded(.up)
        let currentIndex : Int = Int(index)
       // print(currentIndex)
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
//        guard currentIndex >= 0 else {return}
//        gradientLayer.colors = [AppColors.appOrange.cgColor,progressColors[currentIndex].cgColor]
        
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
    var date : Date {
        return dateactual?.components(separatedBy: ".").first?.getDate() ?? Date()
    }
    var dateWithoutTime : Date
    {
        return dateactual?.components(separatedBy: "T").first?.getDate("yyyy-MM-dd") ?? Date()
    }
}
