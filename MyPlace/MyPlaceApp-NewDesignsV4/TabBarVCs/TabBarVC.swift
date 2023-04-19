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
        debugPrint("TabBarController", #function)
//        getProgressData()
        setupUI()
        
     
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
        self.tabBar.tintColor = AppColors.appOrange
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
            TabBarItemStruct(viewController: MyProgressVC.self, title: "PROGRESS", selectedItemImage: "Progress_orange", unSelectedItemImage: "Progress_grey"),
            TabBarItemStruct(viewController: MyContactsVC.self, title: "CONTACTS", selectedItemImage: "Contacts_orange", unSelectedItemImage: "Contacts_grey"),
            TabBarItemStruct(viewController: PhotosVC.self, title: "PHOTOS", selectedItemImage: "Photos_orange", unSelectedItemImage: "Photos_grey"),
            TabBarItemStruct(viewController: DocumentsVC.self, title: "DOCUMENTS", selectedItemImage: "Documents_orange", unSelectedItemImage: "Documents_grey"),
        ]
        self.viewControllers = tabBarItems.map { item in
            let vc = UINavigationController(rootViewController: item.viewController.instace())
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
        
    }
}


extension UIViewController
{
    #warning("Storyboard ID must be same as ViewController Name to utilize below method")
    static func instace(sb : StoryBoard = .newDesignV4) -> Self{
        
        let instance = UIStoryboard(name: sb.rawValue, bundle: nil).instantiateViewController(withIdentifier: String(describing: self)) as! Self
        return instance
    }
    
    enum StoryBoard : String
    {
        case newDesignV4 = "NewDesignsV4"
        case newDesignV5 = "NewDesignsV5"
        case myPlaceLogin = "MyPlaceLogin"
    }
}


struct TabBarItemStruct
{
    let viewController : UIViewController.Type
    let title : String
    let selectedItemImage : String
    let unSelectedItemImage : String
}
