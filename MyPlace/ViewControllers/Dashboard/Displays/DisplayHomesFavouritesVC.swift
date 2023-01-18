//
//  DisplayHomesFavouritesVC.swift
//  BurbankApp
//
//  Created by Naveen Kourampalli on 12/07/21.
//  Copyright © 2021 Sreekanth tadi. All rights reserved.
//

import UIKit

class DisplayHomesFavouritesVC: HeaderVC, ChildVCDelegate {
    func handleActionFor(sort: Bool, map: Bool, favourites: Bool, howWorks: Bool, reset: Bool) {
        print("")
    }
    
  
  @IBOutlet weak var detailCardHeaderView: UIView!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var detailCardView: UIView!
  @IBOutlet weak var estateNameLBL: UILabel!
  @IBOutlet weak var regionTableHeight: NSLayoutConstraint!
  
    @IBOutlet weak var streetNameLBL: UILabel!
    
    @IBOutlet weak var detailsTableView: UITableView!
  var tableViewContentHeight = 0
  var houseDetailsByHouseTypeArr = [houseDetailsByHouseType]()
  
  var displayFavorites = [houseDetailsByHouseType]()
  var isFavoritesService: Bool = false
  var arrFavouriteDisplays = [[houseDetailsByHouseType]]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.headerLogoText = "MyFavourites"
    isFromProfile = true
      addHeaderOptions(delegate: self)
    // self.tabBarController?.tabBar.tintColor = .gray
    if btnBack.isHidden {
      showBackButton()
      btnBack.addTarget(self, action: #selector(handleBackButton(_:)), for: .touchUpInside)
      btnBackFull.addTarget(self, action: #selector(handleBackButton(_:)), for: .touchUpInside)
    }
    let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
    detailCardHeaderView.addGestureRecognizer(tap)
    detailCardHeaderView.tag = 2
    detailCardHeaderView.isUserInteractionEnabled = true
    self.detailCardView.isHidden = true
      self.regionTableHeight.constant = 0
      self.detailsTableView.register(UINib(nibName: "TimingsAndDirectionTVC", bundle: nil), forCellReuseIdentifier: "TimingsAndDirectionTVC")
    self.addBreadCrumb(from: "Your favourite displays")
    
    _ = Networking.shared.GET_request(url: ServiceAPI.shared.URL_FavoriteDisplayHomes(Int(kUserID) ?? 0,Int(kUserState) ?? 0 ), userInfo: nil, success: { (json, response) in
      if let result: AnyObject = json {
        let result = result as! NSDictionary
        if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {
          if let result: AnyObject = json {
            if (result.allKeys as! [String]).contains("userFavDisplays") {
              let packagesResult = result.value(forKey: "userFavDisplays") as! [NSDictionary]
              //                            self.houseDetailsByHouseTypeArr = []
              for package: NSDictionary in packagesResult {
                let suggestedData = houseDetailsByHouseType(package as! [String : Any])
                self.displayFavorites.append(suggestedData)
              }
              DispatchQueue.main.async {
                self.tableView.reloadData()
              }
              
              print(self.houseDetailsByHouseTypeArr)
            }else { print(log: "no SuggestedHomesData found") }
            
          }else {
            
          }
        }
      }
    }, errorblock: { (error, isJSONerror) in
      
      if isJSONerror { }
      else { }
      
    }, progress: nil)
    
      
//      self.detailsTableView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
      
      
  }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        regionTableHeight.constant = detailsTableView.contentSize.height
        super.updateTopConstraint()
        print("-----p=p====-=--=-",detailsTableView.contentSize.height)
    }
   
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        detailsTableView.layer.removeAllAnimations()
//        regionTableHeight.constant = detailsTableView.contentSize.height
//        UIView.animate(withDuration: 0.5) {
//            self.updateViewConstraints()
//        }
//
//    }
    
  
  @objc func handleTap(_ sender: UITapGestureRecognizer) {
    let index = sender.view?.tag
    //        if self.regionTableHeight.constant > 100{
    //            self.regionTableHeight.constant = 0
    //        }
    
    if self.regionTableHeight.constant == 0{
      self.regionTableHeight.constant = CGFloat(self.tableViewContentHeight)
    }else{
      //self.tableViewContentHeight = 0
        self.detailsTableView.contentSize.height = 0
      self.regionTableHeight.constant = 0
        
      
    }
  }
  
  
  @IBAction func handleBackButton (_ sender: UIButton) {
    
    CodeManager.sharedInstance.sendScreenName (burbank_dashboard_displayHomes_button_touch)
    
//    let dash = kStoryboardMain.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
//    (dash as UITabBarController).selectedIndex = 2
//    // self.navigationController?.pushViewController(dash, animated: true)
//    kWindow.rootViewController = dash
      self.navigationController?.popViewController(animated: true)
  }
  
    func layoutTable () {
        self.detailCardView.isHidden = false
        self.detailsTableView.reloadData()
        
        self.detailsTableView.isScrollEnabled = true
        if  houseDetailsByHouseTypeArr.count >= 0 {
            self.tableViewContentHeight = Int(self.detailsTableView.contentSize.height)
            print("----===--------==---------==",self.tableViewContentHeight)
            regionTableHeight.constant = CGFloat(self.tableViewContentHeight)
            //      self.detailsTableView.reloadData()
        }else {
            regionTableHeight.constant = 0
        }
        self.detailsTableView.layoutIfNeeded()
        self.detailsTableView.setNeedsLayout()
        self.detailsTableView.updateConstraints()
//        super.updateTopConstraint()
    }
  
  func gethouseDetailsByHouseType (estateName : String?) {
    _ = Networking.shared.GET_request(url: ServiceAPI.shared.URL_HouseDetailsByEstate(Int(kUserState) ?? 0, estateName ?? ""), userInfo: nil, success: { (json, response) in
      if let result: AnyObject = json {
        let result = result as! NSDictionary
        if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {
          self.houseDetailsByHouseTypeArr = []
          if let result: AnyObject = json {
            if (result.allKeys as! [String]).contains("houseDetailsByHouseType") {
              if (result.value(forKey: "houseDetailsByHouseType") as AnyObject).isKind(of: NSArray.self){
                let packagesResult = result.value(forKey: "houseDetailsByHouseType") as! [NSDictionary]
                
                for package: NSDictionary in packagesResult {
                  let suggestedData = houseDetailsByHouseType(package as! [String : Any])
                  self.houseDetailsByHouseTypeArr.append(suggestedData)
                }
                DispatchQueue.main.async {
                 // self.detailCardView.isHidden = false
                  self.layoutTable ()
                }
                
                print(self.houseDetailsByHouseTypeArr)
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
    
  }
}
extension DisplayHomesFavouritesVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView
        {
            return displayFavorites.count
        }
        else{
            return houseDetailsByHouseTypeArr.count + 1
        }
    }
    
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == self.tableView
         {
            let view = UIView(frame: CGRect(x:0, y:0, width:tableView.frame.size.width, height:40))
            let label = UILabel(frame: CGRect(x:10, y:5, width:tableView.frame.size.width, height:18))
            label.font = UIFont.boldSystemFont(ofSize: 18)
            label.text = "Favourites List (\(displayFavorites.count))";
            label.textColor = .white
            view.addSubview(label);
            view.backgroundColor = .lightGray
            label.translatesAutoresizingMaskIntoConstraints = false
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor , constant: 16).isActive = true
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

            return view
        }else{
            return nil
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == self.tableView
        {
            return 40

        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.detailsTableView
        {
            return tableView.estimatedRowHeight

        }else{
            return self.tableView.estimatedRowHeight
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DisplyHomesFavouritesTVC", for: indexPath) as! DisplyHomesFavouritesTVC
            let displaydata = displayFavorites[indexPath.row]
            
            cell.designCountLBL.text =  displaydata.displayDesignCount?.count == 1 ? "\(displaydata.displayDesignCount?.count ?? 0 )  DESIGN"  :  "\(displaydata.displayDesignCount?.count ?? 0 )  DESIGNS"
//            cell.designCountLBL.text = "\(displaydata.displayDesignCount?.count ?? 0) DESIGNS"
          cell.estateNameLBL.text = "\(displaydata.displayEstateName.trim()), \(displaydata.houseName)"
            cell.favouriteBTN.tag = indexPath.row
          
            if let imageurl : String? = displaydata.facadePermanentUrl {
                ImageDownloader.downloadImage(withUrl: ServiceAPI.shared.URL_imageUrl(imageurl ?? ""), withFilePath: nil, with: { (image, success, error) in
                    cell.homeIMG.contentMode = .scaleToFill
                    if let img = image {
                        cell.homeIMG.image = img
                    }else {
                        cell.homeIMG.image = UIImage (named: "BG-Half")
                    }
                }) { (progress) in
                }
            }
            
            if displaydata.isFav == true {
                cell.favouriteBTN.setBackgroundImage(imageFavorite, for: .normal)
            }else {
                cell.favouriteBTN.setBackgroundImage(imageUNFavorite, for: .normal)
            }
            
            if isFavoritesService == true {
                let displayData = displayFavorites[indexPath.item]
               
                cell.favouriteBTN.isHidden = displayData.favouritedUser?.userID != kUserID
                
            }else {
                let displayData = displayFavorites[indexPath.item]
            }

            cell.favoriteAction = {
                if noNeedofGuestUserToast(self, message: "Please login to add favourites") {
                    
                    if self.isFavoritesService {
                        CodeManager.sharedInstance.sendScreenName(burbank_DisplayHomes_favourite_makeFavourite_button_touch)
                    }else {
                        CodeManager.sharedInstance.sendScreenName(burbank_homeAndLand_results_makeFavourite_button_touch)
                    }
                    
                    self.makeDisplayHomeFavorite(!(displaydata.isFav), displaydata) { (success) in
                        if success {
                            
                            if (!(displaydata.isFav) == true) {
                                DispatchQueue.main.async(execute: {
                                    ActivityManager.showToast("Added to your favourites", self)
                                })
                            }else{
                                DispatchQueue.main.async(execute: {
                                    ActivityManager.showToast("Item removed from favourites", self)
                                })

                             }
                            
                            var updateDefaults = false
                            
                          //  if displaydata.favouritedUser?.userID == kUserID {
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
                                
                                //                                   self.arrFavouriteDisplays.count == 0 ? self.searchResultsTable.setEmptyMessage("No Favourite Packages found", bgColor: COLOR_APP_BACKGROUND) : self.searchResultsTable.setEmptyMessage("", bgColor: COLOR_CLEAR)
                                //
                                //                                   self.searchResultsTable.reloadData ()
                                
                            }else {
                                
                                displaydata.isFav = !(displaydata.isFav)
                                self.displayFavorites[indexPath.item] =  displaydata
                                self.tableView.reloadRows(at: [IndexPath.init(row: indexPath.row, section: 0)], with: .none)
                                
                                //                            if updateDefaults {
                                updateDisplayHomesFavouritesCount(displaydata.isFav == true)
                                //                            }
                                
                            }
                        }
                    }
                }
            }
            print(log: "indexpath \(indexPath.row), arraycount \(houseDetailsByHouseTypeArr.count)")
            
            return cell
        }
        else{
            let lastRow: Int = self.detailsTableView.numberOfRows(inSection: 0) - 1
            
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
                               // }
                                
                                
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
                                    
                                    //                                   self.arrFavouriteDisplays.count == 0 ? self.searchResultsTable.setEmptyMessage("No Favourite Packages found", bgColor: COLOR_APP_BACKGROUND) : self.searchResultsTable.setEmptyMessage("", bgColor: COLOR_CLEAR)
                                    //
                                    //                                   self.searchResultsTable.reloadData ()
                                    
                                }else {
                                    
                                    cell.displayHomeData!.isFav = !( cell.displayHomeData!.isFav)
                                    self.houseDetailsByHouseTypeArr[indexPath.row] =  cell.displayHomeData!
                                    
                                    self.detailsTableView.reloadRows(at: [IndexPath.init(row: indexPath.row, section: 0)], with: .none)
                                    
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
    }
       
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.tableView
        {
            self.regionTableHeight.constant = 0
            let displaydata = displayFavorites[indexPath.row]
            
            gethouseDetailsByHouseType(estateName: displaydata.displayEstateName)
            //        self.estateNameLBL.text = displaydata.displayEstateName
            
            let font:UIFont? = FONT_LABEL_SUB_HEADING(size: FONT_15)
            let fontSuper:UIFont? = FONT_LABEL_BODY(size: FONT_9)
            let boldFontAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: font]
            let normalFontAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: fontSuper]
            let partOne = NSMutableAttributedString(string: displaydata.displayEstateName.uppercased() , attributes: boldFontAttributes as [NSAttributedString.Key : Any])
            let partTwo = NSMutableAttributedString(string: "\n\(displaydata.street),\(displaydata.suburb)", attributes: normalFontAttributes as [NSAttributedString.Key : Any])
            let combination = NSMutableAttributedString()
            combination.append(partOne)
            combination.append(partTwo)
            self.detailCardHeaderView.isHidden = false
            self.estateNameLBL.attributedText = partOne
            self.streetNameLBL.text = "\(displaydata.street),\n\(displaydata.suburb)"
            self.addBreadCrumb(from: "\(displaydata.displayEstateName.uppercased()), \(displaydata.street)")
        }else{
            let data = houseDetailsByHouseTypeArr[indexPath.row]
            let homeDetailView = self.storyboard?.instantiateViewController(withIdentifier: "DisplayHomesDetailsVC") as! DisplayHomesDetailsVC
            homeDetailView.displayHomes = data
            homeDetailView.isFromDisplayHomes = true
            homeDetailView.isCameFromFavorites = true
            self.navigationController?.pushViewController(homeDetailView, animated: true)
        }
    }
  
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.regionTableHeight.constant = 0
        self.detailCardView.isHidden = true
        self.detailCardHeaderView.isHidden = true
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
//    let selectedDisplayHomeData = houseDetailsByHouseTypeArr[sender.tag]
//    let bookAppintmentV = BookAppointmentVC()
//    bookAppintmentV.displayHomeData = houseDetailsByHouseTypeArr
//    self.performSegue(withIdentifier: "BookAppointmentVC", sender: self)
    
    let homeDetailView = self.storyboard?.instantiateViewController(withIdentifier: "BookAppointmentVC") as! BookAppointmentVC
  homeDetailView.isFromFavorites = true
    homeDetailView.displayHomeData = houseDetailsByHouseTypeArr
//    homeDetailView.isFromDisplayHomes = true
    self.navigationController?.pushViewController(homeDetailView, animated: true)
    
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
