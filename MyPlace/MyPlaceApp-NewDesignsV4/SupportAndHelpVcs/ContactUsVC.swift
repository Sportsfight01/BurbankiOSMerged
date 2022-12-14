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
    @IBOutlet weak var tableView: UITableView!
    var tableDataSource : [MyNotesStruct]?
    var contactArr : [MyNotesStruct]?
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
    
    @IBAction func didTappedOnSearch(_ sender: UIButton) {
        searchBarHeight.constant = searchBarHeight.constant == 0 ? 44 : 0
        UIView.animate(withDuration: 0.250) {
            self.view.layoutIfNeeded()
        } completion: { cmp in
            
        }
    }
    @IBAction func didTappedOnNewMsg(_ sender: UIButton) {
        
        let vc = UIStoryboard(name: StoryboardNames.newDesing5, bundle: nil).instantiateViewController(withIdentifier: "ContactUsNewMsgPopupVC") as! ContactUsNewMsgPopupVC
        
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .overCurrentContext
        vc.isFromNewMessage = true
        vc.completion = { [weak self](success) in
            
            self?.getNotes()
        }
        self.present(vc, animated: true)
        
    }
    
    
    
    //MARK: - Service Call
    func getNotes()
    {
        var currenUserJobDetails : MyPlaceDetails?
        currenUserJobDetails = (UIApplication.shared.delegate as! AppDelegate).currentUser?.userDetailsArray![0].myPlaceDetailsArray[0]
        if selectedJobNumberRegionString == ""
        {
            let jobRegion = currenUserJobDetails?.region
            selectedJobNumberRegionString = jobRegion!
            print("jobregion :- \(jobRegion)")
        }
        let authorizationString = "\(currenUserJobDetails?.userName ?? ""):\(currenUserJobDetails?.password ?? "")"
        let encodeString = authorizationString.base64String
        let valueStr = "Basic \(encodeString)"
        let contractNo = currenUserJobDetails?.jobNumber ?? ""
        
        
        NetworkRequest.makeRequestArray(type: MyNotesStruct.self, urlRequest: Router.getNotes(auth: valueStr, contractNo: contractNo)) { [weak self](result) in
            switch result
            {
            case .success(let data):
                //print(data)
                //self?.setupProgressDetails(progressData: data)
                self?.tableDataSource = data.reversed()
                DispatchQueue.main.async {
                    self?.contactArr = self?.tableDataSource
                    self?.tableView.reloadData()
                }
                
            case.failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
}
//MARK: - Tableview Delegate && Datasource
extension ContactUsVC : UITableViewDelegate , UITableViewDataSource,UISearchBarDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableDataSource?.count == 0 {
            tableView.setEmptyMessage("No Records Found")
        }else{
            tableView.restore()
        }
        return tableDataSource?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactUsTVC") as! ContactUsTVC
        cell.authorNameLb.text = tableDataSource?[indexPath.row].authorname
        cell.subjectLb.text = tableDataSource?[indexPath.row].subject
        cell.bodyLb.text = tableDataSource?[indexPath.row].body
        if let noteId = tableDataSource?[indexPath.row].noteid
        {
            let jobNum = CurrentUservars.jobNumber ?? ""
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
//            tableDataSource = contactArr?.filter({$0.authorname?.lowercased().contains(searchText.lowercased()) ?? false})
            tableDataSource = contactArr?.filter({ note in
                let displaydate = note.notedate?.components(separatedBy: "T").first
                let notedated = dateFormatter(dateStr: displaydate ?? "", currentFormate: "yyyy-MM-dd", requiredFormate: "dd/MM/yyyy")
                return (note.authorname?.lowercased().contains(searchText.lowercased()) ?? false) || (note.subject?.lowercased().contains(searchText.lowercased()) ?? false) ||
                (notedated?.contains(searchText.lowercased()) ?? false)
            })
            //            tableDataSource = contactArr?.filter({ note in
            //                 (note.authorname?.lowercased().contains(searchText.lowercased()))! || ((note.subject?.lowercased().contains(searchText.lowercased())) != nil)
            //
            //            })
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
        let vc = UIStoryboard(name: "NewDesignsV5", bundle: nil).instantiateViewController(withIdentifier: "ContactUsDetailsVC") as! ContactUsDetailsVC
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

