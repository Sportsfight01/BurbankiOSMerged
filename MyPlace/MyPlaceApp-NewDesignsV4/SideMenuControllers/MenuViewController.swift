//
//  MenuViewController.swift
//  BurbankApp
//
//  Created by Naresh Banavath on 23/03/22.
//  Copyright © 2022 DMSS. All rights reserved.
//

import UIKit
import SideMenu

class MenuViewController: UIViewController {

    @IBOutlet weak var notificationCountLBL: UILabel!
    @IBOutlet var profileImgView: UIImageView!
    @IBOutlet weak var yourhomecurrentbuildLb: UILabel!
    @IBOutlet weak var usernameLb: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var imageIcons : [String] = ["icon_MyAppointment",/*"icon_MyHistory",*/"icon_MyDetails","icon_MySupport","Ico-Notification", "icon_AppSetting"]
    var tableDataSource : [String] = ["MyAppointments",/*"MyHistory",*/"MyDetails","MySupport","MyNotifications","MySettings"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.view.layer.shadowColor = APPCOLORS_3.GreyTextFont.cgColor
        self.view.layer.shadowOpacity = 0.7
        self.view.layer.shadowRadius = 5
        self.view.layer.shadowOffset = CGSize(width: 10, height: 10) // shadow on the bottom right
       // self.view.backgroundColor = AppColors.appOrange
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupProfile()
    }
    
    @IBAction func closeBtnClicked(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    func setupProfile()
    {
        profileImgView.contentMode = .scaleToFill
        profileImgView.clipsToBounds = true
        profileImgView.layer.cornerRadius = profileImgView.bounds.width/2
//        if let imgURlStr = CurrentUservars.profilePicUrl , let url = URL(string: imgURlStr)
//        {
////            profileImgView.sd_setImage(with: url, placeholderImage: UIImage(named: "icon_User"))
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
        usernameLb.text = CurrentUservars.userName
        let attrStr = NSMutableAttributedString(string: "Your home is currently ")
        let percentageAttrStr = NSAttributedString(string: CurrentUservars.currentHomeBuildProgress ?? "0%", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14.0 , weight: .semibold) , .foregroundColor : UIColor.white])
        let cmpletedStr = NSAttributedString(string: " completed")
        attrStr.append(percentageAttrStr)
        attrStr.append(cmpletedStr)
        yourhomecurrentbuildLb.attributedText = attrStr
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileClick(recognizer:)))
        profileImgView.addGestureRecognizer(tap)
        
    }
    @objc func handleProfileClick (recognizer: UIGestureRecognizer) {
        let vc = UIStoryboard(name: StoryboardNames.newDesing, bundle: nil).instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
        self.navigationController?.pushViewController(vc, animated: true)

    }

}
extension MenuViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {return UITableViewCell()}
        cell.selectionStyle = .none
        let contentView = cell.contentView.viewWithTag(50)!
        let imgView = contentView.viewWithTag(100) as! UIImageView
        imgView.image =  UIImage(named: imageIcons[indexPath.row])
        let titleLabel = contentView.viewWithTag(101) as! UILabel
        titleLabel.text = tableDataSource[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "NewDesignsV4", bundle: nil)
        var vc = storyboard.instantiateViewController(withIdentifier: "MyAppointmentsVC")
        switch indexPath.row
        {
        case 0://MyAppointments
            vc = storyboard.instantiateViewController(withIdentifier: "MyAppointmentsVC") as! MyAppointmentsVC
       /* case 1://MyHistory
            vc = storyboard.instantiateViewController(withIdentifier: "MyHistoryVC") as! MyHistoryVC*/
        case 1://MyContacts
            vc = storyboard.instantiateViewController(withIdentifier: "DetailsVC") as! DetailsVC
        case 2://MySupport
            vc = UIStoryboard(name: "NewDesignsV5", bundle: nil).instantiateViewController(withIdentifier: "SupportVC") as! SupportVC
        case 3://MyNotifications
            vc = storyboard.instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
        case 4://MySetting
            vc = storyboard.instantiateViewController(withIdentifier: "MySettingsVC") as! MySettingsVC
        default:
            break;
        }
        
        self.navigationController?.pushViewController(vc, animated: false)
        
    }
    
    
}
