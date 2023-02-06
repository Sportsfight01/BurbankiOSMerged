//
//  DesignsVC.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 26/03/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit

class DesignsVC: HeaderVC {
    
    var isFromCollection: Bool = false
    
    @IBOutlet weak var favoriteHeaderView: UIView!
    @IBOutlet weak var favoriteHeaderHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var searchResultsView : UIView!
    
    @IBOutlet weak var searchResultsTable : UITableView!
    
    
    var myPlaceQuiz: MyPlaceQuiz?
    
    
    var isFavorites = false
    var arrFavouriteHomeDesigns = [[HomeDesigns]] ()
    
    var arrHomeDesigns = [HomeDesigns] ()
    
    var isFromProfileFavorites: Bool = false
    
    
    
    var selectedFeatures: [NSDictionary]? {
        didSet {
            getCollectionDesigns (selectedFeatures!)
        }
    }
    
    var displayText: String? {
        didSet {
            self.addBreadCrumb(from: displayText!)
        }
    }
    
    
    //MARK: - ViewLife Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchResultsTable.tableFooterView = UIView()
        headerLogoText = "HomeDesigns"
        isFromProfile = true

        //        if isFromCollection {
        if btnBack.isHidden {
            showBackButton()
            btnBack.addTarget(self, action: #selector(handleBackButton(_:)), for: .touchUpInside)
            btnBackFull.addTarget(self, action: #selector(handleBackButton(_:)), for: .touchUpInside)
        }
        //        }
        
        if isFromProfileFavorites {
            addHeaderOptions(sort: false, map: false, favourites: false, howWorks: false, delegate: self)
            favoriteHeaderView.isHidden = false
            favoriteHeaderHeightConstraint.constant = 50
            headerLogoText = "MyFavourites"
            addBreadcrumb("Home Designs")
        }else {
            favoriteHeaderView.isHidden = true
            favoriteHeaderHeightConstraint.constant = 0
            
            addHeaderOptions(sort: false, map: false, favourites: true, howWorks: false, reset: true,totalCount: true,  delegate: self)
        }
        
        
        if isFavorites {
            CodeManager.sharedInstance.sendScreenName(burbank_homeDesigns_favourite_screen_loading)
        }else {
            CodeManager.sharedInstance.sendScreenName(burbank_homeDesigns_results_screen_loading)
        }
        
        if #available(iOS 15.0, *) {
            searchResultsTable.sectionHeaderTopPadding = 0.0
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        btnMap.setTitle("  0 DESIGNS  ", for: .normal)
//        setFramesForOptionsViews()
//        btnTotalCollectionCount.setTitle(" TOTAL 0 DESIGNS ", for: .normal)
        
        if isFavorites {
            self.addBreadCrumb(from: "Favourite Designs")
            //            self.labelInfo.text = "Favourite Designs".uppercased()
        }else {
            if let filter = displayText {
                if filter.count > 0 {
                    self.addBreadCrumb(from: filter.capitalized)
                }else {
                    self.addBreadCrumb(from: infoStaicText.capitalized)
                }
            }else {
                self.addBreadCrumb(from: infoStaicText.capitalized)
            }
        }
        
        if isFavorites {
//            setAppearanceFor(view: btnMyProfile, backgroundColor: APPCOLORS_3.HeaderFooter_white_BG, textColor: APPCOLORS_3.Orange_BG, textFont: btnMyProfile.titleLabel!.font)
            getFavoriteDesigns()
        }
        
        self.searchResultsTable.reloadData()
        
    }
    
    //MARK: - Button Actions
    
    @IBAction func handleBackButton (_ sender: UIButton) {
        
        if navigationController?.viewControllers.count == 1 {
            self.tabBarController?.navigationController?.popViewController(animated: true)
        }else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}



extension DesignsVC: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Table View Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isFromCollection {
            if isFavorites {
                return arrFavouriteHomeDesigns.count
            }
            return 1
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFromCollection {
            if isFavorites {
                return arrFavouriteHomeDesigns[section].count
            }
            return arrHomeDesigns.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //        if isFromCollection {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionTVCell", for: indexPath) as! CollectionTVCell
        
        // Configure the cell...
        cell.selectionStyle = .none
        
        
        if isFavorites {
            
            cell.homeDesign = arrFavouriteHomeDesigns[indexPath.section][indexPath.row]
            
            cell.btnFavourite.isHidden = cell.homeDesign?.favouritedUser?.userID != kUserID
            
        }else {
            
            cell.homeDesign = arrHomeDesigns[indexPath.row]
        }
        
//        if Int(kUserID)! > 0 { print(log: kUserID) }
//        else {
//            cell.btnFavourite.isHidden = true
//        }
        
        cell.favoriteAction = {
            if noNeedofGuestUserToast(self, message: "Please login to add favourites") {
                if self.isFavorites {
                    CodeManager.sharedInstance.sendScreenName(burbank_homeDesigns_favourite_makeFavourite_button_touch)
                }else {
                    CodeManager.sharedInstance.sendScreenName(burbank_homeDesigns_results_makeFavourite_button_touch)
                }
                
                self.makeHomeDesignFavorite(!(cell.homeDesign!.isFav), cell.homeDesign!) { (success) in
                    
                    if success {
                        
                        if (!(cell.homeDesign?.isFav ?? false) == true) {
                            DispatchQueue.main.async(execute: {
                                ActivityManager.showToast("Added to your favourites", self)
                            })
                        }else{
                            DispatchQueue.main.async(execute: {
                                ActivityManager.showToast("Item removed from favourites", self)
                            })

                         }
                        
                        var updateDefaults = false
                        
                        if cell.homeDesign!.favouritedUser?.userID == kUserID {
                            updateDefaults = true
                        }
                        
                        if self.isFavorites {
                            
                            var arr = self.arrFavouriteHomeDesigns[indexPath.section]
                            arr.remove(at: indexPath.row)
                            
                            if arr.count == 0 {
                                self.arrFavouriteHomeDesigns.remove(at: indexPath.section)
                                
                                if updateDefaults {
                                    setHomeDesignsFavouritesCount(count: 0, state: kUserState)
                                }
                                
                            }else {
                                self.arrFavouriteHomeDesigns[indexPath.section] = arr
                                
                                if updateDefaults {
                                    setHomeDesignsFavouritesCount(count: arr.count, state: kUserState)
                                }
                                
                            }
                            
                            self.arrFavouriteHomeDesigns.count == 0 ? self.searchResultsTable.setEmptyMessage("NO SAVED DESIGNS", bgColor: APPCOLORS_3.Body_BG) : self.searchResultsTable.setEmptyMessage("", bgColor: COLOR_CLEAR)
                            
                            
                            self.searchResultsTable.reloadData ()
                            self.searchResultsTable.isScrollEnabled = true
                            
                            
                        }else {
                            
                            cell.homeDesign!.isFav = !(cell.homeDesign!.isFav)
                            self.arrHomeDesigns[indexPath.row] = cell.homeDesign!
                            
                            self.searchResultsTable.reloadRows(at: [IndexPath.init(row: indexPath.row, section: 0)], with: .none)
                            
                            updateHomeDesignsFavouritesCount(cell.homeDesign!.isFav == true)
                        }
                    }
                }
            }
        }
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let designsDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "DesignsDetailsVC") as! DesignsDetailsVC
        designsDetailsVC.isFromProfile = isFromProfile
        designsDetailsVC.isFromFavorites = isFavorites
        designsDetailsVC.designCount = arrHomeDesigns.count
        designsDetailsVC.arrHomeDesignsDetails = arrHomeDesigns
        designsDetailsVC.selectedDesignCount = indexPath.row
        self.navigationController?.pushViewController(designsDetailsVC, animated: true)
        
        
        if isFavorites {
            
            CodeManager.sharedInstance.sendScreenName (burbank_homeDesigns_favourite_homeDetail_tableCell_touch)
            designsDetailsVC.isFromFavorites = isFavorites
            designsDetailsVC.homeDesign = arrFavouriteHomeDesigns[indexPath.section][indexPath.row]
            designsDetailsVC.arrHomeDesignsDetails = arrFavouriteHomeDesigns[indexPath.section]
        }else {
            
            CodeManager.sharedInstance.sendScreenName (burbank_homeDesigns_results_homeDetail_tableCell_touch)
            
            designsDetailsVC.homeDesign = arrHomeDesigns[indexPath.row]
          
        }
        
        designsDetailsVC.displayText = self.displayText
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if isFavorites == true { return 40 }
        return 0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        
        if isFavorites == true { return 40 }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if isFavorites == true {
            
            let packages = arrFavouriteHomeDesigns[section]
            
            let viewHeader = UIView (frame: CGRect (x: 0, y: 0, width: tableView.frame.size.width, height: 60))
            
            let dataLabel = UILabel (frame: .zero)
            viewHeader.addSubview(dataLabel)
            //dataLabel Constraint
            dataLabel.translatesAutoresizingMaskIntoConstraints = false
            dataLabel.leadingAnchor.constraint(equalTo: viewHeader.leadingAnchor, constant: 16).isActive = true
            dataLabel.centerYAnchor.constraint(equalTo: viewHeader.centerYAnchor).isActive = true
            
            if packages[0].favouritedUser?.userID == kUserID {
                dataLabel.text = "Favourites list " + "(\(packages.count))"
            }else {
                
                dataLabel.text =  (packages[0].favouritedUser?.userFirstName?.capitalized ?? packages[0].favouritedUser?.userEmail ?? "") + "'s  Favourites list " + "(\(packages.count))"
            }
            
            setAppearanceFor(view: viewHeader, backgroundColor: APPCOLORS_3.DarkGrey_BG)
            
            setAppearanceFor(view: dataLabel, backgroundColor: nil, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_LABEL_SUB_HEADING (size: FONT_16))
            
            dataLabel.numberOfLines = 3
            
            return viewHeader
            
        }
        
        return UIView (frame: .zero)
        
    }
}


extension DesignsVC: ChildVCDelegate {
    
    func handleActionFor(sort: Bool, map: Bool, favourites: Bool, howWorks: Bool, reset : Bool) {
        
        if sort {
            btnSortFilter.backgroundColor = APPCOLORS_3.HeaderFooter_white_BG
            btnSortFilter.setTitleColor(APPCOLORS_3.Orange_BG, for: .normal)
        }
        
        if map {
            
        }
        if reset{
            print("------- Reset myCollection Data")
            NotificationCenter.default.post(name: NSNotification.Name("handleResetDesignsBTN"), object: nil, userInfo: nil)
            if navigationController?.viewControllers.count == 1 {
                self.tabBarController?.navigationController?.popViewController(animated: true)
            }else {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        if favourites {
            self.searchResultsTable.isScrollEnabled = false
            CodeManager.sharedInstance.sendScreenName(burbank_homeDesigns_favourite_makeFavourite_button_touch)
            
            if isFromProfileFavorites {
                
            }else {
                isFavorites = !isFavorites
                
                if isFavorites {
                    self.addBreadCrumb(from: "Favourite Designs")
                }else {
                    if let filter = displayText {
                        if filter.count > 0 {
                            self.addBreadCrumb(from: filter)
                        }else {
                            self.addBreadCrumb(from: infoStaicText)
                        }
                    }else {
                        self.addBreadCrumb(from: infoStaicText)
                    }
                }
                
                self.arrFavouriteHomeDesigns.removeAll()
                self.arrHomeDesigns.removeAll()
                
               
                
                
                if isFavorites {
                    
                  //  setAppearanceFor(view: btnMyProfile, backgroundColor: APPCOLORS_3.HeaderFooter_white_BG, textColor: APPCOLORS_3.Orange_BG, textFont: btnMyProfile.titleLabel!.font)
                    
                    getFavoriteDesigns()
                    
                }else {
                    
                   // setAppearanceFor(view: btnMyProfile, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: btnMyProfile.titleLabel!.font)
                        getCollectionDesigns (selectedFeatures ?? [])
                    self.searchResultsTable.isScrollEnabled = true
                }
                searchResultsTable.reloadData()
            }
        }
        
    }
}




//MARK: - APIs


extension DesignsVC {
    
    func getCollectionDesigns (_ selectedFeatures: [NSDictionary]) {
        
        let params = NSMutableDictionary ()
        params.setValue(kUserID, forKey: "UserId")
        params.setValue(kUserState, forKey: "StateId")
        params.setValue(1, forKey: "IncludePackages") //1 for packages
        params.setValue(0, forKey: "SortByPrice")
       // params.setValue("", forKey: "Feature")
        
        if selectedFeatures.count == 0 {
            params.setValue(nil, forKey: "newhomesjson")
        }else {
            params.setValue(selectedFeatures, forKey: "newhomesjson")
        }
//      if selectedFeatures.count == 1 { //Lot width
//        if selectedFeatures[0].value(forKey: "Answer") as? String == "I don't mind"
//        {
            params.setValue("8", forKey: "FeatureAllFilter")
//        }
//
//      }
        
        
        _ = Networking.shared.POST_request(url: ServiceAPI.shared.URL_HomeDesignDesignCount, parameters: params, userInfo: nil, success: { (json, response) in
            
            if let result: AnyObject = json {
                
                let result = result as! NSDictionary
                
                if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {
                    
                    if let nextFeature = result.value(forKey: "newHomesNextFeatures") as? NSDictionary {
                        
                        if let homeDesigns = nextFeature.value(forKey: "NewHomesList") as? [NSDictionary] {
                            
                            self.arrHomeDesigns.removeAll()
                            
                            for design in homeDesigns {
                                self.arrHomeDesigns.append (HomeDesigns (design as! [String: Any]))
                            }
                            
                            if self.arrHomeDesigns.count > 0 {
                                //                                ProfileDataManagement.shared.saveRecentSearch(params, SearchType.shared.newHomes, kUserID)
                                
                                var recent = selectedFeatures
                                let count = NSMutableDictionary ()
                                count.setValue("resultsCount", forKey: "feature")
                                count.setValue("\(self.arrHomeDesigns.count)", forKey: "Answer")
                                count.setValue("", forKey: "question")
                                
                                appDelegate.userData?.user?.userDetails?.searchCollectionCount = self.arrHomeDesigns.count
                                appDelegate.userData?.user?.userDetails?.collectionRecentSearch = recent as NSArray
                                
                                recent.append(count)
                                
                               
                                
                                ProfileDataManagement.shared.saveRecentSearch(recent, SearchType.shared.newHomes, kUserID) { (success) in
                                    if success == true {
                                        setCollectionsCount(count: self.arrHomeDesigns.count, state: kUserState)
                                    }
                                }
                                
                            }
                           
                        }
                        self.btnTotalCollectionCount.setTitle("   TOTAL \(self.arrHomeDesigns.count) DESIGNS   ", for: .normal)
                        self.setFramesForOptionsViews()
                    }
                    
                }else {
                    
                    print(log: "no data found")
                }
            }else {
                
            }
            
            self.arrHomeDesigns.count == 0 ? self.searchResultsTable.setEmptyMessage("No Designs found", bgColor: APPCOLORS_3.Body_BG) : self.searchResultsTable.setEmptyMessage("", bgColor: COLOR_CLEAR)
            
            self.searchResultsTable.reloadData()
            
        }, errorblock: { (error, isJsonError) in
            
            if isJsonError { }
            else { }
            
            self.arrHomeDesigns.count == 0 ? self.searchResultsTable.setEmptyMessage("No Designs found", bgColor: APPCOLORS_3.Body_BG) : self.searchResultsTable.setEmptyMessage("", bgColor: COLOR_CLEAR)
            
            self.searchResultsTable.reloadData()
            
            
        }, progress: nil)
        
        
    }
    
    
    
    func makeHomeDesignFavorite (_ favorite: Bool, _ design: HomeDesigns, callBack: @escaping ((_ successss: Bool) -> Void)) {
        
        let params = NSMutableDictionary()
        params.setValue(SearchType.shared.newHomes, forKey: "TypeId")
        params.setValue(appDelegate.userData?.user?.userID, forKey: "UserId")
        params.setValue(design.houseId_LandBank, forKey: "HouseId")
        params.setValue(kUserState, forKey: "StateId")
        params.setValue(favorite, forKey: "isfavourite")
        
        
        
        _ = Networking.shared.POST_request(url: ServiceAPI.shared.URL_Favorite, parameters: params, userInfo: nil, success: { (json, response) in
            
            if let result: AnyObject = json {
                
                let result = result as! NSDictionary
                
                if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {
                    
                    callBack (true)
                    
                }else { print(log: String.init(format: "Couldn't %@ home", arguments: [favorite ? "Favourite" : "Unfavourite"])) }
                
            }else {
                
                showToast(kServerErrorMessage)
            }
            
        }, errorblock: { (error, isJSONerror) in
            
            if isJSONerror {
                showToast(String.init(format: "Couldn't %@ home", arguments: [favorite ? "Favourite" : "Unfavourite"]))
            }else {
                print(log: error?.localizedDescription as Any)
                showToast(String.init(format: "Couldn't %@ home", arguments: [favorite ? "Favourite" : "Unfavourite"]))
            }
            
        }, progress: nil)
        
    }
    
    
    
    
    func getFavoriteDesigns () {
        
        let params = NSMutableDictionary()
        params.setValue(kUserID, forKey: "UserId")
        params.setValue(SearchType.shared.newHomes, forKey: "TypeId")
        params.setValue(kUserState, forKey: "StateId")
        
        
        _ = Networking.shared.POST_request(url: ServiceAPI.shared.URL_User_Favorites, parameters: params, userInfo: nil, success: { (json, response) in
            
            if let result: AnyObject = json {
                
                let result = result as! NSDictionary
                
                if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {
                    
                    var homeLandPackages = [[HomeDesigns]]()
                    
                    if let houseListData = result.value(forKey: "HouseListData") {
                        
                        if (houseListData as AnyObject).isKind(of: NSArray.self) {
                            
                            if let HouseListData = result.value(forKey: "HouseListData") as? [NSDictionary] {
                                
                                for package in HouseListData {
                                    if let searchJson = package.value(forKey: "fetchJsonRecentSearches") as? NSDictionary {
                                        let userId = (searchJson.value(forKey: "UserId") as? NSNumber ?? 0).stringValue
                                        if userId == kUserID{
                                            let useremail = String.checkNullValue (searchJson.value(forKey: "EmailId") as Any)
                                            
                                            let userName = String.checkNullValue (searchJson.value(forKey: "FullName") as Any)
                                            
                                            
                                            var favPackagesUser = [HomeDesigns] ()
                                            
                                            if let newHomesDTOs = searchJson.value(forKey: "newHomesDTOs") as? [NSDictionary] {
                                                for dict in newHomesDTOs {
                                                    
                                                    let homeLandPackage = HomeDesigns (dict as! [String : Any])
                                                    homeLandPackage.isFav = true
                                                    
                                                    homeLandPackage.favouritedUser = UserBean ()
                                                    homeLandPackage.favouritedUser?.userID = userId
                                                    homeLandPackage.favouritedUser?.userEmail = useremail
                                                    homeLandPackage.favouritedUser?.userFirstName = userName
                                                    
                                                    
                                                    if let _ = homeLandPackage.region {
                                                        
                                                        favPackagesUser.append(homeLandPackage)
                                                    }
                                                }
                                                
                                                if favPackagesUser.count > 0 {
                                                    homeLandPackages.append(favPackagesUser)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }else {
                            
                        }
                        
                        self.arrFavouriteHomeDesigns = homeLandPackages
                        
                    }else {
                        
                    }
                    
                    
                }else { print(log: "no packages found") }
                
            }else {
                
            }
            
            self.arrFavouriteHomeDesigns.count == 0 ? self.searchResultsTable.setEmptyMessage("NO SAVED DESIGNS", bgColor: APPCOLORS_3.Body_BG) : self.searchResultsTable.setEmptyMessage("", bgColor: COLOR_CLEAR)
            
            self.searchResultsTable.reloadData()
            self.searchResultsTable.isScrollEnabled = true
            
            if self.arrFavouriteHomeDesigns.count > 0 {
                for item in self.arrFavouriteHomeDesigns {
                    if item[0].favouritedUser?.userID == kUserID {
                        
                        setHomeDesignsFavouritesCount(count: item.count, state: kUserState)
                    }
                }
            }else {
                setHomeDesignsFavouritesCount(count: 0, state: kUserState)
            }
            
            
        }, errorblock: { (error, isJSONerror)  in
            
            if isJSONerror {
                
            }else {
                
            }
            
            self.searchResultsTable.reloadData()
            self.searchResultsTable.isScrollEnabled = true
            
        }, progress: nil)
    }
    
    
}
