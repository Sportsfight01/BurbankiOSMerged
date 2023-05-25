////
////  DisplaysVC.swift
////  MyPlace
////
////  Created by sreekanth reddy Tadi on 26/03/20.
////  Copyright © 2020 Sreekanth tadi. All rights reserved.
////
//
//import UIKit
//
class DisplaysVC: HeaderVC, ChildVCDelegate {
    func handleActionFor(sort: Bool, map: Bool, favourites: Bool, howWorks: Bool, reset: Bool) {
        print("sort action")
    }
    
//
    @IBOutlet weak var topOptionsView : UIView!

    @IBOutlet weak var displaysCollectionView : UICollectionView!

    @IBOutlet weak var childVCsView : UIView!

    @IBOutlet weak var nearbyVCContainerView : UIView!
    @IBOutlet weak var designsVCContainerView : UIView!
    @IBOutlet weak var regionsVCContainerView : UIView!
    @IBOutlet weak var mapVCContainerView : UIView!

    var DisplayHomeData = [DisplayHomeModel]()
    var MostPopularHomesData = [PupularDisplays]()

    var nearbyVC: DisplaysNearByVC?
    var designsVC: DisplaysDesignsVC?
    var regionsVC: DisplaysRegionsVC?
    var mapVC: DisplaysMapVC?
    
    @IBOutlet weak var nearByBTN: UIButton!
    @IBOutlet weak var nearbyIcon: UIButton! //Ico-Location-Unfill
    
    @IBOutlet weak var designBTN: UIButton!
    @IBOutlet weak var designIcon: UIButton! //Ico-MyDesign
    
    @IBOutlet weak var regionBTN: UIButton!
    @IBOutlet weak var regionIcon: UIButton! //circle.dashed
    
    @IBOutlet weak var mapBTN: UIButton!
    @IBOutlet weak var mapIcon: UIButton! //map
    var mapAndDetailsVC: DisplaysRegionsMapDetailVC?
    
    var selectedDesign : DisplayHomeModel?
    
    var isFrromProfileFavorates : Bool = false
    var latitude = "0.0"
        var longitude = "0.0"
    
    //MARK: - ViewLife Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: displaysCollectionView.bounds.width , height: 50)
        let scaleFactor = (self.displaysCollectionView.bounds.width - 8)/2
        layout.itemSize = CGSize(width: scaleFactor , height: 140)
        self.displaysCollectionView.collectionViewLayout = layout
        self.view.backgroundColor = APPCOLORS_3.Body_BG
        headerLogoText = "DisplayHomes"
        isFromProfile = false
        if btnBack.isHidden {
            showBackButton()
            btnBack.addTarget(self, action: #selector(handleBackButton(_:)), for: .touchUpInside)
            btnBackFull.addTarget(self, action: #selector(handleBackButton(_:)), for: .touchUpInside)
        }
        DispatchQueue.main.async {
            LocationServices.shared.onLocationService()
        }
        
        childVCsView.isHidden = true
        displaysCollectionView.isHidden = false
        displaysCollectionView.delegate = self
        displaysCollectionView.dataSource = self
        setImages()
        addHeaderOptions(delegate: self)
        if isFrromProfileFavorates{
            
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name("changeBreadCrumbs"), object: nil, queue: nil, using:updatedNotification)
        setUpUI()
    }
    
    func setUpUI(){
        nearByBTN.titleLabel?.font = FONT_LABEL_BODY(size: 8)
        designBTN.titleLabel?.font = FONT_LABEL_BODY(size: 8)
        mapBTN.titleLabel?.font = FONT_LABEL_BODY(size: 8)
        regionBTN.titleLabel?.font = FONT_LABEL_BODY(size: 8)
    }
    func updatedNotification(notification:Notification) -> Void  {
        guard let changeBreadCrumbLBL = notification.userInfo!["breadcrumb"] else { return }
        self.removeAllBreadCrumbs()
        self.addBreadcrumb(changeBreadCrumbLBL as? String ?? "")
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        btnMap.setTitle("  0 DESIGNS  ", for: .normal)
        setFramesForOptionsViews()
        self.addBreadCrumb(from: "See one of our display homes")
        getDisplayHomes()
       
    }
    
    //MARK: viewSetup
    
    func setImages(){
        let nearbyImg = UIImage(named: "Ico-Display-Nearby")
        let designImg = UIImage(named: "Ico-Display-Designs")
        let regionImg = UIImage(named: "Ico-Display-Regions")
        let mapImg = UIImage(named: "Ico-Display-Maps")
        
        nearbyIcon.setImage(nearbyImg?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        designIcon.setImage(designImg?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        regionIcon.setImage(regionImg?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        mapIcon.setImage(mapImg?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        nearbyIcon.tintColor = .darkGray
        designIcon.tintColor = .darkGray
        regionIcon.tintColor = .darkGray
        mapIcon.tintColor = .darkGray
        
        nearByBTN.setTitleColor(.darkGray, for: .normal)
        designBTN.setTitleColor(.darkGray, for: .normal)
        regionBTN.setTitleColor(.darkGray, for: .normal)
        mapBTN.setTitleColor(.darkGray, for: .normal)
        
    }
   

 

    //MARK: - Handling Back Button Actions

    @IBAction func handleBackButton (_ sender: UIButton) {
        
        

        if !childVCsView.isHidden || displaysCollectionView.isHidden {
            setImages()
            childVCsView.isHidden = true
            displaysCollectionView.isHidden = false
            NotificationCenter.default.post(name: NSNotification.Name("handleBackBtnNaviogation"), object: nil, userInfo: nil)
            self.removeAllBreadCrumbs()
            
            self.getDisplayHomes()
        }else{
            if navigationController?.viewControllers.count == 1 {
               // self.tabBarController?.navigationController?.popViewController(animated: true)
              if let vc = kStoryboardMain.instantiateInitialViewController()
              {
                kWindow.rootViewController = vc
                kWindow.makeKeyAndVisible()
              }
              
            }else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
//MARK: - navigation Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DisplaysNearByVC" {
            nearbyVC = segue.destination as? DisplaysNearByVC
        }else if segue.identifier == "DisplaysDesignsVC" {
            designsVC = segue.destination as? DisplaysDesignsVC
        }else if segue.identifier == "DisplaysRegionsVC" {
            regionsVC = segue.destination as? DisplaysRegionsVC
        }else if segue.identifier == "DisplaysMapVC" {
            mapVC = segue.destination as? DisplaysMapVC
        }else if segue.identifier == "DisplaysRegionsMapDetailVC" {
            mapAndDetailsVC = segue.destination as? DisplaysRegionsMapDetailVC
        }
       
        displaysCollectionView.isHidden = false
    }

//MARK: Handling of Top Buttons with tags showing perticular screens
    @IBAction func handleOptionsButtonsActions (_ sender: UIButton) {

        if childVCsView.isHidden || !displaysCollectionView.isHidden {
            childVCsView.isHidden = false
            displaysCollectionView.isHidden = true
        }
        
       
        nearbyIcon.tintColor = .darkGray
        designIcon.tintColor = .darkGray
        regionIcon.tintColor = .darkGray
        mapIcon.tintColor = .darkGray
        
        nearByBTN.setTitleColor(.darkGray, for: .normal)
        designBTN.setTitleColor(.darkGray, for: .normal)
        regionBTN.setTitleColor(.darkGray, for: .normal)
        mapBTN.setTitleColor(.darkGray, for: .normal)
        
        nearbyVCContainerView.isHidden = true
        designsVCContainerView.isHidden = true
        regionsVCContainerView.isHidden = true
        mapVCContainerView.isHidden = true
        sender.setTitleColor(.darkGray, for: .normal)
        if sender.tag == 11 {
            
            nearbyVCContainerView.isHidden = false
            self.addBreadCrumb(from: "Check out the displays that are near you right now")
            nearbyIcon.tintColor = .orange
            nearByBTN.setTitleColor(.orange, for: .normal)
            NotificationCenter.default.post(name: NSNotification.Name("tappedOnNearBy"), object: nil, userInfo: nil)
            CodeManager.sharedInstance.sendScreenName(burbank_DisplayHomes_TappedOn_NearBy)
        }else if sender.tag == 12 {
            designsVCContainerView.isHidden = false
            self.addBreadCrumb(from: "Are you looking for a specific design?")
            designIcon.tintColor = .orange
            designBTN.setTitleColor(.orange, for: .normal)
            NotificationCenter.default.post(name: NSNotification.Name("tappedOnPopularHomeDesigns"), object: nil, userInfo: ["Key":false])
            CodeManager.sharedInstance.sendScreenName(burbank_DisplayHomes_TappedOn_Display_Design)
        }else if sender.tag == 13 {
            regionsVCContainerView.isHidden = false
            addBreadCrumb(from: "Choose the region you're interested in")
            regionIcon.tintColor = .orange
            regionBTN.setTitleColor(.orange, for: .normal)
            CodeManager.sharedInstance.sendScreenName(burbank_DisplayHomes_TappedOn_Display_Regions)
        }else if sender.tag == 14 {
            mapVCContainerView.isHidden = false
            self.addBreadCrumb(from: "See one of our display homes")
            mapIcon.tintColor = .orange
            mapBTN.setTitleColor(.orange, for: .normal)
            NotificationCenter.default.post(name: NSNotification.Name("tappedOnSuggestedHomes"), object: nil, userInfo: ["Key":false])
            CodeManager.sharedInstance.sendScreenName(burbank_DisplayHomes_TappedOn_Display_Maps)
        }
        NotificationCenter.default.post(name: NSNotification.Name("handleResetDesignsBTN"), object: nil, userInfo: nil)
    }
    
}

//MARK: Coleectionview delegate methods

extension DisplaysVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,displaySuggestedVCProtocol {
    func didTappedOnSuggestedHomeFavourite(index: Int) {
        print(index)
    }
     func numberOfSections(in collectionView: UICollectionView) -> Int {
        if self.DisplayHomeData.count <= 0{
            return 1
        }
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {

            case UICollectionView.elementKindSectionHeader:
            if self.DisplayHomeData.count <= 0{
                if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Cell", for: indexPath) as? SectionHeader{
                    sectionHeader.sectionHeaderlabel.text = "POPULAR HOME DESIGNS"
                       return sectionHeader
                   }
                   return UICollectionReusableView()
            }else{
                
              if indexPath.section == 0{
                    if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Cell", for: indexPath) as? SectionHeader{
                           sectionHeader.sectionHeaderlabel.text = "NEW DISPLAYS"
                           return sectionHeader
                       }
                       return UICollectionReusableView()
                }else{
                    if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Cell", for: indexPath) as? SectionHeader{
                           sectionHeader.sectionHeaderlabel.text = "POPULAR HOME DESIGNS"
                           return sectionHeader
                       }
                       return UICollectionReusableView()
                }
            }
            default:

                assert(false, "Unexpected element kind")
            }
        return UICollectionReusableView()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.DisplayHomeData.count <= 0{
            return MostPopularHomesData.count
        }else{
            if section == 0 {
                return 1
            }
            return MostPopularHomesData.count
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.DisplayHomeData.count <= 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DisplaysCVCell", for: indexPath) as! DisplaysCVCell
            
            let popularData = MostPopularHomesData[indexPath.item]
            cell.designNameLBL.text = popularData.houseName?.uppercased()
            if popularData.locations.count > 0{
                cell.locationsLBL.superview?.isHidden = false
            }else{
                cell.locationsLBL.superview?.isHidden = true
                
            }
            cell.locationsLBL.text = popularData.locations.count == 1 ? "\(popularData.locations.count )  LOCATION"  :  "\(popularData.locations.count )  LOCATIONS"
            
            if let imageurl = popularData.imageUrl {
                
                ImageDownloader.downloadImage(withUrl: ServiceAPI.shared.URL_imageUrl(imageurl), withFilePath: nil, with: { (image, success, error) in
                    
                    //                self.activity.stopAnimating()
                    cell.houseIMG.contentMode = .scaleToFill
                    
                    if let img = image {
                        cell.houseIMG.image = img
                    }else {
                        cell.houseIMG.image = UIImage (named: "BG-Half")
                    }
                    
                    
                }) { (progress) in
                    
                }
            }
            
            return cell
        }else{
            
            if indexPath.section == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DisplaysSuggestedCVCell", for: indexPath) as! DisplaysSuggestedCVCell
                cell.DisplayHomeDataArr = self.DisplayHomeData
                cell.delegate = self
                cell.reloadData()
                
                return cell
            }
            else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DisplaysCVCell", for: indexPath) as! DisplaysCVCell
                
                let popularData = MostPopularHomesData[indexPath.item]
                cell.designNameLBL.text = popularData.houseName?.uppercased()
                if popularData.locations.count > 0{
                    cell.locationsLBL.superview?.isHidden = false
                }else{
                    cell.locationsLBL.superview?.isHidden = true
                    
                }
                cell.locationsLBL.text = popularData.locations.count == 1 ? "\(popularData.locations.count )  LOCATION"  :  "\(popularData.locations.count )  LOCATIONS"
                
                if let imageurl = popularData.imageUrl {
                    
                    ImageDownloader.downloadImage(withUrl: ServiceAPI.shared.URL_imageUrl(imageurl), withFilePath: nil, with: { (image, success, error) in
                        
                        //                self.activity.stopAnimating()
                        cell.houseIMG.contentMode = .scaleToFill
                        
                        if let img = image {
                            cell.houseIMG.image = img
                        }else {
                            cell.houseIMG.image = UIImage (named: "BG-Half")
                        }
                        
                        
                    }) { (progress) in
                        
                    }
                }
                
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.DisplayHomeData.count <= 0{
            let scaleFactor = (collectionView.bounds.width - 8) / 2
            return CGSize (width: scaleFactor, height: 140)
        }else{
            if indexPath.section == 0 {
                return CGSize (width: collectionView.frame.size.width-20, height: 250) //320

            }else{
              let scaleFactor = (collectionView.bounds.width - 8) / 2
              return CGSize (width: scaleFactor, height: 140)
            }
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if self.DisplayHomeData.count <= 0{
            return UIEdgeInsets (top: 4, left: 4, bottom: 4, right:4)
        }else{
            if section == 0{
                return UIEdgeInsets (top: 0, left: 0, bottom: 0, right: 10)
            }else{
                return UIEdgeInsets (top: 4, left: 4, bottom: 4, right:4)
            }
        }
        
        
    }
    
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if MostPopularHomesData[indexPath.row].locations.count == 0 {
//            let selectedDesign = self.MostPopularHomesData[indexPath.row].houseName as? String ?? ""
//            let data = self.MostPopularHomesData[indexPath.row]
//            let homeDetailView = self.storyboard?.instantiateViewController(withIdentifier: "DisplayHomesDetailsVC") as! DisplayHomesDetailsVC
//            homeDetailView.displayDesigns = data
//            homeDetailView.indexOdDesigns = indexPath.row
//            homeDetailView.isFromDisplayHomes = true
//
//            self.navigationController?.pushViewController(homeDetailView, animated: true)
//        }else{
            openDesignsScreen(Index: indexPath.item)
//        }
      
    }
    func didTappedOnSuggestedHome(index: Int) {
        self.selectedDesign = self.DisplayHomeData[index]
        openSuggestedDetailsScreen()
    }
    func openDesignsScreen(Index : Int){
        if childVCsView.isHidden || !displaysCollectionView.isHidden {
            childVCsView.isHidden = false
            displaysCollectionView.isHidden = true
        }
        nearbyVCContainerView.isHidden = true
        designsVCContainerView.isHidden = true
        regionsVCContainerView.isHidden = true
        mapVCContainerView.isHidden = true
        designsVCContainerView.isHidden = false
        NotificationCenter.default.post(name: NSNotification.Name("tappedOnPopularHomeDesigns"), object: nil, userInfo: ["Key":true, "PopularHomeData" :MostPopularHomesData[Index] ])
    }
    
    func openSuggestedDetailsScreen(){
        if childVCsView.isHidden || !displaysCollectionView.isHidden {
            childVCsView.isHidden = false
            displaysCollectionView.isHidden = true
        }
        nearbyVCContainerView.isHidden = true
        designsVCContainerView.isHidden = true
        regionsVCContainerView.isHidden = true
        mapVCContainerView.isHidden = false
        NotificationCenter.default.post(name: NSNotification.Name("tappedOnSuggestedHomes"), object: nil, userInfo: ["Key":true,"suggestedHome" : self.selectedDesign! ])
    }
    
    
    func makeDisplayHomeFavorite (_ favorite: Bool, _ design: DisplayHomeModel, callBack: @escaping ((_ successss: Bool) -> Void)) {

        let params = NSMutableDictionary()
        params.setValue(SearchType.shared.newHomes, forKey: "TypeId")
        params.setValue(appDelegate.userData?.user?.userID, forKey: "UserId")
        params.setValue(design.id, forKey: "HouseId")
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

// MARK:  API's

extension DisplaysVC{
    func getDisplayHomes () {
        
        if LocationServices.shared.isLocationServicesEnabled(){
            latitude = "\(LocationServices.shared.K_GETlocationCORD?.latitude ?? 0.0)"
            longitude = "\(LocationServices.shared.K_GETlocationCORD?.longitude ?? 0.0)"
           
            //For testing Used Static LatLongs
            
     /*       #if DEDEBUG
            if kUserState == "6"{
              latitude = "-33.653444"
                longitude = "150.886556"
            }else if kUserState == "11"{
                latitude = "-37.54162703279499"
                longitude = "143.782211641998"
            }else if kUserState == "4"{
                latitude = "-26.738111"
                longitude = "153.060833"
            }else if kUserState == "5"{
                latitude = "-35.092464"
                longitude = "138.870790"
            }
           
            #endif   */
            
            print("\(LocationServices.shared.K_GETlocationCORD?.latitude ?? 0.0)")
            print("\(LocationServices.shared.K_GETlocationCORD?.longitude ?? 0.0)")
        }else{
            LocationServices.shared.requestUsertoAllowLocationPermissions()
        }
       

        _ = Networking.shared.GET_request(url: ServiceAPI.shared.URL_HomeDisplay (Int(kUserState) ?? 0, "\(latitude)", "\(longitude)", Int(kUserID) ?? 0, "\("")", "",""), userInfo: nil, success: { (json, response) in
            
            if let result: AnyObject = json {
                let result = result as! NSDictionary
                if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {
                    if let result: AnyObject = json {
                        DispatchQueue.main.async {
                        
                        let getdisplaysbyId = result.value(forKey: "getdisplaysbyId") as! NSDictionary
                        
                        if (getdisplaysbyId.allKeys as! [String]).contains("SuggestedHomesDTOs") {
                            if (getdisplaysbyId.value(forKey: "SuggestedHomesDTOs") as AnyObject).isKind(of: NSArray.self){
                                self.DisplayHomeData = []
                                let packagesResult = getdisplaysbyId.value(forKey: "SuggestedHomesDTOs") as! [NSDictionary]
                                for package: NSDictionary in packagesResult {
                                    let suggestedData = DisplayHomeModel(package as! [String : Any])
                                    if let region = suggestedData.regionName {
                                        self.DisplayHomeData.append(suggestedData)
                                    }
                                }
                                print(self.DisplayHomeData)
                            }
                        }else { print(log: "no SuggestedHomesData found") }
                        if (getdisplaysbyId.allKeys as! [String]).contains("MostPopularHomesDTOs") {
                            if (getdisplaysbyId.value(forKey: "MostPopularHomesDTOs") as AnyObject).isKind(of: NSArray.self){
                                let packagesResult = getdisplaysbyId.value(forKey: "MostPopularHomesDTOs") as! [NSDictionary]
                                self.MostPopularHomesData = []
                                for package: NSDictionary in packagesResult {
                                    let popularData = PupularDisplays(package as! [String : Any])
                                    self.MostPopularHomesData.append(popularData)
                                }
                                print(self.DisplayHomeData)
                                DispatchQueue.main.async {
                                    self.displaysCollectionView.reloadData()
                                }
                            }
                        }else { print(log: "no Homes found") }
                            DispatchQueue.main.async {
                                self.displaysCollectionView.reloadData()
                            }
                        }
                        self.addBreadCrumb(from: "See one of our display homes")
                    }
                    
                    else {
                    }
                }
            }
        }, errorblock: { (error, isJSONerror) in

            if isJSONerror { }
            else { }

        }, progress: nil)

    }
}


