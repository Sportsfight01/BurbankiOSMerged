//
//  SubmittedIssueListVC.swift
//  BurbankApp
//
//  Created by Naveen Kourampalli on 26/06/23.
//  Copyright © 2023 Sreekanth tadi. All rights reserved.
//

import UIKit

class SubmittedIssueListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(UINib(nibName: "HomeCareIssueStatusTVC", bundle: nil), forCellReuseIdentifier: "HomeCareIssueStatusTVC")
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBarButtons()
    }
//    override func viewDidDisappear(_ animated: Bool)
//    {
//        super.viewDidDisappear(animated)
//        navigationController?.navigationBar.isHidden = true
//    }
//    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension SubmittedIssueListVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCareIssueStatusTVC", for: indexPath) as! HomeCareIssueStatusTVC
        cell.statusLBL.textColor = APPCOLORS_3.Orange_BG
        cell.issueTypeimage.image = UIImage(named: "Ico-SearchCircle")
        cell.statusdetailsLBL.text = ""
        cell.statusLBLRight.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SubmittedIssueDetailsVC.instace(sb: .reports)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
