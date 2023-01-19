//
//  DisplaysRegionsVC.swift
//  BurbankApp
//
//  Created by sreekanth reddy Tadi on 05/05/21.
//  Copyright © 2021 Sreekanth tadi. All rights reserved.
//

import UIKit

class DisplaysRegionsVC: UIViewController {

    
    @IBOutlet weak var regionTableHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    var arrRegions: [String]?
    var selectedRegion = ""
    var previousRegion: RegionMyPlace?
    
    var regionsMapVC: DisplaysRegionsMapDetailVC?
    var selectedIndex = 0
    
    //MARK: - ViewLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getRegions ()
        print(arrRegions)
        self.tableView.reloadData()
        self.tableView.layoutIfNeeded()
    }
    
    @IBAction func handleSomeButtonAction (_ sender: UIButton) {

        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutTable ()
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        layoutTable ()
    }
    func layoutTable () {
        
        self.tableView.reloadData()
        self.tableView.layoutIfNeeded()
        
        
        self.tableView.isScrollEnabled = true
        
        regionTableHeight.constant = self.tableView.contentSize.height
        
        if let regions = arrRegions {
            regionTableHeight.constant = cellHeight*CGFloat((regions.count)) + 10.0*CGFloat((regions.count))
            
            if (tableView.frame.origin.y + regionTableHeight.constant + 20) > (SCREEN_HEIGHT - 80) {
                
                regionTableHeight.constant = (SCREEN_HEIGHT - 80 - (tableView.frame.origin.y + 20))
                
            }else {
                self.tableView.isScrollEnabled = false
            }
        }else {
            regionTableHeight.constant = 0
        }
        
        
    }
    
}
//MARK: - Tableview Delegates

extension DisplaysRegionsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRegions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegionTableViewCell", for: indexPath) as! RegionTableViewCell
        
        let region = arrRegions?[indexPath.row]
        cell.titleLabel.text = region?.uppercased()
        cell.titleLabel.layer.cornerRadius = 10.0
//        cell.titleLabel.borderWidth = 1.0
        cell.titleLabel.cardView(cornerRadius: 10.0, shadowRadius: 10.0, shadowOpacity: 0.5, shadowColor: UIColor.lightGray.cgColor, backgroundColor: .white)
        cell.titleLabel.clipsToBounds = true
//        cell.titleLabel.borderColor = APPCOLORS_3.
       
        if selectedIndex == indexPath.row{
            cell.titleLabel.backgroundColor = APPCOLORS_3.EnabledOrange_BG
            cell.titleLabel.textColor = .white
            cell.layer.masksToBounds = true
        }else{
            cell.titleLabel.backgroundColor = .white
            cell.titleLabel.textColor = APPCOLORS_3.GreyTextFont
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.tableView.reloadData()
        self.selectedRegion = (arrRegions?[indexPath.row])!
        self.performSegue(withIdentifier: "DisplaysRegionsMapDetailVC", sender: nil)

    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight + 10
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight + 10
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DisplaysRegionsMapDetailVC" {
            regionsMapVC = segue.destination as? DisplaysRegionsMapDetailVC
            regionsMapVC?.selectedRegionForMaps = self.selectedRegion 
        }
    }
}
//MARK: - API's
extension DisplaysRegionsVC{
    func getRegions () {
       
        _ = Networking.shared.GET_request(url: ServiceAPI.shared.URL_getRegionsByStateID (Int(kUserState) ?? 0), userInfo: nil, success: { (json, response) in
            
            if let result: AnyObject = json {
                
                let result = result as! NSDictionary
                
                if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {
                    self.arrRegions = result["regionsByStateId"] as? Array<String>
                        DispatchQueue.main.async {
//                            self.tableView.reloadData()
                            self.layoutTable ()
                        }
                    
                }
            }
        }, errorblock: { (error, isJSONerror) in

            if isJSONerror { }
            else { }

        }, progress: nil)

    }

}
