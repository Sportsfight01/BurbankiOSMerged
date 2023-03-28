//
//  UserPreferenceVC.swift
//  MyPlace
//
//  Created by Sreekanth tadi on 18/03/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit


class UserPreferenceVC: UIViewController {
    
    
    @IBOutlet weak var btnMyProfile: UIButton!
    @IBOutlet weak var lb_myPlace_heading: UILabel!
    @IBOutlet weak var lbWelcomeDescription: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var icon: UIButton!
    
    
    
    @IBOutlet weak var viewWelcome: UIView!
    @IBOutlet weak var labelWelcome: UILabel!
    //@IBOutlet weak var imageAppLogo: UIImageView!
   // @IBOutlet weak var labelWelcomeDescription: UILabel!
 //   @IBOutlet weak var textViewWelcomeDescription: UITextView!
    @IBOutlet weak var btnHowWorks: UIButton!
    
    
    
    @IBOutlet weak var viewModuleSelection: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var btnContinue: UIButton!
    
    @IBOutlet weak var stackViewWidth: NSLayoutConstraint!

    
    @IBOutlet weak var viewLookingSelection: UIView! //just looking
    @IBOutlet weak var btnLookingSelection: UIButton!
    @IBOutlet weak var imageLookingSelection: UIImageView!
    @IBOutlet weak var imageLooking: UIImageView!
    @IBOutlet weak var labelLookingName: UILabel!
    @IBOutlet weak var labelLookingDescription: UILabel!
    
    
    @IBOutlet weak var viewDepositedSelection: UIView! //Deposited
    @IBOutlet weak var btnDepositedSelection: UIButton!
    @IBOutlet weak var imageDepositedSelection: UIImageView!
    @IBOutlet weak var imageDeposited: UIImageView!
    @IBOutlet weak var labelDepositedName: UILabel!
    @IBOutlet weak var labelDepositedDescription: UILabel!
    
    
    @IBOutlet weak var viewFinishedSelection: UIView! //Finished
    @IBOutlet weak var btnFinishedSelection: UIButton!
    @IBOutlet weak var imageFinishedSelection: UIImageView!
    @IBOutlet weak var imageFinished: UIImageView!
    @IBOutlet weak var labelFinishedName: UILabel!
    @IBOutlet weak var labelFinishedDescription: UILabel!
    
    
    
    private var selectedModule = 0
    private let selectedAppModule = "selectedModule"
    
    
    //MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.isHidden = true
        
        pageUISetup()
        setModuleSelection()
        btnContinue.isHidden = true
        viewFinishedSelection.removeFromSuperview()
        
       // stackViewWidth.isActive = false
        stackView.spacing = 10
      //  stackView.addConstraint(NSLayoutConstraint(item: stackView as Any, attribute: .width, relatedBy: .equal, toItem: stackView, attribute: .height, multiplier: 2, constant: 1*stackView.spacing))
        
     //   textViewWelcomeDescription.text = "Find your perfect home on Burbank Homes app - The only property app you need for your home purchase or property needs in Australia. If you are looking to build your dream home, buy a brand new house or invest in home building in Australia, this property finder app will simplify your property search.\nBurbank is proudly an Australian home builder, building homes in Victoria, New South Wales, Queensland and South Australia. "
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        CodeManager.sharedInstance.sendScreenName(burbank_home_screen_loading)

     //   textViewWelcomeDescription.contentOffset = CGPoint (x: 0, y: 0)
        
        if let _ = AppConfigurations.shared.getHowDoesitWorkURL() {

        }else {

            btnHowWorks.isHidden = true
        }
    }
    
    
    //MARK: - View

    func pageUISetup () {
        
        setAppearanceFor(view: viewWelcome, backgroundColor: APPCOLORS_3.Body_BG)
        setAppearanceFor(view: viewModuleSelection, backgroundColor: APPCOLORS_3.Body_BG)
        
        setAppearanceFor(view: labelWelcome, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_SUB_HEADING(size: FONT_13))
        setAppearanceFor(view: lbWelcomeDescription, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_SUB_HEADING(size: FONT_12))
        _ = setAttributetitleFor(view: lb_myPlace_heading, title: "MyPlace", rangeStrings: ["My", "Place"], colors: [APPCOLORS_3.GreyTextFont, APPCOLORS_3.GreyTextFont ], fonts: [FONT_LABEL_BODY(size: 55) , FONT_LABEL_SUB_HEADING(size: 55)], alignmentCenter: true)
//        setAppearanceFor(view: lb_myPlace_heading, backgroundColor: COLOR_CLEAR, textColor: AppColors.darkGray, textFont: FONT_LABEL_SUB_HEADING(size: FONT_12))
      //  setAppearanceFor(view: btnHowWorks, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        
        
        setAppearanceFor(view: labelLookingName, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_BODY(size: FONT_11))
        setAppearanceFor(view: labelLookingDescription, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_BODY(size: FONT_10))
        
        
        setAppearanceFor(view: labelDepositedName, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_BODY(size: FONT_11))
        setAppearanceFor(view: labelDepositedDescription, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_BODY(size: FONT_10))
        
        
        setAppearanceFor(view: btnMyProfile, backgroundColor: APPCOLORS_3.LightGreyDisabled_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_BODY (size: FONT_12))
        btnMyProfile.layer.cornerRadius = 5.0
        
        
        //FINISHED
        setAppearanceFor(view: labelFinishedName, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_HEADING(size: FONT_11))
        setAppearanceFor(view: labelFinishedDescription, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_BODY(size: FONT_10))
        
        
        setAppearanceFor(view: btnContinue, backgroundColor: APPCOLORS_3.Orange_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_HEADING (size: FONT_16))
        
        
      //  btnHowWorks.layer.cornerRadius = 5.0
       // setBorder(view: btnHowWorks, color: , width: 1.0)
       
        btnHowWorks.cardView()
        btnHowWorks.backgroundColor = AppColors.white
        
        viewLookingSelection.layer.cornerRadius = 10.0
        viewDepositedSelection.layer.cornerRadius = 10.0
        viewFinishedSelection.layer.cornerRadius = 5.0
        
        
        setShadow(view: viewLookingSelection, color: UIColor.lightGray, shadowRadius: 10)
        setShadow(view: viewDepositedSelection, color: UIColor.lightGray, shadowRadius: 10)
        setShadow(view: viewFinishedSelection, color: UIColor.lightGray, shadowRadius: 10)
        
        
        btnContinue.layer.cornerRadius = radius_5
        
    }
    
    
    //MARK: - Button Actions
    
    @IBAction func btnMyprofileClicked(_ sender: UIButton) {
        LoginDataManagement.shared.handleDefaultLoginforToken {
            let signIn = kStoryboardLogin.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
            self.navigationController?.pushViewController(signIn, animated: true)
        }
        
    }
    @IBAction func handleHowDoesItWork (_ sender: UIButton) {
        
//        playVideoIn(self, URL(string: ServiceAPI.shared.videoURLBurBank)!)
//        playVideoIn(self, URL(string: "https://player.vimeo.com/video/648885366"))
        
        if let url = AppConfigurations.shared.getHowDoesitWorkURL(), let _ = URL (string: url) {
            print(log: url)
            playVideoIn(self, url)
        }
        
        CodeManager.sharedInstance.sendScreenName(burbank_home_screen_howDoesItWork_button_touch)
    }
    
    func setModuleSelection () {
        
        if let sele = kUserDefaults.value(forKey: selectedAppModule) {
            selectedModule = Int((sele as! String))!
        }else {
            
            selectedModule = 1
            
            kUserDefaults.setValue("1", forKey: selectedAppModule)
            kUserDefaults.synchronize()
        }
        
        imageLookingSelection.image = selectedModule == 1 ? imageChecked : imageUnChecked
        imageDepositedSelection.image = selectedModule == 2 ? imageChecked : imageUnChecked
//        imageFinishedSelection.image = selectedModule == 3 ? imageChecked :imageUnChecked
        
    }
    
    
    @IBAction func handleSelectionButton (sender: UIButton) {
        
//        fatalError()
          
        selectedModule = sender == btnLookingSelection ? 1 : sender == btnDepositedSelection ? 2 : 0

        
        kUserDefaults.setValue(String(selectedModule), forKey: selectedAppModule)
        kUserDefaults.synchronize()
        
        setModuleSelection ()
        
        
        if selectedModule == 1 {
            CodeManager.sharedInstance.sendScreenName(burbank_home_screen_justLooking_button_touch)
//            Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
//              AnalyticsParameterItemID: "id-\(title!)",
//              AnalyticsParameterItemName: title!,
//              AnalyticsParameterContentType: "cont",
//            ])
            
            LoginDataManagement.shared.handleDefaultLoginforToken {
                let signIn = kStoryboardLogin.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
                self.navigationController?.pushViewController(signIn, animated: true)
            }
        }else if selectedModule == 2 {
            CodeManager.sharedInstance.sendScreenName(burbank_home_screen_deposited_button_touch)
            if appDelegate.loginStatus == true
            {
                CodeManager.sharedInstance.handleUserLoginSuccess(user: appDelegate.currentUser!, In: self)
                return
            }else {
                                
                self.navigationController?.pushViewController(UIStoryboard(name: "MyPlaceLogin", bundle: nil).instantiateViewController(withIdentifier: "LaunchVCNew") as! LaunchVCNew, animated: true)
            }
        }
    }
    
    
    @IBAction func handleContinueButtonAction (sender: UIButton) {
        
        CodeManager.sharedInstance.sendScreenName(burbank_home_screen_continue_button_touch)

        
        if selectedModule == 0 {
            
            BurbankApp.showAlert("Please select one option", self)
        }else if selectedModule == 1 {
                        
           
        }else if selectedModule == 2 {

            
            
            return
        }else /*if selectedModule == 3*/ {
            
            BurbankApp.showAlert("Coming Soon", self)
        }
        
    }
    
}
