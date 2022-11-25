//
//  MyPlaceMoreOptionsVC.swift
//  BurbankApp
//
//  Created by Mohan Kumar on 04/05/17.
//  Copyright © 2017 DMSS. All rights reserved.
//

import UIKit


class MyPlaceMoreOptionsVC: BurbankAppVC/*MyPlaceWithTabBarVC*/,UITableViewDelegate,UITableViewDataSource,MyPlaceDocumentVCDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    @IBOutlet weak var titleLabel : UILabel!

    @IBOutlet weak var moreOptionsTable: UITableView!
    
    var documentTempArray : NSMutableArray!

    var documentsArray = [MyPlaceDocuments]()
    let menuArray = [
        ["name" : "Favourite Photos", "imageName" : "Ico-Heart","subName" : "View all your favourite photos from here."],
        ["name" : "Documents", "imageName" : "Ico-Documents","subName" : "View all your contracts and documentations here.",],
        ["name" : "Share with Partners", "imageName" : "Ico-Share-1","subName" : "Invite a friend to share your building journey."],
        ["name" : "Frequently Asked Questions", "imageName" : "Ico-FAQNew","subName" : "For instant answers to your most common questions."]]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        _ = setAttributetitleFor(view: titleLabel, title: "MoreFeatures", rangeStrings: ["More", "Features"], colors: [COLOR_BLACK, COLOR_ORANGE], fonts: [FONT_LABEL_HEADING(size: FONT_18), FONT_LABEL_HEADING(size: FONT_18)], alignmentCenter: false)

        
        moreOptionsTable.dataSource = self
        moreOptionsTable.delegate = self

        
        moreOptionsTable.tableFooterView = UIView.init(frame: .zero)
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Button Actions
    @IBAction func backButtonTapped(sender: AnyObject) {
        
        CodeManager.sharedInstance.sendScreenName(dashboard_back_button_touch)
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func inviteFriendTapped() {
        
        AlertManager.sharedInstance.alert("Work in progress")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoreOptionsCell")as! MyPlaceMoreOptionsCell

        let menuDic = menuArray[indexPath.row]
        cell.menuIcon.image = UIImage(named: menuDic["imageName"]!)
        cell.nameLabel.text = menuDic["name"]
        cell.subNameLabel.text = menuDic["subName"]
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if indexPath.row == 1 {
            
            CodeManager.sharedInstance.sendScreenName(documents_icon_touch)
            
//            if appDelegate.constructionID == nil || appDelegate.officeID == nil {
//                AlertManager.sharedInstance.alert("My Place Construction or Office ID is not available")
//                return
//            }
            // GET service for MyPlace Document Details
//            guard let myPlaceStatusDetails = appDelegate.myPlaceStatusDetails else { return }
//            getMyPlaceDocumentDetails(myPlaceStatusDetails.constructionID, officeID: myPlaceStatusDetails.officeID)
            callServerForDocuments()
        }
        else if indexPath.row == 3 {
            
            CodeManager.sharedInstance.sendScreenName(dashboard_faq_button_touch)
            
//            self.performSegue(withIdentifier: "ShowFAQVC", sender: nil)
                                    
            self.tabBarController?.navigationController?.pushViewController(kStoryboardMain_OLD.instantiateViewController(withIdentifier: "MyPlaceFAQVC") as! MyPlaceFAQVC, animated: true)
            
        }else if indexPath.row == 2
        {
            CodeManager.sharedInstance.sendScreenName(dashboard_share_with_partners_button_touch)
            
//            self.performSegue(withIdentifier: "showCoBurbankVC", sender: nil)
            
            self.tabBarController?.navigationController?.pushViewController(kStoryboardMain_OLD.instantiateViewController(withIdentifier: "CoBurbankListVC") as! CoBurbankListVC, animated: true)
            
        }
        
        else if indexPath.row == 0 {
          
            CodeManager.sharedInstance.sendScreenName(dashboard_fav_photos_button_touch)
            
            self.performSegue(withIdentifier: "showMyPlaceFavPhotosVC", sender: nil)
        }
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return tableView.frame.height/4
//    }
    func callServerForDocuments()
    {
        #if DEDEBUG
        print(selectedJobNumberRegion)
        #endif
        
        func showDocumentsVC()
        {
            self.performSegue(withIdentifier: "showDocumentVC", sender: nil)
        }
        if (selectedJobNumberRegion == .OLD && self.documentTempArray == nil) || (selectedJobNumberRegion != .OLD && documentsArray.count == 0)//for QLD,SA region we are not calling service if documents loaded.
        {
            MyPlaceServiceSession.shared.callToGetDataFromServer(myPlaceDocumentsDetailsURLString(), successBlock: { (json, response) in
                //print("documents-->\(json)")
                func handleForQLDSA()
                {
                    self.documentsArray.removeAll()
                    if let jsonArray = json as? NSArray
                    {
                        for obj in jsonArray
                        {
                            if let jsonDic = obj as? [String: Any]
                            {
                                let document = MyPlaceDocuments(jsonDic)
                                if document.type.uppercased() == kPDF
                                {
                                    self.documentsArray.append(document)
                                }
                            }
                        }
                        showDocumentsVC()
                    }
                }
                func handleForVLC()
                {
                    if let jsonArray = json as? NSArray
                    {
                        self.documentTempArray = ((jsonArray).mutableCopy() as! NSMutableArray)
                        showDocumentsVC()
                    }
                }
                selectedJobNumberRegion == .OLD ? handleForVLC() : handleForQLDSA()
            }, errorBlock:  { (error, isJSON) in
                //
            })
        }else
        {
            showDocumentsVC()
        }
        
    }
//    func getMyPlaceDocumentDetails(_ constructionID : String , officeID : String) {
//        ServiceSessionMyPlace.sharedInstance.myDelegate = self
//        ServiceSessionMyPlace.sharedInstance.serviceConnection("GET", url: NSString(format: "") as String, postBodyDictionary: ["ConstructionID":constructionID,"OfficeID":officeID], serviceModule:"GetMyPlaceDocumentDetails")
//    }
//    func responpseFromRequest(_ data: AnyObject, serviceModule: String) {
//        if serviceModule == "GetMyPlaceDocumentDetails" {
//
//            documentTempArray = (data as! NSArray).mutableCopy() as!NSMutableArray
//            self.performSegue(withIdentifier: "showDocumentVC", sender: nil)
//        }
//
//    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDocumentVC"
        {
            let destinaton = segue.destination as! MyPlaceDocumentVC
            destinaton.delegateDocVc = self
            func fillDataForVLC()
            {
                destinaton.myPlaceDocumentsArray = (documentTempArray.mutableCopy() as! NSMutableArray)
            }
            func fillDataForQLDSA()
            {
                destinaton.documentsList = documentsArray
            }
            selectedJobNumberRegion == .OLD ? fillDataForVLC() : fillDataForQLDSA()
        }
}
    
    internal func selectedDocument(_ index: Int) {
        OperationQueue.main.addOperation({
            // Your code here
            self.appDelegate.showActivity()
        })
        
        var extenSionType : String = (documentTempArray.object(at: index) as! NSDictionary).value(forKey: "Extension") as! String
        
        extenSionType = extenSionType.replacingOccurrences(of: " ", with: "")
        
        var urlString = (documentTempArray.object(at: index) as! NSDictionary).value(forKey: "DocumentPath") as! String
        
        urlString = urlString.replacingOccurrences(of: " ", with: "")
        
        self.navigationController?.isNavigationBarHidden = false
        
        let pdfViewController = PDFViewController()
        pdfViewController.pathName = urlString
        pdfViewController.pathExtension = extenSionType
        
        let temp1 = documentTempArray.object(at: index) as AnyObject
        let value1 = temp1.value(forKey: "Title") as! String
        
        _ = documentTempArray.object(at: index) as AnyObject
        let value2 = temp1.value(forKey: "Extension") as! String
        
        pdfViewController.title = NSString(format: "%@%@",value1, value2) as String//By Pranith
        self.navigationController!.pushViewController(pdfViewController, animated: true)
        
        self.appDelegate.hideActivity()
        
    }


}
