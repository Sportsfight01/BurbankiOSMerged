//
//  TabBarVC.swift
//  BurbankApp
//
//  Created by naresh banavath on 08/12/21.
//  Copyright © 2021 DMSS. All rights reserved.
//

import Foundation

import UIKit

class TabBarVC: UITabBarController, UITabBarControllerDelegate {

    let HEIGHT_TAB_BAR = 70.0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.unselectedItemTintColor = UIColor.darkGray
        self.tabBar.tintColor = AppColors.appOrange
        self.tabBar.backgroundColor = UIColor.white
        self.delegate = self
//        let storyBoard = UIStoryboard(name: "NewDesignsV4", bundle: nil)
//        let MyProgressView = storyBoard.instantiateViewController(withIdentifier: "MyProgressVC") as! MyProgressVC
//        let FirstNVC = UINavigationController(rootViewController: MyProgressView)
//
//        self.viewControllers = [FirstNVC]
//        let homeImage = UIImage(named: "icon_Progress")
//        let homeButton = UITabBarItem(title: "Home", image: homeImage, selectedImage: homeImage)
//        MyProgressView.tabBarItem = homeButton
        
        setTabBarItems()
            //    tabBar.itemWidth = 20
        //tabBar.itemSpacing = 10
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
    
    func setTabBarItems(){
        
        let myTabBarItem1 = (self.tabBar.items?[0])! as UITabBarItem
        myTabBarItem1.image = UIImage(named: "Progress_grey")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem1.selectedImage = UIImage(named: "Progress_orange")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem1.title = "PROGRESS"

    //  myTabBarItem1.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 6)
      //  myTabBarItem1.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        let myTabBarItem2 = (self.tabBar.items?[1])! as UITabBarItem
        myTabBarItem2.image = UIImage(named: "Details_grey")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem2.selectedImage = UIImage(named: "Details_orange")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem2.title = "DETAILS"
   //   myTabBarItem2.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 6)
      //  myTabBarItem2.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        
        let myTabBarItem3 = (self.tabBar.items?[2])! as UITabBarItem
        myTabBarItem3.image = UIImage(named: "Photos_grey")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem3.selectedImage = UIImage(named: "Photos_orange")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem3.title = "PHOTOS"
    //  myTabBarItem3.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 6)
       // myTabBarItem3.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        let myTabBarItem4 = (self.tabBar.items?[3])! as UITabBarItem
        myTabBarItem4.image = UIImage(named: "Documents_grey")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem4.selectedImage = UIImage(named: "Documents_orange")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem4.title = "DOCUMENTS"
    //  myTabBarItem4.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 6)
        //myTabBarItem4.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
        
        let myTabBarItem5 = (self.tabBar.items?[4])! as UITabBarItem
        myTabBarItem5.image = UIImage(named: "Finance_grey")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem5.selectedImage = UIImage(named: "Finance_orange")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem5.title = "FINANCE"
  //    myTabBarItem5.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 6)
     //   myTabBarItem5.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        let selectedColor   = AppColors.appOrange
        let unselectedColor = AppColors.appGray

        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: unselectedColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor], for: .selected)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
