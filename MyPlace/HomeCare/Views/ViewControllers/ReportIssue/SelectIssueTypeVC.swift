//
//  SelectIssueTypeVC.swift
//  BurbankApp
//
//  Created by Naresh Banavath on 31/05/23.
//  Copyright © 2023 Sreekanth tadi. All rights reserved.
//

import UIKit

class SelectIssueTypeVC: HomeCareBaseProfileVC {

    @IBOutlet weak var closeBTN: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }

    
    //MARK: - ButtonActions
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    func setupUI()
    {
        //profileSetup
        profileBaseView.baseImageView.image = nil
        profileBaseView.contentView.backgroundColor = AppColors.AppGray
        profileBaseView.navigationView.backgroundColor = AppColors.AppGray
        profileBaseView.titleLBL.text = "Report Issue"
        profileBaseView.profileView.image = UIImage(named: "BurbankLogo_Black")

        
        setAppearanceFor(view: profileBaseView.titleLBL, backgroundColor: .clear, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_BODY(size: FONT_22))
        setAttributetitleFor(view: profileBaseView.descriptionLBL, title: "Your guide to issue reporting with you new Burbank home \(CurrentUser.jobNumber ?? "").", rangeStrings: ["Your guide to issue reporting with you new Burbank home ", "\(CurrentUser.jobNumber ?? "")."], colors: [APPCOLORS_3.Black_BG, APPCOLORS_3.Orange_BG], fonts: [FONT_LABEL_BODY (size: FONT_9), FONT_LABEL_SEMI_BOLD (size: FONT_9)], alignmentCenter: false)
        //addScrollView()
    }
    
    @IBAction func selectIssueTypeBtnsAction(_ sender: UIButton) {
        
        switch sender.tag
        {
        case 1://product warranty
            debugPrint("Product warranty btn tapped")
            let vc = LogIssueVC.instace(sb: .reports)
            self.navigationController?.pushViewController(vc, animated: true)
          //  fallthrough
            
        case 2://structural issue
            debugPrint("structural issue btn tapped")
            let vc = LogIssueVC.instace(sb: .reports)
            self.navigationController?.pushViewController(vc, animated: true)
           // fallthrough
            
        case 3://Other issues
            debugPrint("other issues btn tapped")
            let vc = LogIssueVC.instace(sb: .reports)
            self.navigationController?.pushViewController(vc, animated: true)
        case 5://close BTN
            self.navigationController?.popViewController(animated: true)
        default:
            debugPrint("default")
        }
        
    }
    

}
