//
//  DesignsDetailsVC.swift
//  MyPlaceNew
//
//  Created by Mohan Kumar on 01/04/20.
//  Copyright © 2020 Burbank. All rights reserved.
//

import UIKit

class DesignsDetailsVC: HeaderVC {
    
    @IBOutlet weak var homeDetailView : UIView!
    @IBOutlet weak var plotView : UIView!
    @IBOutlet weak var enquireView : UIView!
    
    @IBOutlet weak var displayHomesTable : UITableView!
    
    @IBOutlet weak var pageControl : UIPageControl!
    @IBOutlet weak var imageScrollView : UIScrollView!
    
    
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var lBHouseName : UILabel!
    @IBOutlet weak var lBPrice : UILabel!
    
    @IBOutlet weak var lBBedrooms : UILabel!
    @IBOutlet weak var lBBathrooms : UILabel!
    @IBOutlet weak var lBParking : UILabel!
    
    @IBOutlet weak var btnFavorite : UIButton!
    
    @IBOutlet weak var lBLot : UILabel!
    @IBOutlet weak var lBLotWidth : UILabel!
    
    @IBOutlet weak var scrollViewHouseDesign : UIScrollView!
    @IBOutlet weak var imageHouseDesign : UIImageView! //floor plan
    
    
    
    @IBOutlet weak var btnMyPlace : UIButton!
    @IBOutlet weak var btnHomeLand : UIButton!
    
    @IBOutlet weak var lBMyPlace : UILabel!
    @IBOutlet weak var lBHomeLand : UILabel!
    
    
    @IBOutlet weak var facadeTop1: NSLayoutConstraint!
    @IBOutlet weak var facadeTop2: NSLayoutConstraint!
    
    @IBOutlet weak var lBFacadeName : UILabel!
//    @IBOutlet weak var btnSaveDesign : UIButton!

    
    @IBOutlet weak var lBOnDisplay : UILabel!
    
    
    @IBOutlet weak var btnEnquire : UIButton!
    @IBOutlet weak var btnSaveDesign: UIButton!
    
//    @IBOutlet weak var previousDesignBTN: UIButton!
//    @IBOutlet weak var nextDesignBTN: UIButton!
    @IBOutlet weak var previousDesignBTN2: UIButton!
    @IBOutlet weak var nextDesignBTN2: UIButton!
    var selectedDesignCount = 0
    
  
  var validFacadeNamesArray = [String]()
    var containerViewRegion: UIView?
    
    lazy var regionView: RegionVC = {
        kStoryboardMain.instantiateViewController(withIdentifier: "RegionVC") as! RegionVC
    }()
    
    
    var regionSelected : RegionMyPlace?
    
    var selectedIndex = 0
    
    var myPlaceQuiz: MyPlaceQuiz?
    
    
    var homeDesign: HomeDesigns?   
    var homeDesignDetails: HomeDesignDetails?
    var arrHomeDesignsDetails = [HomeDesigns] ()
    
    var arrScrollImageUrls = [String] ()
    var arrOnDisplay = [Any] ()
    
    var isFromFavorites: Bool = false
    
    
    var displayText: String? {
        didSet {
            self.addBreadCrumb(from: displayText ?? "")
        }
    }
    
    var designCount : Int?
    //MARK: - ViewLife Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        CodeManager.sharedInstance.sendScreenName(burbank_homeDesigns_detailView_screen_loading)
        
        if kUserRegion != String.zero(), let regions = kStateRegions {
            for reg in regions {
                if kUserRegion == reg.regionId {
                    regionSelected = reg
                    break
                }
            }
        }
        
        
        
        adjustTableHeight ()
        
        pageUISetup()
        
        headerLogoText = "HomeDesigns"
        
        if btnBack.isHidden {
            showBackButton()
            btnBack.addTarget(self, action: #selector(handleBackButton(_:)), for: .touchUpInside)
            btnBackFull.addTarget(self, action: #selector(handleBackButton(_:)), for: .touchUpInside)
        }
        
        
        
        if let design = homeDesign {
            fillAllDetails ()
            
            getDesignDetails(design)
        }
        
        if isFromFavorites {
            addHeaderOptions(sort: false, map: false, favourites: false, howWorks: false, delegate: self)
        }else {
            addHeaderOptions(sort: false, map: false, favourites: true, howWorks: false, reset: true,totalCount: true,  delegate: self)
        }
        
        if selectedDesignCount >= arrHomeDesignsDetails.count - 1{
           
            self.nextDesignBTN2.isHidden = true
        }else{
           
            self.nextDesignBTN2.isHidden = true
        }
        if selectedDesignCount <= 0{
           
            self.previousDesignBTN2.isHidden = true
        }else{
           
            self.previousDesignBTN2.isHidden = false
        }
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
            swipeRight.direction = .right
            self.view.addGestureRecognizer(swipeRight)

            let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
            swipeDown.direction = .left
            self.view.addGestureRecognizer(swipeDown)
        
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {

        if let swipeGesture = gesture as? UISwipeGestureRecognizer {

            switch swipeGesture.direction {
            case .right:
                print("Swiped right")
                
                if selectedDesignCount <= 0{
                    self.previousDesignBTN2.isHidden = true
                }else{
                    homeDesign = arrHomeDesignsDetails[selectedDesignCount - 1]
                    selectedDesignCount = selectedDesignCount - 1
                    if let design = homeDesign {
                        fillAllDetails ()
                        getDesignDetails(design)
                    }
                }
                
               

            case .left:
                print("Swiped left")
                if selectedDesignCount >= arrHomeDesignsDetails.count - 1{
                    self.nextDesignBTN2.isHidden = true
                }else{
                    homeDesign = arrHomeDesignsDetails[selectedDesignCount + 1]
                    selectedDesignCount = selectedDesignCount + 1
                    if let design = homeDesign {
                        fillAllDetails ()
                        getDesignDetails(design)
                    }
                    
                }

            default:
                break
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let filter = displayText {
            if filter.count > 0 {
                self.addBreadCrumb(from: filter)
                self.btnTotalCollectionCount.setTitle("    TOTAL \(designCount ?? 0) DESIGNS    ", for: .normal)
            }else {
                self.addBreadCrumb(from: infoStaicText)
            }
        }
        
        
        if isFromFavorites
        {
            headerLogoText = "MyFavourites"
          
        }
//        if let design = homeDesign {
//            self.addBreadCrumb (from: (design.houseName ?? "") + " " + (design.houseSize ?? ""))
//        }
        
    }
    
    //MARK: - View
    
    func fillAllDetails () {
//      validFacadeNamesArray = homeDesignDetails?.lsthouses?.validFacades?.components(separatedBy: "|")
        if let imageurl = homeDesign?.facadePermanentUrl {
            
            arrScrollImageUrls.removeAll()
            arrScrollImageUrls.append(ServiceAPI.shared.URL_imageUrl(imageurl))
            
            bannerImageScroll (arrScrollImageUrls)
        }
        
//        self.lBPrice.text = String.currencyFormate(Int32(self.homeDesign!.price!)!)  // -------> v2.2 changes 
        
        self.lBPrice.isHidden = true // -------> v2.2 changes
      //CodeManager.sharedInstance.sendScreenName("BB_HomeDesign_NameAndSize_\(self.homeDesign?.houseName ?? "")_design,\(self.homeDesign?.houseSize ?? "")")
        Analytics.logEvent("BB_profile_HomeDesign_NameAndSize", parameters: ["name" : self.homeDesign?.houseName ?? "","size" : self.homeDesign?.houseSize ?? "","jobID" : appDelegate.currentUser?.jobNumber ?? "0"])
        self.lBHouseName.text = (self.homeDesign?.houseName ?? "") + " " + (self.homeDesign?.houseSize ?? "")
        self.lBBedrooms.text = self.homeDesign!.bedRooms
        self.lBBathrooms.text = self.homeDesign!.bathRooms
        self.lBParking.text = self.homeDesign!.carSpace
        
        if displayText == "Take a quick survey to find your perfect design"{
//        if Int(kUserID)! == 0{
            self.addBreadCrumb (from: (self.homeDesign?.houseName ?? "") + " " + (self.homeDesign?.houseSize ?? ""))

//        }
        }
        
        
        self.lBLotWidth.text = (self.homeDesign?.minLotWidth?.trim() ?? "0") + "m"

        
        if Int(kUserID)! > 0 { // LoggedInUser
            self.btnFavorite.setImage(self.homeDesign!.isFav == true ? imageFavorite : imageUNFavorite, for: .normal)
            self.btnSaveDesign.backgroundColor = self.homeDesign?.isFav == true ? APPCOLORS_3.LightGreyDisabled_BG : APPCOLORS_3.Orange_BG
            
        }else { // Guest User
        
            self.btnFavorite.setImage(imageUNFavorite, for: .normal)
            self.btnSaveDesign.backgroundColor = APPCOLORS_3.Orange_BG
        }
        
       // self.btnSaveDesign.isHidden = self.btnFavorite.isHidden
        
     

        enquireView.isHidden = arrOnDisplay.count == 0
        
        
        if let designDetails = self.homeDesignDetails {
            
            arrScrollImageUrls.removeAll()
            
            if let imageurl = designDetails.lsthouses?.facadeLargeImageUrls {
                for imagURL in imageurl {
                    let imageArr = imagURL.components(separatedBy: "_")
                    let imageName = imageArr[1].replacingOccurrences(of: ".jpg", with: "")
                    print("--=-=---=-=-=-=-=-: ",imageName)
                    validFacadeNamesArray.append(imageName )
                    arrScrollImageUrls.append(imagURL)
                    bannerImageScroll (arrScrollImageUrls)
                }
            }
            
            if let floorplanURL = designDetails.lsthouses?.homePlan?.floorPlanImageURLMobile {
                
                self.imageHouseDesign.showActivityIndicator()
                
                ImageDownloader.downloadImage(withUrl: floorplanURL, withFilePath: nil, with: { (image, success, error) in
                    
                    self.imageHouseDesign.hideActivityIndicator()
                    
                    if success, let img = image {
                        // processpixels method used to change image colors --> black to white
                        self.imageHouseDesign.image = processPixels(in: img)
                        let scrollView = self.scrollViewHouseDesign
                        scrollView?.delegate = self
                        scrollView?.minimumZoomScale = 1.0
                        scrollView?.maximumZoomScale = 10.0
                    }
                    
                }, withProgress: nil)
            }
            
        }
        
        if let subViews3D = self.btnMyPlace.superview?.subviews {
            for vi in subViews3D {
                vi.isHidden = !(self.homeDesign?.visualisation ?? false)
            }
        }
        
        if (enquireView.isHidden) {
            facadeTop1.isActive = true
            facadeTop2.isActive = false
        }else {
            facadeTop1.isActive = false
            facadeTop2.isActive = true
        }
        
        lBFacadeName.text = self.validFacadeNamesArray.first
        
        if ((lBFacadeName.text?.lowercased().contains("facade") ?? false) == false) {
//            lBFacadeName.text = (self.homeDesignDetails?.lsthouses?.facade ?? "") + " facade"
            lBFacadeName.text = (self.validFacadeNamesArray.first ?? "").capitalized + " Facade"
          
          
        }
     
        self.previousDesignBTN2.tintColor = .darkGray
        self.nextDesignBTN2.tintColor = .darkGray
        
        if selectedDesignCount >= arrHomeDesignsDetails.count - 1{
  
            self.nextDesignBTN2.isHidden = true
        }else{
         
            self.nextDesignBTN2.isHidden = false
        }
        if selectedDesignCount <= 0{
          
            self.previousDesignBTN2.isHidden = true
        }else{
           
            self.previousDesignBTN2.isHidden = false
        }
        
        if isFromFavorites
        {
            self.addBreadCrumb(from: (homeDesignDetails?.lsthouses?.houseName ?? "") + " " + "\(homeDesignDetails?.lsthouses?.houseSize ?? 0)")
        }
    }
    
    
    
    func bannerImageScroll(_ arrImageUrls: [String]) {
        
        self.imageScrollView.frame = CGRect(x:0, y:0, width:self.plotView.frame.width, height:self.plotView.frame.height)
        
        let scrollViewWidth:CGFloat = UIScreen.screens[0].bounds.size.width
        let scrollViewHeight:CGFloat = 0.265*UIScreen.screens[0].bounds.size.height // self.plotView.frame.height
        
        for imageview in imageScrollView.subviews {
            imageview.removeFromSuperview()
        }
        
        self.imageScrollView.contentSize = CGSize(width: 0, height: 0)
        
        var xPos: CGFloat = 0
        
        
        for imageUrl in arrImageUrls {
            
            let imgOne = UIImageView(frame: CGRect(x: xPos, y: 0, width: scrollViewWidth, height: scrollViewHeight))
            self.imageScrollView.addSubview(imgOne)
            
            imgOne.showActivityIndicator()
            
            ImageDownloader.downloadImage(withUrl: ServiceAPI.shared.URL_imageUrl(imageUrl), withFilePath: nil, with: { (image, success, error) in
                
                imgOne.hideActivityIndicator()
                
                imgOne.contentMode = .scaleToFill
                
                if let img = image {
                    imgOne.image = img
                }else {
                    imgOne.image = UIImage (named: "BG-Half")
                }
                
            }) { (progress) in
                
            }
            
            
            xPos = xPos + scrollViewWidth
            
        }
        
        
        self.imageScrollView.contentSize = CGSize(width: scrollViewWidth * CGFloat (arrImageUrls.count), height: scrollViewHeight)
        
        self.imageScrollView.delegate = self
        self.pageControl.numberOfPages = arrImageUrls.count
        
        if arrImageUrls.count > 0 {
            self.pageControl.currentPage = 0
        }
        
        //Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(moveToNextPage), userInfo: nil, repeats: true)
    }
    
    
    private func addContainerViewRegion () {
        
        let viewContro =  self.tabBarController ?? self
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
        
        // add child view controller view to container
        
        viewContro.addChild(regionView)
        //            addChildViewController(controller)
        regionView.view.translatesAutoresizingMaskIntoConstraints = false
        containerViewRegion!.addSubview(regionView.view)
        
        NSLayoutConstraint.activate([
            regionView.view.leadingAnchor.constraint(equalTo: containerViewRegion!.leadingAnchor, constant: 0),
            regionView.view.trailingAnchor.constraint(equalTo: containerViewRegion!.trailingAnchor, constant: 0),
            regionView.view.topAnchor.constraint(equalTo: containerViewRegion!.topAnchor, constant: 0),
            regionView.view.bottomAnchor.constraint(equalTo: containerViewRegion!.bottomAnchor, constant: 0)
        ])
        
        regionView.view.backgroundColor = COLOR_CUSTOM_VIEWS_OVERLAY
        regionView.view.backgroundColor = COLOR_CLEAR
        
        
        regionView.didMove(toParent: viewContro)
        
        regionView.delegate = self
        
        containerViewRegion!.isHidden = true
        
    }
    
    
    //MARK: - Button Actions
    
    @IBAction func handleBackButton (_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func handlePreviousDesignButton (_ sender: UIButton) {
        UIView.transition(with: sender,
                          duration: 1.0,
                          options: .transitionCrossDissolve,
                          animations: { sender.isHighlighted = true },
                          completion: nil)
        
        if selectedDesignCount <= 0{
            
            self.previousDesignBTN2.isHidden = true
        }else{
//            self.previousDesignBTN.isHidden = false
            homeDesign = arrHomeDesignsDetails[selectedDesignCount - 1]
            selectedDesignCount = selectedDesignCount - 1
            if let design = homeDesign {
                fillAllDetails ()
                getDesignDetails(design)
            }
        }
        
    }
    
    @IBAction func handleNextDesignButton (_ sender: UIButton) {
        UIView.transition(with: sender,
                          duration: 1.0,
                          options: .transitionCrossDissolve,
                          animations: { sender.isHighlighted = true },
                          completion: nil)
       
        if selectedDesignCount >= arrHomeDesignsDetails.count - 1{
           
            self.nextDesignBTN2.isHidden = true
            
        }else{
//            self.nextDesignBTN.isHidden = false
            homeDesign = arrHomeDesignsDetails[selectedDesignCount + 1]
            selectedDesignCount = selectedDesignCount + 1
            if let design = homeDesign {
                fillAllDetails ()
                
                getDesignDetails(design)
            }
            
        }
       
    }
    @IBAction func handleMyPlaceButton (_ sender: UIButton) {
       
        //MARK: In v2.3 navigating myPlace3D to browser beacuase of webview issues

        
        CodeManager.sharedInstance.sendScreenName(burbank_homeDesigns_detailView_myPlace3d_button_touch)
        
        var state = kUserStateName.lowercased().trim().replacingOccurrences(of: " ", with: "-")
        if kUserStateName.contains("NSW & ACT"){
            state = "nsw"
        }
        guard let url = URL(string:"\(My_Place3DBASEURL)/\(state)/myplace3dmobile/housename.\(self.homeDesign?.houseName ?? "");housesize.\(self.homeDesign?.houseSize ?? "0")/") else { return }
        UIApplication.shared.open(url)
        
//        let myPlace3DVC = self.storyboard?.instantiateViewController(withIdentifier: "MyPlace3DVC") as! MyPlace3DVC
//        myPlace3DVC.url = "\(My_Place3DBASEURL)/\(state)/myplace3dmobile/housename.\(self.homeDesign?.houseName ?? "");housesize.\(self.homeDesign?.houseSize ?? "0")/"
//        self.tabBarController?.navigationController?.pushViewController(myPlace3DVC, animated: true)
        
    }
    
    @IBAction func handleHomeLandButton (_ sender: UIButton) {
        
        CodeManager.sharedInstance.sendScreenName(burbank_homeDesigns_detailView_homeAndLand_button_touch)
        
        if let design = homeDesign {
            getPackagesWithDesign(design)
        }
        
    }
    
    @IBAction func handleEnquireButton (_ sender: UIButton) {
        
        CodeManager.sharedInstance.sendScreenName(burbank_homeDesigns_detailView_enquire_button_touch)
        
        let enquire = self.storyboard?.instantiateViewController(withIdentifier: "EnquireNowVC") as! EnquireNowVC
        enquire.homeDesign = self.homeDesign!
        if let navigation = self.tabBarController?.navigationController {
            navigation.pushViewController(enquire, animated: true)
        }else {
            self.navigationController?.pushViewController(enquire, animated: true)
        }
    }
    
    
    @IBAction func handleFavoriteButtonAction (_ sender: UIButton) {
        
        if noNeedofGuestUserToast(self, message: "Please login to add favourites") {
            
            CodeManager.sharedInstance.sendScreenName (burbank_homeDesigns_detailView_makeFavourite_button_touch)
            
            self.makeHomeDesignFavorite(!(homeDesign!.isFav), homeDesign!) { (success) in
                if success {
                    
                    if (!(self.homeDesign!.isFav) == true) {
                        DispatchQueue.main.async(execute: {
                            ActivityManager.showToast("Added to your favourites", self)
                        })
                    }else{
                        DispatchQueue.main.async(execute: {
                            ActivityManager.showToast("Item removed from favourites", self)
                        })
                    }
                    
                    self.homeDesign!.isFav = !(self.homeDesign!.isFav)
                    
                    self.btnFavorite.setImage(self.homeDesign!.isFav == true ? imageFavorite : imageUNFavorite, for: .normal)
                    
                    self.btnSaveDesign.isHidden = self.btnFavorite.isHidden
                    self.btnSaveDesign.backgroundColor = (self.homeDesign?.isFav ?? false) == true ? APPCOLORS_3.LightGreyDisabled_BG : APPCOLORS_3.Orange_BG
                    
                    
                   // if self.homeDesign!.favouritedUser?.userID == kUserID {

                    updateHomeDesignsFavouritesCount(self.homeDesign!.isFav == true)
                    //}
                }
            }
        }
    }
    
    @IBAction func handleSaveDesignButton (_ sender: UIButton) {
        if let _ = self.homeDesign {
            if Int(kUserID) ?? 0 > 0 { // if user loggedIn
                if (self.homeDesign?.isFav == true) {
                    
                    ActivityManager.showToast("Design saved in favourites", self)
                    
                }
                else {
                    self.handleFavoriteButtonAction(btnFavorite)
                }
            }else {
                self.handleFavoriteButtonAction(btnFavorite)
            }
        }
    }
    
}



extension DesignsDetailsVC: UITableViewDelegate, UITableViewDataSource {
    
    @objc func moveToNextPage (){
        
        let pageWidth:CGFloat = self.imageScrollView.frame.width
        let maxWidth:CGFloat = pageWidth * CGFloat (arrScrollImageUrls.count)
        let contentOffset:CGFloat = self.imageScrollView.contentOffset.x
        
        var slideToX = contentOffset + pageWidth
        
        if  contentOffset + pageWidth == maxWidth
        {
            slideToX = 0
        }
        self.imageScrollView.scrollRectToVisible(CGRect(x:slideToX, y:0, width:pageWidth, height:self.imageScrollView.frame.height), animated: true)
        let currentPage:CGFloat = floor((imageScrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        self.pageControl.currentPage = Int(currentPage);
    }
    
    //ScrollViewDelegate Methods
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        
        if scrollView == imageScrollView {
            if validFacadeNamesArray.count > 0{
                let pageWidth:CGFloat = scrollView.frame.width
                let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
                // Change the indicator
                lBFacadeName.text = self.validFacadeNamesArray[Int(currentPage)]
                
                if ((lBFacadeName.text?.lowercased().contains("facade") ?? false) == false) {
        //            lBFacadeName.text = (self.homeDesignDetails?.lsthouses?.facade ?? "") + " facade"
                    lBFacadeName.text = (self.lBFacadeName.text ?? "").capitalized + " Facade"
                  
                  
                }
                self.pageControl.currentPage = Int(currentPage);
            }
            
            // Test the offset and calculate the current page after scrolling ends
           
        }
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if scrollView == scrollViewHouseDesign {
            return imageHouseDesign
        }
        return nil
    }
    
    //MARK: - Table View Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOnDisplay.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeDesignTVCell", for: indexPath) as! HomeDesignTVCell
        
        // Configure the cell...
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(log: "Add row")
        
        if selectedIndex == indexPath.row {
            selectedIndex = -1
        }else {
            selectedIndex = indexPath.row
        }
        
        adjustTableHeight ()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if selectedIndex == indexPath.row {
            return 240
        }
        return 80
    }
    
    func adjustTableHeight () {
        
        tableHeight.constant = 0
        
    }
    
}



extension DesignsDetailsVC: ChildVCDelegate, RegionVCDelegate
{
    func handleActionFor(sort: Bool, map: Bool, favourites: Bool, howWorks: Bool, reset: Bool) {
        if reset{
            print("------- Reset myCollection Data")
            NotificationCenter.default.post(name: NSNotification.Name("handleResetDesignsBTN"), object: nil, userInfo: nil)
            if navigationController?.viewControllers.count == 1 {
                self.tabBarController?.navigationController?.popViewController(animated: true)
            }else {
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: MyCollectionSurveyVC.self) {
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
                
            }
        }
    }
    
    //headervc
//    func handleActionFor(sort: Bool, map: Bool, favourites: Bool, howWorks: Bool) {
//        
//        
//    }
    
    //RegionVCDelegate
    func handleRegionDelegate(close: Bool, regionBtn: Bool, region: RegionMyPlace) {
        
        if close {
            containerViewRegion!.isHidden = true
        }else {
            self.regionSelected = region
            
            containerViewRegion!.isHidden = true
        }
    }
}




extension DesignsDetailsVC {
    
    func pageUISetup () {
        
        self.view.backgroundColor = APPCOLORS_3.Body_BG
        setAppearanceFor(view: lBHouseName, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_SUB_HEADING(size: FONT_15))
        setAppearanceFor(view: lBPrice, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Orange_BG, textFont: FONT_LABEL_SUB_HEADING(size: FONT_12))
        
        
        setAppearanceFor(view: lBFacadeName, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_BODY(size: FONT_12))

        
        setAppearanceFor(view: lBParking, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_SUB_HEADING(size: FONT_10))
        setAppearanceFor(view: lBBedrooms, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_SUB_HEADING(size: FONT_10))
        setAppearanceFor(view: lBBathrooms, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_SUB_HEADING(size: FONT_10))
        
        
        setAppearanceFor(view: lBLot, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_LIGHT(size: FONT_6))
        setAppearanceFor(view: lBLotWidth, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_SUB_HEADING(size: FONT_8))
        
        
        setAppearanceFor(view: lBOnDisplay, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Orange_BG, textFont: FONT_LABEL_LIGHT(size: FONT_14))
        
        setAppearanceFor(view: btnEnquire, backgroundColor: APPCOLORS_3.Orange_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_BODY(size: FONT_14))
        setAppearanceFor(view: btnSaveDesign, backgroundColor: APPCOLORS_3.Orange_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_BODY(size: FONT_14))

//        lBMyPlace.text = "Interactive \nHome Tour"
//        lBHomeLand.text = "House & Land"
        
        setAppearanceFor(view: btnMyPlace, backgroundColor: APPCOLORS_3.DarkGrey_BG)
        setAppearanceFor(view: btnHomeLand, backgroundColor: APPCOLORS_3.DarkGrey_BG)
        
        
        _ = setAttributetitleFor(view: lBMyPlace, title: "Virtual Home Tour", rangeStrings: ["Virtual", "Home Tour"], colors: [APPCOLORS_3.HeaderFooter_white_BG, APPCOLORS_3.HeaderFooter_white_BG], fonts: [FONT_LABEL_BODY(size: FONT_16), FONT_LABEL_SUB_HEADING(size: FONT_16)], alignmentCenter: false)
        _ = setAttributetitleFor(view: lBHomeLand, title: "House&Land", rangeStrings: ["House","&","Land"], colors: [APPCOLORS_3.HeaderFooter_white_BG, APPCOLORS_3.HeaderFooter_white_BG,APPCOLORS_3.HeaderFooter_white_BG], fonts: [FONT_LABEL_SUB_HEADING(size: FONT_16), FONT_LABEL_BODY(size: FONT_13),FONT_LABEL_SUB_HEADING(size: FONT_16)], alignmentCenter: false)
        
        
        
        lBLot.text = "LOT\nWIDTH"
    
        if let superview = lBLot.superview {
            
            superview.layer.cornerRadius = (superview.frame.size.height)/2
            //            setShadow(view: superview, color: APPCOLORS_3.LightGreyDisabled_BG, shadowRadius: 8)
            setBorder(view: superview, color: APPCOLORS_3.GreyTextFont, width: 0.5)
            
            setAppearanceFor(view: lBLot, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_BODY (size: 6))
            setAppearanceFor(view: lBLotWidth, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_BODY (size: 10))
            
        }
        
        lBMyPlace.superview?.layer.cornerRadius = radius_10
        lBHomeLand.superview?.layer.cornerRadius = radius_10
        
    }
    
    
    //MARK: - APIs
    
    func getDesignDetails (_ design: HomeDesigns) {
        
        _ = Networking.shared.GET_request(url: ServiceAPI.shared.URL_HomeDesignDetails(kUserState, design.houseName ?? "", design.houseSize ?? ""), userInfo: nil, success: { (data, response) in
            
            if (response as! HTTPURLResponse).statusCode == 200, let jsonData = data as? Data {
                
                if let jsonObj: AnyObject = Networking.shared.jsonResponse(jsonData) {
                    if jsonObj is Error {
                        
                    }else {
                        print(log: jsonObj)
                        if let _ = (jsonObj as! NSDictionary).value(forKey: "status"), ((jsonObj as! NSDictionary).value(forKey: "status") as? Bool) == true {
                            
                            do {
                                self.homeDesignDetails = try JSONDecoder().decode(HomeDesignDetails.self, from: jsonData)
                                
                                self.fillAllDetails()
                                
                            } catch let jsonError {
                                print(log: jsonError)
                            }
                        }
                    }
                }
                
            }
            
        }, errorblock: { (error, isJSONerror) in
            
            
        }, progress: nil, showActivity: true, returnJSON: false)
        
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
    
    
    
    func getPackagesWithDesign (_ design: HomeDesigns) {
        
        
        _ = Networking.shared.GET_request(url: ServiceAPI.shared.URL_HomeLandPackagesWithDesign(kUserState, design.houseName ?? ""), userInfo: nil, success: { (json, response) in
            
            if let result: AnyObject = json {
                
                let result = result as! NSDictionary
                
                if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {
                    
                    
                    var arrHomeLandPackages = [HomeLandPackage] ()
                    
                    
                    if let homeLandPackages = result.value(forKey: "getpackagebyName") as? [NSDictionary] {
                        
                        for package in homeLandPackages {
                            arrHomeLandPackages.append(HomeLandPackage (package as! [String : Any]))
                        }
                        
                        if arrHomeLandPackages.count > 0 {
                            
                            let homeLand = kStoryboardMain.instantiateViewController(withIdentifier: "HomeLandVC") as! HomeLandVC
                            
                            homeLand.filter = SortFilter ()
                            
                            homeLand.isFromHomeDesigns = true
                            homeLand.isFromProfileFavorites = false
                            
                            homeLand.design = self.homeDesign
                            
                            homeLand.arrHomeLand = arrHomeLandPackages
                            
                            self.navigationController?.pushViewController(homeLand, animated: true)
                            
                        }else {
                            
                            ActivityManager.showToast("No Packages found", self, .bottom)
                        }
                    }else {
                        ActivityManager.showToast("No Packages found", self, .bottom)
                    }
                    
                }else {
                    
                    ActivityManager.showToast("Couldn't get details")
                }
            }else {
                
                ActivityManager.showToast(kServerErrorMessage)
            }
        }, errorblock: { (error, isJSONerror) in
            
            if isJSONerror {
                ActivityManager.showToast("Couldn't get details")
            }else {
                print(log: error?.localizedDescription as Any)
            }
            
            
        }, progress: nil)
        
    }
    
    
}


