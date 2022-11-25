//
//  PopupDisplayHomesVC.swift
//  BurbankApp
//
//  Created by Naveen Kourampalli on 25/10/22.
//  Copyright © 2022 Sreekanth tadi. All rights reserved.
//

import UIKit

class PopupDisplayHomesVC: UIViewController,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var estateNameLBL: UILabel!
    @IBOutlet weak var suburbNameLBL: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var baseView: UIView!
    
    var houseDetailsByHouseTypeArr = [houseDetailsByHouseType]()
    var isFavoritesService: Bool = false
    var arrDisplayHomes = [DisplayHomeModel]()

    var arrFavouriteDisplays = [[houseDetailsByHouseType]]()
    var estateName = ""
    var suburbAddress = ""
    var tableViewContentHeight = 0

    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.view.layoutIfNeeded()
        self.view.backgroundColor = .clear
        loadData()
        // Do any additional setup after loading the view.
        
    }
    
    func loadData(){
        self.estateNameLBL.text = estateName
        self.suburbNameLBL.text = suburbAddress
        
        self.tableView.reloadData()
        layoutTable()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.tableViewHeight.constant = CGFloat(self.tableViewContentHeight)
    }
}
extension PopupDisplayHomesVC  {
    func layoutTable () {
        DispatchQueue.main.async {
            self.tableView.rowHeight = UITableView.automaticDimension;
            self.tableView.estimatedRowHeight =  165
        self.tableView.reloadData()
        self.tableView.layoutIfNeeded()
            let height = self.tableView.contentSize.height+self.tableView.contentInset.bottom+self.tableView.contentInset.top

//            self.tableViewHeight.constant = self.tableView.contentSize.height
        
        self.tableView.isScrollEnabled = true
                
        if  self.houseDetailsByHouseTypeArr.count > 1 {
            if self.tableViewContentHeight > Int(height){
                self.tableViewHeight.constant = CGFloat(self.tableViewContentHeight)
              //  self.view.frame.height = CGFloat(self.tableViewContentHeight)
            }else{
                self.tableViewContentHeight = Int(height)
                self.tableViewHeight.constant = CGFloat(self.tableViewContentHeight)
            }

        }else if self.houseDetailsByHouseTypeArr.count == 1 {
            self.tableViewContentHeight = Int(height)
            self.tableViewHeight.constant = CGFloat(self.tableViewContentHeight)
        }else{
            self.tableViewHeight.constant = 0
        }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return houseDetailsByHouseTypeArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let lastRow: Int = self.tableView.numberOfRows(inSection: 0) - 1
        
        if indexPath.row ==  lastRow{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DisplaysMapDetailExpandedCell", for: indexPath) as! DisplaysMapDetailExpandedCell
        cell.displayHomeData = houseDetailsByHouseTypeArr[indexPath.row]
            cell.getDirectionBTN.tag = indexPath.row
            cell.bookAnAppointmentBTN.tag = indexPath.row
            cell.getDirectionBTN.addTarget(self, action: #selector(didTappedOnGetDirections(_:)), for: .touchUpInside)
            cell.bookAnAppointmentBTN.addTarget(self, action: #selector(didTappedOnBookAppointments(_:)), for: .touchUpInside)
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

                                   if cell.displayHomeData!.favouritedUser?.userID == kUserID {
                                       updateDefaults = true
                                   }


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

                                    cell.displayHomeData!.isFav = !(cell.displayHomeData!.isFav)
                                    self.houseDetailsByHouseTypeArr[indexPath.row] =  cell.displayHomeData!

                                       self.tableView.reloadRows(at: [IndexPath.init(row: indexPath.row, section: 0)], with: .none)

                                       //                            if updateDefaults {
                                    updateDisplayHomesFavouritesCount(cell.displayHomeData!.isFav == true)
                                       //                            }

                                   }
                               }
                           }
                       }
                   }
                   print(log: "indexpath \(indexPath.row), arraycount \(houseDetailsByHouseTypeArr.count)")
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

                               if cell.displayHomeData!.favouritedUser?.userID == kUserID {
                                   updateDefaults = true
                               }


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
        let selectedDisplayHomeData = houseDetailsByHouseTypeArr[sender.tag]
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
        let selectedDisplayHomeData = houseDetailsByHouseTypeArr[sender.tag]
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
