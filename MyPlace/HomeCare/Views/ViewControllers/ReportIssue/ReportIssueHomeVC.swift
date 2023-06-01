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
        profileBaseView.contentView.backgroundColor = AppColors.appGray
        profileBaseView.navigationView.backgroundColor = AppColors.appGray
        //addScrollView()
    }
    
    //MARK: - Button Actions
    
    
    @IBAction func reportMinorDefectsBtnAction(_ sender: UIButton) {
    }
    
    
    @IBAction func reportOtherIssuesBtnAction(_ sender: UIButton) {
        let vc = SelectIssueTypeVC.instace(sb: .reports)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
