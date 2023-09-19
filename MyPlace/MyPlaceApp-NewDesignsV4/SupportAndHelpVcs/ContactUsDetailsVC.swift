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
    
     //MARK: - Properties
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var authorLb: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var inboxButton: UIButton!
    
    @IBOutlet weak var descriptionLb: UILabel!
    @IBOutlet weak var contactUsHdrLBL: UILabel!
    @IBOutlet weak var subjectLBL: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var contactDetails : MyNotesStruct?
    var tableDataSource : [MyNotesStruct]?
    lazy var dataSource : UITableViewDiffableDataSource<Int, MyNotesStruct>! = makeDataSource()
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
       // tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor.clear
        tableView.allowsSelection = false
        showData()
        let pan1 = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction))
        let pan2 = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction))
        inboxButton.addGestureRecognizer(pan1)
        replyButton.addGestureRecognizer(pan2)

    }
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
        setupNavigationBarButtons(shouldShowNotification: false)
        readUnreadMessage()
    }
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        let contentheight = tableView.contentSize.height
//        self.tableViewHeight.constant = contentheight + 50
//    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let contentheight = tableView.contentSize.height
        self.tableViewHeight.constant = contentheight + 50
//        tableView.isScrollEnabled = false


    }
    
    @objc func panGestureAction(_ gesture : UIPanGestureRecognizer)
    {
        switch gesture.state
        {
        case .changed:
            let translation = gesture.translation(in: self.view)
            debugPrint(translation.x)
            if gesture.view?.tag == 100 { // Inbox
                guard translation.x > 0 && translation.x < SCREEN_WIDTH * 0.4 else {return}
                inboxButton.transform = CGAffineTransform(translationX: translation.x, y: 0)
               
            }else // reply btn
            {
                guard translation.x < 0 else {return}
                replyButton.transform = CGAffineTransform(translationX: translation.x, y: 0)
               
            }
        case .ended:
            gesture.view?.transform = .identity
            if gesture.view?.tag == 100 { // Inbox
                self.didTappedOnInbox(inboxButton)
            }else {
                self.didTappedOnReplay(replyButton)
            }
        default:
            debugPrint("default")
        }
        UIView.animate(withDuration: 0.250, delay: 0) {
            self.view.layoutIfNeeded()
        }
        
    }

     //MARK: - TableView Diffable Datasource
    func applySnapShot()
    {
        var animation : Bool = false
        if #available(iOS 15.0, *){
            animation = true
        }
        
        var snapShot = NSDiffableDataSourceSnapshot<Int, MyNotesStruct>()
        snapShot.appendSections([0])
        snapShot.appendItems(tableDataSource ?? [])
        dataSource.apply(snapShot, animatingDifferences: animation)
        
    }
    func makeDataSource() -> UITableViewDiffableDataSource<Int, MyNotesStruct>
    {
        let dataSource = UITableViewDiffableDataSource<Int, MyNotesStruct>(tableView: tableView) {[weak self] tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ContactUsReplyTBCell
            cell.setup(model: itemIdentifier)

            return cell
        }
        return dataSource
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
            CurrentUser.notesUnReadCount -= 1
        }
        
    }
    
    func showData(){
        
        subjectLBL.text =  "\(self.contactDetails?.subject ?? "") (\(self.contactDetails?.noteId ?? 0))"
        let fullName = "\(self.contactDetails?.author?.fullName  ?? " ") - Burbank Homes"
        let authorValue = (self.contactDetails?.createdInMyHome ?? true) ? appDelegate.currentUser?.userDetailsArray?.first?.fullName ?? " " :  fullName
        authorLb.text = "\(authorValue)"
        descriptionLb.text = self.contactDetails?.body ?? ""
        self.tableDataSource = contactDetails?.replies //All replies
        setupUI()
    }
    func setupUI()
    {
        DispatchQueue.main.async {
            if self.tableDataSource?.count == 0 || self.tableDataSource == nil
            {
                self.tableView.isHidden = true
                
            }else {
                self.tableView.isHidden = false
                self.tableView.layoutIfNeeded()
//                self.tableView.reloadData()
//                self.tableView.layoutIfNeeded()
                self.applySnapShot()
                self.tableView.layoutIfNeeded()
            }
        }
    }

    @IBAction func didTappedOnReplay(_ sender: UIButton) {
        let recipientEmail = "srikanth.vunyala@digitalminds.solutions"
        let subject = "Re: \(contactDetails?.subject ?? "") \(contactDetails?.noteId ?? 0)"
       // let body = ""
        
        let vc = ContactUsNewMsgPopupVC.instace(sb: .supportAndHelp)
        vc.screenData = (sub : subject,to : recipientEmail ,from : self.contactDetails?.authorname ?? "" )
        vc.noteId = contactDetails?.noteId
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.isFromNewMessage = false
        vc.completion = { [weak self](success) in
            self?.getAPIData()
        }
        self.present(vc, animated: true)
        
    }
    @IBAction func didTappedOnInbox(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
                ContactUsVC.updateNoteData = true
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
    func setupSerivceData(notes : [MyNotesStruct])
    {
        
        //Note without "replyTo" key goes to MainNotes
        //Note with "replyTo" key means it is reply to a note in the list
        let currentNoteId = contactDetails?.noteId
        
        // - Replies from mobile
        var replies : [MyNotesStruct]? = notes.filter({ currentNoteId == $0.replyTo?.noteId})
        
        // - Replies from admin portal
        if let conversations = notes.filter({$0.noteId == currentNoteId}).first?.conversations // admin conversations
        {
            if let adminReplies = conversations.list?.map({ reply in
                var adminReply = reply
                adminReply.isFromAdmin = true
                return adminReply
            }){
                if replies == nil
                {
                    replies = adminReplies
                }else {
                    replies?.append(contentsOf: adminReplies )
                }
            }
        }
        // - Sorting all replies of current note
        self.tableDataSource = replies?.sorted(by: {$0.date.compare($1.date) == .orderedDescending})
        self.setupUI()
        
    }


}


//MARK: - Tableview Delegate
extension ContactUsDetailsVC : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 45))
        view.backgroundColor = UIColor.systemGray6
        let sectionLabel = UILabel(frame: .zero)
        sectionLabel.font = mediumFontWith(size: 18.0)
        sectionLabel.textColor = AppColors.appOrange
        sectionLabel.text = "Replies"
        sectionLabel.textAlignment = .left
        sectionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sectionLabel)
        NSLayoutConstraint.activate([
            sectionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            sectionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            sectionLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            sectionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),

        ])
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
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
