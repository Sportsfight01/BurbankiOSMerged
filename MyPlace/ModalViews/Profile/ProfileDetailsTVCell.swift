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
    @IBOutlet weak var lbLastName: UILabel!
    
    @IBOutlet weak var txtLastName: UITextField!
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
        
        setAppearanceFor(view: lBCount, backgroundColor: COLOR_BLACK, textColor: COLOR_WHITE, textFont: FONT_LABEL_SUB_HEADING(size: FONT_8))
        setAppearanceFor(view: lBTitle, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_LABEL_SUB_HEADING (size: FONT_14))
        setAppearanceFor(view: lBLine, backgroundColor: COLOR_ORANGE_LIGHT, textColor: COLOR_WHITE, textFont: FONT_LABEL_BODY(size: FONT_10))
        
        
        setAppearanceFor(view: lBName, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_LABEL_SUB_HEADING(size: FONT_12))
        setAppearanceFor(view: lbLastName, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_LABEL_SUB_HEADING(size: FONT_12))
        setAppearanceFor(view: lBEmail, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_LABEL_SUB_HEADING(size: FONT_12))
        setAppearanceFor(view: lBPhone, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_LABEL_SUB_HEADING(size: FONT_12))
        //setAppearanceFor(view: lBShare, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_LABEL_SUB_HEADING(size: FONT_12))
        
        if let lbprofileImageee = lBProfileImage {
            setAppearanceFor(view: lbprofileImageee, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_LABEL_SUB_HEADING(size: FONT_12))
        }
        
        setAppearanceFor(view: txtName, backgroundColor: COLOR_WHITE, textColor: COLOR_BLACK, textFont: FONT_TEXTFIELD_HEADING(size: FONT_12))
        setAppearanceFor(view: txtLastName, backgroundColor: COLOR_WHITE, textColor: COLOR_BLACK, textFont: FONT_TEXTFIELD_HEADING(size: FONT_12))
        setAppearanceFor(view: txtEmail, backgroundColor: COLOR_WHITE, textColor: COLOR_BLACK, textFont: FONT_TEXTFIELD_HEADING(size: FONT_12))
        setAppearanceFor(view: txtPhone, backgroundColor: COLOR_WHITE, textColor: COLOR_BLACK, textFont: FONT_TEXTFIELD_HEADING(size: FONT_12))
       // setAppearanceFor(view: txtShare, backgroundColor: COLOR_WHITE, textColor: COLOR_BLACK, textFont: FONT_TEXTFIELD_HEADING(size: FONT_12))

        if let btnUploaddd = btnUpload {
            setAppearanceFor(view: btnUploaddd, backgroundColor: COLOR_WHITE, textColor: COLOR_BLACK, textFont: FONT_BUTTON_SUB_HEADING(size: FONT_12))
        }
        if let btnSelecttt = btnSelect {
            setAppearanceFor(view: btnSelecttt, backgroundColor: COLOR_BLACK, textColor: COLOR_WHITE, textFont: FONT_BUTTON_SUB_HEADING(size: FONT_12))
        }
        
        
        setAppearanceFor(view: btnUpdate, backgroundColor: COLOR_CLEAR, textColor: COLOR_WHITE, textFont: FONT_BUTTON_BODY(size: FONT_14))
        
        setBorder(view: btnUpdate, color: COLOR_WHITE, width: 0.5)
        
        txtName.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: txtName.frame.size.height))
        txtLastName.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: txtName.frame.size.height))
        txtEmail.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: txtEmail.frame.size.height))
        txtPhone.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: txtPhone.frame.size.height))
      //  txtShare.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: txtShare.frame.size.height))

        txtName.leftViewMode = .always
        txtLastName.leftViewMode = .always
        txtEmail.leftViewMode = .always
        txtPhone.leftViewMode = .always
      //  txtShare.leftViewMode = .always

        
        txtName.layer.cornerRadius = 5.0
        txtLastName.layer.cornerRadius = 5.0
        txtEmail.layer.cornerRadius = 5.0
        txtPhone.layer.cornerRadius = 5.0
       // txtShare.layer.cornerRadius = 5.0
        
        btnUpdate.layer.cornerRadius = radius_5 //5.0
        
        lBCount.layer.cornerRadius = lBCount.frame.size.height/2

        if let viewProfilePiccc = viewProfilePic {
            btnSelect.layer.cornerRadius = radius_5
            viewProfilePiccc.layer.cornerRadius = radius_5
        }
        
        
        txtEmail.isUserInteractionEnabled = false
        txtEmail.backgroundColor = COLOR_LIGHT_GRAY

        
        txtPhone.delegate = self

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
    func fillDetails () {

        lBCount.isHidden = true

        lBCount.text = "0"

        
        self.txtName.text = appDelegate.userData?.user?.userFirstName?.capitalized
        self.txtLastName.text = appDelegate.userData?.user?.userLastName?.capitalized
        
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
        
//        if emails.count > 0 {
//            self.txtShare.text = emails.joined(separator: ",")
//        }

    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        guard let preText = textField.text as NSString?,
            preText.replacingCharacters(in: range, with: string).count <= 13 else {
            return false
        }
        return true
    }
    
    
}
