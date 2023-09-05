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
//    var selectedTab  = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
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
        setStatusBarColor(color: AppColors.AppGray)
        //CARD VIEW
        tabBarShadowSetup()
        setupViewControllers()
        setupMultipleJobVc()
        
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
            let storyBoard : AppStoryBoards = item.storyboard ?? .homeScreenSb
            let vc = UINavigationController(rootViewController: item.viewController.instace(sb: storyBoard))
            vc.setNavigationBarHidden(true, animated: true)
            vc.tabBarItem = UITabBarItem(title: item.title, image: UIImage(named : item.unSelectedItemImage) , selectedImage: UIImage(named : item.selectedItemImage))
            
            return vc
        }
       
       
    }
    func didTappedOnCompleteAndLodgeBTN() {
        print(log: "close")
    }
    
    
    func setupMultipleJobVc()
    {
        
        let myplaceDetailsArray = appDelegate.currentUser?.userDetailsArray?.first?.myPlaceDetailsArray
        guard myplaceDetailsArray?.isEmpty == false else { return }// myplacedetailsarray is empty so return
        
        /// - User has multiple job numbers
        if (myplaceDetailsArray?.count ?? 0) > 1
        {
    
            let selectedJobNum = UserDefaults.standard.value(forKey: "selectedJobNumber") as? String
            if selectedJobNum == nil /// when user first come to select Job Number
            {
                self.tabBarController?.tabBar.isUserInteractionEnabled = false
                let vc = MultipleJobNumberVC.instace()
                vc.tableDataSource = myplaceDetailsArray?.compactMap({$0.jobNumber}) ?? []
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .coverVertical
                /// - if user loggedIn with Job Number show jobNumber as selected in multipleJobNumbers List
                if !isEmail(){
                    vc.previousJobNum = appDelegate.enteredEmailOrJob
                }
                /// - callback called after user selected job number from multiple jobnums
                vc.selectionClosure = {[weak self] selectedJobNumber in
                    UserDefaults.standard.set(selectedJobNumber, forKey: "selectedJobNumber")
                    self?.getUserProfile()
                    self?.tabBarController?.tabBar.isUserInteractionEnabled = true
                }
                self.present(vc, animated: true)
            }else { /// when user already selected a job from his multiple jobNums go with normal Flow
                CurrentUser.jobNumber = selectedJobNum
                self.getUserProfile()
            }
            
        }
        /// - Users with single JobNumber
        else
        {
            getUserProfile()
        }
    }

    func getUserProfile()
    {
        
        guard let userID = appDelegate.currentUser?.userDetailsArray?.first?.id else { return }
        let parameters : [String : Any] = ["Id" : userID]
        NetworkRequest.makeRequest(type: GetUserProfileStruct.self, urlRequest: Router.getUserProfile(parameters: parameters), showActivity: false) { [weak self]result in
            switch result
            {
            case .success(let data):
                //print(data)
                guard data.status == true else {
                    DispatchQueue.main.async {
                        self?.showAlert(message: data.message ?? somethingWentWrong)
                    };return}
                CurrentUser.email = data.result?.email
                CurrentUser.userName = data.result?.userName
                APIManager.shared.getJobNumberAndAuthorization()
//                self?.profileView.profilePicImgView.downloaded(from: data.result?.profilePicPath ?? "")
                
//                self?.setupProfile()
                
            case .failure(let err):
                print(err.localizedDescription)
                DispatchQueue.main.async {
                    self?.showAlert(message: err.localizedDescription)
                }
            }
        }
    }

}
extension HomeScreenTabBarVC : UITabBarControllerDelegate
{
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("---===---===---===---===--",item.title as Any)
        NotificationCenter.default.post(name: NSNotification.Name("hideWelcomeCard"), object: nil)

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
