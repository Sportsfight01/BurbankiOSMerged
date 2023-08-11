//
//  HomeScreenTabBarVC.swift
//  BurbankApp
//
//  Created by Naveen Kourampalli on 27/04/23.
//  Copyright © 2023 Sreekanth tadi. All rights reserved.
//

import UIKit

class HomeScreenTabBarVC: UITabBarController, didTappedOncomplete {
    
    
    
    let HEIGHT_TAB_BAR = 70.0
    
    var tabBarItems : [TabBarItemStruct] = []
    var isFinanceTabVisible : Bool = false
    var selectedTab  = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    //MARK: - Helper Methods
    func setupUI()
    {
        self.delegate = self
        //Tint COLOR
        self.tabBar.unselectedItemTintColor = UIColor.darkGray
        self.tabBar.tintColor = APPCOLORS_3.Black_BG
        
        let appearance = UITabBarAppearance()
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.font : mediumFontWith(size: 11)]
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.font : regularFontWith(size: 10)]
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        //CARD VIEW
        tabBarShadowSetup()
        setupViewControllers()
        
        
        
    }
    //adding shadow to tabbar
    func tabBarShadowSetup()
    {
        tabBar.layer.shadowColor = UIColor.darkGray.cgColor
        tabBar.layer.shadowOpacity = 0.9
        tabBar.layer.shadowOffset = CGSize.zero
        tabBar.layer.shadowRadius = 5
        tabBar.backgroundColor = UIColor.white
        addTopBordertoTabBar(vc: self)
        

    }
    func setupViewControllers()
    {
        self.tabBarItems.removeAll()
        self.tabBarItems = [
            TabBarItemStruct(viewController: Tabbarscreens.self, title: "MANUALS", selectedItemImage: "Ico-ManualsBlack", unSelectedItemImage: "Ico-Manuals"),
            TabBarItemStruct(viewController: Tabbarscreens.self, title: "DOCUMENTS", selectedItemImage: "Ico-DocumentsBlack", unSelectedItemImage: "Ico-DocumentsHC"),
            TabBarItemStruct(viewController: Tabbarscreens.self, title: "WARRANTIES", selectedItemImage: "Ico-WarrantiesBlack", unSelectedItemImage: "Ico-Warranties"),
            TabBarItemStruct(viewController: ReportIssueHomeVC.self,storyboard : .reports, title: "REPORT", selectedItemImage: "Ico-ReportBlack", unSelectedItemImage: "Ico-Report"),
            TabBarItemStruct(viewController: Tabbarscreens.self, title: "SUPPORT", selectedItemImage: "Ico-HelpBlack", unSelectedItemImage: "Ico-Help"),
        ]
        self.viewControllers = tabBarItems.map { item in
//            if item.title == "REPORT"{
//                let storyboard : UIStoryboard = UIStoryboard(name: "Report", bundle: nil)
//                let popupVC = storyboard.instantiateViewController(withIdentifier: "CompleteAndLodgePopUPVC") as! CompleteAndLodgePopUPVC
//                popupVC.modalPresentationStyle = .overCurrentContext
//                popupVC.modalTransitionStyle = .crossDissolve
//                popupVC.delegate = self
//                popupVC.isPopUpFromHomeScreen = true
//                present(popupVC, animated: true, completion: nil)
//            }
            
            let storyBoard : AppStoryBoards = item.storyboard ?? .homeScreenSb
            let vc = UINavigationController(rootViewController: item.viewController.instace(sb: storyBoard))
            vc.setNavigationBarHidden(true, animated: true)
            vc.tabBarItem = UITabBarItem(title: item.title, image: UIImage(named : item.unSelectedItemImage) , selectedImage: UIImage(named : item.selectedItemImage))
            
            return vc
            
        }
        self.selectedIndex = selectedTab
       
    }
    func didTappedOnCompleteAndLodgeBTN() {
        print(log: "close")
    }

}
extension HomeScreenTabBarVC : UITabBarControllerDelegate
{
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("---===---===---===---===--",item.title as Any)
        if item.title! == "REPORT"{
            let storyboard : UIStoryboard = UIStoryboard(name: "Report", bundle: nil)
            let popupVC = storyboard.instantiateViewController(withIdentifier: "CompleteAndLodgePopUPVC") as! CompleteAndLodgePopUPVC
            popupVC.modalPresentationStyle = .overCurrentContext
            popupVC.modalTransitionStyle = .crossDissolve
            popupVC.delegate = self
            popupVC.isPopUpFromHomeScreen = true
            present(popupVC, animated: true, completion: nil)
            
        }
    }
}
extension UIImage {
    class func colorForNavBar(color: UIColor) -> UIImage {
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()

        context!.setFillColor(color.cgColor)
        context!.fill(rect)

        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()

        return image
    }
}
