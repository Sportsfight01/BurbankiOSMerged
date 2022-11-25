//
//  MyPlaceWithTabBarVC.swift
//  BurbankApp
//
//  Created by dmss on 26/04/17.
//  Copyright © 2017 DMSS. All rights reserved.
//

import UIKit


class MyPlaceWithTabBarVC: UITabBarController, UITabBarControllerDelegate
    //class MyPlaceWithTabBarVC: BurbankAppVC,UITabBarDelegate
{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        if viewController.isKind(of: UINavigationController.self), (viewController as! UINavigationController).viewControllers[0].isKind(of: MyPlaceTabbarDetailVC.self) {
            ((viewController as! UINavigationController).viewControllers[0] as! MyPlaceTabbarDetailVC).selectedTag = 127
        }
    }
    
    
}
