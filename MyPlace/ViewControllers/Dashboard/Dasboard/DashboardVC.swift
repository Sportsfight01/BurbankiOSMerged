//
//  DashboardVC.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 26/03/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit

class DashboardVC: UITabBarController, UITabBarControllerDelegate {
    
    
    var previousSelection = 0
    var afterLoad: (() -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

        
        self.delegate = self
        // Do any additional setup after loading the view.
        
        
        self.tabBar.backgroundColor = COLOR_GRAY
        
        
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: COLOR_BLACK, .font: FONT_LABEL_HEADING(size: FONT_9)], for: .selected)
        
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: COLOR_DARK_GRAY, .font: FONT_LABEL_BODY(size: FONT_9)], for: .normal)
                
        
        if let items = self.tabBar.items {
            
            for item: UITabBarItem in items {
                
                item.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
            }
        }
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let afterLoad = afterLoad {
            afterLoad ()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let afterLoad = afterLoad {
            afterLoad ()
        }
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

    }
    
    
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
                
        if tabBarController.selectedIndex == 0 {
            CodeManager.sharedInstance.sendScreenName(burbank_homeDesigns_homeDesigns_tabBarButton_touch)
        }else {
            CodeManager.sharedInstance.sendScreenName(burbank_homeDesigns_homeAndLand_tabBarButton_touch)
        }
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if viewController.isKind(of: UINavigationController.self) {
            (viewController as! UINavigationController).interactivePopGestureRecognizer?.isEnabled = false
        }
        
        return true
    }
    
}

