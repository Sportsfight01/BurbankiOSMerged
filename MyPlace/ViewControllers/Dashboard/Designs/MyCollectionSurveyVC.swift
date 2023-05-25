//
//  MyCollectionSurveyVC.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 26/03/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit

//HomeDesignQuiz
class MyCollectionSurveyVC: HeaderVC {
  
  //MARK : - Properties
    
  @IBOutlet weak var mainView : UIView!
  @IBOutlet weak var btnDesignsCount: UIButton!
  @IBOutlet weak var btnNext: UIButton!
  @IBOutlet weak var btnPrevious: UIButton!
  @IBOutlet weak var viewRecentSearch: UIView!
  @IBOutlet weak var viewHintPopUp: UIView!
  @IBOutlet weak var lBHintPopUp: UILabel!
  @IBOutlet weak var btnHintPopUp: UIButton!
  
  var recentSearch: RecentSearchPopUp?
  
  
  var arrHomeDesigns = [HomeDesignFeature] ()
  var arrVCs = [HomeDesignModalHeaderVC] ()
  
  var navigateToBack: Bool = false
  
  var currentIndex = -1
  
  var designsCount: Int? {
    didSet {
      fillDesignCounts ()
    }
  }
  var isNotSureSelected = "ALL"
  
  
  
  
  //MARK: - ViewLife Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    CodeManager.sharedInstance.sendScreenName(burbank_homeDesigns_screen_loading)
    
    pageUISetup()
    
    headerLogoText = "HomeDesigns"
    
    
    addHeaderOptions(sort: false, map: false, favourites: true, howWorks: false, delegate: self)
    
    if btnBack.isHidden {
      showBackButton()
      btnBack.addTarget(self, action: #selector(handleBackButton(_:)), for: .touchUpInside)
      btnBackFull.addTarget(self, action: #selector(handleBackButton(_:)), for: .touchUpInside)
    }
    
    
    if let _ = AppConfigurations.shared.getHowDoesitWorkURLinMyCollection() {
      self.btnHowWorks.isHidden = false
    }else {
      btnHowWorks.isHidden = true
    }
    
    self.viewHintPopUp.isHidden = true
    
//      var vc: HomeDesignModalHeaderVC?
//      vc = kStoryboardHomeDesigns.instantiateViewController(withIdentifier: "HavingLotVC") as! HavingLotVC
//      vc?.addContentView(toView: self.mainView, with: self)
      
    getCollectionQuiz ()
    
    self.btnDesignsCount.setTitle("", for: .normal)
    
    
    checkForRecentSearchData ()
    
    viewRecentSearch.isHidden = true
      
    
    
    breadcrumbView.delegate = self
    
    breadcrumbView.addBreadcrumb(infoStaicText)
    
      
    //        self.mainView.backgroundColor = .yellow
    
      NotificationCenter.default.addObserver(forName: NSNotification.Name("handleResetDesignsBTN"), object: nil, queue: nil, using:updatedResetDesignsData)
  }
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.btnDesignsCount.layoutIfNeeded()
        
       
        
    }
  
    func updatedResetDesignsData(notification:Notification) -> Void  {
        if self.arrHomeDesigns.count > 0 {
            self.loadVCs()
            getDesignsCount()
            checkForRecentSearchData ()
            viewRecentSearch.isHidden = true
            btnPrevious.backgroundColor = APPCOLORS_3.LightGreyDisabled_BG
            btnNext.backgroundColor = APPCOLORS_3.LightGreyDisabled_BG
        }
    }
    
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    print(log: self.breadcrumbView.arrBreadCrumbs)
    print(log: self.heightCollection?.constant as Any)
    
  }
  
  
  //MARK: - View
  
  func pageUISetup () {
    
      setAppearanceFor(view: btnDesignsCount, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_BUTTON_LIGHT(size: FONT_14))
    
      setAppearanceFor(view: btnNext, backgroundColor: APPCOLORS_3.LightGreyDisabled_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_15))
      setAppearanceFor(view: btnPrevious, backgroundColor: APPCOLORS_3.LightGreyDisabled_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_15))
    
    
    //        let swipeRight = UISwipeGestureRecognizer (target: self, action: #selector(respondToSwipeGesture(gesture:)))
    //        swipeRight.direction = .right
    //        self.mainView.addGestureRecognizer(swipeRight)
    //
    //        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
    //        swipeLeft.direction = .left
    //        self.mainView.addGestureRecognizer(swipeLeft)
    
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "recentSearch" {
      
      recentSearch = segue.destination as? RecentSearchPopUp
    }
  }
  
  
  //MARK: - Button Actions
  
  
  @IBAction func handleBackButton (_ sender: UIButton) {
    
    CodeManager.sharedInstance.sendScreenName(burbank_homeDesigns_newQuiz_back_button_touch)
    
    if arrVCs.count == 0 {
      
      if navigationController?.viewControllers.count == 1 {
        self.tabBarController?.navigationController?.popViewController(animated: true)
      }else {
        self.navigationController?.popViewController(animated: true)
      }
      
    }else {
      
      if currentIndex == 0 {
        
        if arrVCs[0].homeDesignFeature?.selectedAnswer == "" {
          
          if navigationController?.viewControllers.count == 1 {
            self.tabBarController?.navigationController?.popViewController(animated: true)
          }else {
            self.navigationController?.popViewController(animated: true)
          }
          
        }else {
          
          //  self.btnDesignsCount.setTitle("", for: .normal)
           // btnPrevious.backgroundColor = APPCOLORS_3.LightGreyDisabled_BG
            if let havingLotVc = arrVCs.first as? HavingLotVC
            {
                havingLotVc.lotTF.text?.removeAll()
                btnNext.backgroundColor = APPCOLORS_3.LightGreyDisabled_BG
                btnNext.isUserInteractionEnabled = false
            }
          removeValues(from: currentIndex, removeView: false)
          
          showViewAt(index: currentIndex)
          getDesignsCount ()
        }
      }else {
          if currentIndex == 1 {
              btnPrevious.backgroundColor = APPCOLORS_3.LightGreyDisabled_BG
          }
        removeValues(from: currentIndex)
        showViewAt(index: currentIndex-1)
          btnNext.backgroundColor = APPCOLORS_3.EnabledOrange_BG
        getDesignsCount ()
      }
    }
  }
  
  
  @IBAction func handleDesignsButton (_ sender: UIButton) {
    
    CodeManager.sharedInstance.sendScreenName(burbank_homeDesigns_newQuiz_totalDesigns_button_touch)
    
    if (self.designsCount ?? 0) > 0 {
      
      let display: DesignsVC = kStoryboardMain.instantiateViewController(withIdentifier: "DesignsVC") as! DesignsVC
      display.isFromCollection = true
      //        display.myPlaceQuiz = self.myPlaceQuiz
      display.filter = self.filter
      self.navigationController?.pushViewController(display, animated: true)
      
      let selectedDictValues = selectedFeatureValues ()
      for (index , item) in selectedDictValues.enumerated()
      {
        if item.value(forKey: "Answer") as? String == "NOT SURE"
        {
         
          selectedDictValues[index].setValue("I don't mind", forKey: "Answer")
        }
        if item.value(forKey: "MaxValue") != nil
        {
          if item.value(forKey: "MaxValue") as? String == "NOT SURE"
          {
            selectedDictValues[index].setValue("", forKey: "MaxValue")
          }
          if selectedDictValues[index].value(forKey: "Answer") as? String != "I don't mind"
          {
            selectedDictValues[index].setValue("", forKey: "Answer")
          }
       
        }
        if item.value(forKey: "MinValue") != nil
        {
          selectedDictValues[index].setValue("0.00", forKey: "MinValue")
        }
       // sele[index].setValue("", forKey: "MaxValue")
        
      }
       display.selectedFeatures = selectedDictValues
      
      display.displayText = displayText ()
      
    }
  }
  
  @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
    
    if let swipeGesture = gesture as? UISwipeGestureRecognizer
    {
      switch swipeGesture.direction
      {
      case .right:
        //write your logic for right swipe
        print("Swiped right")
        
        self.handlePreviousNextButtonsAction(self.btnPrevious)
        
      case .left:
        //write your logic for left swipe
        print("Swiped left")
        self.handlePreviousNextButtonsAction(self.btnNext)
        
      default:
        break
      }
    }
  }
  
  @IBAction func handlePreviousNextButtonsAction (_ sender: UIButton) {
    
    if sender == btnNext { // Next btn
        btnNext.backgroundColor = APPCOLORS_3.LightGreyDisabled_BG
      print("btnNext Tapped")
      CodeManager.sharedInstance.sendScreenName(burbank_homeDesigns_newQuiz_next_button_touch)
      if btnNext.isUserInteractionEnabled == true { }
      else { return }
    }else { // previous btn
      CodeManager.sharedInstance.sendScreenName(burbank_homeDesigns_newQuiz_previous_button_touch)
        
       // btnPrevious.backgroundColor = currentIndex > 1 ? APPCOLORS_3.EnabledOrange_BG : APPCOLORS_3.LightGreyDisabled_BG
   
      if btnPrevious.isUserInteractionEnabled == true { }
      else { return }
    }
    
    
    if sender == btnNext {
      
      if arrVCs.count > 0 {
//        guard arrVCs[currentIndex].homeDesignFeature?.selectedAnswer != "" else {return}
        if arrVCs[currentIndex].homeDesignFeature?.selectedAnswer != "" || arrVCs[currentIndex].isKind(of: HomeDesignPriceVC.self) {
          
          if (designsCount ?? 0) > 0 {
            if currentIndex == (arrVCs.count-1) || (designsCount ?? 0) <= 7  {
              
              //navigate to designs list
              
              let design: DesignsVC = kStoryboardMain.instantiateViewController(withIdentifier: "DesignsVC") as! DesignsVC
              design.isFromCollection = true
              //        display.myPlaceQuiz = self.myPlaceQuiz
              design.filter = self.filter
              self.navigationController?.pushViewController(design, animated: true)
              
              let selectedDictValues = selectedFeatureValues ()
              for (index , item) in selectedDictValues.enumerated()
              {
                if item.value(forKey: "Answer") as? String == "NOT SURE"
                {
                 
                  selectedDictValues[index].setValue("I don't mind", forKey: "Answer")
                }
                if item.value(forKey: "MaxValue") != nil
                {
                  if item.value(forKey: "MaxValue") as? String == "NOT SURE"
                  {
                    selectedDictValues[index].setValue("", forKey: "MaxValue")
                  }
                  if selectedDictValues[index].value(forKey: "Answer") as? String != "I don't mind"
                  {
                    selectedDictValues[index].setValue("", forKey: "Answer")
                  }
                }
                if item.value(forKey: "MinValue") != nil
                {
                  selectedDictValues[index].setValue("0.00", forKey: "MinValue")
                }
               // sele[index].setValue("", forKey: "MaxValue")
                
              }
               design.selectedFeatures = selectedDictValues
              
              design.displayText = displayText ()
              
            }else {
              
              currentIndex = currentIndex + 1
              
              showViewAt(index: currentIndex)
          
              
            }
          }else {
            
            ActivityManager.showToast("No Designs found, Please refine your selections", self)
          }
        }else {
          
          ActivityManager.showToast(arrVCs[currentIndex].selectionAlertMessage, self)
        }
        
      }else {
        
        //do nothing
        
      }
      
    }else {
      
      if currentIndex > 0 {
        
        currentIndex = currentIndex - 1
        
        showViewAt(index: currentIndex)
      
      }
        
    }
      
      if arrVCs[currentIndex].homeDesignFeature?.selectedAnswer != "" // answer selected
        {
          btnNext.backgroundColor = APPCOLORS_3.EnabledOrange_BG
      }else {
          btnNext.backgroundColor = APPCOLORS_3.LightGreyDisabled_BG
      }
      
      btnPrevious.backgroundColor = currentIndex > 0 ? APPCOLORS_3.EnabledOrange_BG : APPCOLORS_3.LightGreyDisabled_BG
     
  }
  
  @IBAction func handlePopupHintButtonAction (_ sender: UIButton) {
    
    self.viewHintPopUp.isHidden = true
  }
  
  
  
  //MARK: - View Updates
  
  func loadVCs () {
    
    self.removeValues(from: 0)
    //        self.arrVCs.removeAll()
    
    for homeDesignFeature in self.arrHomeDesigns {
      
      addVC(with: homeDesignFeature)
    }
    
    if arrVCs.count > 0 {
      
      //            self.mainCollectionView.reloadData()
      
      UIView.animate(withDuration: 0.2, animations: {
        
        self.showViewAt(index: 0)
        
      }) { (completed) in
        
        self.showViewAt(index: 0)
      }
    }
     
  }
  
  
  func addVC (with homeDesignFeature: HomeDesignFeature) {
    
//      if arrVCs.count == 1
//      {
//          btnPrevious.backgroundColor = APPCOLORS_3.LightGreyDisabled_BG
//          btnNext.backgroundColor = APPCOLORS_3.LightGreyDisabled_BG
//      }
//     if arrVCs.count > 1{
//          btnPrevious.backgroundColor = APPCOLORS_3.EnabledOrange_BG
//          btnNext.backgroundColor = APPCOLORS_3.EnabledOrange_BG
//      }
//
    if self.arrVCs.count > 0 {
      
      var isFeatureExisted = false
      
      
      for existingFeature in self.arrVCs {
        
        if existingFeature.homeDesignFeature?.featureName == homeDesignFeature.featureName {
          
          isFeatureExisted = true
        }
      }
      
      if isFeatureExisted == false {
        self.addView(with: homeDesignFeature)
      }
      
    }else {
      self.addView(with: homeDesignFeature)
     
    }
  }
  
  
    //MARK: Added "I Do Not Want these" option dynamically in every Question in v2.3
    
  func addView (with homeDesignFeature: HomeDesignFeature) {
    
    var vc: HomeDesignModalHeaderVC?
    
    if homeDesignFeature.featureName == "No Of Bedrooms" {
        CodeManager.sharedInstance.sendScreenName(burbank_homeDesigns_detailView_No_Of_Bedrooms_screen)
        if homeDesignFeature.answerOptions.contains(where: { $0.displayAnswer == "I do not want this" })   {
            vc?.isDo_not_want_this_ENABLED = true
        }
      vc = kStoryboardHomeDesigns.instantiateViewController(withIdentifier: "BedroomsVC") as! BedroomsVC
      
    }else if homeDesignFeature.featureName == "Storeys" {
        CodeManager.sharedInstance.sendScreenName(burbank_homeDesigns_detailView_storey_screen)
        if homeDesignFeature.answerOptions.contains(where: { $0.displayAnswer == "I do not want this" })   {
            vc?.isDo_not_want_this_ENABLED = true
        }
        vc = kStoryboardHomeDesigns.instantiateViewController(withIdentifier: "StoreysVC") as! StoreysVC
        
      
    }else if homeDesignFeature.featureName == "Grand Alfresco" {
        CodeManager.sharedInstance.sendScreenName(burbank_homeDesigns_detailView_Alfresco_screen)
        vc = kStoryboardHomeDesigns.instantiateViewController(withIdentifier: "AlfrescoVC") as! AlfrescoVC
      
    }else if homeDesignFeature.featureName == "Study" {
        CodeManager.sharedInstance.sendScreenName(burbank_homeDesigns_detailView_study_screen)
        if homeDesignFeature.answerOptions.contains(where: { $0.displayAnswer == "I do not want this" })   {
            vc?.isDo_not_want_this_ENABLED = true
        }
        vc = kStoryboardHomeDesigns.instantiateViewController(withIdentifier: "StudyVC") as! StudyVC
      
    }else if homeDesignFeature.featureName == "Lot Width" {
        CodeManager.sharedInstance.sendScreenName(burbank_homeDesigns_detailView_lot_width_screen)
        
        vc = kStoryboardHomeDesigns.instantiateViewController(withIdentifier: "HavingLotVC") as! HavingLotVC
        
//      vc = kStoryboardHomeDesigns.instantiateViewController(withIdentifier: "LotVC") as! LotVC
      
    }else if homeDesignFeature.featureName == "Storage (more than 1 per room)" {
        CodeManager.sharedInstance.sendScreenName(burbank_homeDesigns_detailView_storage_more_than_1_room_screen)
        if homeDesignFeature.answerOptions.contains(where: { $0.displayAnswer == "I do not want this" })   {
            vc?.isDo_not_want_this_ENABLED = true
        }
        
      vc = kStoryboardHomeDesigns.instantiateViewController(withIdentifier: "StorageVC") as! StorageVC
      
    }else if homeDesignFeature.featureName == "European Laundry" {
        CodeManager.sharedInstance.sendScreenName(burbank_homeDesigns_detailView_European_Laundry_screen)
        if homeDesignFeature.answerOptions.contains(where: { $0.displayAnswer == "I do not want this" })   {
            vc?.isDo_not_want_this_ENABLED = true
        }
      vc = kStoryboardHomeDesigns.instantiateViewController(withIdentifier: "EuropeanVC") as! EuropeanVC
      
    }else if homeDesignFeature.featureName == "Separate Kids Living Area" {
        CodeManager.sharedInstance.sendScreenName(burbank_homeDesigns_detailView_Separate_Kids_Living_Area_screen)
        if homeDesignFeature.answerOptions.contains(where: { $0.displayAnswer == "I do not want this" })   {
            vc?.isDo_not_want_this_ENABLED = true
        }
        
      vc = kStoryboardHomeDesigns.instantiateViewController(withIdentifier: "SeparateKidsVC") as! SeparateKidsVC
      
    }else if homeDesignFeature.featureName == "Separate Living Area" {
          CodeManager.sharedInstance.sendScreenName(burbank_homeDesigns_detailView_Separate_Kids_Living_Area_screen)
          if homeDesignFeature.answerOptions.contains(where: { $0.displayAnswer == "I do not want this" })   {
              vc?.isDo_not_want_this_ENABLED = true
          }
          
        vc = kStoryboardHomeDesigns.instantiateViewController(withIdentifier: "SeperateLivingAreaVC") as! SeperateLivingAreaVC
        
      }
      else if homeDesignFeature.featureName == "Straight Corridor" {
        CodeManager.sharedInstance.sendScreenName(burbank_homeDesigns_detailView_Straight_Corridor_screen)
        if homeDesignFeature.answerOptions.contains(where: { $0.displayAnswer == "I do not want this" })   {
            vc?.isDo_not_want_this_ENABLED = true
        }
      vc = kStoryboardHomeDesigns.instantiateViewController(withIdentifier: "StraightCorridorVC") as! StraightCorridorVC
      
    }else if homeDesignFeature.featureName == "Living/Meals Entire Rear" {
        CodeManager.sharedInstance.sendScreenName(burbank_homeDesigns_detailView_Living_Meals_Entire_Rear_screen)
        if homeDesignFeature.answerOptions.contains(where: { $0.displayAnswer == "I do not want this" })   {
            vc?.isDo_not_want_this_ENABLED = true
        }
      vc = kStoryboardHomeDesigns.instantiateViewController(withIdentifier: "LivingMealsVC") as! LivingMealsVC
      
    }else if homeDesignFeature.featureName == "Minor Bedrooms Wing" {
        CodeManager.sharedInstance.sendScreenName(burbank_homeDesigns_detailView_Minor_Bedrooms_Wing_screen)
        if homeDesignFeature.answerOptions.contains(where: { $0.displayAnswer == "I do not want this" })   {
            vc?.isDo_not_want_this_ENABLED = true
        }
      vc = kStoryboardHomeDesigns.instantiateViewController(withIdentifier: "MinorBedroomsVC") as! MinorBedroomsVC
      
    }else if homeDesignFeature.featureName == "Bedroom At Front" {
        CodeManager.sharedInstance.sendScreenName(burbank_homeDesigns_detailView_Bedroom_At_Front_screen)
        if homeDesignFeature.answerOptions.contains(where: { $0.displayAnswer == "I do not want this" })   {
            vc?.isDo_not_want_this_ENABLED = true
        }
      vc = kStoryboardHomeDesigns.instantiateViewController(withIdentifier: "MasterBedroomVC") as! MasterBedroomVC
      
    }else if homeDesignFeature.featureName == "Price" {
        CodeManager.sharedInstance.sendScreenName(burbank_homeDesigns_detailView_Price_screen)
        
      vc = kStoryboardHomeDesigns.instantiateViewController(withIdentifier: "HomeDesignPriceVC") as! HomeDesignPriceVC
      
    }else {
      
    }
    
    if let viewCon = vc {
      
      self.arrVCs.append(viewCon)
      viewCon.homeDesignFeature = homeDesignFeature
      
      viewCon.addContentView(toView: self.mainView, with: self)
      
      if vc?.isKind(of: HomeDesignPriceVC.self) ?? false {
        (vc as! HomeDesignPriceVC).setFeaturePriceValues ()
      }
      //            self.mainCollectionView.reloadData()
      selectionCallBacks(vc: viewCon)
    }
  }
  
  
  func hideAllViews () {
    
    for VC in arrVCs {
      VC.view.isHidden = true
    }
  }
  
  
  func showViewAt (index: Int) {
    if arrVCs.count > 0 {
      
    }else {
        btnPrevious.backgroundColor = APPCOLORS_3.LightGreyDisabled_BG
        btnNext.backgroundColor = APPCOLORS_3.EnabledOrange_BG
      return
    }
    
    if index == 0 {
      //self.btnPrevious.alpha = 0.4
      self.btnPrevious.isUserInteractionEnabled = false
        
    }else {
      self.btnPrevious.alpha = 1.0
      self.btnPrevious.isUserInteractionEnabled = true
    }
    
    hideAllViews ()
      
    currentIndex = index
    
    let vc = arrVCs[index]
    
    vc.view.isHidden = false
    self.mainView.bringSubviewToFront(vc.view)
    
    //        self.mainCollectionView.scrollToItem(at: IndexPath (row: currentIndex, section: 0), at: .centeredVertically, animated: true)
    
    vc.reloadView ()
    vc.view.layoutIfNeeded()
    
    vc.reloadView()
    
    //        if let str = vc.homeDesignFeature?.displayString {
    breadcrumbView.changeColorForSelectedBreadCrumb(vc.homeDesignFeature?.displayString ?? "")
    //        }
    
  }
  
  
  func selectionCallBacks (vc: HomeDesignModalHeaderVC) {
    
    vc.selectionUpdates = { (selectedVC) in
      
      CodeManager.sharedInstance.sendScreenName(burbank_homeDesigns_newQuiz_selectedAnswer_button_touch)
      
      let index = self.arrVCs.firstIndex(of: selectedVC)!
      if self.arrVCs.count != index+1 {
        
        self.removeValues(from: index+1)
        
        self.showViewAt(index: index)
        
      }else {
        self.showSelectedValues ()
      }
      
      if selectedVC.isKind(of: HomeDesignPriceVC.self) {
        
        self.getPriceValues(after: 1)
      }else {
        self.getDesignsCount()
          //Previous Next Button Color Changes
          if selectedVC.isKind(of: HavingLotVC.self)//First question
          {
              self.btnPrevious.backgroundColor = APPCOLORS_3.LightGreyDisabled_BG
          }else {
              self.btnPrevious.backgroundColor = APPCOLORS_3.EnabledOrange_BG
          }
          self.btnNext.backgroundColor = APPCOLORS_3.EnabledOrange_BG
          self.btnNext.isUserInteractionEnabled = true
      }
      
    }
  }
  
  
  func removeValues (from index: Int, removeView: Bool = true) {
    
    if arrVCs.count > 0, (index) <= (arrVCs.count-1) {
      
      var arr = [HomeDesignModalHeaderVC] ()
      
      for i in index...arrVCs.count-1 {
        
        let VC = arrVCs[i]
        
        //remove selections also
        VC.clearSelections ()
        
        arr.append(VC)
      }
      
      if removeView {
        for vc in arr {
          if arrVCs.contains(vc) {
            vc.view.removeFromSuperview()
            let arrIndex = arrVCs.firstIndex(of: vc)!
            arrVCs.remove(at: arrIndex)
          }
        }
      }
    }
    showSelectedValues ()
  }
  
  
  func showSelectedValues () {
    
    addBreadCrumb(from: displayText())
    
    //        labelInfo.text = displayText ()
    //
    //        labelInfo.layoutIfNeeded()
    
    mainView.layoutIfNeeded()
    
    //        mainCollectionView.layoutIfNeeded()
    
    if currentIndex > -1, (arrVCs.count-1) >= currentIndex {
      breadcrumbView.changeColorForSelectedBreadCrumb(arrVCs[currentIndex].homeDesignFeature?.displayString ?? "")
    }
    
  }
  
  private func displayText () -> String {
    
    var displayValue = ""
    
    for VC in arrVCs {
        displayValue = addSpaceandnewValue(displayValue, VC.homeDesignFeature?.displayString.replacingOccurrences(of: "NOT SURE", with: ""))
    }
    
    if displayValue == "" {
      displayValue = infoStaicText
    }
    
    return displayValue
  }
  
  private func displayTextWithDesignFeatures (_ features: [HomeDesignFeature]) -> String {
    
    var displayValue = ""
    
    for feature in features {
        displayValue = addSpaceandnewValue(displayValue, feature.displayString.capitalized)
    }
    
    if displayValue == "" {
        displayValue = infoStaicText.capitalized
    }
      if displayValue == "All" {
          displayValue = "Selected All Designs"
      }
    
    return displayValue
  }
  
  
  
  func fillDesignCounts () {
    
    if (self.designsCount ?? 0) == 0 {
      
      self.btnDesignsCount.setTitle("NO DESIGNS", for: .normal)
        setAppearanceFor(view: btnDesignsCount, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_BUTTON_LIGHT(size: FONT_14))
      
    }else if (self.designsCount ?? 0) == 1 {
      
      self.btnDesignsCount.setTitle("SKIP TO 1 DESIGN >", for: .normal)
      
      setAppearanceFor(view: btnDesignsCount, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
      
    }else {
      
      self.btnDesignsCount.setTitle("SKIP TO \(self.designsCount ?? 0) DESIGNS >", for: .normal)
      
      setAppearanceFor(view: btnDesignsCount, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
    }
    
  }
  
  
  func selectedFeatureValues () -> [NSDictionary] {
    
    var arrSelectedFeatures = [NSDictionary] ()
    
    if currentIndex < 0 {
      return arrSelectedFeatures
    }
    
    for i in 0...arrVCs.count-1 {
      
      let vc = arrVCs[i]
      
      //            if vc.homeDesignFeature?.selectedAnswer == DesignAnswer.dontmind.rawValue {
      //                //not adding in query
      ////                let values = vc.homeDesignFeature?.returnValues ()
      ////                if values != nil, let val = values {
      ////                    val.setValue("", forKey: "Answer")
      ////                    arrSelectedFeatures.append(val)
      ////                }
      //            }else {
      if vc.isKind(of: HomeDesignPriceVC.self) || vc.isKind(of: HavingLotVC.self) {
        let values = vc.homeDesignFeature?.returnValuesForPrice ()
        if values != nil, let val = values {
          arrSelectedFeatures.append(val)
            print(val)
          if val.value(forKey: "Answer") as! String == "NOT SURE" {
            
          }else{
            
          }
        }
        
      }else {
        let values = vc.homeDesignFeature?.returnValues ()
        if values != nil, let val = values {
          arrSelectedFeatures.append(val)
          if val.value(forKey: "Answer") as! String == "NOT SURE" {
            
          }else{
            
          }
        }
        
      }
      //            }
    }
      print(arrSelectedFeatures)
    return arrSelectedFeatures
  }
  
  
  
  //MARK: - perform selector
  
  func getPriceValues (after: TimeInterval) {
    cancelPreviousSelector()
    perform(#selector(getDesignsCount), with: nil, afterDelay: after)
  }
  
  func cancelPreviousSelector () {
    NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(getDesignsCount), object: nil)
  }
  
}



//MARK: - Delegates

extension MyCollectionSurveyVC: ChildVCDelegate, HeaderBreadCrumpDelegate/*, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate */{
  
  
  //    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
  //        return arrVCs.count
  //    }
  //
  //    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
  //
  //        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
  //
  //        let viewCon = arrVCs[indexPath.row]
  //
  //        viewCon.addContentView(toView: cell.viewWithTag(101)!, with: self)
  //
  //        cell.layoutIfNeeded()
  //        viewCon.reloadView()
  //
  //        if viewCon.isKind(of: HomeDesignPriceVC.self) {
  //            (viewCon as! HomeDesignPriceVC).setFeaturePriceValues ()
  //        }
  //
  //        return cell
  //    }
  //
  //    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
  //
  //        let viewCon = arrVCs[indexPath.row]
  //        viewCon.view.isHidden = false
  //        viewCon.reloadView()
  //    }
  //
  //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
  //        return CGSize (width: collectionView.frame.size.width, height: collectionView.frame.size.height)
  //    }
  //
  //    //ScrollViewDelegate Methods
  //    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
  //
  //        if scrollView == mainCollectionView {
  //
  //            // Test the offset and calculate the current page after scrolling ends
  //            let pageWidth:CGFloat = scrollView.frame.width
  //            let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
  //            // Change the indicator
  //            self.currentIndex = Int(currentPage)
  ////            self.pageControl.currentPage = Int(currentPage);
  //        }
  //
  //    }
  
  
    func handleActionFor(sort: Bool, map: Bool, favourites: Bool, howWorks: Bool, reset : Bool) {
        
        if favourites {
            
            CodeManager.sharedInstance.sendScreenName(burbank_homeDesigns_newQuiz_favourites_button_touch)
            
            let designs: DesignsVC = kStoryboardMain.instantiateViewController(withIdentifier: "DesignsVC") as! DesignsVC
            designs.isFromCollection = true
            designs.isFavorites = true
            
            designs.isFromProfileFavorites = true
            
            
            designs.filter = SortFilter ()
            self.navigationController?.pushViewController(designs, animated: true)
        }
        
        
        if howWorks {
            
            if let url = AppConfigurations.shared.getHowDoesitWorkURLinMyCollection(), let _ = URL (string: url) {
                print(log: url)
                playVideoIn(self, url)
            }
            
            CodeManager.sharedInstance.sendScreenName(burbank_homeDesigns_newQuiz_howDoesItWork_button_touch)
        }
        
        
    }
  
  
  func selectedBreadCrumb(_ str: String) {
    
    CodeManager.sharedInstance.sendScreenName(burbank_homeDesigns_newQuiz_selectedAnswer_button_touch)
   
    for i in 0...arrVCs.count-1 {
      
      let vc = arrVCs[i]
        print("\(vc.homeDesignFeature?.displayString ?? "") == \(str)")
        
        if vc.homeDesignFeature?.displayString == str {
        
        currentIndex = i
        
        showViewAt(index: currentIndex)
        
        break
      }
    }
    
  }
  
  
}



//MARK: - APIs

extension MyCollectionSurveyVC {
  
  func checkForRecentSearchData () {
      guard Int(kUserID) ?? 0 > 0 else {return} // only for loggedIn users
    ProfileDataManagement.shared.recentSearchData(SearchType.shared.newHomes, Int(kUserState)!, kUserID, succe: { (recentSearchResult) in
      
      if let recent = recentSearchResult {
        
        guard let resultFeatures = recent.value(forKey: "SearchJson") as? NSArray else { return }
        
        
        var rece = [NSDictionary] ()
        var features = [HomeDesignFeature] ()
        
        for item in resultFeatures as! [NSDictionary] {
          
          if String.checkNullValue(item.value(forKey: "feature") as Any).contains("resultsCount") {
            
            //                        appDelegate.userData?.user?.userDetails?.searchCollectionCount = (String.checkNullValue(item.value(forKey: "Answer") as Any) as NSString).integerValue
            
            setCollectionsCount(count: (String.checkNullValue(item.value(forKey: "Answer") as Any) as NSString).integerValue, state: kUserState)
            
          }else {
            
            rece.append(item)
            features.append(HomeDesignFeature (recentSearch: item))
          }
        }
        
        setHomeDesignsFavouritesCount(count: (recent.value(forKey: "UserFavourites") as! NSNumber).intValue, state: kUserState)
        
        
        //                appDelegate.userData?.user?.userDetails?.searchHomeDesignCount = (recent.value(forKey: "UserFavourites") as! NSNumber).intValue
        //
        //
        //                appDelegate.userData?.saveUserDetails()
        //                appDelegate.userData?.loadUserDetails()
        
        
        if features.count > 0 {
          
          appDelegate.userData?.user?.userDetails?.collectionRecentSearch = rece as NSArray
          
          self.recentSearch?.recentSearchFrom = "MyCollection"
            self.recentSearch?.recentSearch.text = features.count > 0 ? self.displayTextWithDesignFeatures(features) : infoStaicText.capitalized
          self.recentSearch?.btnShow.setTitle("Show Designs", for: .normal)
          
          
          self.viewRecentSearch.isHidden = false
          self.view.bringSubviewToFront(self.viewRecentSearch)
          
          self.viewHintPopUp.isHidden = true
          self.view.sendSubviewToBack(self.viewHintPopUp)
          
          CodeManager.sharedInstance.sendScreenName(burbank_homeDesigns_recentQuiz_screen_loading)
          
          self.recentSearch?.showAction = {
            
            CodeManager.sharedInstance.sendScreenName(burbank_homeDesigns_recentQuiz_showDesigns_button_touch)
            
            self.viewRecentSearch.isHidden = true
            self.view.sendSubviewToBack (self.viewRecentSearch)
            
            
            let designs: DesignsVC = kStoryboardMain.instantiateViewController(withIdentifier: "DesignsVC") as! DesignsVC
            designs.isFromCollection = true
            designs.filter = SortFilter ()
            
            self.navigationController?.pushViewController(designs, animated: true)
            
            designs.selectedFeatures = rece
            
            designs.displayText = features.count > 0 ? self.displayTextWithDesignFeatures(features) : infoStaicText
          }
          
          
          self.recentSearch?.startNewAction = {
            
            CodeManager.sharedInstance.sendScreenName(burbank_homeDesigns_recentQuiz_startNew_button_touch)
            
            
            //                        homeLand.filter = SortFilter ()
            //                        homeLand.selectAllViewsBasedonFilter ()
            //
            //                        homeLand.viewDidLoad()
            //
            self.viewRecentSearch.isHidden = true
            self.view.sendSubviewToBack (self.viewRecentSearch)
            
            self.viewHintPopUp.isHidden = false
            self.view.bringSubviewToFront (self.viewHintPopUp)
            
            self.viewHintPopUp.isHidden = true
          }
        }else {
          self.viewHintPopUp.isHidden = false
          self.view.bringSubviewToFront (self.viewHintPopUp)
          
          self.viewHintPopUp.isHidden = true
        }
      }
    })
    
  }
  
  
  func getCollectionQuiz () {
    
    _ = Networking.shared.GET_request(url: ServiceAPI.shared.URL_HomeDesignQuiz (), userInfo: nil, success: { (json, response) in
      
      if let result: AnyObject = json {
        
        let result = result as! NSDictionary
        
        if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {
          
          self.arrHomeDesigns.removeAll()
          
          if (result.allKeys as! [String]).contains("newhomesQuiz") {
            
            let quizItems = result.value(forKey: "newhomesQuiz") as! [NSDictionary]
            
            let features = quizItems.sorted { (dict1, dict2) -> Bool in
              return (dict1.value (forKey: "QuestionOrder") as? NSNumber ?? 0).intValue < (dict2.value (forKey: "QuestionOrder") as? NSNumber ?? 0).intValue
            }
            
            for item in features {
              
              self.arrHomeDesigns.append(HomeDesignFeature (dict: item))
            }
            
            self.loadVCs ()
            
            self.getDesignsCount()
          }
          
        }else { print(log: "no packages found") }
        
      }else {
        
      }
      
    }, errorblock: { (error, isJSONerror) in
      
      if isJSONerror { }
      else { }
      
    }, progress: nil)
    
  }
  
  
  
  @objc func getDesignsCount () {
    
     
      
      
    let params = NSMutableDictionary ()
    params.setValue(kUserID, forKey: "UserId")
    params.setValue(kUserState, forKey: "StateId")
    params.setValue(0, forKey: "IncludePackages")
    params.setValue(0, forKey: "SortByPrice")
    params.setValue("", forKey: "FeatureAllFilter")
    
    //  params.setValue(0, forKey: "MinLotWidth")
    
    
    //        var nextFeatureName = ""
    //
    //        if arrVCs.count > currentIndex+1 {
    //            nextFeatureName = arrVCs[currentIndex+1].homeDesignFeature?.featureName ?? ""
    //        }else {
    ////            nextFeatureName = arrVCs[currentIndex].homeDesignFeature?.featureName ?? ""
    //        }
    
    //        params.setValue(nextFeatureName, forKey: "Feature")
    //
    //        //price will go as a next feature name
    //        if arrVCs[currentIndex].isKind(of: HomeDesignPriceVC.self), nextFeatureName.count == 0 {
    //            params.setValue(arrVCs[currentIndex].homeDesignFeature?.featureName ?? "", forKey: "Feature")
    //        }
    
    let sele = selectedFeatureValues()
    print(sele)
    params.setValue("8", forKey: "FeatureAllFilter")
    if sele.count == 0 {
      params.setValue(nil, forKey: "newhomesjson")
    }
    else {
      print(sele.count)
//      params.setValue("8", forKey: "FeatureAllFilter")
      if sele.last?.value(forKey: "Answer") as? String == "NOT SURE"
      {
        sele.last?.setValue("I don't mind",forKey: "Answer")
        //params.setValue("ALL", forKey: "FeatureAllFilter")
      }
//      else {
//        params.setValue("8", forKey: "FeatureAllFilter")
//      }
      for (index , item) in sele.enumerated()
      {
        if item.value(forKey: "Answer") as? String == "NOT SURE"
        {
         
          sele[index].setValue("I don't mind", forKey: "Answer")
        }
        if item.value(forKey: "MaxValue") != nil
        {
          if item.value(forKey: "MaxValue") as? String == "NOT SURE"
          {
            sele[index].setValue("", forKey: "MaxValue")
          }
          if sele[index].value(forKey: "Answer") as? String != "I don't mind"
          {
            sele[index].setValue("", forKey: "Answer")
          }
        }
        if item.value(forKey: "MinValue") != nil
        {
          sele[index].setValue("0.00", forKey: "MinValue")
        }
       // sele[index].setValue("", forKey: "MaxValue")
        
      }
      if let maxValue = sele.last?.value(forKey: "MaxValue") as? String, maxValue != ""
      {
        params.setValue(maxValue, forKey: "FeatureAllFilter")
      }

      params.setValue(sele, forKey: "newhomesjson")
      
    }
//    if sele.count == 1 { //Lot width
//      if sele[0].value(forKey: "Answer") as? String == "I don't mind"
//      {
//          params.setValue("8", forKey: "FeatureAllFilter")
//      }
//
//    }
    
    for task in NetworkingManager.shared.arrayDesignsCountTasks {
      if (task as AnyObject).isKind(of: URLSessionDataTask.self), (task as! URLSessionDataTask).state == .running {
        (task as! URLSessionDataTask).cancel()
      }
    }
    
    
    
    let datatask = Networking.shared.POST_request(url: ServiceAPI.shared.URL_HomeDesignDesignCount, parameters: params, userInfo: nil, success: {[weak self] (json, response) in
        guard let self = self else {return}
        // previous and next button color changes based on question changes
    

      if let result: AnyObject = json {
        
        let result = result as! NSDictionary
        
        if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {
          if let message = result.value(forKey: "message") as? String
            {
              self.btnDesignsCount.isHidden = true
              self.btnNext.backgroundColor = APPCOLORS_3.LightGreyDisabled_BG
              self.btnNext.isUserInteractionEnabled = false
              let userInfo = ["message" : message]
              NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewHomesNextFeatureResponse"), object: nil, userInfo: userInfo)
              self.removeAllBreadCrumbs()
              self.addBreadcrumb(self.displayText())
          }else {
            self.btnDesignsCount.isHidden = false
          }
          self.isNotSureSelected = ""
          if let nextFeature = result.value(forKey: "newHomesNextFeatures") as? NSDictionary {
            self.designsCount = (nextFeature.value(forKey: "HouseCount") as? NSNumber ?? 0).intValue
            
            if let _ = nextFeature.value(forKey: "NextFeatureAnswers") as? NSArray {
              
              //                            if /*nextFeatureName.count > 0,*/ self.arrVCs.count > (self.currentIndex+1), answers.count > 0 {
              //
              //                                self.arrVCs[self.currentIndex+1].homeDesignFeature?.answerOptions = answers as! [String]
              //
              //                                self.arrVCs[self.currentIndex+1].reloadView()
              //                            }
              
              let nextFeature = HomeDesignFeature (nextFeature: nextFeature)
                //nextFeature.
              self.addVC(with: nextFeature)
              
              //                            self.arrVCs.last?.reloadView()
              //                            self.mainCollectionView.reloadData()
              
              if self.arrVCs.count > (self.currentIndex+1) {
                
                self.showViewAt(index: self.currentIndex)
              }
              
            }
            
            
            if self.arrVCs[self.currentIndex].isKind(of: HomeDesignPriceVC.self)/*, nextFeatureName.count == 0*/ {
              
              let vc = self.arrVCs[self.currentIndex]
              
              var counts = [0, 0, 0, 0, 0, 0, 0]
              let distributionCount = nextFeature.value(forKey: "CountDistribution") as? [String]
              
              if let count = distributionCount {
                counts = count.map({ (str) in
                  return (str as NSString).integerValue
                })
              }
              
              
              if self.designsCount !=  counts.reduce (0, +) {
                counts[0] = counts[0] + 1
              }
              
              
              (vc as! HomeDesignPriceVC).priceRangeVC?.bars = counts
              (vc as! HomeDesignPriceVC).priceRangeVC?.barGraph.reloadData()
              
            }else {
              
              let minPrice = (String.checkNullValue (nextFeature.value(forKey: "Minvalue") as Any) as NSString).doubleValue
              let maxPrice = (String.checkNullValue (nextFeature.value(forKey: "Maxvalue") as Any) as NSString).doubleValue
              
              if minPrice > 0, maxPrice > 0 {
                
                for vc in self.arrVCs {
                  if vc.isKind(of: HomeDesignPriceVC.self) {
                    
                    var counts = [0, 0, 0, 0, 0, 0, 0]
                    let distributionCount = nextFeature.value(forKey: "CountDistribution") as? [String]
                    
                    if let count = distributionCount {
                      counts = count.map({ (str) in
                        return (str as NSString).integerValue
                      })
                    }
                    
                    (vc as! HomeDesignPriceVC).setFeaturePriceValues(with: minPrice, maxPrice: maxPrice, countDistribution: counts)
                    break
                  }
                }
                
              }
            }
          }
        }else {
          
          print(log: "no data found")
        }
      }else {
        
      }
      
    }, errorblock: { (error, isJsonError) in
      
      if isJsonError { }
      else { }
      
    }, progress: nil)
    
    
    if let task = datatask {
      NetworkingManager.shared.arrayDesignsCountTasks.add(task)
    }
    
  }
  
}
