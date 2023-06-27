//
//  CompleteAndLodgePopUPVC.swift
//  BurbankApp
//
//  Created by Naveen Kourampalli on 26/06/23.
//  Copyright © 2023 Sreekanth tadi. All rights reserved.
//

import UIKit

protocol didTappedOncomplete {
    func didTappedOnCompleteAndLodgeBTN()
}

class CompleteAndLodgePopUPVC: UIViewController {
    var delegate : didTappedOncomplete? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.9)
   // Do any additional setup after loading the view.
    }
    @IBAction func didTappedOnAddMoreIssues(_ sender: Any) {
        self.dismiss(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        setStatusBarColor(color: AppColors.AppGray)
    }
    
    @IBAction func didTappedOnCompleteAndLodge(_ sender: UIButton) {
        
        self.delegate?.didTappedOnCompleteAndLodgeBTN()
        self.dismiss(animated: true)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
