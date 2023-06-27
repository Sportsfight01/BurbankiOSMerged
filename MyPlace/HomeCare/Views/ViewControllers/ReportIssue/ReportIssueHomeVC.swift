//
//  ReportIssueHomeVC.swift
//  BurbankApp
//
//  Created by Naresh Banavath on 31/05/23.
//  Copyright © 2023 Sreekanth tadi. All rights reserved.
//

import UIKit

class ReportIssueHomeVC: HomeCareBaseProfileVC {

    @IBOutlet weak var containerView: UIView!
    private var scrollView : UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    func setupUI()
    {
        //profileSetup
        profileBaseView.baseImageView.image = nil
        profileBaseView.contentView.backgroundColor = AppColors.AppGray
        profileBaseView.navigationView.backgroundColor = AppColors.AppGray
        profileBaseView.titleLBL.text = "MyReports"
        //addScrollView()
    }
    
    //MARK: - Button Actions
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    @IBAction func reportMinorDefectsBtnAction(_ sender: UIButton) {
    }
    
    
    @IBAction func reportOtherIssuesBtnAction(_ sender: UIButton) {
        let vc = SelectIssueTypeVC.instace(sb: .reports)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
