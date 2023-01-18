//
//  MyPlaceDashBoardVC.swift
//  BurbankApp
//
//  Created by dmss on 25/04/17.
//  Copyright © 2017 DMSS. All rights reserved.
//

import UIKit
import MessageUI

class MyPlaceDashBoardVC: BurbankAppVC/*MyPlaceWithTabBarVC*/,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,MyPlaceDocumentVCDelegate,ProgressStatusVCDelegate,SWRevealViewControllerDelegate,UIDocumentInteractionControllerDelegate,UITableViewDataSource,UITableViewDelegate,jobInvitationsProtocol,UITextFieldDelegate,addJobProtocol
{
    @IBOutlet weak var menuCV: UICollectionView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var welcome: UILabel!
    @IBOutlet weak var welcomeUsername: UILabel!
  
    @IBOutlet weak var jobNumberBackGroundView: UIView!
    @IBOutlet weak var jobInvitationsView: UIView!
    @IBOutlet weak var addJobView: UIView!
    @IBOutlet weak var addJobInfoView: UIView!
    
    @IBOutlet weak var support_Help_View: UIView!

    
    @IBOutlet weak var menuCVHeight: NSLayoutConstraint!
    @IBOutlet weak var menuCVBottom: NSLayoutConstraint!

    
    var isUserHasData: Bool?
    var isFromLaunchVC = false
    let menuArray = [
        ["name" : "Progress", "imageName" : "Ico-Process","segueIndetifier": "showProgressVC"],
        ["name" : "Photos", "imageName" : "Ico-Photos","segueIndetifier": "showStatusVC"],
        ["name" : "Details", "imageName" : "Ico-Doc","segueIndetifier": "showContractVC"],
        ["name" : "Finance", "imageName" : "Ico-Finance" ,"segueIndetifier" : "showFinanceVC"],
        ["name" : "Support", "imageName" : "Ico-Support" ,"segueIndetifier" : ""],
        ["name" : "More", "imageName" : "Ico-More" ,"segueIndetifier" : "showMoreOptionsVC"]
    ]
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var financeTempDictionary : NSMutableDictionary!
    var contactTempDictionary : NSMutableDictionary!
    
    var documentTempArray : NSMutableArray!
    
    var photosTempArray : NSMutableArray!
    
    var progressTempDictionary : NSMutableDictionary!
    
    
    @IBOutlet weak var notificationsButton : UIButton!
    
    @IBOutlet weak var notificationsButtonIcon : UIImageView!

 //   @IBOutlet weak var notificationsCountIcon : UIImageView!
    
    @IBOutlet weak var settingsButton : UIButton!

    @IBOutlet weak var jobNumberTextFiled: UITextField!

    @IBOutlet weak var jobListTableView: UITableView!
    @IBOutlet weak var jobListDropDownButton: UIButton!
    @IBOutlet weak var jobListTableViewHeightAnchor: NSLayoutConstraint!
    let jobListCellHeight = SCREEN_HEIGHT * 0.075
    var jobListCount = 0
    
    
    //support
    @IBOutlet weak var jobNoLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var designationLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var mobileNoLabel: UILabel!
    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var btnCall: UIButton!

    
    @IBOutlet weak var tableWidth: NSLayoutConstraint!

    
    //Myplace Variables
//
//    var myPLaceConstructionID = ""
//    var myPlaceOfficeID = ""
//    var myPlaceJobID = ""
    var myPlaceResponseArray = NSMutableArray()
    var myPlaceRegion: String?
    
    var isForLoggedInService = false
    
    var jobInvitationsVC: JobInvitationsVC?
    let lOGOUTTAG = 123
    let SETTINGSTAG = 124
    var stagesProgressDetailsDic = [String: [MyPlaceProgressDetails]]()// for QLD and SA Region
    var myPlaceContractDetails: MyPlaceContractDetails!
    
    
    lazy var jobListBackGroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(jobListBackGroundViewTapped)))
        
        return view
    }()
    
    @objc func jobListBackGroundViewTapped()
    {
        UIView.animate(withDuration: 0.5, animations: {
            self.jobListTableView.alpha = 0
        }) { (isSucced) in
            self.jobListBackGroundView.removeFromSuperview()
        }
        
    }
    
    func setUpUI () {
        
        setAppearanceFor(view: welcome, backgroundColor: .clear, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_HEADING(size: FONT_24))
        setAppearanceFor(view: welcomeUsername, backgroundColor: .clear, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_LABEL_HEADING(size: FONT_24))
        
        setAppearanceFor(view: jobNumberTextFiled, backgroundColor: .clear, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_BODY(size: FONT_14))

        
        
        setAppearanceFor(view: jobNoLabel, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))

        
        setAppearanceFor(view: btnEmail, backgroundColor: APPCOLORS_3.Black_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_15))
        setAppearanceFor(view: btnCall, backgroundColor: APPCOLORS_3.Black_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_15))

        
        setAppearanceFor(view: nameLabel, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_SUB_HEADING (size: FONT_15))
        setAppearanceFor(view: emailLabel, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_BODY (size: FONT_13))
        setAppearanceFor(view: designationLabel, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_BODY (size: FONT_13))

        setAppearanceFor(view: mobileNoLabel, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_BODY (size: FONT_13))

        
        
        btnCall.layer.cornerRadius = radius_5
        btnEmail.layer.cornerRadius = radius_5
        
        jobListTableView.layer.cornerRadius = radius_5
        jobListTableView.clipsToBounds = true
        jobListTableView.layer.masksToBounds = true
    }
    
}




class MyPlaceMenuCVCell: BurbankAppCVCell
{
    @IBOutlet weak var blackBackGroundView: UIView!
    @IBOutlet weak var menuImageView: UIImageView!
    @IBOutlet weak var menuNameLabel: UILabel!
   
//    override func draw(_ rect: CGRect)
//    {
//        super.draw(rect)
//        let height = SCREEN_HEIGHT * 0.35 * 0.8 * 0.5
//        blackBackGroundView.layer.cornerRadius =  height/2 //((SCREEN_HEIGHT * 0.4) - 10) * 0.5
//        blackBackGroundView.layer.masksToBounds = true
//        if IS_IPHONE_X && tag >= 3
//        {
//            self.contentView.constraints.forEach({ (constraint) in
//                if constraint.identifier == "centralYID"
//                {
//                    constraint.constant = 20
//                }
//            })
//        }
//    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
                
        setAppearanceFor(view: self.menuNameLabel, backgroundColor: self.menuNameLabel.backgroundColor ?? .clear, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_BODY(size: FONT_14))
    }
    
}


