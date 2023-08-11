//
//  Tabbarscreens.swift
//  BurbankApp
//
//  Created by Naveen Kourampalli on 02/05/23.
//  Copyright © 2023 Sreekanth tadi. All rights reserved.
//

import UIKit

class Tabbarscreens: HomeCareBaseProfileVC {

    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.tableview.register(UINib(nibName: "HomeCareFilesTVC", bundle: nil), forCellReuseIdentifier: "HomeCareFilesTVC")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // profileView.notificationCountLb.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        setUpProfileView()
        addTopBordertoTabBar(vc: self)
        
    }
    
    func setUpProfileView(){
//        self.view.backgroundColor = AppColors.AppGray
        profileBaseView.navigationView.backgroundColor = AppColors.AppGray
        profileBaseView.contentView.backgroundColor = AppColors.appGray
        profileBaseView.descriptionLBL.textColor = .black
        profileBaseView.profileView.image = UIImage(named: "BurbankLogo_Black")
        profileBaseView.titleLBL.textColor = .black
        profileBaseView.titleLBL.text = "My" + (self.navigationController?.tabBarItem.title?.capitalized ?? "")
        profileBaseView.baseImageView.image = UIImage(named: "")
        profileBaseView.baseImageView.backgroundColor = AppColors.AppGray
        profileBaseView.profileBaseView.backgroundColor = AppColors.AppGray.withAlphaComponent(0.6)
        setAppearanceFor(view: profileBaseView.titleLBL, backgroundColor: .clear, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_BODY (size: FONT_22))
        setAppearanceFor(view: profileBaseView.descriptionLBL, backgroundColor: .clear, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_BODY (size: FONT_10))
        
        setAttributetitleFor(view: profileBaseView.descriptionLBL, title: "All the guides to the great appliances and services in your new home \(CurrentUser.jobNumber ?? "").", rangeStrings: ["All the guides to the great appliances and services in your new home ", "\(CurrentUser.jobNumber ?? "")."], colors: [APPCOLORS_3.Black_BG, APPCOLORS_3.Orange_BG], fonts: [FONT_LABEL_BODY (size: FONT_9), FONT_LABEL_SEMI_BOLD (size: FONT_9)], alignmentCenter: false)
        
//        profileBaseView.menuAndBackBtn.setImage(UIImage(systemName:"arrow.left", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
//        getTabBardetail()
       
        
    }

}
extension Tabbarscreens : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCareFilesTVC", for: indexPath) as! HomeCareFilesTVC
        
        switch self.navigationController?.tabBarItem.title {
        case "MANUALS":
            cell.imageCategory.image = UIImage(named: "Ico-ManualCircle")
            break
        case "DOCUMENTS":
            cell.imageCategory.image = UIImage(named: "Ico-DocumentCircle")
            break
        case "WARRANTIES":
            cell.imageCategory.image = UIImage(named: "Ico-WarrantiesCircle")
            break
        case "SUPPORT":
            cell.imageCategory.image = UIImage(named: "Ico-Support-circle")
            break
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = HMCPDFViewerVC.instace(sb: .homeScreenSb)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
