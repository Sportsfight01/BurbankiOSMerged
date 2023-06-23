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
    static var updateNoteData : Bool = false
    //MARK: - Properties
    
    @IBOutlet weak var newMessageBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBarHeight: NSLayoutConstraint!
    private var tableDataSource : [MyNotesStruct]?
    {
        didSet{   setupUI()   }
    }
    private var contactArr : [MyNotesStruct]?
   // private lazy var dataSource : UITableViewDiffableDataSource<Int,MyNotesStruct>! = makeDataSource()
    
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
      
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction))
        newMessageBtn.addGestureRecognizer(gesture)
        getAPIData()
        tableView.addRefressControl {[weak self] in
            self?.getAPIData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBarButtons(shouldShowNotification: false)
        searchBar.text?.removeAll()
        searchBar.resignFirstResponder()
        if ContactUsVC.updateNoteData{
            getAPIData()
            ContactUsVC.updateNoteData = false
        }
        
        
    }
    
    deinit {
        debugPrint("ContactUS Deinitialized")
    }
//     //MARK: - TableViewDiffableDataSource
//    private func makeDataSource() -> UITableViewDiffableDataSource<Int, MyNotesStruct>
//    {
//        let dataSource = UITableViewDiffableDataSource<Int, MyNotesStruct>(tableView: tableView) { tableView, indexPath, itemIdentifier in
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactUsTVC") as! ContactUsTVC
//            cell.setup(model : itemIdentifier)
//            return cell
//        }
//        return dataSource
//    }
//
//    private func applySnapShot()
//    {
//        var snapShot = NSDiffableDataSourceSnapshot<Int, MyNotesStruct>()
//        snapShot.appendSections([0])
//        snapShot.appendItems(tableDataSource ?? [])
//        dataSource.apply(snapShot, animatingDifferences: true)
//    }
    
    
    @objc func panGestureAction(_ gesture : UIPanGestureRecognizer)
    {
        // let translation = gesture.translation(in: newMessageBtn.superview)
        //debugPrint(translation.x)
        switch gesture.state
        {
        case .changed:
            let translation = gesture.translation(in: self.view)
            debugPrint(translation.x)
            guard translation.x > 0 && translation.x < SCREEN_WIDTH * 0.4 else {return}
            newMessageBtn.transform = CGAffineTransform(translationX: translation.x, y: 0)
        case .ended:
            newMessageBtn.transform = .identity
            self.didTappedOnNewMsg(newMessageBtn)
        default:
            debugPrint("default")
        }
        UIView.animate(withDuration: 0.250, delay: 0) {
            self.view.layoutIfNeeded()
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
        guard isNetworkReachable else { showAlert(message: checkInternetPullRefresh) {[weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.refreshControl?.endRefreshing()
            }
        }; return}
        appDelegate.showActivity()
        APIManager.shared.getNotes {[weak self] result in
            DispatchQueue.main.async {
                appDelegate.hideActivity()
                self?.tableView.refreshControl?.endRefreshing()
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
               // self.tableView.reloadData()
                self.tableView.restore()
//                self.applySnapShot()
                self.tableView.reloadData()
            }
        }
    }
    @objc private func refreshControlAction()
    {
        self.getAPIData()
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
//        DispatchQueue.main.async {
//            self.setupUI()
//        }
        
        
    }
    
    
}
//MARK: - Tableview Delegate && Datasource
extension ContactUsVC : UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableDataSource?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactUsTVC") as! ContactUsTVC
        cell.setup(model : self.tableDataSource?[indexPath.row])
        return cell
    }
//
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0
        {
            self.tableDataSource = contactArr
            self.searchBar.endEditing(true)
            
        }
        else {
            self.tableDataSource = contactArr?.filter({ note in
          
                return (note.authorname?.lc.contains(searchText.lc) ?? false) || (note.subject?.lc.contains(searchText.lc) ?? false) ||
                (note.displayDate?.contains(searchText.lc) ?? false)
            })
            self.tableView.reloadData()
        }
      
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
