//
//  ContactUsVC.swift
//  BurbankApp
//
//  Created by Naveen Kourampalli on 17/12/21.
//  Copyright © 2021 DMSS. All rights reserved.
//

import UIKit
import MessageUI

class ContactUsVC: UIViewController,MFMailComposeViewControllerDelegate {
    
    //MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    private var tableDataSource : [MyNotesStruct]?
    private var contactArr : [MyNotesStruct]?
    @IBOutlet weak var searchBarHeight: NSLayoutConstraint!
    
    @IBOutlet weak var searchBar: UISearchBar!
    {
        didSet{
            if #available(iOS 13.0, *) {
                searchBar[keyPath: \.searchTextField].font = UIFont.systemFont(ofSize: 14.0)
                UILabel.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = UIFont.systemFont(ofSize: 14)
            } else {
                // Fallback on earlier versions
            }
        }
    }
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .clear
        searchBar.delegate = self
        searchBarHeight.constant = 0
      
        //  navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBarButtons()
        searchBar.text?.removeAll()
        searchBar.resignFirstResponder()
        getNotes()
    }
    
    //MARK: - IBActions
    @IBAction func didTappedOnSearch(_ sender: UIButton) {
        searchBarHeight.constant = searchBarHeight.constant == 0 ? 44 : 0
        UIView.animate(withDuration: 0.250) {
            self.view.layoutIfNeeded()
        } completion: { cmp in
            
        }
    }
    @IBAction func didTappedOnNewMsg(_ sender: UIButton) {
        
        let vc = ContactUsNewMsgPopupVC.instace(sb: .supportAndHelp)
        
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .overCurrentContext
        vc.isFromNewMessage = true
        vc.completion = { [weak self](success) in
            
            self?.getNotes()
        }
        self.present(vc, animated: false)
        
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
    
    func createNewNote()
    {
        
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

                var mainNotes = tableData.filter({$0.replyTo == nil})
                for item in mainNotes
                {
                    var note = item
                    let noteId = item.noteId
                    let replies = tableData.filter({ noteId == $0.replyTo?.noteId})
                    if replies.count > 0//replies found
                    {
                        note.replies = replies
                    }
                    tempDataSource.append(note)
                }
               // tempDataSource = tableData
            }
        }
        
        tempDataSource = tempDataSource.sorted(by: {$0.date.compare($1.date) == .orderedDescending})
        self.contactArr = tempDataSource
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
//MARK: - Tableview Delegate && Datasource
extension ContactUsVC : UITableViewDelegate , UITableViewDataSource,UISearchBarDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableDataSource?.count == 0 {
            tableView.setEmptyMessage("No Notes Found")
        }else{
            tableView.restore()
        }
        return tableDataSource?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactUsTVC") as! ContactUsTVC
        cell.authorNameLb.text = tableDataSource?[indexPath.row].authorname ?? "No Author"
        cell.subjectLb.text = tableDataSource?[indexPath.row].subject
        cell.bodyLb.text = tableDataSource?[indexPath.row].body
        if let noteId = tableDataSource?[indexPath.row].noteId
        {
            let jobNum = CurrentUser.jobNumber ?? ""
            if let isRead = UserDefaults.standard.value(forKey: "\(jobNum)_\(noteId)_isRead") as? Bool , isRead == true
            {
                cell.circlelb.isHidden = true
            }
            else {
                cell.circlelb.isHidden = false
            }
        }
        if let notedate = tableDataSource?[indexPath.row].notedate?.components(separatedBy: ".").first
        {
            cell.noteDateLb.isHidden = false
            
            let notedated = dateFormatter(dateStr: notedate, currentFormate: "yyyy-MM-dd'T'HH:mm:ss", requiredFormate: "dd/MM/yyyy")
            cell.noteDateLb.text = notedated
        }
        else {
            cell.noteDateLb.isHidden = true
        }
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0
        {
            tableDataSource = contactArr
            self.searchBar.endEditing(true)
            
        }
        else {
            tableDataSource = contactArr?.filter({ note in
                let displaydate = note.notedate?.components(separatedBy: "T").first
                let notedated = dateFormatter(dateStr: displaydate ?? "", currentFormate: "yyyy-MM-dd", requiredFormate: "dd/MM/yyyy")
                return (note.authorname?.lowercased().contains(searchText.lowercased()) ?? false) || (note.subject?.lowercased().contains(searchText.lowercased()) ?? false) ||
                (notedated?.contains(searchText.lowercased()) ?? false)
            })
        }
        tableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.searchBar.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ContactUsDetailsVC.instace(sb: .supportAndHelp)
        vc.contactDetails = tableDataSource?[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}



func createEmailUrl(to: String, subject: String, body: String) -> URL? {
    let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    
    let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
    let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
    let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
    let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
    let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
    
    if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
        return gmailUrl
    } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
        return outlookUrl
    } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
        return yahooMail
    } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
        return sparkUrl
    }
    
    return defaultUrl
}

func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    controller.dismiss(animated: true)
}

extension ContactUsVC
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
