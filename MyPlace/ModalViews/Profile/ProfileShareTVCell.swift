//
//  ProfileShareTVCell.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 06/07/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit



class ProfileShareTVCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var lBCount: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var lBTitle: UILabel!
    @IBOutlet weak var btnArrow: UIButton!
    
    
    @IBOutlet weak var lBLine: UILabel!
    
    
    
    
    @IBOutlet weak var btnShare: UIButton!
    
    @IBOutlet weak var labelShareHeading: UILabel!
    @IBOutlet weak var txtShareEmail: UITextField!
    
    
    @IBOutlet weak var topViewMaxHeight: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var tableViewShareUsers: UITableView!
    @IBOutlet weak var shareUsersHeight: NSLayoutConstraint!
    
    @IBOutlet weak var topSpaceTable: NSLayoutConstraint!
    @IBOutlet weak var bottomSpaceTable: NSLayoutConstraint!
    
    
    var favoriteAction: ((_ user: UserBean) -> Void)?
    var deleteAction: ((_ user: UserBean) -> Void)?
    
    var shareUserDetails: ((_ user: UserBean) -> Void)?
    
    
    let cellHeight: CGFloat = 40
    
    
    var userDetails: [UserBean]? {
        didSet {
            
//            lBCount.isHidden = userDetails!.count == 0

            lBCount.text = "\(userDetails!.count)"

            
            if cellHeight < 40 {
                shareUsersHeight.constant = 40.0 * CGFloat(userDetails!.count)
            }else {
                shareUsersHeight.constant = cellHeight * CGFloat(userDetails!.count)
            }
            
            tableViewShareUsers.reloadData ()
            
            
            if userDetails!.count == 0 {
                
                topSpaceTable.constant = -10
                bottomSpaceTable.constant = 0
                tableViewShareUsers.isHidden = true
            }else {
                
                topSpaceTable.constant = 10
                bottomSpaceTable.constant = 10
                tableViewShareUsers.isHidden = false
            }
            
            
//            if userDetails!.count > 3 {
//                //                topViewMaxHeight.constant = 0
//
//                txtShareEmail.isUserInteractionEnabled = false
//                txtShareEmail.backgroundColor = COLOR_LIGHT_GRAY
//
//                btnShare.isEnabled = false
//                btnShare.alpha = 0.4
//            }else {
                
                txtShareEmail.isUserInteractionEnabled = true
                txtShareEmail.backgroundColor = COLOR_WHITE
                
                btnShare.isEnabled = true
                btnShare.alpha = 1.0
//            }
        }
    }
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setAppearanceFor(view: lBCount, backgroundColor: COLOR_BLACK, textColor: COLOR_WHITE, textFont: FONT_LABEL_SUB_HEADING(size: FONT_8))
        setAppearanceFor(view: lBTitle, backgroundColor: COLOR_CLEAR, textColor: COLOR_WHITE, textFont: FONT_LABEL_SUB_HEADING (size: FONT_14))
        setAppearanceFor(view: lBLine, backgroundColor: COLOR_ORANGE_LIGHT, textColor: COLOR_WHITE, textFont: FONT_LABEL_BODY(size: FONT_10))
        
        
        setAppearanceFor(view: labelShareHeading, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_LABEL_SUB_HEADING (size: FONT_12))
        
        setAppearanceFor(view: txtShareEmail, backgroundColor: COLOR_WHITE, textColor: COLOR_BLACK, textFont: FONT_TEXTFIELD_HEADING(size: FONT_12))
        
        setAppearanceFor(view: btnShare, backgroundColor: COLOR_ORANGE, textColor: COLOR_WHITE, textFont: FONT_BUTTON_BODY(size: FONT_14))
        
        
        setBorder(view: txtShareEmail, color: COLOR_LIGHT_GRAY, width: 1.0)
        txtShareEmail.layer.cornerRadius = radius_5 //5.0
        
        txtShareEmail.leftView = UIView.init(frame: CGRect (x: 0, y: 0, width: 10, height: txtShareEmail.frame.size.height))
        txtShareEmail.leftViewMode = .always
        
        btnShare.layer.cornerRadius = radius_5 //5.0
        
        lBCount.layer.cornerRadius = lBCount.frame.size.height/2
        
        
        tableViewShareUsers.tableFooterView = UIView (frame: .zero)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
    @IBAction func handleShareButtonAction  (_ sender: UIButton) {
        
        CodeManager.sharedInstance.sendScreenName (burbank_profile_shareAccount_share_button_touch)
        
        
        let email = txtShareEmail.text?.trim() ?? ""
        
        if email == "" {
            
            ActivityManager.showToast ("Please enter email")
            
            //                   showAlert("Please enter email")
            return
        }else if email.isValidEmail() == false {
            
            ActivityManager.showToast ("Please enter valid email")
            
            //                   showAlert("Please enter valid email")
            return
        }else if email == appDelegate.userData?.user?.userEmail {
            
            ActivityManager.showToast ("Sharing email should not be your own")
            
            return
        }
        
        
        var canGoNext = true
        
        for userExists in self.userDetails! {
            if email == userExists.userEmail {
                canGoNext = false
                break
            }
        }
        
        if canGoNext {
            
            checkEmailExists(email)
        }else {
            ActivityManager.showToast ("Email already exists")
        }
    }
    
    
    @IBAction func handleDeleteButtonAction (_ sender: UIButton) {
        
        CodeManager.sharedInstance.sendScreenName(burbank_profile_shareAccount_delete_button_touch)
        
        let user = self.userDetails![sender.tag]
        
        
        if let delete = deleteAction {
            
            alert.showAlert("Delete", "Are you sure want to delete?", kWindow.rootViewController!, ["No", "Yes"]) { (str) in
                
                if str == "Yes" {
                    
                    delete (user)
                }
                
            }
            
        }
    }
    
    
    @IBAction func handleFavoriteButtonAction (_ sender: UIButton) {
        
        let user = self.userDetails![sender.tag]
        
        if user.userDetails?.invitationStatus == 1 {
            
            return
        }
        
        //        if user.userDetails?.invitationStatus == 1 {
        //
        //            ActivityManager.showToast ("\(user.userEmail ?? "") has to accept the invitaion")
        //            return
        //        }
        
        if let favourite = favoriteAction {
            
            if user.userDetails?.favorite == true {
                
                alert.showAlert("Favourite", "\(user.userFirstName ?? "user")'s favourite will not appear, OK?", kWindow.rootViewController!, ["No", "Yes"]) { (str) in
                    
                    if str == "Yes" {
                        favourite (user)
                    }
                }
            }else {
                
                alert.showAlert("Favourite", "\(user.userFirstName ?? "user")'s favourites will be added, OK?", kWindow.rootViewController!, ["No", "Yes"]) { (str) in
                    
                    if str == "Yes" {
                        favourite (user)
                    }
                }
                
            }
        }
        
    }
    
    
    
    
    //MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let users = userDetails {
            return users.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShareUserCell", for: indexPath) as! ShareUserCell
        
        cell.user = userDetails![indexPath.row]
        
        cell.btnFavorite.tag = indexPath.row
        cell.btnDelete.tag = indexPath.row
        
        cell.btnFavorite.addTarget(self, action: #selector(handleFavoriteButtonAction(_:)), for: .touchUpInside)
        cell.btnDelete.addTarget(self, action: #selector(handleDeleteButtonAction(_:)), for: .touchUpInside)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    
    
    
    //MARK: - APIs
    
    
    func checkEmailExists (_ email: String) {
        
        let _ = Networking.shared.POST_request(url: ServiceAPI.shared.URL_checkUserExistsForShare (email), parameters: NSDictionary(), userInfo: nil, success: { (json, response) in
            
            if let result: AnyObject = json {
                
                let result = result as! NSDictionary
                                
                if status (result) == true {
                    
                    let userShare = UserBean()
                    userShare.userEmail = email
                    
                    let userValues: NSDictionary = result.value(forKey: "CheckEmailstatus") as! NSDictionary
                    
                    userShare.userFirstName = String.checkNullValue (userValues.value(forKey: "FullName") as Any)
                    
                    let profile = String.checkNullValue(userValues.value(forKey: "ProfilePic") as Any)
                    
                    if profile == "No Image" {
                        userShare.userProfileImageURL = ""
                    }else {
                        userShare.userProfileImageURL = profile
                    }
                    
                    if let share = self.shareUserDetails {
                        share (userShare)
                    }
                    
                }else {
                    
                    if String.checkNullValue (result.value(forKey: "message") as Any).count > 0 {
                        ActivityManager.showToast (String.checkNullValue (result.value(forKey: "message") as Any))
                    }else {
                        ActivityManager.showToast("Email doesn't Exists")
                    }
                }
            }else {
                
            }
            
        }, errorblock: { (error, isJSONerror)  in
            
            if isJSONerror {
                
            }else {
                
            }
            
        }, progress: nil)
        
        
    }
    
}



//let pendingIcon = UIImage (named: "Ico-Pending")

let pendingIcon = UIImage (named: "Ico-Waiting")

let deleteIcon = UIImage (named: "Ico-delete")
let unfavoriteIcon = UIImage (named: "Ico-heartGrey")
let favoriteIcon = UIImage (named: "Ico-heartOrange")


class ShareUserCell: UITableViewCell {
    
    
    @IBOutlet var labelUserEmail: UILabel!
    
    @IBOutlet var btnFavorite: UIButton!
    @IBOutlet var btnDelete: UIButton!
    
    @IBOutlet var favHeight: NSLayoutConstraint!
    @IBOutlet var deleteHeight: NSLayoutConstraint!
    
    
    var user: UserBean? {
        didSet {
            fillDetails()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setAppearanceFor(view: labelUserEmail, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_LABEL_SUB_HEADING (size: FONT_12))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func fillDetails () {
        
        let status = user?.userDetails?.invitationStatus == 1 ? "( Pending )" : "( Accepted )"
        let namestr = (user?.userFirstName ?? "") + " " + status
        let str = (user?.userEmail ?? "") + "\n" + namestr

        
        labelUserEmail.text = str
        
        _ = setAttributetitleFor(view: labelUserEmail, title: str, rangeStrings: [(user?.userEmail ?? ""), (user?.userFirstName ?? "") + " ", status], colors: [COLOR_BLACK, COLOR_BLACK, COLOR_BLACK], fonts: [FONT_LABEL_SUB_HEADING (size: FONT_12), FONT_LABEL_BODY (size: FONT_9), FONT_LABEL_LIGHT (size: FONT_9)], alignmentCenter: false)
        
        
        btnDelete.setImage(deleteIcon, for: .normal)
        
        if user?.userDetails?.favorite == true {
            btnFavorite.setImage(favoriteIcon, for: .normal)
        }else {
            btnFavorite.setImage(unfavoriteIcon, for: .normal)
        }
        
        
        if user?.userDetails?.invitationStatus == 1 {
            
            btnFavorite.setImage(pendingIcon, for: .normal)
        }else {
            
        }
    }
    
}
