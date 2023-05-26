//
//  DisplayHomesDetailsVC.swift
//  BurbankApp
//
//  Created by Naveen Kourampalli on 08/07/21.
//  Copyright © 2021 Sreekanth tadi. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class DisplayHomesDetailsVC: HeaderVC,GMSMapViewDelegate {
  @IBOutlet weak var navTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var headerConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var facadeViewHeightConstraint: NSLayoutConstraint!
    var isCameFromFavorites : Bool = false
    @IBOutlet weak var backBTN: UIButton!
    @IBOutlet weak var backIconBtn: UIButton!
    
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
    
    @IBOutlet weak var lBFacadeName : UILabel!
//    @IBOutlet weak var btnSaveDesign : UIButton!

   // @IBOutlet weak var facadeIMGHeight: NSLayoutConstraint!
    
    @IBOutlet weak var lBOnDisplay : UILabel!
    
    
    @IBOutlet weak var btnEnquire : UIButton!
    @IBOutlet weak var btnSaveDesign: UIButton!

    
    var containerViewRegion: UIView?
    
    lazy var regionView: RegionVC = {
        kStoryboardMain.instantiateViewController(withIdentifier: "RegionVC") as! RegionVC
    }()
    
    
    var regionSelected : RegionMyPlace?
    
    var selectedIndex = 0
    
    var myPlaceQuiz: MyPlaceQuiz?
    
    var isFromFavorites: Bool?
    var isFromHomeDesigns: Bool = false
    var design: HomeDesigns?

    
    var homeLandPackageDetails: HomeLandPackageDetails?

    var isFromDisplayHomes : Bool = false
    var displayHomes: houseDetailsByHouseType?
    var displayDesigns: PupularDisplays? {
        didSet {
            
        }
    }
    
    var isFave : Bool = false
    var desplayID = ""
    var popularHomedesplayID = ""
    var indexOdDesigns = 0
    var arrScrollImageUrls = [String] ()
    var arrOnDisplay = [Any] ()
    var homeDesignDetails: HomeDesignDetails?
    var validFacadeNamesArray = [String] ()
    
    var selected_EstateName = ""
   // var favouriteButtonCompletion : ((Bool) -> Void)? // Closure
    override func viewDidLoad() {
        super.viewDidLoad()

            backIconBtn.addTarget(self, action: #selector(handleBackButton(_:)), for: .touchUpInside)
            backBTN.addTarget(self, action: #selector(handleBackButton(_:)), for: .touchUpInside)
        if let package = displayHomes {
//            fillPackageData()
           
            self.isFave = package.isFav
            self.desplayID = package.displayId
            self.selected_EstateName = package.displayEstateName
            self.popularHomedesplayID = "0"
            pageUISetup()
            getDesignDetails(package.houseName, package.houseSize)
//            getPackageDetails(package)
//            mapViewGoogle.addZoomLevelButtons()
//            mapViewGoogle.setMapPosition(with: package, zoomlevel: 12.0)
//
//            mapViewGoogle.addMarkers(packages: [package])
        }
        if let package = displayDesigns {
//            fillPackageData()
            print(indexOdDesigns)
            self.isFave = package.IsFav ?? false
            self.popularHomedesplayID = package.id ?? ""
            self.desplayID = "0"
            pageUISetup()
            getDesignDetails(package.houseName ?? "", package.houseSize ?? "")
//            getPackageDetails(package)
//            mapViewGoogle.addZoomLevelButtons()
//            mapViewGoogle.setMapPosition(with: package, zoomlevel: 12.0)
//
//            mapViewGoogle.addMarkers(packages: [package])
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name("handleBackBtnNaviogation"), object: nil, queue: nil, using:updatedNotification)
      //---------Logic to Hide and show navigation bar(Navbar has to visible when comming from favorites)
        if isCameFromFavorites{
            // headerLogoText = "DisplayHomes"
             headerLogoText = "MyFavourites"
            headerConstraint.constant = 0
            navTopConstraint.constant = 135
          //  self.backBTN.isHidden = true
            self.backBTN.superview?.superview?.isHidden = true
            let displyBrdStr = "\(displayHomes?.houseName ?? "") \(displayHomes?.houseSize ?? "")"
            self.addBreadCrumb(from: displyBrdStr)
           // self.facadeIMGHeight = facadeIMGHeight.changeMultiplier(facadeIMGHeight, multiplier: 0.263)
            if btnBack.isHidden {
                showBackButton()
                btnBack.addTarget(self, action: #selector(handleNavBackBtn), for: .touchUpInside)
                btnBackFull.addTarget(self, action: #selector(handleNavBackBtn), for: .touchUpInside)
            }
            //  headerLogoText = "Favorites"
        }else {
        headerConstraint.constant = 50
         // self.facadeIMGHeight = facadeIMGHeight.changeMultiplier(facadeIMGHeight, multiplier: 0.45)
        navTopConstraint.constant = 0
        containerView?.isHidden = true
        headerView_header.isHidden = true
        headerViewHeight = 0
      
      }
        
    }
    
    
  @objc func handleNavBackBtn()
  {
    self.navigationController?.popViewController(animated: true)
  }
    func updatedNotification(notification:Notification) -> Void  {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func fillPackageData () {
        //CodeManager.sharedInstance.sendScreenName("BB_DisplayHomes_NameAndSize_\(self.homeDesignDetails?.lsthouses?.houseName ?? "")_design,\(self.homeDesignDetails?.lsthouses?.houseSize ?? 0)")
        Analytics.logEvent("BB_DisplayHomes_NameAndSize_", parameters: ["name" : self.homeDesignDetails?.lsthouses?.houseName ?? "","size" : self.homeDesignDetails?.lsthouses?.houseSize ?? ""])
//        validFacadeNamesArray = homeDesignDetails?.lsthouses?.validFacades?.components(separatedBy: "|")
        if let imageurl = homeDesignDetails?.lsthouses?.facadePermanentURL {
            
            arrScrollImageUrls.removeAll()
            arrScrollImageUrls.append(ServiceAPI.shared.URL_imageUrl(imageurl))
            
            bannerImageScroll (arrScrollImageUrls)
        }
        
        self.lBPrice.text = String.currencyFormate(Int32(self.homeDesignDetails?.lsthouses?.price ?? 0))
        
        self.lBHouseName.text = "\(self.homeDesignDetails?.lsthouses?.houseName ?? "")  \(self.homeDesignDetails?.lsthouses?.houseSize ?? 0)"
        self.lBBedrooms.text =  "\(self.homeDesignDetails?.lsthouses?.bedRooms ?? 0)"
        self.lBBathrooms.text = "\(self.homeDesignDetails?.lsthouses?.bathRooms ?? 0)"
        self.lBParking.text = "\(self.homeDesignDetails?.lsthouses?.carSpace ?? 0)"
        
        
        
        self.lBLotWidth.text = "\(self.homeDesignDetails?.lsthouses?.minLotWidth ?? 0.0) m"
//        let tex = (self.homeDesign!.minLotWidth ?? "0") + "m2"
        
//        let font:UIFont? = FONT_LABEL_SUB_HEADING(size: FONT_8)
//        let fontSuper:UIFont? = FONT_LABEL_SUB_HEADING(size: FONT_6)
//        let attString:NSMutableAttributedString = NSMutableAttributedString(string: tex, attributes: [.font:font!])
//        attString.setAttributes([.font:fontSuper!,.baselineOffset:4], range: NSRange(location:tex.count-1,length:1))
//        lBLotWidth.attributedText = attString

        
        
        
        
        self.btnFavorite.tintColor = APPCOLORS_3.GreyTextFont
        if Int(kUserID)! == 0 // Guest User
        {
            self.btnFavorite.setImage(imageUNFavorite, for: .normal)
            self.btnSaveDesign.backgroundColor = APPCOLORS_3.Orange_BG
            
        }else { // User logged In
            self.btnFavorite.setImage(self.isFave == true ? imageFavorite : imageUNFavorite, for: .normal)
            self.btnSaveDesign.backgroundColor = isFave == true ? APPCOLORS_3.LightGreyDisabled_BG : APPCOLORS_3.Orange_BG
            
        }
        
//        if Int(kUserID)! > 0 {
//
////            if self.isFave == true {
////                self.btnFavorite.setBackgroundImage(imageFavorite, for: .normal)
////            }else {
////                self.btnFavorite.setBackgroundImage(imageUNFavorite, for: .normal)
////            }
//
//            if isFromFavorites == true {
//                btnFavorite.isHidden = displayHomes?.favouritedUser?.userID != kUserID
//            }
//        }else {
//
//            self.btnFavorite.isHidden = true
//        }
        
       // self.btnSaveDesign.isHidden = self.btnFavorite.isHidden
//        self.btnSaveDesign.backgroundColor = isFave == true ? APPCOLORS_3.GreyTextFont : APPCOLORS_3.Orange_BG

        enquireView.isHidden = arrOnDisplay.count == 0
        
        
        if let designDetails = self.homeDesignDetails {

            arrScrollImageUrls.removeAll()

            if let imageurl = designDetails.lsthouses?.facadeLargeImageUrls {
                for imagURL in imageurl {
                    let imageArr = imagURL.components(separatedBy: "_")
                    let imageName = imageArr[1].replacingOccurrences(of: ".jpg", with: "")
                    print("--=-=---=-=-=-=-=-: ",imageName)
                    validFacadeNamesArray.append(imageName)
                    arrScrollImageUrls.append(imagURL)
                    bannerImageScroll (arrScrollImageUrls)
                }
                
                print(validFacadeNamesArray)
                lBFacadeName.text = self.validFacadeNamesArray.first
                if ((lBFacadeName.text?.lowercased().contains("facade") ?? false) == false) {
                  lBFacadeName.text = (self.validFacadeNamesArray.first ?? "") + " Facade"
                  
                  
                }
            }

            if let floorplanURL = homeDesignDetails?.lsthouses?.homePlan?.floorPlanImageURLMobile {

                self.imageHouseDesign.showActivityIndicator()

                ImageDownloader.downloadImage(withUrl: floorplanURL, withFilePath: nil, with: { (image, success, error) in

                    self.imageHouseDesign.hideActivityIndicator()

                    if success, let img = image {
                        self.imageHouseDesign.image = processPixels(in: img)

                        let scrollView = self.scrollViewHouseDesign
                        scrollView?.delegate = self
                        scrollView?.minimumZoomScale = 1.0
                        scrollView?.maximumZoomScale = 10.0
                    }

                }, withProgress: nil)
            }

        }
        
//        if let subViews3D = self.btnMyPlace.superview?.subviews {
//            for vi in subViews3D {
//                vi.isHidden = !(self.homeDesignDetails?.lsthouses?.visualisation ?? false)
//            }
//        }
       
        if self.homeDesignDetails?.lsthouses?.visualisation == false
        {
            btnMyPlace.backgroundColor = .clear
            btnMyPlace.superview?.backgroundColor = .clear
            lBMyPlace.textColor = .clear
            btnMyPlace.isUserInteractionEnabled = false
        
        }else
        {
            btnMyPlace.isUserInteractionEnabled = true
        }
        if (enquireView.isHidden) {
            facadeTop1.isActive = true
        }else {
            facadeTop1.isActive = false
        }
    
        
    }
    func getPackageDetails (_ design: houseDetailsByHouseType) {
        
        _ = Networking.shared.GET_request(url: ServiceAPI.shared.URL_packageDetails(self.displayHomes?.houseId_LandBank ?? ""), userInfo: nil, success: { (data, response) in
            
            if (response as! HTTPURLResponse).statusCode == 200, let jsonData = data as? Data {
                
                if let jsonObj: AnyObject = Networking.shared.jsonResponse(jsonData) {
                    if jsonObj is Error {
                        
                    }else {
                        print(log: jsonObj)
                        if let _ = (jsonObj as! NSDictionary).value(forKey: "status"), ((jsonObj as! NSDictionary).value(forKey: "status") as? Bool) == true {
                            
                            do {
                                self.homeLandPackageDetails = try JSONDecoder().decode(HomeLandPackageDetails.self, from: jsonData)
                                
                                self.fillPackageData()
                                
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
    
    @IBAction func handleBackButton (_ sender: UIButton) {

        self.navigationController?.popViewController(animated: true)

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
extension DisplayHomesDetailsVC{
   
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
            
            let imgOne = UIImageView(frame: CGRect(x: xPos, y: 0, width: scrollViewWidth, height: self.plotView.frame.height))
            self.imageScrollView.addSubview(imgOne)
            
            imgOne.showActivityIndicator()
            
            ImageDownloader.downloadImage(withUrl: ServiceAPI.shared.URL_imageUrl(imageUrl), withFilePath: nil, with: { (image, success, error) in
                
                imgOne.hideActivityIndicator()
                
                var imageHeight = (image?.size.height)!
                var imageWidth = (image?.size.width)!
                var plotViewWidth = self.plotView.frame.width
                var plotViewHeight = self.plotView.frame.height
                var imageRatio = imageWidth/imageHeight
                var platViewRatio = plotViewWidth/plotViewHeight
                let heightRatio = imageRatio/platViewRatio
//                self.facadeViewHeightConstraint.constant = heightRatio
//                    imgOne = UIImageView(frame: CGRect(x: xPos, y: 0, width: self.plotView.frame.width, height: heightRatio))
                if heightRatio > 0.9{
                    imgOne.contentMode = .scaleAspectFit
                }else{
                    imgOne.contentMode = .scaleToFill
                }
                if let img = image {
                    imgOne.image = img
                }else {
                    imgOne.image = UIImage (named: "BG-Half")
                }
//                self.facadeViewHeightConstraint.constant = imageHeight
                
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
        
//        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(moveToNextPage), userInfo: nil, repeats: true)
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
    @IBAction func handleMyPlaceButton (_ sender: UIButton) {
        
        //MARK: In v2.3 navigating myPlace3D to browser beacuase of webview issues
        
        
        CodeManager.sharedInstance.sendScreenName(burbank_DisplayHomes_detailView_myPlace3d_screen_loading)
        var state = kUserStateName.lowercased().trim().replacingOccurrences(of: " ", with: "-")
        if kUserStateName.contains("NSW & ACT"){
            state = "nsw"
        }
        
        guard let url = URL(string:"\(My_Place3DBASEURL)/\(state)/myplace3dmobile/housename.\(self.homeDesignDetails?.lsthouses?.houseName ?? "");housesize.\(self.homeDesignDetails?.lsthouses?.houseSize ?? 0)/") else { return }
        UIApplication.shared.open(url)
        
//        let myPlace3DVC = self.storyboard?.instantiateViewController(withIdentifier: "MyPlace3DVC") as! MyPlace3DVC
//        myPlace3DVC.url = "\(My_Place3DBASEURL)/\(state)/myplace3dmobile/housename.\(self.homeDesignDetails?.lsthouses?.houseName ?? "");housesize.\(self.homeDesignDetails?.lsthouses?.houseSize ?? 0)/"
//        print("\(My_Place3DBASEURL)/\(state)/myplace3dmobile/housename.\(self.homeDesignDetails?.lsthouses?.houseName ?? "");housesize.\(self.homeDesignDetails?.lsthouses?.houseSize ?? 0)/")
//        self.tabBarController?.navigationController?.pushViewController(myPlace3DVC, animated: true)
        
    }
    
    @IBAction func handleHomeLandButton (_ sender: UIButton) {
        
        CodeManager.sharedInstance.sendScreenName(burbank_DisplayHomes_detailView_HomeAndLand_BTN_screen_loading)
        
        if let design = displayHomes {
            getPackagesWithDesign(design)
        }
        
    }
    
    @IBAction func handleEnquireButton (_ sender: UIButton) {
        
        CodeManager.sharedInstance.sendScreenName(burbank_DisplayHomes_detailView_enquire_button_touch)
        
        let enquire = self.storyboard?.instantiateViewController(withIdentifier: "EnquireNowVC") as! EnquireNowVC
        enquire.homeDesignDetails = self.homeDesignDetails
        enquire.selected_Estate = self.selected_EstateName
        if let navigation = self.tabBarController?.navigationController {
            navigation.pushViewController(enquire, animated: true)
        }else {
            self.navigationController?.pushViewController(enquire, animated: true)
        }
    }
    
    
    @IBAction func handleFavoriteButtonAction (_ sender: UIButton) {
        
        if noNeedofGuestUserToast(self, message: "Please login to add favourites") {
            
            CodeManager.sharedInstance.sendScreenName (burbank_DisplayHomes_detailView_makeFavourite_button_touch)
            
            self.makeDisplayHomeFavorite(!(isFave), desplayID, self.popularHomedesplayID) { (success) in
                if success {
                    
                    if (!(self.isFave) == true) {
                        DispatchQueue.main.async(execute: {
                            ActivityManager.showToast("Added to your favourites", self)
                        })
                        self.isFave = true
                    }else{
                           DispatchQueue.main.async(execute: {
                               ActivityManager.showToast("Item removed from favourites", self)
                           })
                        self.isFave = false
                    }
                  //  self.favouriteButtonCompletion?(self.isFave)
//                    self.homeDesignDetails?.lsthouses?.isFav = !((self.homeDesignDetails?.lsthouses?.isFav)!)
                        
//                        = !((self.homeDesignDetails?.lsthouses?.isFav!)!)
                    
                    self.btnFavorite.setImage(self.isFave == true ? imageFavorite : imageUNFavorite, for: .normal)
                    
                   // self.btnSaveDesign.isHidden = self.btnFavorite.isHidden
                    self.btnSaveDesign.backgroundColor = (self.isFave ) == true ? APPCOLORS_3.LightGreyDisabled_BG : APPCOLORS_3.Orange_BG
                    
                    
//                    if self.homeDesignDetails?.userID == kUserID {
                    updateDisplayHomesFavouritesCount(self.isFave == true)
//                    }
                }
            }
        }
    }
    
    @IBAction func handleSaveDesignButton (_ sender: UIButton) {
        if let _ = self.displayHomes {
            if Int(kUserID) ?? 0 > 0 { // User logged In
                if (self.isFave == true) {
                    
                    ActivityManager.showToast("Design already saved in favourites", self)
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
extension DisplayHomesDetailsVC: ChildVCDelegate, RegionVCDelegate
{
    //headervc
    func handleActionFor(sort: Bool, map: Bool, favourites: Bool, howWorks: Bool, reset: Bool) {
        
    }
    
   
    
    
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


extension DisplayHomesDetailsVC: UITableViewDelegate, UITableViewDataSource{
    
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
        self.lBFacadeName.text = self.validFacadeNamesArray[Int(currentPage)]
        if ((lBFacadeName.text?.lowercased().contains("facade") ?? false) == false) {
          lBFacadeName.text = (lBFacadeName.text ?? "") + " Facade"
          
          
        }
    }
    
    //ScrollViewDelegate Methods
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        
        if scrollView == imageScrollView {
            
            // Test the offset and calculate the current page after scrolling ends
            let pageWidth:CGFloat = scrollView.frame.width
            let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
            // Change the indicator
          self.lBFacadeName.text = self.validFacadeNamesArray[Int(currentPage)]
          
          if ((lBFacadeName.text?.lowercased().contains("facade") ?? false) == false) {
  //            lBFacadeName.text = (self.homeDesignDetails?.lsthouses?.facade ?? "") + " facade"
            lBFacadeName.text = (lBFacadeName.text ?? "") + " Facade"
            
            
          }
            self.pageControl.currentPage = Int(currentPage);
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
extension DisplayHomesDetailsVC {
    
    func pageUISetup () {
        
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

        setAppearanceFor(view: backBTN, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Orange_BG, textFont: FONT_BUTTON_BODY(size: FONT_14))
        
//        lBMyPlace.text = "Interactive \nHome Tour"
//        lBHomeLand.text = "House & Land"
        
        _ = setAttributetitleFor(view: lBMyPlace, title: "Virtual Home Tour", rangeStrings: ["Virtual", "Home Tour"], colors: [APPCOLORS_3.HeaderFooter_white_BG, APPCOLORS_3.HeaderFooter_white_BG], fonts: [FONT_LABEL_BODY(size: FONT_16), FONT_LABEL_SUB_HEADING(size: FONT_16)], alignmentCenter: false)
        _ = setAttributetitleFor(view: lBHomeLand, title: "House&Land", rangeStrings: ["House","&","Land"], colors: [APPCOLORS_3.HeaderFooter_white_BG, APPCOLORS_3.HeaderFooter_white_BG,APPCOLORS_3.HeaderFooter_white_BG], fonts: [FONT_LABEL_SUB_HEADING(size: FONT_16), FONT_LABEL_BODY(size: FONT_16),FONT_LABEL_SUB_HEADING(size: FONT_16)], alignmentCenter: false)
        
        
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
    
    func getDesignDetails (_ designHouseName: String, _ designHouseSize : String ) {

        _ = Networking.shared.GET_request(url: ServiceAPI.shared.URL_HomeDesignDetails(kUserState, designHouseName , designHouseSize), userInfo: nil, success: { (data, response) in

            if (response as! HTTPURLResponse).statusCode == 200, let jsonData = data as? Data {

                if let jsonObj: AnyObject = Networking.shared.jsonResponse(jsonData) {
                    if jsonObj is Error {

                    }else {
                        print(log: jsonObj)
                        if let _ = (jsonObj as! NSDictionary).value(forKey: "status"), ((jsonObj as! NSDictionary).value(forKey: "status") as? Bool) == true {

                            do {
                                self.homeDesignDetails = try JSONDecoder().decode(HomeDesignDetails.self, from: jsonData)

                                self.fillPackageData()

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
    
    
    func makeDisplayHomeFavorite (_ favorite: Bool, _ design: String, _ popularHomeDisplayId : String, callBack: @escaping ((_ successss: Bool) -> Void)) {
        
        let params = NSMutableDictionary()
        params.setValue(3, forKey: "TypeId")
        params.setValue(appDelegate.userData?.user?.userID, forKey: "UserId")
        params.setValue(design, forKey: "HouseId")
        params.setValue(kUserState, forKey: "StateId")
        params.setValue(favorite, forKey: "isfavourite")
        params.setValue(popularHomeDisplayId,forKey: "PopularHouseId")
        
        
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
    
    
    
    func getPackagesWithDesign (_ design: houseDetailsByHouseType) {
        
        
        _ = Networking.shared.GET_request(url: ServiceAPI.shared.URL_HomeLandPackagesWithDesign(kUserState, design.houseName ), userInfo: nil, success: { (json, response) in
            
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
                            homeLand.addBreadCrumb(from: design.houseName)
                            homeLand.isFromHomeDesigns = true
                            homeLand.isFromProfileFavorites = false
                            
//                            homeLand.design = self.homeDesign
                            
                            homeLand.arrHomeLand = arrHomeLandPackages
                            self.tabBarController?.navigationController?.pushViewController(homeLand, animated: true)
//                            self.navigationController?.pushViewController(homeLand, animated: true)
                            
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
