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
        
//    func setTabBarItems(){
//
//        let myTabBarItem1 = (self.tabBar.items?[0])! as UITabBarItem
//        myTabBarItem1.image = UIImage(named: "Progress_grey")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//        myTabBarItem1.selectedImage = UIImage(named: "Progress_orange")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//        myTabBarItem1.title = "PROGRESS"
//
//    //  myTabBarItem1.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 6)
//      //  myTabBarItem1.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
//
//        let myTabBarItem2 = (self.tabBar.items?[1])! as UITabBarItem
//        myTabBarItem2.image = UIImage(named: "Contacts_grey")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//        myTabBarItem2.selectedImage = UIImage(named: "Contacts_orange")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//        myTabBarItem2.title = "CONTACTS"
//   //   myTabBarItem2.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 6)
//      //  myTabBarItem2.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
//
//
//        let myTabBarItem3 = (self.tabBar.items?[2])! as UITabBarItem
//        myTabBarItem3.image = UIImage(named: "Photos_grey")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//        myTabBarItem3.selectedImage = UIImage(named: "Photos_orange")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//        myTabBarItem3.title = "PHOTOS"
//    //  myTabBarItem3.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 6)
//       // myTabBarItem3.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
//
//        let myTabBarItem4 = (self.tabBar.items?[3])! as UITabBarItem
//        myTabBarItem4.image = UIImage(named: "Documents_grey")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//        myTabBarItem4.selectedImage = UIImage(named: "Documents_orange")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//        myTabBarItem4.title = "DOCUMENTS"
//    //  myTabBarItem4.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 6)
//        //myTabBarItem4.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
//
//        let myTabBarItem5 = (self.tabBar.items?[4])! as UITabBarItem
//        myTabBarItem5.image = UIImage(named: "Finance_grey")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//        myTabBarItem5.selectedImage = UIImage(named: "Finance_orange")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//        myTabBarItem5.title = "FINANCE"
//  //    myTabBarItem5.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 6)
//     //   myTabBarItem5.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
//        let selectedColor   = AppColors.appOrange
//        let unselectedColor = AppColors.appGray
//
//        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: unselectedColor], for: .normal)
//        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor], for: .selected)
//
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
