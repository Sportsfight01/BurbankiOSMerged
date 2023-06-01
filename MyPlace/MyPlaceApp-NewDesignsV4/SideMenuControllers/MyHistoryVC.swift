//
//  MyHistoryVC.swift
//  BurbankApp
//
//  Created by Naresh Banavath on 24/03/22.
//  Copyright © 2022 DMSS. All rights reserved.
//

import UIKit

class MyHistoryVC: UIViewController {

    //MARK: - Properties
    @IBOutlet weak var profileImgView: UIImageView!
    
    @IBOutlet weak var notificationCountLBL: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var tableDataSource : [MyNotesStruct]?
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupProfile()
        // Do any additional setup after loading the view.
        getHistoryDetails()
        tableView.delegate = self
        tableView.dataSource = self
    
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupNavigationBarButtons()
        setupProfile()
    }
    
    //MARK: - Service Call
    func getHistoryDetails()
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
                self?.tableDataSource = data
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                
            case.failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    
    func setupProfile()
    {
        profileImgView.contentMode = .scaleToFill
        profileImgView.clipsToBounds = true
        profileImgView.layer.cornerRadius = profileImgView.bounds.width/2
//        if let imgURlStr = CurrentUservars.profilePicUrl , let url = URL(string: imgURlStr)
//        {
//          //  profileImgView.sd_setImage(with: url, placeholderImage: UIImage(named: "icon_User"))
//            profileImgView.downloaded(from: url)
//        }
        if let imgURlStr = CurrentUser.profilePicUrl
        {
           // profileImgView.sd_setImage(with: url, placeholderImage: UIImage(named: "icon_User"))
            profileImgView.image = imgURlStr
        }
        if appDelegate.notificationCount == 0{
            notificationCountLBL.isHidden = true
        }else{
            notificationCountLBL.text = "\(appDelegate.notificationCount)"
        }
        //        profileImgView.addBadge(number: appDelegate.notificationCount)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileClick(recognizer:)))
        profileImgView.addGestureRecognizer(tap)
        
    }
    @objc func handleProfileClick (recognizer: UIGestureRecognizer) {
        //        let vc = UIStoryboard(name: StoryboardNames.newDesing, bundle: nil).instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
                let vc = NotificationsVC.instace(sb: .newDesignV4)
                self.navigationController?.pushViewController(vc, animated: true)

    }

}

extension MyHistoryVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableDataSource?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyHistoryTBCell", for: indexPath) as! MyHistoryTBCell
        let history = tableDataSource?[indexPath.row]
        
        //"yyyy-MM-dd'T'HH:mm:ss.zzz"
        
//        let dateFormatterPrint = DateFormatter()
//        dateFormatterPrint.dateFormat = "dd/MM/yyyy HH:mm:ss a"
       // "By " + (contactUsVICArray[indexPath.row].authorname + "on " + contactUsVICArray[indexPath.row].notedateWithFormat)
        
        cell.subjectLb.text = history?.subject
        let noteDate = dateFormatter(dateStr: (history?.notedate ?? ""), currentFormate: "yyyy-MM-dd'T'HH:mm:ss.SSS", requiredFormate: "dd/MM/yyyy HH:mm:ss a") ?? ""
     //   print("Note Date :- \(noteDate)")
      cell.authorNameLb.text =  "By " + (history?.authorname ?? "")
       // cell.authorNameLb.text =  "By " + (history?.authorname ?? "") + " on " + noteDate
        cell.bodyLb.text = history?.body
        return cell
    }
    
    
}
struct MyNotesStruct : Codable
{
    var authorname : String?
    var body : String?
    var notedate : String?
    var noteId : Int?
    var replies : [MyNotesStruct]?
    var replyTo : ReplyTo?
    var subject : String?
    var byclient : Bool?
    
    enum CodingKeys : String, CodingKey
    {
        case authorname = "unknownAuthor"
        case body, noteId, replies, replyTo, subject, byclient
        case notedate = "activityDate"
        
    }
    var date : Date
    {
        return notedate?.components(separatedBy: ".").first?.getDate() ?? Date()
    }
    
    struct ReplyTo : Codable
    {
        let noteId : Int?
    }
        
}
