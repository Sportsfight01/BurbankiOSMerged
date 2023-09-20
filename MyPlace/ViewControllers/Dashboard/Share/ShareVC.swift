//
//  ShareVC.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 10/07/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit


let imageShareCheck = "Ico-CheckPopup"
let imageShareUnCheck = "Ico-UncheckPopup"


class ShareVC: UIViewController {
    
    
    //Share Popup
    @IBOutlet weak var sharePopupView: UIView!
    @IBOutlet weak var sharePopupUserImage: UIImageView!
    @IBOutlet weak var sharePopupheaderLabel: UILabel!
    @IBOutlet weak var sharePopuphelpLabel: UILabel!
    @IBOutlet weak var sharePopupNameLabel: UILabel!
    @IBOutlet weak var sharePopupEmailLabel: UILabel!
    @IBOutlet weak var sharePopupConfirmLabel: UILabel!
    @IBOutlet weak var sharePopupCheckBoxBtn: UIButton!
    @IBOutlet weak var sharePopupRejectBtn: UIButton!
    @IBOutlet weak var sharePopupAcceptBtn: UIButton!
    
    
    var invitations = [UserBean]()
    
    var shareToUser: UserBean?
    
    var closeShare: (() -> Void)?
    var showShare: (() -> Void)?
    var returnResponse: (() -> Void)?
    
    
    var agree: Bool = false
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        handleUISetup ()
    }
    
    
    //MARK: Share Popup
    
    func fillPopupDetails (_ shareUser: UserBean, shareToOthers: Bool = true) {
        
        self.shareToUser = shareUser
        
        if shareToOthers {
            self.sharePopupAcceptBtn.setTitle("Confirm", for: .normal)
            self.sharePopupRejectBtn.setTitle("Cancel", for: .normal)
            
        }else {
            self.sharePopupAcceptBtn.setTitle("Accept", for: .normal)
            self.sharePopupRejectBtn.setTitle("Reject", for: .normal)
        }
        
        self.sharePopupEmailLabel.text = self.shareToUser?.userEmail ?? ""
        self.sharePopupNameLabel.text = self.shareToUser?.userFirstName ?? ""
        
        self.sharePopupConfirmLabel.text = "I agree for sharing my favourites with \(self.shareToUser?.userFirstName ?? "user")"
        
        agree = false
        
        if agree == true {
            
            sharePopupCheckBoxBtn.setImage(UIImage(named: imageShareCheck), for: .normal)
        }else {
            
            sharePopupCheckBoxBtn.setImage(UIImage(named: imageShareUnCheck), for: .normal)
        }
        
        
        self.sharePopupUserImage.layer.cornerRadius = self.sharePopupUserImage.frame.size.height/2
        self.sharePopupUserImage.clipsToBounds = true
        self.sharePopupUserImage.contentMode = .scaleToFill
        
        
        if let imageURL = self.shareToUser?.userProfileImageURL {
            
            ImageDownloader.downloadImage(withUrl: ServiceAPI.shared.URL_imageUrl(imageURL), withFilePath: nil, with: { (image, success, error) in
                
                if success, let img = image {
                    
                    self.sharePopupUserImage.image = img
                }else {
                    
                    self.sharePopupUserImage.image = UIImage (named: "Ico-UserWithBG")
                }
                
            }, withProgress: nil)
            
        }
    }
    
    
    
    @IBAction func handleSharepopupBtnActions (_ sender : UIButton) {
        
        if sender == sharePopupCheckBoxBtn {
            
            agree = !agree
            
            sharePopupCheckBoxBtn.setImage(agree == true ? UIImage(named: imageShareCheck) : UIImage(named: imageShareUnCheck), for: .normal)
            
            return
            
        }else if sender == sharePopupAcceptBtn {
            
            if !agree {
                showToast("Please agree the sharing")
                return
            }
            
            if sharePopupAcceptBtn.title(for: .normal) ==  "Confirm" {
                
                self.sharing (NSDictionary (), checkForExistingUsers: true)
            }else {
                
                self.acceptSharing(self.shareToUser!)
            }
            
        }else {
            
            if sharePopupRejectBtn.title(for: .normal) == "Cancel" {
                
                closeShareView ()
                
            }else {
                
                self.rejectSharing(self.shareToUser!)
            }
        }
        
    }
    
    
    func closeShareView () {
        
        self.shareToUser = nil
        
        sharePopupCheckBoxBtn.setImage(UIImage(named: imageShareUnCheck), for: .normal)
        
        agree = false
        
        if let close = closeShare {
            close ()
        }
    }
    
    
    func checkForPendingInvitationsBeforeSharing () {
        
        for user in self.invitations {
            
            if user.userDetails?.invitationStatus == 1 && user.userDetails?.favorite == false, user.userEmail == self.shareToUser?.userEmail {
                
                self.shareToUser = user
                
                break
            }
        }
        
        self.acceptSharing(self.shareToUser!)
        
    }
    
    
    func checkForPendingInvitations () {
        
        var canClose = true
        
        for user in self.invitations {
            
            if user.userDetails?.invitationStatus == 1 && user.userDetails?.favorite == false {
                //pending
                if let open = showShare {
                    open ()
                }
                
                canClose = false
                break
            }
        }
        
        if canClose == true {
            closeShareView ()
        }
        
    }
    
    func handleUISetup () {
        
        setAppearanceFor(view: view, backgroundColor: APPCOLORS_3.Orange_BG)
        
        
        setAppearanceFor(view: sharePopupheaderLabel, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_SUB_HEADING(size: FONT_16))
        setAppearanceFor(view: sharePopupNameLabel, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_SUB_HEADING(size: FONT_15))
        setAppearanceFor(view: sharePopupEmailLabel, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont:  FONT_LABEL_BODY(size: FONT_14))
        setAppearanceFor(view: sharePopuphelpLabel, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont:  FONT_LABEL_BODY(size: FONT_14))
        setAppearanceFor(view: sharePopupConfirmLabel, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont:  FONT_LABEL_BODY(size: FONT_14))
        
        setAppearanceFor(view: sharePopupRejectBtn, backgroundColor: APPCOLORS_3.BTN_DarkGray, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_SUB_HEADING(size: FONT_16))
        setAppearanceFor(view: sharePopupAcceptBtn, backgroundColor: APPCOLORS_3.Orange_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_SUB_HEADING(size: FONT_16))
        
        sharePopupView.layer.cornerRadius = radius_10
        
        sharePopupRejectBtn.layer.cornerRadius = radius_5
        sharePopupAcceptBtn.layer.cornerRadius = radius_5
        
    }
    
}



extension ShareVC {
    
    func getInvitations () {
        
        self.sharing(NSDictionary ())
        
    }
    
    
    func acceptSharing (_ user: UserBean) {
        
        let params = NSMutableDictionary ()
        params.setValue(user.userEmail ?? "", forKey: "OthersEmail")
        params.setValue(true, forKey: "FavouriteAdded")
        params.setValue(1, forKey: "ShareAccount")
        
        
        for userExists in self.invitations {
            if user.userEmail?.lowercased() == userExists.userEmail?.lowercased() {
                params.setValue(2, forKey: "ShareAccount")
                break
            }
        }
        
        
        sharing(params)
    }
    
    func rejectSharing (_ user: UserBean) {
        
        let params = NSMutableDictionary ()
        params.setValue(user.userEmail ?? "", forKey: "OthersEmail")
        params.setValue(false, forKey: "FavouriteAdded")
        params.setValue(0, forKey: "ShareAccount")
        
        
        sharing(params)
    }
    
    
    func favoriteSharing (_ user: UserBean) {
        
        let params = NSMutableDictionary ()
        params.setValue(user.userEmail ?? "", forKey: "OthersEmail")
        params.setValue(user.userDetails?.favorite == true ? 1 : 0, forKey: "FavouriteAdded")
        params.setValue(2, forKey: "ShareAccount")
        
        
        sharing(params)
    }
    
    
    
    func sharing (_ params: NSDictionary, checkForExistingUsers: Bool = false) {
        
        _ = Networking.shared.POST_request(url: ServiceAPI.shared.URL_User_Share(kUserID), parameters: params, userInfo: nil, success: { (json, response) in
            
            if let result: AnyObject = json {
                
                let result = result as! NSDictionary
                
                if let dictResult = result.value(forKey: "SharedAccountList") as? NSDictionary {
                    
                    self.invitations.removeAll()
                    
                    if status (dictResult) == true {
                        
                        for us in dictResult.value(forKey: "sharedUserLists") as! [NSDictionary] {
                            
                            let userShare = UserBean()
                            
                            userShare.userFirstName = String.checkNullValue (us.value(forKey: "FullName") as Any)
                            userShare.userEmail = String.checkNullValue(us.value(forKey: "Email") as Any)
                            userShare.userDetails?.favorite = (us.object (forKey: "FavouriteAdded") as? Bool)!
                            userShare.userDetails?.invitationStatus = (us.value(forKey: "AcceptStatus") as? NSNumber ?? 0).intValue
                            
                            if userShare.userDetails?.invitationStatus == 0 {
                                //not adding
                            }else {
                                self.invitations.append(userShare)
                            }
                        }
                    }else {
                        
                    }
                    
                    appDelegate.userData?.user?.userDetails?.totalInvitationsCount = self.invitations.count
                    appDelegate.userData?.saveUserDetails()
                    
                    appDelegate.userData?.loadUserDetails()
                    
                    
                    if checkForExistingUsers {
                        self.checkForPendingInvitationsBeforeSharing ()
                    }else {
                        self.checkForPendingInvitations ()
                    }
                }
            }else {
                
            }
            
        }, errorblock: { (error, isJsonError) in
            
            
        }, progress: nil)
    }
    
}

