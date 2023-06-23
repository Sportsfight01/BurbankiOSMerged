//
//  DocumentsVC.swift
//  BurbankApp
//
//  Created by naresh banavath on 24/11/21.
//  Copyright © 2021 DMSS. All rights reserved.
//

import UIKit
import SideMenu
import SafariServices
import SkeletonView

class DocumentsVC: BaseProfileVC {
    
    //MARK: - Properties
    @IBOutlet weak var searchBarHeight: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewFavouritesContainerView: UIView!

//    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    var documentList : [DocumentsDetailsStruct]?
    var tableDataSource : [DocumentsDetailsStruct]?
    { didSet { handleTableViewEmptyState() } }
    var currentFilePath : String!
    lazy var dataSource = makeDataSource()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getDocumentDetails()
        tableView.addRefressControl {[weak self] in
            self?.getDocumentDetails()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        tableView.backgroundColor = .systemGray6
        searchBar.resignFirstResponder()
        self.tableView.stopSkeletonAnimation()
        self.tableView.refreshControl?.endRefreshing()
       
       
    }
    //MARK: - IBActions
    
    @IBAction func searchBtnAction(_ sender: UIButton) {
        hideAndShowSearchBar()
    }
    
    @objc func handleGestureRecognizer(recognizer : UITapGestureRecognizer){
        hideAndShowSearchBar()
    }
    
    //MARK: - Helper Methods
    func setupUI()
    {
        //UI_Elemets_Setup
        viewFavouritesContainerView.backgroundColor = .systemGray6

        //TableView_Setup
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 120
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        tableView.isSkeletonable = true
        
        //SearchBar
        searchBar.delegate = self
        searchBar[keyPath: \.searchTextField].font = UIFont.systemFont(ofSize: 15.0)
        UILabel.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = UIFont.systemFont(ofSize: 14)
        
        //Gestures
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleGestureRecognizer(recognizer:)))
        viewFavouritesContainerView.addGestureRecognizer(tap)
        
        //Calling Helper Methods
        setupTitles()
    }
    
    func setupTitles()
    {
        profileView.titleLb.text = "MyDocuments"
        profileView.helpTextLb.text = "Find all the documents related to your home build."
    }
    
    func handleTableViewEmptyState()
    {
        if tableDataSource?.count == 0
        {
            tableView.setEmptyMessage("No documents found")
        }
        else {
            tableView.restore()
        }
    }
    func hideAndShowSearchBar(){
        searchBarHeight.constant = searchBarHeight.constant == 0 ? 44 : 0;
        if searchBarHeight.constant == 44
        {
            searchBar.becomeFirstResponder()
        }
        else{
            searchBar.resignFirstResponder()
        }
        UIView.animate(withDuration: 0.250) {
            self.view.layoutIfNeeded()
        }
    }

    func makeDataSource() -> UITableViewDiffableDataSource<Int,DocumentsDetailsStruct>
    {
        let dataSource = UITableViewDiffableDataSource<Int,DocumentsDetailsStruct>(tableView: tableView) { tableView, indexPath, itemIdentifier in
            self.getTableCell(indexPath: indexPath)
        }
        
        return dataSource
    }
    func applySnapshot()
    {
        var snapShot = NSDiffableDataSourceSnapshot<Int, DocumentsDetailsStruct>()
        snapShot.appendSections([0])
        snapShot.appendItems(tableDataSource ?? [])
        dataSource.apply(snapShot, animatingDifferences: true)
    }
    func getTableCell(indexPath : IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: DocumentsTBCell.identifier) as! DocumentsTBCell
        if let item = tableDataSource?[indexPath.row]
        {
            cell.setup(model: item )
        }
        return cell
    }

    
    //MARK: - Service Calls
    
    func getDocumentDetails()
    {
        guard isNetworkReachable else { showAlert(message: checkInternetPullRefresh) {[weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.refreshControl?.endRefreshing()
            }
        }; return}
        let jobAndAuth = APIManager.shared.getJobNumberAndAuthorization()
        guard let jobNumber = jobAndAuth.jobNumber else {debugPrint("Job Number is Null");return}
        let auth = jobAndAuth.auth
        //show skeleton
        tableView.showAnimatedGradientSkeleton()        
        NetworkRequest.makeRequestArray(type: DocumentsDetailsStruct.self, urlRequest: Router.documentsDetails(auth: auth, contractNo: jobNumber), showActivity: false) { [weak self](result) in
            //hide skeleton
            DispatchQueue.main.async {
                self?.tableView.stopSkeletonAnimation()
                self?.view.hideSkeleton()
            }
            DispatchQueue.main.async {
            appDelegate.hideActivity()
                self?.tableView.refreshControl?.endRefreshing()
            }
      
            switch result
            {
            case .success(let data):
                
                self?.documentList = data.filter( { !($0.type!.lc.contains("jpg"))}).filter( { !($0.type!.lc.contains("png")) })
                //self?.documentList = data.filter({$0.type?.lowercased() != "jpg"})
                DispatchQueue.main.async {
                    self?.documentList = self?.documentList?.sorted(by: {$0.date > $1.date})
                    self?.tableDataSource = self?.documentList
                    self?.viewFavouritesContainerView.isHidden = self?.tableDataSource?.count == 0 ? true : false
                   // self?.tableView.reloadData()
                    self?.applySnapshot()
                        
                }
                
            case.failure(let err):
                print(err.localizedDescription)
            }
            
            
        }
    }
    func getPdfDataAt(rowNo : Int)
    {
        guard let url = tableDataSource?[rowNo].url, let type = tableDataSource?[rowNo].type?.trim(), let title = tableDataSource?[rowNo].title else {return}
        let fileName = "\(title).\(type)"
        let documentURL = "\(clickHomeBaseImageURL)\(url)"
        if type.contains("eml")
        {
            openSafariVC(url: documentURL)
        }else {
            //DocumentPreviewer
            let documentPreviewer = DocumentPreviewer(fileName: fileName, url: documentURL)
            documentPreviewer.parentViewController = self
            documentPreviewer.loadDocument()
        }
        
    }
    
    func openSafariVC(url : String)
    {
        if let url = URL(string: url) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
    
    
}

//MARK: - SearchBar Delegate & Datasource
extension DocumentsVC : UISearchBarDelegate
{

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0
        {
            tableDataSource = documentList
        }
        else {
            tableDataSource = documentList?.filter({ doc in
                
                guard let title = doc.title, let docDate = doc.docdate else {return false}
                let displayDate = docDate.components(separatedBy: ".").first ?? ""
                let notedated = dateFormatter(dateStr: displayDate, currentFormate: "yyyy-MM-dd'T'HH:mm:ss", requiredFormate: "dd MMM, yyyy, hh:mm a") ?? ""
                let filter = (title.lc.contains(searchText.lc) || notedated.lc.contains(searchText.lc))
                return filter
            })
            
        }
        self.applySnapshot()
       // tableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        if searchBar.searchTextField.text?.trim().count == 0
        {
            tableDataSource = documentList
          //  tableView.reloadData()
            applySnapshot()
        }
        self.searchBar.endEditing(true)
    }
}

extension DocumentsVC : UITableViewDelegate, SkeletonTableViewDataSource
{
    //MARK: - Skeleton Datasource
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return DocumentsTBCell.identifier
    }
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    //MARK: - TableView Delegate & Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableDataSource?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        return getTableCell(indexPath: indexPath)

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        getPdfDataAt(rowNo: indexPath.row)
        searchBar.resignFirstResponder()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
}
// MARK: - DocumentsDetailsStruct
struct DocumentsDetailsStruct: Decodable , Hashable{
    let title, authorname: String?
    let byclient: Bool?
    let docdate: String?
    let current: Bool?
    let type, url: String?
    let externalUrls: [String]?
    
    var date : Date {
        return docdate?.components(separatedBy: ".").first?.getDate() ?? Date()
    }
}


