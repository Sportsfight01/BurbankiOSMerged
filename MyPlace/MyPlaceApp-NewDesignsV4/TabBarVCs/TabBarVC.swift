//
//  TabBarVC.swift
//  BurbankApp
//
//  Created by naresh banavath on 08/12/21.
//  Copyright © 2021 DMSS. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

class TabBarVC: UITabBarController {

    let HEIGHT_TAB_BAR = 70.0
    
    var tabBarItems : [TabBarItemStruct] = []
    var isFinanceTabVisible : Bool = false
    let realm = try! Realm()
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
       
    }
    
    //MARK: - Helper Methods
    
    func setupUI()
    {
        self.delegate = self
        //Tint COLOR
        self.tabBar.unselectedItemTintColor = UIColor.darkGray
        self.tabBar.tintColor = AppColors.appOrange
    
        //CARD VIEW
        tabBar.layer.shadowColor = UIColor.darkGray.cgColor
        tabBar.layer.shadowOpacity = 0.7
        tabBar.layer.shadowOffset = CGSize.zero
        tabBar.layer.shadowRadius = 5
        tabBar.backgroundColor = UIColor.white
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBarItem.appearance().setTitleTextAttributes([.font : FONT_LABEL_SUB_HEADING(size: FONT_8)], for: .normal)
   
            self.setupViewControllers()
        
       
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
        self.viewControllers = tabBarItems.map { item in
            let vc = UINavigationController(rootViewController: item.viewController.instace())
            vc.setNavigationBarHidden(true, animated: true)
            vc.tabBarItem = UITabBarItem(title: item.title, image: UIImage(named : item.unSelectedItemImage) , selectedImage: UIImage(named : item.selectedItemImage))
            
            return vc
            
        }
       
    }
    
    

}
extension TabBarVC : UITabBarControllerDelegate
{
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let rootView = self.viewControllers![self.selectedIndex] as! UINavigationController
        rootView.popToRootViewController(animated: false)
//        let hapticGenerator = UISelectionFeedbackGenerator()
//        hapticGenerator.prepare()
//        hapticGenerator.selectionChanged()
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
        
    }
}



struct TabBarItemStruct
{
    let viewController : UIViewController.Type
    let storyboard : AppStoryBoards?
    let title : String
    let selectedItemImage : String
    let unSelectedItemImage : String
    init(viewController: UIViewController.Type, storyboard: AppStoryBoards? = nil, title: String, selectedItemImage: String, unSelectedItemImage: String) {
        self.viewController = viewController
        self.storyboard = storyboard
        self.title = title
        self.selectedItemImage = selectedItemImage
        self.unSelectedItemImage = unSelectedItemImage
    }
}
