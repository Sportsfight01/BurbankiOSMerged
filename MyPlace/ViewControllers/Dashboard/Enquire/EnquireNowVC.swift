
//
//  EnquireNowVC.swift
//  MyPlace
//
//  Created by Mohan Kumar on 10/06/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit

class EnquireNowVC: BurbankAppVC, UITextFieldDelegate , UIPickerViewDelegate , UIPickerViewDataSource {
    
    //MARK: - Properties
    
    @IBOutlet weak var viewWhereWouldYouliketolive: UIView!
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var btnback : UIButton!
    @IBOutlet weak var iconAccept : UIImageView!
    
    @IBOutlet weak var viewFirstNameText : UIView!
    @IBOutlet weak var viewLastNameText : UIView!
    @IBOutlet weak var viewEmailText : UIView!
    @IBOutlet weak var viewPhoneText : UIView!
    @IBOutlet weak var viewWhatToBuildText : UIView!
    
    @IBOutlet weak var viewMessage : UIView!
    @IBOutlet weak var frstNameTF : UITextField!
    @IBOutlet weak var lastNameTF : UITextField!
    @IBOutlet weak var emailTF : UITextField!
    @IBOutlet weak var phoneTF : UITextField!
    @IBOutlet weak var whatToBuildTF : UITextField!
    
    @IBOutlet weak var textViewMessage : UITextView!
    @IBOutlet weak var textViewPlaceholder : UILabel!
    
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var acceptHint: UILabel!
    @IBOutlet weak var btnEnquire: UIButton!
    @IBOutlet weak var whereWouldYouLiveTF: UITextField!
    
    var homeDesign: HomeDesigns?
    
    var homelandPackage: HomeLandPackage?
    
    var homeDesignDetails: HomeDesignDetails?
    
    var acceptedTerms: Bool = false
    
    var phoneNumberNotAvailable: Bool = false
    var lastName = appDelegate.userData?.user?.userLastName ?? ""
    let pickerView = UIPickerView()
    var pickerViewDataSource : [String] = [""]
    
//    var victoriaRegions = [
//        "Not Sure Yet","West Region","North Region","South East Region","Regional South East","Geelong & Bellarine Region", "Ballarat Region","Bendigo Region"]
//    var queenslandRegions = [
//        "Brisbane Metro","Gold Coast","North/Moreton","South/Logan","Sunshine Coast","West/Ipswich", "East/Redlands","Other or Unsure"]
//    var southaustraliaRegions = [
//        "Adelaide Hills","East","North","South","West","Other or Unsure"]
//    var nswRegions = [
//        "ACT & Surrounds","Newcastle/Hunter","North-West Sydney","South-West Sydney","Wollongong/Nowra","Other or Unsure"]
    
    var stateName = ""
    var selected_Estate = ""
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        if let _ = homeDesign {
            CodeManager.sharedInstance.sendScreenName(burbank_homeDesigns_detailView_enquire_screen_loading)
        }else if let _ = homelandPackage{
            CodeManager.sharedInstance.sendScreenName(burbank_homeAndLand_detailView_enquire_screen_loading)
        }else if let _ = homeDesignDetails{
            self.navigationController?.navigationBar.isHidden = true
        }
        stateName = kUserStateName.lowercased().trim().replacingOccurrences(of: " ", with: "-")
        if kUserStateName.contains("NSW & ACT"){
            
            pickerViewDataSource = nswRegions
            stateName = "nsw"
            
        }else if kUserStateName.contains("South"){
            stateName = "south-australia"
            pickerViewDataSource = southaustraliaRegions
        }else if kUserStateName.contains("Queensland"){
            stateName = "queensland"
            pickerViewDataSource = queenslandRegions
        }else if kUserStateName.contains("Victoria"){
            stateName = "victoria"
            pickerViewDataSource = victoriaRegions
        }
        handleUISetup ()
                
        
    }
    
    
    func handleUISetup () {
        
        iconAccept.layer.cornerRadius = 5.0
//        _ = setAttributetitleFor(view: titleLabel, title: "EnquireNow", rangeStrings: ["Enquire", "Now"], colors: [APPCOLORS_3.Black_BG, APPCOLORS_3.Black_BG], fonts: [logoFont, logoFont], alignmentCenter: false)
        btnback.setImage(UIImage(named: "Ico-LeftArrow")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnback.tintColor = APPCOLORS_3.GreyTextFont
        _ = setAttributetitleFor(view: titleLabel, title: "EnquireNow", rangeStrings: ["Enquire", "Now"], colors: [APPCOLORS_3.GreyTextFont , APPCOLORS_3.GreyTextFont], fonts: [FONT_LABEL_BODY(size: 30) , FONT_LABEL_SUB_HEADING(size : 30)], alignmentCenter: false)
        
        //cardView of viewElements
        [viewEmailText,viewFirstNameText,viewLastNameText,viewPhoneText,viewWhatToBuildText, viewMessage , viewWhereWouldYouliketolive].forEach { view in
            if #available(iOS 13.0, *) {
                view?.cardView(cornerRadius: radius_5 , shadowOpacity: 0.3 , shadowColor: UIColor.systemGray3.cgColor)
            } else {
                // Fallback on earlier versions
                view?.cardView(cornerRadius: radius_5 , shadowOpacity: 0.3)
            }
        }
        
            setAppearanceFor(view: view, backgroundColor: APPCOLORS_3.Body_BG)
        setAppearanceFor(view: emailTF, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_TEXTFIELD_BODY(size: FONT_13))
        setAppearanceFor(view: lastNameTF, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_TEXTFIELD_BODY(size: FONT_13))
        setAppearanceFor(view: frstNameTF, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_TEXTFIELD_BODY(size: FONT_13))
        setAppearanceFor(view: phoneTF, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_TEXTFIELD_BODY(size: FONT_13))
        setAppearanceFor(view: whatToBuildTF, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_TEXTFIELD_BODY(size: FONT_13))
        
        
        setAppearanceFor(view: textViewMessage, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_TEXTFIELD_BODY(size: FONT_13))
        setAppearanceFor(view: textViewPlaceholder, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.LightGreyDisabled_BG, textFont: FONT_TEXTFIELD_BODY(size: FONT_13))
        
        
        setAppearanceFor(view: btnAccept, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_SUB_HEADING(size: FONT_14))
        setAppearanceFor(view: btnEnquire, backgroundColor: AppColors.appOrange, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_SUB_HEADING(size: FONT_15))
        
        
//        viewEmailText.layer.cornerRadius = radius_5
//        viewFirstNameText.layer.cornerRadius = radius_5
//        viewLastNameText.layer.cornerRadius = radius_5
//        viewPhoneText.layer.cornerRadius = radius_5
//        viewWhatToBuildText.layer.cornerRadius = radius_5
//        whereWouldYouLiveTF.superview?.layer.cornerRadius = radius_5
//
//        viewMessage.layer.cornerRadius = radius_5
        
        whereWouldYouLiveTF.attributedPlaceholder = NSAttributedString(string: "Where would you like to live?", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
        
        
        
        btnEnquire.layer.cornerRadius = radius_5
        
        if let _ = homelandPackage {
            self.whatToBuildTF.text = "\(self.homelandPackage?.houseName ?? "") \(self.homelandPackage?.houseSize ?? "")"
        }else if let _ = homeDesign{
            self.whatToBuildTF.text = "\(self.homeDesign?.houseName ?? "") \(self.homeDesign?.houseSize ?? "")"
        }else if let _ = homeDesignDetails{
            self.whatToBuildTF.text = "\(self.homeDesignDetails?.lsthouses?.houseName ?? "") \(self.homeDesignDetails?.lsthouses?.houseSize ?? 0)"
        }
        
     self.whatToBuildTF.isUserInteractionEnabled = false
        if Int(kUserID)! > 0 {
            
            self.frstNameTF.text = appDelegate.userData?.user?.userFirstName?.capitalized
            self.lastNameTF.text = appDelegate.userData?.user?.userLastName?.capitalized
            self.emailTF.text = appDelegate.userData?.user?.userEmail ?? ""
            self.phoneTF.text = appDelegate.userData?.user?.userPhone ?? ""
            
           
            
            if #available(iOS 13.0, *) {
                setAppearanceFor(view: viewWhatToBuildText, backgroundColor: APPCOLORS_3.LightGreyDisabled_BG, textColor: APPCOLORS_3.Black_BG, textFont: FONT_TEXTFIELD_BODY(size: FONT_13))
                setAppearanceFor(view: self.viewWhatToBuildText, backgroundColor: APPCOLORS_3.LightGreyDisabled_BG)
            setAppearanceFor(view: self.viewEmailText, backgroundColor: APPCOLORS_3.LightGreyDisabled_BG)
            setAppearanceFor(view: self.viewLastNameText, backgroundColor: APPCOLORS_3.LightGreyDisabled_BG)
            setAppearanceFor(view: self.viewFirstNameText, backgroundColor: APPCOLORS_3.LightGreyDisabled_BG)
            setAppearanceFor(view: self.frstNameTF, backgroundColor: APPCOLORS_3.LightGreyDisabled_BG)
            setAppearanceFor(view: self.lastNameTF, backgroundColor: APPCOLORS_3.LightGreyDisabled_BG)
            setAppearanceFor(view: lastNameTF, backgroundColor: APPCOLORS_3.LightGreyDisabled_BG, textColor: APPCOLORS_3.Black_BG, textFont: FONT_TEXTFIELD_BODY(size: FONT_13))
            setAppearanceFor(view: frstNameTF, backgroundColor: APPCOLORS_3.LightGreyDisabled_BG, textColor: APPCOLORS_3.Black_BG, textFont: FONT_TEXTFIELD_BODY(size: FONT_13))
            
            if self.frstNameTF.text != "" {
             setAppearanceFor(view: frstNameTF, backgroundColor: .clear, textColor: APPCOLORS_3.Black_BG, textFont: FONT_TEXTFIELD_BODY(size: FONT_13))
             setAppearanceFor(view: viewFirstNameText, backgroundColor: APPCOLORS_3.LightGreyDisabled_BG)
             self.frstNameTF.isUserInteractionEnabled = false
            }else{
             self.frstNameTF.isUserInteractionEnabled = true
             setAppearanceFor(view: frstNameTF, backgroundColor: .clear, textColor: APPCOLORS_3.Black_BG, textFont: FONT_TEXTFIELD_BODY(size: FONT_13))
             setAppearanceFor(view: self.viewFirstNameText, backgroundColor: APPCOLORS_3.HeaderFooter_white_BG)
            }
            
           if self.lastNameTF.text != "" {
            setAppearanceFor(view: lastNameTF, backgroundColor: .clear, textColor: APPCOLORS_3.Black_BG, textFont: FONT_TEXTFIELD_BODY(size: FONT_13))
            setAppearanceFor(view: viewLastNameText, backgroundColor: APPCOLORS_3.LightGreyDisabled_BG)
            self.lastNameTF.isUserInteractionEnabled = false
           }else{
            self.lastNameTF.isUserInteractionEnabled = true
            setAppearanceFor(view: lastNameTF, backgroundColor: .clear, textColor: APPCOLORS_3.Black_BG, textFont: FONT_TEXTFIELD_BODY(size: FONT_13))
            setAppearanceFor(view: self.viewLastNameText, backgroundColor: APPCOLORS_3.HeaderFooter_white_BG)
           }
            
            } else {
                // Fallback on earlier versions
            }
            self.viewWhatToBuildText.isUserInteractionEnabled = false
            self.emailTF.isUserInteractionEnabled = false
//            self.frstNameTF.isUserInteractionEnabled = false
            
            if self.phoneTF.text == "" {
                phoneNumberNotAvailable =  true
            }
            
        }
        
        
        phoneTF.delegate = self
        
        //pickerViewSetup
        whereWouldYouLiveTF.inputView = pickerView
        pickerView.delegate = self
        pickerView.dataSource = self
        
    }
    
    
    @IBAction func didTappedOnHomeBTN(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK: - PickerViewDelegateDatasource

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewDataSource.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       return pickerViewDataSource[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        whereWouldYouLiveTF.text = pickerViewDataSource[row]
        whereWouldYouLiveTF.resignFirstResponder()
    }
    
    
    //MARK: - Delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let preText = textField.text as NSString?,
            preText.replacingCharacters(in: range, with: string).count <= 13 else {
                return false
        }
        return true
    }
    
    
    
    
    //MARK: - Actions
    
    @IBAction func handleButtonAction (_ sender: UIButton) {
        
        if sender == btnback {
            
            self.navigationController?.popViewController(animated: true)
        }else if sender == btnAccept {
            
            if let _ = homeDesign {
                CodeManager.sharedInstance.sendScreenName(burbank_homeDesigns_detailView_enquire_accept_button_touch)
            }else if let _ = homelandPackage {
                CodeManager.sharedInstance.sendScreenName(burbank_homeAndLand_detailView_enquire_accept_button_touch)
            }
            
            if acceptedTerms {
                
                iconAccept.image = imageUnCheckedEnquiry
                acceptedTerms = false
            }else {
                
                acceptedTerms = true
                iconAccept.image = imageCheckedEnquiry
            }
        }else { //btnEnquire
            
            if let _ = homeDesign {
                CodeManager.sharedInstance.sendScreenName(burbank_homeDesigns_detailView_enquire_enquire_button_touch)
            }else if let _ = homelandPackage {
                CodeManager.sharedInstance.sendScreenName(burbank_homeAndLand_detailView_enquire_enquire_button_touch)
            }
            if frstNameTF.text?.trim() == "" {
                
                BurbankApp.showAlert("Please enter first name", self)
            }else if lastNameTF.text?.trim() == "" {
                
                BurbankApp.showAlert("Please enter last name", self)
            }else if emailTF.text?.trim() == "" {
                
                BurbankApp.showAlert("Please enter email", self)
            }else if emailTF.text?.trim().isValidEmail() == false {
                
                BurbankApp.showAlert("Please enter valid email id", self)
            }else if phoneTF.text?.trim() == "" {
                
                BurbankApp.showAlert("Please enter phone number", self)
            }else if whereWouldYouLiveTF.text?.trim() == "" {
                
                BurbankApp.showAlert("Please select where would you live?", self)
            }else if !(phoneTF.text?.trim().isPhoneNumber)! {
                
                BurbankApp.showAlert("Please enter valid phone number", self)
            }else if (phoneTF.text?.trim().count ?? 0) > 14 {
                BurbankApp.showAlert("Phone number should be a maximum of 14 characters length", self)
            }else if acceptedTerms == false {
              
                BurbankApp.showAlert("Please accept Burbank's privacy policy", self)
          }else {
                                
                if /*(appDelegate.userData?.user?.userPhone ?? "").count == 0,*/ (phoneTF.text?.trim().count ?? 0) > 0 {
                    updateProfileDetails ()
                }
                
                if let _ = homelandPackage {
                    
                    enquireHomeLand ()
                }else if let _ = homeDesign{
                    
                    enquireHomeDesign ()
                }else{
                    enquireDisplayHomes ()
                }
                
            }
        }
        
    }
    
    
    
    func enquireHomeLand () -> Void {
        
        let params = NSMutableDictionary.init()
        params.setValue(self.frstNameTF.text ?? "", forKey: "FirstName")
        if lastName != ""  {
            params.setValue(lastName, forKey: "LastName")
        }else{
            params.setValue(self.lastNameTF.text ?? "", forKey: "LastName")
        }
        params.setValue(self.emailTF.text ?? "", forKey: "Email")
        params.setValue(self.phoneTF.text ?? "", forKey: "PhoneNumber")
        params.setValue(self.whereWouldYouLiveTF.text ?? "", forKey: "Build")
        params.setValue(self.textViewMessage.text ?? "", forKey: "Message")
        params.setValue("HomeandLandEnquiry", forKey: "FormName")
        
        params.setValue(self.acceptedTerms, forKey: "IsConsent")
        
        params.setValue(stateName, forKey: "State")
        params.setValue("iOS - App", forKey: "EnquiryType")
        params.setValue("", forKey: "Hearaboutus")
        params.setValue(self.homelandPackage?.houseName ?? "", forKey: "HouseName")
       // params.setValue(self.homelandPackage?.packageId ?? "", forKey: "PackageId")
        params.setValue("PackageId-\(self.homelandPackage?.packageId_LandBank ?? "")", forKey: "Notes")
        //        params.setValue("enquiry", forKey: "Subject") // "mobile app enquiry - contact us"
        
       // params.setValue("Mobile app Enquiry - Contact Us", forKey: "Subject")
        params.setValue("MyPlace App enquiry - \(My_Place3DBASEURL)/\(stateName)/home-details/housename.\(self.homelandPackage?.houseName ?? "");housesize.\(self.homelandPackage?.houseSize ?? "0");packageId.\(self.homelandPackage?.packageId_LandBank ?? "")/", forKey: "Subject")

//        - https//www.purbanc.com.au/queensland/nome
//        dotails/nousenamp.kenmoro:nouses:zea.259dotails/nousenamp.kenmoro:nouses:zea.259

        params.setValue("", forKey: "Header")
        params.setValue("", forKey: "ReferralSource")

        
        let paramsBody = NSMutableDictionary.init()
        paramsBody.setValue("\(self.frstNameTF.text ?? "") \( self.lastNameTF.text ?? "")", forKey: "Name")
        paramsBody.setValue(self.emailTF.text ?? "", forKey: "Email")
        paramsBody.setValue(self.phoneTF.text ?? "", forKey: "PhoneNumber")
        paramsBody.setValue(self.whatToBuildTF.text ?? "", forKey: "I'm interested in")

        paramsBody.setValue(self.whereWouldYouLiveTF.text ?? "", forKey: "Where would you like to live")
        paramsBody.setValue(self.textViewMessage.text ?? "", forKey: "Message")
        paramsBody.setValue(self.acceptedTerms.description, forKey: "I accept Burbank’s privacy policy and wish to receive Burbank’s latest news and offers on my email.")
      //  paramsBody.setValue(self.whereWouldYouLiveTF.text ?? "", forKey: "Build")
        
        
        params.setValue(paramsBody, forKey: "Body")
        
        
        _ = Networking.shared.POST_request(url: ServiceAPI.shared.URL_Enquiry, parameters: params, userInfo: nil, success: { (json, response) in
            
            if let result: AnyObject = json {
                
                let result = result as! NSDictionary
                
                if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {
                    let message = result.value(forKey: "message") as? String ?? ""
                    let alertController = UIAlertController(title: "", message: message, preferredStyle:UIAlertController.Style.alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                      { action -> Void in
                        self.navigationController?.popViewController(animated: true)
                    })
                    self.present(alertController, animated: true, completion: nil)
                    
//                    self.navigationController?.popViewController(animated: true)
//                    showToast("Enquiry Submitted Successfully.")
                }else {
                    
                    print(log: "couldn't get recent searches")
                }
                
            }else {
                
            }
            
        }, errorblock: { (error, isJSONerror) in
            
            if isJSONerror {
                
            }else {
                
            }
        }, progress: nil)
        
    }
    
    
    func enquireHomeDesign () -> Void {
        
        let params = NSMutableDictionary.init()
        params.setValue(self.frstNameTF.text ?? "", forKey: "FirstName")
        if lastName != "" {
            params.setValue(lastName, forKey: "LastName")
        }else{
            params.setValue(self.lastNameTF.text ?? "", forKey: "LastName")
        }
//        params.setValue("", forKey: "LastName")
        params.setValue(self.emailTF.text ?? "", forKey: "Email")
        params.setValue(self.phoneTF.text ?? "", forKey: "PhoneNumber")
        params.setValue(self.whereWouldYouLiveTF.text ?? "", forKey: "Build")
        params.setValue(self.textViewMessage.text ?? "", forKey: "Message")
        params.setValue("NewHomesEnquiry", forKey: "FormName")
        
        params.setValue(true, forKey: "IsConsent")//self.acceptedTerms
        
        params.setValue(stateName, forKey: "State")
        params.setValue("iOS - App", forKey: "EnquiryType")
        params.setValue("", forKey: "Hearaboutus")
        params.setValue(self.homeDesign?.houseName ?? "", forKey: "HouseName")
//        params.setValue("enquiry", forKey: "Subject")
        params.setValue("MyPlace App enquiry - \(My_Place3DBASEURL)/\(stateName)/house-details/housename.\(self.homeDesign?.houseName ?? "");housesize.\(self.homeDesign?.houseSize ?? "0")/", forKey: "Subject")
        params.setValue("", forKey: "Header")
        params.setValue("", forKey: "ReferralSource")
                

        let paramsBody = NSMutableDictionary.init()
        paramsBody.setValue("\(self.frstNameTF.text ?? "") \( self.lastNameTF.text ?? "")", forKey: "Name")
        paramsBody.setValue(self.emailTF.text ?? "", forKey: "Email")
        paramsBody.setValue(self.phoneTF.text ?? "", forKey: "PhoneNumber")
        paramsBody.setValue(self.whatToBuildTF.text ?? "", forKey: "I'm interested in")
        paramsBody.setValue(self.whereWouldYouLiveTF.text ?? "", forKey: "Where would you like to live")
        paramsBody.setValue(self.textViewMessage.text ?? "", forKey: "Message")
        paramsBody.setValue(self.acceptedTerms.description ?? "", forKey: "I accept Burbank’s privacy policy and wish to receive Burbank’s latest news and offers on my email.")
     //   paramsBody.setValue(self.whereWouldYouLiveTF.text ?? "", forKey: "Build")
        
        
        
        params.setValue(paramsBody, forKey: "Body")
        
        _ = Networking.shared.POST_request(url: ServiceAPI.shared.URL_Enquiry, parameters: params, userInfo: nil, success: { (json, response) in
            
            if let result: AnyObject = json {
                let result = result as! NSDictionary
                if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {
//                    self.navigationController?.popViewController(animated: true)
                    let message = result.value(forKey: "message") as? String ?? ""
                    let alertController = UIAlertController(title: "", message: message, preferredStyle:UIAlertController.Style.alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                      { action -> Void in
                        self.navigationController?.popViewController(animated: true)
                    })
                    self.present(alertController, animated: true, completion: nil)
//                    showToast("Enquiry Submitted Successfully.")
                }else {
                    print(log: "couldn't get recent searches")
                }
            }else {
            }
        }, errorblock: { (error, isJSONerror) in
            
            if isJSONerror {
                
            }else {
                
            }
        }, progress: nil)
        
    }
    
    func enquireDisplayHomes () -> Void {
        
        let params = NSMutableDictionary.init()
        params.setValue(self.frstNameTF.text ?? "", forKey: "FirstName")
        if lastName != ""  {
            params.setValue(lastName, forKey: "LastName")
        }else{
            params.setValue(self.lastNameTF.text ?? "", forKey: "LastName")
        }
        params.setValue(self.emailTF.text ?? "", forKey: "Email")
        params.setValue(self.phoneTF.text ?? "", forKey: "PhoneNumber")
        params.setValue(self.whereWouldYouLiveTF.text ?? "", forKey: "Build")
        params.setValue(self.textViewMessage.text ?? "", forKey: "Message")
        params.setValue("DisplayHomesEnquiry", forKey: "FormName")
        params.setValue(self.acceptedTerms, forKey: "IsConsent")
        params.setValue(stateName, forKey: "State")
        params.setValue("iOS - App", forKey: "EnquiryType")
        params.setValue("", forKey: "Hearaboutus")
        params.setValue(self.homeDesignDetails?.lsthouses?.houseName ?? "", forKey: "HouseName")
        params.setValue("DisplayLocation-\(selected_Estate)", forKey: "Notes")
//        params.setValue("enquiry", forKey: "Subject") // "mobile app enquiry - contact us"
//        params.setValue("Mobile app Enquiry - Contact Us", forKey: "Subject")
//    https://www.burbank.com.au/south-australia/display-location/miravale-estate/
//        let estateName = selected_Estate.replacingOccurrences(of: "  Estate", with: "- estate")
        selected_Estate = selected_Estate.trim()
        let estateName = selected_Estate.replacingOccurrences(of: " ", with: "-").lowercased()
        
        params.setValue("MyPlace App enquiry - \(My_Place3DBASEURL)/\(stateName)/display-location/\(estateName)", forKey: "Subject")
        
//        params.setValue("MyPlace App enquiry - \(My_Place3DBASEURL)/\(stateName)/homedetails/housename.\(self.homeDesignDetails?.lsthouses?.houseName ?? "");housesize.\(self.homeDesignDetails?.lsthouses?.houseSize ?? 0);displayId.\(self.homeDesignDetails?.lsthouses?.id ?? 0)/", forKey: "Subject")


        params.setValue("", forKey: "Header")
        params.setValue("", forKey: "ReferralSource")
        let paramsBody = NSMutableDictionary.init()
        paramsBody.setValue("\(self.frstNameTF.text ?? "") \( self.lastNameTF.text ?? "")", forKey: "Name")
        paramsBody.setValue(self.emailTF.text ?? "", forKey: "Email")
        paramsBody.setValue(self.phoneTF.text ?? "", forKey: "PhoneNumber")
        paramsBody.setValue(self.whatToBuildTF.text ?? "", forKey: "I'm interested in")
        paramsBody.setValue(self.whereWouldYouLiveTF.text ?? "", forKey: "Where would you like to live")
        paramsBody.setValue(self.textViewMessage.text ?? "", forKey: "Message")
        paramsBody.setValue(self.acceptedTerms.description, forKey: "I accept Burbank’s privacy policy and wish to receive Burbank’s latest news and offers on my email.")
      //  paramsBody.setValue(self.whereWouldYouLiveTF.text ?? "", forKey: "Build")
        params.setValue(paramsBody, forKey: "Body")
        _ = Networking.shared.POST_request(url: ServiceAPI.shared.URL_Enquiry, parameters: params, userInfo: nil, success: { (json, response) in
            
            if let result: AnyObject = json {
                
                let result = result as! NSDictionary
                
                if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {
                    let message = result.value(forKey: "message") as? String ?? ""
//                    AlertManager.sharedInstance.showAlert(alertMessage: message, title: "")
                   
                    let alertController = UIAlertController(title: "", message: message, preferredStyle:UIAlertController.Style.alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                      { action -> Void in
                        self.navigationController?.popViewController(animated: true)
                    })
                    self.present(alertController, animated: true, completion: nil)

                    
//                    showToast("Enquiry Submitted Successfully.")
                }else {
                    
                    print(log: "couldn't get recent searches")
                }
                
            }else {
                
            }
            
        }, errorblock: { (error, isJSONerror) in
            
            if isJSONerror {
                
            }else {
                
            }
        }, progress: nil)
        
    }
    
    func updateProfileDetails () {
        
        var params = [String: Any]()
        
        params["FirstName"] = appDelegate.userData?.user?.userFirstName
        params["LastName"] = appDelegate.userData?.user?.userLastName
        
        params["Email"] = appDelegate.userData?.user?.userEmail
        params["Password"] = appDelegate.userData?.user?.userPassword
        params["PhoneNumber"] =  self.phoneTF.text
        params["FacebookId"] = appDelegate.userData?.user?.userFacebookID
        params["GoogleId"] = appDelegate.userData?.user?.userGoogleID
        
        if appDelegate.userData?.user?.userGoogleID?.count ?? 0 > 0 {
            params["LoginType"] = "google"
        }else if appDelegate.userData?.user?.userFacebookID?.count ?? 0 > 0 {
            params["LoginType"] = "facebook"
        }else {
            params["LoginType"] = "email"
        }
        
        params["ImageContent"] = ""
        
        
        _ = Networking.shared.POST_request(url: ServiceAPI.shared.URL_updateUser, parameters: params as NSDictionary, userInfo: nil, success: { (json, response) in
            
            if let result: AnyObject = json {
                
                let result = result as! NSDictionary
                
                if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {
                    
                    self.phoneNumberNotAvailable = false
                    if let user = appDelegate.userData?.user {
                        ProfileDataManagement.shared.getProfileDetails(user, succe: nil)
                    }
                    
                }else {
                    
                }
            }else {
                
            }
            
        }, errorblock: { (error, isJSONerror) in
            
            if isJSONerror {
                
            }else {
                
            }
            
        }, progress: nil)
        
        
    }
    
    
}





extension EnquireNowVC: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.text.count > 0 {
            textViewPlaceholder.text = ""
        }else {
            textViewPlaceholder.text = "Message"
        }
        
    }
    
}
