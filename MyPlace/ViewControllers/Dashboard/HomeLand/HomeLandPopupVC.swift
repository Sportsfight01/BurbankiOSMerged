//
//  HomeLandPopupVC.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 21/07/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit

class HomeLandPopupVC: UIViewController {

    
    @IBOutlet weak var tableViewHomeLandPopup: UITableView!
    
    @IBOutlet weak var labelHeading: UILabel!
    @IBOutlet weak var btnClose: UIButton!

    @IBOutlet weak var tableViewHomeLandPopupHeight: NSLayoutConstraint!

    
    
    
    var arrHomeLandPackages = [HomeLandPackage]()
    
    var selectedPackage: ((_ package: HomeLandPackage?) -> Void)?
    
    
    let maxTableheight = SCREEN_HEIGHT - (statusBarHeight () + 44 + 60)
    
    var arrDisplayHomes = [DisplayHomeModel]()
    var selectedDisplayHomes: ((_ displayHome: DisplayHomeModel?) -> Void)?
        
    var isDisplayHome : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tableViewHomeLandPopup.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)

    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        tableViewHomeLandPopup.layer.removeAllAnimations()
        
        if tableViewHomeLandPopup.contentSize.height > maxTableheight {
            tableViewHomeLandPopupHeight.constant = maxTableheight
        }else {
            tableViewHomeLandPopupHeight.constant = tableViewHomeLandPopup.contentSize.height
        }
        
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }

    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()

    }
    
    func setHeading () {
        if isDisplayHome ?? false{
            
        }
        else{
            if arrHomeLandPackages.count == 1 {
                
                _ = setAttributetitleFor(view: labelHeading, title: "SELECTED HOUSE", rangeStrings: ["SELECTED HOUSE"], colors: [APPCOLORS_3.GreyTextFont], fonts: [FONT_LABEL_SUB_HEADING (size: FONT_16)], alignmentCenter: false)

            }else {
                
                let str = "HOUSES IN GROUP"
                let count = "\(arrHomeLandPackages.count) Houses"
                
                _ = setAttributetitleFor(view: labelHeading, title: str + "\n" + count, rangeStrings: [str, count], colors: [APPCOLORS_3.GreyTextFont, APPCOLORS_3.GreyTextFont], fonts: [FONT_LABEL_SUB_HEADING(size: FONT_16), FONT_LABEL_LIGHT (size: FONT_12)], alignmentCenter: false)
            }
        }
       
        
    }
    
    
    
    //MARK: - Action
    
    @IBAction func handleCloseButtonAction (_ sender: UIButton) {
        
        if let selected = selectedPackage {
            selected(nil)
        }
    }

}



//MARK: - Delegate

extension HomeLandPopupVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isDisplayHome ?? false{
            return arrDisplayHomes.count
        }
        else{
            return arrHomeLandPackages.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
////        print(log: "willDisplay indexpath: " + "\(indexPath.row)")
        
//        let cell = cell as! HomeLandTVCell
//
//        cell.imageHouseHeight.constant = cell.frame.size.height - 20
        
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
//        print(log: "didEndDisplaying indexpath: " + "\(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeLandTVCell", for: indexPath) as! HomeLandTVCell
        
        // Configure the cell...
        cell.selectionStyle = .none
        
        if Int(kUserID)! > 0 { }
        else {
            cell.btnFavorite.isHidden = true
        }
                
       // setBorder(view: cell, color: APPCOLORS_3.GreyTextFont, width: 0.5)
        
        if isDisplayHome ?? false{
            cell.displayHomeData = arrDisplayHomes[indexPath.row]
        }else{
            cell.homeLand = arrHomeLandPackages[indexPath.row]
        }
        
//        cell.homeLand = arrHomeLandPackages[indexPath.row]
        
        
        cell.favoriteAction = {
            
            CodeManager.sharedInstance.sendScreenName(burbank_homeAndLand_map_cluster_makeFavourite_button_touch)
            
            self.makeHomeLandFavorite(!(cell.homeLand!.isFav), cell.homeLand!) { (success) in
                if success {
                    cell.homeLand!.isFav = !(cell.homeLand!.isFav)
                    self.arrHomeLandPackages[indexPath.row] = cell.homeLand!
                    
                    self.tableViewHomeLandPopup.reloadRows(at: [indexPath], with: .none)
                }
            }
        }
        
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let selected = selectedPackage {
            selected(arrHomeLandPackages[indexPath.row])
        }
    }
        
    
    
    //MARK: - APIs
    
    func makeHomeLandFavorite (_ favorite: Bool, _ homeLand: HomeLandPackage, callBack: @escaping ((_ successss: Bool) -> Void)) {
        
        let params = NSMutableDictionary()
        params.setValue(SearchType.shared.homeLand, forKey: "TypeId")
        params.setValue(appDelegate.userData?.user?.userID, forKey: "UserId")
        params.setValue(homeLand.packageId, forKey: "HouseId")
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
