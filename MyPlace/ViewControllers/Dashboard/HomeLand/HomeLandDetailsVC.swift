//
//  HomeLandDetailsVC.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 03/04/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import GoogleMaps


class HomeLandDetailsVC: HeaderVC {

    @IBOutlet weak var homeDetailView : UIView!
    @IBOutlet weak var plotView : UIView!
    @IBOutlet weak var homeMapView : UIView!
    @IBOutlet weak var enquireView : UIView!
    
    
    @IBOutlet weak var mapViewGoogle : MyPlaceMap!

    
    @IBOutlet weak var viewMapExpanded: UIView!
    @IBOutlet weak var mapViewGoogleExpanded : MyPlaceMap!
    @IBOutlet weak var btnClose: UIButton!

    
    
    @IBOutlet weak var imageHouse : UIImageView!
    @IBOutlet weak var activity: UIActivityIndicatorView!

    @IBOutlet weak var lBHouseName : UILabel!
    @IBOutlet weak var lBFacadeName : UILabel!
    @IBOutlet weak var lBAddress : UILabel!
    @IBOutlet weak var lBPrice : UILabel!
    @IBOutlet weak var lBBedrooms : UILabel!
    @IBOutlet weak var lBBathrooms : UILabel!
    @IBOutlet weak var lBParking : UILabel!
    @IBOutlet weak var lBLandSize : UILabel!
//    @IBOutlet weak var lBLandSize_size : UILabel!
    @IBOutlet weak var btnFavorite : UIButton!
    
    @IBOutlet weak var lBLinePrice : UILabel!
//    @IBOutlet weak var lBLineSize : UILabel!

    
    @IBOutlet weak var imageDesign : UIImageView!

    
    
    @IBOutlet weak var imageEstateLogo : UIImageView!
    @IBOutlet weak var lBEstateFacadeName : UILabel!
    @IBOutlet weak var lBEstateAddress : UILabel!

    
    @IBOutlet weak var btnEnquire : UIButton!
    @IBOutlet weak var btnSaveDesign: UIButton!

    var isFromFavorites: Bool = false
    
    var isFromHomeDesigns: Bool = false
    var design: HomeDesigns?

    
    
    var myPlaceQuiz: MyPlaceQuiz?

    var homeLand: HomeLandPackage? {
        didSet {
            
        }
    }
    
    var homeLandPackageDetails: HomeLandPackageDetails?

    var isFromDisplayHomes : Bool = false
    var displayHomes: houseDetailsByHouseType? {
        didSet {
            
        }
    }
    
    //MARK: - ViewLife Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

       
        if isFromDisplayHomes {
            headerLogoText = "House&Land"
        }else{
            headerLogoText = "House&Land"
        }
        CodeManager.sharedInstance.sendScreenName(burbank_homeAndLand_detailView_screen_loading)
        
        pageUISetup ()
        
        if btnBack.isHidden {
            showBackButton()
            btnBack.addTarget(self, action: #selector(handleBackButton(_:)), for: .touchUpInside)
            btnBackFull.addTarget(self, action: #selector(handleBackButton(_:)), for: .touchUpInside)
        }

        self.addHeaderOptions(favourites: true, delegate: self)
        if let package = homeLand {
            fillPackageData()
            
            getPackageDetails(package)
            
//            mapViewGoogle.addZoomLevelButtons()
            mapViewGoogle.setMapPosition(with: package, zoomlevel: 12.0)
            
            mapViewGoogle.addMarkers(packages: [package])
        }
        
        viewMapExpanded.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isFromFavorites {
            headerLogoText = "MyFavourites"
        }
                               
        if let homeLand = homeLand {
            
            self.addBreadCrumb(from: (homeLand.houseName ?? "") + " " + (homeLand.houseSize ?? ""))
        }
        else {
            if isFromHomeDesigns {
                
                if let houseName = self.design?.houseName {
                    if houseName.count > 0 {
                        self.addBreadCrumb(from: houseName + " " + (self.design?.houseSize ?? ""))
                    }
                }
            }else if isFromDisplayHomes{
                if let houseName = self.displayHomes?.houseName {
                    if houseName.count > 0 {
                        self.addBreadCrumb(from: houseName + " " + (self.displayHomes?.houseSize ?? ""))
                    }
                }
            }
            else {
                guard let filter = myPlaceQuiz else {
                    myPlaceQuiz = MyPlaceQuiz()
                    return
                }
                self.addBreadCrumb(from: filter.filterStringDisplayHomes())
            }
        }
        
    }
    
    
    func fillPackageData () {
        
      //CodeManager.sharedInstance.sendScreenName("BB_HomeAndLand_NameAndSize_\(self.homeLand?.houseName ?? "")_design,\(self.homeLand?.houseSize ?? "")")
        Analytics.logEvent("BB_HomeAndLand_NameAndSize_", parameters: ["name" : self.homeLand?.houseName ?? "","size" : self.homeLand?.houseSize ?? "","jobID" : appDelegate.currentUser?.jobNumber ?? "0"])
        self.lBHouseName.text = (self.homeLand?.houseName ?? "") + " " + (self.homeLand?.houseSize ?? "")
        self.lBFacadeName.text = self.homeLand?.facade ?? ""
      self.lBAddress.text = self.homeLand?.address?.replacingOccurrences(of: " ,", with: ",").replacingOccurrences(of: " ,", with: ",").replacingOccurrences(of: " ,", with: ",").replacingOccurrences(of: " ,", with: ",") //replace " ," with "," until we remove 4 spaces infront of ","

        self.lBPrice.text = String.currencyFormate(Int32(self.homeLand?.price ?? "")!)

        self.lBBedrooms.text = self.homeLand?.bedRooms ?? ""
        self.lBBathrooms.text = self.homeLand?.bathRooms ?? ""
        self.lBParking.text = self.homeLand?.carSpace ?? ""
        self.lBLandSize.text = self.homeLand?.landSizeSqm ?? ""
        
        
        if ((self.lBFacadeName.text?.lowercased().contains("facade") ?? false) == false) {
            self.lBFacadeName.text = (self.lBFacadeName.text ?? "") + " Facade"
        }
        
        //        self.lBLotWidth.text =
        let tex = "LAND SIZE " + (self.homeLand?.landSizeSqm ?? "0") + "m2"
        
        let mainStr = NSMutableAttributedString(string: "LAND SIZE ", attributes: [.font : FONT_LABEL_SUB_HEADING(size: 10)])
        let landSizeStr = NSAttributedString(string: "\(self.homeLand?.landSizeSqm ?? "0")m", attributes: [.font : FONT_LABEL_HEADING(size: 12)])
        let metreStr = NSAttributedString(string: "2", attributes: [.font : FONT_LABEL_HEADING(size: 12), .baselineOffset : 2])
        
        mainStr.append(landSizeStr)
        mainStr.append(metreStr)
        lBLandSize.attributedText = mainStr
        
//        let font:UIFont? = FONT_LABEL_SUB_HEADING(size: 10)
//        let fontSuper:UIFont? = FONT_LABEL_SUB_HEADING(size: 10)
//        let attString:NSMutableAttributedString = NSMutableAttributedString(string: tex, attributes: [.font:font!])
//        attString.setAttributes([.font:fontSuper!,.baselineOffset:2], range: NSRange(location:tex.count-1,length:1))//attribute to make m^2
//        lBLandSize.attributedText = attString

        
        self.addBreadCrumb(from: (self.homeLand?.houseName ?? "") + " " + (self.homeLand?.houseSize ?? ""))

        
        self.btnFavorite.tintColor = APPCOLORS_3.GreyTextFont
        if Int(kUserID)! > 0 {// Current User
            self.btnFavorite.setBackgroundImage(self.homeLand?.isFav == true ? imageFavorite : imageUNFavorite, for: .normal)
            self.btnSaveDesign.backgroundColor = self.homeLand?.isFav == true ? APPCOLORS_3.LightGreyDisabled_BG : APPCOLORS_3.Orange_BG
//            if isFromFavorites == true {
//                btnFavorite.isHidden = homeLand?.favouritedUser?.userID != kUserID
//            }

        }else { // Guest User
            
            self.btnFavorite.setBackgroundImage(imageUNFavorite, for: .normal)
        }
        
       // self.btnSaveDesign.isHidden = self.btnFavorite.isHidden
       
        
                    
        self.lBEstateFacadeName.text = self.homeLand?.estateName ?? ""
        self.lBEstateAddress.text = self.homeLand?.address ?? ""

        
        self.imageHouse?.image = imageEmpty
        activity.startAnimating()

        if let imageURL = self.homeLand?.facadePermanentUrl {
                            
            print(log: ServiceAPI.shared.URL_imageUrl(imageURL))

            ImageDownloader.downloadImage(withUrl: ServiceAPI.shared.URL_imageUrl(imageURL), withFilePath: nil, with: { (image, success, error) in
                
                self.activity.stopAnimating()
                self.imageHouse.contentMode = .scaleToFill
                
                if let img = image {
                    self.imageHouse.image = processPixels(in: img)
                }else {
                    self.imageHouse.image = UIImage (named: "BG-Half")
                }
                
            }) { (progress) in
                
                
            }
        }
        
        if let packageDetails = self.homeLandPackageDetails {
                        
            if let floorplanURL = packageDetails.packageDetails?.floorPlanImageURLMobile {
                
                self.imageDesign.showActivityIndicator()

                ImageDownloader.downloadImage(withUrl: floorplanURL, withFilePath: nil, with: { (image, success, error) in
                    
                    self.imageDesign.hideActivityIndicator()

                    if success, let img = image {
                        self.imageDesign.image = processPixels(in: img)
                        let scrollView = self.imageDesign.superview as! UIScrollView
                        scrollView.delegate = self
                        scrollView.minimumZoomScale = 1.0
                        scrollView.maximumZoomScale = 10.0
                    }else{
                        print(error)
                        print("*-*-*-*-*-*-**-*-*-*-*-*",error)
                        ActivityManager.showToast("Error while loaading Floor plan", self)
                    }
                    if (error != nil) {
                        ActivityManager.showToast("Error while loaading Floor plan", self)
                    }
                    
                }, withProgress: nil)
            }
                        
        }
       
    }
    
//    func findColors(_ image: UIImage) -> [UIColor] {
//        let pixelsWide = Int(image.size.width)
//        let pixelsHigh = Int(image.size.height)
//
//        guard let pixelData = image.cgImage?.dataProvider?.data else { return [] }
//        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
//
//        var imageColors: [String] = []
//        for x in 0..<pixelsWide {
//            for y in 0..<pixelsHigh {
//                let point = CGPoint(x: x, y: y)
//                let pixelInfo: Int = ((pixelsWide * Int(point.y)) + Int(point.x)) * 4
//                let color = UIColor(red: CGFloat(data[pixelInfo]) / 255.0,
//                                    green: CGFloat(data[pixelInfo + 1]) / 255.0,
//                                    blue: CGFloat(data[pixelInfo + 2]) / 255.0,
//                                    alpha: CGFloat(data[pixelInfo + 3]) / 255.0)
//                imageColors.append(color.accessibilityName)
//            }
//        }
//        print("=-------------------------------",imageColors)
//        return imageColors
//    }
    //MARK: - Button Actions
    
    @IBAction func handleBackButton (_ sender: UIButton) {

        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func handleFavoriteButtonAction (_ sender: UIButton) {
        
        if noNeedofGuestUserToast(self, message: "Please login to add favourites") {
            
            CodeManager.sharedInstance.sendScreenName(burbank_homeAndLand_detailView_makeFavourite_button_touch)
            
            if let homeLa = homeLand {
                makeHomeLandFavorite(!(homeLa.isFav), homeLa)
            }
        }
    }
    
    @IBAction func handleMapViewButton (_ sender: UIButton) {

        if let package = homeLand {
            
            mapViewGoogleExpanded.addZoomLevelButtons()
            mapViewGoogleExpanded.setMapPosition(with: package, zoomlevel: 10.0)
            
            mapViewGoogleExpanded.addMarkers(packages: [package])
            
            viewMapExpanded.isHidden = false
            self.view.bringSubviewToFront(viewMapExpanded)
        }
    }
    
    
    @IBAction func handleCloseButton (_ sender: UIButton) {
        
        viewMapExpanded.isHidden = true
        self.view.sendSubviewToBack(viewMapExpanded)
        
    }
    
    @IBAction func handleEnquireButton (_ sender: UIButton) {
        
        CodeManager.sharedInstance.sendScreenName(burbank_homeAndLand_detailView_enquire_button_touch)
        
        let enquire = self.storyboard?.instantiateViewController(withIdentifier: "EnquireNowVC") as! EnquireNowVC
        enquire.homelandPackage = self.homeLand!
        
        if let navigation = self.tabBarController?.navigationController {
            navigation.pushViewController(enquire, animated: true)
        }else {
            self.navigationController?.pushViewController(enquire, animated: true)
        }
    }
    
    @IBAction func handleSaveDesignButton (_ sender: UIButton) {
        if let _ = self.homeLand {
            if Int(kUserID) ?? 0 > 0 { // user loggedIn
                if (self.homeLand?.isFav == true) {
                    
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


extension HomeLandDetailsVC: ChildVCDelegate, UIScrollViewDelegate
{
    func handleActionFor(sort: Bool, map: Bool, favourites: Bool, howWorks: Bool, reset: Bool) {
        
    }
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageDesign
    }
    
}


extension HomeLandDetailsVC: CLLocationManagerDelegate, MKMapViewDelegate, GMSMapViewDelegate {
           
       func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if mapView == mapViewGoogle {
            return false
        }
        return true
       }
       
}




extension HomeLandDetailsVC {
    
    func pageUISetup () {
    
        self.view.backgroundColor = APPCOLORS_3.Body_BG
        setAppearanceFor(view: lBHouseName, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_SUB_HEADING (size: FONT_18))
        
        setAppearanceFor(view: lBFacadeName, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_HEADING (size: FONT_12))
        setAppearanceFor(view: lBAddress, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_BODY (size: FONT_10))

        
        setAppearanceFor(view: lBPrice, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Orange_BG, textFont: FONT_LABEL_SUB_HEADING (size: FONT_18))
       setAppearanceFor(view: lBLinePrice, backgroundColor: APPCOLORS_3.GreyTextFont, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_LIGHT(size: FONT_10))

        
        setAppearanceFor(view: lBBedrooms, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_SUB_HEADING(size: FONT_10))
        setAppearanceFor(view: lBBathrooms, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_SUB_HEADING(size: FONT_10))
        setAppearanceFor(view: lBParking, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_SUB_HEADING(size: FONT_10))
        
        
        setAppearanceFor(view: lBLandSize, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_SUB_HEADING (size: 10)) //(size: 6))
//        setAppearanceFor(view: lBLandSize_size, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_LIGHT(size: 8))g
//
//        setAppearanceFor(view: lBLineSize, backgroundColor: APPCOLORS_3.GreyTextFont, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_LIGHT(size: FONT_10))


        setAppearanceFor(view: lBEstateFacadeName, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_LIGHT(size: FONT_8))
        setAppearanceFor(view: lBEstateAddress, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_LIGHT(size: FONT_8))


        setAppearanceFor(view: btnEnquire, backgroundColor: APPCOLORS_3.Orange_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_BODY (size: FONT_14))
        setAppearanceFor(view: btnSaveDesign, backgroundColor: APPCOLORS_3.Orange_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_BODY(size: FONT_14))

    }
    
    
    //MARK: - getting package details APIs
    
    func getPackageDetails (_ design: HomeLandPackage) {
        
        _ = Networking.shared.GET_request(url: ServiceAPI.shared.URL_packageDetails(self.homeLand?.packageId_LandBank ?? ""), userInfo: nil, success: { (data, response) in
            
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
    
    //MARK: Favorite Api's
    
    func makeHomeLandFavorite (_ favorite: Bool, _ homeLand: HomeLandPackage) {
        
        let params = NSMutableDictionary()
        params.setValue(SearchType.shared.homeLand, forKey: "TypeId")
        params.setValue(appDelegate.userData?.user?.userID, forKey: "UserId")
        params.setValue(homeLand.packageId, forKey: "HouseId")
        params.setValue(homeLand.stateId, forKey: "StateId")
        params.setValue(favorite, forKey: "isfavourite")
        
                            
        _ = Networking.shared.POST_request(url: ServiceAPI.shared.URL_Favorite, parameters: params, userInfo: nil, success: { (json, response) in

            if let result: AnyObject = json {
                
                let result = result as! NSDictionary
                
                if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {
                    
                    if (favorite == true) {
//                        DispatchQueue.main.async(execute: {
                            ActivityManager.showToast("Added to your favourites", self)
//                        })
                    }else{
                        DispatchQueue.main.async(execute: {
                            ActivityManager.showToast("Item removed from favourites", self)
                        })
                    }
                    
                    self.homeLand?.isFav = favorite
                    self.fillPackageData()
                                        
                  //  if self.homeLand!.favouritedUser?.userID == kUserID {
                        updateHomeLandFavouritesCount(self.homeLand!.isFav == true)
                    //}

                    
                }else { print(log: String.init(format: "Couldn't %@ home", arguments: [favorite ? "Favorite" : "Unfavorite"])) }
                
            }else {
                
                showToast(kServerErrorMessage)
            }
                        
        }, errorblock: { (error, isJSONerror) in
            
            if isJSONerror {
                showToast(String.init(format: "Couldn't %@ home", arguments: [favorite ? "Favorite" : "Unfavorite"]))
            }else {
                print(log: error?.localizedDescription as Any)
                showToast(String.init(format: "Couldn't %@ home", arguments: [favorite ? "Favorite" : "Unfavorite"]))
            }            
            
        }, progress: nil)
        
    }
        
}
