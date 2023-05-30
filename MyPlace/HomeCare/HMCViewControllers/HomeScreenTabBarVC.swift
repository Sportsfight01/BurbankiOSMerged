//
//  HomeScreenTabBarVC.swift
//  BurbankApp
//
//  Created by Naveen Kourampalli on 27/04/23.
//  Copyright © 2023 Sreekanth tadi. All rights reserved.
//

import UIKit

class HomeScreenTabBarVC: UITabBarController {
    
    let HEIGHT_TAB_BAR = 70.0
    
    var tabBarItems : [TabBarItemStruct] = []
    var isFinanceTabVisible : Bool = false
    var selectedTab  = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint("TabBarController", #function)
//        getProgressData()
        setupUI()
        
        if let viewControllers = viewControllers {
            for viewController in viewControllers {
                _ = viewController.view
            }
        }
        
     
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        var tabFrame = self.tabBar.frame
//        tabFrame.size.height = HEIGHT_TAB_BAR
//        tabFrame.origin.y = self.view.frame.size.height - HEIGHT_TAB_BAR
//        self.tabBar.frame = tabFrame
//        tabBar.itemWidth = 20
//        tabBar.itemSpacing = 10
        
       
    }
   
    
    //MARK: - Helper Methods
    func setupUI()
    {
        self.delegate = self
        //Tint COLOR
        self.tabBar.unselectedItemTintColor = UIColor.darkGray
        self.tabBar.tintColor = APPCOLORS_3.Black_BG
        //CARD VIEW
        tabBar.layer.shadowColor = UIColor.darkGray.cgColor
        tabBar.layer.shadowOpacity = 0.7
        tabBar.layer.shadowOffset = CGSize.zero
        tabBar.layer.shadowRadius = 5
        tabBar.backgroundColor = UIColor.white
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        setupViewControllers()
        
    }
    
    func setupViewControllers()
    {
        self.tabBarItems.removeAll()
        self.tabBarItems = [
            TabBarItemStruct(viewController: Tabbarscreens.self, title: "MANUALS", selectedItemImage: "Ico-ManualsBlack", unSelectedItemImage: "Ico-Manuals"),
            TabBarItemStruct(viewController: Tabbarscreens.self, title: "DOCUMENTS", selectedItemImage: "Ico-DocumentsBlack", unSelectedItemImage: "Ico-DocumentsHC"),
            TabBarItemStruct(viewController: Tabbarscreens.self, title: "WARRANTIES", selectedItemImage: "Ico-WarrantiesBlack", unSelectedItemImage: "Ico-Warranties"),
            TabBarItemStruct(viewController: Tabbarscreens.self, title: "REPORT", selectedItemImage: "Ico-ReportBlack", unSelectedItemImage: "Ico-Report"),
            TabBarItemStruct(viewController: Tabbarscreens.self, title: "HELP SECTION", selectedItemImage: "Ico-HelpBlack", unSelectedItemImage: "Ico-Help"),
        ]
        self.viewControllers = tabBarItems.map { item in
            let vc = UINavigationController(rootViewController: item.viewController.instace(sb: .homeScreenSb))
            vc.setNavigationBarHidden(true, animated: true)
            vc.tabBarItem = UITabBarItem(title: item.title, image: UIImage(named : item.unSelectedItemImage) , selectedImage: UIImage(named : item.selectedItemImage))
            
            return vc
            
        }
        self.selectedIndex = selectedTab
       
    }
    

}
extension HomeScreenTabBarVC : UITabBarControllerDelegate
{
//    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        let rootView = self.viewControllers![self.selectedIndex] as! UINavigationController
//        print(self.selectedIndex)
//        print(self.selectedViewController)
//        if let vc = self.selectedViewController as? HomeCareDashBoardScreenVC{
//            vc.selectedTabBar = self.selectedIndex
//        }
//
//        rootView.popViewController(animated: false)
//
//    }
}
