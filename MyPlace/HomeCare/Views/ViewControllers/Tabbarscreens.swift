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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.tableview.register(UINib(nibName: "HomeCareFilesTVC", bundle: nil), forCellReuseIdentifier: "HomeCareFilesTVC")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // profileView.notificationCountLb.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        setUpProfileView()
        
        print("-------======",self.navigationController?.tabBarItem.title)
    }
    
    func setUpProfileView(){
//        self.view.backgroundColor = AppColors.AppGray
        profileBaseView.navigationView.backgroundColor = AppColors.appGray
        profileBaseView.contentView.backgroundColor = AppColors.appGray
        profileBaseView.descriptionLBL.textColor = .black
        profileBaseView.profileView.image = UIImage(named: "BurbankLogo_Black")
        profileBaseView.titleLBL.textColor = .black
        profileBaseView.titleLBL.text = "My" + (self.navigationController?.tabBarItem.title?.capitalized ?? "")
        profileBaseView.baseImageView.image = UIImage(named: "welcome")
//        profileBaseView.menuAndBackBtn.setImage(UIImage(systemName:"arrow.left", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
//        getTabBardetail()
       
        
    }

}
extension Tabbarscreens : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCareFilesTVC", for: indexPath) as! HomeCareFilesTVC
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}
