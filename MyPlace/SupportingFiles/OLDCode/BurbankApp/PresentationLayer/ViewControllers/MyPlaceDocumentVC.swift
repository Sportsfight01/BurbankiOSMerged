//
//  MyPlaceDocumentVC.swift
//  Burbank
//
//  Created by Mohan Kumar on 25/10/16.
//  Copyright © 2016 DMSS. All rights reserved.
//

import UIKit
import SafariServices


protocol MyPlaceDocumentVCDelegate {
    func selectedDocument(_ index : Int)
}

class MyPlaceDocumentVC: BurbankAppVC/*MyPlaceWithTabBarVC*/, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var titleLabel : UILabel!

    @IBOutlet var myPlaceDocumentTableView : UITableView!
    @IBOutlet weak var jobNumberTextFiled : UITextField!
    
    var myPlaceDocumentsArray : NSMutableArray!

    var delegateDocVc : MyPlaceDocumentVCDelegate!
    var documentsList = [MyPlaceDocuments]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAppearanceFor(view: titleLabel, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_LABEL_HEADING(size: FONT_18))

        
        let user = appDelegate.currentUser
        if let jobNumber = user?.userDetailsArray?[0].myPlaceDetailsArray[0].jobNumber
        {
            jobNumberTextFiled.text = jobNumber
        }
        // Do any additional setup after loading the view.

    }
    // MARK: - Button Actions
    @IBAction func backButtonTapped(sender: AnyObject) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return selectedJobNumberRegion == .OLD ? myPlaceDocumentsArray.count : documentsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myPlaceDocumentCell = tableView.dequeueReusableCell(withIdentifier: "MyPlaceDocumentIdentifier", for: indexPath) as! MyPlaceDocumentCell
        
        myPlaceDocumentCell.selectionStyle = .none
        
        func fillCellForVLC()
        {
            myPlaceDocumentCell.docNameLabel.text = NSString(format: "%@%@", (myPlaceDocumentsArray.object(at: indexPath.row) as AnyObject).value(forKey: "Title")as! NSString,(myPlaceDocumentsArray.object(at: indexPath.row) as AnyObject).value(forKey: "Extension")as! NSString) as String
            
            myPlaceDocumentCell.dateLabel.text = (myPlaceDocumentsArray.object(at: indexPath.row) as AnyObject).value(forKey: "UploadedTime") as? String
            
            var extensionType = (myPlaceDocumentsArray.object(at: indexPath.row) as AnyObject).value(forKey: "Extension")as! String
            
            extensionType = extensionType.replacingOccurrences(of: " ", with: "")
            
            myPlaceDocumentCell.docImage.image = UIImage(named: "Ico-pdf")
            
            if extensionType == ".PNG" || extensionType == ".JPG" {
                myPlaceDocumentCell.docImage.image = UIImage(named: "document_picture")
            }
        }
        func fillCellForQLDSA()
        {
            let document = documentsList[indexPath.row]
            myPlaceDocumentCell.docNameLabel.text = "\(document.title).\(document.type)"
            myPlaceDocumentCell.docImage.image = #imageLiteral(resourceName: "Ico-pdf")
            myPlaceDocumentCell.dateLabel.text = "\(document.docDate.displayDateFormateString()) \(document.docDate.displayInTimeFormat())"
            
        }
        selectedJobNumberRegion == .OLD ? fillCellForVLC() : fillCellForQLDSA()
        return myPlaceDocumentCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        CodeManager.sharedInstance.sendScreenName(documents_viewed)
        
        
        func handleForVLC()
        {
            delegateDocVc.selectedDocument(indexPath.row)
        }
        func handleForQLDSA()
        {
            let urlId = documentsList[indexPath.row].urlId
            let url = documentsList[indexPath.row].url
            let documentURL = "\(clickHomeBaseImageURL)\(url)"
            //let jobNumber = appDelegate.myPlaceStatusDetails?.jobNumber ?? ""
            var filePath = ""
            let user = appDelegate.currentUser
            if let jobNumber = user?.userDetailsArray?[0].myPlaceDetailsArray[0].jobNumber
            {
                filePath = "\(documentsPath)/\(jobNumber)_\(urlId).pdf"
            }
            let fileURL = URL(fileURLWithPath: filePath)
            let fileURLString = fileURL.absoluteString
            if FileManager.default.fileExists(atPath: fileURL.path)
            {
                showPDFFile(fileURLString) // fileURLString
            }else
            {
                MyPlaceServiceSession.shared.callToGetDataFromServer(documentURL, successBlock: { (json, response) in
                    if let jsosData = json as? Data
                    {
                        //.appendingPathExtension("pdf")
                        do
                        {
                            try jsosData.write(to: fileURL, options: .atomic)
                            self.showPDFFile(fileURLString) // fileURLString
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
        selectedJobNumberRegion == .OLD ? handleForVLC() : handleForQLDSA()
    }
    func showPDFFile(_ path: String)
    {
//        let pdfViewController = PDFViewController()
//        pdfViewController.pathName = path//fileURL.absoluteString
//        pdfViewController.pathExtension = ".PDF"
//        //                        pdfViewController.title = "Testy"
//        self.navigationController?.isNavigationBarHidden = false
//        self.navigationController!.pushViewController(pdfViewController, animated: true)
        
        let tempPath = path.replacingOccurrences(of: "file://", with: "")
        
        let dc = UIDocumentInteractionController(url: URL(fileURLWithPath: tempPath))
        dc.delegate = self
        dc.presentPreview(animated: true)
        
    }
    func downloadAndshowPDFFile()
    {
        
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        if IS_IPHONE
//        {
//            return (tableView.frame.size.height / 6)
//
//        }else
//        {
//            return (tableView.frame.size.height / 10)
//        }
//    }
//
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MyPlaceDocumentVC : UIDocumentInteractionControllerDelegate {
    //MARK: UIDocumentInteractionController delegates
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self//or use return self.navigationController for fetching app navigation bar colour
    }
}
