//
//  SubmittedIssueDetailsVC.swift
//  BurbankApp
//
//  Created by Naveen Kourampalli on 26/06/23.
//  Copyright © 2023 Sreekanth tadi. All rights reserved.
//

import UIKit

class SubmittedIssueDetailsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func didTappedOnViewAllIssues(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
