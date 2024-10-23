//
//  JobInvitationsVC.swift
//  BurbankApp
//
//  Created by dmss on 15/06/17.
//  Copyright © 2017 DMSS. All rights reserved.
//

import UIKit
protocol jobInvitationsProtocol
{
    func hideInvitationView()
    func updateUserProfile()
}
class JobInvitationsVC: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var delegate: jobInvitationsProtocol?
    @IBOutlet weak var invitationsTableView: UITableView!
    @IBOutlet weak var invitationsViewHeightConstrint: NSLayoutConstraint!
    @IBOutlet weak var noInvitationInfoLabel: UILabel!
    //@IBOutlet weak var
    let appDelegate = UIApplication.shared.delegate as!AppDelegate
    let CELLHEIGHT = SCREEN_HEIGHT * 0.1
    var coBurbankList = [CoBurbankUser]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.65)
        invitationsTableView.dataSource = self
        invitationsTableView.delegate = self
        
        invitationsViewHeightConstrint.constant =  0 //1 * CELLHEIGHT + 32
        noInvitationInfoLabel.isHidden = true

        callGetInvitationsService()
        
        
        setAppearanceFor(view: noInvitationInfoLabel, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_BODY(size: FONT_15))
        invitationsTableView.tableFooterView = UIView.init(frame: .zero)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func reloadList()
    {
        invitationsTableView.isScrollEnabled = true
        
//        invitationsViewHeightConstrint.constant = coBurbankList.count == 0 ? (invitationsTableView.frame.origin.y + invitationsTableView.frame.size.height + 40)  :  CGFloat(coBurbankList.count) * CELLHEIGHT + 40 + 50
        
        if coBurbankList.count == 0
        {
            noInvitationInfoLabel.isHidden = false
            invitationsTableView.isHidden = true
            
            invitationsViewHeightConstrint.constant = 40 + 35 + 20

            return
        }
        
        invitationsTableView.reloadData()
        invitationsTableView.layoutIfNeeded()
        
//        if invitationsTableView.contentSize.height > invitationsTableView.frame.size.height {
            invitationsViewHeightConstrint.constant = invitationsTableView.contentSize.height + 40 + 20
//        }else {
//            invitationsViewHeightConstrint.constant = invitationsTableView.frame.origin.y + invitationsTableView.frame.size.height
//        }
        
        print(invitationsTableView.contentSize.height)
        
        invitationsTableView.isScrollEnabled = false

    }
    
    
    //Getting invitations from service
    func callGetInvitationsService()
    {
        let user = appDelegate.currentUser
        if let email = user?.userDetailsArray?[0].primaryEmail
        {            
            let postDic = ["Email":email] as NSDictionary
            ServiceSession.shared.callToPostDataToServerWithGivenURLString(urlString: getCoBurbankInvitationsListURL, postBodyDictionary: postDic) { (json) in
                let jsonDic = json as! NSDictionary
                #if DEDEBUG
                print(jsonDic)
                #endif
                
                if let status = jsonDic.object(forKey: "Status") as? Bool {
                    
                    if status == true
                    {
                        if let resultArray = jsonDic.object(forKey: "Result") as? NSArray
                        {
                            self.loadBurbankListAndShow(resultArray)
                        }
                    }
                }
            }
        }
        
    }
    func loadBurbankListAndShow(_ resultArray: NSArray)
    {
        self.coBurbankList.removeAll()
        if resultArray.count == 0
        {
            self.reloadList()
            return
        }
        for resultDicObj in resultArray
        {
            let resultDic = resultDicObj as! [String: Any]
            let coBurbankUser = CoBurbankUser(dic: resultDic)
            var isJobNumberAlreadyExist = false
            appDelegate.currentUser?.userDetailsArray?[0].myPlaceDetailsArray.forEach({ (myplaceDetails) in
                if myplaceDetails.jobNumber == coBurbankUser.jobNumber
                {
                    isJobNumberAlreadyExist = true
                }
            })
            if isJobNumberAlreadyExist == false
            {
                 self.coBurbankList.append(coBurbankUser)
            }
           
        }
        self.reloadList()
        #if DEDEBUG
        print(self.coBurbankList.count)
        #endif
    }

    @IBAction func cancelButtonTapped(sender: AnyObject?)
    {
        delegate?.hideInvitationView()
    }
    
    @IBAction func statusButtonTapped(sender: AnyObject) {
        
        let acceptButton = sender as! UIButton
        let coBurbankUser = coBurbankList[acceptButton.tag]
        if let email = coBurbankUser.email, let jobNumber = coBurbankUser.jobNumber
        {
            let postDic = ["Email":email,"JobNumber": jobNumber] as NSDictionary
            ServiceSession.shared.callToPostDataToServerWithGivenURLString(urlString: acceptInvitationURL, postBodyDictionary: postDic) { (json) in
                let jsonDic = json as! NSDictionary
                #if DEDEBUG
                print(jsonDic)
                #endif
                if let status = jsonDic.object(forKey: "Status") as? Bool {
                    
                    if status == true
                    {
                        if let resultArray = jsonDic.object(forKey: "Result") as? NSArray
                        {
                            self.loadBurbankListAndShow(resultArray)
                            self.delegate?.updateUserProfile()
                        }
                    }
                }
            }
        }
        
    }
    @IBAction func rejectButtonTapped(sender: AnyObject) {
        
        let rejectButton = sender as! UIButton
        let coBurbankUser = coBurbankList[rejectButton.tag]
        if let email = coBurbankUser.email, let jobNumber = coBurbankUser.jobNumber
        {
            let postDic = ["Email":email,"JobNumber": jobNumber] as NSDictionary
            ServiceSession.shared.callToPostDataToServerWithGivenURLString(urlString: rejectInvitationURL, postBodyDictionary: postDic) { (json) in
                let jsonDic = json as! NSDictionary
                #if DEDEBUG
                print(jsonDic)
                #endif
                if let status = jsonDic.object(forKey: "Status") as? Bool {
                    
                    if status == true
                    {
                        if let resultArray = jsonDic.object(forKey: "Result") as? NSArray
                        {
                           self.loadBurbankListAndShow(resultArray)
                        }
                    }
                }
            }
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coBurbankList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) as! InvitationTVCell
        let coUser = coBurbankList[indexPath.row]
//        cell.statusMessage.numberOfLines = 0
        cell.statusButton.tag = indexPath.row
        cell.rejectButton.tag = indexPath.row
        cell.statusMessage.text = coUser.statusMessage
        
        setAppearanceFor(view: cell.statusButton, backgroundColor: APPCOLORS_3.Orange_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_SUB_HEADING(size: FONT_12))
        setAppearanceFor(view: cell.rejectButton, backgroundColor: APPCOLORS_3.BTN_DarkGray, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_SUB_HEADING(size: FONT_12))

        
        cell.partnerButton.isHidden = true
        
        cell.statusButton.isHidden = false
        cell.rejectButton.isHidden = false

        if coUser.coBurbank == true
        {
            cell.partnerButton.setTitle("Partner", for: .normal)
            
            setAppearanceFor(view: cell.partnerButton, backgroundColor: APPCOLORS_3.BTN_DarkGray, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_SUB_HEADING(size: FONT_14))
            
            cell.partnerButton.isHidden = false
            
            cell.statusButton.isHidden = true
            cell.rejectButton.isHidden = true

        }else
        {
            cell.statusButton.setTitle("Accept", for: .normal)
//            cell.rejectButton.isHidden = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return CELLHEIGHT
        return UITableView.automaticDimension
    }
    
}






class InvitationTVCell: UITableViewCell
{
    @IBOutlet weak var statusMessage: UILabel!
    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var statusButton: UIButton!

    @IBOutlet weak var partnerButton: UIButton!

    

}
