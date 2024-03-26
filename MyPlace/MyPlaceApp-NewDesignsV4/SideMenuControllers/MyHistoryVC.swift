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
        tableView.addRefressControl {[weak self] in
            self?.getAPIData(showSpinner: false)
        }
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
    func getAPIData(showSpinner : Bool = true )
    {
        guard isNetworkReachable else { showAlert(message: checkInternetPullRefresh) {[weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.refreshControl?.endRefreshing()
            }
        }; return}
        if showSpinner {
            appDelegate.showActivity()
        }
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
            DispatchQueue.main.async {
                appDelegate.hideActivity()
                self.tableView.refreshControl?.endRefreshing()
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
        // - not getting 'unknownAuthor' key for all the records. So replacing this value with userdetails fullName from getUserDetails api data
//        let authorname = appDelegate.currentUser?.userDetailsArray?.first?.fullName ?? "--"
//        cell.authorNameLb.text =  "By " + (authorname)
         cell.authorNameLb.text =  "By " + (history?.authorname ?? "--")
        cell.bodyLb.text = history?.body ?? "--"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
struct MyNotesStruct : Codable, Hashable
{
    static func == (lhs: MyNotesStruct, rhs: MyNotesStruct) -> Bool {
        lhs.noteId == rhs.noteId
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(noteId)
    }

    
    var authorname : String?
    var body : String?
    var createdInMyHome : Bool?
    var notedate : String?
    var noteId : Int?
    var replies : [MyNotesStruct]?
    var replyTo : ReplyTo?
    var subject : String?
//    var byclient : Bool?
    var isFromAdmin : Bool = false
    var conversations : Conversations?
    var author : Author?
    
    enum CodingKeys : String, CodingKey
    {
        case authorname = "unknownAuthor"
        case body, noteId, replies, replyTo, subject,conversations,createdInMyHome,author
        case notedate = "activityDate"
        
    }
    var date : Date
    {
        return notedate?.components(separatedBy: ".").first?.getDate() ?? Date()
    }
    var displayDate : String? {
        if let notedate = notedate?.components(separatedBy: ".").first{
            return dateFormatter(dateStr: notedate,  currentFormate: "yyyy-MM-dd'T'HH:mm:ss", requiredFormate: "dd MMM yyyy, hh:mm a")
        }
        return nil
    }
    struct ReplyTo : Codable
    {
        let noteId : Int?
    }
    struct Conversations : Codable
    {
        var list : [MyNotesStruct]?
    }
    struct Author : Codable
    {
        var fullName : String?
    }
        
}
func dateFormatter(dateStr : String , currentFormate : String , requiredFormate : String) -> String?
{
    let dateFormatterGet = DateFormatter()
    dateFormatterGet.dateFormat = currentFormate
    
    let dateFormatterPrint = DateFormatter()
    dateFormatterPrint.dateFormat = requiredFormate
    
    if let date = dateFormatterGet.date(from: dateStr) {
        return dateFormatterPrint.string(from: date)
    } else {
        return nil
    }
}
