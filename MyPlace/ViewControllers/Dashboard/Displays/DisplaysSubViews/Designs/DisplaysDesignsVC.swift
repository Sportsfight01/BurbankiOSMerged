//
//  DisplaysDesignsVC.swift
//  BurbankApp
//
//  Created by sreekanth reddy Tadi on 05/05/21.
//  Copyright © 2021 Sreekanth tadi. All rights reserved.
//

import UIKit
import CoreLocation

class DisplaysDesignsVC: UIViewController {
    
    
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    @IBOutlet weak var colletionView: UICollectionView!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var arrayDesigns = [1, 2, 3, 4]
    var arrayDesignStoreys = ["  ALL  ", "  SINGLE STOREY  ", "  DOUBLE STOREY  "]
    
    var MostPopularHomesData = [PupularDisplays]()
    
    var selectedHome = DisplayHomeModel()
    var selectedTVC = false
    var selectedIndex = 0
    var selectedTableIndex = 0
    var selectedDesign = ""
    var latitude = "0.0"
    var longitude = "0.0"
    // MARK: - View Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colletionView.delegate = self
        colletionView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        self.tableView.scrollsToTop = true
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: locationupdated),
                                               object: nil,
                                               queue: nil,
                                               using:updatedNotificationForLocartion)
        NotificationCenter.default.addObserver(forName: NSNotification.Name("tappedOnPopularHomeDesigns"), object: nil, queue: nil, using:updatedNotification)
        
    }
    
    // MARK: - Handiling notification Centre
    func updatedNotificationForLocartion(notification:Notification) -> Void  {
        guard let location = notification.userInfo!["loc"] else { return }
        let locValue = location as! CLLocationCoordinate2D
        latitude = "\(locValue.latitude)"
        longitude = "\(locValue.longitude)"
    }
    func updatedNotification(notification:Notification) -> Void  {
        guard let isTappedonPopularHomeDesigns = notification.userInfo!["Key"] else { return }
        //        print("\(LocationServices.shared.K_GETlocationCORD?.latitude ?? 0.0)")
        print("-------\(isTappedonPopularHomeDesigns)")
        if isTappedonPopularHomeDesigns as! Bool {
            guard let popularHomeData : PupularDisplays = notification.userInfo!["PopularHomeData"] as? PupularDisplays else { return }
            collectionHeight.constant = 0
            getDesignsData(story: "", houseName: popularHomeData.houseName ?? "", houseSize: popularHomeData.houseSize ?? "")
        }
        else{
            
            selectedTableIndex = 0
            selectedIndex = 0
            collectionHeight.constant = 70
            getDesignsData(story: "All", houseName: "", houseSize: "")
            colletionView.reloadData()
            
        }
    }
}
// MARK: - Tableview Delegates
extension DisplaysDesignsVC: UITableViewDelegate, UITableViewDataSource,displayDesignDetailsProtocol {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.MostPopularHomesData.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DisplaysDesignsTVCell", for: indexPath) as! DisplaysDesignsTVCell
        cell.displayHomeModelLocations = self.MostPopularHomesData[indexPath.row]
        if self.selectedTableIndex == indexPath.row{
           cell.displayHomeModelLocations?.locations = self.MostPopularHomesData[self.selectedTableIndex].locations
            cell.tableHeight.constant = cell.displaysDesignsSubTVCellHeight*CGFloat(self.MostPopularHomesData[self.selectedTableIndex].locations.count )
           // cell.subTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                cell.subTableView.reloadData()
     
        }else{
            cell.tableHeight.constant = 0
        }
       
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.MostPopularHomesData[indexPath.row].locations.count > 0{
            self.selectedTableIndex = indexPath.row
            DispatchQueue.main.async {
                
//                let sec = tableView.rect(forSection: indexPath.section)
//                tableView.scrollRectToVisible(sec, animated: false)
                self.tableView.reloadData()
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
                
                if indexPath.row == self.MostPopularHomesData.count - 1{
                    self.tableView.scrollToRow(at: IndexPath(row: indexPath.row, section: 0), at: .bottom, animated: false)
                }
            }
           
        }else{
            self.selectedDesign = self.MostPopularHomesData[indexPath.row].houseName as? String ?? ""
            let data = self.MostPopularHomesData[indexPath.row]
            let homeDetailView = self.storyboard?.instantiateViewController(withIdentifier: "DisplayHomesDetailsVC") as! DisplayHomesDetailsVC
            homeDetailView.displayDesigns = data
            homeDetailView.indexOdDesigns = indexPath.row
            homeDetailView.isFromDisplayHomes = true
            
            self.navigationController?.pushViewController(homeDetailView, animated: true)
        }
        
        
    }
}

// MARK: - CollectionView Delegates
extension DisplaysDesignsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayDesignStoreys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DisplaysDesignsCVCell", for: indexPath) as! DisplaysDesignsCVCell
       
        cell.storeyBTN.setTitle(arrayDesignStoreys[indexPath.item], for: .normal)
        cell.storeyBTN.tag = indexPath.item
        cell.storeyBTN.addTarget(self, action: #selector(didTappedOnFiltersBTN(_:)), for: .touchUpInside)
//        cell.storeyBTN.backgroundColor = .black
//        cell.storeyBTN.setTitleColor(.orange, for: .normal)
        
        if selectedIndex == indexPath.item{
            cell.storeyBTN.backgroundColor = APPCOLORS_3.Orange_BG
            cell.storeyBTN.setTitleColor(.white, for: .normal)
        }else{
            cell.storeyBTN.backgroundColor = APPCOLORS_3.Body_BG
            cell.storeyBTN.setTitleColor(APPCOLORS_3.GreyTextFont, for: .normal)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize (width: collectionView.frame.size.width-10 / 3, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        self.colletionView.reloadData()
        if indexPath.item == 0{
            getDesignsData(story: "All", houseName: "", houseSize: "")
        }else{
            getDesignsData(story: "\(indexPath.item )", houseName: "", houseSize: "")
        }
       
    }

}
// MARK: - Buttion Actions And segues

extension DisplaysDesignsVC{
    @IBAction func didTappedOnFiltersBTN (_ sender: UIButton) {
        selectedIndex = sender.tag
        self.colletionView.reloadData()
        if sender.tag == 0{
            getDesignsData(story: "All", houseName: "", houseSize: "")
        }else{
            getDesignsData(story: "\(sender.tag)", houseName: "", houseSize: "")
        }
    }
    
    func didTappedOnestateName(index: Int) {
        let homeDetailView = self.storyboard?.instantiateViewController(withIdentifier: "DisplaysRegionsMapDetailVC") as! DisplaysRegionsMapDetailVC
        homeDetailView.screenFromHomeDesigns = true
        homeDetailView.popularHomeDesignData = self.MostPopularHomesData[self.selectedTableIndex].locations[index]
        self.navigationController?.pushViewController(homeDetailView, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DisplaysRegionsMapDetailVC {
            vc.screenFromHomeDesigns = true
            vc.selctedDesignHome =  self.selectedDesign
        }
    }
    
    @IBAction func didTappedOnBackBTN(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}


// MARK: - API's
extension DisplaysDesignsVC{
    func getDesignsData(story : String, houseName : String, houseSize : String){
        _ = Networking.shared.GET_request(url: ServiceAPI.shared.URL_HomeDisplay (Int(kUserState) ?? 0, "\(latitude)", "\(longitude)", Int(kUserID) ?? 0, story, houseName,houseSize), userInfo: nil, success: { (json, response) in
            
            if let result: AnyObject = json {
                
                let result = result as! NSDictionary
                
                if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {
                    if let result: AnyObject = json {
                        let getdisplaysbyId = result.value(forKey: "getdisplaysbyId") as! NSDictionary
                        if (getdisplaysbyId.allKeys as! [String]).contains("MostPopularHomesDTOs") {
                            
                            let packagesResult = getdisplaysbyId.value(forKey: "MostPopularHomesDTOs") as! [NSDictionary]
                            self.MostPopularHomesData.removeAll()
                            for package: NSDictionary in packagesResult {
                                let popularData = PupularDisplays(package as! [String : Any])
                                self.MostPopularHomesData.append(popularData)
                             }

                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: 0, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                                
                            }
                           
                        }else { print(log: "no Homes found") }
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
