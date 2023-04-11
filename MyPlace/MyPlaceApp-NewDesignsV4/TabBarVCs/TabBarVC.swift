//
//  TabBarVC.swift
//  BurbankApp
//
//  Created by naresh banavath on 08/12/21.
//  Copyright © 2021 DMSS. All rights reserved.
//

import Foundation

import UIKit

class TabBarVC: UITabBarController {

    let HEIGHT_TAB_BAR = 70.0
    
    var tabBarItems : [TabBarItemStruct] = []
    var isFinanceTabVisible : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.unselectedItemTintColor = UIColor.darkGray
        self.tabBar.tintColor = AppColors.appOrange
//        self.tabBar.backgroundColor = UIColor.white
        self.delegate = self
       // setTabBarItems()
        
        //to make tabbar as cardView
        tabBar.layer.shadowColor = UIColor.darkGray.cgColor
        tabBar.layer.shadowOpacity = 0.7
        tabBar.layer.shadowOffset = CGSize.zero
        tabBar.layer.shadowRadius = 5
        self.tabBar.layer.borderColor = UIColor.clear.cgColor
        self.tabBar.layer.borderWidth = 0
        self.tabBar.clipsToBounds = false
        self.tabBar.backgroundColor = UIColor.white
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        getProgressData()
     
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupViewControllers()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        var tabFrame = self.tabBar.frame
//        tabFrame.size.height = HEIGHT_TAB_BAR
//        tabFrame.origin.y = self.view.frame.size.height - HEIGHT_TAB_BAR
//        self.tabBar.frame = tabFrame
        tabBar.itemWidth = 20
        tabBar.itemSpacing = 10
        
       
    }
    func setupViewControllers()
    {
        self.tabBarItems.removeAll()
        self.tabBarItems = [
            TabBarItemStruct(viewController: MyProgressVC.self, title: "PROGRESS", selectedItemImage: "Progress_orange", unSelectedItemImage: "Progress_grey"),
            TabBarItemStruct(viewController: MyContactsVC.self, title: "CONTACTS", selectedItemImage: "Contacts_orange", unSelectedItemImage: "Contacts_grey"),
            TabBarItemStruct(viewController: PhotosVC.self, title: "PHOTOS", selectedItemImage: "Photos_orange", unSelectedItemImage: "Photos_grey"),
            TabBarItemStruct(viewController: DocumentsVC.self, title: "DOCUMENTS", selectedItemImage: "Documents_orange", unSelectedItemImage: "Documents_grey"),
        ]
        
        if isFinanceTabVisible{
            
            let financeTab = TabBarItemStruct(viewController: FinanceVC.self, title: "FINANCE", selectedItemImage: "Finance_orange", unSelectedItemImage: "Finance_grey")
            self.tabBarItems.append(financeTab)
        }
        
        self.viewControllers = tabBarItems.map { item in
            let vc = UINavigationController(rootViewController: item.viewController.instace())
            vc.tabBarItem = UITabBarItem(title: item.title, image: UIImage(named : item.unSelectedItemImage) , selectedImage: UIImage(named : item.selectedItemImage))
            return vc
            
        }
       
    }
    //MARK: - ServiceCall
    
    func getProgressData()
    {
        var currenUserJobDetails : MyPlaceDetails?
        currenUserJobDetails = (UIApplication.shared.delegate as! AppDelegate).currentUser?.userDetailsArray![0].myPlaceDetailsArray[0]
        if selectedJobNumberRegionString == ""
        {
            let jobRegion = currenUserJobDetails?.region
            selectedJobNumberRegionString = jobRegion!
            print("jobregion :- \(jobRegion)")
        }
        let authorizationString = "\(currenUserJobDetails?.userName ?? ""):\(currenUserJobDetails?.password ?? "")"
        let encodeString = authorizationString.base64String
        let valueStr = "Basic \(encodeString)"
        
        var contractNo : String = ""
    
            if let jobNum = appDelegate.currentUser?.jobNumber, !jobNum.trim().isEmpty
            {
                contractNo = jobNum
            }
            else {
                contractNo = appDelegate.currentUser?.userDetailsArray?.first?.myPlaceDetailsArray.first?.jobNumber ?? ""
            }
        
        NetworkRequest.makeRequestArray(type: ProgressStruct.self, urlRequest: Router.progressDetails(auth: valueStr, contractNo: contractNo)) {[weak self] (result) in
            switch result
            {
            case .success(let data):
                // print(data)
                let filtered = data.filter({$0.phasecode?.lowercased() == "presite".lowercased()}).filter({($0.name?.trim().lowercased() == "Sign Building Contract".trim().lowercased() || $0.name?.trim().lowercased() == "Contract Signed".lowercased()) && $0.status?.lowercased() == "completed"})
                
                if filtered.count == 1
                {
                    self?.isFinanceTabVisible = true
                    DispatchQueue.main.async {
                        self?.setupViewControllers()
                    }
                }
                
            case.failure(let err):
                print(err.localizedDescription)
            }
        }
    }

}
extension TabBarVC : UITabBarControllerDelegate
{
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let rootView = self.viewControllers![self.selectedIndex] as! UINavigationController
        rootView.popToRootViewController(animated: false)
        
    }
}


extension UIViewController
{
    
   static func instace() -> Self{
        
        let instance = UIStoryboard(name: "NewDesignsV4", bundle: nil).instantiateViewController(withIdentifier: String(describing: self)) as! Self
        return instance
    }
}


struct TabBarItemStruct
{
    let viewController : UIViewController.Type
    let title : String
    let selectedItemImage : String
    let unSelectedItemImage : String
}
