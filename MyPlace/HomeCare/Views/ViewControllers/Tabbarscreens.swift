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
    var tableArr = [tableData]()
    
    @IBOutlet weak var baseView: UIView!
    
    @IBOutlet weak var continueBTN: UIButton!
    var isWelcomeCardHidden1 = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.tableview.register(UINib(nibName: "HomeCareFilesTVC", bundle: nil), forCellReuseIdentifier: "HomeCareFilesTVC")
        self.navigationController?.setNavigationBarHidden(true, animated: true)

        tableArr = [tableData(pdfFileName: "Dishlex Dishwasher Manual.pdf", createdDate: "Uploaded on: 20 June, 2021, 05:51am"),
                    tableData(pdfFileName: "Rheem Hotwater System Manual.pdf", createdDate: "Uploaded on: 20 June, 2021, 05:51am"),
                    tableData(pdfFileName: "Steel-line Garage Door Manual.pdf", createdDate: "Uploaded on: 20 June, 2021, 05:51am"),
                    tableData(pdfFileName: "NBN Modem Manual.pdf", createdDate: "Uploaded on: 20 June, 2021, 05:51am"),
                    tableData(pdfFileName: "Dishlex Dishwasher Manual.pdf", createdDate: "Uploaded on: 20 June, 2021, 05:51am"),
                    tableData(pdfFileName: "Rheem Hotwater System Manual.pdf", createdDate: "Uploaded on: 20 June, 2021, 05:51am"),
                    tableData(pdfFileName: "Steel-line Garage Door Manual.pdf", createdDate: "Uploaded on: 20 June, 2021, 05:51am")]
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(hideWelcomeCard), name: NSNotification.Name("hideWelcomeCard"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // profileView.notificationCountLb.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        setUpProfileView()
        addTopBordertoTabBar(vc: self)
      
//        setStatusBarColor(color: AppColors.AppGray)
    }
//    override func viewDidDisappear(_ animated: Bool) {
//        NotificationCenter.default.removeObserver(self)
//    }
    @objc func hideWelcomeCard(notification : Notification)
    {
        baseView.isHidden = true
        isWelcomeCardHidden1 = true
        setUpProfileView()
    }
    func setUpProfileView(){
//        self.view.backgroundColor = AppColors.AppGray
        profileBaseView.navigationView.backgroundColor = AppColors.AppGray
        profileBaseView.descriptionLBL.textColor = .black
        profileBaseView.profileView.image = UIImage(named: "BurbankLogo_Black")
        profileBaseView.titleLBL.textColor = .black
        
        profileBaseView.baseImageView.image = UIImage(named: "")
        
        setAppearanceFor(view: profileBaseView.titleLBL, backgroundColor: .clear, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_BODY (size: FONT_22))
        setAppearanceFor(view: profileBaseView.descriptionLBL, backgroundColor: .clear, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_BODY (size: FONT_10))
        if navigationController?.tabBarItem.title != "MANUALS"{
            baseView.isHidden = true
        }
        
        if baseView.isHidden{
            profileBaseView.contentView.backgroundColor = AppColors.appGray
            profileBaseView.baseImageView.backgroundColor = AppColors.AppGray
            profileBaseView.profileBaseView.backgroundColor = AppColors.AppGray.withAlphaComponent(0.6)

            profileBaseView.titleLBL.text = "My" + (self.navigationController?.tabBarItem.title?.capitalized ?? "")
            setAttributetitleFor(view: profileBaseView.descriptionLBL, title: "All the guides to the great appliances and services in your new home \(CurrentUser.jobNumber ?? "").", rangeStrings: ["All the guides to the great appliances and services in your new home ", "\(CurrentUser.jobNumber ?? "")."], colors: [APPCOLORS_3.Black_BG, APPCOLORS_3.Orange_BG], fonts: [FONT_LABEL_BODY (size: FONT_9), FONT_LABEL_SEMI_BOLD (size: FONT_9)], alignmentCenter: false)           
        }else{
            profileBaseView.contentView.backgroundColor = AppColors.white
            profileBaseView.baseImageView.backgroundColor = AppColors.white
            profileBaseView.profileBaseView.backgroundColor = AppColors.white 

            profileBaseView.titleLBL.text = "MyHomeCare"
            setAttributetitleFor(view: profileBaseView.descriptionLBL, title: "Congratulations on the completion of your new Burbank home \(CurrentUser.jobNumber ?? "").", rangeStrings: ["Congratulations on the completion of your new Burbank home ", "\(CurrentUser.jobNumber ?? "")."], colors: [APPCOLORS_3.Black_BG, APPCOLORS_3.Orange_BG], fonts: [FONT_LABEL_BODY (size: FONT_9), FONT_LABEL_SEMI_BOLD (size: FONT_9)], alignmentCenter: false)

        }
//        profileBaseView.menuAndBackBtn.setImage(UIImage(systemName:"arrow.left", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
//        getTabBardetail()
       
        
    }

    @IBAction func didTappeOnCOntinueBTN(_ sender: UIButton) {
        baseView.isHidden = true
        setUpProfileView()
    }
}
extension Tabbarscreens : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCareFilesTVC", for: indexPath) as! HomeCareFilesTVC
        cell.dateLBL.text = tableArr[indexPath.row].createdDate
        cell.titleLBL.text = tableArr[indexPath.row].pdfFileName
        
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
        
//        baseView.isHidden = true
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

struct tableData{
    var pdfFileName : String
    var createdDate : String
    
    init(pdfFileName: String, createdDate: String) {
        self.pdfFileName = pdfFileName
        self.createdDate = createdDate
    }
}
