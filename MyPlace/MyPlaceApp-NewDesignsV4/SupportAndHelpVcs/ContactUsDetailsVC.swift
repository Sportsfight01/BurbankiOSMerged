//
//  ContactUsDetailsVC.swift
//  BurbankApp
//
//  Created by Naveen Kourampalli on 20/12/21.
//  Copyright © 2021 DMSS. All rights reserved.
//

import UIKit
import MessageUI

class ContactUsDetailsVC: UIViewController,MFMailComposeViewControllerDelegate {
    @IBOutlet weak var repliesHeader: UILabel!
    
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var descriptionLb: UILabel!
    @IBOutlet weak var contactUsHdrLBL: UILabel!
    var contactDetails : MyNotesStruct?

   // @IBOutlet weak var fromLBL: UILabel!
    @IBOutlet weak var subjectLBL: UILabel!
   // @IBOutlet weak var toLBL: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    var tableDataSource : [MyNotesStruct]?
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        showData()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor.clear
    }
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      self.setupNavigationBarButtons()
        readUnreadMessage()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //tableHeight.constant = tableView.contentSize.height
    }

    func readUnreadMessage()
    {
        guard let contactData = contactDetails else {return}
        if let noteId = contactData.noteId
        {
            let jobNum = CurrentUser.jobNumber
            let key = "\(jobNum ?? "")_\(noteId)_isRead"
            print("key :- \(key)")
            UserDefaults.standard.set(true, forKey: key )
        }
        
    }
    
    func showData(){
        
        subjectLBL.text =  "Subject : \(self.contactDetails?.subject ?? "")"
        //toLBL.text = "To : \(self.contactDetails?.authorname ?? "")"
       // fromLBL.text =  "From : " + (appDelegate.currentUser?.userDetailsArray?[0].fullName)!
        descriptionLb.text = self.contactDetails?.body ?? ""
        self.tableDataSource = contactDetails?.replies //All replies
        tableView.reloadData()
//        self.view.layoutSubviews()
//        self.view.layoutIfNeeded()
     
        
    }

    @IBAction func didTappedOnReplay(_ sender: UIButton) {
        let recipientEmail = "srikanth.vunyala@digitalminds.solutions"
        let subject = "Re : \(contactDetails?.subject ?? "") \(contactDetails?.noteId ?? 0)"
       // let body = ""
        
        let vc = ContactUsNewMsgPopupVC.instace(sb: .supportAndHelp)
        vc.screenData = (sub : subject,to : recipientEmail ,from : self.contactDetails?.authorname ?? "" )
        vc.noteId = contactDetails?.noteId
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .overCurrentContext
        vc.isFromNewMessage = false
        vc.completion = { [weak self](success) in
            self?.getNotes()
        }
        self.present(vc, animated: true)
        
    }
    @IBAction func didTappedOnInbox(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func didTappedOnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: - Service Calls
    func getNotes()
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
        urlRequest.httpBody = getNotesPostData()
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
                self?.showAlert(message:("\(error?.localizedDescription ?? somethingWentWrong)"));return }
            //:End Of Validation
            
            guard let json = try? JSONSerialization.jsonObject(with: data) as? NSDictionary else {return}
            
            self?.setupSerivceData(dictionary: json)
         
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
                
                let noteId = contactDetails?.noteId
                let replies = tableData.filter({ noteId == $0.replyTo?.noteId})
                tempDataSource = replies
            }
        }
        
        tempDataSource = tempDataSource.sorted(by: {$0.date.compare($1.date) == .orderedDescending})

        self.tableDataSource = tempDataSource
        DispatchQueue.main.async {
            if self.tableDataSource?.count == 0
            {
                self.tableView.setEmptyMessage("No Notes Found")
            }else {
                self.tableView.reloadData()
            }
        }
        
    }


}


//MARK: - Tableview Delegate & Datasource
extension ContactUsDetailsVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableDataSource?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {return UITableViewCell()}
        let cellData = tableDataSource?[indexPath.row]
        if let titleLb = cell.contentView.viewWithTag(100) as? UILabel
        {
            titleLb.text = cellData?.body
        }
        if let datelb = cell.contentView.viewWithTag(101) as? UILabel
        {
            let notedate = dateFormatter(dateStr: cellData?.notedate?.components(separatedBy: ".").first ?? "", currentFormate: "yyyy-MM-dd'T'HH:mm:ss", requiredFormate: "dd/MM/yyyy hh:mm a")
            datelb.text = notedate
        }
        
        return cell
    }
    
    
}
extension ContactUsDetailsVC
{
    func getNotesPostData() -> Data
    {
        guard let json = """
         {
             "Notes": {
               "List": {
                 "MetaData": {}
               }
             }
         }
         
         """.data(using: .utf8) else { return Data() }
        return json
    }
}
