//
//  CoBurbankVC.swift
//  BurbankApp
//
//  Created by Naveen Kourampalli on 04/04/22.
//  Copyright © 2022 DMSS. All rights reserved.
//


import UIKit

class CoBurbankVC: BurbankAppVC,UITableViewDataSource,UITableViewDelegate
{
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var listTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var inviteFriendPopUp: UIControl!
    @IBOutlet weak var inviteFriendEmailTextField: UITextField!
    @IBOutlet weak var inviteButton: UIButton!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var CELLHEIGHT: CGFloat = SCREEN_HEIGHT * 0.145//65.0
    var HEADERHEIGHT: CGFloat = SCREEN_HEIGHT * 0.09
    let MAXHEIGHT: CGFloat = 40 + SCREEN_HEIGHT * 0.05 + 5
    var coBurbankList = [CoBurbankUserList]()
    var coBurbankDataJson = CoBurbankData()
    
    var isPrimaryApplicant = true
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        listTableView.dataSource = self
        listTableView.delegate = self
        listTableView.isScrollEnabled = false
        listTableViewHeightConstraint.constant = 0
        
        inviteButton.alpha = 0
        getCoBurbankList()
        setUpInviteFriendView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBarButtons(title: "Share with partners", backButton: true, notificationIcon: false)
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
    }
    func setUpInviteFriendView()
    {
        inviteFriendPopUp.alpha = 0
        inviteFriendPopUp.backgroundColor = UIColor.black.withAlphaComponent(0.65)
        self.view.bringSubviewToFront(inviteFriendPopUp)
    }
    func setUpInviteButton()
    {
        let user = appDelegate.currentUser
        if coBurbankList.count >= 5
        {
            inviteButton.alpha = 0
        }else
        {
            if isPrimary() //user.userDetails[0].isPrimary()
            {
                inviteButton.setTitle("Invite", for: .normal)
            }else
            {
                inviteButton.setTitle("Refer", for: .normal)
            }
            UIView.animate(withDuration: 0.5, animations: {
                self.inviteButton.alpha = 1.0
            })
        }
        
    }
    private func isPrimary() -> Bool
    {
        var isPrimary = false
        let user = appDelegate.currentUser
        let primaryEmail = user?.userDetailsArray?[0].primaryEmail
        coBurbankList.forEach { (coBurbankUser) in
            //
            if coBurbankUser.Email == primaryEmail
            {
                isPrimary =  coBurbankUser.PrimaryApplicant!
            }
        }
        
        return isPrimary
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func ReloadList()
    {
        let height = CELLHEIGHT  * CGFloat(coBurbankList.count + 1)
        listTableViewHeightConstraint.constant = CELLHEIGHT  * CGFloat(coBurbankList.count) + HEADERHEIGHT
        listTableView.reloadData()
    }
    func getCoBurbankList()
    {
        let user = appDelegate.currentUser
        if let jobNumber = user?.userDetailsArray?[0].myPlaceDetailsArray[0].jobNumber,let userID = user?.userDetailsArray?[0].myPlaceDetailsArray[0].userId
        {
            let postDic = ["JobNumber": jobNumber,"UserId":userID] as [String : Any]
//            ServiceSession.shared.callToPostDataToServerWithGivenURLString(urlString: getCoBurbankListURL, postBodyDictionary: postDic) { (json) in
//                //
//                let jsonDic = json as! NSDictionary
//                #if DEDEBUG
//                print(jsonDic)
//                #endif
//                if let status = jsonDic.object(forKey: "Status") as? Bool {
//
//                    if status == true
//                    {
//                        if let resultArray = jsonDic.object(forKey: "Result") as? NSArray
//                        {
//                            self.loadBurbankListAndShow(resultArray)
//                        }
//                    }
//
//                }
//            }
            
            
            NetworkRequest.makeRequest(type: CoBurbankData.self, urlRequest: Router.getCoBurbankInfo(parameters: postDic)) { [weak self](result) in
                switch result
                {
                case .success(let data):
                    print(data)
                    if data.Status ?? false{
                        self?.loadBurbankListAndShow(data.Result ?? [])
                        
                    }
                    else {
                        debugPrint("status")
                    }
                        
                   // self?.setupAppointments(progressData: data)
                    
                case.failure(let err):
                    print(err.localizedDescription)
                    DispatchQueue.main.async {
                        self?.showAlert(message: err.localizedDescription)
                    }
                }
            }


        }
    }
    func loadBurbankListAndShow(_ resultArray: [CoBurbankUserList])
    {
        coBurbankList.removeAll()
        if resultArray.count == 0
        {
            self.ReloadList()
            return
        }
        for resultDicObj in resultArray
        {

            self.coBurbankList.append(resultDicObj)
        }
        self.setUpInviteButton()
        self.ReloadList()
        
    }
    var isCanReInvite = false
    let REINVITETAG = 345
    var invitationTag = 0
    @IBAction func inviteOrReInviteButtonTapped(sender: AnyObject) {
        let inviteButton = sender as! UIButton
        let coBurbankUser = coBurbankList[inviteButton.tag]
        invitationTag = inviteButton.tag
//
//        if let email = coBurbankUser.email, let jobNumber = coBurbankUser.jobNumber, let userId = coBurbankUser.userId
//        {
//            let postDic = ["Email":email,"JobNumber": jobNumber,"UserId":userId] as! NSDictionary
//            ServiceSession.shared.callToPostDataToServerWithGivenURLString(urlString: sendInvitationURL, postBodyDictionary: postDic) { (json) in
//                let jsonDic = json as! NSDictionary
//                print(jsonDic)
//                if let status = jsonDic.object(forKey: "Status") as? Bool {
//
//                    if status == true
//                    {
//                        if let resultArray = jsonDic.object(forKey: "Result") as? NSArray
//                        {
//                            self.loadBurbankListAndShow(resultArray)
//                        }
//                    }
//                }
//            }
//        }
        showInviteFriendPopUp()
        inviteFriendEmailTextField.text = coBurbankUser.Email
        if inviteButton.titleLabel?.text == "Re-Invite"
        {
            inviteFriendEmailTextField.isUserInteractionEnabled = false
        }
        inviteFriendEmailTextField.tag = REINVITETAG
        isCanReInvite = coBurbankUser.CanReInvite!
    }
    @IBAction func deleteButtonTapped(sender: AnyObject) {
        let deleteButton = sender as! UIButton
        let coBurbankUser = coBurbankList[deleteButton.tag]
      //  let message = String(format: "Are You sure want to delete %@", coBurbankUser.Email!)
        let deleteAlert = UIAlertController(title: "Alert", message: "Are You sure want to delete", preferredStyle: .alert)
        deleteAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        deleteAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.deletCoBurbankUser(coBurbankUser)
        }))
        
        self.present(deleteAlert, animated: true, completion: nil)
        
    }
    func deletCoBurbankUser(_ coBurbankUser: CoBurbankUserList)
    {
        
    //    CodeManager.sharedInstance.sendScreenName(more_features_sharewith_partner_delete_button_touch)
        
        
        if let email = coBurbankUser.Email, let jobNumber = coBurbankUser.JobNumber, let userId = coBurbankUser.UserId, let isCoBurbank = coBurbankUser.CoBurbank, let primaryUserId = appDelegate.currentUser?.userDetailsArray?[0].myPlaceDetailsArray[0].userId
        {
            let postDic = ["Email":email, "JobNumber": jobNumber, "UserId":userId, "CoBurbank":isCoBurbank, "DeletedByUserId":primaryUserId] as NSDictionary
//            ServiceSession.shared.callToPostDataToServerWithGivenURLString(urlString: deleteInvitationURL, postBodyDictionary: postDic) { (json) in
//                let jsonDic = json as! NSDictionary
//                #if DEDEBUG
//                print(jsonDic)
//                #endif
//                if let status = jsonDic.object(forKey: "Status") as? Bool {
//
//                    if status == true
//                    {
//                        if let resultArray = jsonDic.object(forKey: "Result") as? NSArray
//                        {
//                            self.loadBurbankListAndShow(resultArray)
//                        }
//                    }
//                }
//            }
            
            
            
            NetworkRequest.makeRequest(type: CoBurbankData.self, urlRequest: Router.deleteInvitationCoBurbank(parameters: postDic as! Parameters)) { [weak self](result) in
                switch result
                {
                case .success(let data):
                    print(data)
                    if data.Status ?? false{
                        self?.loadBurbankListAndShow(data.Result ?? [])
//                        self?.coBurbankList = data.Result ?? []
                    }
                        
                   // self?.setupAppointments(progressData: data)
                    
                case.failure(let err):
                    print(err.localizedDescription)
                    DispatchQueue.main.async {
                        self?.showAlert(message: err.localizedDescription)
                    }
                }
            }
        }
        else {
            print("nil values found")
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    // MARK: - DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return coBurbankList.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return HEADERHEIGHT
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderID") as! CoBurbankTVHeaderCell
        let user = appDelegate.currentUser
        if let jobNumber = user?.userDetailsArray?[0].myPlaceDetailsArray[0].jobNumber
        {
            cell.jobNumberTextFiled.text = jobNumber
        }
        return cell
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CoBurbankTVCell", for: indexPath) as! CoBurbankTVCell
            let coBurbankUser = coBurbankList[indexPath.row]
           // cell.nameLabel.text = coBurbankUser.name
            let nameText = NSMutableAttributedString()
            if let name = coBurbankUser.Name //&& coBurbankUser.statusMessage != ""
            {
              //  cell.statusMessageLabelBottomConstraint.constant = 8
                nameText.append(NSMutableAttributedString(string: "\(name)", attributes: [NSAttributedString.Key.font: ProximaNovaRegular(size: 16.0)]))
            }
            
            if let email = coBurbankUser.Email
            {
                if nameText.string.count > 0 {
                    nameText.append(NSMutableAttributedString(string: "\n", attributes: [NSAttributedString.Key.font: ProximaNovaRegular(size: 13.0)]))
                }
                nameText.append(NSMutableAttributedString(string: "\(email)", attributes: [NSAttributedString.Key.font: ProximaNovaRegular(size: 13.0)]))
              //  cell.contactDetailsLabel.text = String(format: "%@", email)
            }
    //        cell.statusMessage.numberOfLines = 3
            //cell.statusMessage.text = coBurbankUser.statusMessage
            if let sta = coBurbankUser.StatusMessage {
                if sta.count > 0 {
                    if nameText.string.count > 0 {
                        nameText.append(NSMutableAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font: ProximaNovaRegular(size: 13.0)]))
                    }
                    nameText.append(NSMutableAttributedString(string: "\(sta)", attributes: [NSAttributedString.Key.font: ProximaNovaRegular(size: 11.0)]))
                }else {
                    nameText.append(NSMutableAttributedString(string: "\n", attributes: [NSAttributedString.Key.font: ProximaNovaRegular(size: 13.0)]))
                }
            }else{
                nameText.append(NSMutableAttributedString(string: "\n", attributes: [NSAttributedString.Key.font: ProximaNovaRegular(size: 13.0)]))
            }
            
            cell.nameLabel.attributedText = nameText
            cell.statusButton.tag = indexPath.row
            if let dele = cell.deleteButton {
                dele.tag = indexPath.row
            }
            cell.statusButton.isUserInteractionEnabled = false
            cell.statusButton.titleLabel?.font = ProximaNovaRegular(size: 12.0)
            
            if let dele = cell.deleteButton {
                dele.titleLabel?.font = ProximaNovaRegular(size: 12.0)
            }

            
            if coBurbankUser.PrimaryApplicant == true
            {
                cell.statusButton.setTitle("   Primary Applicant   ", for: .normal)
                cell.statusButton.titleLabel?.font = ProximaNovaRegular(size: 14.0)
            }
            
            if coBurbankUser.CoBurbank == true
            {
                cell.statusButton.setTitle("   Partner   ", for: .normal)
                cell.statusButton.titleLabel?.font = ProximaNovaRegular(size: 12.0)
            }
            if coBurbankUser.Referred == true
            {
                cell.statusButton.setTitle("   Referred   ", for: .normal)
            }
            if coBurbankUser.Rejected == true
            {
                cell.statusButton.setTitle("   Rejected   ", for: .normal)
            }
            if coBurbankUser.Invited == true
            {
                cell.statusButton.setTitle("   Invited   ", for: .normal)
            }
            

            if coBurbankUser.CanReject == true
            {
                cell.statusButton.setTitle("   Reject   ", for: .normal)
                cell.statusButton.backgroundColor = UIColor.orangeBurBankColor()
                cell.statusButton.isUserInteractionEnabled = true

            }
            if coBurbankUser.CanInvite == true
            {
                cell.statusButton.setTitle("   Invite   ", for: .normal)
                cell.statusButton.backgroundColor = UIColor.orangeBurBankColor()
                cell.statusButton.isUserInteractionEnabled = true

            }
            if coBurbankUser.CanReInvite == true
            {
                let str = "   Re-Invite   "
                
                cell.statusButton.setTitle(str, for: .normal)
                cell.statusButton.backgroundColor = UIColor.orangeBurBankColor()
                cell.statusButton.isUserInteractionEnabled = true
                
                cell.statusButton.superview?.layoutIfNeeded()

            }
            
            
            
            if coBurbankUser.CanDelete == true
            {
                cell.deleteButton.isHidden = false
             //   cell.deleteButton.setTitle("Delete", for: .normal)
                
                cell.btnStatus.isHidden = true

            }else
            {
                cell.statusButton.superview?.isHidden = true
                
                cell.btnStatus.isHidden = false
                
                cell.btnStatus.setTitle(cell.statusButton.title(for: .normal), for: .normal)
                
    //            cell.Stackheight.constant = (50/2) - (5/2)

    //            if let dele = cell.deleteButton {
    //                dele.removeFromSuperview()
    //                dele.alpha = 0
    //            }
                
    //            cell.statusButton.superview?.constraints.forEach({ (constraint) in
    //                if constraint.identifier == "heightID"
    //                {
    //                    constraint.constant = -100
    //                }
    //            })
            }
            
            cell.nameLabel.layoutIfNeeded()

            cell.layoutIfNeeded()
            
            
            return cell
            
        
        
        
        
        
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CoBurbankTVCell", for: indexPath) as! CoBurbankTVCell
//        let coBurbankUser = coBurbankList[indexPath.row]
//       // cell.nameLabel.text = coBurbankUser.name
//        let nameText = NSMutableAttributedString()
//        if let name = coBurbankUser.Name //&& coBurbankUser.statusMessage != ""
//        {
//          //  cell.statusMessageLabelBottomConstraint.constant = 8
//            nameText.append(NSMutableAttributedString(string: "\(name)\n", attributes: [NSAttributedString.Key.font: ProximaNovaRegular(size: 14)]))
//        }
//
//        if let email = coBurbankUser.Email
//        {
//            nameText.append(NSMutableAttributedString(string: "\(email)\n", attributes: [NSAttributedString.Key.font: ProximaNovaRegular(size: 12)]))
//          //  cell.contactDetailsLabel.text = String(format: "%@", email)
//        }
////        cell.statusMessage.numberOfLines = 3
//        //cell.statusMessage.text = coBurbankUser.statusMessage
//        nameText.append(NSMutableAttributedString(string: "\n\(coBurbankUser.StatusMessage ?? "")", attributes: [NSAttributedString.Key.font: ProximaNovaRegular(size: 12)]))
//        cell.nameLabel.attributedText = nameText
//        cell.statusButton.tag = indexPath.row
//        cell.deleteButton.tag = indexPath.row
//        cell.statusButton.isUserInteractionEnabled = false
//       // cell.reInviteBTN.alpha = 0.0
//        cell.statusButton.titleLabel?.font = ProximaNovaRegular(size: 12.0)
//        cell.deleteButton.titleLabel?.font = ProximaNovaRegular(size: 12.0)
//        if coBurbankUser.PrimaryApplicant == true
//        {
//            cell.statusButton.setTitle("Primary Applicant", for: .normal)
//            cell.statusButton.titleLabel?.font = ProximaNovaRegular(size: 12.0)
//        }
//        if coBurbankUser.CoBurbank == true
//        {
//            cell.statusButton.setTitle("Partner", for: .normal)
//            cell.statusButton.titleLabel?.font = ProximaNovaRegular(size: 12.0)
//        }
//        if coBurbankUser.Referred == true
//        {
//            cell.statusButton.setTitle("Referred", for: .normal)
//        }
//        if coBurbankUser.Rejected == true
//        {
//            cell.statusButton.setTitle("Rejected", for: .normal)
//        }
//        if coBurbankUser.Invited == true
//        {
//            cell.statusButton.setTitle("Invited", for: .normal)
//        }
//
//
//        if coBurbankUser.CanReject == true
//        {
//            cell.statusButton.setTitle("Reject", for: .normal)
//            cell.statusButton.backgroundColor = UIColor.orangeBurBankColor()
//            cell.statusButton.isUserInteractionEnabled = true
//
//        }
//        if coBurbankUser.CanInvite == true
//        {
//            cell.statusButton.setTitle("Invite", for: .normal)
//            cell.statusButton.backgroundColor = UIColor.orangeBurBankColor()
//            cell.statusButton.isUserInteractionEnabled = true
//
//        }
//        if coBurbankUser.CanReInvite == true
//        {
//            cell.statusButton.setTitle("Re-Invite", for: .normal)
//            cell.statusButton.backgroundColor = UIColor.orangeBurBankColor()
//            cell.statusButton.isUserInteractionEnabled = true
//
//        }
//        if coBurbankUser.CanDelete == true
//        {
//            cell.deleteButton.isHidden = false
//         //   cell.deleteButton.setTitle("Delete", for: .normal)
//        }else
//        {
//            cell.deleteButton.alpha = 0
////            cell.statusButton.superview?.constraints.forEach({ (constraint) in
////                if constraint.identifier == "heightID"
////                {
////                    constraint.constant = -100
////                }
////            })
//        }
//
//        return cell
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
//        let coBurbankUser = coBurbankList[indexPath.row]
//        // cell.nameLabel.text = coBurbankUser.name
//        var nameText = ""
////        if let name = coBurbankUser.name //&& coBurbankUser.statusMessage != ""
////        {
////            nameText.append("\(name)\n\n")
////        }
////        if let email = coBurbankUser.email
////        {
////            nameText.append("\(email)\n\n")
////        }
////        nameText.append(coBurbankUser.statusMessage ?? "")
//        return CELLHEIGHT //+ height - 10
        return UITableView.automaticDimension
    }
    // MARK: - Button Actions
    @IBAction func cancelButtonTapped(sender: AnyObject?)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func inviteButtonTapped(sender: AnyObject?)
    {
        inviteFriendEmailTextField.isUserInteractionEnabled = true
        showInviteFriendPopUp()
    }
    func showInviteFriendPopUp()
    {
        UIView.animate(withDuration: 0.5)
        {
            self.inviteFriendPopUp.alpha = 1.0
        }
        self.inviteFriendEmailTextField.text = ""
        self.inviteFriendEmailTextField.becomeFirstResponder()
    }
    @IBAction func inviteFriendCancelButtonTapped(sender: AnyObject?)
    {
        hideInviteFriendPopUp()
    }
    func hideInviteFriendPopUp()
    {
        UIView.animate(withDuration: 0.5)
        {
            self.inviteFriendPopUp.alpha = 0
        }
        inviteFriendEmailTextField.resignFirstResponder()
    }
    @IBAction func inviteFriendSubmitButtonTapped(sender: AnyObject?)
    {
        
        
        CodeManager.sharedInstance.sendScreenName(more_features_sharewith_partner_invite_button_touch)
        
        
        let whitespaceSet = NSCharacterSet.whitespaces
        if inviteFriendEmailTextField.text?.trimmingCharacters(in: whitespaceSet) == "" {
            AlertManager.sharedInstance.alert("Please enter Valid email")
            inviteFriendEmailTextField.becomeFirstResponder()
            return
        }
        
        if inviteFriendEmailTextField.text == ""
        {
            AlertManager.sharedInstance.alert("Please enter email")
            inviteFriendEmailTextField.becomeFirstResponder()
            return
        }
        if CodeManager.sharedInstance.isValidEmail(testStr: inviteFriendEmailTextField.text!)
        {
            if inviteFriendEmailTextField.tag == REINVITETAG
            {
                callToSendInvitationService()
            }else
            {
                var isCoUserExsist = false
                coBurbankList.forEach({ (coUser) in
                    if coUser.Email == inviteFriendEmailTextField.text
                    {
                        if coUser.PrimaryApplicant == true
                        {
                            isCoUserExsist = true
                            AlertManager.sharedInstance.alert("Invitation cannot send to primary applicant.")
                        }else
                        {
                            isCoUserExsist = true
                            AlertManager.sharedInstance.alert("Already invited. Please check the status in the list")
                        }
                    }
                })
                if isCoUserExsist == false
                {
                    callAddCoBurbankService()
                }
            }
            
        }else
        {
            AlertManager.sharedInstance.showAlert(alertMessage: "Please Enter Valid Email", title: "")
            inviteFriendEmailTextField.becomeFirstResponder()
            return
        }
        
    }
    func callAddCoBurbankService()
    {
        let user = appDelegate.currentUser
        if let jobNumber = user?.userDetailsArray?[0].myPlaceDetailsArray[0].jobNumber,let userId = user?.userDetailsArray?[0].myPlaceDetailsArray[0].userId,let invitedEmail = inviteFriendEmailTextField.text
        {
            let canInvite = isCanReInvite
            let postDic = ["jobNumber": jobNumber,"UserId":userId,"InvitationToEmail":invitedEmail,"AddByPrimary": user?.userDetailsArray?[0].isPrimary() ?? false] as NSDictionary
//            ServiceSession.shared.callToPostDataToServerWithGivenURLString(urlString: addCoBurbankURL, postBodyDictionary: postDic, completionHandler: { (json) in
//                let jsonDic = json as! NSDictionary
//            //    print(jsonDic)
//                if let status = jsonDic.object(forKey: "Status") as? Bool {
//
//                    if status == true
//                    {
//                        if let resultArray = jsonDic.object(forKey: "Result") as? NSArray
//                        {
//                           self.handleResponse(resultArray)
//                        }
//                    }
//
//                }
//            })
            
            NetworkRequest.makeRequest(type: CoBurbankData.self, urlRequest: Router.addCoBurbankData(parameters: postDic as! Parameters)) { [weak self](result) in
                switch result
                {
                case .success(let data):
                    print(data)
                    if data.Status ?? false{
                        self?.handleResponse(data.Result ?? [])
//                        self?.coBurbankList = data.Result ?? []
                    }
                        
                   // self?.setupAppointments(progressData: data)
                    
                case.failure(let err):
                    print(err.localizedDescription)
                    DispatchQueue.main.async {
                        self?.showAlert(message: err.localizedDescription)
                    }
                }
            }

            
        }
        
    }
    func handleResponse(_ resultArray: [CoBurbankUserList])
    {
        self.loadBurbankListAndShow(resultArray)
        self.hideInviteFriendPopUp()
        #if DEDEBUG
        print(self.coBurbankList.count)
        #endif
    }
    func callToSendInvitationService()
    {
        let coBurbankUser = coBurbankList[invitationTag]
        let primaryUser = coBurbankList[0]
        if let email = coBurbankUser.Email, let jobNumber = coBurbankUser.JobNumber, let userId = primaryUser.UserId
        {
            let canInvite = isCanReInvite
            let postDic = ["Email":email,"JobNumber": jobNumber,"UserId":userId,"CanReInvite": isCanReInvite] as NSDictionary
//            ServiceSession.shared.callToPostDataToServerWithGivenURLString(urlString: sendInvitationURL, postBodyDictionary: postDic) { (json) in
//                let jsonDic = json as! NSDictionary
//
//                #if DEDEBUG
//                print(jsonDic)
//                #endif
//
//                if let status = jsonDic.object(forKey: "Status") as? Bool {
//
//                    if status == true
//                    {
//                        if let resultArray = jsonDic.object(forKey: "Result") as? NSArray
//                        {
//                            self.handleResponse(resultArray)
//                        }
//                    }
//                }
//            }
            
            
            
            
            NetworkRequest.makeRequest(type: CoBurbankData.self, urlRequest: Router.sendInvitationCoBurbank(parameters: postDic as! Parameters)) { [weak self](result) in
                switch result
                {
                case .success(let data):
                    print(data)
                    if data.Status ?? false{
                        self?.handleResponse(data.Result ?? [])
//                        self?.coBurbankList = data.Result ?? []
                    }
                        
                   // self?.setupAppointments(progressData: data)
                    
                case.failure(let err):
                    print(err.localizedDescription)
                    DispatchQueue.main.async {
                        self?.showAlert(message: err.localizedDescription)
                    }
                }
            }
            
        }
    }
}


struct CoBurbankData : Codable{
    var Status : Bool?
    var Result : [CoBurbankUserList]?
}

struct CoBurbankUserList: Codable
{
    
    var PrimaryApplicant: Bool?
    var CoBurbank: Bool?
    
    var Email: String?
    var UserId: Int?
    var JobNumber: String?
    var Mobile: String?
    var Name: String?
    //var primaryAcceptance: String?
    var Referred: Bool?
    var Rejected: Bool?
    var Invited: Bool?
    
    var CanDelete : Bool?
    var CanInvite: Bool?
    var CanReject: Bool?
    var CanReInvite: Bool?

    var StatusMessage: String?
    
//    init(dic: [String: Any]?)
//    {
//        primaryApplicant = dic?["PrimaryApplicant"] as? Bool
//        coBurbank =  dic?["CoBurbank"] as? Bool //CoBurbank
//
//        email = NSString.checkNullValue(dic?["Email"] as? String)  //dic?["Email"] as? String
//        userId =  dic?["UserId"] as? Int
//        jobNumber = NSString.checkNullValue(dic?["JobNumber"] as? String) //dic?["JobNumber"] as? String
//        mobile = NSString.checkNullValue(dic?["Mobile"] as? String)//dic?["Mobile"] as? String
//        name = dic?["Name"] as? String
//
//        reffered = dic?["Referred"] as? Bool
//        rejected =  dic?["Rejected"] as? Bool
//        invited = dic?["Invited"] as? Bool
//
//        canDelete =  dic?["CanDelete"] as? Bool
//        canInvite =  dic?["CanInvite"] as? Bool
//        canReject =  dic?["CanReject"] as? Bool
//        canReInvite =  dic?["CanReInvite"] as? Bool
//
//        statusMessage = NSString.checkNullValue(dic?["StatusMessage"] as? String)//dic?["StatusMessage"] as? String
//    }
}

