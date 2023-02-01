//
//  HeaderVC.swift
//  MyPlace
//
//  Created by Sreekanth tadi on 19/03/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit
import SDWebImage

protocol ChildVCDelegate: NSObject {
    
    func handleActionFor (sort: Bool, map: Bool, favourites: Bool, howWorks:Bool, reset:Bool)
}

var headerViewHeight = 0.238*SCREEN_HEIGHT //135 for 375 width 667 height

let logoImageHeight = headerViewHeight*0.37 //48 for 375 width 667 height
let logoImageWidth = SCREEN_WIDTH*0.512


let profileImageHeight = SCREEN_WIDTH*0.123 //46 for 375 width 667 height



let infoStaicText = "Take a quick survey to find your perfect design"

var statusBarHeight = { () -> CGFloat in
    
    if #available(iOS 11.0, *) {
        return kWindow.safeAreaInsets.top
    }
    return CGFloat(20.0)
}



let profileHeaderHeight = statusBarHeight() + 15 + profileImageHeight + 40/*info label height*/ + 20 /* padding */




var basicFont: CGFloat = FONT_25
var logoFont: UIFont {
    return FONT_LABEL_HEADING (size: basicFont)
}
var logoFontSubHedding: UIFont {
    return FONT_LABEL_SUB_HEADING (size: basicFont)
}
var logoFontRegular: UIFont {
    return FONT_LABEL_BODY (size: basicFont)
}


class HeaderVC: UIViewController {
    let favCountLb = UILabel()
    weak var childVCDelegate: ChildVCDelegate?
    
    lazy var profileView: UserProfileVC = {
        kStoryboardMain.instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileVC
    }()
    
    lazy var sortFilterView: SortFilterVC = {
        kStoryboardMain.instantiateViewController(withIdentifier: "SortFilterVC") as! SortFilterVC
    }()
    
    var headerView_header = UIView()
    
    var labelLine = UILabel()
    var logoLabel: UILabel = UILabel()
    var profileImage = ProfileButton()

    
    
    var breadcrumbView = HeaderBreadCrump (frame: .zero)
    var heightCollection: NSLayoutConstraint?

    
    
//    var labelInfo = UILabel()
    var btnBack = UIButton()
    var btnBackProfile = UIButton()
    
   // var btnHome = UIButton()

    var btnBackFull = UIButton()
    
    
    var optionsView = UIView()
    
    var btnHowWorks = UIButton(frame: .zero)
    var btnSortFilter = UIButton(frame: .zero)
    var btnMap = UIButton(frame: .zero)
    var btnMyProfile = UIButton(frame: .zero)
    
    var btnReset = UIButton(frame: .zero)
    var btnTotalCollectionCount = UIButton(frame: .zero)
    
    var containerView: UIView?
    
    var containerViewSortFilter: UIView?
    
    
    
    var headerLogoText: String? {
        didSet {
            
            
            //var rangeStrings : [String] = []
            
            switch headerLogoText {
                
            case "House&Land":
                _ = setAttributetitleFor(view: logoLabel, title: headerLogoText!, rangeStrings: ["House&" , "Land"], colors: [APPCOLORS_3.GreyTextFont , APPCOLORS_3.GreyTextFont], fonts: [FONT_LABEL_BODY(size: 30) , FONT_LABEL_SUB_HEADING(size : 30)], alignmentCenter: false)
                
            case "HomeDesigns":
                _ = setAttributetitleFor(view: logoLabel, title: headerLogoText!, rangeStrings: ["Home" , "Designs"], colors: [APPCOLORS_3.GreyTextFont , APPCOLORS_3.GreyTextFont], fonts: [FONT_LABEL_BODY(size: 30) , FONT_LABEL_SUB_HEADING(size : 30)], alignmentCenter: false)
            case "MyFavourites":
                _ = setAttributetitleFor(view: logoLabel, title: headerLogoText!, rangeStrings: ["My" , "Favourites"], colors: [APPCOLORS_3.GreyTextFont , APPCOLORS_3.GreyTextFont], fonts: [FONT_LABEL_BODY(size: 30) , FONT_LABEL_SUB_HEADING(size : 30)], alignmentCenter: false)
            case "MyProfile":
                _ = setAttributetitleFor(view: logoLabel, title: headerLogoText!, rangeStrings: ["My" , "Profile"], colors: [APPCOLORS_3.GreyTextFont , APPCOLORS_3.GreyTextFont], fonts: [FONT_LABEL_BODY(size: 30) , FONT_LABEL_SUB_HEADING(size : 30)], alignmentCenter: false)
                
            case "DisplayHomes":
                _ = setAttributetitleFor(view: logoLabel, title: headerLogoText!, rangeStrings: ["Display" , "Homes"], colors: [APPCOLORS_3.GreyTextFont , APPCOLORS_3.GreyTextFont], fonts: [FONT_LABEL_BODY(size: 30) , FONT_LABEL_SUB_HEADING(size : 30)], alignmentCenter: false)
            
            default :
                setAppearanceFor(view: logoLabel, backgroundColor: .clear, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_SUB_HEADING(size : 30))
                logoLabel.text = headerLogoText
            }
            
            
            
            
//            if self.headerLogoText!.contains("My") {
//                setAppearanceFor(view: logoLabel, backgroundColor: logoLabel.backgroundColor!, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: logoFont)
//                let _ = setAttributetitleFor(view: logoLabel, title: self.headerLogoText!, rangeStrings: ["My"], colors: [APPCOLORS_3.Black_BG], fonts: [logoFont], alignmentCenter: false)
//            } else if  self.headerLogoText!.contains("Displays") {
//                setAppearanceFor(view: logoLabel, backgroundColor: logoLabel.backgroundColor!, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: logoFont)
//                let _ = setAttributetitleFor(view: logoLabel, title: self.headerLogoText!, rangeStrings: ["Displays"], colors: [APPCOLORS_3.Black_BG], fonts: [logoFont], alignmentCenter: false)
//            }
//            else if  self.headerLogoText!.contains("Home") {
//                setAppearanceFor(view: logoLabel, backgroundColor: logoLabel.backgroundColor!, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: logoFont)
//                let _ = setAttributetitleFor(view: logoLabel, title: self.headerLogoText!, rangeStrings: ["Home"], colors: [APPCOLORS_3.Black_BG], fonts: [logoFontRegular], alignmentCenter: false)
//            }
//            else if  self.headerLogoText!.contains("Designs") {
//                setAppearanceFor(view: logoLabel, backgroundColor: logoLabel.backgroundColor!, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: logoFont)
//                let _ = setAttributetitleFor(view: logoLabel, title: self.headerLogoText!, rangeStrings: ["Designs"], colors: [APPCOLORS_3.Black_BG], fonts: [logoFontSubHedding], alignmentCenter: false)
//            }
//            else{
//                setAppearanceFor(view: logoLabel, backgroundColor: logoLabel.backgroundColor!, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: logoFont)
//                let _ = setAttributetitleFor(view: logoLabel, title: self.headerLogoText!, rangeStrings: [""], colors: [APPCOLORS_3.HeaderFooter_white_BG], fonts: [logoFont], alignmentCenter: false)
//            }
        }
    }
    
    
    
    
    var quizPriceMinimumValue: String?
    var quizPriceMaximumValue: String?
    
    var filter: SortFilter = SortFilter()
    
    
    
    
    var updated: Bool = false
    
    
    
    
    
    var isFromProfile: Bool = false

    
    
    
    //MARK: - ViewLife cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        headerLogoText = "MyPlace"
        
        
        addHeaderView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       // self.profileImage.isHidden = isFromProfile
        profileImage.layer.cornerRadius = profileImage.frame.size.height/2
        profileImage.clipsToBounds = true
        profileImage.setImage(UIImage(named: "BurbankLogo"), for: .normal)
        
        hideProfileView()
        hideSortFilterView()
        
        if updated == false {
            updateTopConstraint()
            updated = true
        }
        
//        if let url = appDelegate.userData?.user?.userProfileImageURL {
//            addProfileImage(url)
//        }
//
       
        
        
        breadcrumbView.addObserver()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        breadcrumbView.removeObserver()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
       // breadcrumbView.reloadViewItems()
    }
    
    func addProfileImage (_ url: String?) {
        
//        if let imageURL = url {
//            
//            guard let urlImage = URL (string: imageURL) else { return }
//            
//            SDImageCache.shared.removeImage(forKey: url, cacheType: .all) {
//                
//                SDWebImageDownloader.shared.downloadImage(with: urlImage, options: .ignoreCachedResponse, progress: { (receivedsize, totalsize, targeturl) in
//
//                }) { (image, data, error, finished) in
//
//                    if finished {
//                        if let imageDownloaded = image {
//                            self.profileImage.setBackgroundImage(imageDownloaded, for: .normal)
//                        }else {
//                            self.profileImage.setBackgroundImage(Image_defaultDP, for: .normal)
//                        }
//                    }
//                }
//
//            }
//
////            ImageDownloader.removeImage(forKey: url) {
////
////                ImageDownloader.downloadImage(withUrl: imageURL, withFilePath: nil, with: { (image, success, error) in
////
////                    if success, let img = image {
////
////                        self.profileImage.setBackgroundImage(img, for: .normal)
////                    }else {
////                        self.profileImage.setBackgroundImage(Image_defaultDP, for: .normal)
////                    }
////
////                    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height/2
////                    self.profileImage.clipsToBounds = true
////
////                }) { (progress) in
////
////                }
////            }
//            
////            downloadImage(from: urlImage) { (image, error, success) in
////
////                DispatchQueue.main.async() {
////
////                    if success, let img = image {
////                        self.profileImage.setBackgroundImage(img, for: .normal)
////                    }else {
////                        self.profileImage.setBackgroundImage(Image_defaultDP, for: .normal)
////                    }
////                }
////            }
//            
//            
//        }else{
//            
//        }
    }
        
    
    
    // MARK: - Header view
    
     func addHeaderView () {
        
         headerView_header.backgroundColor = AppColors.white
        //headerView_header.tintColor = APPCOLORS_3.Orange_BG
        
        headerView_header.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(headerView_header)
        
        
        NSLayoutConstraint.activate([
            headerView_header.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            headerView_header.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            headerView_header.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
        ])
        
        headerView_header.layoutIfNeeded()
        
        addHeaderViewOptions()
        
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
            containerView!.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])
        
        // add child view controller view to container
        
        addChild(profileView)
        //            addChildViewController(controller)
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
    
    
    private func addContainerViewSortFilter () {
        
        let viewContro = (tabBarController as? DashboardVC) ?? self
        let viewSuper = viewContro.view!
        
        
        containerViewSortFilter = UIView ()
        
        containerViewSortFilter!.backgroundColor = COLOR_CUSTOM_VIEWS_OVERLAY
        
        containerViewSortFilter!.translatesAutoresizingMaskIntoConstraints = false
        
        viewSuper.addSubview(containerViewSortFilter!)
        
        viewSuper.bringSubviewToFront(containerViewSortFilter!)
        
        
        NSLayoutConstraint.activate([
            containerViewSortFilter!.leadingAnchor.constraint(equalTo: viewSuper.leadingAnchor, constant: 0),
            containerViewSortFilter!.trailingAnchor.constraint(equalTo: viewSuper.trailingAnchor, constant: 0),
            containerViewSortFilter!.topAnchor.constraint(equalTo: viewSuper.topAnchor, constant: 0),
            containerViewSortFilter!.bottomAnchor.constraint(equalTo: viewSuper.bottomAnchor, constant: 0),
        ])
        
        // add child view controller view to container
        
        viewContro.addChild(sortFilterView)
        //            addChildViewController(controller)
        sortFilterView.view.translatesAutoresizingMaskIntoConstraints = false
        containerViewSortFilter!.addSubview(sortFilterView.view)
        
        NSLayoutConstraint.activate([
            sortFilterView.view.leadingAnchor.constraint(equalTo: containerViewSortFilter!.leadingAnchor, constant: 0),
            sortFilterView.view.trailingAnchor.constraint(equalTo: containerViewSortFilter!.trailingAnchor, constant: 0),
            sortFilterView.view.topAnchor.constraint(equalTo: containerViewSortFilter!.layoutMarginsGuide.topAnchor, constant: 0),
            sortFilterView.view.bottomAnchor.constraint(equalTo: containerViewSortFilter!.bottomAnchor, constant: 0)
            
        ])
        
        sortFilterView.view.backgroundColor = COLOR_CLEAR
        
        
        sortFilterView.sortFilterbottomConstraint.isActive = false
        NSLayoutConstraint.activate([
            sortFilterView.sortFilterView.bottomAnchor.constraint(equalTo: containerViewSortFilter!.layoutMarginsGuide.bottomAnchor, constant: -30)])
        
        sortFilterView.didMove(toParent: viewContro)
        
        sortFilterView.delegate = self
        
        containerViewSortFilter!.isHidden = true
        
    }
    
    
    
    private func addHeaderViewOptions () {
        
        labelLine.backgroundColor = APPCOLORS_3.Body_BG
        headerView_header.addSubview(labelLine)
        
        
        profileImage.setBackgroundImage(Image_defaultDP, for: .normal)
        headerView_header.addSubview(profileImage)
        profileImage.addTarget(self, action: #selector(handleHomeButtonAction), for: .touchUpInside)
        
        
        headerView_header.addSubview(logoLabel)

        headerView_header.addSubview(breadcrumbView)
        
        
//        btnHome.setBackgroundImage(imageHome, for: .normal)
//        btnHome.clipsToBounds = true
//        btnHome.isHidden = false
//        btnHome.addTarget(self, action: #selector(handleHomeButtonAction(_:)), for: .touchUpInside)
//        headerView_header.addSubview(btnHome)

        
        
        btnBack.setBackgroundImage(imageBack, for: .normal)
        btnBack.tintColor = AppColors.darkGray
        btnBack.clipsToBounds = true
        btnBack.isHidden = true
        headerView_header.addSubview(btnBack)

        
        headerView_header.addSubview(btnBackFull)
        btnBackFull.isHidden = true
        
        
        btnBackProfile.setBackgroundImage(imageBack, for: .normal)
        btnBackProfile.clipsToBounds = true
        btnBackProfile.isHidden = true
        headerView_header.addSubview(btnBackProfile)
        btnBackProfile.addTarget(self, action: #selector(handleProfileBackAction), for: .touchUpInside)
        
        
        headerView_header.addSubview(optionsView)
        
        
        hideBackButton()
        
    }
    
    
    private func setFramesForviews () {
        
        labelLine.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            labelLine.leadingAnchor.constraint(equalTo: headerView_header.leadingAnchor, constant: 0),
            labelLine.trailingAnchor.constraint(equalTo: headerView_header.trailingAnchor, constant: 0),
            labelLine.topAnchor.constraint(equalTo: headerView_header.topAnchor, constant: statusBarHeight()),
            labelLine.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        
        
        labelLine.isHidden = true
        
                        
        
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImage.trailingAnchor.constraint(equalTo: headerView_header.trailingAnchor, constant: -15),
            profileImage.topAnchor.constraint(equalTo: headerView_header.topAnchor, constant: statusBarHeight() + 15),
            profileImage.heightAnchor.constraint(equalTo: headerView_header.widthAnchor, multiplier: 0.14),
            profileImage.widthAnchor.constraint(equalTo: profileImage.heightAnchor, multiplier: 1)
        ])
        
                
        profileImage.layer.cornerRadius = profileImage.frame.size.height/2
        profileImage.clipsToBounds = true
        profileImage.layer.masksToBounds = true
        
        
        
        btnBack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            btnBack.leadingAnchor.constraint(equalTo: headerView_header.leadingAnchor, constant: 10),
            btnBack.centerYAnchor.constraint(equalTo: breadcrumbView.centerYAnchor, constant: 0),
            btnBack.heightAnchor.constraint(equalToConstant: 18),
            btnBack.widthAnchor.constraint(equalToConstant: 18)
        ])
        
        
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoLabel.leadingAnchor.constraint(equalTo: btnBack.trailingAnchor, constant: 10),
            logoLabel.topAnchor.constraint(equalTo: headerView_header.topAnchor, constant: statusBarHeight() + 15),
            logoLabel.trailingAnchor.constraint(equalTo: profileImage.leadingAnchor, constant: -10),
            logoLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor, constant: 0)
        ])
        
        
        
//        btnHome.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            btnHome.leadingAnchor.constraint(equalTo: headerView_header.leadingAnchor, constant: 5),
//            btnHome.centerYAnchor.constraint(equalTo: logoLabel.centerYAnchor, constant: -2),
//            btnHome.heightAnchor.constraint(equalToConstant: 30),
//            btnHome.widthAnchor.constraint(equalToConstant: 30)
//        ])

        
        
        btnBackFull.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            btnBackFull.leadingAnchor.constraint(equalTo: headerView_header.leadingAnchor, constant: 0),
            btnBackFull.trailingAnchor.constraint(equalTo: logoLabel.leadingAnchor, constant: 0),
            btnBackFull.topAnchor.constraint(equalTo: headerView_header.topAnchor, constant: 0),
            btnBackFull.bottomAnchor.constraint(equalTo: headerView_header.bottomAnchor, constant: 0),
        ])
                        
        

        
        breadcrumbView.translatesAutoresizingMaskIntoConstraints = false


//        heightCollection = breadcrumbView.heightAnchor.constraint(greaterThanOrEqualToConstant: 18)
        //heightCollection = breadcrumbView.heightAnchor.constraint(equalToConstant: 40)

        NSLayoutConstraint.activate([
            breadcrumbView.leadingAnchor.constraint(equalTo: logoLabel.leadingAnchor, constant: 0),
            breadcrumbView.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 2),
            breadcrumbView.trailingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 0),
            breadcrumbView.heightAnchor.constraint(equalToConstant: 35)
        ])
        
//        breadcrumbView.updateFrame = {
////            self.breadcrumbView.backgroundColor = .yellow
//            self.heightCollection!.constant = self.breadcrumbView.heightBreadCrum
//
//            self.breadcrumbView.layoutIfNeeded()
//            self.breadcrumbView.updateConstraints()
//        }
        


        optionsView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            optionsView.leadingAnchor.constraint(equalTo: logoLabel.leadingAnchor, constant: 0),
            optionsView.trailingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 0),
            optionsView.topAnchor.constraint(equalTo: breadcrumbView.bottomAnchor, constant: 10),
            headerView_header.bottomAnchor.constraint(equalTo: optionsView.bottomAnchor, constant: 10)
        ])
                
    }
    
    
    //MARK: - Action
    
    @IBAction func handleHomeButtonAction (_ sender: UIButton) {
        
        if let vc = kStoryboardMain.instantiateInitialViewController()
        {
            
            kWindow.rootViewController = vc
            
            kWindow.makeKeyAndVisible()
            
        }
//        if headerLogoText == "Displays"
//        {
//            if let vc = kStoryboardMain.instantiateInitialViewController()
//            {
//
//                kWindow.rootViewController = vc
//
//                kWindow.makeKeyAndVisible()
//
//            }
//
//        }
//        if let navi = self.tabBarController?.navigationController {
//            navi.popToRootViewController(animated: true)
//        }else {
//
//            self.navigationController?.popToRootViewController(animated: true)
//        }
        
    }
    
    
}


//MARK: - Back button, Profile Show/hide

extension HeaderVC {
    
    func showBackButton () {
        
        btnBack.isHidden = false
        setFramesForviews()
        
        setFramesForOptionsViews()
        
    }
    
    func hideBackButton() {
        
        btnBack.isHidden = true
        setFramesForviews()
        
        setFramesForOptionsViews()
        
    }
    
    func showProfileBackButton () {
        
        btnBackProfile.isHidden = false
        setFramesForviews()
        
        setFramesForOptionsViews()
        
    }
    
    func hideProfileBackButton() {
        
        btnBackProfile.isHidden = true
        setFramesForviews()
        
        setFramesForOptionsViews()
        
    }
    
    func showProfileView () {
        
        containerView!.isHidden = false
        profileView.setHeightForViewBasedonRowsHeight()
        profileView.getDisplaysNotificationsCount()
        profileView.tableProfile.reloadData()
        
        view.bringSubviewToFront(containerView!)
        
        profileView.completionHandlerProfile = { () -> Void in

            self.hideProfileView()

//            if let url = appDelegate.userData?.user?.userProfileImageURL {
//                ImageDownloader.removeImage(forKey: url) {
//                    self.addProfileImage(url)
//                }
//            }
        }
        
        profileView.completionHandlerProfilePicUpdate = {
            self.showProfileView()
        }
        
        profileView.updateProfileImage ()
        profileView.getProfileNotificationsCount ()
        profileView.tableProfile.reloadData()
       
        
        addLocationObserver ()
        
        return
    }
    
    func hideProfileView () {
        
        self.profileView.selectedIndex = -1
        self.containerView?.isHidden = true
        
        self.removeLocationObserver ()
    }
    
    func showSortFilterView () {
        
        UIView.animate(withDuration: 0.1, animations: {
            
            self.containerViewSortFilter!.isHidden = false
            if self.sortFilterView.sortFilterFrame != .zero {
                self.sortFilterView.sortFilterView.frame = self.sortFilterView.sortFilterFrame
            }
            self.sortFilterView.sortView.isHidden = true
            self.sortFilterView.updatePriceRangeView ()
            
        }) { (completed) in
            
            self.sortFilterView.updatePriceRangeView ()
            
            self.sortFilterView.priceRangeVC?.updateRangeSliderValues(with: self.filter)
            
            self.sortFilterView.updateFilterValues ()
        }
    }
    
    func hideSortFilterView () {
        
        if let container = containerViewSortFilter {
            
            if container.isHidden {
                
            } else {
                
                setAppearanceFor(view: btnSortFilter, backgroundColor: AppColors.appOrange, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_BODY(size: FONT_12))
                containerViewSortFilter!.isHidden = true
            }
        }
    }
}


// MARK: - Header Options

extension HeaderVC {
    
    func addHeaderOptions (sort: Bool = false, map: Bool = false, favourites: Bool = false, howWorks: Bool = false, reset : Bool = false,totalCount : Bool = false, delegate: ChildVCDelegate?) {
        
        addHowWorks()

        addSort()

        addMap()

        addFavorites()

        addReset ()
        
        addTotalCount()
        
        if let del = delegate {
            childVCDelegate = del
        }
        
        
        if !howWorks {
            btnHowWorks.isHidden = true
        }
        
        if !sort {
            btnSortFilter.isHidden = true
        }
        if !map {
            btnMap.isHidden = true
        }
        if !reset {
            btnReset.isHidden = true
        }
        if !totalCount {
            btnTotalCollectionCount.isHidden = true
        }
//        if !btnProfile {
//            btnMyProfile.isHidden = true
//        }
        
//        if !favourites {
//            btnFavorites.isHidden = true
//        }
                
        
        btnMyProfile.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            //            btnFavorites.leadingAnchor.constraint(equalTo: optionsView.leadingAnchor, constant: 0),
            btnMyProfile.trailingAnchor.constraint(equalTo: optionsView.trailingAnchor, constant: 0),
            btnMyProfile.topAnchor.constraint(equalTo: optionsView.topAnchor, constant: 0),
            optionsView.bottomAnchor.constraint(equalTo: btnMyProfile.bottomAnchor, constant: 0)
        ])
        NotificationCenter.default.post(name: NSNotification.Name("FavouritesUpdated"), object: nil)
        let totalFavCount = kDesignFavoritesCount + kHomeLandFavoritesCount + kDisplayHomesFavoritesCount
        NotificationCenter.default.addObserver(self, selector: #selector(favoritesUpdated), name: NSNotification.Name("FavouritesUpdated"), object: nil)
        //MyProfile favorites count label

        self.favCountLb.text = "\(totalFavCount)"
        favCountLb.backgroundColor = .gray
        favCountLb.textColor = .white
        favCountLb.font = FONT_LABEL_SUB_HEADING(size: 12.0)
        favCountLb.layer.cornerRadius = 9
        favCountLb.clipsToBounds = true
        favCountLb.textAlignment = .center
        let isFavAvailable = kUserID == "0" ? false : true
        favCountLb.isHidden = totalFavCount > 0 ? false : true
        if isFavAvailable
        {
            btnMyProfile.addSubview(favCountLb)
//            favCountLb.isHidden = false
            favCountLb.translatesAutoresizingMaskIntoConstraints = false
            favCountLb.topAnchor.constraint(equalTo: btnMyProfile.topAnchor , constant: -9).isActive = true
            favCountLb.trailingAnchor.constraint(equalTo: btnMyProfile.trailingAnchor, constant: 9).isActive = true
            favCountLb.heightAnchor.constraint(equalToConstant: 18).isActive = true
            favCountLb.widthAnchor.constraint(equalToConstant: 18).isActive = true
        }
        
        
        
        btnSortFilter.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            btnSortFilter.leadingAnchor.constraint(equalTo: optionsView.leadingAnchor, constant: 0),
            //            btnFavorites.trailingAnchor.constraint(equalTo: optionsView.trailingAnchor, constant: 0),
            btnSortFilter.topAnchor.constraint(equalTo: optionsView.topAnchor, constant: 0),
            optionsView.bottomAnchor.constraint(equalTo: btnMyProfile.bottomAnchor, constant: 0)
        ])
        
        
        btnMap.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            btnMap.leadingAnchor.constraint(equalTo: btnSortFilter.trailingAnchor, constant: 5),
            btnMap.trailingAnchor.constraint(lessThanOrEqualTo: btnMyProfile.leadingAnchor, constant: -5),
            btnMap.topAnchor.constraint(equalTo: optionsView.topAnchor, constant: 0),
            optionsView.bottomAnchor.constraint(equalTo: btnMyProfile.bottomAnchor, constant: 0)
        ])
        
        btnReset.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            btnReset.leadingAnchor.constraint(equalTo: optionsView.leadingAnchor, constant: -20),
            //            btnFavorites.trailingAnchor.constraint(equalTo: optionsView.trailingAnchor, constant: 0),
            btnReset.topAnchor.constraint(equalTo: optionsView.topAnchor, constant: 0),
            optionsView.bottomAnchor.constraint(equalTo: btnMyProfile.bottomAnchor, constant: 0)
        ])
        
        
        btnTotalCollectionCount.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            btnTotalCollectionCount.leadingAnchor.constraint(equalTo: btnReset.trailingAnchor, constant: 5),
            btnTotalCollectionCount.trailingAnchor.constraint(lessThanOrEqualTo: btnMyProfile.leadingAnchor, constant: -5),
            btnTotalCollectionCount.topAnchor.constraint(equalTo: optionsView.topAnchor, constant: 0),
            optionsView.bottomAnchor.constraint(equalTo: btnMyProfile.bottomAnchor, constant: 0)
        ])
        
        
        
        btnHowWorks.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            btnHowWorks.leadingAnchor.constraint(equalTo: optionsView.leadingAnchor, constant: 0),
            //            btnFavorites.trailingAnchor.constraint(equalTo: optionsView.trailingAnchor, constant: 0),
            btnHowWorks.topAnchor.constraint(equalTo: optionsView.topAnchor, constant: 0),
            optionsView.bottomAnchor.constraint(equalTo: btnHowWorks.bottomAnchor, constant: 0)
        ])
        
        setFramesForOptionsViews()
        
        
    }
    
    @objc func favoritesUpdated(notification : Notification)
    {
        let totalFavCount = kDesignFavoritesCount + kHomeLandFavoritesCount + kDisplayHomesFavoritesCount
        favCountLb.text = "\(totalFavCount)"
        favCountLb.isHidden = totalFavCount > 0 ? false : true
    }
    
    //serviceCall of displayhomes fav
//    func getDisplayHomesFavoriteCount()
//    {
//
//        _ = Networking.shared.GET_request(url: ServiceAPI.shared.URL_FavoriteDisplayHomes(Int(kUserID) ?? 0,Int(kUserState) ?? 0 ), userInfo: nil, success: { [weak self] (json, response) in
//                if let result: AnyObject = json {
//                    let result = result as! NSDictionary
//                    if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {
//                        if let result: AnyObject = json {
//                            if (result.allKeys as! [String]).contains("userFavDisplays") {
//                                let packagesResult = result.value(forKey: "userFavDisplays") as! [NSDictionary]
//
//
//                                kDisplayHomesFavCount = packagesResult.count
//
//                            }else { print(log: "no SuggestedHomesData found") }
//
//                        }else {
//
//                        }
//                    }
//                }
//            }, errorblock: { (error, isJSONerror) in
//
//                if isJSONerror { }
//                else { }
//
//            }, progress: nil)
//
//
//    }
    
    
    func addHowWorks () {
        
        optionsView.addSubview(btnHowWorks)
        
        btnHowWorks.setTitle("  HOW DOES IT WORK  ", for: .normal)
        setAppearanceFor(view: btnHowWorks, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_SUB_HEADING  (size: FONT_11))
        btnHowWorks.addTarget(self, action: #selector(handleHowWorksAction), for: .touchUpInside)
    }
    
    
    func addSort () {
        
        optionsView.addSubview(btnSortFilter)
        
        btnSortFilter.setTitle("  SORT / FILTER  ", for: .normal)
        setAppearanceFor(view: btnSortFilter, backgroundColor: APPCOLORS_3.Orange_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_SUB_HEADING  (size: FONT_11))
        btnSortFilter.addTarget(self, action: #selector(handleSortFilterAction), for: .touchUpInside)
    }
    
    func addReset () {
        
        optionsView.addSubview(btnReset)
        
        btnReset.setTitle("    RESET    ", for: .normal)
        setAppearanceFor(view: btnReset, backgroundColor: APPCOLORS_3.Orange_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_SUB_HEADING  (size: FONT_11))
        btnReset.addTarget(self, action: #selector(handleResetAction), for: .touchUpInside)
    }
    
    func addTotalCount () {
        
        optionsView.addSubview(btnTotalCollectionCount)
        
        btnTotalCollectionCount.setTitle("    TOTAL DESIGNS    ", for: .normal)
        setAppearanceFor(view: btnTotalCollectionCount, backgroundColor: APPCOLORS_3.DarkGrey_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_SUB_HEADING  (size: FONT_11))
        //btnSortFilter.addTarget(self, action: #selector(handleSortFilterAction), for: .touchUpInside)
    }

    
    
    func addMap () {
        
        optionsView.addSubview(btnMap)
        
        btnMap.setTitle("     MAP     ", for: .normal)
        setAppearanceFor(view: btnMap, backgroundColor: APPCOLORS_3.Orange_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_SUB_HEADING  (size: FONT_11))
        btnMap.addTarget(self, action: #selector(handleMapAction), for: .touchUpInside)
    }
    
    func addFavorites () {
        
        optionsView.addSubview(btnMyProfile)
        
        btnMyProfile.setTitle("  MY PROFILE  ", for: .normal)
        //userID == 0 means guest user so we are disabling myprofile button and chaging background color
        let MyProfilebckColor = kUserID == "0" ? AppColors.lightGray.withAlphaComponent(0.6) : AppColors.appOrange
      //  btnMyProfile.isUserInteractionEnabled = kUserID == "0" ? false : true
        setAppearanceFor(view: btnMyProfile, backgroundColor: MyProfilebckColor, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_11))
        btnMyProfile.addTarget(self, action: #selector(handleProfileImageAction), for: .touchUpInside)
    }
    
    func setFramesForOptionsViews () {
        
        if let str = btnHowWorks.title(for: .normal) {
            if str != "" {

                setBorder(view: btnHowWorks, color: APPCOLORS_3.Body_BG, width: 0.5)
                btnHowWorks.layer.cornerRadius = 5.0
                btnHowWorks.clipsToBounds = true
            }
        }
        
        
        if let str = btnSortFilter.title(for: .normal) {
            if str != "" {

                setBorder(view: btnSortFilter, color: APPCOLORS_3.Body_BG, width: 0.5)
                btnSortFilter.layer.cornerRadius = 5.0
            }
        }
        
        
        if let str = btnMap.title(for: .normal) {
            if str != "" {
                
                if btnSortFilter.title(for: .normal) == nil || btnSortFilter.title(for: .normal) == "" {
                    
                }
                                
                setBorder(view: btnMap, color: APPCOLORS_3.Body_BG, width: 0.5)
                btnMap.layer.cornerRadius = 5.0
            }
        }
        if let str = btnReset.title(for: .normal) {
            if str != "" {

                setBorder(view: btnReset, color: APPCOLORS_3.Body_BG, width: 0.5)
                btnReset.layer.cornerRadius = 5.0
            }
        }
        if let str = btnTotalCollectionCount.title(for: .normal) {
            if str != "" {

                setBorder(view: btnTotalCollectionCount, color: APPCOLORS_3.Body_BG, width: 0.5)
                btnTotalCollectionCount.layer.cornerRadius = 5.0
            }
        }
        
        if let str = btnMyProfile.title(for: .normal) {
            if str != "" {
                
                //setBorder(view: btnMyProfile, color: APPCOLORS_3.Body_BG, width: 0.5)
                let MyProfilebckColor = kUserID == "0" ? APPCOLORS_3.LightGreyDisabled_BG : APPCOLORS_3.EnabledOrange_BG
                btnMyProfile.backgroundColor = MyProfilebckColor
                btnMyProfile.layer.cornerRadius = 5.0
            }
        }
    }
    
}


//MARK: - Header Options Actions

extension HeaderVC {
    
    @objc func handleHowWorksAction () {
                
        if let delegate = childVCDelegate {
            delegate.handleActionFor(sort: false, map: false, favourites: false, howWorks: true, reset: false)
        }
//        playVideoIn(self, URL(string: ServiceAPI.shared.videoURLBurBank)!)
    }
    
    @objc func handleResetAction () {
        if let delegate = childVCDelegate {
            delegate.handleActionFor(sort: false, map: false, favourites: false, howWorks: false, reset : true)
        }
    }
    @objc func handleSortFilterAction () {
        
        if let _ = containerViewSortFilter {
            
        }else {
            addContainerViewSortFilter()
        }
        
        if containerViewSortFilter!.isHidden {
            
            sortFilterView.filter = filter

            showSortFilterView()
            
            setAppearanceFor(view: btnSortFilter, backgroundColor: APPCOLORS_3.HeaderFooter_white_BG, textColor: APPCOLORS_3.Orange_BG, textFont: FONT_BUTTON_BODY(size: FONT_12))
        }else {
            
            hideSortFilterView()
        }
        
    }
    
    @objc func handleMapAction () {
        if let delegate = childVCDelegate {
            delegate.handleActionFor(sort: false, map: true, favourites: false, howWorks: false, reset: false)
        }
    }
    
    @objc func handleFavoritesAction () {
        
        if noNeedofGuestUserToast(self, message: "Please login to show favourites") {
            
            if let delegate = childVCDelegate {
                delegate.handleActionFor(sort: false, map: false, favourites: true, howWorks: false, reset: false)
            }
        }
    }
    
    //higher order functions
    @objc func handleProfileImageAction () {
        
        if let _ = containerView {
            
        }else {
            addContainerView()
        }
        
        if noNeedofGuestUserToast(self) {
            
            if containerView!.isHidden {
                showProfileView()
            }else {
                hideProfileView()
            }
        }
        
    }
    
    @objc func handleProfileBackAction () {
        
        hideProfileView()
    }
    
}

extension HeaderVC: SortFilterDelegate {
    
    func handleSortFilterDelegate(close: Bool, searchBtn: Bool, results: Any) {
        
        if close {
            
        }
        
        if searchBtn {
            if (results as AnyObject).isKind(of: SortFilter.self) {
                self.filter = results as! SortFilter
                
                if let childDelegate = childVCDelegate {
                    childDelegate.handleActionFor(sort: true, map: false, favourites: false, howWorks: false, reset: false)
                }
            }
        }
        
        hideSortFilterView()
        
    }
    
}


extension HeaderVC {
    
    func updateTopConstraint () {
        
        var topConstraint: NSLayoutConstraint?
        
        for constraint: NSLayoutConstraint in view.constraints {
            if constraint.constant == 135 || constraint.constant == 130 {
                topConstraint = constraint
                //                print(log: "success finding the constraint")
                break
            }
        }
        
        if let top = topConstraint {
            top.constant = headerViewHeight + 0//5
            
            top.isActive = false
            
            let viewTop = top.firstItem as! UIView
            
            NSLayoutConstraint.activate([
                viewTop.topAnchor.constraint(equalTo: headerView_header.bottomAnchor, constant: 0)
            ])
            
        }
    }
}



extension HeaderVC {
    
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

extension HeaderVC/*: HeaderBreadCrumpDelegate*/ {
    
    
    func addBreadCrumb (from displayText: String) {
        
        let arr = displayText.components(separatedBy: "|")
        
        removeAllBreadCrumbs()
        
        for item in arr {
          addBreadcrumb(item.trim())
        }
        
    }
    
        
    func addBreadcrumb (_ str: String) {
        breadcrumbView.addBreadcrumb(str)
    }
    
    func removeBreadcrumb (_ str: String) {
        breadcrumbView.removeBreadcrumb(str)
    }
    
    func removeAllBreadCrumbs () {
        breadcrumbView.removeAllBreadCrumbs()
    }
}
