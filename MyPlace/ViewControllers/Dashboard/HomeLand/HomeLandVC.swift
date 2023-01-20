//
//  HomeLandVC.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 08/05/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import GoogleMaps
import GoogleMapsUtils


class HomeLandVC: HeaderVC {
    
    
    @IBOutlet weak var favoritesHeaderView: UIView!
    @IBOutlet weak var searchResultsView : UIView!
    @IBOutlet weak var homeMapView : UIView!
    
    
    @IBOutlet weak var searchResultsTable : UITableView!
    @IBOutlet weak var mapResultsTable : UITableView!

    @IBOutlet weak var mapResultsTableHeight : NSLayoutConstraint!

    
    @IBOutlet weak var favouritesHeaderHightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mapViewGoogle : MyPlaceMap!
    
    private var clusterManager: GMUClusterManager!

    
    var selectedMarker : MyPlaceMarker?

    
    
//    @IBOutlet weak var mapView : MKMapView!
//    let locationManager = CLLocationManager()
    
    
    @IBOutlet weak var containerViewMarkerInfo : UIView!
    @IBOutlet weak var containerViewHomelandPopUpVc : UIView!

    
    
    var markerInfoVC: MarkerInfoVC?
    var homelandPopUpVc: HomeLandPopupVC?

    

    var isFromProfileFavorites: Bool = false

    
    
    var online: Bool = true
    var isFavoritesService: Bool = false

    var loadingPackagesService = false
    

    var isFromHomeDesigns: Bool = false
    var design: HomeDesigns?

    
    
    //MARK: - myPlaceQuiz
        

    var myPlaceQuiz: MyPlaceQuiz?
    
    var arrHomeLand = [HomeLandPackage]()
    var arrHomeLandMapTable = [HomeLandPackage]()
    
    var arrFavouritePackages = [[HomeLandPackage]]()
  
    var arrRegions: [RegionMyPlace]?
    
    
    var pageSize = 50
    var page = 1
    
    
    //MARK: - ViewLife Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //        headerLogoImage = IMAGE_HOMELAND
       
        isFromProfile = true
        
        pageUISetup ()
        
        if btnBack.isHidden {
            showBackButton()
            //            hideBackButton()
            btnBack.addTarget(self, action: #selector(handleBackButton(_:)), for: .touchUpInside)
            btnBackFull.addTarget(self, action: #selector(handleBackButton(_:)), for: .touchUpInside)
        }
        
        
        if isFromProfileFavorites {

//                      addHeaderOptions(sort: false, map: false, favourites: true, howWorks: false, delegate: self)
            
            if isFromHomeDesigns { }
            else {
                loadPackages()
            }
            self.favouritesHeaderHightConstraint.constant = 50
            headerLogoText = "MyFavourites"
            favoritesHeaderView.isHidden = false
            addHeaderOptions(sort: false, map: false, favourites: true, howWorks: false, delegate: self)
        }else {
            self.favouritesHeaderHightConstraint.constant = 0
            favoritesHeaderView.isHidden = true
            headerLogoText = "House&Land"
            if isFromHomeDesigns {
                
                addHeaderOptions(sort: false, map: false, favourites: true, howWorks: false, delegate: self)
                
                self.searchResultsTable.reloadData()
            }else {
                
                addHeaderOptions(sort: true, map: true, favourites: true, howWorks: false, delegate: self)
                
                loadPackages()
            }
        }
        
        if isFavoritesService {
            CodeManager.sharedInstance.sendScreenName(burbank_homeAndLand_favourite_screen_loading)
        }else {
            CodeManager.sharedInstance.sendScreenName(burbank_homeAndLand_results_screen_loading)
        }
        
        
        containerViewMarkerInfo.isHidden = true
        containerViewHomelandPopUpVc.isHidden = true
        
        setUpClustering ()        
        self.filter.searchType = SearchType.shared.homeLand
        if #available(iOS 15.0, *) {
            searchResultsTable.sectionHeaderTopPadding = 0.0
        } else {
            // Fallback on earlier versions
        }
        searchResultsTable.tableFooterView = UIView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let filter = myPlaceQuiz {
            dataFromFilter()
            self.addBreadCrumb(from: filter.filterStringDisplayHomes())
//            self.labelInfo.text = filter.filterStringDisplayHomes()
            
            if isFavoritesService {
                self.addBreadCrumb(from: "Favourite Packages")
//                self.labelInfo.text = "Favourite Packages".uppercased()
            }
        }
        
        
        if isFromHomeDesigns {
            
            if let houseName = self.design?.houseName {
                if houseName.count > 0 {
                    self.addBreadCrumb(from: houseName + " " + (self.design?.houseSize ?? ""))
//                    self.labelInfo.text = houseName
                }
            }
            
        }else {
            if isFavoritesService {
                
              //  setAppearanceFor(view: btnMyProfile, backgroundColor: APPCOLORS_3.HeaderFooter_white_BG, textColor: APPCOLORS_3.Orange_BG, textFont: btnMyProfile.titleLabel!.font)
                
                loadFavoritePackagesList ()
                
                btnMap.isHidden = true
                btnSortFilter.isHidden = true
            }
        }
        searchResultsTable.reloadData ()
        
    }
    
    
    
    //MARK: - View
    
    func pageUISetup () {
        
        mapSetup ()
        
        searchResultsView.isHidden = false
        
        
        homeMapView.isHidden = true
        btnMap.setTitle("     MAP     ", for: .normal)

        mapResultsTable.isHidden = true
    }
    
    func setUpClustering () {
        
        let iconGenerator = GMUDefaultClusterIconGenerator (buckets: [100], backgroundImages: [UIImage (named: "Ico-LocationDot")!])
        
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapViewGoogle, clusterIconGenerator: iconGenerator)
        renderer.delegate = self
        
        clusterManager = GMUClusterManager(map: mapViewGoogle, algorithm: algorithm, renderer: renderer)

        
        // Generate and add random items to the cluster manager.
//        generateClusterItems ()

        // Call cluster() after items have been added to perform the clustering
        // and rendering on map.
//        clusterManager.cluster()
        
        
        clusterManager.setDelegate(self, mapDelegate: self)
    }
    
    
    private func generateClusterItems() {
        let extent = 0.002
        
        if arrHomeLand.count > 0 {
            
            let package = arrHomeLand[0]
            let list = arrHomeLand.filter { $0.latitude != "" }
            print(list[0])
            self.mapViewGoogle.setMapPosition(with: list[0])
            
            
            for index in 0...arrHomeLand.count-1 {
                
                let homeLand = arrHomeLand[index]
                
                if let latLangs = homeLand.latitude {
                    if latLangs.count > 0 {
                        let lat = (latLangs as NSString).doubleValue + extent * randomScale()
                        let lng = (homeLand.longitude! as NSString).doubleValue + extent * randomScale()
                        let name = "Item \(index)"
                        let item = POIItem(position: CLLocationCoordinate2DMake(lat, lng), name: name, package: homeLand)
                                                
                        clusterManager.add (item)
                    }
                }
            }
            
            clusterManager.cluster()
        }
    }

    /// Returns a random value between -1.0 and 1.0.
    private func randomScale() -> Double {
        return Double(arc4random()) / Double(UINT32_MAX) * 2.0 - 1.0
    }
    
    
    
       
    //MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "markerPopUp" {
        
            markerInfoVC = segue.destination as? MarkerInfoVC
            
            
            markerInfoVC?.detailViewAction = { (package) in
                                
                let homeDetailView = self.storyboard?.instantiateViewController(withIdentifier: "HomeLandDetailsVC") as! HomeLandDetailsVC
                homeDetailView.myPlaceQuiz = self.myPlaceQuiz
                
                self.navigationController?.pushViewController(homeDetailView, animated: true)
                                
                homeDetailView.homeLand = package
                
                
                self.containerViewMarkerInfo.isHidden = true
                self.view.sendSubviewToBack (self.containerViewMarkerInfo)
                
                self.makeAllMarkersasUnSelected ()
            }
            
            markerInfoVC?.dismissAction = {
                
                self.containerViewMarkerInfo.isHidden = true
                self.view.sendSubviewToBack (self.containerViewMarkerInfo)
                
                self.makeAllMarkersasUnSelected ()
            }
            
        }else if segue.identifier == "popupcluster" {
            
            homelandPopUpVc = segue.destination as? HomeLandPopupVC
            
            homelandPopUpVc?.selectedPackage = { (package) in
                
                if let pack = package {
                    
                    let homeDetailView = self.storyboard?.instantiateViewController(withIdentifier: "HomeLandDetailsVC") as! HomeLandDetailsVC
                    homeDetailView.myPlaceQuiz = self.myPlaceQuiz
                    
                    self.navigationController?.pushViewController(homeDetailView, animated: true)
                    
                    homeDetailView.homeLand = pack
                }else {
                    CodeManager.sharedInstance.sendScreenName(burbank_homeAndLand_map_cluster_close_button_touch)
                }
                
                self.homelandPopUpVc?.arrHomeLandPackages.removeAll()
                self.homelandPopUpVc?.tableViewHomeLandPopup.reloadData()
                self.homelandPopUpVc?.tableViewHomeLandPopupHeight.constant = 0
                
                self.containerViewHomelandPopUpVc.isHidden = true
                
                self.homelandPopUpVc?.setHeading ()
                
                self.view.sendSubviewToBack (self.containerViewHomelandPopUpVc)
                    
                self.makeAllMarkersasUnSelected ()
            }
        }
        
    }
    
    
    //MARK: - Button Actions
    
    
    @IBAction func handleBackButton (_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func dataFromFilter () {
        
        let sortfilter = filter
        
        if sortfilter.region.regionName.count > 0 {
            let regionsArr =  sortfilter.regionsArr.map{ $0.regionName }
            print("----1-1-1-1-1,",regionsArr)
            let regions = regionsArr.joined(separator: ",")
            print("----1-1-1-1-1,",regions)
                    
            if sortfilter.regionsArr.count == arrRegions?.count{
                myPlaceQuiz?.region = "All regions"
            }else{
                myPlaceQuiz?.region = regions
            }
            
          //  myPlaceQuiz?.region = sortfilter.regionsArr
        }
        
        if sortfilter.storeysCount == .one {
            
            myPlaceQuiz!.storeysCount = "SINGLE"
        }else if sortfilter.storeysCount == .two {
            
            myPlaceQuiz!.storeysCount = "DOUBLE"
        }else {
            
            myPlaceQuiz!.storeysCount = ""
        }
        
        
        
        if sortfilter.bedRoomsCount == .three /*|| sortfilter.bedRoomsCount == .ALL */{
            
            myPlaceQuiz!.bedRoomCount = "3 BED"
        }else if sortfilter.bedRoomsCount == .four {
            
            myPlaceQuiz!.bedRoomCount = "4 BED"
        }else if sortfilter.bedRoomsCount == .five {
            
            myPlaceQuiz!.bedRoomCount = "5+ BED"
        }
        
        
        myPlaceQuiz!.priceRangeLow = "$\(sortfilter.priceRange.priceStartStringValue)K"
        myPlaceQuiz!.priceRangeHigh = "$\(sortfilter.priceRange.priceEndStringValue)K"
        
        quizPriceMinimumValue = sortfilter.priceRange.priceStartStringValue
        quizPriceMaximumValue = sortfilter.priceRange.priceEndStringValue
              
        self.addBreadCrumb(from: myPlaceQuiz!.filterStringDisplayHomes())
//        self.labelInfo.text = myPlaceQuiz!.filterStringDisplayHomes()

    }

}


extension HomeLandVC: ChildVCDelegate {
    
    //MARK: Handling of Breadcrumb Buttons
    
    
    func handleActionFor(sort: Bool, map: Bool, favourites: Bool, howWorks: Bool, reset : Bool) {
        
        if sort {
            CodeManager.sharedInstance.sendScreenName(burbank_homeAndLand_results_sortFilter_button_touch)
            setAppearanceFor(view: btnSortFilter, backgroundColor: APPCOLORS_3.HeaderFooter_white_BG, textColor: APPCOLORS_3.Orange_BG, textFont: btnSortFilter.titleLabel!.font)
            homeMapView.isHidden = true
            btnMap.setTitle("     MAP     ", for: .normal)
            searchResultsView.isHidden = false
            self.arrHomeLand.removeAll()
            defer {
                self.searchResultsTable.reloadData()
            }
            if online {
                self.page = 1
                self.dataFromFilter()
                loadPackages ()
            }
        }
        
        if map {
            
            CodeManager.sharedInstance.sendScreenName(burbank_homeAndLand_results_map_button_touch)
            if btnMap.titleLabel?.text?.trim() == "MAP" {
                homeMapView.isHidden = false
                searchResultsView.isHidden = true
                btnMap.setTitle("     LIST     ", for: .normal)
                mapViewGoogle.layoutIfNeeded()
                clusterManager.clearItems()
                self.generateClusterItems ()
                
            }else {
                CodeManager.sharedInstance.sendScreenName(burbank_homeAndLand_map_screen_loading)
                homeMapView.isHidden = true
                searchResultsView.isHidden = false
                searchResultsTable.reloadData()
                btnMap.setTitle("     MAP     ", for: .normal)
                mapViewGoogle.removeAllMarkers()
                clusterManager.clearItems()
                
            }
            
        }
        
        if favourites {
            self.searchResultsTable.isScrollEnabled = false
            if isFromProfileFavorites {
                
                
            }else {
                
                isFavoritesService = !isFavoritesService
                
                if isFavoritesService {
                    self.addBreadCrumb(from: "Favourite Packages")
//                    self.labelInfo.text = "Favourite Packages".uppercased()
                }else {
                    if let filter = myPlaceQuiz {
                        self.addBreadCrumb(from: filter.filterStringDisplayHomes())
//                        self.labelInfo.text = filter.filterStringDisplayHomes()
                    }
                }
                
                if isFavoritesService {
                   // setAppearanceFor(view: btnMyProfile, backgroundColor: APPCOLORS_3.HeaderFooter_white_BG, textColor: APPCOLORS_3.Orange_BG, textFont: btnMyProfile.titleLabel!.font)
                    
                    loadFavoritePackagesList ()
                    
                    self.searchResultsTable.reloadData()
                    btnMap.isHidden = true
                    btnSortFilter.isHidden = true
                    
                }else {
                    
                    btnMap.isHidden = false
                    btnSortFilter.isHidden = false

                    
                  //  setAppearanceFor(view: btnMyProfile, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: btnMyProfile.titleLabel!.font)
                    
                    if isFromHomeDesigns {
                        
                        self.searchResultsTable.reloadData()
                        
                    }else {
                        page = 1
                        loadPackages()
                    }
                }
                
                homeMapView.isHidden = true
                btnMap.setTitle("     MAP     ", for: .normal)

                searchResultsView.isHidden = false
                self.searchResultsTable.isScrollEnabled = true
            }
           
        }
    }
}



extension HomeLandVC: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if isFavoritesService == true { return arrFavouritePackages.count }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == searchResultsTable {
            if isFavoritesService == true { return arrFavouritePackages[section].count }
            return arrHomeLand.count
        }
        else {
            return arrHomeLandMapTable.count
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
//        print(log: "willDisplay indexpath: " + "\(indexPath.row)")
        
        let cell = cell as! HomeLandTVCell
        
      //  cell.imageHouseHeight.constant = cell.frame.size.height - 20
        
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
//        print(log: "didEndDisplaying indexpath: " + "\(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == searchResultsTable {
            
//            print(log: "cellForRowAt indexpath: " + "\(indexPath.row)")
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeLandTVCell", for: indexPath) as! HomeLandTVCell
            
            // Configure the cell...
            cell.selectionStyle = .none
            
            if isFavoritesService == true {
                
                let package = arrFavouritePackages[indexPath.section][indexPath.row]
                cell.homeLand = package
                
                cell.btnFavorite.isHidden = package.favouritedUser?.userID != kUserID
                
            }else {
                
                cell.homeLand = arrHomeLand[indexPath.row]
            }

            /*
            if Int(kUserID)! > 0 { print(log: kUserID) }
            else {
                cell.btnFavorite.isHidden = true
            }*/
            cell.favoriteAction = {
                if noNeedofGuestUserToast(self, message: "Please login to add favourites") {
                    
                    if self.isFavoritesService {
                        CodeManager.sharedInstance.sendScreenName(burbank_homeAndLand_favourite_makeFavourite_button_touch)
                    }else {
                        CodeManager.sharedInstance.sendScreenName(burbank_homeAndLand_results_makeFavourite_button_touch)
                    }
                    
                    self.makeHomeLandFavorite(!(cell.homeLand!.isFav), cell.homeLand!) { (success) in
                        if success {
                            
                            if (!(cell.homeLand!.isFav) == true) {
                                DispatchQueue.main.async(execute: {
                                    ActivityManager.showToast("Added to your favourites", self)
                                })
                            }else{
                                DispatchQueue.main.async(execute: {
                                    ActivityManager.showToast("Item removed from favourites", self)
                                })

                             }
                            
                            var updateDefaults = false
                            
                            if cell.homeLand!.favouritedUser?.userID == kUserID {
                                updateDefaults = true
                            }
                            
                            
                            if self.isFavoritesService {
                                
                                var arr = self.arrFavouritePackages[indexPath.section]
                                arr.remove(at: indexPath.row)
               
                                if arr.count == 0 {
                                    self.arrFavouritePackages.remove(at: indexPath.section)
                                    
                                    if updateDefaults {
                                        setHomeLandFavouritesCount(count: 0, state: kUserState)
                                    }
                                    
                                }else {
                                    self.arrFavouritePackages[indexPath.section] = arr
                                    
                                    if updateDefaults {
                                        setHomeLandFavouritesCount(count: arr.count, state: kUserState)
                                    }
                                }
                                
                                self.arrFavouritePackages.count == 0 ? self.searchResultsTable.setEmptyMessage("No Favourite Packages found", bgColor: APPCOLORS_3.Body_BG) : self.searchResultsTable.setEmptyMessage("", bgColor: COLOR_CLEAR)
                                
                                self.searchResultsTable.reloadData ()
                                
                            }else {
                                
                                cell.homeLand!.isFav = !(cell.homeLand!.isFav)
                                self.arrHomeLand[indexPath.row] = cell.homeLand!
                                
                                self.searchResultsTable.reloadRows(at: [IndexPath.init(row: indexPath.row, section: 0)], with: .none)
                                
                                
                                //                            if updateDefaults {
                                updateHomeLandFavouritesCount(cell.homeLand!.isFav == true)
                                //                            }
                                
                            }
                        }
                    }
                }
            }
            print(log: "indexpath \(indexPath.row), arraycount \(arrHomeLand.count)")
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeLandTVCell", for: indexPath) as! HomeLandTVCell
            
            // Configure the cell...
            cell.selectionStyle = .none
            
            if Int(kUserID)! > 0 { }
            else {
                cell.btnFavorite.isHidden = true
            }
            
            //            setShadow(view: cell.contentView, color: APPCOLORS_3.GreyTextFont, shadowRadius: 10.0)
            
            setBorder(view: cell, color: APPCOLORS_3.GreyTextFont, width: 0.5)
            
            cell.homeLand = arrHomeLandMapTable[indexPath.row]
            
            if indexPath.row == arrHomeLandMapTable.count - 1 {
                
                cell.layer.borderWidth = 0.0
                cell.backgroundColor = APPCOLORS_3.HeaderFooter_white_BG
            }else {
                
                cell.backgroundColor = APPCOLORS_3.Body_BG
            }
            
            
            cell.favoriteAction = {
                
                self.makeHomeLandFavorite(!(cell.homeLand!.isFav), cell.homeLand!) { (success) in
                    if success {
                        
                        if (!(cell.homeLand!.isFav) == true) {
                            DispatchQueue.main.async(execute: {
                                ActivityManager.showToast("Added to your favourites", self)
                            })
                        }
                        
                        cell.homeLand!.isFav = !(cell.homeLand!.isFav)
                        self.arrHomeLandMapTable[indexPath.row] = cell.homeLand!
                        
                        self.mapResultsTable.reloadRows(at: [indexPath], with: .none)
                    }
                }
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isFavoritesService {
            CodeManager.sharedInstance.sendScreenName(burbank_homeAndLand_favourite_homeDetail_tableCell_touch)
        }else {
            CodeManager.sharedInstance.sendScreenName(burbank_homeAndLand_results_homeDetail_tableCell_touch)
        }
        
        if tableView == searchResultsTable {
            
            let homeDetailView = self.storyboard?.instantiateViewController(withIdentifier: "HomeLandDetailsVC") as! HomeLandDetailsVC
            homeDetailView.myPlaceQuiz = myPlaceQuiz
            homeDetailView.isFromFavorites = isFavoritesService
            homeDetailView.isFromProfile = isFromProfile
            homeDetailView.isFromHomeDesigns = isFromHomeDesigns
            homeDetailView.design = self.design
            
            self.navigationController?.pushViewController(homeDetailView, animated: true)
            
            
            if isFavoritesService == true {
                
                homeDetailView.homeLand = arrFavouritePackages[indexPath.section][indexPath.row]
            }else {
                
                homeDetailView.homeLand = arrHomeLand[indexPath.row]
            }
            
        }else {
            
            if indexPath.row == arrHomeLandMapTable.count - 1 {
                
                let homeDetailView = self.storyboard?.instantiateViewController(withIdentifier: "HomeLandDetailsVC") as! HomeLandDetailsVC
                homeDetailView.myPlaceQuiz = myPlaceQuiz
                
                self.navigationController?.pushViewController(homeDetailView, animated: true)
            }else {
                
                let homeLandobj = arrHomeLandMapTable[indexPath.row]
                let homeLandobjLast = arrHomeLandMapTable.last
                arrHomeLandMapTable[indexPath.row] = homeLandobjLast!
                arrHomeLandMapTable[arrHomeLandMapTable.count - 1] = homeLandobj
                
                tableView.reloadData()
                
//                tableView.reloadRows(at: [indexPath, IndexPath(item: arrHomeLandMapTable.count - 1, section: 0)], with: .fade)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == searchResultsTable {
            
            return UITableView.automaticDimension //110
        }else {
            
            return arrHomeLandMapTable.count-1 == indexPath.row ? UITableView.automaticDimension : 10
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == searchResultsTable {
            
            return 90
        }else {
            
            return arrHomeLandMapTable.count-1 == indexPath.row ? 100 : 10
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if isFavoritesService == true { return 40 }
        return 0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        
        if isFavoritesService == true { return 40 }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if isFavoritesService == true {
            
            let packages = arrFavouritePackages[section]
            
            let viewHeader = UIView (frame: CGRect (x: 0, y: 0, width: tableView.frame.size.width, height: 60))
            
            let dataLabel = UILabel (frame: .zero)
            viewHeader.addSubview(dataLabel)
            //dataLabel Constraint
            dataLabel.translatesAutoresizingMaskIntoConstraints = false
            dataLabel.leadingAnchor.constraint(equalTo: viewHeader.leadingAnchor, constant: 16).isActive = true
            dataLabel.centerYAnchor.constraint(equalTo: viewHeader.centerYAnchor).isActive = true
            
            if packages[0].favouritedUser?.userID == kUserID {
                dataLabel.text = "My Favourites list " + "(\(packages.count))"
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
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if let _ = self.design {

        }else if isFromHomeDesigns {
            
        }else {
            if scrollView == searchResultsTable {
                if ((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height) , !loadingPackagesService {
                    
                    self.loadingPackagesService = true
                    self.loadPackages()
                }
            }
        }
    }
    
}


extension HomeLandVC: GMSMapViewDelegate, UIPopoverPresentationControllerDelegate, GMUClusterManagerDelegate, GMUClusterRendererDelegate {
    
    func renderer(_ renderer: GMUClusterRenderer, markerFor object: Any) -> GMSMarker? {
        
        if (object as AnyObject).isKind(of: POIItem.self) {
//        if (object as AnyObject).isKind(of: HomeLandPackage.self) {
            
            let markerMyPlace = MyPlaceMarker (package: (object as! POIItem).homeLandPackage)
            
            return markerMyPlace
        }
        
        return nil
    }
    
    func renderer(_ renderer: GMUClusterRenderer, willRenderMarker marker: GMSMarker) {
        
        print ("willRenderMarker")
    }
    
    func renderer(_ renderer: GMUClusterRenderer, didRenderMarker marker: GMSMarker) {
        
        print("didRenderMarker \(marker)")
    }
    
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        if marker.isKind(of: MyPlaceMarker.self) {
            
            CodeManager.sharedInstance.sendScreenName(burbank_homeAndLand_map_markers_button_touch)
            
            print(log: "zoomLevel \((mapView as! MyPlaceMap).zoomLevel)")
            
            makeAllMarkersasUnSelected ()
            
            selectedMarker = marker as? MyPlaceMarker
            selectedMarker?.selected = true
            
            
            let package = (marker as! MyPlaceMarker).homeLandPackage!
            
//            mapView.camera = GMSCameraPosition (target: CLLocationCoordinate2D (latitude: (package.latitude! as NSString).doubleValue, longitude: (package.longitude! as NSString).doubleValue ), zoom: (mapView as! MyPlaceMap).camera.zoom)
//
////            zoomLevel
//
//            markerInfoVC?.fillDetails(with: package)
//
//            containerViewMarkerInfo.isHidden = false
//            view.bringSubviewToFront(containerViewMarkerInfo)
                        
            
            self.homelandPopUpVc?.arrHomeLandPackages.removeAll()
            self.homelandPopUpVc?.arrHomeLandPackages.append (package)
            
                                    
            self.homelandPopUpVc?.tableViewHomeLandPopup.reloadData()
            self.homelandPopUpVc?.tableViewHomeLandPopup.layoutIfNeeded()
            self.homelandPopUpVc?.view.updateConstraints()
            
            self.containerViewHomelandPopUpVc.isHidden = false
            
            self.view.bringSubviewToFront(self.containerViewHomelandPopUpVc)
            
            
            self.homelandPopUpVc?.setHeading ()
            
            
            
//            mapResultsTable.isHidden = true
//            mapResultsTableHeight.constant = 0
//            arrHomeLandMapTable.removeAll()
//
//            mapResultsTable.reloadData()
            
        }else if let cluster = marker.userData as? GMUStaticCluster {
                        
            CodeManager.sharedInstance.sendScreenName(burbank_homeAndLand_map_cluster_button_touch)
            
            self.homelandPopUpVc?.arrHomeLandPackages.removeAll()
            
            for item in cluster.items as! [POIItem] {
                
                self.homelandPopUpVc?.arrHomeLandPackages.append (item.homeLandPackage)
            }
                                    
            self.homelandPopUpVc?.tableViewHomeLandPopup.reloadData()
            self.homelandPopUpVc?.tableViewHomeLandPopup.layoutIfNeeded()
            self.homelandPopUpVc?.view.updateConstraints()
            
            self.containerViewHomelandPopUpVc.isHidden = false
            
            self.view.bringSubviewToFront(self.containerViewHomelandPopUpVc)
            
            
            self.homelandPopUpVc?.setHeading ()

            
            
            //            arrHomeLandMapTable.removeAll()
            //
            //            for item in cluster.items as! [POIItem] {
            //
            //                arrHomeLandMapTable.append (item.homeLandPackage)
            //            }
            

//            mapResultsTable.isHidden = false
//
//            mapResultsTable.reloadData()
//
//
//            if arrHomeLandMapTable.count > 0 {
//                mapResultsTableHeight.constant = 150
//            }else {
//                mapResultsTableHeight.constant = 0
//            }
            
        }
        
        
        
        
        //        let homeDetailView = self.storyboard?.instantiateViewController(withIdentifier: "HomeLandDetailsVC") as! HomeLandDetailsVC
        //        homeDetailView.myPlaceQuiz = myPlaceQuiz
        //
        //        self.navigationController?.pushViewController(homeDetailView, animated: true)
        //
        //        homeDetailView.homeLand = (marker as! MyPlaceMarker).homeLandPackage!
        
        //        let infoView = MarkerPopupView (frame: CGRect (x: 15, y: 0, width: SCREEN_WIDTH-30, height: 200))
        //
        //        mapView.addSubview(infoView)
        
        return true
    }
    

    private func clusterManager(clusterManager: GMUClusterManager, didTapCluster cluster: GMUCluster) {
        
        print("cluster tap")
        
//        let newCamera = GMSCameraPosition.cameraWithTarget(cluster.position, zoom: mapView.camera.zoom + 1)
//        let update = GMSCameraUpdate.setCamera(newCamera)
//        mapView.moveCamera(update)
      }


    
    func makeAllMarkersasUnSelected () {
        
        if let marker = selectedMarker {
            
            marker.selected = false
        }
        
//        for marker in mapViewGoogle.allMarkers {
//            marker.selected = false
//        }
        
    }
    
    
    
//    // mapview delegate methods
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
//
//        mapView.mapType = MKMapType.standard
//
//        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//        let region = MKCoordinateRegion(center: locValue, span: span)
//        mapView.setRegion(region, animated: true)
//
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = locValue
//        annotation.title = "Burbank"
//        annotation.subtitle = "current location"
//        mapView.addAnnotation(annotation)
//
//        //centerMap(locValue)
//    }
//    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
//    {
//        print(log: "Error \(error)")
//    }
//
//    //Annotation tap event delegate method
//    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
//    {
//        if let annotationTitle = view.annotation?.title
//        {
//            print(log: "User tapped on annotation with title: \(annotationTitle!)")
//            mapResultsTable.isHidden = false
//        }
//    }
//    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
//        if let annotationTitle = view.annotation?.title
//        {
//            print(log: "User deselect on annotation with title: \(annotationTitle!)")
//            mapResultsTable.isHidden = true
//        }
//    }
}




extension HomeLandVC {
    
    func mapSetup () {
        
        mapViewGoogle.addZoomLevelButtons ()
        mapViewGoogle.setMapPosition (with: self.filter.region)
        
        
//        self.locationManager.requestAlwaysAuthorization()
//
//        // For use in foreground
//        self.locationManager.requestWhenInUseAuthorization()
//
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager.startUpdatingLocation()
//        }
//
//        mapView.delegate = self
//        mapView.mapType = .standard
//        mapView.isZoomEnabled = true
//        mapView.isScrollEnabled = true
//
//        if let coor = mapView.userLocation.location?.coordinate{
//            mapView.setCenter(coor, animated: true)
//        }
        
    }
    
    
    //MARK: - APIs
    
    func getDefaultPriceRanges (stateId: String, region: RegionMyPlace) {
        
        let filt = SortFilter ()
        filt.region = region
        
        _ = DashboardDataManagement.shared.getHomeLandFilterValues(with: filt) { (filterNew) in
            
            self.filter.defaultPriceRange = filterNew.defaultPriceRange

            if self.filter.priceRange.priceStart == 0 || self.filter.priceRange.priceEnd == 1 {
                
                self.filter.priceRange = filterNew.priceRange
                
                self.filter.priceRange.totalCount = filterNew.priceRange.totalCount
                self.filter.priceRange.priceRangeCounts = filterNew.priceRange.priceRangeCounts
                
            }
        }
        
    }
    
    
    func loadPackages () {
        
        if isFavoritesService {
            
            loadFavoritePackagesList ()
            return
        }
        
        if online {
            
            self.loadingPackagesService = true

            
            if page == 1 {
                self.arrHomeLand.removeAll()
                self.searchResultsTable.reloadData()
            }
            
            DashboardDataManagement.shared.getHomeLandPackagesWithFilterValues(with: self.filter, page) { (packages) in
                
//            }
//            DashboardDataManagement.shared.packagesWith(Int(kUserState)!, page, filter: self.filter /*self.myPlaceQuiz?.sortfilter ?? SortFilter()*/) { (packages) in
                
                self.loadingPackagesService = false
                
                if let packages2 = packages {
                    
                    if self.page == 1 {
                        self.arrHomeLand.removeAll()
                    }
                    
                    self.arrHomeLand.append(contentsOf: packages2)
                    
                    if packages2.count > 0 {
                        
                        self.page = self.page + 1
                        self.searchResultsTable.reloadData()
                    }else {
                        if self.page > 1 { showToast("No more packages to load", self) }
                    }
                }
                
                self.arrHomeLand.count == 0 ? self.searchResultsTable.setEmptyMessage("No Packages found", bgColor: APPCOLORS_3.Body_BG) : self.searchResultsTable.setEmptyMessage("", bgColor: COLOR_CLEAR)
                
            }
            
        }else {
            
            if page == 1 {
                page = 0
                self.arrHomeLand.removeAll()
                self.searchResultsTable.reloadData()
            }
            
            
            MyPlacePackages.fetchPackages(page: page, limit: pageSize) { (packages) in
                
                self.loadingPackagesService = false
                
                if let homelandPackegs = packages {
                    if homelandPackegs.count > 0 {
                        arrHomeLand.append(contentsOf: homelandPackegs)
                    }
                }
                
                if arrHomeLand.count == 0 {
                    
                    if NetworkingManager.shared.arrayPackagesTasks.count > 0 {
                        
                        for packgesDataTask: Any in NetworkingManager.shared.arrayPackagesTasks {
                            if (packgesDataTask as! URLSessionDataTask).state == .running {
                                (packgesDataTask as! URLSessionDataTask).cancel()
                            }
                        }
                        
                        NetworkingManager.shared.arrayPackagesTasks.removeAllObjects()
                    }
                    
                    showActivityFor(view: view)
                    
                    DashboardDataManagement.shared.getAllPackages(Int(kUserState)!, true) { (objects) in
                        
                        hideActivityFor(view: self.view)
                        
                        self.loadingPackagesService = false
                        
                        if let packages2 = objects {
                            self.arrHomeLand.append(contentsOf: packages2)
                            
                            self.page = self.page + 1
                        }
                        self.reloadTable()
                    }
                }else {
                    
                    page = page + 1
                    self.reloadTable()
                }
            }
        }
    }
    
    
//    func loadSortFilterResults () {
//
//        if online {
//
//            if page == 1 {
//                self.arrHomeLand.removeAll()
//                self.searchResultsTable.reloadData()
//            }
//
//
//            DashboardDataManagement.shared.getHomeLandPackagesForSortFilter(with: self.filter, page) { (packages) in
//
//                //            }
//                //            DashboardDataManagement.shared.packagesWith(Int(kUserState)!, page, filter: self.filter /*self.myPlaceQuiz?.sortfilter ?? SortFilter()*/) { (packages) in
//
//                self.loadingPackagesService = false
//
//                if let packages2 = packages {
//
//                    self.arrHomeLand.append(contentsOf: packages2)
//
//                    if packages2.count > 0 {
//                        self.page = self.page + 1
//                        self.searchResultsTable.reloadData()
//                    }else {
//                        if self.page > 1 { showToast("No more packages to load", self) }
//                    }
//                }
//
//                self.arrHomeLand.count == 0 ? self.searchResultsTable.setEmptyMessage("No Packages found", bgColor: APPCOLORS_3.Body_BG) : self.searchResultsTable.setEmptyMessage("", bgColor: COLOR_CLEAR)
//
//            }
//
//        }
//    }
    
    
    func reloadTable () {
        
        if page == 1 {
            UIView.animate(withDuration: 0.1, animations: {
                self.searchResultsTable.reloadData()
            }) { (completed) in
                self.searchResultsTable.reloadData()
            }
        }else {
            self.searchResultsTable.reloadData()
        }
        
    }
    
    
    func loadFavoritePackagesList () {
        
//        let params: NSMutableDictionary = filter.serviceModal()
        let params = NSMutableDictionary()
        params.setValue(kUserID, forKey: "UserId")
        params.setValue(SearchType.shared.homeLand, forKey: "TypeId")
        params.setValue(kUserState, forKey: "StateId")
//        params.setValue(NSArray(), forKey: "ListHouses")
            
        
//        self.arrHomeLand.removeAll()
//        self.searchResultsTable.reloadData()

        
        _ = Networking.shared.POST_request(url: ServiceAPI.shared.URL_User_Favorites, parameters: params, userInfo: nil, success: { (json, response) in
            
            if let result: AnyObject = json {
                
                let result = result as! NSDictionary
                
                if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {
                    
                    var homeLandPackages = [[HomeLandPackage]]()
                    
                    if let houseListData = result.value(forKey: "HouseListData") {
                        
                        if (houseListData as AnyObject).isKind(of: NSArray.self) {
                            
                            for package: NSDictionary in result.value(forKey: "HouseListData") as! [NSDictionary] {
                                
                                let searchJson = package.value(forKey: "fetchJsonRecentSearches") as! NSDictionary
                                
                                let useremail = String.checkNullValue (searchJson.value(forKey: "EmailId") as Any)
                                let userId = (searchJson.value(forKey: "UserId") as? NSNumber ?? 0).stringValue
                                let userName = String.checkNullValue (searchJson.value(forKey: "FullName") as Any)
                                
                                
                                var favPackagesUser = [HomeLandPackage] ()
                                
                                for dict in searchJson.value(forKey: "homeAndLandDTOs") as! [NSDictionary] {
                                    
                                    let homeLandPackage = HomeLandPackage(dict as! [String : Any])
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
                            
                            
                            
                        }else {
                            
                        }
                        
                        self.arrFavouritePackages = homeLandPackages
                        
                        if self.arrFavouritePackages.count > 0 {
                            for item in self.arrFavouritePackages {
                                if item[0].favouritedUser?.userID == kUserID {
                                    setHomeLandFavouritesCount(count: item.count, state: kUserState)
                                    break
                                }
                            }
                        }
                        
                    }else {
                        
                    }
                    
                }else { print(log: "no packages found") }
                
            }else {
                
            }
            
            self.arrFavouritePackages.count == 0 ? self.searchResultsTable.setEmptyMessage("No Favourite Packages found", bgColor: APPCOLORS_3.Body_BG) : self.searchResultsTable.setEmptyMessage("", bgColor: COLOR_CLEAR)

            self.searchResultsTable.reloadData()
            
            
        }, errorblock: { (error, isJSONerror)  in
            
            if isJSONerror {
                
            }else {
                
            }
            
            self.arrFavouritePackages.count == 0 ? self.searchResultsTable.setEmptyMessage("No Favourite Packages found", bgColor: APPCOLORS_3.Body_BG) : self.searchResultsTable.setEmptyMessage("", bgColor: COLOR_CLEAR)

            self.searchResultsTable.reloadData()

        }, progress: nil)
    }
    
    
    func makeHomeLandFavorite (_ favorite: Bool, _ homeLand: HomeLandPackage, callBack: @escaping ((_ successss: Bool) -> Void)) {
        
        let params = NSMutableDictionary()
        params.setValue(SearchType.shared.homeLand, forKey: "TypeId")
        params.setValue(appDelegate.userData?.user?.userID, forKey: "UserId")
        params.setValue(homeLand.packageId, forKey: "HouseId")
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
            
            
            if self.isFavoritesService {
                
                self.arrFavouritePackages.count == 0 ? self.searchResultsTable.setEmptyMessage("No Favourite Packages found", bgColor: APPCOLORS_3.Body_BG) : self.searchResultsTable.setEmptyMessage("", bgColor: COLOR_CLEAR)
            }else {
                if self.mapResultsTable.isHidden {
                    
                    self.arrHomeLand.count == 0 ? self.searchResultsTable.setEmptyMessage("No Packages found", bgColor: APPCOLORS_3.Body_BG) : self.searchResultsTable.setEmptyMessage("", bgColor: COLOR_CLEAR)
                }else {
                    
                }
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
    
    
    
}
    
    

