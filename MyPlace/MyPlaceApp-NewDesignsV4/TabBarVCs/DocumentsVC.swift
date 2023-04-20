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

class DocumentsVC: UIViewController {
    
    //MARK: - Properties
    @IBOutlet weak var searchBarHeight: NSLayoutConstraint!
    {
        didSet{
            searchBarHeight.constant = 0 //initially searchBar height is zero
        }
    }
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
    @IBOutlet weak var notificationCountLBL: UILabel!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    {
        didSet{
            tableView.tableFooterView = UIView()
            tableView.separatorStyle = .none
            tableView.separatorColor = .clear
        }
    }
    @IBOutlet weak var viewFavouritesContainerView: UIView!{
        didSet{
            if #available(iOS 13.0, *) {
                viewFavouritesContainerView.backgroundColor = .systemGray6
            } else {
                viewFavouritesContainerView.backgroundColor = .lightGray
            }
            
        }
    }
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    var documentList : [DocumentsDetailsStruct]?
    var tableDataSource : [DocumentsDetailsStruct]?
    { didSet { handleTableViewEmptyState() } }
    var menu : SideMenuNavigationController!
    var currentFilePath : String!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // addGradientLayer()
        
        setupProfile()
        sideMenuSetup()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleGestureRecognizer(recognizer:)))
        viewFavouritesContainerView.addGestureRecognizer(tap)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        setupProfile()
        if #available(iOS 13.0, *) {
            tableView.backgroundColor = .systemGray6
        }else{
            tableView.backgroundColor = .lightGray
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getDocumentDetails()
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 120
        tableView.isSkeletonable = true
        tableView.showAnimatedGradientSkeleton()
   
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: - Helper Methods
    func sideMenuSetup()
    {
        let sideMenuVc = UIStoryboard(name: "NewDesignsV4", bundle: nil).instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menu = SideMenuNavigationController(rootViewController: sideMenuVc)
        menu.leftSide = true
        menu.menuWidth = 0.8 * UIScreen.main.bounds.width
        menu.presentationStyle = .menuSlideIn
        menu.presentationStyle.onTopShadowColor = .darkGray
        menu.presentationStyle.onTopShadowOffset = CGSize(width: 1.0, height: 1.0)
        menu.presentationStyle.onTopShadowOpacity = 1.0
        menu.setNavigationBarHidden(true, animated: false)
        SideMenuManager.default.leftMenuNavigationController = menu
        
        
    }
    
    func handleTableViewEmptyState()
    {
        if tableDataSource?.count == 0
        {
            tableView.setEmptyMessage("No Documents Found")
        }
        else {
            tableView.restore()
        }
    }
    
    func setupProfile()
    {
        profileImgView.contentMode = .scaleToFill
        profileImgView.clipsToBounds = true
        profileImgView.layer.cornerRadius = profileImgView.bounds.width/2
        if let imgURlStr = CurrentUservars.profilePicUrl
        {
            profileImgView.image = imgURlStr
        }
        if appDelegate.notificationCount == 0{
            notificationCountLBL.isHidden = true
        }else{
            notificationCountLBL.text = "\(appDelegate.notificationCount)"
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileClick(recognizer:)))
        profileImgView.addGestureRecognizer(tap)
        
    }
    @objc func handleProfileClick (recognizer: UIGestureRecognizer) {
        let vc = UIStoryboard(name: StoryboardNames.newDesing, bundle: nil).instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func searchBtnAction(_ sender: UIButton) {
        hideAndShowSearchBar()
    }
    
    @objc func handleGestureRecognizer(recognizer : UITapGestureRecognizer){
        hideAndShowSearchBar()
    }
    
    func hideAndShowSearchBar(){
        searchBarHeight.constant = searchBarHeight.constant == 0 ? 44 : 0; self.searchBar.resignFirstResponder()
        UIView.animate(withDuration: 0.250) {
            self.view.layoutIfNeeded()
        } completion: { cmp in
            
        }
    }
    //MARK: - Helper Methods
    func getTableCell(indexPath : IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: DocumentsTBCell.identifier) as! DocumentsTBCell
        if let item = tableDataSource?[indexPath.row]
        {
            cell.setup(model: item )
        }
        return cell
    }
    @IBAction func didTappedOnMenuIcon(_ sender: UIButton) {
        present(menu, animated: true, completion: nil)
    }
    @IBAction func supportBtnTapped(_ sender: UIButton) {
        guard let vc = UIStoryboard(name: StoryboardNames.newDesing5, bundle: nil).instantiateViewController(withIdentifier: "ContactUsVC") as? ContactUsVC else {return}
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Service Calls
    
    func getDocumentDetails()
    {
        let jobAndAuth = APIManager.shared.getJobNumberAndAuthorization()
        guard let jobNumber = jobAndAuth.jobNumber else {debugPrint("Job Number is Null");return}
        let auth = jobAndAuth.auth
     
        NetworkRequest.makeRequestArray(type: DocumentsDetailsStruct.self, urlRequest: Router.documentsDetails(auth: auth, contractNo: jobNumber), showActivity: false) { [weak self](result) in
            switch result
            {
            case .success(let data):
                
                self?.documentList = data.filter( { !($0.type!.lowercased().contains("jpg"))}).filter( { !($0.type!.lowercased().contains("png")) })
                //self?.documentList = data.filter({$0.type?.lowercased() != "jpg"})
                DispatchQueue.main.async {
                    self?.tableDataSource = self?.documentList?.sorted(by: {$0.date > $1.date})
                    self?.tableView.stopSkeletonAnimation()
                    self?.view.hideSkeleton()
                        self?.tableView.reloadData()
                        
                }
                
            case.failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    func getPdfDataAt(rowNo : Int)
    {
        guard let url = tableDataSource?[rowNo].url, let type = tableDataSource?[rowNo].type, let title = tableDataSource?[rowNo].title else {return}
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
                let filter = [doc.title?.lowercased() , doc.type?.lowercased()]
                let displayDate = doc.docdate?.displayDateFormateString()
                return (filter.contains(searchText.lowercased())) ||
                (displayDate?.lowercased().contains(searchText.lowercased()) ?? false)
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
}


//MARK: - TableView Delegate & Datasource
extension DocumentsVC : UITableViewDelegate, SkeletonTableViewDataSource
{
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return DocumentsTBCell.identifier
    }
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


