//
//  HomeVC.swift
//  BurbankApp
//
//  Created by Mohan Kumar on 16/12/16.
//  Copyright © 2016 DMSS. All rights reserved.
//

import UIKit

class HomeVC: UIViewController/*,profileScreenDismissedProtocol*/,performSegueDelegate, profileScreenProtocol
{
    var menuArray: NSMutableArray =
        [  ["name" : "SALES CONSULTANT", "imageName" : "Ico-SalesConsultant","segueIndetifier": ""],
           ["name" : "CALENDER", "imageName" : "Ico-Calender","segueIndetifier": ""],
           ["name" : "NEW HOMES", "imageName" : "Ico-Newhome","segueIndetifier": ""],
           ["name" : "DISPLAY HOMES", "imageName" : "Ico-Displayhome" ,"segueIndetifier" : ""],
           ["name" : "H&L PACKAGES", "imageName" : "Ico-HNL" ,"segueIndetifier" : ""],
           ["name" : "MY INSPIRATIONS", "imageName" : "Ico-Inspire" ,"segueIndetifier" : ""]
           ]
    @IBOutlet weak var menuCollectionView: UICollectionView!
    lazy var menuCollectionVC: MenuCustomVC = {
        
        let menuCollectionVC = MenuCustomVC()
        menuCollectionVC.mydelegate = self
        menuCollectionVC.menuArray = self.menuArray
        return menuCollectionVC
    }()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        checkAndShowProfileVC()
        
        menuCollectionView.delegate = self.menuCollectionVC
        menuCollectionView.dataSource = self.menuCollectionVC
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func checkAndShowProfileVC()
    {
        let isPurchasedUserEnteredProfileDetails = UserDefaults.standard.bool(forKey: "isPurchasedUserEnteredProfileDetails")
        if isPurchasedUserEnteredProfileDetails == false
        {
            UserDefaults.standard.set(true, forKey: "isPurchasedUserEnteredProfileDetails")
            showProfileVC()
        }
    }

    func showProfileVC()
    {
        let storyBoard  = UIStoryboard(name: "Main_OLD", bundle: nil)
        let profileVC = storyBoard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        profileVC.modalPresentationStyle = .overCurrentContext
        profileVC.delegate = self
        present(profileVC, animated: true, completion: nil)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
    }
    // MARK: - perform segue delegate Methods
    func profileScreenDismissed()
    {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            let storyBoard  = UIStoryboard(name: "Main_OLD", bundle: nil)
            let salesConsultantVC = storyBoard.instantiateViewController(withIdentifier: "SaleConsultantVC") as! SalesConsultantVC
            salesConsultantVC.modalPresentationStyle = .overCurrentContext
            self.present(salesConsultantVC, animated: true, completion: nil)
            
        }, completion: { (completed: Bool) in
            //Nothing to do
        })
    }
    // MARK: - Menu VC delegate Methods
    func showSegueViewController(_ index: Int)
    {
        if menuArray.count > index
        {
            if let segueIdetifier = (menuArray.object(at: index) as AnyObject).value(forKey: "segueIndetifier") as? String
            {
                self.performSegue(withIdentifier: segueIdetifier, sender: nil)
            }else
            {
                AlertManager.sharedInstance.alert("Work in progress")
            }
            
            //checking whether we perform segue through stroyboard or not
            // For Sprint2 we are showing only Purchase Orders
//            if segueIdetifier.isEmpty == false
//            {
//                self.performSegue(withIdentifier: segueIdetifier, sender: nil)
//            }else
//            {
//                AlertManager.sharedInstance.alert("Work in progress")
//            }
        }
        
    }
}
