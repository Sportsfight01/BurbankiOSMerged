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
    
    @IBOutlet weak var newMsgBtnWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var newMessageBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    private var tableDataSource : [MyNotesStruct]?
    private var contactArr : [MyNotesStruct]?
    @IBOutlet weak var searchBarHeight: NSLayoutConstraint!
    private var newMsgBtnPropertyAnimator : UIViewPropertyAnimator!
    
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
        //setupAnimation()
      
        //let gesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction))
        //newMessageBtn.addGestureRecognizer(gesture)
      
        //  navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBarButtons(shouldShowNotification: false)
        searchBar.text?.removeAll()
        searchBar.resignFirstResponder()
        getAPIData()
        
    }
    
    private func setupAnimation()
    {
        newMsgBtnPropertyAnimator = UIViewPropertyAnimator(duration: 1, curve: .easeInOut, animations: {
            self.newMessageBtn.frame.size.width = 250
        })
    }
    @objc func panGestureAction(_ sender : UIPanGestureRecognizer)
    {
        let translation = sender.translation(in: newMessageBtn.superview)
        debugPrint(translation.x)
        if translation.x > 0{
            newMsgBtnPropertyAnimator.fractionComplete = translation.x
            
        }
    }

    
    //MARK: - IBActions
    @IBAction func didTappedOnSearch(_ sender: UIButton) {
        guard tableDataSource?.count ?? 0 > 0 else { return }
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
            self?.getAPIData()
        }
        self.present(vc, animated: false)

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
                DispatchQueue.main.async {
                    self.setupSerivceData(notes: notes)
                }
            case .failure(let err):
                debugPrint(err.localizedDescription)
                DispatchQueue.main.async {
                    self.showAlert(message: err.description)
                    return}
                }
            }
        
    }
    //MARK: - HelperMethods
    func setupUI()
    {
        DispatchQueue.main.async {
            if self.tableDataSource?.count == 0
            {
                self.tableView.setEmptyMessage("No records found")
            }else {
                self.tableView.reloadData()
            }
        }
    }
    func setupSerivceData(notes : [MyNotesStruct])
    {
        //Note without "replyTo" key goes to MainNotes
        //Note with "replyTo" key means it is reply to a note in the list
        var tempDataSource : [MyNotesStruct] = []
        let mainNotes = notes.filter({$0.replyTo == nil})
        for item in mainNotes
        {
            var note = item
            let noteId = item.noteId
            let replies = notes.filter({ noteId == $0.replyTo?.noteId})
            if replies.count > 0//replies found
            {
                note.replies = replies
            }
            tempDataSource.append(note)
        }
        // tempDataSource = tableData
        
        tempDataSource = tempDataSource.sorted(by: {$0.date.compare($1.date) == .orderedDescending})
        self.contactArr = tempDataSource
        self.tableDataSource = tempDataSource
        DispatchQueue.main.async {
            self.setupUI()
        }
        
        
    }
    
    
}
//MARK: - Tableview Delegate && Datasource
extension ContactUsVC : UITableViewDelegate , UITableViewDataSource,UISearchBarDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableDataSource?.count == 0 {
            tableView.setEmptyMessage("No records found")
        }else{
            tableView.restore()
        }
        return tableDataSource?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactUsTVC") as! ContactUsTVC
        cell.authorNameLb.text = tableDataSource?[indexPath.row].authorname ?? "--"
        cell.subjectLb.text = tableDataSource?[indexPath.row].subject ?? "--"
        cell.bodyLb.text = tableDataSource?[indexPath.row].body ?? "--"
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
            let notedated = dateFormatter(dateStr: notedate, currentFormate: "yyyy-MM-dd'T'HH:mm:ss", requiredFormate: "dd MMM yyyy, hh:mm a")
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
    static func getNotesPostData() -> Data
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
