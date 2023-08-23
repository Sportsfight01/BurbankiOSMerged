//
//  MyProgressVC.swift
//  BurbankApp
//
//  Created by naresh banavath on 17/11/21.
//  Copyright © 2021 DMSS. All rights reserved.
//



import UIKit
import Combine
import SkeletonView


class MyProgressVC: BaseProfileVC,UIGestureRecognizerDelegate {
    
    //MARK: - Properties
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var progressBar: HorizontalProgressBar!
    @IBOutlet weak var yourOverallProgressLb: UILabel!

    private var clItems : [MyProgressVM.ProgressItem]?
    private var viewModel = MyProgressVM()
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialUISetup()
        setupMultipleJobVc()
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
    
    //MARK: - Initial UI Setup Methods
    private func initialUISetup()
    {
        /// - Setting Background Image to View
        let imgeView = UIImageView(image: UIImage(named: "StagesBackground_Image"))
        imgeView.frame = view.frame
        view.insertSubview(imgeView, at: 0)
        yourOverallProgressLb.font = FONT_LABEL_BODY(size: FONT_12)
        setupTopViewUI()
        setupCollectionView()
        setupBinding()
    }
    private func setupTopViewUI()
    {
        profileView.titleLb.text = "MyProgress"
        profileView.helpTextLb.text = "--"
        profileView.profilePicImgView.tintColor = .darkGray
        profileView.titleLb.textColor = .black
        profileView.helpTextLb.textColor = .black
        profileView.profilePicImgView.borderColor = APPCOLORS_3.GreyTextFont
        [profileView.menubtn,profileView.contactUsBtn,profileView.navBarTitleImg].forEach({$0?.tintColor = .black})
        
        let panGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        panGestureRecognizer.direction = .down
        view.addGestureRecognizer(panGestureRecognizer)
        view.isUserInteractionEnabled = true
    }
    
    private func setupCollectionView()
    {
        collectionView.collectionViewLayout = compositionalLayout()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    private func compositionalLayout() -> UICollectionViewLayout
    {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(3/4), heightDimension: .fractionalHeight(1)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = 16.0
        section.visibleItemsInvalidationHandler = { [unowned self](visibleItems,contentOffset,layoutEnvironment) in
            debugPrint(contentOffset)
            let cellWidth = (0.75 * self.collectionView.frame.width)
            let spaceFromLeftSide = (self.collectionView.frame.width - cellWidth)/2
            let offSet = contentOffset.x + spaceFromLeftSide + 1
            print("offset : - \(offSet), cellWidth : \(cellWidth)")
            let index =  offSet / cellWidth
            let currentIndex : Int = Int(abs(index.rounded(.toNearestOrAwayFromZero)))
            debugPrint("currentIndex : \(currentIndex)")
            guard (0...6).contains(currentIndex) else {return}
            if currentIndex == 0
            {
                self.yourOverallProgressLb.text = "YOUR OVERALL PROGRESS"
            }
            else
            {
                self.yourOverallProgressLb.text = MyProgressCVCell.setupLastUpdateDate(progressData: clItems?[currentIndex].progressDetails).overallProgress
            }
           
            self.setupCurrentIndex(contentoffset: contentOffset)
        }
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    //MARK: - Bindings

    private func setupCurrentIndex(contentoffset : CGPoint)
    {
        debugPrint(contentoffset)
        let cellWidth = (0.75 * self.collectionView.frame.width)
        let spaceFromLeftSide = (self.collectionView.frame.width - cellWidth)/2
        let offSet = contentoffset.x + spaceFromLeftSide + 1
        print("offset : - \(offSet), cellWidth : \(cellWidth)")
        let index =  offSet / cellWidth
        let currentIndex : Int = Int(abs(index.rounded(.toNearestOrAwayFromZero)))
        debugPrint("currentIndex : \(currentIndex)")
        guard (0...6).contains(currentIndex) else {return}
        if currentIndex == 0
        {
            self.yourOverallProgressLb.text = "YOUR OVERALL PROGRESS"
        }
        else
        {
            self.yourOverallProgressLb.text = MyProgressCVCell.setupLastUpdateDate(progressData: clItems?[currentIndex].progressDetails).overallProgress
        }
    }
    //MARK: - Bindings
    private func setupBinding()
    {
        viewModel.financeVisibilityPublisher.sink {[weak self] shouldShowFinance in
            if shouldShowFinance {  self?.showFinanceTab() }
        }.store(in: &cancellables)
    }
    
    //MARK: - API Calls
    func callAPIs()
    {
        guard isNetworkReachable else { self.showAlert(message: checkInternetPullRefresh); return }
        getProgressDetails()
        getUserProfile()
        getNotification()
    }
    /// - PullToRefress Action
    @objc func panGestureRecognizerAction(sender: UISwipeGestureRecognizer) {
        
        if sender.state == .ended{
            callAPIs()
        }
        if sender.state == .began{
            appDelegate.showActivity()
        }
    }
    func setupMultipleJobVc()
    {
        
        let myplaceDetailsArray = appDelegate.currentUser?.userDetailsArray?.first?.myPlaceDetailsArray
        guard myplaceDetailsArray?.isEmpty == false else { return }// myplacedetailsarray is empty so return
        
        /// - User has multiple job numbers
        if (myplaceDetailsArray?.count ?? 0) > 1
        {
    
            let selectedJobNum = UserDefaults.standard.value(forKey: "selectedJobNumber") as? String
            if selectedJobNum == nil /// when user first come to select Job Number
            {
                self.tabBarController?.tabBar.isUserInteractionEnabled = false
                let vc = MultipleJobNumberVC.instace()
                vc.tableDataSource = myplaceDetailsArray?.compactMap({$0.jobNumber}) ?? []
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .coverVertical
                /// - if user loggedIn with Job Number show jobNumber as selected in multipleJobNumbers List
                if !isEmail(){
                    vc.previousJobNum = appDelegate.enteredEmailOrJob
                }
                /// - callback called after user selected job number from multiple jobnums
                vc.selectionClosure = {[weak self] selectedJobNumber in
                    UserDefaults.standard.set(selectedJobNumber, forKey: "selectedJobNumber")
                    self?.callAPIs()
                    self?.tabBarController?.tabBar.isUserInteractionEnabled = true
                }
                self.present(vc, animated: true)
            }else { /// when user already selected a job from his multiple jobNums go with normal Flow
                CurrentUser.jobNumber = selectedJobNum
                self.callAPIs()
            }
            
        }
        /// - Users with single JobNumber
        else
        {
            callAPIs()
        }
    }
    
    func showFinanceTab()
    {
            /// - add financeTab only if it not added
            guard self.tabBarController?.viewControllers?.count == 4 else {return}
            let vc = UINavigationController(rootViewController: FinanceVC.instace())
            vc.tabBarItem = UITabBarItem(title: "FINANCE", image: UIImage(named : "Finance_grey") , selectedImage: UIImage(named : "Finance_orange"))
            self.tabBarController?.viewControllers?.append(vc)
    }

    func setupDataForCollectionView()
    {
        /// - Calculating whole home progress
        guard let clItems else { return }
        let totalHomeProgress = Double(clItems.compactMap({$0.progress}).reduce(0.0, +)) / 6.0
        let totalHomeProgressPercentage = Int(Double(totalHomeProgress * 100).rounded(.toNearestOrAwayFromZero))
        
        let newClItem = MyProgressVM.ProgressItem(stage: Stage(rawValue: "Your New Home"), imageName: "icon_house", progress: totalHomeProgress,progressDetails: nil)
        /// - add Your new home in first place only when it is not present in list
        if !clItems.contains(where: {$0.stage?.rawValue == "Your New Home" }){
            print("Added your new home")
            self.clItems?.insert(newClItem, at: 0)
        }
        
        /// - add data to UI Elements
        progressBar.progress = CGFloat(totalHomeProgress)
        let yourHomeBuild = "Your home \(CurrentUser.jobNumber ?? "") is currently \(totalHomeProgressPercentage)% completed. Swipe to see your stages."
        setAttributetitleFor(view: profileView.helpTextLb, title: yourHomeBuild, rangeStrings: ["Your home" , CurrentUser.jobNumber ?? "", "is currently", "\(totalHomeProgressPercentage)%" , "completed. Swipe to see your stages."], colors: [APPCOLORS_3.Black_BG,APPCOLORS_3.Orange_BG,APPCOLORS_3.Black_BG,APPCOLORS_3.Black_BG,APPCOLORS_3.Black_BG], fonts: [FONT_LABEL_BODY(size: FONT_10), boldFontWith(size: FONT_10),FONT_LABEL_BODY(size: FONT_10),boldFontWith(size: FONT_10),FONT_LABEL_BODY(size: FONT_10)], alignmentCenter: false)
        
        
        collectionView.reloadData()
        collectionView.contentSize.width = collectionView.contentSize.width + 50 // to make last item of collectionView visible properly
        CurrentUser.currentHomeBuildProgress = "\(totalHomeProgressPercentage)%"
        
    }
    
    
    //MARK: - Service Calls
    func getProgressDetails()
    {
        self.collectionView.showAnimatedGradientSkeleton()
        viewModel.getProgressData {[weak self] result in
            DispatchQueue.main.async{
                self?.collectionView.stopSkeletonAnimation()
                self?.view.hideSkeleton()
            }
            switch result
            {
            case .success(let ProgressItems):
                self?.clItems = ProgressItems
                self?.setupDataForCollectionView()
                break
            case .failure(let err):
                AlertManager.sharedInstance.showAlert(alertMessage: err.localizedDescription)
            }
        }
    }
    
    func getUserProfile()
    {
        
        guard let userID = appDelegate.currentUser?.userDetailsArray?.first?.id else { return }
        let parameters : [String : Any] = ["Id" : userID]
        NetworkRequest.makeRequest(type: GetUserProfileStruct.self, urlRequest: Router.getUserProfile(parameters: parameters), showActivity: false) { [weak self]result in
            switch result
            {
            case .success(let data):
                //print(data)
                guard data.status == true else {
                    DispatchQueue.main.async {
                        self?.showAlert(message: data.message ?? somethingWentWrong)
                    };return}
                CurrentUser.email = data.result?.email
                CurrentUser.userName = data.result?.userName
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
 //MARK: - CollectionViewCell Delegate
extension MyProgressVC : MyProgressCellDelegate
{
    func didTappedSeeMoreButton(index: Int) {
        guard let model = clItems?[index] else {return}
        let vc = MyProgressDetailVC.instace(sb: .newDesignV4)
        vc.progressData = model
        guard index > 0 else {return} //First Cell should not get tapped as it has just total home info
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension MyProgressVC : UICollectionViewDelegate , SkeletonCollectionViewDataSource
{
     //MARK: - SkeletonView DataSource
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "MyProgressCVCell"
    }
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    //MARK: -  CollectionView Delegate Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return clItems?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyProgressCVCell", for: indexPath) as! MyProgressCVCell
        cell.delegate = self
        let model = clItems?[indexPath.row]
        cell.setup(model: model, index : indexPath.row)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didTappedSeeMoreButton(index: indexPath.row)
    }
  
}


