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
    
    fileprivate var defaultTabBarHeight : CGFloat { tabBar.frame.size.height }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

        
        self.delegate = self
        // Do any additional setup after loading the view.
        
        
        self.tabBar.backgroundColor = AppColors.white
        
        
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: AppColors.appOrange, .font: FONT_LABEL_HEADING(size: FONT_9)], for: .selected)
        
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: AppColors.lightGray, .font: FONT_LABEL_BODY(size: FONT_9)], for: .normal)
      //  print(hasTopNotch)
    
                
//        if UIDevice.current.hasNotch == false {
//            UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -4)
//        }
        //UITabBarItem.appearance().imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        if let items = self.tabBar.items {

            for item: UITabBarItem in items {
                if item.title?.lowercased() == "favourites"
                {
                    if #available(iOS 13.0, *) {
                        item.image = UIImage(systemName: "heart")?.withBaselineOffset(fromBottom: 5)
                    } else {
                        // Fallback on earlier versions
                        item.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
                    }
                    
                }else {
                    item.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
                }
            }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        if UIDevice.current.hasNotch == false {
//            let newTabBarHeight = CGFloat(60)
//            tabBar.frame.size.height = newTabBarHeight
//            tabBar.frame.origin.y = self.view.frame.size.height - newTabBarHeight
//        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let afterLoad = afterLoad {
            afterLoad ()
        }
    }
//    override func viewWillLayoutSubviews() {
//          super.viewWillLayoutSubviews()
//
//      }
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
        }else if tabBarController.selectedIndex == 1 {
            CodeManager.sharedInstance.sendScreenName(burbank_homeDesigns_homeAndLand_tabBarButton_touch)
        }
        else if tabBarController.selectedIndex == 2 {
            CodeManager.sharedInstance.sendScreenName(burbank_homeDesigns_homeAndLand_tabBarButton_touch)
        }
        else if tabBarController.selectedIndex == 3 {
            CodeManager.sharedInstance.sendScreenName(burbank_homeDesigns_homeAndLand_tabBarButton_touch)
            
        }
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController)!
        if selectedIndex == 3 {
            print("favorites tab bar was selected")
            if noNeedofGuestUserToast(self, message: "Please login to add favourites") {
                if viewController.isKind(of: UINavigationController.self) {
                    (viewController as! UINavigationController).interactivePopGestureRecognizer?.isEnabled = false
                }
            }else{
                return false
            }
        } else {
            if viewController.isKind(of: UINavigationController.self) {
                (viewController as! UINavigationController).interactivePopGestureRecognizer?.isEnabled = false
            }
        }
        
        return true
    }
    
}

extension UIDevice {
    /// Returns `true` if the device has a notch
    var hasNotch: Bool {
        guard #available(iOS 11.0, *), let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return false }
        if UIDevice.current.orientation.isPortrait {
            return window.safeAreaInsets.top >= 44
        } else {
            return window.safeAreaInsets.left > 0 || window.safeAreaInsets.right > 0
        }
    }
}
