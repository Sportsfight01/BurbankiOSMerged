//
//  MyHistoryVC.swift
//  BurbankApp
//
//  Created by Naresh Banavath on 24/03/22.
//  Copyright © 2022 DMSS. All rights reserved.
//

import UIKit

class MyHistoryVC: UIViewController {

    //MARK: - Properties
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var headerLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var notificationCountLBL: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var tableDataSource : [MyNotesStruct]?

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getAPIData()
    
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupNavigationBarButtons()
        headerLeadingConstraint.constant = self.getLeadingSpaceForNavigationTitleImage()
        setupProfile()
       
        
    }
     //MARK: - Helper Methods
    func setupProfile()
    {
        profileImgView.contentMode = .scaleToFill
        profileImgView.clipsToBounds = true
        profileImgView.layer.cornerRadius = profileImgView.bounds.width/2
        if let imgURlStr = CurrentUser.profilePicUrl
        {

            profileImgView.image = imgURlStr
        }
        if appDelegate.notificationCount == 0{
            notificationCountLBL.isHidden = true
        }else{
            notificationCountLBL.text = "\(appDelegate.notificationCount)"
        }
        //        profileImgView.addBadge(number: appDelegate.notificationCount)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileClick(recognizer:)))
        profileImgView.addGestureRecognizer(tap)
        
    }
    func setupUI()
    {
        self.tableDataSource = self.tableDataSource?.sorted(by: {$0.date.compare($1.date) == .orderedDescending})
        if self.tableDataSource?.count == 0
        {
            self.tableView.setEmptyMessage("No History Found")
        }else {
            self.tableView.reloadData()
        }
    }
    
    //MARK: - Service Calls
    func getAPIData()
    {
        appDelegate.showActivity()
        APIManager.shared.getNotes {[weak self] result in
            DispatchQueue.main.async {
                appDelegate.hideActivity()
            }
            guard let self else { return }
            switch result{
            case .success(let notes):
                self.tableDataSource = notes.filter({$0.replyTo == nil})
                DispatchQueue.main.async {
                    self.setupUI()
                }
            case .failure(let err):
                debugPrint(err.localizedDescription)
                DispatchQueue.main.async {
                    self.showAlert(message: err.description)
                    return}
                }
            }
        
    }


    @objc func handleProfileClick (recognizer: UIGestureRecognizer) {
        let vc = NotificationsVC.instace(sb: .newDesignV4)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

}

extension MyHistoryVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableDataSource?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyHistoryTBCell", for: indexPath) as! MyHistoryTBCell
        let history = tableDataSource?[indexPath.row]
        cell.subjectLb.text = history?.subject ?? "--"
        let noteDate = dateFormatter(dateStr: history?.notedate?.components(separatedBy: ".").first ?? "", currentFormate: "yyyy-MM-dd'T'HH:mm:ss", requiredFormate: "dd MMM yyyy, hh:mm a")
        cell.noteDateLb.text = noteDate ?? "--"
        cell.authorNameLb.text =  "By " + (history?.authorname ?? "--")
        // cell.authorNameLb.text =  "By " + (history?.authorname ?? "") + " on " + noteDate
        cell.bodyLb.text = history?.body ?? "--"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
struct MyNotesStruct : Codable
{
    var authorname : String?
    var body : String?
    var notedate : String?
    var noteId : Int?
    var replies : [MyNotesStruct]?
    var replyTo : ReplyTo?
    var subject : String?
    var byclient : Bool?
    
    enum CodingKeys : String, CodingKey
    {
        case authorname = "unknownAuthor"
        case body, noteId, replies, replyTo, subject, byclient
        case notedate = "activityDate"
        
    }
    var date : Date
    {
        return notedate?.components(separatedBy: ".").first?.getDate() ?? Date()
    }
    
    struct ReplyTo : Codable
    {
        let noteId : Int?
    }
        
}
