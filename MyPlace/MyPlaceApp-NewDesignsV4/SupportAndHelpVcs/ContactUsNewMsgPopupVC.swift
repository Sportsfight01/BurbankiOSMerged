//
//  ContactUsNewMsgPopupVC.swift
//  BurbankApp
//
//  Created by Naresh Banavath on 22/07/22.
//  Copyright © 2022 DMSS. All rights reserved.
//

import UIKit
import GrowingTextView
class ContactUsNewMsgPopupVC: UIViewController {

    //MARK: - Properties
    @IBOutlet weak var replyTextView: GrowingTextView!
    @IBOutlet weak var subjectTf: UITextField!
//    @IBOutlet weak var toTf: UITextField!
    @IBOutlet weak var headerLb: UILabel!
    var isFromNewMessage : Bool = false
    
    
  //  @IBOutlet weak var fromLb: UILabel!
    
    var screenData : (sub : String? , to : String? , from : String?)?
    var noteId : Int?
    var completion : ((String)->())?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
       // toTf.isUserInteractionEnabled = false
        if !isFromNewMessage {
            headerLb.text = "Reply Message"
            // When clicked Reply
            subjectTf.isUserInteractionEnabled = false
            if #available(iOS 13.0, *)
            {
          //  toTf.backgroundColor = .systemGray6
            subjectTf.backgroundColor = .systemGray6
            }
            
        }
    
        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // fromLb.text = screenData?.to
       // toTf.text = screenData?.from
        subjectTf.text = screenData?.sub
        replyTextView.layer.borderWidth = 1.0
        replyTextView.layer.borderColor = UIColor.black.cgColor
        replyTextView.backgroundColor = .white
        replyTextView.layer.cornerRadius = 5.0
//        if #available(iOS 13.0, *)
//        {
//            replyTextView.backgroundColor = .systemGray6
//        }
//        else {
//        replyTextView.backgroundColor = .lightGray
//        }
    }
    
    
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        
        dismiss(animated: true)
    }
    
    @IBAction func submitBtnAction(_ sender: UIButton) {
        guard replyTextView.text.count > 10 else {self.showAlert(message: "Please Enter Minimum of 10 characters");return}
     
        postNote()
    }
    //MARK: - Service Call
    
    func postNote()
    {
        var currenUserJobDetails : MyPlaceDetails?
        currenUserJobDetails = (UIApplication.shared.delegate as! AppDelegate).currentUser?.userDetailsArray![0].myPlaceDetailsArray[0]
        if selectedJobNumberRegionString == ""
        {
            let jobRegion = currenUserJobDetails?.region
            selectedJobNumberRegionString = jobRegion!
           // print("jobregion :- \(jobRegion)")
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
        

        var parameters : [String : Any] = [:]

        if isFromNewMessage
        {
            parameters = ["replytoid" : NSNull() , "subject" : subjectTf.text ?? "", "stepid" : 0, "body" : replyTextView.text ?? ""]
        }
        else
        {
            if let noteId = noteId {
                parameters = ["replytoid" : noteId , "subject" : subjectTf.text ?? "", "stepid" : 0, "body" : replyTextView.text ?? ""]
            }
            
        }


        NetworkRequest.makeRequest(type: MyNotesStruct.self, urlRequest: Router.postNotes(auth: valueStr, contractNo: contractNo , parameters: parameters)) { [weak self](result) in
            switch result
            {
            case .success(let data):
                print(data)
                //self?.setupProgressDetails(progressData: data)
              //  self?.tableDataSource = data
                DispatchQueue.main.async {
                 //   self?.contactArr = self?.tableDataSource
                   // self?.tableView.reloadData()
                    self?.dismiss(animated: true) {
                        self?.completion?("success")
                    }
                   
                }

            case.failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
//    func checkUserLogin1()
//      {
//          guard  let myPlaceDetails = self.appDelegate.currentUser?.userDetailsArray?[0].myPlaceDetailsArray[0] else {return }
//          let region = myPlaceDetails.region ?? ""
//          let jobNumber = myPlaceDetails.jobNumber ?? ""
//          let password = myPlaceDetails.password ?? ""
//          let userName = myPlaceDetails.userName ?? ""
//          // ServiceSessionMyPlace.sharedInstance.serviceConnection("POST", url: url, postBodyDictionary: ["Region": region, "JobNumber":jobNumber, "UserName":userName, "Password":password], serviceModule:"PropertyStatusService")
//          let postDic =  ["Region": region, "JobNumber":jobNumber, "UserName":userName, "Password":password]
//          //callMyPlaceLoginServie(myPlaceDetails)
//          let url = URL(string: checkUserLogin())
//          var urlRequest = URLRequest(url: url!)
//          urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
//          urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
//          urlRequest.httpMethod = kPost
//          do {
//              urlRequest.httpBody = try JSONSerialization.data(withJSONObject: postDic, options:[])
//          }
//          catch {
//  #if DEDEBUG
//              print("JSON serialization failed:  \(error)")
//  #endif
//          }
//          appDelegate.showActivity()
//          URLSession.shared.dataTask(with: urlRequest, completionHandler: { [weak self](data, response, error) in
//              DispatchQueue.main.async {
//                  self?.appDelegate.hideActivity()
//              }
//              print("URL:- \(response?.url) postData :- \(postDic)")
//              if error != nil
//              {
//  #if DEDEBUG
//                  print("fail to Logout")
//  #endif
//                  return
//              }
//              if let strData = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
//              {
//                  print(strData)
//                  guard strData == "true" || strData.contains("true") else {return}
//                  self?.getContacts()
//                  
//                  
//              }
//          }).resume()
//      }
//    func getContacts()
//    {
//      guard  let myPlaceDetails = self.appDelegate.currentUser?.userDetailsArray?[0].myPlaceDetailsArray[0] else {return }
//      let jobNumber = myPlaceDetails.jobNumber ?? ""
//      NetworkRequest.makeRequest(type: ContactDetailsStruct.self, urlRequest: Router.getClientInfoForContractNumber(jobNumber: jobNumber)) {[weak self] (result) in
//        switch result
//        {
//        case .success(let data):
//          print(data)
//         // let contractPrice =  String(format: "%.2f",data.contractPrice)
// //         self?.financeDetails = data
// //         self?.setupUI()
//
//            DispatchQueue.main.async {
//                self?.toTf.text = data.siteSupervisor
//
//            }
//
//        case .failure(let err):
//          print(err.localizedDescription)
//            DispatchQueue.main.async {
//                self?.showAlert(message: "No Data Found")
//            }
//        }
//      }
//    }

}
