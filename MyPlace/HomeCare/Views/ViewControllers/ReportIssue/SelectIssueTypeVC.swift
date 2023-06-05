//
//  SelectIssueTypeVC.swift
//  BurbankApp
//
//  Created by Naresh Banavath on 31/05/23.
//  Copyright © 2023 Sreekanth tadi. All rights reserved.
//

import UIKit

class SelectIssueTypeVC: HomeCareBaseProfileVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    //MARK: - ButtonActions
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    @IBAction func selectIssueTypeBtnsAction(_ sender: UIButton) {
        
        switch sender.tag
        {
        case 1://product warranty
            debugPrint("Product warranty btn tapped")
          //  fallthrough
            
        case 2://structural issue
            debugPrint("structural issue btn tapped")
           // fallthrough
            
        case 3://Other issues
            debugPrint("other issues btn tapped")
            let vc = LogIssueVC.instace(sb: .reports)
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            debugPrint("default")
        }
        
    }
    

}
