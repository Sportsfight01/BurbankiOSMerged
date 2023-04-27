//
//  SupportVC.swift
//  BurbankApp
//
//  Created by Naveen on 15/12/21.
//  Copyright © 2021 DMSS. All rights reserved.
//

import UIKit

class SupportVC: UIViewController {
    
    let gradientLayer = CAGradientLayer()
    
    @IBOutlet weak var headerLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var notificationCountLBL: UILabel!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var wholeView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var titleText = ["Info Centre","FAQs"/*,"Contact Us"*/]

    var subjectText = ["Helpful videos and information to explain some of the stages in your build and what you need to know.","Find answers to our most Frequently Asked Questions."/*,"Or simply get in touch here so we can help you directly."*/]
 

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        // tableView.allowsSelection = false
        // navigationController?.setNavigationBarHidden(true, animated: true)
        //addGradientLayer()
        // setupProfile()
        self.view.backgroundColor = AppColors.myplaceGray 
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBarButtons(title: "", backButton: true, notificationIcon: false)
        setupProfile()
        headerLeadingConstraint.constant = self.getLeadingSpaceForNavigationTitleImage()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.shouldRemoveShadow(true)
    }
    func setupProfile()
    {
        profileImgView.contentMode = .scaleToFill
        profileImgView.clipsToBounds = true
        profileImgView.layer.cornerRadius = profileImgView.bounds.width/2
        //        if let imgURlStr = CurrentUservars.profilePicUrl , let url = URL(string: imgURlStr)
        //        {
        //           // profileImgView.sd_setImage(with: url, placeholderImage: UIImage(named: "icon_User"))
        //            profileImgView.downloaded(from: url)
        //        }
        
        if let imgURlStr = CurrentUservars.profilePicUrl
        {
            // profileImgView.sd_setImage(with: url, placeholderImage: UIImage(named: "icon_User"))
            profileImgView.image = imgURlStr
        }
        
        //        profileImgView.addBadge(number: appDelegate.notificationCount)
        if appDelegate.notificationCount == 0{
            notificationCountLBL.isHidden = true
        }else{
            notificationCountLBL.text = "\(appDelegate.notificationCount)"
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileClick(recognizer:)))
        profileImgView.addGestureRecognizer(tap)
        
        
        
        
    }
    @objc func handleProfileClick (recognizer: UIGestureRecognizer) {
        //        let vc = UIStoryboard(name: StoryboardNames.newDesing, bundle: nil).instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
                let vc = NotificationsVC.instace(sb: .newDesignV4)
                self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func addGradientLayer()
    {
        
        gradientLayer.locations = [0.5,1]
        gradientLayer.colors = [AppColors.myplaceGray.cgColor,APPCOLORS_3.HeaderFooter_white_BG.cgColor]
        //      gradientLayer.colors = [AppColors.appOrange.cgColor , UIColor(red: 230/255, green: 177/255, blue: 79/255, alpha: 1.0).cgColor]
        gradientLayer.frame = wholeView.bounds
        self.wholeView.layer.insertSublayer(gradientLayer, at: 0)
    }
    @IBAction func didTappedOnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func didTappedOnSupport(_ sender: UIButton) {
    }
    
}
extension SupportVC : UITableViewDelegate , UITableViewDataSource
{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return titleText.count
    
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "SupportTVC") as! SupportTVC
    cell.titleLBL.text = titleText[indexPath.row]
    cell.subjectLBL.text = subjectText[indexPath.row]
    cell.seeMoreBTN.tag = indexPath.row
//cell.seeMoreBTN.addTarget(self, action: #selector(didTappedOnSeemore(sender:)), for: .touchUpInside)
    return cell
  }
  @objc func didTappedOnSeemore(sender : UIButton){
    let vc = UIStoryboard(name: "NewDesignsV5", bundle: nil).instantiateViewController(withIdentifier: "InfoCentreVC") as! InfoCentreVC
    self.navigationController?.pushViewController(vc, animated: true)
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
   // var vc : UIViewController!
    switch indexPath.row {
    case 0: //Info
      let vc = UIStoryboard(name: StoryboardNames.newDesing5, bundle: nil).instantiateViewController(withIdentifier: "InfoCentreVC") as! InfoCentreVC
        self.navigationController?.pushViewController(vc, animated: true)
    case 1: //FAQs
      let vc = UIStoryboard(name : StoryboardNames.newDesing, bundle: nil).instantiateViewController(withIdentifier: "FAQsVc") as! FAQsVc
        self.navigationController?.pushViewController(vc, animated: true)
    case 2://Contact Us
      let vc = UIStoryboard(name : StoryboardNames.newDesing5, bundle: nil).instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    default:
      break
    }
   //   self.navigationController?.pushViewController(vc, animated: true)
  }
  
}
