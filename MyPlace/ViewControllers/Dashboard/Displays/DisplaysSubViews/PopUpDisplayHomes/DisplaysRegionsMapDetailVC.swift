//
//  File.swift
//  BurbankApp
//
//  Created by sreekanth reddy Tadi on 07/05/21.
//  Copyright © 2021 Sreekanth tadi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import GoogleMaps
import GoogleMapsUtils


class DisplaysRegionsMapDetailVC: UIViewController {

    
    @IBOutlet weak var regionTableHeight: NSLayoutConstraint!

    @IBOutlet weak var titleCardHeight: NSLayoutConstraint!
    @IBOutlet weak var titleCardView: UIView!
    @IBOutlet weak var titleNameLBL: UILabel!
    
    @IBOutlet weak var displayDetailsCard: UIView!
    @IBOutlet weak var streetNameLBL: UILabel!
    @IBOutlet weak var mapView: MyPlaceMap!
    @IBOutlet weak var estateNameLBL: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
//    var arrDisplayHomes = [DisplayHomeModel]()

    var arrDisplayHomes = [DisplayHomeModel]()
    var selectedDisplayHomes : DisplayHomeModel?
    
    var markerInfoVC: MarkerInfoVC?
    var selectedMarker : NearByPlaceMarkers?
    private var clusterManager: GMUClusterManager!
    
    var houseDetailsByHouseTypeArr = [houseDetailsByHouseType]()
    var selectedRegionForMaps = ""
    var screenFromHomeDesigns : Bool = false
    var selctedDesignHome = ""
    var isFavoritesService: Bool = false
    
    var arrFavouriteDisplays = [[houseDetailsByHouseType]]()
    var tableViewContentHeight = 0
    var popularHomeDesignData = designLocations()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "TimingsAndDirectionTVC", bundle: nil), forCellReuseIdentifier: "TimingsAndDirectionTVC")
        
//        if screenFromHomeDesigns{
//            fillDetailsFromDesignScreen()
//            self.titleNameLBL.text = "POPULAR HOME DESIGNS"
//        }else{
//            self.titleNameLBL.text = selectedRegionForMaps.uppercased()
//            NotificationCenter.default.post(name: NSNotification.Name("changeBreadCrumbs"), object: nil, userInfo: ["breadcrumb" :"Choose a display from the \(selectedRegionForMaps)."])
//            self.displayDetailsCard.isHidden = true
//            print(selectedRegionForMaps)
//            DashboardDataManagement.shared.getDisplaysForRegionAndMap(stateId: kUserState, regionName: selectedRegionForMaps, popularFlag: true, userId: kUserID, showActivity: true) { (nearbyPlaces) in
//                print(nearbyPlaces!)
//                for package : NSDictionary  in nearbyPlaces! {
//
//                    let suggestedData = DisplayHomeModel(package as! [String : Any])
//                    if let region = suggestedData.regionName {
//                        print(log: region.lowercased())
//                        self.arrDisplayHomes.append(suggestedData)
//                    }
//                    DispatchQueue.main.async {
//                        self.mapView.delegate = self
//                        self.mapView.setMapPosition(with: suggestedData, zoomlevel: 10.0)
//                        let markars = self.mapView.addMarkersTONearByPlaces (nearByPlaces: self.arrDisplayHomes)
//
//                         var bounds = GMSCoordinateBounds()
//                             for marker in markars {
//                                 bounds = bounds.includingCoordinate(marker.position)
//                             }
//                         self.mapView.animate(with: GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 50.0 , left: 50.0 ,bottom: 50.0 ,right: 50.0)))
//                    }
//                }
//            }
//        }
       
        
        mapView.addZoomLevelButtons ()
        mapView.isMyLocationEnabled = true

        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleGestureRecognizer(recognizer:)))
        displayDetailsCard.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(forName: NSNotification.Name("handleBackBtnNaviogation"), object: nil, queue: nil, using:updatedNotification)
        
    }
    func updatedNotification(notification:Notification) -> Void  {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func handleGestureRecognizer (recognizer: UIGestureRecognizer) {
        self.regionTableHeight.constant = CGFloat(self.tableViewContentHeight)
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if screenFromHomeDesigns{
            fillDetailsFromDesignScreen()
            self.titleNameLBL.text = "POPULAR HOME DESIGNS"
        }else{
            self.titleNameLBL.text = selectedRegionForMaps.uppercased()
            NotificationCenter.default.post(name: NSNotification.Name("changeBreadCrumbs"), object: nil, userInfo: ["breadcrumb" :"Choose a display from the \(selectedRegionForMaps)."])
            self.displayDetailsCard.isHidden = true
            print(selectedRegionForMaps)
            DashboardDataManagement.shared.getDisplaysForRegionAndMap(stateId: kUserState, regionName: selectedRegionForMaps, popularFlag: true, userId: kUserID, showActivity: true) { (nearbyPlaces) in
                print(nearbyPlaces!)
                for package : NSDictionary  in nearbyPlaces! {
                    
                    let suggestedData = DisplayHomeModel(package as! [String : Any])
                    if let region = suggestedData.regionName {
                        print(log: region.lowercased())
                        self.arrDisplayHomes.append(suggestedData)
                    }
                    DispatchQueue.main.async {
                        self.mapView.delegate = self
                        self.mapView.setMapPosition(with: suggestedData, zoomlevel: 10.0)
                        let markars = self.mapView.addMarkersTONearByPlaces (nearByPlaces: self.arrDisplayHomes)
                         
                         var bounds = GMSCoordinateBounds()
                             for marker in markars {
                                 bounds = bounds.includingCoordinate(marker.position)
                             }
                         self.mapView.animate(with: GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 50.0 , left: 50.0 ,bottom: 50.0 ,right: 50.0)))
                    }
                }
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
    }
    func fillDetailsFromDesignScreen(){
        
//        self.displayDetailsCard.isHidden = false
        let font:UIFont? = FONT_LABEL_SUB_HEADING(size: FONT_15)
        let fontSuper:UIFont? = FONT_LABEL_SUB_HEADING(size: FONT_12)
        let boldFontAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: font]
        let normalFontAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: fontSuper]
        let partOne = NSMutableAttributedString(string: "\(self.popularHomeDesignData.eststeName ?? "")".uppercased() , attributes: boldFontAttributes as [NSAttributedString.Key : Any])
        let partTwo = NSMutableAttributedString(string: "\n\(self.popularHomeDesignData.lotStreet1 ?? ""),\(self.popularHomeDesignData.lotSuburb ?? "")", attributes: normalFontAttributes as [NSAttributedString.Key : Any])
        
        let combination = NSMutableAttributedString()
        
        combination.append(partOne)
        combination.append(partTwo)
        
        self.estateNameLBL.attributedText = combination
        
        NotificationCenter.default.post(name: NSNotification.Name("changeBreadCrumbs"), object: nil, userInfo: ["breadcrumb" :"\(self.popularHomeDesignData.eststeName?.uppercased() ?? "")"])
        self.streetNameLBL.text = "\(popularHomeDesignData.lotStreet1 ?? ""),\n\(popularHomeDesignData.lotSuburb ?? "")"
        self.mapView.delegate = self
        self.mapView.setMapPosition(with: self.popularHomeDesignData, zoomlevel: 12.0)
        self.mapView.addMarkersToDesignLoc(packages: [self.popularHomeDesignData])
        DashboardDataManagement.shared.getestateDetailsData(stateId: kUserState, estateName: "\(self.popularHomeDesignData.eststeName ?? "")", showActivity: true, { estateDetails in
            self.houseDetailsByHouseTypeArr = []
            if let estate = estateDetails {
                 self.houseDetailsByHouseTypeArr = estate
            }
            DispatchQueue.main.async {
                self.displayDetailsCard.isHidden = false
                self.layoutTable ()
            }
            
        })
    }
    
    func layoutTable () {
        DispatchQueue.main.async {
            self.tableView.rowHeight = UITableView.automaticDimension;
            self.tableView.estimatedRowHeight = 90
        self.tableView.reloadData()
        self.tableView.layoutIfNeeded()
        
        
        self.tableView.isScrollEnabled = true
                
        if  self.houseDetailsByHouseTypeArr.count > 1 {
            if self.tableViewContentHeight > Int(self.tableView.contentSize.height){
                self.regionTableHeight.constant = CGFloat(self.tableViewContentHeight)
            }else{
                self.tableViewContentHeight = Int(self.tableView.contentSize.height)
                self.regionTableHeight.constant = CGFloat(self.tableViewContentHeight)
            }

        }else if self.houseDetailsByHouseTypeArr.count == 1 {
            self.tableViewContentHeight = Int(self.tableView.contentSize.height)
            self.regionTableHeight.constant = CGFloat(self.tableViewContentHeight)
        }else{
            self.regionTableHeight.constant = 0
        }
        }
        
    }

    @IBAction func didTappedOnBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
//        if segue.identifier == "DisplaysNearByVC" {
//            nearbyVC = segue.destination as? DisplaysNearByVC
//        }else if segue.identifier == "DisplaysDesignsVC" {
//            designsVC = segue.destination as? DisplaysDesignsVC
//        }else if segue.identifier == "DisplaysRegionsVC" {
//            regionsVC = segue.destination as? DisplaysRegionsVC
//        }else if segue.identifier == "DisplaysMapVC" {
//            mapVC = segue.destination as? DisplaysMapVC
//        }else if segue.identifier == "DisplaysRegionsMapDetailVC" {
//            mapAndDetailsVC = segue.destination as? DisplaysRegionsMapDetailVC
//        }
//    }
    
}


extension DisplaysRegionsMapDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return houseDetailsByHouseTypeArr.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let lastRow: Int = self.tableView.numberOfRows(inSection: 0) - 1
        
        if indexPath.row ==  lastRow{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimingsAndDirectionTVC", for: indexPath) as! TimingsAndDirectionTVC
//                cell.displayHomeData = houseDetailsByHouseTypeArr[indexPath.row]
            cell.getDirectionBTN.tag = indexPath.row
            cell.bookAnAppointmentBTN.tag = indexPath.row
            cell.getDirectionBTN.addTarget(self, action: #selector(didTappedOnGetDirections(_:)), for: .touchUpInside)
            cell.bookAnAppointmentBTN.addTarget(self, action: #selector(didTappedOnBookAppointments(_:)), for: .touchUpInside)
            
            cell.selectionStyle = .none
            if self.houseDetailsByHouseTypeArr.count > 0{
                let tradingHoursSepr = self.houseDetailsByHouseTypeArr[0].openTimes.components(separatedBy: ",")
                let tradingHrs = tradingHoursSepr.joined(separator: " " + "|" + " ")
                cell.tradingHoursLBL.text = "TRADING HOURS \n\(tradingHrs)"
            }
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DisplaysMapDetailCell", for: indexPath) as! DisplaysMapDetailCell
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            cell.addGestureRecognizer(tap)
            cell.tag = indexPath.row
            cell.isUserInteractionEnabled = true
            
            cell.selectionStyle = .none
            
            if isFavoritesService == true {
                //             let displayData = DisplayHomeDataArr[indexPath.item]
                //            let package = arrFavouritePackages[indexPath.section][indexPath.row]
                cell.displayHomeData = houseDetailsByHouseTypeArr[indexPath.row]
                
                
                cell.favoriteBTN.isHidden = cell.displayHomeData?.favouritedUser?.userID != kUserID
                
            }else {
                //             let displayData = DisplayHomeDataArr[indexPath.item]
                cell.displayHomeData = houseDetailsByHouseTypeArr[indexPath.row]
            }
            
            /*
             if Int(kUserID)! > 0 { print(log: kUserID) }
             else {
             cell.btnFavorite.isHidden = true
             }*/
            cell.favoriteAction = {
                if noNeedofGuestUserToast(self, message: "Please login to add favourites") {
                    
                    if self.isFavoritesService {
                        CodeManager.sharedInstance.sendScreenName(burbank_DisplayHomes_favourite_makeFavourite_button_touch)
                    }else {
                        CodeManager.sharedInstance.sendScreenName(burbank_homeAndLand_results_makeFavourite_button_touch)
                    }
                    
                    self.makeDisplayHomeFavorite((!(cell.displayHomeData!.isFav)), cell.displayHomeData!) { (success) in
                        if success {
                            
                            if (!(cell.displayHomeData!.isFav) == true) {
                                DispatchQueue.main.async(execute: {
                                    ActivityManager.showToast("Added to your favourites", self)
                                })
                            }else{
                                DispatchQueue.main.async(execute: {
                                    ActivityManager.showToast("Item removed from favourites", self)
                                })
                                
                            }
                            
                            var updateDefaults = false
                            
                            // if cell.displayHomeData!.favouritedUser?.userID == kUserID {
                            updateDefaults = true
                            //}
                            
                            
                            if self.isFavoritesService {
                                
                                var arr = self.arrFavouriteDisplays[indexPath.row]
                                arr.remove(at: indexPath.row)
                                
                                if arr.count == 0 {
                                    self.arrFavouriteDisplays.remove(at: indexPath.row)
                                    
                                    if updateDefaults {
                                        setDisplayHomesFavouritesCount(count: 0, state: kUserState)
                                    }
                                    
                                }else {
                                    self.arrFavouriteDisplays[indexPath.row] = arr
                                    
                                    if updateDefaults {
                                        setDisplayHomesFavouritesCount(count: arr.count, state: kUserState)
                                    }
                                }
                                
                                //                                   self.arrFavouriteDisplays.count == 0 ? self.searchResultsTable.setEmptyMessage("NO SAVED PACKAGES", bgColor: APPCOLORS_3.Body_BG) : self.searchResultsTable.setEmptyMessage("", bgColor: COLOR_CLEAR)
                                //
                                //                                   self.searchResultsTable.reloadData ()
                                
                            }else {
                                
                                cell.displayHomeData!.isFav = !(cell.displayHomeData!.isFav)
                                self.houseDetailsByHouseTypeArr[indexPath.row] =  cell.displayHomeData!
                                
                                self.tableView.reloadRows(at: [IndexPath.init(row: indexPath.row, section: 0)], with: .none)
                                
                                updateDisplayHomesFavouritesCount(cell.displayHomeData!.isFav == true)
                                
                            }
                        }
                    }
                }
            }
            print(log: "indexpath \(indexPath.row), arraycount \(houseDetailsByHouseTypeArr.count)")
            return cell
        }
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
         print(sender.view?.tag)
        let index = sender.view?.tag ?? 0
        let data = houseDetailsByHouseTypeArr[index]
        let homeDetailView = self.storyboard?.instantiateViewController(withIdentifier: "DisplayHomesDetailsVC") as! DisplayHomesDetailsVC
        homeDetailView.displayHomes = data
        homeDetailView.isFromDisplayHomes = true
        self.navigationController?.pushViewController(homeDetailView, animated: true)
        
      }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = houseDetailsByHouseTypeArr[indexPath.row]
        let homeDetailView = self.storyboard?.instantiateViewController(withIdentifier: "DisplayHomesDetailsVC") as! DisplayHomesDetailsVC
        homeDetailView.displayHomes = data
//        homeDetailView.favouriteButtonCompletion = { isFav in
//            print(isFav)
//        }
        homeDetailView.isFromDisplayHomes = true
        self.navigationController?.pushViewController(homeDetailView, animated: true)
    }
    func makeDisplayHomeFavorite (_ favorite: Bool, _ design: houseDetailsByHouseType, callBack: @escaping ((_ successss: Bool) -> Void)) {

        let params = NSMutableDictionary()
        params.setValue(3, forKey: "TypeId")
        params.setValue(appDelegate.userData?.user?.userID, forKey: "UserId")
        params.setValue(design.displayId, forKey: "HouseId")
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

    @IBAction func didTappedOnGetDirections (_ sender: UIButton) {
        let selectedDisplayHomeData = houseDetailsByHouseTypeArr[sender.tag - 1]
        let bookAppintmentV = DirctionsVC()
        bookAppintmentV.displayHomeData = houseDetailsByHouseTypeArr
        var latLong = "\(selectedDisplayHomeData.latitude)\(selectedDisplayHomeData.longitude)".whiteSpacesRemoved()
        if latLong.contains(","){
            print("latlong has coma",latLong)
        }else{
            latLong = "\(selectedDisplayHomeData.latitude),\(selectedDisplayHomeData.longitude)"
            print("latlong did not have coma",latLong)
        }

        if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {
            let url = "https://maps.google.com/maps?saddr&daddr=\(latLong)"
                    UIApplication.shared.open(URL(string:url)!)
        }else{
            let url = "https://maps.apple.com/maps?saddr&daddr=\(latLong)"
            UIApplication.shared.open(URL(string:url)!)
        }
    }

    @IBAction func didTappedOnBookAppointments (_ sender: UIButton) {
//        let selectedDisplayHomeData = houseDetailsByHouseTypeArr[sender.tag]
        let bookAppintmentV = BookAppointmentVC()
        bookAppintmentV.displayHomeData = houseDetailsByHouseTypeArr
        self.performSegue(withIdentifier: "BookAppointmentVC", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let vc = segue.destination as? BookAppointmentVC {
            vc.displayHomeData = houseDetailsByHouseTypeArr
            vc.estateName = self.estateNameLBL.text ??  ""
        }
        if let vc = segue.destination as? DirctionsVC {
            vc.displayHomeData = houseDetailsByHouseTypeArr
            vc.estateName = self.estateNameLBL.text ??  ""
        }
    }

}
extension DisplaysRegionsMapDetailVC{
    func gethouseDetailsByHouseType (estateName : String?) {
        _ = Networking.shared.GET_request(url: ServiceAPI.shared.URL_HouseDetailsByEstate(Int(kUserState) ?? 0, estateName ?? ""), userInfo: nil, success: { (json, response) in
            
            if let result: AnyObject = json {
                
                let result = result as! NSDictionary
                
                if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {
                    if let result: AnyObject = json {
                        if (result.allKeys as! [String]).contains("houseDetailsByHouseType") {
                            
                            if (result.value(forKey: "houseDetailsByHouseType") as AnyObject).isKind(of: NSArray.self){
                            let packagesResult = result.value(forKey: "houseDetailsByHouseType") as! [NSDictionary]
                            self.houseDetailsByHouseTypeArr = []
                            for package: NSDictionary in packagesResult {
                                let suggestedData = houseDetailsByHouseType(package as! [String : Any])
                                    self.houseDetailsByHouseTypeArr.append(suggestedData)
                            }
                         
                            
                            print(self.houseDetailsByHouseTypeArr)
                            }else{
                                self.houseDetailsByHouseTypeArr = []
                                print(log:  "No HouseDetail found")
                                
                            }}else { print(log:  "No HouseDetail found") }
                        DispatchQueue.main.async {
                            self.displayDetailsCard.isHidden = false
                            self.layoutTable ()
                        }
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


extension DisplaysRegionsMapDetailVC: GMSMapViewDelegate, UIPopoverPresentationControllerDelegate, GMUClusterManagerDelegate, GMUClusterRendererDelegate {
    
    func setUpClustering () {
        
        let iconGenerator = GMUDefaultClusterIconGenerator (buckets: [100], backgroundImages: [UIImage (named: "Ico-LocationDot")!])
        
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
        renderer.delegate = self
        
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)
        clusterManager.setDelegate(self, mapDelegate: self)
    }
    
    
    private func generateClusterItems() {
        let extent = 0.002
        
        if arrDisplayHomes.count ?? 0 > 0 {
            
            let package = arrDisplayHomes[0]
            self.mapView.setMapPosition(with: package)
            
            
            for index in 0...arrDisplayHomes.count-1 {
                
                let homeLand = arrDisplayHomes[index]
                
                if let latLangs = homeLand.latitude {
                    if latLangs.count > 0 {
                        let lat = (latLangs as NSString).doubleValue + extent * randomScale()
                        let lng = (homeLand.longitude! as NSString).doubleValue + extent * randomScale()
                        let name = "Item \(index)"
                        let item = POIItemTwo(position: CLLocationCoordinate2DMake(lat, lng), name: name, package: homeLand)
                        print("=-=-=--=--=-",item)
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
    
    
    
    
    func renderer(_ renderer: GMUClusterRenderer, markerFor object: Any) -> GMSMarker? {
        
        if (object as AnyObject).isKind(of: POIItemTwo.self) {
            //        if (object as AnyObject).isKind(of: HomeLandPackage.self) {
            
            let markerMyPlace = NearByPlaceMarkers (nearByPlace: (object as! POIItemTwo).dispalyeNearByPlace)
            
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
        
        if marker.isKind(of: NearByPlaceMarkers.self) {
            
            CodeManager.sharedInstance.sendScreenName(burbank_homeAndLand_map_markers_button_touch)
            
            print(log: "zoomLevel \((mapView as! MyPlaceMap).zoomLevel)")
            
            makeAllMarkersasUnSelected ()
            
            selectedMarker = marker as? NearByPlaceMarkers
            selectedMarker?.selected = true
            let package = (marker as! NearByPlaceMarkers).displayHomesPlaces!
            gethouseDetailsByHouseType(estateName: package.estateName)
            self.estateNameLBL.text = package.estateName
            self.streetNameLBL.text = "\(package.lotStreet1 ?? ""),\n\(package.lotSuburb ?? "")"
            NotificationCenter.default.post(name: NSNotification.Name("changeBreadCrumbs"), object: nil, userInfo: ["breadcrumb" :"\(package.estateName ?? "")"])
            let font:UIFont? = FONT_LABEL_SUB_HEADING(size: FONT_15)
            let fontSuper:UIFont? = FONT_LABEL_SUB_HEADING(size: FONT_12)
            
            let boldFontAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: font]
            let normalFontAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: fontSuper]
            let partOne = NSMutableAttributedString(string: package.estateName?.uppercased() ?? "" , attributes: boldFontAttributes as [NSAttributedString.Key : Any])
            let partTwo = NSMutableAttributedString(string: "\n\(package.lotStreet1 ?? ""),\(package.lotSuburb ?? "")", attributes: normalFontAttributes as [NSAttributedString.Key : Any])
            
            let combination = NSMutableAttributedString()
            
            combination.append(partOne)
            combination.append(partTwo)
            
            self.estateNameLBL.attributedText = combination
            NotificationCenter.default.post(name: NSNotification.Name("changeBreadCrumbs"), object: nil, userInfo: ["breadcrumb" :"\(package.estateName?.uppercased() ?? ""), \(package.lotStreet1 ?? "")"])
            DashboardDataManagement.shared.getestateDetailsData(stateId: kUserState, estateName: package.estateName ?? "", showActivity: true, { estateDetails in
                self.houseDetailsByHouseTypeArr = []
                if let estate = estateDetails {
                     self.houseDetailsByHouseTypeArr = estate
                }
//                DispatchQueue.main.async {
//                    let vc = self.storyboard!.instantiateViewController(withIdentifier: "PopupDisplayHomesVC") as! PopupDisplayHomesVC
//                    vc.estateName = combination.string
//                    vc.suburbAddress = ""
//                    vc.houseDetailsByHouseTypeArr = self.houseDetailsByHouseTypeArr
//                        let navigationController = self.navigationController
//                        let transition = CATransition()
//                        transition.duration = 0.5
//                    transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//                    transition.type = CATransitionType.moveIn
//                    transition.subtype = CATransitionSubtype.fromTop
//                        navigationController?.view.layer.add(transition, forKey: nil)
//                        navigationController?.present(vc, animated: false)
////                    self.displayDetailsCard.isHidden = false
////                    self.regionTableHeight.constant = 100
////                    self.layoutTable ()
//                }
                
            })
        
             
        }else if let cluster = marker.userData as? GMUStaticCluster {
            
//            CodeManager.sharedInstance.sendScreenName(burbank_homeAndLand_map_cluster_button_touch)
////            let package = (marker as! NearByPlaceMarkers).displayHomesPlaces!
//            for item in cluster.items as! [POIItem] {
////                self.homelandPopUpVc?.arrHomeLandPackages.append (item.homeLandPackage)
//            }
//            gethouseDetailsByHouseType(estateName: package.estateName)
        }
        return true
    }
    
    
    private func clusterManager(clusterManager: GMUClusterManager, didTapCluster cluster: GMUCluster) {
        
        print("cluster tap")
        
        //        let newCamera = GMSCameraPosition.cameraWithTarget(cluster.position, zoom: mapView.camera.zoom + 1)
        //        let update = GMSCameraUpdate.setCamera(newCamera)
        //        mapView.moveCamera(update)
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("Tapped On Map")
        print("Tapped On Map")
        if self.regionTableHeight.constant > 100{
            self.regionTableHeight.constant = 0
            print("height zero")
        }else{

        }
        
      print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
    }
    
    func makeAllMarkersasUnSelected () {
        
        if let marker = selectedMarker {
            
            marker.selected = false
        }
    }
    
    
    
    // mapview delegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        mapView.isMyLocationEnabled = true
    }
    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print(log: "Error \(error)")
    }
}

    


