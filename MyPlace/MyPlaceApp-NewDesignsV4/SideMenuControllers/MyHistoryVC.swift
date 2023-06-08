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
    
        getHistoryDetails()
    
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupNavigationBarButtons()
        headerLeadingConstraint.constant = self.getLeadingSpaceForNavigationTitleImage()
        setupProfile()
        
    }
    
    //MARK: - Service Calls
    func getHistoryDetails()
    {
        guard let currentJobDetails = APIManager.shared.currentJobDetails else {debugPrint("currentJobDetailsNotAvailable");return}
        let url = "\(clickHomeV3BaseURL)Accounts/Login"
        let postDict = ["contractNumber":currentJobDetails.jobNumber ?? "","userName":currentJobDetails.userName ,"password": currentJobDetails.password]

        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: postDict)
        appDelegate.showActivity()
        //LoginService
        URLSession.shared.dataTask(with: urlRequest) {[weak self] data, response, error in
            DispatchQueue.main.async {
                appDelegate.hideActivity()
            }
            let httpResp = response as? HTTPURLResponse
            guard let httpResp, (200...299).contains(httpResp.statusCode) else {
                self?.showAlert(message: "error occured statusCode : \(httpResp?.statusCode ?? 400)")
                ;return}
            debugPrint("login Service succesfully got the results")
            //Get Notes service

            self?.getNotesList()
              
        }.resume()

    }
    func getNotesList()
    {
        let url = "\(clickHomeV3BaseURL)MasterContracts/Get"
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.httpBody = ContactUsVC.getNotesPostData()
        DispatchQueue.main.async {
            appDelegate.showActivity()
        }
        URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            DispatchQueue.main.async {
                appDelegate.hideActivity()
            }
            //Validation
            debugPrint(response.debugDescription)
            let httpResp = response as? HTTPURLResponse
            guard let httpResp, (200...299).contains(httpResp.statusCode) else {
                self?.showAlert(message: "error occured statusCode : \(httpResp?.statusCode ?? 400)")
                return}
            guard let data else {
                DispatchQueue.main.async {
                    self?.showAlert(message:("\(error?.localizedDescription ?? somethingWentWrong)"))
                };return}
            
            //:End Of Validation
            
            guard let json = try? JSONSerialization.jsonObject(with: data) as? NSDictionary else {return}
            DispatchQueue.main.async {
                self?.setupSerivceData(dictionary: json)
            }
         
         
        }.resume()

        
    }
    //MARK: - HelperMethods
    func setupSerivceData(dictionary : NSDictionary)
    {
        //        let keyPaths = ["constructionContract","preconstructionContract","leadContract"]
        var tempDataSource : [MyNotesStruct] = []
        if let notesList = dictionary.value(forKeyPath: "notes.list") as? [[String : Any]], let jsonData = try? JSONSerialization.data(withJSONObject: notesList)
        {
            if let tableData = try? JSONDecoder().decode([MyNotesStruct].self, from: jsonData)
            {
                //Note without "replyTo" key goes to MainNotes
                //Note with "replyTo" key means it is reply to a note in the list

                tempDataSource = tableData.filter({$0.replyTo == nil})
               
               // tempDataSource = tableData
            }
        }
        
        self.tableDataSource = tempDataSource.sorted(by: {$0.date.compare($1.date) == .orderedDescending})
            if self.tableDataSource?.count == 0
            {
                self.tableView.setEmptyMessage("No Notes Found")
            }else {
                self.tableView.reloadData()
            }
        
    }
    
    
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
    @objc func handleProfileClick (recognizer: UIGestureRecognizer) {
        //        let vc = UIStoryboard(name: StoryboardNames.newDesing, bundle: nil).instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
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
        cell.subjectLb.text = history?.subject
        let noteDate = dateFormatter(dateStr: history?.notedate?.components(separatedBy: ".").first ?? "", currentFormate: "yyyy-MM-dd'T'HH:mm:ss", requiredFormate: "dd/MM/yyyy hh:mm a")
        cell.noteDateLb.text = noteDate ?? "--"
        cell.authorNameLb.text =  "By " + (history?.authorname ?? "--")
        // cell.authorNameLb.text =  "By " + (history?.authorname ?? "") + " on " + noteDate
        cell.bodyLb.text = history?.body
        return cell
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
