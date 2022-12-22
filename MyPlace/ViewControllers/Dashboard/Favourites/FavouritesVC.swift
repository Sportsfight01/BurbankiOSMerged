//
//  FavouritesVC.swift
//  BurbankApp
//
//  Created by Naveen Kourampalli on 23/11/22.
//  Copyright © 2022 Sreekanth tadi. All rights reserved.
//

import UIKit

class FavouritesVC: HeaderVC {

   
    let arrIcons = [iconCollection, iconHL, iconDH]
    let arrNames = [nameMyDesign, nameHL, nameDisplayHomes]

    @IBOutlet weak var profileHeaderView: UIView!
    
    @IBOutlet weak var tableViewFvrts: UITableView!
    var selectedIndex = -1
    var displayFavorites = [houseDetailsByHouseType]()
    var logoLabelProfile = UILabel()
    var btnProfileImage = UIButton()
    var lBInfo = UILabel()
    var completionHandlerProfile: (() -> Void)?
    var completionHandlerProfilePicUpdate: (() -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewFvrts.tableFooterView = UIView(frame: .zero)
        
//        setShadowatBottom(view: profileViewBorder, color: COLOR_BLACK, shadowRadius: 5.0)
        
        
        tableViewFvrts.backgroundColor = AppColors.white
        view.backgroundColor = COLOR_CLEAR
//        profileViewBorder.backgroundColor = COLOR_CLEAR
        
        btnProfileImage.layer.cornerRadius = btnProfileImage.frame.size.height/2
        btnProfileImage.clipsToBounds = true
        getDisplaysNotificationsCount()
        setHeightForViewBasedonRowsHeight()
        
        addHeaderViewOptions()
        self.tableViewFvrts.register(UINib(nibName: "MyDesignsTVC", bundle: nil), forCellReuseIdentifier: "MyDesignsTVC")
        self.tableViewFvrts.register(UINib(nibName: "DisplayHomesTVC", bundle: nil), forCellReuseIdentifier: "DisplayHomesTVC")

        self.tableViewFvrts.register(UINib(nibName: "HomeAndLandTVC", bundle: nil), forCellReuseIdentifier: "HomeAndLandTVC")
        self.tableViewFvrts.register(UINib(nibName: "FavouritesTVCell", bundle: nil), forCellReuseIdentifier: "FavouritesTVCell")
      
            showBackButton()
            btnBack.addTarget(self, action: #selector(handleBackButton(_:)), for: .touchUpInside)
            btnBackFull.addTarget(self, action: #selector(handleBackButton(_:)), for: .touchUpInside)
        

    }
    
    @IBAction func handleBackButton (_ sender: UIButton) {
        
        if navigationController?.viewControllers.count == 1 {
            self.tabBarController?.navigationController?.popViewController(animated: true)
        }else {
            self.navigationController?.popViewController(animated: true)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension FavouritesVC{
    func addHeaderViewOptions () {
        headerLogoText = "MyFavourites"
        self.addBreadcrumb("View your saved favourites")
        showBackButton()
        let yPosPadding: CGFloat = 15.0//20.0
        let xPosPadding: CGFloat = 20.0
        
        var yPos: CGFloat = yPosPadding + statusBarHeight()
        let xPos: CGFloat = xPosPadding
        let leftPadding: CGFloat = 20.0
        btnProfileImage.frame = CGRect(x: SCREEN_WIDTH - profileImageHeight - 15, y: yPos, width: profileImageHeight, height: profileImageHeight)
        btnProfileImage.layer.cornerRadius = btnProfileImage.frame.size.height/2
        btnProfileImage.clipsToBounds = true
        logoLabelProfile.frame = CGRect(x: xPos, y: yPos-yPosPadding/2, width: btnProfileImage.frame.origin.x - xPos - 10, height: (profileHeaderHeight-statusBarHeight())*0.398)
        logoLabelProfile.frame.origin.y = yPos + (btnProfileImage.frame.size.height - logoLabelProfile.frame.size.height)/2
        print(log: logoImageHeight)
        print(log: (profileHeaderHeight-statusBarHeight())*0.398)
        yPos = yPos + logoLabelProfile.frame.size.height
        yPos = logoLabelProfile.frame.origin.y + logoLabelProfile.frame.size.height
        yPos = btnProfileImage.frame.origin.y + btnProfileImage.frame.size.height
        lBInfo.frame = CGRect(x: xPos, y: yPos, width: SCREEN_WIDTH - leftPadding - xPos, height: 40)
        lBInfo.numberOfLines = 2
        lBInfo.lineBreakMode = .byTruncatingTail
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
}
extension FavouritesVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrNames.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        
        if cell.isKind(of: FavouritesTVCell.self) {
            let cell = cell as! FavouritesTVCell
            cell.icon.image = arrIcons[indexPath.row]
            cell.lBTitle.text = arrNames[indexPath.row]
            let name = arrNames[indexPath.row]
            cell.lBCount.isHidden = false
            cell.lBCount.text = "0"
            if name == nameMyDesign {
                cell.lBCount.text = "\(kDesignFavoritesCount)"
            }else if name == nameHL {
                cell.lBCount.text = "\(kHomeLandFavoritesCount)"
            }else if name == nameDisplayHomes{
                cell.lBCount.text = "\(self.displayFavorites.count)"
            }
           
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if selectedIndex == indexPath.row {
            let name = arrNames[selectedIndex]
            arrIcons[indexPath.row]?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            
            if name == nameMyDesign {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "MyDesignsTVC", for: indexPath) as! MyDesignsTVC
                cell.icon.image = arrIcons[indexPath.row]
                cell.lBTitle.text = arrNames[indexPath.row]
                
                if let recentSearch = appDelegate.userData?.user?.userDetails?.collectionRecentSearch {
                    
                    cell.searchResultSortFilter = recentSearch as? [NSDictionary]
                    cell.bottomView.cardView(cornerRadius : 10.0)
                    cell.btnSavedDesigns.cardView(cornerRadius : 10.0, backgroundColor : cell.btnSavedDesigns.backgroundColor ?? AppColors.appOrange)
                    
                    cell.actionHandler = { (button) in
                        
                        CodeManager.sharedInstance.sendScreenName(burbank_profile_homeDesigns_savedDesigns_button_touch)
                        
                        let designs = kStoryboardMain.instantiateViewController(withIdentifier: "DesignsVC") as! DesignsVC
                        
                        
                        
                        if button == cell.btnSearch
                        {
                            designs.isFromProfileFavorites = false
                            designs.isFavorites = false
                            if let features = cell.homeDesignFeatures
                            {
                                designs.displayText = cell.displayTextWithDesignFeatures(features)
                            }
                        
                           // designs.filter = SortFilter()
                        }else {
                            designs.isFromProfileFavorites = true
                            
                            designs.isFavorites = true
                            designs.displayText = "Favourite Designs"
                        }
                        designs.isFromCollection = true
                        designs.filter = SortFilter ()
                        
                        self.navigationController?.pushViewController(designs, animated: true)
                        
                        
                        designs.selectedFeatures = recentSearch as? [NSDictionary]
                        
                        //                        if let features = cell.homeDesignFeatures {
                        //                            displayVC.displayText = features.count > 0 ? cell.displayTextWithDesignFeatures(features) : ""
                        //                        }else {
                       
                        //                        }
                        
                    }
                }
                
                return cell
                
            }else if name == nameDisplayHomes {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "DisplayHomesTVC", for: indexPath) as! DisplayHomesTVC
                
                cell.icon.image = arrIcons[indexPath.row]?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                cell.icon.tintColor = .black
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
            }else if name == nameHL {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "HomeAndLandTVC", for: indexPath) as! HomeAndLandTVC
                cell.icon.image = arrIcons[indexPath.row]
                cell.lBTitle.text = arrNames[indexPath.row]
                
                cell.searchResultSortFilter = appDelegate.userData?.user?.userDetails?.homeLandSortFilter
                cell.bottomViewBottom.cardView(cornerRadius : 10.0)
                cell.btnSavedDesigns.cardView(cornerRadius : 10.0, backgroundColor : cell.btnSavedDesigns.backgroundColor ?? AppColors.appOrange)
                
                cell.actionHandler = { (button) in
                    
                    
                    let homeLand = kStoryboardMain.instantiateViewController(withIdentifier: "HomeLandVC") as! HomeLandVC
                    homeLand.isFromProfile = true
                    
                    if button == cell.btnSearch {
                        
                        homeLand.myPlaceQuiz = MyPlaceQuiz.init()
                        homeLand.filter = cell.searchResultSortFilter ?? SortFilter()
                        homeLand.dataFromFilter ()
                        
                        CodeManager.sharedInstance.sendScreenName(burbank_profile_homeAndLand_designs_button_touch)
                        
                    }else {
                        
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
                
            }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavouritesTVCell", for: indexPath) as! FavouritesTVCell
        
        cell.icon.image = arrIcons[indexPath.row]?.withRenderingMode(.alwaysTemplate)
        cell.icon.tintColor = .black
        cell.lBTitle.text = arrNames[indexPath.row]
       // cell.lBTitle.textColor = AppColors.black
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if selectedIndex == indexPath.row {
            selectedIndex = -1
            selectedRowHeight = rowHeight
            
        }else {
            
            selectedIndex = indexPath.row
            let name = arrNames[selectedIndex]
            
             if name == nameHL {
                
                selectedIndex = -1
                
                ProfileDataManagement.shared.recentSearchData(SearchType.shared.homeLand, Int(kUserState)!, kUserID, succe: { (recentSearchResult) in
                    
                    if let recent = recentSearchResult {
                                                
                        appDelegate.userData?.user?.userDetails?.homeLandSortFilter = SortFilter (dict: recent.value(forKey: "SearchJson") as! NSDictionary, recentsearch: true)
                                                
                        setHomeLandFavouritesCount(count: (recent.value(forKey: "UserFavourites") as! NSNumber).intValue, state: kUserState)
                        
                        self.selectedIndex = indexPath.row
                        
                    //    self.setHeightForViewBasedonRowsHeight()
                        self.tableViewFvrts.reloadData()
                    }
                    else {
                        AlertManager.sharedInstance.alert("Recent Searches not available")
                    }
                })
                
                
                CodeManager.sharedInstance.sendScreenName(burbank_profile_homeAndLand_button_touch)
                
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
                        
                        self.tableViewFvrts.reloadData()

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
                                            self.tableViewFvrts.reloadData()
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
                CodeManager.sharedInstance.sendScreenName(burbank_profile_homeDesigns_button_touch)
            }
        }        
        setHeightForViewBasedonRowsHeight()
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if selectedIndex == indexPath.row {
            
            let name = arrNames[selectedIndex]
            
            if  name == nameHL || name == nameMyDesign  || name == nameDisplayHomes{
                
                return UITableView.automaticDimension
            }
            return selectedRowHeight
        }
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if selectedIndex == indexPath.row {
            
            let name = arrNames[selectedIndex]
            
            if  name == nameHL || name == nameMyDesign  || name == nameDisplayHomes {
                
                return UITableView.automaticDimension
            }
            return selectedRowHeight
        }
        return rowHeight
    }
    
}

extension FavouritesVC{
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
                                    self.tableViewFvrts.reloadData()
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
}
