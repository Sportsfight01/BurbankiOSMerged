//
//  DisplaysMapVC.swift
//  BurbankApp
//
//  Created by sreekanth reddy Tadi on 05/05/21.
//  Copyright © 2021 Sreekanth tadi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import GoogleMaps
import GoogleMapsUtils
import GoogleUtilities

class DisplaysMapVC: UIViewController {
    var getDisplayNearByHome = [DisplayHomeModel]()
    var homelandPopUpVc: HomeLandPopupVC?
    var markerInfoVC: MarkerInfoVC?
    var selectedMarker : NearByPlaceMarkers?
    private var clusterManager: GMUClusterManager!
    
    @IBOutlet weak var backBTN: UIButton!
    @IBOutlet weak var backBTNCard: UIView!
    
    @IBOutlet weak var mapView: MyPlaceMap!
    @IBOutlet weak var regionTableHeight: NSLayoutConstraint!
    @IBOutlet weak var displayDetailsCard: UIView!
    @IBOutlet weak var streetNameLBL: UILabel!
    @IBOutlet weak var estateNameLBL: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var titleCardHeight: NSLayoutConstraint!
    @IBOutlet weak var titleCardView: UIView!
    @IBOutlet weak var titleNameLBL: UILabel!
    
    var houseDetailsByHouseTypeArr = [houseDetailsByHouseType]()
    var selectedSuggestedDisplay = ""
    var screenFromSuggestedDisplays : Bool = false
    var selectedDisplayHomes : DisplayHomeModel?
    var tableViewContentHeight = 0
    var isFavoritesService: Bool = false
    var arrFavouriteDisplays = [[houseDetailsByHouseType]]()
    var isTradingViewExpanded : Bool = false
    
    // MARK: - ViewLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("tappedOnSuggestedHomes"), object: nil, queue: nil, using:updatedNotification)
        mapView.addZoomLevelButtons ()
        mapView.isMyLocationEnabled = true
        self.tableView.register(UINib(nibName: "TimingsAndDirectionTVC", bundle: nil), forCellReuseIdentifier: "TimingsAndDirectionTVC")
        
        setAppearanceFor(view: titleNameLBL, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_HEADING(size: FONT_12))
        setAppearanceFor(view: estateNameLBL, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_SUB_HEADING(size: FONT_14))
        setAppearanceFor(view: streetNameLBL, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_BODY(size: FONT_10))
        setAppearanceFor(view: backBTN, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Orange_BG, textFont: FONT_BUTTON_BODY(size: FONT_14))
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.titleNameLBL.text == "NEW HOME DESIGNS" {
            if selectedDisplayHomes != nil{
                fillDetailsFromDesignScreen(suggestedHome: selectedDisplayHomes!)
            }
            
        }else{
            if selectedMarker != nil{
                let package = (selectedMarker!).displayHomesPlaces!
                getHouseDetailsData(package: package)
            }
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        regionTableHeight.constant = tableView.contentSize.height
    }
    
   
    
    @objc func handleTapOnTradingView(recognizer : UITapGestureRecognizer)
    {
        isTradingViewExpanded.toggle()
        tableView.reloadData()
        tableView.layoutIfNeeded()
        regionTableHeight.constant = tableView.contentSize.height
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.view.layoutIfNeeded()
        }
    }
    
    func updatedNotification(notification:Notification) -> Void  {
        
        guard let isTappedonPopularHomeDesigns = notification.userInfo!["Key"] else { return }
        //        print("\(LocationServices.shared.K_GETlocationCORD?.latitude ?? 0.0)")
        print("-------\(isTappedonPopularHomeDesigns)")
        if isTappedonPopularHomeDesigns as! Bool {
            guard let suggestedHomeData = notification.userInfo!["suggestedHome"] else { return }
            selectedDisplayHomes = suggestedHomeData as! DisplayHomeModel
            fillDetailsFromDesignScreen(suggestedHome: suggestedHomeData as! DisplayHomeModel)
        }
        else{
            self.titleNameLBL.text = "CHOOSE A DISPLAY"
            self.navigationController?.popViewController(animated: true)
            self.displayDetailsCard.isHidden = true
            self.backBTNCard.isHidden = true
            self.regionTableHeight.constant = 100
            DashboardDataManagement.shared.getDisplaysForRegionAndMap(stateId: kUserState, regionName: "\(selectedSuggestedDisplay)", popularFlag: true, userId: kUserID, showActivity: true) { (nearbyPlaces) in
                print(nearbyPlaces!)
                self.getDisplayNearByHome = []
                for package : NSDictionary  in nearbyPlaces! {
                    
                    let suggestedData = DisplayHomeModel(package as! [String : Any])
                    if let region = suggestedData.regionName {
                        print(log: region.lowercased())
                        self.getDisplayNearByHome.append(suggestedData)
                    }
                    DispatchQueue.main.async {
                        self.mapView.delegate = self
                        self.mapView.setMapPosition(with: suggestedData, zoomlevel: 12.0)
                        let markars = self.mapView.addMarkersTONearByPlaces (nearByPlaces: self.getDisplayNearByHome)
                        
                        var bounds = GMSCoordinateBounds()
                        for marker in markars {
                            bounds = bounds.includingCoordinate(marker.position)
                        }
                        self.mapView.animate(with: GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 50.0 , left: 50.0 ,bottom: 50.0 ,right: 50.0)))
                    }
                    
                }
                
            }
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleGestureRecognizer(recognizer:)))
        displayDetailsCard.addGestureRecognizer(tap)
    }
    @objc func handleGestureRecognizer (recognizer: UIGestureRecognizer) {
        if self.regionTableHeight.constant == 0{
            self.regionTableHeight.constant = CGFloat(self.tableViewContentHeight)
        }else{
            //self.tableViewContentHeight = 0
            self.tableView.contentSize.height = 0
            self.regionTableHeight.constant = 0
  
        }
        
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.view.layoutIfNeeded()
        }
        
        
        //        self.regionTableHeight.constant = CGFloat(self.tableViewContentHeight)
    }
    
    func fillDetailsFromDesignScreen(suggestedHome : DisplayHomeModel){
        self.titleNameLBL.text = "NEW HOME DESIGNS"
        self.displayDetailsCard.isHidden = false
        self.backBTNCard.isHidden = true
        self.estateNameLBL.text = "\(suggestedHome.estateName ?? "")".uppercased()
        self.streetNameLBL.text = "\(suggestedHome.lotStreet1 ?? ""),\n\(suggestedHome.lotSuburb ?? "")"
        self.mapView.delegate = self
        NotificationCenter.default.post(name: NSNotification.Name("changeBreadCrumbs"), object: nil, userInfo: ["breadcrumb" :"\(suggestedHome.estateName ?? ""),".uppercased() + " \(suggestedHome.lotStreet1 ?? "")"])
        self.mapView.setMapPosition(with: suggestedHome, zoomlevel : 15.0)
        _ = self.mapView.addMarkersTONearByPlaces(nearByPlaces: [suggestedHome])
        
        DashboardDataManagement.shared.getestateDetailsData(stateId: kUserState, estateName: "\(suggestedHome.estateName ?? "")", showActivity: true, { estateDetails in
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
}
// MARK: - Map Delegates And Clusters

extension DisplaysMapVC: GMSMapViewDelegate, UIPopoverPresentationControllerDelegate, GMUClusterManagerDelegate, GMUClusterRendererDelegate {
    
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
        
        if getDisplayNearByHome.count > 0 {
            
            let package = getDisplayNearByHome[0]
            self.mapView.setMapPosition(with: package)
            
            
            for index in 0...getDisplayNearByHome.count-1 {
                
                let homeLand = getDisplayNearByHome[index]
                
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
            getHouseDetailsData(package: package)
            
        }else if let cluster = marker.userData as? GMUStaticCluster {
            
            //                CodeManager.sharedInstance.sendScreenName(burbank_homeAndLand_map_cluster_button_touch)
            //    //            let package = (marker as! NearByPlaceMarkers).displayHomesPlaces!
            //                for item in cluster.items as! [POIItem] {
            //    //                self.homelandPopUpVc?.arrHomeLandPackages.append (item.homeLandPackage)
            //                }
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
    func getHouseDetailsData(package : DisplayHomeModel){
        self.estateNameLBL.text = "\(package.estateName ?? "")".uppercased()
        self.streetNameLBL.text = "\(package.lotStreet1 ?? ""),\n\(package.lotSuburb ?? "")"
        backBTNCard.isHidden = false
        let font:UIFont? = FONT_LABEL_SUB_HEADING(size: FONT_15)
        let fontSuper:UIFont? = FONT_LABEL_SUB_HEADING(size: FONT_12)
        
        let boldFontAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: font]
        let normalFontAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: fontSuper]
        let partOne = NSMutableAttributedString(string: "\(package.estateName ?? "")".uppercased(), attributes: boldFontAttributes as [NSAttributedString.Key : Any])
        let partTwo = NSMutableAttributedString(string: "\n\(package.lotStreet1 ?? ""),\(package.lotSuburb ?? "")", attributes: normalFontAttributes as [NSAttributedString.Key : Any])
        
        let combination = NSMutableAttributedString()
        
        combination.append(partOne)
        combination.append(partTwo)
        
        // self.estateNameLBL.attributedText = combination
        NotificationCenter.default.post(name: NSNotification.Name("changeBreadCrumbs"), object: nil, userInfo: ["breadcrumb" :"\(package.estateName?.uppercased() ?? ""), \(package.lotStreet1 ?? "")"])
        
        DashboardDataManagement.shared.getestateDetailsData(stateId: kUserState, estateName: package.estateName ?? "", showActivity: true, { estateDetails in
            self.houseDetailsByHouseTypeArr = []
            if let estate = estateDetails {
                self.houseDetailsByHouseTypeArr = estate
            }
            
            //Commented for taking global popup class bellow
            DispatchQueue.main.async {
                self.displayDetailsCard.isHidden = false
                self.regionTableHeight.constant = 100
                self.layoutTable ()
            }
            
//            DispatchQueue.main.async {
//                let vc = self.storyboard!.instantiateViewController(withIdentifier: "PopupDisplayHomesVC") as! PopupDisplayHomesVC
//                vc.estateName = combination.string
//                vc.suburbAddress = ""
//                vc.houseDetailsByHouseTypeArr = self.houseDetailsByHouseTypeArr
//                    let navigationController = self.navigationController
//                    vc.modalPresentationStyle = .overCurrentContext
//                    navigationController?.present(vc, animated: false)
//            }

            
        })
    }
    
    
    func makeAllMarkersasUnSelected () {
        
        if let marker = selectedMarker {
            
            marker.selected = false
        }
    }
    
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("Tapped On Map")
        if self.regionTableHeight.constant > 100{
            self.regionTableHeight.constant = 0
            self.tableView.contentSize.height = 0
            print("height zero")
        }else{
            
        }
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
    }
//    if self.regionTableHeight.constant == 0{
//        self.regionTableHeight.constant = CGFloat(self.tableViewContentHeight)
//    }else{
//        //self.tableViewContentHeight = 0
//        self.tableView.contentSize.height = 0
//        self.regionTableHeight.constant = 0
//
//
//    }
}
// MARK: - TableView Delegate Methods
extension DisplaysMapVC: UITableViewDelegate, UITableViewDataSource {
    
    func layoutTable () {
        DispatchQueue.main.async {
            self.tableView.rowHeight = UITableView.automaticDimension;
            self.tableView.estimatedRowHeight = 90
            self.tableView.reloadData()
            self.tableView.layoutIfNeeded()
            
            self.regionTableHeight.constant = self.tableView.contentSize.height
            self.tableViewContentHeight = Int(self.tableView.contentSize.height)

            self.tableView.isScrollEnabled = true
            
            if  self.houseDetailsByHouseTypeArr.count > 1 {
                if self.tableViewContentHeight > Int(self.tableView.contentSize.height){
                    self.regionTableHeight.constant = CGFloat(self.tableViewContentHeight)
                }else{
                    self.tableViewContentHeight = Int(self.tableView.contentSize.height)
                    self.regionTableHeight.constant = CGFloat(self.tableViewContentHeight)
                }
            }else if self.houseDetailsByHouseTypeArr.count == 1{
                self.tableViewContentHeight = Int(self.tableView.contentSize.height)
                self.regionTableHeight.constant = CGFloat(self.tableViewContentHeight)
            }
            else {
                self.regionTableHeight.constant = 0
            }
        }
        
    }
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
                let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOnTradingView))
                cell.cardViewTwo.addGestureRecognizer(tapGuesture)
                var openTimesArray = (self.houseDetailsByHouseTypeArr[0].openTimes.components(separatedBy: ","));
                let dataFormatter = DateFormatter()
                dataFormatter.dateFormat = "dd/MM"
                let strDate = dataFormatter.string(from: Date())
                // replace today's day with 'TODAY' (ex if today is Wed replacing that as TODAY)
                let openTimesStr = openTimesArray.map { str in
                    if str.contains(strDate)
                    {
                        return str.replace_fromStart(str: str, endIndex: 3, With: "Today")
                    }
                    return str
                }.joined(separator: " \n")
                //   openTimes = openTimes.replace_fromStart(str: openTimes, endIndex: 2, With: "TODAY")
                let tradingHoursString = "TRADING HOURS  \n\(openTimesStr)"
                setAttributetitleFor(view: cell.tradingHoursLBL, title: tradingHoursString, rangeStrings: ["TRADING HOURS", openTimesStr], colors: [APPCOLORS_3.GreyTextFont, APPCOLORS_3.GreyTextFont], fonts: [FONT_LABEL_SUB_HEADING(size: 14), FONT_LABEL_BODY(size: 12)], alignmentCenter: false)
                
                cell.tradingHoursLBL.textAlignment = .left
                cell.tradingHoursLBL.numberOfLines = isTradingViewExpanded ? 0 : 2
                cell.downArrowImage.transform = isTradingViewExpanded ? .init(rotationAngle: .pi) : .identity
            }

            return cell
        }  else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DisplaysMapDetailCell", for: indexPath) as! DisplaysMapDetailCell
            cell.displayHomeData = houseDetailsByHouseTypeArr[indexPath.row]
            cell.selectionStyle = .none
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            cell.addGestureRecognizer(tap)
            cell.tag = indexPath.row
            cell.isUserInteractionEnabled = true
            
            if isFavoritesService == true {
                //             let displayData = DisplayHomeDataArr[indexPath.item]
                //            let package = arrFavouritePackages[indexPath.section][indexPath.row]
                cell.displayHomeData = houseDetailsByHouseTypeArr[indexPath.row]
                
                
                cell.favoriteBTN.isHidden = cell.displayHomeData?.favouritedUser?.userID != kUserID
                
            }else {
                //             let displayData = DisplayHomeDataArr[indexPath.item]
                cell.displayHomeData = houseDetailsByHouseTypeArr[indexPath.row]               }
            
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
                    
                    self.makeDisplayHomeFavorite(!(cell.displayHomeData!.isFav), cell.displayHomeData!) { (success) in
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
                                
                            }else {
                                
                                cell.displayHomeData!.isFav = !(cell.displayHomeData!.isFav)
                                self.houseDetailsByHouseTypeArr[indexPath.row] =  cell.displayHomeData!
                                
                                self.tableView.reloadRows(at: [IndexPath.init(row: indexPath.row, section: 0)], with: .none)
                                
                                if updateDefaults {
                                    updateDisplayHomesFavouritesCount(cell.displayHomeData!.isFav == true)
                                }
                                
                            }
                        }
                    }
                }
            }
            print(log: "indexpath \(indexPath.row), arraycount \(houseDetailsByHouseTypeArr.count)")
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = houseDetailsByHouseTypeArr[indexPath.row]
        let homeDetailView = self.storyboard?.instantiateViewController(withIdentifier: "DisplayHomesDetailsVC") as! DisplayHomesDetailsVC
        homeDetailView.displayHomes = data
        homeDetailView.isFromDisplayHomes = true
        self.navigationController?.pushViewController(homeDetailView, animated: true)
    }
    
}

// MARK: - Handling Button Actions and Segues
extension DisplaysMapVC{
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        print(sender.view?.tag)
        let index = sender.view?.tag ?? 0
        let data = houseDetailsByHouseTypeArr[index]
        let homeDetailView = self.storyboard?.instantiateViewController(withIdentifier: "DisplayHomesDetailsVC") as! DisplayHomesDetailsVC
        homeDetailView.displayHomes = data
        homeDetailView.isFromDisplayHomes = true
        self.navigationController?.pushViewController(homeDetailView, animated: true)
        
    }
    
    @IBAction func didTappedOnGetDirections (_ sender: UIButton) {
        guard houseDetailsByHouseTypeArr.count >= 0 else {
           showAlert(message: "Something went terribly wrong. Please come back later.")
           return
         }
        
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
        if houseDetailsByHouseTypeArr.count > 0{
            let selectedDisplayHomeData = houseDetailsByHouseTypeArr[sender.tag - 1]
            let bookAppintmentV = BookAppointmentVC()
            bookAppintmentV.displayHomeData = houseDetailsByHouseTypeArr
            self.performSegue(withIdentifier: "BookAppointmentVC", sender: nil)
        }else{
            showAlert(message: "Something went terribly wrong. Please come back later.")
        }
    }
    @IBAction func didTappedOnBackButton(_ sender: UIButton) {
        self.backBTNCard.isHidden = true
        self.displayDetailsCard.isHidden = true
        self.regionTableHeight.constant = 100
        makeAllMarkersasUnSelected ()
        NotificationCenter.default.post(name: NSNotification.Name("changeBreadCrumbs"), object: nil, userInfo: ["breadcrumb" :"See one of our display homes"])
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
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
// MARK: - API's
extension DisplaysMapVC{
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
    
}
