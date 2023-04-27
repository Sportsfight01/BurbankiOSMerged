//
//  NotificationsVC.swift
//  BurbankApp
//
//  Created by Naresh Banavath on 27/04/23.
//  Copyright © 2023 Sreekanth tadi. All rights reserved.
//

import UIKit
import RealmSwift

class NotificationsVC: UIViewController {

    //MARK: - Properties
    var tableDataSource : [RealmStageComplete] = []
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var jobNumber : UILabel!
    
    let realm = try! Realm()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        appDelegate.showActivity()
        APIManager.shared.getUserSelectedNotificationTypes {[weak self] notificationTypes in
            if notificationTypes.photoAdd == false && notificationTypes.stageCompleted == false && notificationTypes.stageChange == false
            {
                //Notifications Settings not selected
                let errMsg = "Notifications settings are not enabled, Please enable preferred notifications from settings."
                self?.tableView.setEmptyMessage(errMsg)
            }else {
                let objects = self?.realm.objects(RealmStageComplete.self)
                let sorted = objects?.sorted(by: { $0.date > $1.date } ).filter({$0.isRead == false})
                DispatchQueue.main.async {
                    
                    self?.tableDataSource = sorted ?? []
                    self?.tableView.reloadData()
                    appDelegate.hideActivity()
                }
            }
        }
        
            
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBarButtons()
        jobNumber.text = CurrentUservars.jobNumber
    }
    
}
//MARK: - TableView Delegate & DataSource
extension NotificationsVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NotificationsTBCell
        cell.title.numberOfLines = 0
        let item = tableDataSource[indexPath.row]
        cell.imgView.tintColor = APPCOLORS_3.Orange_BG
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        let dateStr = dateFormatter.string(from: item.date)
        
        if item.isPhoto == true // stage complete
        {
            cell.imgView.image = UIImage(systemName: "photo.circle.fill",withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
            cell.title.text = "Check out the new photos added on \(dateStr)"
        }else {
            cell.title.text = "\(item.taskName!) Completed on \(dateStr)"
            cell.imgView.image = UIImage(systemName: "bell.circle.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
        }
        
        let formatter = RelativeDateTimeFormatter()
        //formatter.unitsStyle = .full
        formatter.dateTimeStyle = .numeric

        // get relative date to the current date
        let relativeDate = formatter.localizedString(for: item.date, relativeTo: Date())
        cell.subTitleLb.text = relativeDate
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = tableDataSource[indexPath.row]
        let realm = try! Realm()
        try! realm.write {
            item.isRead = true
        }
        
        let objects = self.realm.objects(RealmStageComplete.self)
        let unreadObjects = objects.filter({$0.isRead == false})
        appDelegate.notificationCount = unreadObjects.count
        if item.isPhoto // Photo Clicked(go to photos screen)
        {
            if let vc = self.navigationController?.viewControllers.filter({$0.isKind(of: PhotosVC.self)}).first
            {
                self.navigationController?.popToViewController(vc, animated: true)
            }else {
                self.navigationController?.topViewController?.tabBarController?.selectedIndex = 2//PhotosVC
            }
        }else {//Progress screen
            let tabbar = TabBarVC.instace(sb: .newDesignV4)
            kWindow.rootViewController = tabbar
            kWindow.makeKeyAndVisible()
        }
        
        
        
    }
    
    
}


class NotificationsTBCell : UITableViewCell
{
   
    @IBOutlet weak var title : UILabel!
    @IBOutlet weak var subTitleLb : UILabel!
    @IBOutlet weak var imgView : UIImageView!
    
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }

    
}
