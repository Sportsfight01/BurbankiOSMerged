//
//  SubmittedIsuuesVC.swift
//  BurbankApp
//
//  Created by Naveen Kourampalli on 26/06/23.
//  Copyright © 2023 Sreekanth tadi. All rights reserved.
//

import UIKit

class SubmittedIsuuesVC: HomeCareBaseProfileVC{
    
    

    @IBOutlet weak var baseView: UIView!
    
    @IBOutlet weak var tableVIew: UITableView!
    
    @IBOutlet weak var reportOtherIssuesVC: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpProfileView()
        self.tableVIew.delegate = self
        self.tableVIew.dataSource = self
        self.tableVIew.register(UINib(nibName: "HomeCareIssueStatusTVC", bundle: nil), forCellReuseIdentifier: "HomeCareIssueStatusTVC")
        
        // Do any additional setup after loading the view.
    }
    
     func setUpProfileView(){
        profileBaseView.navigationView.backgroundColor = AppColors.AppGray
        profileBaseView.descriptionLBL.textColor = .black
        profileBaseView.profileView.image = UIImage(named: "BurbankLogo_Black")
        profileBaseView.baseImageView.image = UIImage(named: "")
        profileBaseView.baseImageView.backgroundColor = AppColors.AppGray
         profileBaseView.backgroundColor = AppColors.AppGray
         profileBaseView.dotView.isHidden = CurrentUser.notesUnReadCount > 0 ? false : true

        profileBaseView.titleLBL.textColor = .black
        profileBaseView.titleLBL.text = "Report Issue"
        self.navigationController?.setNavigationBarHidden(true, animated: true)
       
//        tabBar.tintColor = .gray
        setAppearanceFor(view: profileBaseView.titleLBL, backgroundColor: .clear, textColor: APPCOLORS_3.Black_BG, textFont: FONT_BUTTON_LIGHT (size: FONT_20))
        setAppearanceFor(view: profileBaseView.descriptionLBL, backgroundColor: .clear, textColor: APPCOLORS_3.Black_BG, textFont: FONT_BUTTON_BODY (size: FONT_10))
        setStatusBarColor(color: AppColors.AppGray)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    @IBAction func didTappedOnReportOtherIsuues(_ sender: UIButton) {
        let vc = LoggedissuesVC.instace(sb: .reports)
        self.navigationController?.pushViewController(vc, animated: true)
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
extension SubmittedIsuuesVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCareIssueStatusTVC", for: indexPath) as! HomeCareIssueStatusTVC
        cell.statusLBL.textColor = APPCOLORS_3.Orange_BG
        cell.statusLBL.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SubmittedIssueListVC.instace(sb: .reports)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
