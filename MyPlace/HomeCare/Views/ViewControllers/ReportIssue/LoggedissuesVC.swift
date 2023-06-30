//
//  LoggedissuesVC.swift
//  BurbankApp
//
//  Created by Naveen Kourampalli on 07/06/23.
//  Copyright © 2023 Sreekanth tadi. All rights reserved.
//

import UIKit

class LoggedissuesVC: UIViewController,UIPopoverPresentationControllerDelegate,didTappedOncomplete {

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
        self.setupNavigationBarButtons()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func didTappedOnCompleteAndLodgeBTN() {
        let vc = SubmittedIsuuesVC.instace(sb: .reports)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTappedOnAddNewIssue(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTappedOnCompleteAndLodge(_ sender: UIButton) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Report", bundle: nil)
        let popupVC = storyboard.instantiateViewController(withIdentifier: "CompleteAndLodgePopUPVC") as! CompleteAndLodgePopUPVC
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        popupVC.delegate = self
//        self.tabBarController?.present(popupVC, animated: true)
        present(popupVC, animated: true, completion: nil)
    }
    
}
extension LoggedissuesVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCareFilesTVC", for: indexPath) as! HomeCareFilesTVC
        cell.titleLBL.textColor = APPCOLORS_3.Orange_BG
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = LogIssueVC.instace(sb: .reports)
        vc.isEditIssueScreen = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
