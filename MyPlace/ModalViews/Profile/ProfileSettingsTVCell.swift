//
//  ProfileSettingsTVCell.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 01/04/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit

class ProfileSettingsTVCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var lBCount: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var lBTitle: UILabel!
    @IBOutlet weak var btnArrow: UIButton!

    @IBOutlet weak var permissionsView: UIView!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var lBHeading: UILabel!//services
    @IBOutlet weak var lBNotifications: UILabel!
    @IBOutlet weak var lBLocationServices: UILabel!
    @IBOutlet weak var btnLogout: UIButton!

    @IBOutlet weak var switchNotifications: UISwitch!
    @IBOutlet weak var switchLocation: UISwitch!
//    @IBOutlet weak var btnLogoutIcon: UIButton!

    
    @IBOutlet weak var lBLineHeading: UILabel!
    @IBOutlet weak var lBLineNotifications: UILabel!
    @IBOutlet weak var lBLineLocations: UILabel!
//    @IBOutlet weak var lBLineLogout: UILabel!

    
    @IBOutlet weak var lBLine: UILabel!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setAppearanceFor(view: lBCount, backgroundColor: COLOR_GRAY, textColor: COLOR_WHITE, textFont: FONT_LABEL_SUB_HEADING(size: FONT_8))
        setAppearanceFor(view: lBTitle, backgroundColor: COLOR_CLEAR, textColor: COLOR_GRAY, textFont: FONT_LABEL_SUB_HEADING (size: FONT_14))
        setAppearanceFor(view: lBLine, backgroundColor: COLOR_ORANGE_LIGHT, textColor: COLOR_WHITE, textFont: FONT_LABEL_BODY(size: FONT_10))

                
        setAppearanceFor(view: lBHeading, backgroundColor: COLOR_CLEAR, textColor: COLOR_DARK_GRAY, textFont: FONT_LABEL_SUB_HEADING (size: FONT_15))
        setAppearanceFor(view: lBNotifications, backgroundColor: COLOR_CLEAR, textColor: COLOR_ORANGE, textFont: FONT_LABEL_SUB_HEADING (size: FONT_14))
        setAppearanceFor(view: lBLocationServices, backgroundColor: COLOR_CLEAR, textColor: COLOR_ORANGE, textFont: FONT_LABEL_SUB_HEADING (size: FONT_14))
        setAppearanceFor(view: btnLogout, backgroundColor: COLOR_ORANGE, textColor: COLOR_WHITE, textFont: FONT_LABEL_BODY(size: FONT_14))


//        btnLogoutIcon.setTitle("", for: .normal)
//        btnLogoutIcon.setBackgroundImage(UIImage(named: "Ico-Settings"), for: .normal)
        
        permissionsView.cardView()
        
        selectionColorsForSwitch(switchService: switchNotifications)
        selectionColorsForSwitch(switchService: switchLocation)

        bottomView.layer.cornerRadius = radius_5 //5.0
        //bottomView.layer.masksToBounds = true
        
        lBCount.layer.cornerRadius = lBCount.frame.size.height/2

        
        lBHeading.superview?.layer.cornerRadius = radius_5
        
        
        lBCount.isHidden = false

        lBCount.text = ""
        btnArrow.tintColor = .gray
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
    @IBAction func handleServicesSwitch (_ sender: UISwitch) {
    
        if sender == switchNotifications {
            //update service and store to defaluts of user and update it
            
            CodeManager.sharedInstance.sendScreenName(burbank_profile_appSettings_notification_switch_touch)
            
            sender.isOn == true ? NotificationServices.shared.onNotificationsServices() : NotificationServices.shared.offNotificationsServices()
        }else {
            
            CodeManager.sharedInstance.sendScreenName (burbank_profile_appSettings_location_switch_touch)
            DispatchQueue.main.async {
                sender.isOn == true ? LocationServices.shared.onLocationService() : LocationServices.shared.offLocationServices()
            }
        }
        
        selectionColorsForSwitch(switchService: sender)
    }
    
    
    func selectionColorsForSwitch (switchService: UISwitch) {
        
        switchService.thumbTintColor = switchService.isOn ? COLOR_ORANGE : COLOR_DARK_GRAY
    }
    
    
}
