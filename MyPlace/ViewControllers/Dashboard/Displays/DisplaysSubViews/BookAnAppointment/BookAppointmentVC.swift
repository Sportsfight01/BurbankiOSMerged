//
//  BookAppointmentVC.swift
//  BurbankApp
//
//  Created by Naveen Kourampalli on 18/06/21.
//  Copyright © 2021 Sreekanth tadi. All rights reserved.
//

import UIKit

class BookAppointmentVC: HeaderVC,UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    
    var acceptedTerms : Bool = false
    @IBOutlet weak var iconAcceptTerms: UIImageView!
    @IBOutlet weak var backBtnView: UIView!
  @IBOutlet weak var navTopConstraint: NSLayoutConstraint!
  var isFromFavorites : Bool = false
    @IBOutlet weak var titleCardView: UIView!
    @IBOutlet weak var titleNameLBL: UILabel!
    @IBOutlet weak var streetNameLBL: UILabel!
    @IBOutlet weak var tirlCardHeight: NSLayoutConstraint!
    
    @IBOutlet weak var topCardView: UIView!
    @IBOutlet weak var titleLBL: UILabel!
    
    @IBOutlet weak var chooseDateAndTimeCard: UIView!
    @IBOutlet weak var dateLBLInChooseDateCard: UILabel!
    @IBOutlet weak var chooseYourDateBTN: UIButton!
    @IBOutlet weak var mrngBTN: UIButton!
    
    @IBOutlet weak var reqAppointmentCard: UIView!
    @IBOutlet weak var dateLBLinRqstCard: UILabel!
    @IBOutlet weak var appointmentMSGInDateAndTimeCARDLBL: UILabel!
    
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var mobileNumberTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var whereWouldyouLikeToLiveTF: UITextField!
    
    @IBOutlet weak var timeLBL: UILabel!
    @IBOutlet weak var commentsTV: UITextView!
    @IBOutlet weak var requestBTN: UIButton!
    @IBOutlet weak var middleOftheBTN: UIButton!
    @IBOutlet weak var afternoonBTN: UIButton!
    
    @IBOutlet weak var appointmentMSGInReqCardLBL: UILabel!
    @IBOutlet weak var successCard: UIView!
    @IBOutlet weak var estateNameLBL: UILabel!
    @IBOutlet weak var dateInSuccesCardLBL: UILabel!
    @IBOutlet weak var timeInSuccessCardLBL: UILabel!
    
    @IBOutlet weak var successMSGLBL: UILabel!
    @IBOutlet weak var dateCardView: UIView!
    @IBOutlet weak var selecteTimeBTN: UIButton!
    
    var datePicker: UIDatePicker?
    var datePickerConstraints = [NSLayoutConstraint]()
    
    @IBOutlet weak var datePickerView: UIView!
    var isSelectedDate  : Bool = false
    var isSelectedTime : Bool = false
    
    @IBOutlet weak var successIMGWidth: NSLayoutConstraint!
    @IBOutlet weak var successIMG: UIImageView!
    
    @IBOutlet weak var backBTN: UIButton!
    @IBOutlet weak var backIconBtn: UIButton!
    @IBOutlet weak var backBTNCardWidthConstant: NSLayoutConstraint!
  
    var lastName = appDelegate.userData?.user?.userLastName ?? ""

    var isRequested : Bool = false
    var selectedDate = Date()
    var displayHomeData: [houseDetailsByHouseType]?
    //    {
    //        didSet {
    //            fillAllDisplayHomeDetails()
    //        }
    //    }
    var estateName = ""
    let pickerView = UIPickerView()
    var pickerViewDataSource : [String] = [""]
    var stateName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        self.chooseDateAndTimeCard.isHidden = true
        self.successCard.isHidden = true
        self.reqAppointmentCard.isHidden = true
        self.successCard.isHidden = true
        self.chooseYourDateBTN.isHidden = true
        self.mrngBTN.isHidden = false
        self.successCard.isHidden = true
        self.afternoonBTN.isHidden = false
        self.middleOftheBTN.isHidden = false
        appointmentMSGInDateAndTimeCARDLBL.isHidden = true
        showDatePicker()
        print(displayHomeData)
        fillAllDisplayHomeDetails ()
        self.commentsTV.delegate = self
        self.commentsTV.textColor = APPCOLORS_3.Black_BG
        self.commentsTV.text = "Comments"
        self.successIMGWidth.constant = 0
        HeaderVC().addBreadCrumb(from: "Book an appointment")
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("handleBackBtnNaviogation"), object: nil, queue: nil, using:updatedNotification)
        showUserDetails()
      
      if isFromFavorites{
        headerLogoText = "DisplayHomes"
        backBtnView.isHidden = true
        isFromProfile = true
          navTopConstraint.constant = 120
      self.addBreadCrumb(from: "Book an appointment")
        if btnBack.isHidden {
            showBackButton()
            btnBack.addTarget(self, action: #selector(handleNavBackBtn), for: .touchUpInside)
            btnBackFull.addTarget(self, action: #selector(handleNavBackBtn), for: .touchUpInside)
        }
     //  headerLogoText = "Favorites"
      }else {
        backBtnView.isHidden = false
        navTopConstraint.constant = 0
        containerView?.isHidden = true
        headerView_header.isHidden = true
        headerViewHeight = 0
      
      }
        
        stateName = kUserStateName.lowercased().trim().replacingOccurrences(of: " ", with: "-")
        if kUserStateName.contains("NSW & ACT"){
            
            pickerViewDataSource = nswRegions
            stateName = "nsw"
            
        }else if kUserStateName.contains("South-Australia"){
            stateName = "south-australia"
            pickerViewDataSource = southaustraliaRegions
        }else if kUserStateName.contains("Queensland"){
            stateName = "queensland"
            pickerViewDataSource = queenslandRegions
        }else if kUserStateName.contains("Victoria"){
            stateName = "victoria"
            pickerViewDataSource = victoriaRegions
        }
        
        whereWouldyouLikeToLiveTF.inputView = pickerView
        pickerView.delegate = self
        pickerView.dataSource = self
        whereWouldyouLikeToLiveTF.attributedPlaceholder = NSAttributedString(string: "Where would you like to live?", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
        
        self.whereWouldyouLikeToLiveTF.setupRightImage(imageName: "Ico-Downarrow-1")
       
        iconAcceptTerms.layer.cornerRadius = 5.0
    }
//   func handleUISetup()
//    {
//        //cardView of viewElements
//        [firstNameTF,lastNameTF,mobileNumberTF,emailTF,whereWouldyouLikeToLiveTF, commentsTV].forEach { view in
//            if #available(iOS 13.0, *) {
//                view?.cardView(cornerRadius: radius_5 , shadowOpacity: 0.3 , shadowColor: UIColor.systemGray3.cgColor)
//            } else {
//                // Fallback on earlier versions
//                view?.cardView(cornerRadius: radius_5 , shadowOpacity: 0.3)
//            }
//        }
//    }
    @IBAction func btnAcceptTermsAction(_ sender: UIButton) {
        
        if acceptedTerms {
            
            iconAcceptTerms.image = imageUnCheckedEnquiry
            acceptedTerms = false
        }else {
            
            acceptedTerms = true
            iconAcceptTerms.image = imageCheckedEnquiry
        }
    }
    
    
    func updatedNotification(notification:Notification) -> Void  {
        self.navigationController?.popViewController(animated: true)
    }
  @objc func handleNavBackBtn()
  {
    self.navigationController?.popViewController(animated: true)
  }
    func textViewDidBeginEditing(_ textView: UITextView) {
       // self.commentsTV.textColor = APPCOLORS_3.Black_BG
        self.commentsTV.text = ""
    }
    func showUserDetails(){
        self.firstNameTF.text = appDelegate.userData?.user?.userFirstName?.capitalized
        self.lastNameTF.text = appDelegate.userData?.user?.userLastName?.capitalized
        self.emailTF.text = appDelegate.userData?.user?.userEmail ?? ""
        self.mobileNumberTF.text = appDelegate.userData?.user?.userPhone ?? ""
        
        if self.lastNameTF.text != "" {
         setAppearanceFor(view: lastNameTF, backgroundColor: APPCOLORS_3.LightGreyDisabled_BG, textColor: APPCOLORS_3.Black_BG, textFont: FONT_TEXTFIELD_BODY(size: FONT_13))
         self.lastNameTF.isUserInteractionEnabled = false
        }else{
         self.lastNameTF.isUserInteractionEnabled = true
         setAppearanceFor(view: lastNameTF, backgroundColor: .clear, textColor: APPCOLORS_3.Black_BG, textFont: FONT_TEXTFIELD_BODY(size: FONT_13))
        }
        
        if self.firstNameTF.text != "" {
            setAppearanceFor(view: firstNameTF, backgroundColor: APPCOLORS_3.LightGreyDisabled_BG, textColor: APPCOLORS_3.Black_BG, textFont: FONT_TEXTFIELD_BODY(size: FONT_13))
         self.firstNameTF.isUserInteractionEnabled = false
        }else{
         self.firstNameTF.isUserInteractionEnabled = true
         setAppearanceFor(view: firstNameTF, backgroundColor: .clear, textColor: APPCOLORS_3.Black_BG, textFont: FONT_TEXTFIELD_BODY(size: FONT_13))
        }
        
        if self.emailTF.text != "" {
         setAppearanceFor(view: emailTF, backgroundColor: APPCOLORS_3.LightGreyDisabled_BG, textColor: APPCOLORS_3.Black_BG, textFont: FONT_TEXTFIELD_BODY(size: FONT_13))
         self.emailTF.isUserInteractionEnabled = false
        }else{
         self.emailTF.isUserInteractionEnabled = true
         setAppearanceFor(view: emailTF, backgroundColor: .clear, textColor: APPCOLORS_3.Black_BG, textFont: FONT_TEXTFIELD_BODY(size: FONT_13))
        }
        
    }
    
    func fillAllDisplayHomeDetails () {
        print(displayHomeData)
        NotificationCenter.default.post(name: NSNotification.Name("changeBreadCrumbs"), object: nil, userInfo: ["breadcrumb" :"Book an Appointment"])
        var streetNames =  [String]()
        for i in 0..<(displayHomeData?.count)! {
            let houseNames = displayHomeData?[i].houseName
            let houseSize = displayHomeData?[i].houseSize
            let house = "\(houseNames ?? "") \(houseSize ?? "")"
            streetNames.append(house)
        }
        let joinedStreetNames = streetNames.joined(separator: ", ")
        self.streetNameLBL.text = "\(displayHomeData?[0].street ?? ""), \n\(displayHomeData?[0].suburb ?? "")"
        self.streetNameLBL.textColor = APPCOLORS_3.GreyTextFont
        
        let font:UIFont? = FONT_LABEL_HEADING(size: FONT_11)
        let fontSuper:UIFont? = FONT_LABEL_SUB_HEADING(size: FONT_9)
        let boldFontAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: font]
        let normalFontAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: fontSuper]
        let partOne = NSMutableAttributedString(string: displayHomeData?[0].displayEstateName.uppercased() ?? "" , attributes: boldFontAttributes as [NSAttributedString.Key : Any])
        let partTwo = NSMutableAttributedString(string: "\nON DISPLAY: \(joinedStreetNames)", attributes: normalFontAttributes as [NSAttributedString.Key : Any])
        
        let combination = NSMutableAttributedString()
        
        combination.append(partOne)
        combination.append(partTwo)
        
        self.titleNameLBL.attributedText = combination
        self.estateNameLBL.text = displayHomeData?[0].displayEstateName.uppercased()
        
    }
    func showDatePicker() {
        datePicker = UIDatePicker()
        datePicker?.date = Date()
        datePicker?.locale = .current
        datePicker?.tintColor = APPCOLORS_3.Orange_BG
        datePicker?.datePickerMode = .date
        datePicker?.minimumDate = Date()
        let dateFormater: DateFormatter = DateFormatter()
        dateFormater.dateFormat = "MM/dd/yyyy"
        let stringFromDate: String = dateFormater.string(from: datePicker!.date) as String
        if #available(iOS 14.0, *) {
            datePicker?.preferredDatePickerStyle = .inline
        } else {
            // Fallback on earlier versions
        }
        //        datePicker?.preferredDatePickerStyle = .compact
        //        datePicker?.preferredDatePickerStyle = .inline
        datePicker?.addTarget(self, action: #selector(handleDateSelection), for: .valueChanged)
        addDatePickerAsSubview()
    }
    func addDatePickerAsSubview() {
        guard let datePicker = datePicker else { return }
        self.datePickerView.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 14.0, *) {
            updateDatePickerConstraints()
        } else {
            // Fallback on earlier versions
        }
    }
    
    @available(iOS 14.0, *)
    func updateDatePickerConstraints() {
        guard let datePicker = datePicker else { return }
        
        // Remove any previously set constraints.
        self.datePickerView.removeConstraints(datePickerConstraints)
        datePickerConstraints.removeAll()
        
        // Set new constraints depending on the date picker style.
        datePickerConstraints.append(datePicker.centerYAnchor.constraint(equalTo: self.datePickerView.centerYAnchor, constant: 10))
        
        if datePicker.preferredDatePickerStyle != .inline {
            datePickerConstraints.append(datePicker.centerXAnchor.constraint(equalTo: self.datePickerView.centerXAnchor))
        } else {
            //            datePickerConstraints.append(datePicker.topAnchor.constraint(equalTo: self.dateCardView.topAnchor, constant: 0))
//                datePickerConstraints.append(datePicker.bottomAnchor.constraint(equalTo: self.datePickerView.bottomAnchor, constant: -40))
            
            datePickerConstraints.append(datePicker.leadingAnchor.constraint(equalTo: self.datePickerView.leadingAnchor, constant: 8))
            datePickerConstraints.append(datePicker.trailingAnchor.constraint(equalTo: self.datePickerView.trailingAnchor, constant: -8))
        }
        
        // Activate all constraints.
        NSLayoutConstraint.activate(datePickerConstraints)
    }
    
    
    @objc func handleDateSelection() {
        guard let picker = datePicker else { return }
        picker.tintColor = .orange
        print("Selected date/time:", picker.date)
        let dateFormater: DateFormatter = DateFormatter()
        dateFormater.dateFormat = "EEEE, MMM dd yyyy"
        
        let stringFromDate: String = dateFormater.string(from: picker.date) as String
        print("Selected date/time:----", stringFromDate)
        self.dateLBLinRqstCard.text = stringFromDate
        self.dateInSuccesCardLBL.text = stringFromDate
        self.dateLBLInChooseDateCard.text = stringFromDate
        isSelectedDate = true
        
        
    }
    
    @IBAction func didTappedOnSelectTimeBTN(_ sender: UIButton) {
        //        self.dateCardView.removeConstraints(datePickerConstraints)
        if  isSelectedDate{
            self.datePicker?.isHidden = true
            self.dateCardView.isHidden = true
            self.chooseDateAndTimeCard.isHidden = false
            self.reqAppointmentCard.isHidden = true
            self.titleLBL.text = "CHOOSE YOUR TIME"
        } else{
            let dateFormater: DateFormatter = DateFormatter()
            dateFormater.dateFormat = "EEEE, MMMM dd yyyy"
            let stringFromDate: String = dateFormater.string(from:Date()) as String
            print("Selected date/time:----", stringFromDate)
            self.dateLBLinRqstCard.text = stringFromDate
            self.dateInSuccesCardLBL.text = stringFromDate
            self.dateLBLInChooseDateCard.text = stringFromDate
            self.datePicker?.isHidden = true
            self.dateCardView.isHidden = true
            self.chooseDateAndTimeCard.isHidden = false
            self.reqAppointmentCard.isHidden = true
            self.titleLBL.text = "CHOOSE YOUR TIME"
             isSelectedDate = true
        }
    }
    @IBAction func didTappedOnBackBTN(_ sender: UIButton) {
        
        if isSelectedDate{
            self.datePicker?.isHidden = false
            self.dateCardView.isHidden = false
            self.chooseDateAndTimeCard.isHidden = true
            self.reqAppointmentCard.isHidden = true
            self.successCard.isHidden = true
            isSelectedDate = false
            titleLBL.text = "CHOOSE YOUR DATE"
            //self.navigationController?.popViewController(animated: true)
        }else if isSelectedTime{
            self.datePicker?.isHidden = true
            self.dateCardView.isHidden = true
            self.chooseDateAndTimeCard.isHidden = false
            self.reqAppointmentCard.isHidden = true
            self.successCard.isHidden = true
            self.isSelectedTime = false
            isSelectedDate = true
            titleLBL.text = "CHOOSE YOUR TIME"
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        //        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func didTappedOnDateBTN(_ sender: UIButton) {
        showDatePicker()
    }
    @IBAction func didTappedOnTimeBTNS(_ sender: UIButton) {
        let arrOfTimeBtns = [mrngBTN,middleOftheBTN,afternoonBTN]
        
        arrOfTimeBtns.forEach { btn in
            if btn == sender
            {
                sender.backgroundColor = APPCOLORS_3.EnabledOrange_BG
                sender.setTitleColor(.white, for: .normal)
            }
            else {
                btn?.backgroundColor = .white
                btn?.setTitleColor(APPCOLORS_3.GreyTextFont, for: .normal)
            }
        }
//        middleOftheBTN.backgroundColor = .white
//        mrngBTN.backgroundColor = .white
//        afternoonBTN.backgroundColor = .white
//        middleOftheBTN.setTitleColor(APPCOLORS_3.Orange_BG, for: .normal)
//        mrngBTN.setTitleColor(APPCOLORS_3.Orange_BG, for: .normal)
//        afternoonBTN.setTitleColor(APPCOLORS_3.Orange_BG, for: .normal)
                
        
        self.chooseDateAndTimeCard.isHidden = true
        self.dateCardView.isHidden = true
        self.reqAppointmentCard.isHidden = false
        self.successCard.isHidden = true
        self.timeLBL.text = sender.titleLabel?.text
        self.timeInSuccessCardLBL.text = sender.titleLabel?.text
        self.titleLBL.text = "CHOOSE YOUR TIME"
        self.isSelectedDate = false
        self.isSelectedTime = true
    }
    
    @IBAction func didTappedONRequestBTN(_ sender: UIButton) {
        if firstNameTF.text?.trim() == "" {
        
            AlertManager.sharedInstance.showAlert(alertMessage: "Please enter first name")
        }else if lastNameTF.text?.trim() == "" {
            
            AlertManager.sharedInstance.showAlert(alertMessage: "Please enter last name")
        }else if mobileNumberTF.text?.trim() == "" {
            
            AlertManager.sharedInstance.showAlert(alertMessage: "Please enter phone number")
        }else if !(mobileNumberTF.text?.trim().isPhoneNumber)! {
            
            AlertManager.sharedInstance.showAlert(alertMessage: "Please enter valid phone number")
        }else if (mobileNumberTF.text?.trim().count ?? 0) > 14 {
            AlertManager.sharedInstance.showAlert(alertMessage: "Phone number should be a maximum of 14 characters length")
        }else if emailTF.text?.trim() == "" {
            
            AlertManager.sharedInstance.showAlert(alertMessage: "Please enter email")
        }else if emailTF.text?.trim().isValidEmail() == false {
            
            AlertManager.sharedInstance.showAlert(alertMessage: "Please enter valid email id")
        }
        else if whereWouldyouLikeToLiveTF.text?.trim() == "" {
            
            AlertManager.sharedInstance.showAlert(alertMessage: "Please select where would you like to live?")
        }
        else if !self.acceptedTerms{
            AlertManager.sharedInstance.showAlert(alertMessage: "Please accept Burbank's privacy policy", title: "")
        }else{
            self.enquireDisplayHomes { successss in
                if successss{
                    self.submitAppointment()
                }
            }
        }
        
        
        
    }
    
    func submitAppointment(){
        
        let params1 = NSMutableDictionary()
        params1.setValue(kUserState, forKey: "stateId")
        params1.setValue(kUserID, forKey: "userId")
        params1.setValue(self.displayHomeData?[0].id ?? "", forKey: "displayId")
        params1.setValue(commentsTV.text == "Comments" ? "" : commentsTV.text, forKey: "comments")
        params1.setValue(self.dateLBLinRqstCard.text ?? "", forKey: "date")
        params1.setValue(self.timeLBL.text ?? "", forKey: "time")
        params1.setValue(self.firstNameTF.text ?? "", forKey: "FirstName")
        params1.setValue(self.lastNameTF.text ?? "", forKey: "LastName")
        params1.setValue(self.mobileNumberTF.text ?? "", forKey: "Phone")
        params1.setValue(self.emailTF.text ?? "", forKey: "Email")
        params1.setValue(self.whereWouldyouLikeToLiveTF.text ?? "", forKey: "Where would you like to live")
        params1.setValue(self.whereWouldyouLikeToLiveTF.text ?? "", forKey: "Build")
        params1.setValue(self.acceptedTerms, forKey: "IsPrivacyConsent")
//        let noteValue = "DisplayLocation-\(self.displayHomeData?[0].displayEstateName ?? "")~AppointmentTime-\(self.timeLBL.text ?? "")~Date-\(self.dateLBLinRqstCard.text ?? "")"
//        //        &AppointmentTime-\(self.timeLBL.text ?? "")&Date-\(self.dateLBLinRqstCard.text ?? "")
//        params1.setValue(noteValue, forKey: "Notes")
        
        _ = Networking.shared.POST_request(url: ServiceAPI.shared.URL_HouseAppointment(), parameters: params1, userInfo: nil, success: { (json, response) in
            if let result: AnyObject = json {
                
                let result = result as! NSDictionary
                
                if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {
                    let houseDetailsByHouseType1 = result["houseDetailsByHouseType"] as? String ?? ""
                    self.titleLBL.text = "REQUEST SUCCESSFUL"
                    self.backBTNCardWidthConstant.constant = 35
                    
                    self.backBTN.setTitle("X", for: .normal)
                    self.backBtnView.backgroundColor = APPCOLORS_3.Body_BG
                    self.backBtnView.layer.borderWidth = 1.0
                    self.backBtnView.layer.borderColor = APPCOLORS_3.Orange_BG.cgColor
                    self.dateCardView.isHidden = true
                    self.chooseDateAndTimeCard.isHidden = true
                    self.reqAppointmentCard.isHidden = true
                    self.successCard.isHidden = false
                    self.successMSGLBL.text = houseDetailsByHouseType1
                    //                          "Thank you for your appointment request. A New Home Consultant will be in touch with your precise appointment times."
                    self.isSelectedDate = false
                    self.isSelectedTime = false
                    self.isRequested = true
                    self.successIMGWidth.constant = 30
                    self.backIconBtn.isHidden = true
                    
                    self.backBTN.setTitleColor(APPCOLORS_3.Orange_BG, for: .normal)
                    self.tirlCardHeight.constant = 0
                    AlertManager.sharedInstance.showAlert(alertMessage: houseDetailsByHouseType1, title: "")
                    
                }else {
                    self.titleLBL.text = "REQUEST DENIED"
                    self.backBTN.setTitle("X", for: .normal)
                    self.backBTN.backgroundColor = APPCOLORS_3.Body_BG
                }
            }
        }, errorblock: { (error, isJSONerror) in
            
            if isJSONerror { }
            else { }
            
        }, progress: nil)
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
        whereWouldyouLikeToLiveTF.text = pickerViewDataSource[row]
//        whereWouldYouLiveTF.resignFirstResponder()
    }
    
    
}

extension BookAppointmentVC{
    func enquireDisplayHomes( callBack: @escaping ((_ successss: Bool) -> Void)) {
        
        let params = NSMutableDictionary.init()
        params.setValue(self.firstNameTF.text ?? "", forKey: "FirstName")
        if lastName != ""  {
            params.setValue(lastName, forKey: "LastName")
        }else{
            params.setValue(self.lastNameTF.text ?? "", forKey: "LastName")
        }
        params.setValue(self.emailTF.text ?? "", forKey: "Email")
        params.setValue(self.mobileNumberTF.text ?? "", forKey: "PhoneNumber")
        params.setValue( self.whereWouldyouLikeToLiveTF.text ?? "", forKey: "Build")
        params.setValue(self.commentsTV.text ?? "", forKey: "Message")
        params.setValue("DisplayHomesAppointment", forKey: "FormName")
        
        params.setValue(self.acceptedTerms, forKey: "IsConsent")
        
        params.setValue(stateName, forKey: "State")
        params.setValue("iOS - App", forKey: "EnquiryType")
        params.setValue("", forKey: "Hearaboutus")
        params.setValue(displayHomeData?[0].houseName ?? "", forKey: "HouseName")
        let noteValue = "DisplayLocation-\(self.displayHomeData?[0].displayEstateName ?? "")~AppointmentTime-\(self.timeLBL.text ?? "")~Date-\(self.dateLBLinRqstCard.text ?? "")"
//        &AppointmentTime-\(self.timeLBL.text ?? "")&Date-\(self.dateLBLinRqstCard.text ?? "")
        params.setValue(noteValue, forKey: "Notes")
        
        //        params.setValue("enquiry", forKey: "Subject") // "mobile app enquiry - contact us"
        
//        params.setValue("Mobile app Enquiry - Contact Us", forKey: "Subject")
//        params.setValue("MyPlace App enquiry - \(My_Place3DBASEURL)/\(stateName)/homedetails/housename.\(displayHomeData?[0].houseName ?? "");housesize.\(displayHomeData?[0].houseSize ?? "");displayId.\(displayHomeData?[0].id ?? "")/", forKey: "Subject")
//        let estateName = (self.displayHomeData?[0].displayEstateName ?? "").replacingOccurrences(of: "  Estate", with: "- estate")
    
        let estate = (self.displayHomeData?[0].displayEstateName ?? "").dropLast()
        let estateName = estate.replacingOccurrences(of: " ", with: "-").lowercased()

        params.setValue("MyPlace App enquiry - \(My_Place3DBASEURL)/\(stateName)/display-location/\(estateName)", forKey: "Subject")
        params.setValue("", forKey: "Header")
        params.setValue("", forKey: "ReferralSource")
        let paramsBody = NSMutableDictionary.init()
        paramsBody.setValue("\(self.firstNameTF.text ?? "") \( self.lastNameTF.text ?? "")", forKey: "Name")
        paramsBody.setValue(self.emailTF.text ?? "", forKey: "Email")
        paramsBody.setValue(self.mobileNumberTF.text ?? "", forKey: "PhoneNumber")
        paramsBody.setValue(displayHomeData?[0].houseName ?? "", forKey: "I'm interested in")
        paramsBody.setValue(self.whereWouldyouLikeToLiveTF.text ?? "", forKey: "Where would you like to live")
        paramsBody.setValue(self.commentsTV.text ?? "", forKey: "Message")
        paramsBody.setValue(self.acceptedTerms, forKey: "I accept Burbank’s privacy policy and wish to receive Burbank’s latest news and offers on my email.")
      //  paramsBody.setValue(self.whereWouldYouLiveTF.text ?? "", forKey: "Build")
        params.setValue(paramsBody, forKey: "Body")
        
        
        _ = Networking.shared.POST_request(url: ServiceAPI.shared.URL_Enquiry, parameters: params, userInfo: nil, success: { (json, response) in
            
            if let result: AnyObject = json {
                
                let result = result as! NSDictionary
                
                if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {
                    
                    callBack (true)
//                    showToast("Enquiry Submitted Successfully.")
                }else {
                    callBack (true)
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
}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


