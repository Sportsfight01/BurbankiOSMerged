//
//  MyPlaceHomeVC.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 26/03/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit
import SDWebImage



class MyPlaceHomeVC: UIViewController {
    
    //MARK: - Properties
    @IBOutlet weak var btnMyProfile: UIButton!
    @IBOutlet weak var btnState: UIButton!
    @IBOutlet weak var btnIcon: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnBackWidth: NSLayoutConstraint!
    @IBOutlet weak var btnStateLeading: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var lBMyPlace: UILabel!
    @IBOutlet weak var lBWelcome: UILabel!
    @IBOutlet weak var lBChooseMethod: UILabel!
    
    
    @IBOutlet weak var viewHomeDesign: UIView!
    @IBOutlet weak var btnHomeDesign: UIButton!
    @IBOutlet weak var lBHomeDesignTitle: UILabel!
    @IBOutlet weak var lBHomeDesignSubTitle: UILabel!
    @IBOutlet weak var iconHomeDesign: UIImageView!
    
    
    @IBOutlet weak var viewHomeLand: UIView!
    @IBOutlet weak var btnHomeLand: UIButton!
    @IBOutlet weak var lBHomeLandTitle: UILabel!
    @IBOutlet weak var lBHomeLandSubTitle: UILabel!
    @IBOutlet weak var iconHomeLand: UIImageView!
    
    
    @IBOutlet weak var viewHomeDisplay: UIView!
    @IBOutlet weak var btnHomeDisplay: UIButton!
    @IBOutlet weak var lBHomeDisplayTitle: UILabel!
    @IBOutlet weak var lBHomeDisplaySubTitle: UILabel!
    @IBOutlet weak var iconHomeDisplay: UIImageView!
    
    
    @IBOutlet weak var containerViewShare: UIView!
    
    @IBOutlet weak var stateView: UIView!
    let favCountLb = UILabel()
    
    var containerViewRegion: UIView?
    var regionVC: RegionVC = kStoryboardMain.instantiateViewController(withIdentifier: "RegionVC") as! RegionVC
    
    
    var containerViewStateSelection: UIView?
    var stateSelectionVC: StateSelectionVC = kStoryboardMain.instantiateViewController(withIdentifier: "StateSelectionVC") as! StateSelectionVC
    
    var containerView: UIView?
    lazy var profileView: UserProfileVC = {
        kStoryboardMain.instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileVC
    }()
    var shareVC: ShareVC?
    private let fetchedPackgesApi = "fetchedPackgesApi"
    var firstTimeLoading = true
    
    
    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        handleUISetup()
        
        LocationServices.shared.requestUsertoAllowLocationPermissions()
        
        
        if kUserState == String.zero() || kUserState == String.empty() {
            stateView.isHidden = true
            getStates ()
        }else {
            
            setRegionText() //state
            
            DashboardDataManagement.shared.getRegions(stateId: kUserState, showActivity: false) { (regions) in
                
            }
        }
        
        
        if (Int(kUserID) ?? 0) > 0 {
            
            btnBackWidth.constant = 0
            btnStateLeading.constant = 0
            
            ProfileDataManagement.shared.getProfileDetails(appDelegate.userData?.user ?? UserBean.init()) {
                //                            if let url = appDelegate.userData?.user?.userProfileImageURL {
                //                                self.addProfileImage(url)
                //                            }
            }
            
            ProfileDataManagement.shared.getSearchTypes {
                
            }
            
        }else {
            
            btnBackWidth.constant = 10
            btnStateLeading.constant = 15
        }
        
        
        containerViewShare.isHidden = true
        
        
        CodeManager.sharedInstance.sendScreenName(burbank_dashboard_screen_loading)
    
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideProfileView()
        
        //        if let url = appDelegate.userData?.user?.userProfileImageURL {
        //            addProfileImage(url)
        //        }
        self.btnIcon.layer.cornerRadius = self.btnIcon.frame.size.height/2
        let totalFavCount = kDesignFavoritesCount + kHomeLandFavoritesCount + kDisplayHomesFavoritesCount
        self.favCountLb.text = "\(totalFavCount)"
      //  favCountLb.isHidden = totalFavCount > 0 ? false : true
        ProfileDataManagement.shared.getDisplayHomesFavoriteCount { favouritetCount in
            print(log: "DisplayHomes Favourite COunt \(String(describing: favouritetCount))")
        }
      
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
     
        self.btnIcon.layer.cornerRadius = self.btnIcon.frame.size.height/2
       // favCountLb.isHidden = totalFavCount > 0 ? false : true
       
        
    }
    
    
    //MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "share" {
            shareVC = segue.destination as? ShareVC
            
            shareVC?.getInvitations()
            
            shareVCShowHideActions ()
        }
    }
    
    func shareVCShowHideActions () {
        
        shareVC?.showShare = {
            
            self.containerViewShare.isHidden = false
            
            self.view.bringSubviewToFront(self.containerViewShare)
            
            for user in self.shareVC!.invitations {
                if user.userDetails?.invitationStatus == 1 {
                    self.shareVC?.fillPopupDetails(user, shareToOthers: false)
                }
            }
            
        }
        
        shareVC?.closeShare = {
            
            self.containerViewShare.isHidden = true
            
            self.view.sendSubviewToBack(self.containerViewShare)
            
        }
    }
    
    
    //MARK: - View
    
    func handleUISetup () {
        
        btnMyProfile.backgroundColor = kUserID == "0" ? APPCOLORS_3.LightGreyDisabled_BG : APPCOLORS_3.EnabledOrange_BG
        btnMyProfile.layer.cornerRadius = 5.0
        
        _ = setAttributetitleFor(view: lBMyPlace, title: "MyPlace", rangeStrings: ["My", "Place"], colors: [AppColors.black, AppColors.black ], fonts: [FONT_LABEL_BODY(size: 55) , FONT_LABEL_SUB_HEADING(size: 55)], alignmentCenter: true)
        setAppearanceFor(view: view, backgroundColor: AppColors.white)
        
        setAppearanceFor(view: btnState, backgroundColor: COLOR_CLEAR, textColor: AppColors.darkGray , textFont: FONT_BUTTON_SUB_HEADING(size: FONT_13))
        
        
        setAppearanceFor(view: lBWelcome, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_SUB_HEADING(size: FONT_11))
        setAppearanceFor(view: lBChooseMethod, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_SUB_HEADING(size: FONT_13))
        
        
        setAppearanceFor(view: lBHomeDesignTitle, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_SUB_HEADING(size: FONT_11))
        setAppearanceFor(view: lBHomeDesignSubTitle, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont , textFont: FONT_LABEL_BODY(size: FONT_10))
        
        
        setAppearanceFor(view: lBHomeLandTitle, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_SUB_HEADING(size: FONT_11))
        setAppearanceFor(view: lBHomeLandSubTitle, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont , textFont: FONT_LABEL_BODY(size: FONT_10))
        
        setAppearanceFor(view: lBHomeDisplayTitle, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_SUB_HEADING(size: FONT_11))
        setAppearanceFor(view: lBHomeDisplaySubTitle, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont , textFont: FONT_LABEL_BODY(size: FONT_10))
        
        //make card vuew
        
        viewHomeLand.cardView()
        viewHomeDesign.cardView()
        viewHomeDisplay.cardView()
        //stateView
        stateView.layer.cornerRadius = stateView.frame.height/2
        //stateView.clipsToBounds = true
        stateView.layer.borderWidth = 1.0
        stateView.layer.borderColor = APPCOLORS_3.Black_BG.cgColor
        
        self.btnIcon.layer.cornerRadius = self.btnIcon.frame.size.height/2
        self.btnIcon.clipsToBounds = true
        
        let totalFavCount = kDesignFavoritesCount + kHomeLandFavoritesCount + kDisplayHomesFavoritesCount
        
        //MyProfile favorites count label
        
        favCountLb.text = "\(totalFavCount)"
        
        favCountLb.backgroundColor = .gray
        favCountLb.textColor = .white
        favCountLb.font = FONT_LABEL_SUB_HEADING(size: 12.0)
        favCountLb.layer.cornerRadius = 9
        favCountLb.clipsToBounds = true
        favCountLb.textAlignment = .center
        let isFavAvailable = kUserID == "0" ? false : true
       
        if isFavAvailable{
//            favCountLb.isHidden = false
            btnMyProfile.addSubview(favCountLb)
            favCountLb.translatesAutoresizingMaskIntoConstraints = false
            favCountLb.topAnchor.constraint(equalTo: btnMyProfile.topAnchor , constant: -9).isActive = true
            favCountLb.trailingAnchor.constraint(equalTo: btnMyProfile.trailingAnchor, constant: 9).isActive = true
            favCountLb.heightAnchor.constraint(equalToConstant: 18).isActive = true
            favCountLb.widthAnchor.constraint(equalToConstant: 18).isActive = true
        }
        
        
        
    }
    
    func addRegionView () {
        
        let viewContro =  /*self.tabBarController ??*/ self
        let viewSuper = viewContro.view!
        
        
        containerViewRegion = UIView()
        
        
        containerViewRegion!.backgroundColor = COLOR_CUSTOM_VIEWS_OVERLAY
        
        containerViewRegion!.translatesAutoresizingMaskIntoConstraints = false
        
        viewSuper.addSubview(containerViewRegion!)
        
        viewSuper.bringSubviewToFront(containerViewRegion!)
        
        
        NSLayoutConstraint.activate([
            containerViewRegion!.leadingAnchor.constraint(equalTo: viewSuper.leadingAnchor, constant: 0),
            containerViewRegion!.trailingAnchor.constraint(equalTo: viewSuper.trailingAnchor, constant: 0),
            containerViewRegion!.topAnchor.constraint(equalTo: viewSuper.topAnchor, constant: 0),
            containerViewRegion!.bottomAnchor.constraint(equalTo: viewSuper.bottomAnchor, constant: 0),
        ])
        
        
        viewContro.addChild(regionVC)
        regionVC.view.translatesAutoresizingMaskIntoConstraints = false
        containerViewRegion!.addSubview(regionVC.view)
        
        NSLayoutConstraint.activate([
            regionVC.view.leadingAnchor.constraint(equalTo: containerViewRegion!.leadingAnchor, constant: 0),
            regionVC.view.trailingAnchor.constraint(equalTo: containerViewRegion!.trailingAnchor, constant: 0),
            regionVC.view.topAnchor.constraint(equalTo: containerViewRegion!.topAnchor, constant: 0),
            regionVC.view.bottomAnchor.constraint(equalTo: containerViewRegion!.bottomAnchor, constant: 0)
        ])
        
        regionVC.view.backgroundColor = COLOR_CUSTOM_VIEWS_OVERLAY
        regionVC.view.backgroundColor = COLOR_CLEAR
        
        
        regionVC.didMove(toParent: viewContro)
        
        regionVC.delegate = self
        
        containerViewRegion!.isHidden = false
        
        
    }
    
    func showRegionView () {
        
        if let viewRegion = containerViewRegion {
            
            viewRegion.isHidden = false
            (/*self.tabBarController ?? */self).view.bringSubviewToFront(viewRegion)
        }else {
            
            addRegionView()
        }
    }
    
    func hideRegionView () {
        
        containerViewRegion!.isHidden = true
    }
    
    
    //MARK: - Set State
    
    func setRegionText () {
        
        let region = String(format: "%@         ", appDelegate.userData?.user?.userDetails?.userState ?? "")
        
        btnState.setTitle(region, for: .normal)
        
        //        btnState.superview?.layer.cornerRadius = (btnState.superview?.frame.size.height)!/2 //radius_3
        //        setBorder(view: btnState.superview!, color: APPCOLORS_3.HeaderFooter_white_BG, width: 1)
    }
    
    
    
    //MARK: - State
    
    func addStateView () {
        
        let viewContro =  /*self.tabBarController ??*/ self
        let viewSuper = viewContro.view!
        
        
        containerViewStateSelection = UIView()
        
        
        containerViewStateSelection!.backgroundColor = COLOR_CUSTOM_VIEWS_OVERLAY
        
        containerViewStateSelection!.translatesAutoresizingMaskIntoConstraints = false
        
        viewSuper.addSubview(containerViewStateSelection!)
        
        viewSuper.bringSubviewToFront(containerViewStateSelection!)
        
        
        NSLayoutConstraint.activate([
            containerViewStateSelection!.leadingAnchor.constraint(equalTo: viewSuper.leadingAnchor, constant: 0),
            containerViewStateSelection!.trailingAnchor.constraint(equalTo: viewSuper.trailingAnchor, constant: 0),
            containerViewStateSelection!.topAnchor.constraint(equalTo: viewSuper.topAnchor, constant: 0),
            containerViewStateSelection!.bottomAnchor.constraint(equalTo: viewSuper.bottomAnchor, constant: 0),
        ])
        
        
        viewContro.addChild(stateSelectionVC)
        stateSelectionVC.view.translatesAutoresizingMaskIntoConstraints = false
        containerViewStateSelection!.addSubview(stateSelectionVC.view)
        
        NSLayoutConstraint.activate([
            stateSelectionVC.view.leadingAnchor.constraint(equalTo: containerViewStateSelection!.leadingAnchor, constant: 0),
            stateSelectionVC.view.trailingAnchor.constraint(equalTo: containerViewStateSelection!.trailingAnchor, constant: 0),
            stateSelectionVC.view.topAnchor.constraint(equalTo: containerViewStateSelection!.topAnchor, constant: 0),
            stateSelectionVC.view.bottomAnchor.constraint(equalTo: containerViewStateSelection!.bottomAnchor, constant: 0)
        ])
        
       // stateSelectionVC.view.backgroundColor = APPCOLORS_3.HeaderFooter_white_BG
        stateSelectionVC.view.backgroundColor = COLOR_CLEAR
        
        
        stateSelectionVC.didMove(toParent: viewContro)
        
        stateSelectionVC.delegateState = self
        
        containerViewStateSelection!.isHidden = false
        
    }
    
    func showStateSelectionView (_ states: [State]) {
        
        if let viewStates = containerViewStateSelection {
            
            viewStates.isHidden = false
            (/*self.tabBarController ?? */self).view.bringSubviewToFront(viewStates)
        }else {
            
            addStateView()
        }
        
        stateSelectionVC.arrStates = states
        
        if kUserState != String.zero() {
            for stat in states {
                if stat.stateId == kUserState {
                    
                    stateSelectionVC.statePrevious = State()
                    stateSelectionVC.statePrevious?.stateName = String(format: "%@", stat.stateName)
                    stateSelectionVC.statePrevious?.stateId = String(format: "%@", stat.stateId)
                    
                    stateSelectionVC.stateSelected = stat
                    break
                }
            }
        }
        
        stateSelectionVC.layoutTable ()
        
    }
    
    func hideStateSelectionView () {
        
        containerViewStateSelection!.isHidden = true
        stateView.isHidden = false
        
    }
    
    
    //MARK: - Button Actions
    
    @IBAction func handleBtnMyProfileAction(_ sender: UIButton) {
        
        CodeManager.sharedInstance.sendScreenName (burbank_dashboard_profile_button_touch)
        
        handleProfileImageAction(sender)
    }
    
    @IBAction func handleButtonActions (_ sender: UIButton) {
        
        //        fatalError("Manual crash")
        
        if sender == btnBack {
            
            appDelegate.userData?.removeUserDetails()
            appDelegate.userData?.user = UserBean()
            appDelegate.userData?.saveUserDetails()
            removeFilterFromDefaults()
            loadLoginView()
            
        }else if sender == btnIcon {
            
            //if user is logged in need to show the logoutpopUp
            if kUserID != "0" // not a guest user
            {
                //show popup
                BurbankApp.showAlert("Are you sure, you want to Logout?", self, ["NO", "YES"]) { (str) in
                    
                    if str == "YES" {
                        logoutUser()
                    }
                }
            }else {
                //go to main screen
                loadMainView()
            }
            
        }else if sender == btnState {
            
            getStates ()
            
            CodeManager.sharedInstance.sendScreenName (burbank_dashboard_selectState_button_touch)
            
        }/*else if sender == btnHomeDesign {
          
          self.navigationController?.popToRootViewController(animated: true)
          
          let collectionSurvey = kStoryboardMain.instantiateViewController(withIdentifier: "MyCollectionSurveyVC") as! MyCollectionSurveyVC
          self.navigationController?.pushViewController(collectionSurvey, animated: true)
          
          }else if sender == btnHomeLand {
          
          self.tabBarController?.selectedIndex = 1
          }else if sender == btnHomeDisplay {
          
          //            if let _ = getFilterFromDefaults() {
          self.tabBarController?.selectedIndex = 2
          //            }else {
          //                handleButtonActions(btnHomeDesign)
          //            }
          }*/
        else if sender == btnHomeDesign { // HomeDesign
            
            CodeManager.sharedInstance.sendScreenName (burbank_dashboard_homeDesigns_button_touch)
            //MARK: - HomeDesigns
            
            let dash = kStoryboardMain.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
            
            (dash as UITabBarController).selectedIndex = 0
            self.navigationController?.pushViewController(dash, animated: true)
            
        }else if sender == btnHomeLand { // HouseAndLand
            
            CodeManager.sharedInstance.sendScreenName (burbank_dashboard_homeAndLand_button_touch)
            //MARK: - Home & land
            let dash = kStoryboardMain.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
            
            dash.afterLoad = {
                (dash as UITabBarController).selectedIndex = 1
            }
            
            self.navigationController?.pushViewController(dash, animated: true)
            
            
            getHomeLandRecentSearchData (dash)
            
            
        }
        else if sender == btnHomeDisplay { // DisplayHomes
            CodeManager.sharedInstance.sendScreenName (burbank_dashboard_displayHomes_button_touch)
        
            let dash = kStoryboardMain.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
            (dash as UITabBarController).selectedIndex = 2
            self.navigationController?.pushViewController(dash, animated: true)
        }else{ // Favourite Tapped
            
            CodeManager.sharedInstance.sendScreenName (burbank_dashboard_displayHomes_button_touch)
      
            let dash = kStoryboardMain.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
            (dash as UITabBarController).selectedIndex = 3
            self.navigationController?.pushViewController(dash, animated: true)
            
        }
        
    }
    
    
    func handleProfileImageAction (_ sender: UIButton) {
        
        if noNeedofGuestUserToast(self) {
            
            if let _ = containerView {
                
            }else {
                addContainerView()
            }
            
            
            if containerView!.isHidden {
                showProfileView()
            }else {
                hideProfileView()
            }
        }
        
    }
    
    func addProfileImage (_ url: String) {
        
        //        if url.count > 0 {
        //
        //            guard let urlImage = URL (string: url) else { return }
        //
        //            SDImageCache.shared.removeImage(forKey: url, cacheType: .all) {
        //
        //                SDWebImageDownloader.shared.downloadImage(with: urlImage, options: .ignoreCachedResponse, progress: { (receivedsize, totalsize, targeturl) in
        //
        //
        //                }) { (image, data, error, finished) in
        //
        //                    if finished {
        //                        if let imageDownloaded = image {
        //                            self.btnIcon.setBackgroundImage(imageDownloaded, for: .normal)
        //                        }else {
        //                            self.btnIcon.setBackgroundImage(Image_defaultDP, for: .normal)
        //                        }
        //                    }
        //                }
        //
        //            }
        //
        //            //            ImageDownloader.removeImage(forKey: url) {
        //            //
        //            //                ImageDownloader.downloadImage(withUrl: url, withFilePath: nil, with: { (image, success, error) in
        //            //
        //            //                    if success, let img = image {
        //            //                        self.btnIcon.setBackgroundImage(img, for: .normal)
        //            //                    }else {
        //            //                        self.btnIcon.setBackgroundImage(Image_defaultDP, for: .normal)
        //            //                    }
        //            //
        //            //                }) { (progress) in
        //            //
        //            //                }
        //            //            }
        //
        //
        //            //            downloadImage(from: urlImage) { (image, error, success) in
        //            //
        //            //                DispatchQueue.main.async() {
        //            //
        //            //                    if success, let img = image {
        //            //                        self.btnIcon.setBackgroundImage(img, for: .normal)
        //            //                    }else {
        //            //                        self.btnIcon.setBackgroundImage(Image_defaultDP, for: .normal)
        //            //                    }
        //            //                }
        //            //            }
        //
        //
        //        }else{
        //
        //        }
    }
    
    
    func getHomeLandRecentSearchData (_ dashbo: DashboardVC) {
        
        
        ProfileDataManagement.shared.recentSearchData(SearchType.shared.homeLand, Int(kUserState)!, kUserID, succe: { (recentSearchJson) in
            
            if let recent = recentSearchJson {
                
                let recentSearch = SortFilter (dict: recent.value(forKey: "SearchJson") as! NSDictionary, recentsearch: true)
                
                if let VCs = (dashbo as UITabBarController).viewControllers {
                    
                    (VCs[1] as! UINavigationController).popToRootViewController(animated: true)
                    
                    let homeLand = (VCs[1] as! UINavigationController).viewControllers[0] as! HomeLandVCSurvey
                    
                    let recentSearchText = self.recentSearchString(with: recentSearch)
                    
                    
                    setHomeLandFavouritesCount(count: (recent.value(forKey: "UserFavourites") as? NSNumber)?.intValue ?? 0, state: kUserState)
                    
                    
                    if recentSearchText != "" {
                        
                        CodeManager.sharedInstance.sendScreenName(burbank_homeAndLand_recentQuiz_screen_loading)
                        
                        
                        appDelegate.userData?.user?.userDetails?.homeLandSortFilter = SortFilter (dict: recent.value(forKey: "SearchJson") as! NSDictionary, recentsearch: true)
                        
                        appDelegate.userData?.saveUserDetails()
                        appDelegate.userData?.loadUserDetails()
                        
                        
                        homeLand.recentSearch?.recentSearchFrom = "House&Land"
                        
                        homeLand.recentSearch?.recentSearch.text = recentSearchText.capitalized
                        
                        homeLand.viewRecentSearch.isHidden = false
                        homeLand.view.bringSubviewToFront(homeLand.viewRecentSearch)
                        
                        homeLand.recentSearch?.showAction = {
                            
                            CodeManager.sharedInstance.sendScreenName(burbank_homeAndLand_recentQuiz_showDesigns_button_touch)
                            
                            homeLand.filter = recentSearch
                            homeLand.selectAllViewsBasedonFilter ()
                            
                            homeLand.moveToHomeLandListPage ()
                            
                            homeLand.viewRecentSearch.isHidden = true
                            homeLand.view.sendSubviewToBack (homeLand.viewRecentSearch)
                        }
                        
                        homeLand.recentSearch?.startNewAction = {
                            
                            CodeManager.sharedInstance.sendScreenName(burbank_homeAndLand_recentQuiz_startNew_button_touch)
                            
                            homeLand.viewRecentSearch.isHidden = true
                            homeLand.view.sendSubviewToBack (homeLand.viewRecentSearch)
                        }
                        
                    }
                }
                
            }else {
                
                if let VCs = (dashbo as UITabBarController).viewControllers {
                    let homeLand = (VCs[1] as! UINavigationController).viewControllers[0] as! HomeLandVCSurvey
                    homeLand.filter = SortFilter ()
                    
                    (VCs[1] as! UINavigationController).popToRootViewController(animated: true)
                }
            }
        })
    }
    
    func recentSearchString (with filter: SortFilter) -> String {
        
        let myPlaceQuiz = MyPlaceQuiz ()
        let regionsArr =  filter.regionsArr.map{ $0.regionName }
        print("----1-1-1-1-1,",regionsArr)
        let regions = regionsArr.joined(separator: ",")
        print("----1-1-1-1-1,",regions)
        
        
        
        
        myPlaceQuiz.region = regions
        
        //        myPlaceQuiz.region = filter.region.regionName
        
        
        if filter.storeysCount == .one {
            
            myPlaceQuiz.storeysCount = "SINGLE"
        }else if filter.storeysCount == .two {
            
            myPlaceQuiz.storeysCount = "DOUBLE"
        }else {
            
            myPlaceQuiz.storeysCount = ""
        }
        
        
        if filter.bedRoomsCount == .three/* || filter.bedRoomsCount == .ALL*/ {
            
            myPlaceQuiz.bedRoomCount = "3 BED"
        }else if filter.bedRoomsCount == .four {
            
            myPlaceQuiz.bedRoomCount = "4 BED"
        }else if filter.bedRoomsCount == .five {
            
            myPlaceQuiz.bedRoomCount = "5+ BED"
        }else if filter.bedRoomsCount == .ALL {
            
            myPlaceQuiz.bedRoomCount = ""
        }
        
        if filter.priceRange.priceStart == 0, filter.priceRange.priceEnd == 1 {
            
            myPlaceQuiz.priceRangeLow = ""
            myPlaceQuiz.priceRangeHigh = ""
            
        }else {
            
            myPlaceQuiz.priceRangeLow = "$\(filter.priceRange.priceStartStringValue)K"
            myPlaceQuiz.priceRangeHigh = "$\(filter.priceRange.priceEndStringValue)K"
        }
        
        let str = myPlaceQuiz.filterStringDisplayHomes()
        
        return str == "Take a quick survey to find your perfect design" ? "" : str
    }
    
    
    
    //MARK:- Profile
    
    func showProfileView () {
        
        containerView!.isHidden = false
        profileView.setHeightForViewBasedonRowsHeight()
        profileView.getDisplaysNotificationsCount()
        profileView.tableProfile.reloadData()
        
        view.bringSubviewToFront(containerView!)
        
        profileView.completionHandlerProfile = { () -> Void in
            
            self.hideProfileView ()
            
            if let url = appDelegate.userData?.user?.userProfileImageURL {
                // self.addProfileImage(url)
                ImageDownloader.removeImage(forKey: url) {
                    self.addProfileImage(url)
                }
            }
        }
        
        profileView.completionHandlerProfilePicUpdate = {
            self.showProfileView()
        }
        
        profileView.updateProfileImage ()
        
        profileView.tableProfile.reloadData()
        profileView.getProfileNotificationsCount ()
        
        addLocationObserver ()
    }
    
    func hideProfileView () {
        
        self.profileView.selectedIndex = -1
        self.containerView?.isHidden = true
        
        removeLocationObserver()
    }
    
    
    
    private func addContainerView () {
        
        containerView = UIView ()
        
        containerView!.backgroundColor = COLOR_CLEAR
        containerView!.backgroundColor = COLOR_CUSTOM_VIEWS_OVERLAY.withAlphaComponent(0.6)
        
        containerView!.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView!)
        NSLayoutConstraint.activate([
            containerView!.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            containerView!.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            containerView!.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            //            containerView!.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: labelInfo.frame.origin.y + labelInfo.frame.size.height + 10),
            //            containerView!.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: headerViewHeight),
            containerView!.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])
        
        // add child view controller view to container
        addChild(profileView)
        profileView.view.translatesAutoresizingMaskIntoConstraints = false
        containerView!.addSubview(profileView.view)
        
        NSLayoutConstraint.activate([
            profileView.view.leadingAnchor.constraint(equalTo: containerView!.leadingAnchor, constant: 0),
            profileView.view.trailingAnchor.constraint(equalTo: containerView!.trailingAnchor, constant: 0),
            profileView.view.topAnchor.constraint(equalTo: containerView!.topAnchor, constant: 0),
            profileView.view.bottomAnchor.constraint(equalTo: containerView!.bottomAnchor, constant: 0)
        ])
        
        profileView.didMove(toParent: self)
        
        
        containerView!.isHidden = true
        
    }
    
    
}



extension MyPlaceHomeVC: RegionVCDelegate, StateSelectionVCDelegate {
    
    func handleRegionDelegate(close: Bool, regionBtn: Bool, region: RegionMyPlace) {
        
        hideRegionView ()
        
        appDelegate.userData?.user?.userDetails?.userRegion = region.regionName
        appDelegate.userData?.user?.userDetails?.userRegionId = region.regionId
        
        appDelegate.userData?.saveUserDetails()
        
        setRegionText()
    }
    
    func handleStateSelectionDelegate(close: Bool, stateBtn: Bool, state: State) {
        
        hideStateSelectionView ()
        
        //getDisplayHomesFavoriteCount()
        if close {
            
            
        }else {
            
            if appDelegate.userData?.user?.userDetails?.userState == "" {
                saveState(state)
            }else {
                
                if appDelegate.userData?.user?.userDetails?.userStateId == state.stateId {
                    saveState(state)
                }else {
                    
                    alert.showAlert("Select \(state.stateName)?", "Do you want to change the state?", self, ["No", "Yes"]) { (str) in
                        
                        if str == "Yes" {
                            self.saveState(state)
                        }
                    }
                }
            }
            
        }
    }
    
    
    func saveState (_ state: State) {
        
        appDelegate.userData?.user?.userDetails?.userState = state.stateName
        appDelegate.userData?.user?.userDetails?.userStateId = state.stateId
        
        appDelegate.userData?.saveUserDetails()
        
        appDelegate.userData?.loadUserDetails()
        
        
        showToast(String(format: "Selected State: %@", appDelegate.userData?.user?.userDetails?.userState ?? ""), self)
        
        self.setRegionText()
        
        removeRegionsfromDefaults ()
        
        DashboardDataManagement.shared.getRegions(stateId: kUserState, showActivity: false) { (regions) in
            
        }
        //MARK: - To Get favourite count of all modules
        ProfileDataManagement.shared.getProfileDetails { [weak self] flag in
            //count label
            let totalFavCount = kDesignFavoritesCount + kHomeLandFavoritesCount + kDisplayHomesFavoritesCount
            self?.favCountLb.text = "\(totalFavCount)"
            self?.favCountLb.isHidden = totalFavCount == 0 ? true : false
        }
        
    }
    
    
}





extension MyPlaceHomeVC {
    
    
    func getStates () {
        
        _ = Networking.shared.GET_request(url: ServiceAPI.shared.URL_states, userInfo: nil, success: { (json, response) in
            
            if let result: AnyObject = json {
                
                let result = result as! NSDictionary
                
                if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {
                    
                    let resultStates = result.value(forKey: "States") as! [NSDictionary]
                    
                    saveStatestoDefaults(resultStates as NSArray)
                    
                    if let states = kStatesMyPlace {
                        if states.count > 0 {
                            self.showStateSelectionView(states)
                        }
                    }
                }else {
                    print(log: "states not found")
                    ActivityManager.showToast(result.value(forKey: "message") as? String ?? "", self)
                }
                
            }else {
                
            }
            
        }, errorblock: { (error, isJSONerror)  in
            
            if isJSONerror {
                
            }else {
                
            }
        }, progress: nil)
        
    }
    
    
    
    
    func getPackages () {
        
        if isPackagesApiCalledToday() {
            
        }else {
            DashboardDataManagement.shared.getAllPackages(Int(kUserState)!) { (_) in
                self.makePackagesApiFetchedToday ()
                NetworkingManager.shared.arrayPackagesTasks.removeAllObjects()
            }
        }
    }
    
    
    func isPackagesApiCalledToday () -> Bool {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyy"
        
        if let dict: [String: Any] = UserDefaults.standard.value(forKey: fetchedPackgesApi) as? [String : Any] {
            if let _ = dict[dateFormatter.string(from: Date())] {
                //                makePackagesApiFetchedToday ()
                return true
            }
        }
        return false
    }
    
    func makePackagesApiFetchedToday () {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyy"
        
        UserDefaults.standard.setValue([dateFormatter.string(from: Date()) : "yes"], forKey: fetchedPackgesApi)
        UserDefaults.standard.synchronize()
    }
}


let kLocationPermissionChanges = "locationPermissionChanges"


extension MyPlaceHomeVC {
    
    func addLocationObserver () {
        
        NotificationCenter.default.addObserver(self, selector: #selector(locationPermissonsChanged), name: NSNotification.Name (kLocationPermissionChanges), object: nil)
        
    }
    
    func removeLocationObserver () {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name (kLocationPermissionChanges), object: nil)
    }
    
    
    @objc func locationPermissonsChanged () {
        
        self.profileView.tableProfile.reloadData()
        
    }
    
}
