//
//  CustomersUserpreferrenceVC.swift
//  BurbankApp
//
//  Created by Naresh Banavath on 29/05/23.
//  Copyright © 2023 Sreekanth tadi. All rights reserved.
//
import UIKit

class CustomersUserpreferrenceVC: UIViewController {
   
    @IBOutlet weak var downArrowOnIMG: UIImageView!
    
    @IBOutlet weak var jobnNumberBTN: UIButton!
    @IBOutlet weak var nameLBL: UILabel!
    @IBOutlet weak var helloLBL: UILabel!
    
    @IBOutlet weak var buildProgressBTN: UIButton!
    @IBOutlet weak var buildProgressView: UIView!
    
    @IBOutlet weak var homeCareView: UIView!
    @IBOutlet weak var homeCareBTN: UIButton!

    var userData : User!
    var isFromMenu = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true

    }
    
    func setupUI(){
        
        if let selectedJobNum = UserDefaults.standard.value(forKey: "selectedJobNumber") as? String{
            self.jobnNumberBTN.setTitle("  \(selectedJobNum )", for: .normal)
        }else{
            if isEmail(){
                self.jobnNumberBTN.setTitle("  \(CurrentUser.jobNumber ?? "")", for: .normal)
            }else{
                self.jobnNumberBTN.setTitle("  \(appDelegate.currentUser?.jobNumber ?? "")", for: .normal)
            }
        }
        var myplaceDetailsArray = [MyPlaceDetails]()
        
        if userData != nil{
            myplaceDetailsArray = (userData.userDetailsArray?.first!.myPlaceDetailsArray)!
        }else{
            myplaceDetailsArray = (appDelegate.currentUser?.userDetailsArray?.first!.myPlaceDetailsArray)!
        }
        //*** Users With Multiple Job Numbers ***//
        if (myplaceDetailsArray.count ?? 0) < 1
        {
            self.downArrowOnIMG.isHidden = true
            self.jobnNumberBTN.contentHorizontalAlignment = .center
        }
        
        if !isFromMenu{
            setupMultipleJobVc()
        }
        
        nameLBL.text = appDelegate.currentUser?.userDetailsArray?.first?.firstName ?? ""
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        setStatusBarColor(color: .white)
        UIApplication.shared.statusBarView?.backgroundColor = .white

    }

    @IBAction func didTappedOnBuildProgress(_ sender: UIButton) {
        CodeManager.sharedInstance.handleUserLoginSuccess(user: appDelegate.currentUser!, In: self)
    }
    @IBAction func didTappedOnHomeCare(_ sender: UIButton) {
        CodeManager.sharedInstance.handleUserHomecareModule(user: appDelegate.currentUser!, In: self)
    }
    
    @IBAction func didTappedOnJobNumber(_ sender: UIButton) {
        setupMultipleJobVc()
    }
    func setupMultipleJobVc()
    {
        
        var myplaceDetailsArray = [MyPlaceDetails]()
        
        if userData != nil{
            myplaceDetailsArray = (userData.userDetailsArray?.first!.myPlaceDetailsArray)!
        }else{
            myplaceDetailsArray = (appDelegate.currentUser?.userDetailsArray?.first!.myPlaceDetailsArray)!
        }
        //*** Users With Multiple Job Numbers ***//
        if (myplaceDetailsArray.count ?? 0) > 1
        {// user has multiple job numbers
            let selectedJobNum = UserDefaults.standard.value(forKey: "selectedJobNumber") as? String
            
                self.tabBarController?.tabBar.isUserInteractionEnabled = false
                let vc = MultipleJobNumberVC.instace()
            vc.tableDataSource = myplaceDetailsArray.compactMap({$0.jobNumber}) ?? []
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .coverVertical
                //*if user loggedIn with Job Number show jobNumber as selected in multipleJobNumbers List
                if !isEmail(){
                    if selectedJobNum != nil{
                        vc.previousJobNum = selectedJobNum
                    }else{
                        vc.previousJobNum = appDelegate.enteredEmailOrJob
                    }
                   
                }
                vc.selectionClosure = {[weak self] selectedJobNumber in
                    UserDefaults.standard.set(selectedJobNumber, forKey: "selectedJobNumber")
                    self?.tabBarController?.tabBar.isUserInteractionEnabled = true
                    self?.jobnNumberBTN.setTitle("  \(selectedJobNumber )", for: .normal)
                    CurrentUser.jobNumber = selectedJobNumber

                }
                self.present(vc, animated: true)
        }else{
            self.jobnNumberBTN.isEnabled = false
            CurrentUser.jobNumber = myplaceDetailsArray[0].jobNumber
            if isEmail(){
                self.jobnNumberBTN.setTitle("  \(myplaceDetailsArray[0].jobNumber ?? "")", for: .normal)
            }
            
            self.downArrowOnIMG.isHidden = true
            self.jobnNumberBTN.contentHorizontalAlignment = .center
        }
    }
    

 
}
