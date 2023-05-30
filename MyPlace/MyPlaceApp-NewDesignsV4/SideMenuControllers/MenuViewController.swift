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
    var tableDataSource : [SideMenuItem] = SideMenuItem.allCases
    
    var isHomecareSideMenu = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        cardViewSetup()
        tableView.isScrollEnabled = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupProfile()
        checkForMultipleJobNums()
        
    }
    
    //MARK: - Helper Methods
    func cardViewSetup()
    {
        self.view.layer.shadowColor = APPCOLORS_3.GreyTextFont.cgColor
        self.view.layer.shadowOpacity = 0.7
        self.view.layer.shadowRadius = 5
        self.view.layer.shadowOffset = CGSize(width: 10, height: 10)
    }
    
    func checkForMultipleJobNums()
    {
        let myplaceDetailsArray = appDelegate.currentUser?.userDetailsArray?.first?.myPlaceDetailsArray
        if myplaceDetailsArray?.count == 1// Users with only one Job Number
        {
            tableDataSource.removeAll(where: { $0 == .changeJobNumber})
        }
        tableView.reloadData()
    }
    
    func presentMultipleJobVc()
    {
       // self.dismiss(animated: true)
       
        let myplaceDetailsArray = appDelegate.currentUser?.userDetailsArray?.first?.myPlaceDetailsArray
        let vc = MultipleJobNumberVC.instace()
        vc.tableDataSource = myplaceDetailsArray?.compactMap({$0.jobNumber}) ?? []
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .coverVertical
        vc.selectionClosure = { selectedJobNumber in
            CurrentUser.jobNumber = selectedJobNumber
            UserDefaults.standard.set(selectedJobNumber, forKey: "selectedJobNumber")
            kWindow.rootViewController = UIStoryboard(name: "NewDesignsV4", bundle: nil).instantiateInitialViewController()
            kWindow.makeKeyAndVisible()
        }
        kWindow.rootViewController?.present(vc, animated: true)
        

    }
    
    @IBAction func closeBtnClicked(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    func setupProfile()
    {
        profileImgView.contentMode = .scaleToFill
        profileImgView.clipsToBounds = true
        profileImgView.layer.cornerRadius = profileImgView.bounds.width/2
        if let imgURlStr = CurrentUser.profilePicUrl
        {
            profileImgView.image = imgURlStr
        }
        if appDelegate.notificationCount == 0{
            notificationCountLBL.isHidden = true
        }else{
            notificationCountLBL.text = "\(appDelegate.notificationCount)"
        }
        usernameLb.text = CurrentUser.userName
        
        var yourHomeBuild = "Your home \(CurrentUser.jobNumber ?? "") is currently \(CurrentUser.currentHomeBuildProgress ?? "0%") completed"
        
        setAttributetitleFor(view: yourhomecurrentbuildLb, title: yourHomeBuild, rangeStrings: ["Your home" , CurrentUser.jobNumber ?? "", "is currently", "\(CurrentUser.currentHomeBuildProgress ?? "0%")" , "completed"], colors: [.white,APPCOLORS_3.Orange_BG,.white,.white,.white], fonts: [FONT_LABEL_BODY(size: FONT_10), boldFontWith(size: FONT_10),FONT_LABEL_BODY(size: FONT_10),boldFontWith(size: FONT_10),FONT_LABEL_BODY(size: FONT_10)], alignmentCenter: false)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileClick(recognizer:)))
        profileImgView.addGestureRecognizer(tap)
        if isHomecareSideMenu{
            yourHomeBuild = "Home Care\nChange phase"
            setAttributetitleFor(view: yourhomecurrentbuildLb, title: yourHomeBuild, rangeStrings: ["Home Care", "Change phase"], colors: [.white,.white], fonts: [ProximaNovaSemiBold(size: FONT_13),ProximaNovaRegular(size: FONT_11)], alignmentCenter: false)
            yourhomecurrentbuildLb.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleChangePhase(recognizer:)))
            yourhomecurrentbuildLb.addGestureRecognizer(tap)
            usernameLb.text = "Mitchell Symonds"
        }
        
        
    }
    @objc func handleProfileClick (recognizer: UIGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)

//        let vc = UIStoryboard(name: StoryboardNames.newDesing, bundle: nil).instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
        let vc = NotificationsVC.instace(sb: .newDesignV4)
        self.navigationController?.pushViewController(vc, animated: true)
        self.dismiss(animated: false)

    }

    @objc func handleChangePhase (recognizer: UIGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)

        let vc = UIStoryboard(name: "MyPlaceLogin", bundle: nil).instantiateViewController(withIdentifier: "CustomersUserpreferrenceVC") as! CustomersUserpreferrenceVC
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
}
//MARK: - TableView DataSource & Delegate
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
        imgView.image =  UIImage(named: tableDataSource[indexPath.row].iconName)?.withRenderingMode(.alwaysTemplate).withTintColor(.white)
        let titleLabel = contentView.viewWithTag(101) as! UILabel
        titleLabel.text = tableDataSource[indexPath.row].rawValue
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.dismiss(animated: true)
        if let vc = tableDataSource[indexPath.row].viewController {
            self.navigationController?.pushViewController(vc, animated: false)
        } else {//change Job Number case
            presentMultipleJobVc()
        }
        
    }

    
    
}

//MARK: - Models
extension MenuViewController
{
    enum SideMenuItem : String, CaseIterable
    {
        case changeJobNumber = "MyJobNumber"
        case appointment     = "MyAppointments"
        case details         = "MyDetails"
        case support         = "MySupport"
        case notifications   = "MyNotifications"
        case settings        = "MySettings"
        
        
        var iconName : String
        {
            switch self
            {
                
            case .appointment:
                return "icon_MyAppointment"
            case .details:
                return "icon_MyDetails"
            case .support:
                return "icon_MySupport"
            case .notifications:
                return "Ico-Notification"
            case .settings:
                return "icon_AppSetting"
            case .changeJobNumber:
                return "icon_password"
            }
        }
        
        var viewController : UIViewController?
        {
            switch self
            {
                
            case .appointment:
                return MyAppointmentsVC.instace()
            case .details:
                return DetailsVC.instace()
            case .support:
                return SupportVC.instace(sb: .supportAndHelp)
            case .notifications:
                return NotificationsVC.instace()
            case .settings:
                return MySettingsVC.instace()
            case .changeJobNumber:
                return nil
            }
        }
    }
    
}
