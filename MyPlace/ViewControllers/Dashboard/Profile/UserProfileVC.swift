//
//  ProfileVC.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 31/03/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit
import Foundation
import CropViewController
import SDWebImage


let iconCollection = UIImage(named: "Ico-HomeDesigns")
let iconHL = UIImage(named: "Ico-H&L1")
let iconMyday = UIImage(named: "Ico-MyDayRound")
let iconMyDesign = UIImage(named: "Ico-HomeDesignRound")
let iconShare = UIImage(named: "Ico-ShareRound")
let iconProfile = UIImage(named: "Ico-ProfileRound")
let iconSettings = UIImage(named: "Ico-Settings")
let iconDH = UIImage(named: "Ico-Displays-Bottomm")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
var iconFav : UIImage
{
    if #available(iOS 13.0, *)
    {
        return UIImage(systemName: "heart")!
    }
    else {
        return UIImage(named: "Ico-favorite-Black")!
    }
}

let nameFavourites = "MyFavourites"

let nameMyCollection = "MyCollection"
let nameHL = "House&Land"
let nameMyday = "MyDay"
let nameMyDesign = "HomeDesigns"
let nameMyDetails = "MyDetails"
let nameShare = "ShareAccount"
let nameSettings = "AppSettings"
let nameDisplayHomes = "DisplayHomes"


let rowHeight: CGFloat = 60
let rowHeightProfileDetails_noImage: CGFloat = SCREEN_WIDTH/1.1029 // 340 SE-290.14
let rowHeightProfileDetails: CGFloat = SCREEN_WIDTH/0.96  //390 //1.1029 // 340 SE-290.14
let rowHeightCollection: CGFloat = SCREEN_WIDTH/1.2295 // 305 SE-260.26
let rowHeightHomeLand: CGFloat = SCREEN_WIDTH/1.0714 // 350  SE-297.95
let rowHeightMyDay: CGFloat = SCREEN_WIDTH/2.2058 // 170  SE-145
let rowHeightSettings: CGFloat = (SCREEN_WIDTH/1.5) > 250 ? SCREEN_WIDTH/1.5 : 250 //250 // 210 SE-179



var selectedRowHeight: CGFloat = rowHeight


let logoFontProfile = FONT_LABEL_HEADING (size: FONT_30)
let logoFontProfileSUBHEADING = FONT_LABEL_SUB_HEADING(size: FONT_30)


class UserProfileVC: UIViewController {
    
    @IBOutlet weak var tableViewHeightConstrait: NSLayoutConstraint!
    @IBOutlet weak var profileView: UIView!
    
    @IBOutlet weak var profileHeaderView: UIView!
    @IBOutlet weak var profileHeaderViewHeight: NSLayoutConstraint!
    var labelLine = UILabel()
    var logoLabelProfile = UILabel()
    var btnProfileImage = UIButton()
    var lBInfo = UILabel()
    var backBtn = UIButton()
    
    var completionHandlerProfile: (() -> Void)?
    var completionHandlerProfilePicUpdate: (() -> Void)?
    
    
    @IBOutlet weak var tableProfile: UITableView!
    
    @IBOutlet weak var profileViewBorder: UIView!
    
    
    let arrIcons = [iconProfile, iconFav/*iconShare,, iconCollection, iconMyday, iconHL, iconMyDesign, iconDH*/, iconSettings]
    let arrNames = [nameMyDetails, nameFavourites/*nameShare,, nameMyCollection, nameMyday, nameHL, nameMyDesign, nameDisplayHomes*/, nameSettings]
    
    
    
    var selectedIndex = -1
    
    
    let imagePicker = ImagePicker()
    var selectedImage: UIImage?
    
    
    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
    
    //Share Popup
    
    @IBOutlet weak var containerViewShare: UIView!
    
    var shareVC: ShareVC?
    var displayFavorites = [houseDetailsByHouseType]()
    
    //MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        self.tableProfile.tableFooterView = UIView(frame: .zero)
        
        
        setShadowatBottom(view: profileViewBorder, color: APPCOLORS_3.Black_BG, shadowRadius: 5.0)
        
        
        tableProfile.backgroundColor = AppColors.white
        view.backgroundColor = COLOR_CLEAR
        profileViewBorder.backgroundColor = COLOR_CLEAR
        
        btnProfileImage.layer.cornerRadius = btnProfileImage.frame.size.height/2
        btnProfileImage.clipsToBounds = true
        
        setHeightForViewBasedonRowsHeight()
        
        addHeaderViewOptions()
        
        //        lBInfo.isHidden = true
        
        
        profileHeaderViewHeight.constant = profileHeaderHeight - 20
        
        updateProfileImage ()
        
        //Share Popup
        self.containerViewShare.isHidden = true
        
        self.tableProfile.tableFooterView = UIView (frame: .zero)
        
        
        CodeManager.sharedInstance.sendScreenName(burbank_profile_screen_loading)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.profileView.backgroundColor = .clear
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableViewHeightConstrait.constant = tableProfile.contentSize.height + 20
    }
    func getDisplaysNotificationsCount(){
        _ = Networking.shared.GET_request(url: ServiceAPI.shared.URL_FavoriteDisplayHomes(Int(kUserID) ?? 0,Int(kUserState) ?? 0 ), userInfo: nil, success: { (json, response) in
            if let result: AnyObject = json {
                let result = result as! NSDictionary
                if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {
                    if let result: AnyObject = json {
                        if (result.allKeys as! [String]).contains("userFavDisplays") {
                            if (result.value(forKey: "userFavDisplays") as AnyObject).isKind(of: NSArray.self){
                                let packagesResult = result.value(forKey: "userFavDisplays") as! [NSDictionary]
                                self.displayFavorites = []
                                for package: NSDictionary in packagesResult {
                                    let suggestedData = houseDetailsByHouseType(package as! [String : Any])
                                    self.displayFavorites.append(suggestedData)
                                }
                                DispatchQueue.main.async {
                                    self.tableProfile.reloadData()
                                }
                                
                            }
                        }else { print(log: "no favorates found") }
                        
                    }else {
                        
                    }
                }
            }
        }, errorblock: { (error, isJSONerror) in
            
            if isJSONerror { }
            else { }
            
        }, progress: nil)
    }
    
    //MARK: - View
    
    func addHeaderViewOptions () {
        
        profileHeaderView.backgroundColor = AppColors.white
        
        
        labelLine.backgroundColor = APPCOLORS_3.Body_BG
        profileHeaderView.addSubview(labelLine)
        
        labelLine.isHidden = true
        
        profileHeaderView.addSubview(backBtn)
        btnProfileImage.setBackgroundImage(Image_defaultDP, for: .normal)
        profileHeaderView.addSubview(btnProfileImage)
        btnProfileImage.addTarget(self, action: #selector(handleProfileImageAction), for: .touchUpInside)
        
        
        let _ = setAttributetitleFor(view: logoLabelProfile, title: "MyProfile", rangeStrings: ["My", "Profile"], colors: [APPCOLORS_3.Black_BG, APPCOLORS_3.Black_BG], fonts: [FONT_LABEL_BODY(size: FONT_30), FONT_LABEL_SUB_HEADING(size: FONT_30)], alignmentCenter: false)
        profileHeaderView.addSubview(logoLabelProfile)
        
        
        
        lBInfo.text = "View your favourites & information"//infoStaicText
        setAppearanceFor(view: lBInfo, backgroundColor: COLOR_CLEAR, textColor: AppColors.darkGray, textFont: FONT_LABEL_SUB_HEADING(size: FONT_11))
        profileHeaderView.addSubview(lBInfo)
        
        let yPosPadding: CGFloat = 15.0//20.0
        let xPosPadding: CGFloat = 35.0
        
        var yPos: CGFloat = yPosPadding + statusBarHeight()
        let xPos: CGFloat = xPosPadding
        let leftPadding: CGFloat = 20.0
        
        
        
        labelLine.frame = CGRect(x: 0, y: yPos - yPosPadding, width: SCREEN_WIDTH, height: 0.5)
        btnProfileImage.frame = CGRect(x: SCREEN_WIDTH - profileImageHeight - 15, y: yPos, width: profileImageHeight, height: profileImageHeight)
        btnProfileImage.layer.cornerRadius = btnProfileImage.frame.size.height/2
        btnProfileImage.clipsToBounds = true
        
        logoLabelProfile.frame = CGRect(x: xPos, y: yPos-yPosPadding/2, width: btnProfileImage.frame.origin.x - xPos - 10, height: (profileHeaderHeight-statusBarHeight())*0.398)
        logoLabelProfile.frame.origin.y = yPos + (btnProfileImage.frame.size.height - logoLabelProfile.frame.size.height)/2
        
        yPos = yPos + logoLabelProfile.frame.size.height
        yPos = logoLabelProfile.frame.origin.y + logoLabelProfile.frame.size.height
        yPos = btnProfileImage.frame.origin.y + btnProfileImage.frame.size.height
        
        
        lBInfo.frame = CGRect(x: xPos, y: logoLabelProfile.frame.midY + 10 , width: SCREEN_WIDTH - leftPadding - xPos, height: 40)
        lBInfo.numberOfLines = 2
        lBInfo.lineBreakMode = .byTruncatingTail
        
        backBtn.frame = CGRect(x: 0, y: logoLabelProfile.center.y, width: 30, height: 30)
        backBtn.setImage(UIImage(named: "Ico-Back_Black"), for: .normal)
        backBtn.addTarget(self, action: #selector(handleProfileImageAction), for: .touchUpInside)

        
    }
    
    
    
    
    
    
    
    func setHeightForViewBasedonRowsHeight () {
        
        if selectedIndex != -1 {
            //            profileViewHeight.constant = profileHeaderViewHeight.constant + rowHeight*CGFloat(arrNames.count-1) + selectedRowHeight
        }else {
            //            profileViewHeight.constant = profileHeaderViewHeight.constant + rowHeight*CGFloat(arrNames.count)
        }
        
        var tabBartop: CGFloat = 0
        
        if let tabbar = self.parent?.tabBarController {
            tabBartop = tabbar.tabBar.frame.origin.y
        }else {
            tabBartop = self.parent?.view.frame.size.height ?? SCREEN_HEIGHT
        }
        
        print(log: tabBartop)
        
    }
    
    //MARK: Update Profile Image
    func updateProfileImage () {
        if let url = appDelegate.userData?.user?.userProfileImageURL {
            addProfileImage(url)
        }
    }
    
    
    func addProfileImage (_ url: String?) {
//
//        if let imageURL = url {
//
//            guard let urlImage = URL (string: imageURL) else { return }
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
//                            self.btnProfileImage.setBackgroundImage(imageDownloaded, for: .normal)
//                        }else {
//                            self.btnProfileImage.setBackgroundImage(Image_defaultDP, for: .normal)
//                        }
//                    }
//                }
//
//            }
//            //            ImageDownloader.removeImage(forKey: imageURL) {
//            //
//            //                ImageDownloader.downloadImage(withUrl: imageURL, withFilePath: nil, with: { (image, success, error) in
//            //
//            //                    if success, let img = image {
//            //
//            //                        self.btnProfileImage.setBackgroundImage(img, for: .normal)
//            //                    }else {
//            //                        self.btnProfileImage.setBackgroundImage(Image_defaultDP, for: .normal)
//            //                    }
//            //
//            //                }) { (progress) in
//            //
//            //                }
//            //            }
//
//            //            downloadImage(from: urlImage) { (image, error, success) in
//            //
//            //                DispatchQueue.main.async() {
//            //
//            //                    if success, let img = image {
//            //
//            //                        self.btnProfileImage.setBackgroundImage(img, for: .normal)
//            //                    }else {
//            //                        self.btnProfileImage.setBackgroundImage(Image_defaultDP, for: .normal)
//            //                    }
//            //                }
//            //            }
//
//        }else{
//
//        }
    }
    
    
    @objc func handleProfileImageAction () {
        
        if let callback = completionHandlerProfile {
            callback ()
        
        }
        
        CodeManager.sharedInstance.sendScreenName(burbank_profile_profilePic_button_touch)
    }
    
}


//MARK: Tableview Delegate methods

extension UserProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrNames.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if cell.isKind(of: ProfileShareTVCell.self) {
            
            (cell as! ProfileShareTVCell).tableViewShareUsers.reloadData()
        }
        
        if cell.isKind(of: ProfileTVCell.self) {
            
            let cell = cell as! ProfileTVCell
            
            cell.icon.image = arrIcons[indexPath.row]
            cell.lBTitle.text = arrNames[indexPath.row]
            
            
            let name = arrNames[indexPath.row]
            
            cell.lBCount.isHidden = false
            cell.lBCount.text = "0"
            
            
            if name == nameMyDetails {
              //  cell.lBCount.isHidden = true
                cell.lBCount.text = ""
            }else if name == nameShare {
                
                cell.lBCount.text = "\(kShareCount)"
                
            }else if name == nameMyCollection {
                
                cell.lBCount.text = "\(kCollectionFavoritesCount)"
                
            }else if name == nameMyDesign {
                
                cell.lBCount.text = "\(kDesignFavoritesCount)"
                
            }else if name == nameMyday {
            }else if name == nameHL {
                cell.lBCount.text = "\(kHomeLandFavoritesCount)"
            }else if name == nameDisplayHomes{
                cell.lBCount.text = "\(self.displayFavorites.count)"
            }
            else if name == nameSettings {
               // cell.lBCount.isHidden = true
                cell.lBCount.text = ""
            }
            else if name == nameFavourites {
               let totalCount = kDesignFavoritesCount + kHomeLandFavoritesCount + self.displayFavorites.count
              cell.lBCount.text = "\(totalCount)"
              }
            
            
        }
        self.viewWillLayoutSubviews()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if selectedIndex == indexPath.row {
            
            let name = arrNames[selectedIndex]
            arrIcons[indexPath.row]?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            
            if name == nameMyDetails {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileDetailsTVCell", for: indexPath) as! ProfileDetailsTVCell
                cell.icon.image = arrIcons[indexPath.row]
                cell.lBTitle.text = arrNames[indexPath.row]
                cell.txtName.text = "\(appDelegate.userData?.user?.userFirstName?.capitalized ?? "") \(appDelegate.userData?.user?.userLastName?.capitalized ?? "")"
                cell.fillDetails()
                
                
                cell.btnUpdate.addTarget(self, action: #selector(handleUpdateDetailsAction(_:)), for: .touchUpInside)
                if let btnSelect = cell.btnSelect {
                    btnSelect.addTarget(self, action: #selector(handleSelectProfilePicAction(_:)), for: .touchUpInside)
                }
                
                
                if selectedRowHeight == rowHeightProfileDetails_noImage {
                    if let viewProfilePic = cell.viewProfilePic {
                        if let superProfile = viewProfilePic.superview {
                            superProfile.removeFromSuperview() //if user have facebook pictures or google pictures, then not allowing users to select the image
                        }
                    }
                }
                
                return cell
                
            }else if name == nameShare {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileShareTVCell", for: indexPath) as! ProfileShareTVCell
                cell.icon.image = arrIcons[indexPath.row]
                cell.lBTitle.text = arrNames[indexPath.row]
                
                if let share = self.shareVC {
                    cell.userDetails = share.invitations
                }
                
                cell.shareUserDetails = { (shareUser) in
                    
                    cell.txtShareEmail.resignFirstResponder()
                    
                    self.shareVC?.fillPopupDetails (shareUser)
                    
                    cell.txtShareEmail.text = ""
                    
                    self.containerViewShare.isHidden = false
                    
                    self.view.bringSubviewToFront(self.containerViewShare)
                }
                
                cell.deleteAction = { (user) in
                    
                    self.shareVC?.rejectSharing (user)
                }
                
                cell.favoriteAction = { (user) in
                    
                    user.userDetails!.favorite = !(user.userDetails!.favorite)
                    
                    self.shareVC?.favoriteSharing (user)
                    
                }
                
                cell.layoutIfNeeded()
                
                
                return cell
                
            } else if name == nameMyCollection {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCollectionTVCell", for: indexPath) as! ProfileCollectionTVCell
                cell.icon.image = arrIcons[indexPath.row]
                cell.lBTitle.text = arrNames[indexPath.row]
                
                if let recentSearch = appDelegate.userData?.user?.userDetails?.collectionRecentSearch {
                    
                    cell.searchResultSortFilter = recentSearch as? [NSDictionary]
                    
                    
                    cell.actionHandler = { (button) in
                        
                        let designsVC = kStoryboardMain.instantiateViewController(withIdentifier: "DesignsVC") as! DesignsVC
                        designsVC.isFromProfileFavorites = true
                        
                        if button == cell.btnSavedDesigns {
                            
                            //displayVC.isFavorites = true
                            CodeManager.sharedInstance.sendScreenName(burbank_profile_myCollection_designs_button_touch)
                        }else {
                            
                            CodeManager.sharedInstance.sendScreenName(burbank_profile_myCollection_recentSearch_button_touch)
                        }
                        
                        designsVC.isFromCollection = true
                        designsVC.filter = SortFilter ()
                        
                        self.navigationController?.pushViewController(designsVC, animated: true)
                        
                        
                        designsVC.selectedFeatures = recentSearch as? [NSDictionary]
                        
                        if let features = cell.homeDesignFeatures {
                            designsVC.displayText = features.count > 0 ? cell.displayTextWithDesignFeatures(features) : ""
                        }else {
                            designsVC.displayText = ""
                        }
                        
                    }
                    
                }
                
                cell.lBPriceRange.layoutIfNeeded()
                cell.layoutIfNeeded()
                
                return cell
                
            }else if name == nameMyDesign {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileHomeDesignTVCell", for: indexPath) as! ProfileHomeDesignTVCell
                cell.icon.image = arrIcons[indexPath.row]
                cell.lBTitle.text = arrNames[indexPath.row]
                
                if let recentSearch = appDelegate.userData?.user?.userDetails?.collectionRecentSearch {
                    
                    cell.searchResultSortFilter = recentSearch as? [NSDictionary]
                    
                    
                    cell.actionHandler = { (button) in
                        
                        CodeManager.sharedInstance.sendScreenName(burbank_profile_homeDesigns_savedDesigns_button_touch)
                        
                        let designs = kStoryboardMain.instantiateViewController(withIdentifier: "DesignsVC") as! DesignsVC
                        designs.isFromProfileFavorites = true
                        
                        designs.isFavorites = true
                        
                        
                        designs.isFromCollection = true
                        designs.filter = SortFilter ()
                        
                        self.navigationController?.pushViewController(designs, animated: true)
                        
                        
                        designs.selectedFeatures = recentSearch as? [NSDictionary]
                        
                        //                        if let features = cell.homeDesignFeatures {
                        //                            displayVC.displayText = features.count > 0 ? cell.displayTextWithDesignFeatures(features) : ""
                        //                        }else {
                        designs.displayText = "Favourite Designs"
                        //                        }
                        
                    }
                }
                
                return cell
                
            }else if name == nameDisplayHomes {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileHomeDesignTVCell", for: indexPath) as! ProfileHomeDesignTVCell
                
                cell.icon.image = arrIcons[indexPath.row]?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                cell.icon.tintColor = APPCOLORS_3.GreyTextFont
                cell.lBTitle.text = arrNames[indexPath.row]
                
                //                if displayFavorites.count
                cell.fillTheData1(diplayFaoritesCount: displayFavorites.count)
                cell.lBCount.text = "\(displayFavorites.count)"
                cell.actionHandler = { (button) in
                    CodeManager.sharedInstance.sendScreenName(burbank_profile_displayHomes_savedDesigns_button_touch)
                    let designs = kStoryboardMain.instantiateViewController(withIdentifier: "DisplayHomesFavouritesVC") as! DisplayHomesFavouritesVC
                    self.navigationController?.pushViewController(designs, animated: true)
                }
                
                return cell
            }else if name == nameMyday {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileDayTVCell", for: indexPath) as! ProfileDayTVCell
                cell.icon.image = arrIcons[indexPath.row]
                cell.lBTitle.text = arrNames[indexPath.row]
                
                let daysCount = appDelegate.userData?.user?.userDetails?.myDayCount ?? 0
                
                cell.lBDayTitle.text = String(format: "You have %d %@ planned", daysCount, (daysCount == 0) ? "days" : daysCount == 1 ? "day" : "days")
                
                return cell
                
            }else if name == nameHL {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileHomeLandTVCell", for: indexPath) as! ProfileHomeLandTVCell
                cell.icon.image = arrIcons[indexPath.row]
                cell.lBTitle.text = arrNames[indexPath.row]
                
                cell.searchResultSortFilter = appDelegate.userData?.user?.userDetails?.homeLandSortFilter
                
                
                cell.actionHandler = { (button) in
                    
                    
                    let homeLand = kStoryboardMain.instantiateViewController(withIdentifier: "HomeLandVC") as! HomeLandVC
                    homeLand.isFromProfile = true
                    
                    if button == cell.btnSearch {
                        
                        homeLand.myPlaceQuiz = MyPlaceQuiz.init()
                        homeLand.filter = cell.searchResultSortFilter ?? SortFilter()
                        homeLand.dataFromFilter ()
                        
                        CodeManager.sharedInstance.sendScreenName(burbank_profile_homeAndLand_designs_button_touch)
                        
                    }
                    else {
                        
                        CodeManager.sharedInstance.sendScreenName(burbank_profile_homeAndLand_recentSearch_button_touch)
                        
                        
                        homeLand.myPlaceQuiz = MyPlaceQuiz.init()
                        homeLand.isFavoritesService = true
                        
                        //                        "Favourite Designs"
                        
                        homeLand.isFromProfileFavorites = true
                        
                        if kHomeLandFavoritesCount == 0 {
                            return
                        }
                    }
                    
                    self.navigationController?.pushViewController(homeLand, animated: true)
                    
                }
                
                return cell
                
            }else if name == nameSettings {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileSettingsTVCell", for: indexPath) as! ProfileSettingsTVCell
                cell.icon.image = arrIcons[indexPath.row]
                cell.lBTitle.text = arrNames[indexPath.row]
                
                cell.switchLocation.isOn = LocationServices.shared.isLocationServicesEnabled ()
                
                NotificationServices.shared.isNotificationServicesEnabled { (enabled) in
                    cell.switchNotifications.isOn = enabled
                    
                    cell.selectionColorsForSwitch(switchService: cell.switchNotifications)
                }
                
                
                cell.selectionColorsForSwitch(switchService: cell.switchLocation)
                
                
                cell.btnLogout.addTarget(self, action: #selector(handleLogoutAction(_:)), for: .touchUpInside)
                
                return cell
                
            }
            else if name == nameFavourites{
             let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTVCell", for: indexPath) as! ProfileTVCell
            cell.icon.image = arrIcons[indexPath.row]?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                cell.icon.tintColor = APPCOLORS_3.GreyTextFont
            cell.lBTitle.text = arrNames[indexPath.row]
            return cell
           }
            
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTVCell", for: indexPath) as! ProfileTVCell
        
        cell.icon.image = arrIcons[indexPath.row]?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        cell.icon.tintColor = APPCOLORS_3.GreyTextFont
        cell.lBTitle.text = arrNames[indexPath.row]
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if selectedIndex == indexPath.row {
            selectedIndex = -1
            selectedRowHeight = rowHeight
            
        }else {
            
            selectedIndex = indexPath.row
            let name = arrNames[selectedIndex]
            
            if name == nameMyDetails {
                
                if appDelegate.userData?.user?.userFacebookID != nil, appDelegate.userData?.user?.userFacebookID != "" {
                    
                    selectedRowHeight = rowHeightProfileDetails_noImage
                }else if appDelegate.userData?.user?.userGoogleID != nil, appDelegate.userData?.user?.userGoogleID != "" {
                    
                    selectedRowHeight = rowHeightProfileDetails_noImage
                }else {
                    
                    selectedRowHeight = rowHeightProfileDetails
                }
                
                
                CodeManager.sharedInstance.sendScreenName(burbank_profile_myDetails_button_touch)
                
            }
            else if name == nameShare {
                
                selectedIndex = -1
                
                self.shareVC?.getInvitations()
                
                self.tableProfile.reloadData()
                
                
                CodeManager.sharedInstance.sendScreenName(burbank_profile_shareAccount_button_touch)
                
            }
            else if name == nameFavourites{
                
//                let fvrtVC = kStoryboardMain.instantiateViewController(withIdentifier: "FavouritesVC") as! FavouritesVC
//
//                self.navigationController?.pushViewController(fvrtVC, animated: true)
//                 tabBarController?.selectedIndex = 4
                let dash = kStoryboardMain.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
                
                (dash as UITabBarController).selectedIndex = 3
                
//                if ((self.parent?.parent?.parent?.isKind(of: DashboardVC.self)) != nil)
//                {
//                    if let vc = self.parent?.parent?.parent as? DashboardVC
//                    {
//                        vc.selectedIndex = 3
//                        vc.selectedViewController?.navigationController?.viewControllers.forEach({ subvc in
//                            if subvc.isKind(of: FavouritesVC.self)
//                            {
//                                vc.selectedViewController?.navigationController?.popToViewController(subvc, animated: true)
//                            }
//                        })
//
//                    }
//
//                }else {
//                    if self.navigationController == nil
//                    {
//                        kWindow.rootViewController = dash
//                        kWindow.makeKeyAndVisible()
//                    }else {
//                        self.navigationController?.pushViewController(dash, animated: true)
//                    }
//                }
                kWindow.rootViewController = dash
                kWindow.makeKeyAndVisible()
                
            }
            //            else if name == nameMyCollection { selectedRowHeight = rowHeightCollection }
            else if name == nameMyday { selectedRowHeight = rowHeightMyDay }
            else if name == nameHL {
                
                selectedIndex = -1
                
                ProfileDataManagement.shared.recentSearchData(SearchType.shared.homeLand, Int(kUserState)!, kUserID, succe: { (recentSearchResult) in
                    
                    if let recent = recentSearchResult {
                        
                        appDelegate.userData?.user?.userDetails?.homeLandSortFilter = SortFilter (dict: recent.value(forKey: "SearchJson") as! NSDictionary, recentsearch: true)
                        
                        setHomeLandFavouritesCount(count: (recent.value(forKey: "UserFavourites") as! NSNumber).intValue, state: kUserState)
                        
                        self.selectedIndex = indexPath.row
                        
                        self.setHeightForViewBasedonRowsHeight()
                        self.tableProfile.reloadData()
                    }
                    else {
                        AlertManager.sharedInstance.alert("Recent Searches not available")
                    }
                })
                
                
                CodeManager.sharedInstance.sendScreenName(burbank_profile_homeAndLand_button_touch)
                
            }
            else if name == nameMyCollection {
                
                selectedIndex = -1
                
                
                ProfileDataManagement.shared.recentSearchData(SearchType.shared.newHomes, Int(kUserState)!, kUserID, succe: { (recentSearchResult) in
                    
                    if let recent = recentSearchResult {
                        
                        guard let resultFeatures = recent.value(forKey: "SearchJson") as? NSArray else {
                            
                            AlertManager.sharedInstance.alert("Recent Searches not available")
                            
                            setHomeDesignsFavouritesCount(count: (recent.value(forKey: "UserFavourites") as? NSNumber)?.intValue ?? 0, state: kUserState)
                            
                            return
                        }
                        
                        var rece = [NSDictionary] ()
                        
                        for item in resultFeatures as! [NSDictionary] {
                            
                            if String.checkNullValue(item.value(forKey: "feature") as Any).contains("resultsCount") {
                                
                                setCollectionsCount(count: (String.checkNullValue(item.value(forKey: "Answer") as Any) as NSString).integerValue, state: kUserState)
                                
                            }else {
                                
                                rece.append(item)
                            }
                        }
                        appDelegate.userData?.user?.userDetails?.collectionRecentSearch = rece as NSArray
                        
                        setHomeDesignsFavouritesCount(count: (recent.value(forKey: "UserFavourites") as? NSNumber)?.intValue ?? 0, state: kUserState)
                        
                        
                        self.selectedIndex = indexPath.row
                        
                        
                        self.tableProfile.reloadData()
                        
                    }else {
                        AlertManager.sharedInstance.alert("Recent Searches not available")
                    }
                })
                
                CodeManager.sharedInstance.sendScreenName(burbank_profile_myCollection_button_touch)
                
            }
            else if name == nameMyDesign {
                
                selectedIndex = -1
                ProfileDataManagement.shared.recentSearchData(SearchType.shared.newHomes, Int(kUserState)!, kUserID, succe: { (recentSearchResult) in
                    
                    if let recent = recentSearchResult {
                        
                        if let resultFeatures = recent.value(forKey: "SearchJson") as? NSArray {
                            
                            let count = (recent.value(forKey: "UserFavourites") as! NSNumber).intValue
                            
                            if count == 0 {
                                setHomeDesignsFavouritesCount(count: 0, state: kUserState)
                                
                                AlertManager.sharedInstance.alert("Favourites not available")
                            }else {
                                
                                var rece = [NSDictionary] ()
                                
                                for item in resultFeatures as! [NSDictionary] {
                                    
                                    if String.checkNullValue(item.value(forKey: "feature") as Any).contains("resultsCount") {
                                        
                                        setCollectionsCount(count: (String.checkNullValue(item.value(forKey: "Answer") as Any) as NSString).integerValue, state: kUserState)
                                    }else {
                                        
                                        rece.append(item)
                                    }
                                    
                                    appDelegate.userData?.user?.userDetails?.collectionRecentSearch = rece as NSArray
                                    
                                }
                                
                                self.selectedIndex = indexPath.row
                                
                            }
                        } else {
                            
                        }
                        
                        setHomeDesignsFavouritesCount(count: (recent.value(forKey: "UserFavourites") as! NSNumber).intValue, state: kUserState)
                        
                        self.tableProfile.reloadData()
                        
                    }else {
                        
                        setHomeDesignsFavouritesCount(count: 0, state: kUserState)
                        
                        AlertManager.sharedInstance.alert("Favourites not available")
                    }
                })
                
                
                CodeManager.sharedInstance.sendScreenName(burbank_profile_homeDesigns_button_touch)
                
            }
            else if name == nameDisplayHomes {
                
                selectedIndex = -1
                _ = Networking.shared.GET_request(url: ServiceAPI.shared.URL_FavoriteDisplayHomes(Int(kUserID) ?? 0,Int(kUserState) ?? 0 ), userInfo: nil, success: { (json, response) in
                    if let result: AnyObject = json {
                        let result = result as! NSDictionary
                        if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {
                            if let result: AnyObject = json {
                                if (result.allKeys as! [String]).contains("userFavDisplays") {
                                    let packagesResult = result.value(forKey: "userFavDisplays") as! [NSDictionary]
                                    self.displayFavorites = []
                                    for package: NSDictionary in packagesResult {
                                        
                                        let suggestedData = houseDetailsByHouseType(package as! [String : Any])
                                        self.displayFavorites.append(suggestedData)
                                    }
                                    DispatchQueue.main.async {
                                        
                                        if self.displayFavorites.count == 0 {
                                            setDisplayHomesFavouritesCount(count: 0, state: kUserState)
                                            AlertManager.sharedInstance.alert("Favourites not available")
                                        }else {
                                            
                                            self.selectedIndex = indexPath.row
                                            self.tableProfile.reloadData()
                                        }
                                    }
                                }else { print(log: "no SuggestedHomesData found") }
                                
                            }else {
                                
                            }
                        }
                    }
                }, errorblock: { (error, isJSONerror) in
                    
                    if isJSONerror { }
                    else { }
                    
                }, progress: nil)
                //                ProfileDataManagement.shared.recentSearchData(3, Int(kUserState)!, kUserID, succe: { (recentSearchResult) in
                //
                //                    if let recent = recentSearchResult {
                //
                //                        if let resultFeatures = recent.value(forKey: "SearchJson") as? NSArray {
                //
                //                            let count = (recent.value(forKey: "UserFavourites") as! NSNumber).intValue
                //
                //                            if count == 0 {
                //                                setDisplayHomesFavouritesCount (count: 0, state: kUserState)
                //
                //                                AlertManager.sharedInstance.alert("Favourites not available")
                //                            }else {
                //
                //                                var rece = [NSDictionary] ()
                //
                //                                for item in resultFeatures as! [NSDictionary] {
                //
                //                                    if String.checkNullValue(item.value(forKey: "feature") as Any).contains("resultsCount") {
                //
                //                                        setDisplayHomesFavouritesCount(count: (String.checkNullValue(item.value(forKey: "Answer") as Any) as NSString).integerValue, state: kUserState)
                //                                    }else {
                //
                //                                        rece.append(item)
                //                                    }
                //
                //                                    appDelegate.userData?.user?.userDetails?.collectionRecentSearch = rece as NSArray
                //                                }
                //
                //                                self.selectedIndex = indexPath.row
                //
                //                            }
                //                        } else {
                //
                //                        }
                //
                //                        setDisplayHomesFavouritesCount(count: (recent.value(forKey: "UserFavourites") as! NSNumber).intValue, state: kUserState)
                //
                //                        self.tableProfile.reloadData()
                //
                //                    }else {
                //
                //                        setDisplayHomesFavouritesCount(count: 0, state: kUserState)
                //
                //                        AlertManager.sharedInstance.alert("Favourites not available")
                //                    }
                //                })
                
                
                CodeManager.sharedInstance.sendScreenName(burbank_profile_homeDesigns_button_touch)
                
            }
            else if name == nameSettings {
                selectedRowHeight = rowHeightSettings
                CodeManager.sharedInstance.sendScreenName(burbank_profile_appSettings_button_touch)
            }
            
        }
        
        
        setHeightForViewBasedonRowsHeight()
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if selectedIndex == indexPath.row {
            
            let name = arrNames[selectedIndex]
            
            if name == nameShare || name == nameHL || name == nameMyCollection || name == nameMyDesign || name == nameDisplayHomes || name == nameMyDetails{
                
                return UITableView.automaticDimension
            }
            return selectedRowHeight
        }
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if selectedIndex == indexPath.row {
            
            let name = arrNames[selectedIndex]
            
            if name == nameShare || name == nameHL || name == nameMyCollection || name == nameMyDesign || name == nameDisplayHomes {
                
                return UITableView.automaticDimension
            }
            return selectedRowHeight
        }
        return rowHeight
    }
    
}

//MARK: - Cell Actions

extension UserProfileVC {
    //MyDay
    @IBAction func handleViewJourneyAction (_ sender: UIButton) {
        
    }
    
    //MARK: Profile Details
    @IBAction func handleUpdateDetailsAction (_ sender: UIButton) {
        
        CodeManager.sharedInstance.sendScreenName(burbank_profile_myDetails_update_button_touch)
        
        if tableProfile.cellForRow(at: IndexPath.init(row: 0, section: 0))!.isKind(of: ProfileDetailsTVCell.self) {
            
            let cell = tableProfile.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! ProfileDetailsTVCell
            
            //            if let name = cell.txtName.text {
            //                if name == "" {
            //                    showToast("First Name should be minimum of 3 letters", self)
            //                    return
            //                }else{
            //
            //                }
            //            }
            if !(cell.txtName.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? false) {
                print(cell.txtName.text?.trimmingCharacters(in: .whitespaces) ?? "")
                // string contains non-whitespace characters
            }else{
                print(cell.txtName.text?.trimmingCharacters(in: .whitespaces) ?? "")
                showToast("Name should be minimum of 3 letters", self)
                return
            }
            
//            if !(cell.txtLastName.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? false) {
//                print(cell.txtLastName.text?.trimmingCharacters(in: .whitespaces) ?? "")
//                // string contains non-whitespace characters
//            }else{
//                print(cell.txtLastName.text?.trimmingCharacters(in: .whitespaces) ?? "")
//                showToast("Last Name should be minimum of 3 letters", self)
//                return
//            }
            
            if let existedPhone = appDelegate.userData?.user?.userPhoneNumber {
                if existedPhone.count > 0, cell.txtPhone.text?.trim().count == 0 {
                    ActivityManager.showToast("Please enter phone number", self)
                    return
                }
            }
            
            if !(cell.txtPhone.text?.trim().isPhoneNumber)! {
                ActivityManager.showToast("Please enter valid phone number", self)
                return
            }
            
            if (cell.txtPhone.text?.trim().count ?? 0) < 8 {
                ActivityManager.showToast("Phone number should be a minimum of 8 characters length", self)
                return
            }
            
            
            let user = UserBean.init()
            
            user.userFirstName = cell.txtName.text
            user.userLastName = appDelegate.userData?.user?.userLastName
            user.userEmail = appDelegate.userData?.user?.userEmail
            user.userPhoneNumber = cell.txtPhone.text
            
            user.userPassword = appDelegate.userData?.user?.userPassword
            
            var canUpdate = false
            
            if user.userFirstName != appDelegate.userData?.user?.userFirstName {
                canUpdate = true
            }
            if user.userLastName != appDelegate.userData?.user?.userLastName {
                canUpdate = true
                print(canUpdate)
            }
            
            if user.userPhoneNumber != appDelegate.userData?.user?.userPhoneNumber {
                canUpdate = true
            }
            
            
            if canUpdate {
                
                ProfileDataManagement.shared.updateProfileDetails(user) {
                    
                    ProfileDataManagement.shared.getProfileDetails(appDelegate.userData?.user ?? UserBean.init()) {
                        
                        self.tableProfile.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
                    }
                    
                }
                
            }
            
        }
    }
    
    //MARK: ProfilePic Selection
    @IBAction func handleSelectProfilePicAction (_ sender: UIButton) { //my details cell
        
        CodeManager.sharedInstance.sendScreenName(burbank_profile_myDetails_select_button_touch)
        
        imagePicker.showPicker(presentationController: self, sourceView: self.view, false)
        imagePicker.selectImageFromPicker = { (image) -> Void in
            if let img = image {
                self.selectedImage = img
                self.showCropView()
            }
        }
    }
    
    //MARK: LogOut
    @IBAction func handleLogoutAction (_ sender: UIButton) {
        
        CodeManager.sharedInstance.sendScreenName(burbank_profile_appSettings_logout_button_touch)
        
        BurbankApp.showAlert("Are you sure, you want to Logout?", self, ["NO", "YES"]) { (str) in
            
            if str == "YES" {
                logoutUser()
            }
        }
    }
    
    
    //MARK: Share Popup
    
    //MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "share" {
            shareVC = segue.destination as? ShareVC
            
            //            shareVC?.getInvitations()
            
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
            
            self.selectedIndex = self.arrNames.firstIndex(of: nameShare)!
            
            self.tableProfile.reloadData()
            
        }
        
    }
    
    
    
}


extension UserProfileVC: CropViewControllerDelegate {
    
    func showCropView() {
        
        let cropController = CropViewController(croppingStyle: CropViewCroppingStyle.default, image: self.selectedImage!)
        //cropController.modalPresentationStyle = .fullScreen
        cropController.delegate = self
        
        // Uncomment this if you wish to provide extra instructions via a title label
        //cropController.title = "Crop Image"
        
        // -- Uncomment these if you want to test out restoring to a previous crop setting --
        //cropController.angle = 90 // The initial angle in which the image will be rotated
        //cropController.imageCropFrame = CGRect(x: 0, y: 0, width: 2848, height: 4288) //The initial frame that the crop controller will have visible.
        
        // -- Uncomment the following lines of code to test out the aspect ratio features --
        //cropController.aspectRatioPreset = .presetSquare; //Set the initial aspect ratio as a square
        //cropController.aspectRatioLockEnabled = true // The crop box is locked to the aspect ratio and can't be resized away from it
        //cropController.resetAspectRatioEnabled = false // When tapping 'reset', the aspect ratio will NOT be reset back to default
        //cropController.aspectRatioPickerButtonHidden = true
        
        // -- Uncomment this line of code to place the toolbar at the top of the view controller --
        //cropController.toolbarPosition = .top
        
        //cropController.rotateButtonsHidden = true
        //cropController.rotateClockwiseButtonHidden = true
        
        //cropController.doneButtonTitle = "Title"
        //cropController.cancelButtonTitle = "Title"
        
        //cropController.toolbar.doneButtonHidden = true
        //cropController.toolbar.cancelButtonHidden = true
        //cropController.toolbar.clampButtonHidden = true
        //        self.image = image
        
        //If profile picture, push onto the same navigation stack
        //        if croppingStyle == .circular {
        //            if picker.sourceType == .camera {
        //                picker.dismiss(animated: true, completion: {
        //                    self.present(cropController, animated: true, completion: nil)
        //                })
        //            } else {
        //                picker.pushViewController(cropController, animated: true)
        //            }
        //        }
        //        else { //otherwise dismiss, and then present from the main controller
        //            picker.dismiss(animated: true, completion: {
        //                self.present(cropController, animated: true, completion: nil)
        //                //self.navigationController!.pushViewController(cropController, animated: true)
        //            })
        //        }
        
        
        self.present(cropController, animated: true, completion: nil)
        
    }
    
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        
        cropViewController.dismiss(animated: true) {
            if let profileImage = self.completionHandlerProfilePicUpdate {
                profileImage()
            }
        }
    }
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.croppedRect = cropRect
        self.croppedAngle = angle
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
        
    }
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.croppedRect = cropRect
        self.croppedAngle = angle
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
    }
    
    public func updateImageViewWithImage(_ image: UIImage, fromCropViewController cropViewController: CropViewController) {
        //        imageView.image = image
        //        layoutImageView()
        
        //        self.navigationItem.leftBarButtonItem?.isEnabled = true
        
        //        if cropViewController.croppingStyle != .circular {
        //            imageView.isHidden = true
        //
        //            cropViewController.dismissAnimatedFrom(self, withCroppedImage: image,
        //                                                   toView: imageView,
        //                                                   toFrame: CGRect.zero,
        //                                                   setup: { self.layoutImageView() },
        //                                                   completion: {
        //                                                    self.imageView.isHidden = false })
        //        }
        //        else {
        //            self.imageView.isHidden = false
        //        }
        
        
        
        self.selectedImage = image
        
        BurbankApp.showAlert("Do you want to update profile picture??", cropViewController, ["No", "Yes"]) { (action) in
            
            if action == "Yes" {
                
                self.updateProfileImage(self.selectedImage!)
            }
            
            cropViewController.dismiss(animated: true) {
                if let profileImage = self.completionHandlerProfilePicUpdate {
                    profileImage()
                }
            }
            
        }
        
    }
    
    
    //MARK: - APIs
    
    //MARK: - Update Profile Image
    
    func updateProfileImage (_ imagee: UIImage) {
        
        let data = Data(referencing: imagesPickManager.sharedInstance.compressImage(image: imagee))
        let base64Str = data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)).replacingOccurrences(of: "\r\n", with: "")
        let parameters = NSMutableDictionary()
        parameters.setValue(kUserID, forKey: "UserId")
        parameters.setValue(base64Str, forKey: "ImageContent")
        
        //                    let parameters = ["UserId" : kUserID, "ImageContent" : base64Str.replacingOccurrences(of: "'\'/", with: "/")]
        
        let _ = Networking.shared.POST_request(url: ServiceAPI.shared.URL_updateProfileImage, parameters: parameters as NSDictionary, userInfo: nil, success: { (json, response) in
            
            if let result: AnyObject = json {
                //\/9j\/4AAQSkZJRgABAQAASABIAAD
                ///9j/4AAQSkZJRgABAQAASABIAAD
                
                let result = result as! NSDictionary
                
                if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {
                    
                    self.btnProfileImage.setBackgroundImage(imagee, for: .normal)
                    
                    if let imageURL = appDelegate.userData?.user?.userProfileImageURL {
                        
                        showActivityFor(view: self.view)
                        
                        //                        SDImageCache.shared.removeImageFromDisk(forKey: imageURL)
                        //                        SDImageCache.shared.removeImageFromMemory(forKey: imageURL)
                        
                        NVImageCache.shared()?.removeImage(forKey: imageURL)
                        NVImageCache.shared()?.removeImage(forKey: imageURL, fromDisk: true)
                        
                        ImageDownloader.removeImage(forKey: imageURL) {
                            
                            hideActivityFor(view: self.view)
                            
                            appDelegate.userData?.user?.userProfileImageURL = ServiceAPI.shared.URL_imageUrl(String.checkNullValue(result.value(forKey: "File") as Any))
                            appDelegate.userData?.saveUserDetails()
                        }
                        
                        //                        ProfileDataManagement.shared.getProfileDetails(appDelegate.userData?.user ?? UserBean.init()) {
                        //                            appDelegate.userData?.user?.userProfileImageURL = ServiceAPI.shared.URL_imageUrl(String.checkNullValue(result.value(forKey: "File") as Any))
                        //                            appDelegate.userData?.saveUserDetails()
                        //                        }
                    }
                    
                    
                    
                    
                }else {
                    alert.showAlert("", "Image upload Failed, Do you wish to upload it again?", self, ["No", "Yes"]) { (action) in
                        
                        if action == "Yes" {
                            
                            self.updateProfileImage(imagee)
                        }
                    }
                }
            }else {
                
            }
            
            
        }, errorblock: { (error, isJson) in
            
            
        }, progress: nil)
    }
    
    
    func getProfileNotificationsCount () {
        
        //        let parameters = NSMutableDictionary()
        //        parameters.setValue(kUserID, forKey: "UserId")
        //        parameters.setValue(kUserState, forKey: "StateId")
        //
        //
        //        let _ = Networking.shared.POST_request(url: ServiceAPI.shared.URL_updateProfileImage, parameters: parameters as NSDictionary, userInfo: nil, success: { (json, response) in
        //
        //            if let result: AnyObject = json {
        //
        //                let result = result as! NSDictionary
        //
        //                if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {
        //
        //                    appDelegate.userData?.user?.userDetails?.searchHomeLandCount = (String.checkNullValue(result.value(forKey: "File") as Any) as NSString).integerValue
        //                    appDelegate.userData?.user?.userDetails?.searchCollectionCount = (String.checkNullValue(result.value(forKey: "File") as Any) as NSString).integerValue
        //                    appDelegate.userData?.user?.userDetails?.searchHomeDesignCount = (String.checkNullValue(result.value(forKey: "File") as Any) as NSString).integerValue
        //                    appDelegate.userData?.user?.userDetails?.totalInvitationsCount = (String.checkNullValue(result.value(forKey: "File") as Any) as NSString).integerValue
        //
        //
        //                    appDelegate.userData?.saveUserDetails()
        //                    appDelegate.userData?.loadUserDetails()
        //
        //                }else {
        //
        //                }
        //            }else {
        //
        //            }
        //
        //            self.tableProfile.reloadData()
        //
        //        }, errorblock: { (error, isJson) in
        //
        //
        //        }, progress: nil)
        //
    }
    
}




//MARK: - Default profile Cell

class ProfileTVCell: UITableViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var lBCount: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var lBTitle: UILabel!
    @IBOutlet weak var btnArrow: UIButton!
    @IBOutlet weak var lBLine: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setAppearanceFor(view: lBCount, backgroundColor: APPCOLORS_3.Black_BG, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_SUB_HEADING(size: FONT_8))
        setAppearanceFor(view: lBTitle, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_SUB_HEADING (size: FONT_14))
        setAppearanceFor(view: lBLine, backgroundColor: APPCOLORS_3.EnabledOrange_BG, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_LIGHT(size: FONT_12))
        
        
        lBCount.layer.cornerRadius = lBCount.frame.size.height/2
        
        lBCount.isHidden = true
        
        lBCount.text = "0"
        lBCount.textColor = .white
        
        icon.tintColor = APPCOLORS_3.GreyTextFont
        lBCount.backgroundColor = APPCOLORS_3.GreyTextFont
        btnArrow.setImage(UIImage(named: "Ico-DownArrow")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnArrow.tintColor = APPCOLORS_3.GreyTextFont
        btnArrow.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
    
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
