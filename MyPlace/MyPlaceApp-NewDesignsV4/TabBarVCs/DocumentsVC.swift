//
//  DocumentsVC.swift
//  BurbankApp
//
//  Created by naresh banavath on 24/11/21.
//  Copyright © 2021 DMSS. All rights reserved.
//

import UIKit
import SideMenu

import QuickLook
import SafariServices

enum DifSection{
    case first
}


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
    var menu : SideMenuNavigationController!
    var currentFilePath : String!
    ///Diffable Datasource
    ///iOS 13.0 *
//    @available(iOS 13.0, *)
//    typealias DataSource = UITableViewDiffableDataSource<DifSection ,DocumentsDetailsStruct>
//    @available(iOS 13.0, *)
//    typealias SnapShot = NSDiffableDataSourceSnapshot<DifSection ,DocumentsDetailsStruct>

    //    public var dataSource : DataSource?
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
       // addGradientLayer()
        getDocumentDetails()
        setupProfile()
        sideMenuSetup()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleGestureRecognizer(recognizer:)))
        viewFavouritesContainerView.addGestureRecognizer(tap)
      
        // Do any additional setup after loading the view.
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
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    func sideMenuSetup()
    {
        let sideMenuVc = UIStoryboard(name: "NewDesignsV4", bundle: nil).instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menu = SideMenuNavigationController(rootViewController: sideMenuVc)
        menu.leftSide = true
        menu.menuWidth = 0.8 * UIScreen.main.bounds.width
        menu.presentationStyle = .menuSlideIn
        
     
        menu.setNavigationBarHidden(true, animated: false)
        SideMenuManager.default.leftMenuNavigationController = menu
        
        
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
//

//    @available(iOS 13.0, *)
//    func makeDataSource() -> DataSource
//    {
//        let datasource = DataSource(tableView: tableView) { [weak self] tableView, indexPath, model in
////            let cell = tableView.dequeueReusableCell(withIdentifier: DocumentsTBCell.identifier) as! DocumentsTBCell
////            cell.pdfNameLb.numberOfLines = 1
////            cell.pdfNameLb.font = UIFont.systemFont(ofSize: 16.0,weight: .bold)
////            cell.pdfNameLb.text = "\(self?.tableDataSource?[indexPath.row].title ?? " ").\(self?.tableDataSource?[indexPath.row].type ?? "pdf")"
////            let date = self?.tableDataSource?[indexPath.row].docdate?.displayDateFormateString() ?? "-"
////            let time = self?.tableDataSource?[indexPath.row].docdate?.displayInTimeFormat() ?? "-"
////            cell.uploadedOnDateLb.text = "Uploaded on: \(date), \(time)"
////            cell.uploadedOnDateLb.numberOfLines = 1
////            return cell
//            return self?.getTableCell(indexPath: indexPath)
//
//        }
//        return datasource
//    }
    
    func getTableCell(indexPath : IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: DocumentsTBCell.identifier) as! DocumentsTBCell
        cell.pdfNameLb.numberOfLines = 1
        cell.pdfNameLb.font = UIFont.systemFont(ofSize: 16.0,weight: .bold)
        cell.pdfNameLb.text = "\(tableDataSource?[indexPath.row].title ?? " ").\(tableDataSource?[indexPath.row].type ?? "pdf")"
      //  let date = tableDataSource?[indexPath.row].docdate?. ?? "-"
        if let notedate = tableDataSource?[indexPath.row].docdate?.components(separatedBy: ".").first
        {
            
            
            let notedated = dateFormatter(dateStr: notedate, currentFormate: "yyyy-MM-dd'T'HH:mm:ss", requiredFormate: "dd MMM, yyyy, hh:mm a")
            cell.uploadedOnDateLb.text = "Uploaded on: \(notedated ?? "")"
        }
        
        
//        let time = tableDataSource?[indexPath.row].docdate?.displayInTimeFormat() ?? "-"
//        cell.uploadedOnDateLb.text = "Uploaded on: \(date), \(time)"
        cell.uploadedOnDateLb.numberOfLines = 1
        return cell
    }

//    @available(iOS 13.0, *)
//    func applySnapShot(array : [DocumentsDetailsStruct], animate : Bool = false)
    
//    @available(iOS 13.0, *)
//    func applySnapShot(array : [DocumentsDetailsStruct])
//    {
//        var snapShot = SnapShot()
//        snapShot.appendSections([.first])
//        snapShot.appendItems(array)
//        makeDataSource().apply(snapShot, animatingDifferences: animate)
//        makeDataSource().apply(snapShot, animatingDifferences: false)
//    }
    @IBAction func didTappedOnMenuIcon(_ sender: UIButton) {
        
        present(menu, animated: true, completion: nil)
        //        guard let vc = UIStoryboard(name: StoryboardNames.newDesing5, bundle: nil).instantiateInitialViewController() else {return}
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func supportBtnTapped(_ sender: UIButton) {
        guard let vc = UIStoryboard(name: StoryboardNames.newDesing5, bundle: nil).instantiateViewController(withIdentifier: "ContactUsVC") as? ContactUsVC else {return}
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Service Calls
    
    func getDocumentDetails()
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
        var contractNo : String = ""
    
            if let jobNum = appDelegate.currentUser?.jobNumber, !jobNum.trim().isEmpty
            {
                contractNo = jobNum
            }
            else {
                contractNo = appDelegate.currentUser?.userDetailsArray?.first?.myPlaceDetailsArray.first?.jobNumber ?? ""
            }
        
        
        
        NetworkRequest.makeRequestArray(type: DocumentsDetailsStruct.self, urlRequest: Router.documentsDetails(auth: valueStr, contractNo: contractNo)) { [weak self](result) in
            switch result
            {
            case .success(let data):
                
           
                self?.documentList = data.filter( { !($0.type!.lowercased().contains("jpg"))}).filter( { !($0.type!.lowercased().contains("png")) })
                //self?.documentList = data.filter({$0.type?.lowercased() != "jpg"})
                DispatchQueue.main.async {
                    self?.tableDataSource = self?.documentList?.sorted(by: {$0.date > $1.date})
                    
//                    if #available(iOS 13.0, *)
//                    {
//                        self?.applySnapShot(array: self?.tableDataSource ?? [])
//                    }
//                    else {
                        self?.tableView.reloadData()
                   // }
                }
                
            case.failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    func getPdfDataAt(rowNo : Int)
    {
        
        
        
        guard let urlId = tableDataSource?[rowNo].url?.components(separatedBy: "?").first?.components(separatedBy: "/").last else {return}
        guard let url = tableDataSource?[rowNo].url, let type = tableDataSource?[rowNo].type else {return}
    
        let documentURL = "\(clickHomeBaseImageURL)\(url)"
        //let jobNumber = appDelegate.myPlaceStatusDetails?.jobNumber ?? ""
      
        
        var filePath = ""
        let user = appDelegate.currentUser
        if let jobNumber = user?.jobNumber
        {
            filePath = "\(documentsPath)/\(jobNumber)_\(urlId).\(type)"
        }
        let fileURL = URL(fileURLWithPath: filePath)
        let fileURLString = fileURL.absoluteString
        if FileManager.default.fileExists(atPath: fileURL.path)
        {
            showPDFFile(fileURLString) // fileURLString
        }else
        {
            MyPlaceServiceSession.shared.callToGetDataFromServer(documentURL, successBlock: { [weak self](json, response) in
                if let jsosData = json as? Data
                {
                    //.appendingPathExtension("pdf")
                    do
                    {
                        try jsosData.write(to: fileURL, options: .atomic)
                        self?.showPDFFile(fileURLString) // fileURLString
                    }catch
                    {
#if DEDEBUG
                        print("fail to write file")
#endif
                        
                    }
                    
                }
                
                // data.writeToFile(filePath, atomically: true)
            }, errorBlock: { (error, isJSON) in
                //
            },isResultEncodedString: true)
        }
        
    }
    func showPDFFile(_ path: String)
    {
        let tempPath = path.replacingOccurrences(of: "file://", with: "")
        print("currentfilePath :- \(tempPath)")
        self.currentFilePath = tempPath
        
//
        let previewController = QLPreviewController()
        previewController.dataSource = self
        self.present(previewController, animated: true)

//            let safariVC = SFSafariViewController(url: URL(fileURLWithPath: tempPath))
// 
//        present(safariVC, animated: true)
        
    }
    
    
}

//@available(iOS 13.0, *)
extension DocumentsVC : UITableViewDelegate , UITableViewDataSource , UISearchBarDelegate , QLPreviewControllerDataSource
{
    //MARK: - Quicklook delegates
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let url = URL(fileURLWithPath: currentFilePath)
        return url as QLPreviewItem
    }
    
    
    //MARK: - SearchBar Delegate & Datasource
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0
        {
            tableDataSource = documentList
        }
        else {
            //tableDataSource = documentList?.filter({$0.title?.lowercased().contains(searchText.lowercased()) ?? false})
            tableDataSource = documentList?.filter({ doc in
                
                let displayDate = doc.docdate?.displayDateFormateString()
                return (doc.title?.lowercased().contains(searchText.lowercased()) ?? false) ||
                (displayDate?.lowercased().contains(searchText.lowercased()) ?? false)
            })
            
        }
//        if #available(iOS 13.0, *) {
//            self.applySnapShot(array: tableDataSource ?? [])
//        } else {
            // Fallback on earlier versions
//            // Fallback on earlier versions
            tableView.reloadData()
       // }
        
        
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
        {
            self.searchBar.endEditing(true)
        }
    
    //MARK: - TableView Delegate & Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableDataSource?.count == 0
        {
            tableView.setEmptyMessage("No Records Found")
        }
        else {
            tableView.restore()
        }
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
@available(iOS 13.0, *)
extension DocumentsVC : UIDocumentInteractionControllerDelegate {
    //MARK: UIDocumentInteractionController delegates
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self//or use return self.navigationController for fetching app navigation bar colour
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
