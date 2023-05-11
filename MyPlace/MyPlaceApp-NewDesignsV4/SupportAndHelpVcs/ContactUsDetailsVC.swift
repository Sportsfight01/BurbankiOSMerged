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
            let jobNum = CurrentUservars.jobNumber
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
        
        let vc = UIStoryboard(name: StoryboardNames.newDesing5, bundle: nil).instantiateViewController(withIdentifier: "ContactUsNewMsgPopupVC") as! ContactUsNewMsgPopupVC
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
    //MARK: - Service Call
    func getNotes()
    {
        let jobAndAuth = APIManager.shared.getJobNumberAndAuthorization()
        guard let jobNumber = jobAndAuth.jobNumber else {debugPrint("Job Number is Null");return}
        let auth = jobAndAuth.auth
        
        NetworkRequest.makeRequestArray(type: MyNotesStruct.self, urlRequest: Router.getNotes(auth: auth, contractNo: jobNumber)) { [weak self](result) in
            switch result
            {
            case .success(let data):
                print(data)
                //self?.setupProgressDetails(progressData: data)
                let currentData = data.filter({$0.noteId == self?.contactDetails?.noteId})
                self?.tableDataSource = currentData.first?.replies
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                
            case.failure(let err):
                print(err.localizedDescription)
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
