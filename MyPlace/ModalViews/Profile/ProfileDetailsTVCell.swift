//
//  ProfileDetailsTVCell.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 02/04/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit

class ProfileDetailsTVCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var lBCount: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var lBTitle: UILabel!
    @IBOutlet weak var btnArrow: UIButton!
    
    
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var btnUpdate: UIButton!
    
    @IBOutlet weak var lBName: UILabel!
    @IBOutlet weak var txtName: UITextField!
//    @IBOutlet weak var lbLastName: UILabel!
    
//    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var lBEmail: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var lBPhone: UILabel!
    @IBOutlet weak var txtPhone: UITextField!
    
//    @IBOutlet weak var lBShare: UILabel!
//    @IBOutlet weak var txtShare: UITextField!

    @IBOutlet weak var lBProfileImage: UILabel!
    @IBOutlet weak var viewProfilePic: UIView!
    @IBOutlet weak var btnUpload: UIButton!
    @IBOutlet weak var btnSelect: UIButton!

    
    
    @IBOutlet weak var lBLine: UILabel!
    
    
    var userDetails: UserBean? {
        didSet {
            fillDetails()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setAppearanceFor(view: lBCount, backgroundColor: APPCOLORS_3.GreyTextFont, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_LABEL_SUB_HEADING(size: FONT_8))
        setAppearanceFor(view: lBTitle, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_SUB_HEADING (size: FONT_14))
        setAppearanceFor(view: lBLine, backgroundColor: APPCOLORS_3.EnabledOrange_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_LABEL_BODY(size: FONT_10))
        
        
        setAppearanceFor(view: lBName, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_SUB_HEADING(size: FONT_12))
//        setAppearanceFor(view: lbLastName, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_SUB_HEADING(size: FONT_12))
        setAppearanceFor(view: lBEmail, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_SUB_HEADING(size: FONT_12))
        setAppearanceFor(view: lBPhone, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_SUB_HEADING(size: FONT_12))
        //setAppearanceFor(view: lBShare, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_SUB_HEADING(size: FONT_12))
        
        if let lbprofileImageee = lBProfileImage {
            setAppearanceFor(view: lbprofileImageee, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_SUB_HEADING(size: FONT_12))
        }
        
        setAppearanceFor(view: txtName, backgroundColor: APPCOLORS_3.HeaderFooter_white_BG, textColor: APPCOLORS_3.Black_BG, textFont: FONT_TEXTFIELD_HEADING(size: FONT_12))
//        setAppearanceFor(view: txtLastName, backgroundColor: APPCOLORS_3.HeaderFooter_white_BG, textColor: APPCOLORS_3.Black_BG, textFont: FONT_TEXTFIELD_HEADING(size: FONT_12))
        setAppearanceFor(view: txtEmail, backgroundColor: APPCOLORS_3.HeaderFooter_white_BG, textColor: APPCOLORS_3.Black_BG, textFont: FONT_TEXTFIELD_HEADING(size: FONT_12))
        setAppearanceFor(view: txtPhone, backgroundColor: APPCOLORS_3.HeaderFooter_white_BG, textColor: APPCOLORS_3.Black_BG, textFont: FONT_TEXTFIELD_HEADING(size: FONT_12))
       // setAppearanceFor(view: txtShare, backgroundColor: APPCOLORS_3.HeaderFooter_white_BG, textColor: APPCOLORS_3.Black_BG, textFont: FONT_TEXTFIELD_HEADING(size: FONT_12))

        if let btnUploaddd = btnUpload {
            setAppearanceFor(view: btnUploaddd, backgroundColor: APPCOLORS_3.HeaderFooter_white_BG, textColor: APPCOLORS_3.Black_BG, textFont: FONT_BUTTON_SUB_HEADING(size: FONT_12))
        }
        if let btnSelecttt = btnSelect {
            setAppearanceFor(view: btnSelecttt, backgroundColor: APPCOLORS_3.Black_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_SUB_HEADING(size: FONT_12))
        }
        
        
        setAppearanceFor(view: btnUpdate, backgroundColor: APPCOLORS_3.Orange_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_BODY(size: FONT_14))
        
        setBorder(view: btnUpdate, color: APPCOLORS_3.HeaderFooter_white_BG, width: 0.5)
        
        [txtName,txtEmail,txtPhone].forEach { txtField in
            txtField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: txtField.frame.size.height))
            txtField.leftViewMode = .always
            txtField.layer.cornerRadius = 5.0
        }
       
//        txtLastName.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: txtName.frame.size.height))
//        txtEmail.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: txtName.frame.size.height))
//        txtPhone.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: txtPhone.frame.size.height))
//      //  txtShare.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: txtShare.frame.size.height))
//
//
////        txtLastName.leftViewMode = .always
//        txtEmail.leftViewMode = .always
//        txtPhone.leftViewMode = .always
//      //  txtShare.leftViewMode = .always
//
//
//
//
//        txtEmail.layer.cornerRadius = 5.0
//        txtPhone.layer.cornerRadius = 5.0
       
        
        btnUpdate.layer.cornerRadius = radius_5 //5.0
        
        lBCount.layer.cornerRadius = lBCount.frame.size.height/2

        if let viewProfilePiccc = viewProfilePic {
            btnSelect.layer.cornerRadius = radius_5
            viewProfilePiccc.layer.cornerRadius = radius_5
        }
        
        
//        txtEmail.isUserInteractionEnabled = false
//        txtName.isUserInteractionEnabled = false
        [txtName, txtEmail].forEach { txtField in
            txtField?.isUserInteractionEnabled = false
            txtField?.backgroundColor = APPCOLORS_3.LightGreyDisabled_BG
        }

        
        txtPhone.delegate = self

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
    func fillDetails () {
        self.txtName.isUserInteractionEnabled = false
        lBCount.isHidden = false
        lBCount.text = ""
        self.txtName.text = "\(appDelegate.userData?.user?.userFirstName?.capitalized ?? "") \(appDelegate.userData?.user?.userLastName?.capitalized ?? "")"
        self.txtEmail.text = appDelegate.userData?.user?.userEmail
        self.txtPhone.text = appDelegate.userData?.user?.userPhone

        
        var emails = [String]()
        
        if let userss = appDelegate.userData?.sharingUsers {
            for user in userss {
                if user.userEmail!.count > 0 {
                    emails.append(user.userEmail!)
                }
            }
        }

    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        guard let preText = textField.text as NSString?,
            preText.replacingCharacters(in: range, with: string).count <= 13 else {
            return false
        }
        return true
    }
    
    
}
