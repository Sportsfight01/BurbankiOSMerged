//
//  HomeLandVCSurvey.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 26/03/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit

class HomeLandVCSurvey: HeaderVC {
    
    
    @IBOutlet weak var mainView : UIView!
    @IBOutlet weak var regionView : UIView! // tag - 101
    @IBOutlet weak var priceView : UIView! // tag - 102
    @IBOutlet weak var storeysView : UIView! // tag - 103
    @IBOutlet weak var bedroomsView : UIView! // tag - 104
  
    
    
    
    @IBOutlet weak var btnDesignsCount: UIButton!
    
    
    //MARK: - regionView
    
    @IBOutlet weak var region_lBregion: UILabel!
    @IBOutlet weak var regionsTable: UITableView!
    @IBOutlet weak var regionTableHeight: NSLayoutConstraint!
    
    
    
    //MARK: - storeysView
    
    @IBOutlet weak var storeys_lBstoreys: UILabel!
    
    @IBOutlet weak var storeys_iconSingle: UIImageView!
    @IBOutlet weak var storeys_lBSingle: UILabel!
    @IBOutlet weak var storeys_btnSingle: UIButton!
    
    @IBOutlet weak var storeys_iconDouble: UIImageView!
    @IBOutlet weak var storeys_lBDouble: UILabel!
    @IBOutlet weak var storeys_btnDouble: UIButton!
    
    @IBOutlet weak var storeys_iconNotSure: UIImageView!
    @IBOutlet weak var storeys_lBNotSure: UILabel!
    @IBOutlet weak var storeys_btnNotSure: UIButton!
    
    
    
    //MARK: - priceView
    
    @IBOutlet weak var price_lBPrice: UILabel!
//    @IBOutlet weak var price_btnContinue: UIButton!
//    @IBOutlet weak var price_btnSkip: UIButton!
    //    @IBOutlet weak var price_priceRange: PriceRangeView!
    @IBOutlet weak var priceRangeContainerView: UIView!
    
    
    //MARK: - BedroomsView
    @IBOutlet weak var bedrooms_lBbedrooms: UILabel!
    @IBOutlet weak var bedrooms_btn3Bedrooms: UIButton!
    @IBOutlet weak var bedrooms_btn4Bedrooms: UIButton!
    @IBOutlet weak var bedrooms_btn5Bedrooms: UIButton!
    @IBOutlet weak var bedrooms_btnNotSure: UIButton!
  
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var viewRecentSearch: UIView!

    
    
    //MARK: - myPlaceQuiz
    
    let myPlaceQuiz = MyPlaceQuiz()
    let minViewTag = 101
    var viewTag = 101//Int = minViewTag
    
    var priceRangeVC: PriceRangeVC?
    var arrRegions: [RegionMyPlace]?
    
    
//    var selectedRegion: RegionMyPlace = RegionMyPlace.init()
//    var previousRegion: RegionMyPlace?
    
    
    var packagesCount: Int? {
        didSet {
            if packagesCount == 0 {
                
                self.btnDesignsCount.setTitle("NO PACKAGES", for: .normal)
                setAppearanceFor(view: btnDesignsCount, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.LightGreyDisabled_BG, textFont: FONT_BUTTON_LIGHT(size: FONT_14))
                self.btnDesignsCount.isUserInteractionEnabled = false
                
                self.btnNext.backgroundColor = APPCOLORS_3.LightGreyDisabled_BG
                
                btnNext.isUserInteractionEnabled = self.btnNext.backgroundColor == APPCOLORS_3.EnabledOrange_BG
                
            }else {
                
                self.btnDesignsCount.setTitle(String(format: "SKIP TO %d %@ >", packagesCount!, packagesCount! == 1 ? "PACKAGE" : "PACKAGES"), for: .normal)

                setAppearanceFor(view: btnDesignsCount, backgroundColor: COLOR_CLEAR, textColor: AppColors.lightGray, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
                
              //  self.btnNext.superview!.alpha = 1.0
              //  self.btnNext.backgroundColor = APPCOLORS_3.EnabledOrange_BG
                btnNext.isUserInteractionEnabled = self.btnNext.backgroundColor == APPCOLORS_3.EnabledOrange_BG ? true : false

                self.btnDesignsCount.isUserInteractionEnabled = true
                
            }
        }
    }
    
    
    var recentSearch: RecentSearchPopUp?
    
    
    
    //MARK: - ViewLife Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
                
        CodeManager.sharedInstance.sendScreenName(burbank_homeAndLand_screen_loading)
    
        headerLogoText = "House&Land"
        
        viewTag = 101
        
        pageUISetup ()
        
        if btnBack.isHidden {
            showBackButton()
            //            hideBackButton()
            btnBack.addTarget(self, action: #selector(handleBackButton(_:)), for: .touchUpInside)
            btnBackFull.addTarget(self, action: #selector(handleBackButton(_:)), for: .touchUpInside)
        }
        
        addHeaderOptions(sort: false, map: false, favourites: true, howWorks: false, delegate: self)
                
        if let _ = AppConfigurations.shared.getHowDoesitWorkURLinHomeandLand() {
//            self.btnHowWorks.isHidden = false
        }else {
            btnHowWorks.isHidden = true
        }

        
        viewRecentSearch.isHidden = true
        
        breadcrumbView.delegate = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        print(log: self.breadcrumbView.arrBreadCrumbs)
        print(log: self.heightCollection?.constant as Any)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
//        self.tabBarController?.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

        if (self.priceRangeVC?.rangeslider.maximumValue ?? 0) > 1 {
            self.filter.defaultPriceRange.priceStart = self.priceRangeVC?.rangeslider.minimumValue ?? 0
            self.filter.defaultPriceRange.priceEnd = self.priceRangeVC?.rangeslider.maximumValue ?? 0
            
            self.filter.priceRange.priceStart = self.priceRangeVC?.rangeslider.lowerValue ?? self.priceRangeVC?.rangeslider.minimumValue ?? 0
            self.filter.priceRange.priceEnd = self.priceRangeVC?.rangeslider.upperValue ?? self.priceRangeVC?.rangeslider.maximumValue ?? 0
        }
        
        priceRangeVC?.searchType = SearchType.shared.homeLand
        priceRangeVC?.bars = self.filter.priceRange.priceRangeCounts
        print(self.filter.priceRange.priceRangeList)
        print(priceRangeVC?.priceListArr)
        priceRangeVC?.priceListArr = self.filter.priceRange.priceRangeList
        
        priceRangeVC?.updateRangeSlider()
        
        
        
        getRegions ()
        
        
        self.filter.searchType = SearchType.shared.homeLand

//        self.searchType = SearchType.shared.homeLand
        
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//        self.tabBarController?.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//
//    }
    
    
    //MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "priceRange" {
            priceRangeVC = segue.destination as? PriceRangeVC
            priceRangeVC?.searchType = SearchType.shared.homeLand
            
            priceRangeVC?.updatedPriceRangeValues = {
                
                if self.viewTag == 102 {

                    self.filter.priceRange.priceStart = (self.priceRangeVC?.rangeslider.lowerValue)!
                    self.filter.priceRange.priceEnd = (self.priceRangeVC?.rangeslider.upperValue)!
                    
                    self.myPlaceQuiz.priceRangeLow = "$\(self.filter.priceRange.priceStartStringValue)K"
                    self.myPlaceQuiz.priceRangeHigh = "$\(self.filter.priceRange.priceEndStringValue)K"
                    
                    
//                    self.labelInfo.text = self.myPlaceQuiz.filterStringDisplayHomes()
                    
                    self.addBreadCrumb(from: self.myPlaceQuiz.filterStringDisplayHomes())
                    self.getPriceValues(after: 1)
                    self.selectBreadCrumb ()
                }
            }
            //Below Closure called when price range selected
            priceRangeVC?.tapedOnBarPriceRangeValues = {
            
                if self.viewTag == 102 {

                    self.filter.priceRange.priceStart = (self.priceRangeVC?.rangeslider.lowerValue)!
                    self.filter.priceRange.priceEnd = (self.priceRangeVC?.rangeslider.upperValue)!
                    
                    self.myPlaceQuiz.priceRangeLow = "$\(self.filter.priceRange.priceStartStringValue)K"
                    self.myPlaceQuiz.priceRangeHigh = "$\(self.filter.priceRange.priceEndStringValue)K"
                    
//                    self.labelInfo.text = self.myPlaceQuiz.filterStringDisplayHomes()
                    self.btnDesignsCount.isUserInteractionEnabled = self.priceRangeVC?.selectedBarValue == 0 ? false : true
                    self.btnNext.isUserInteractionEnabled = self.btnDesignsCount.isUserInteractionEnabled
                    self.btnNext.backgroundColor = self.priceRangeVC?.selectedBarValue == 0 ? APPCOLORS_3.LightGreyDisabled_BG : APPCOLORS_3.EnabledOrange_BG
                    if self.priceRangeVC?.selectedBarValue == 0
                    {
                        self.btnDesignsCount.setTitle("NO PACKAGES", for: .normal)
                        
//                        self.btnNext.isUserInteractionEnabled = false
//                        self.btnNext.backgroundColor = APPCOLORS_3.LightGreyDisabled_BG
                    }
                    else {
                        
                        self.btnDesignsCount.setTitle(String(format: "SKIP TO %d %@ >", self.priceRangeVC?.selectedBarValue ?? 0, self.priceRangeVC?.selectedBarValue == 1 ? "PACKAGE" : "PACKAGES"), for: .normal)
                    }


                    self.addBreadCrumb(from: self.myPlaceQuiz.filterStringDisplayHomes())
                    
//                    self.getPriceValues(after: 1)
                    
                    self.selectBreadCrumb ()
                    //self.btnNext.backgroundColor = APPCOLORS_3.EnabledOrange_BG
                    //self.btnPrevious.backgroundColor = APPCOLORS_3.EnabledOrange_BG
                }
            }

            
        }else if segue.identifier == "recentSearch" {
            
            recentSearch = segue.destination as? RecentSearchPopUp
        }
    }
    
    
    //MARK: - View UISetup
    
    func pageUISetup () {
        
        regionViewSetUp()
        priceViewSetUp()
        storeysViewSetUp()
        bedroomViewSetUp()
        
        
        
        btnDesignsCount.setTitle("SKIP >", for: .normal)
        setAppearanceFor(view: btnDesignsCount, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_BUTTON_SUB_HEADING(size: FONT_14))
        
        setAppearanceFor(view: btnNext, backgroundColor: APPCOLORS_3.LightGreyDisabled_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_15))
        setAppearanceFor(view: btnPrevious, backgroundColor: APPCOLORS_3.LightGreyDisabled_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_15))

        //        arrButtons.forEach({$0.backgroundColor = COLOR_CLEAR})
        //        arrButtons.forEach({$0.setTitleColor(APPCOLORS_3.GreyTextFont, for: .normal)})
        //
        //        region_btnNorth.backgroundColor = APPCOLORS_3.Orange_BG
        //        region_btnNorth.setTitleColor(APPCOLORS_3.HeaderFooter_white_BG, for: .normal)
        
        
        showHideAllViews ()
    
        
//        let swipeRight = UISwipeGestureRecognizer (target: self, action: #selector(respondToSwipeGesture(gesture:)))
//        swipeRight.direction = .right
//        self.mainView.addGestureRecognizer(swipeRight)
//
//        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
//        swipeLeft.direction = .left
//        self.mainView.addGestureRecognizer(swipeLeft)

    }
    
    func regionViewSetUp () {
        
        let str = "WHAT REGION ARE YOU\nLOOKING FOR YOUR NEW HOME?"
        region_lBregion.text = str
        
        setAppearanceFor(view: region_lBregion, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_BODY (size: FONT_18))
        
    }
    
    
    func storeysViewSetUp () {
        
        setAppearanceFor(view: storeys_lBstoreys, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_BODY (size: FONT_19))
       
        storeys_iconSingle.image = UIImage(named: "Ico-Single")
        storeys_iconDouble.image = UIImage(named: "Ico-Double")
        storeys_iconNotSure.image = UIImage(named: "Ico-Question")
        //changing tint color of storeys
        [storeys_iconSingle,storeys_iconDouble, storeys_iconNotSure].forEach({$0?.tintColor = APPCOLORS_3.GreyTextFont})
        
        setAppearanceFor(view: storeys_lBSingle, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_SUB_HEADING(size: FONT_9))
        setAppearanceFor(view: storeys_lBDouble, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_SUB_HEADING(size: FONT_9))
        setAppearanceFor(view: storeys_lBNotSure, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_SUB_HEADING(size: FONT_9))
        
        storeys_btnSingle.superview?.layer.cornerRadius = radius_5
        storeys_btnDouble.superview?.layer.cornerRadius = radius_5
        storeys_btnNotSure.superview?.layer.cornerRadius = radius_5
        
        
        
        setAppearanceFor(view: storeys_btnSingle.superview!, backgroundColor: APPCOLORS_3.HeaderFooter_white_BG)
        setAppearanceFor(view: storeys_btnDouble.superview!, backgroundColor: APPCOLORS_3.HeaderFooter_white_BG)
        setAppearanceFor(view: storeys_btnNotSure.superview!, backgroundColor: APPCOLORS_3.HeaderFooter_white_BG)
        
    }
    
    
    func priceViewSetUp () {
        
        setAppearanceFor(view: price_lBPrice, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_BODY (size: FONT_19))
        
//        setAppearanceFor(view: price_btnContinue, backgroundColor: APPCOLORS_3.Orange_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_BODY(size: FONT_14))
//        setAppearanceFor(view: price_btnSkip, backgroundColor: APPCOLORS_3.Orange_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_BODY(size: FONT_14))
//
//        price_btnSkip.layer.cornerRadius = radius_5
//        price_btnContinue.layer.cornerRadius = radius_5
        
    }
    
    func bedroomViewSetUp () {
        
        setAppearanceFor(view: bedrooms_lBbedrooms, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_BODY (size: FONT_19))
        
        _ = setAttributetitleFor(view: bedrooms_btn3Bedrooms, title: "3\nBEDROOMS", rangeStrings: ["3","BEDROOMS"], colors: [APPCOLORS_3.GreyTextFont, APPCOLORS_3.GreyTextFont], fonts: [FONT_LABEL_BODY(size: FONT_23), FONT_LABEL_SUB_HEADING(size: FONT_9)], alignmentCenter: true)
        _ = setAttributetitleFor(view: bedrooms_btn4Bedrooms, title: "4\nBEDROOMS", rangeStrings: ["4","BEDROOMS"], colors: [APPCOLORS_3.GreyTextFont, APPCOLORS_3.GreyTextFont], fonts: [FONT_LABEL_BODY(size: FONT_23), FONT_LABEL_SUB_HEADING(size: FONT_9)], alignmentCenter: true)
        
        _ = setAttributetitleFor(view: bedrooms_btn5Bedrooms, title: "5+\nBEDROOMS", rangeStrings: ["5+","BEDROOMS"], colors: [APPCOLORS_3.GreyTextFont, APPCOLORS_3.GreyTextFont], fonts: [FONT_LABEL_BODY(size: FONT_23), FONT_LABEL_SUB_HEADING(size: FONT_9)], alignmentCenter: true)
        _ = setAttributetitleFor(view: bedrooms_btnNotSure, title: "?\nNOT SURE", rangeStrings: ["?","NOT SURE"], colors: [APPCOLORS_3.GreyTextFont, APPCOLORS_3.GreyTextFont], fonts: [FONT_LABEL_LIGHT(size: FONT_40), FONT_LABEL_SUB_HEADING(size: FONT_9)], alignmentCenter: true)

        
        bedrooms_btn3Bedrooms.superview?.layer.cornerRadius = radius_5
        bedrooms_btn4Bedrooms.superview?.layer.cornerRadius = radius_5
        bedrooms_btn5Bedrooms.superview?.layer.cornerRadius = radius_5
        bedrooms_btnNotSure.superview?.layer.cornerRadius = radius_5


        setAppearanceFor(view: bedrooms_btn3Bedrooms.superview!, backgroundColor: APPCOLORS_3.HeaderFooter_white_BG)
        setAppearanceFor(view: bedrooms_btn4Bedrooms.superview!, backgroundColor: APPCOLORS_3.HeaderFooter_white_BG)
        setAppearanceFor(view: bedrooms_btn5Bedrooms.superview!, backgroundColor: APPCOLORS_3.HeaderFooter_white_BG)
        setAppearanceFor(view: bedrooms_btnNotSure.superview!, backgroundColor: APPCOLORS_3.HeaderFooter_white_BG)

    }
    
    
    //MARK: - Button Actions
    
    
    @IBAction func handleBackButton (_ sender: UIButton) {
        
        CodeManager.sharedInstance.sendScreenName(burbank_homeAndLand_newQuiz_back_button_touch)
       
      //  btnNext.backgroundColor = viewTag >
        
        if viewTag == 101 {
            
            if (btnDesignsCount.title(for: .normal) == "SKIP >") {
                
                if navigationController?.viewControllers.count == 1 {
                    self.tabBarController?.navigationController?.popViewController(animated: true)
                }else {
                    self.navigationController?.popViewController(animated: true)
                }
                
                self.filter = SortFilter ()
                
                selectStoreys ()
                selectBedrooms()
                
                
                return
            }
            
            if self.btnBack.isHidden {
                
            } else {
                
                btnDesignsCount.setTitle("SKIP >", for: .normal)
                setAppearanceFor(view: btnDesignsCount, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_BUTTON_SUB_HEADING(size: FONT_14))

                
                myPlaceQuiz.region = nil
                filter.region = RegionMyPlace()
                filter.regionsArr = []

                
                if let _ = self.arrRegions {
//                    self.filter.region = regions[0]
//                    myPlaceQuiz.region = self.filter.region.regionName
//                    self.filter.regionsArr =
                    arrRegions?.forEach { $0.isSelected =  true ? false: $0.isSelected  }
                    self.regionsTable.reloadData()
                }

                self.addBreadCrumb(from: myPlaceQuiz.filterStringDisplayHomes())
//                self.labelInfo.text = myPlaceQuiz.filterStringDisplayHomes()
                
                selectBreadCrumb ()

            }
        }else if viewTag == 103 {
            
            myPlaceQuiz.storeysCount = nil
            filter.storeysCount = .none
                        
            myPlaceQuiz.bedRoomCount = nil
            filter.bedRoomsCount = .none

//            myPlaceQuiz.priceRangeLow = nil
//            myPlaceQuiz.priceRangeHigh = nil
            
            filter.priceRange = PriceRange()
            
            filter.defaultPriceRange = PriceRange ()

        }else if viewTag == 104 {
            
            myPlaceQuiz.bedRoomCount = nil
            filter.bedRoomsCount = .none
            
//            myPlaceQuiz.priceRangeLow = nil
//            myPlaceQuiz.priceRangeHigh = nil
            
            filter.priceRange = PriceRange()
            
            filter.defaultPriceRange = PriceRange ()

        }else if viewTag == 102 {
            myPlaceQuiz.storeysCount = nil
            filter.storeysCount = .none
                        
            myPlaceQuiz.bedRoomCount = nil
            filter.bedRoomsCount = .none

            myPlaceQuiz.priceRangeLow = nil
            myPlaceQuiz.priceRangeHigh = nil
            
            filter.priceRange = PriceRange()
            
            filter.defaultPriceRange = PriceRange ()
        }
        
        
        
        
        if viewTag > 101 {
            viewTag = viewTag - 1
            
            updateDesignsCount()

        }else {
            //            arrButtons.forEach({$0.backgroundColor = COLOR_CLEAR})
            //            arrButtons.forEach({$0.setTitleColor(APPCOLORS_3.GreyTextFont, for: .normal)})
            //
            //            region_btnNorth.backgroundColor = APPCOLORS_3.Orange_BG
            //            region_btnNorth.setTitleColor(APPCOLORS_3.HeaderFooter_white_BG, for: .normal)
            
        }
        
        //remove previous data
        selectStoreys ()
        selectBedrooms()

        
        
        showHideAllViews ()
        btnPrevious.backgroundColor = viewTag > 101 ? APPCOLORS_3.EnabledOrange_BG : APPCOLORS_3.LightGreyDisabled_BG
        btnNext.backgroundColor = viewTag < 105 ? APPCOLORS_3.EnabledOrange_BG : APPCOLORS_3.LightGreyDisabled_BG
        
    }
    
    
    
    //    @IBAction func regionBtnClicked(_ sender: UIButton) {
    //
    //        arrButtons.forEach({$0.backgroundColor = COLOR_CLEAR})
    //        arrButtons.forEach({$0.setTitleColor(APPCOLORS_3.GreyTextFont, for: .normal)})
    //
    //        sender.backgroundColor = APPCOLORS_3.Orange_BG
    //        sender.setTitleColor(APPCOLORS_3.HeaderFooter_white_BG, for: .normal)
    //
    //        viewTag = minViewTag
    //
    //        anyButtonTapped(sender: sender)
    //
    //    }
    
    
    //below method called any one of answer is selected stpreys and bedrooms
    @IBAction func anyButtonTapped(sender: UIButton) {
        
        
        if sender == btnDesignsCount {
            
//            if Int(self.filter.region.regionId)! == 0 {
//                showToast("Please select one region", self, .top)
//                return
//            }
            
            if viewTag == 101, !(btnDesignsCount.title(for: .normal)?.contains("SKIP TO"))! {

                CodeManager.sharedInstance.sendScreenName(burbank_homeAndLand_newQuiz_skip_button_touch)
                
                viewTag = viewTag + 1

                self.filter = SortFilter ()
                
                selectStoreys ()
                selectBedrooms()
                

                updateDesignsCount()
                
                showHideAllViews ()
            
                return
            }
            
            CodeManager.sharedInstance.sendScreenName(burbank_homeAndLand_newQuiz_totalDesigns_button_touch)
            
            
            if filter.priceRange.priceStart == 0 || filter.priceRange.priceEnd == 1 {
                
//                getPriceRanges {
                    self.moveToHomeLandListPage ()
//                }
            }else {
                
                self.moveToHomeLandListPage ()
            }
            
            return
        }
                
        btnNext.backgroundColor = APPCOLORS_3.EnabledOrange_BG
        btnPrevious.backgroundColor = APPCOLORS_3.EnabledOrange_BG
        if btnBack.isHidden {
            showBackButton()
        }
        
        
        CodeManager.sharedInstance.sendScreenName(burbank_homeAndLand_newQuiz_selectedAnswer_button_touch)
        
        if viewTag == 101 { // Region
            
            myPlaceQuiz.region = sender.title(for: .normal)?.capitalized
            filter.region = RegionMyPlace()
            
//            btnDesignsCount.setTitle("0 PACKAGES >", for: .normal)

        }else if viewTag == 103 { // Storeys
            
            
            
            
            if sender == storeys_btnSingle {
                
                myPlaceQuiz.storeysCount = "SINGLE"
                filter.storeysCount = .one
            }else if sender == storeys_btnDouble {
                
                myPlaceQuiz.storeysCount = "DOUBLE"
                filter.storeysCount = .two
            }else if sender == storeys_btnNotSure {
                
                myPlaceQuiz.storeysCount = ""
                filter.storeysCount = .ALL
            }
            
            selectStoreys ()

            
            selectBedrooms()

        }else if viewTag == 104 {
            
            if sender == bedrooms_btn3Bedrooms {
                
                myPlaceQuiz.bedRoomCount = "3 BED"
                filter.bedRoomsCount = .three
                
            }else if sender == bedrooms_btn4Bedrooms {
                
                myPlaceQuiz.bedRoomCount = "4 BED"
                filter.bedRoomsCount = .four
            }else if sender == bedrooms_btn5Bedrooms {
                
                myPlaceQuiz.bedRoomCount = "5+ BED"
                filter.bedRoomsCount = .five
            }else if sender == bedrooms_btnNotSure{
                myPlaceQuiz.bedRoomCount = ""
                filter.bedRoomsCount = .ALL
            }
            
            selectBedrooms()
            
            getPriceRanges (nil)
            
        }else if viewTag == 102 {
            
            myPlaceQuiz.bedRoomCount = ""
            filter.bedRoomsCount = .none

            
            myPlaceQuiz.priceRangeLow = ""
            myPlaceQuiz.priceRangeHigh = ""
            
            filter.defaultPriceRange.priceStart = 0
            filter.defaultPriceRange.priceEnd = 1

            filter.priceRange.priceStart = 0
            filter.priceRange.priceEnd = 1
            
        }
        
        
        if viewTag > 104 {
                        
            moveToHomeLandListPage ()
        }else {

        }
        
        updateDesignsCount()
        
        
        showHideAllViews ()
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer
        {
            switch swipeGesture.direction
            {
            case .right:
                //write your logic for right swipe
                print("Swiped right")
                
//                UIView.animate(withDuration: 5, animations: {
                    
                    self.handlePreviousNextButtonsAction(self.btnPrevious)
//                }) { (completed) in
//
//                }
                
            case .left:
                //write your logic for left swipe
                print("Swiped left")
                
//                UIView.animateKeyframes(withDuration: 1, delay: 0, options: .calculationModeCubicPaced, animations: {
                    
                    self.handlePreviousNextButtonsAction (self.btnNext)

//                }) { (completed) in
//
//                }
                
            default:
                break
            }
        }
    }
    
    @IBAction func handlePreviousNextButtonsAction (_ sender: UIButton) {
        print(log: viewTag)
      
        if sender == btnNext {
            print(viewTag)
            CodeManager.sharedInstance.sendScreenName(burbank_homeAndLand_newQuiz_next_button_touch)
           // btnPrevious.backgroundColor = APPCOLORS_3.EnabledOrange_BG
            btnNext.backgroundColor = APPCOLORS_3.LightGreyDisabled_BG
            if btnNext.isUserInteractionEnabled == true { }
            else { return }
        }else {
            
            CodeManager.sharedInstance.sendScreenName(burbank_homeAndLand_newQuiz_previous_button_touch)
            //btnNext.backgroundColor = APPCOLORS_3.EnabledOrange_BG
           // btnPrevious.backgroundColor = APPCOLORS_3.EnabledOrange_BG
            if btnPrevious.isUserInteractionEnabled == true { }
            else { return }
        }
        
        
        if sender == btnNext {
            
            if viewTag == 101 {//region
                if let reg = myPlaceQuiz.region {
                    if reg == "" {
                        showToast("Please select region", self)
                        return
                    }
                }else {
                    showToast("Please select region", self)
                    return
                }
            }else if viewTag == 103 {//storeys
                if let storeysCount = myPlaceQuiz.storeysCount, self.filter.storeysCount == .none {
                    if storeysCount == "" {
                        showToast("Please select storeys", self)
                        return
                    }
                }else {
                    if self.filter.storeysCount == .none {
                        showToast("Please select storeys", self)
                        return
                    }
                }
            }else if viewTag == 104 {//bedrooms
                
                if let bedRoomsCount = myPlaceQuiz.bedRoomCount, self.filter.bedRoomsCount == .none {
                    if bedRoomsCount == "" {
                        showToast("Please select bedrooms", self)
                        return
                    }
                }else {
                    if self.filter.bedRoomsCount == .none{
                    showToast("Please select bedrooms", self)
                    return
                    }
                }
                
                self.myPlaceQuiz.priceRangeLow = "$\(self.filter.priceRange.priceStartStringValue)K"
                self.myPlaceQuiz.priceRangeHigh = "$\(self.filter.priceRange.priceEndStringValue)K"
                
                
            }else if viewTag == 102 {//pricerange
                if let storeysCount = myPlaceQuiz.priceRangeLow {
                    if storeysCount == "" {
                        showToast("Please select price", self)
                        return
                    }
                }else {
                    showToast("Please select price", self)
                    return
                }
            }
            
            if viewTag != 104 {
                
//                DashboardDataManagement.shared.getDesignsCount(filter: self.filter) { (count) in
                    
//                    self.btnDesignsCount.setTitle("\(count) PACKAGES >", for: .normal)
                    self.viewTag = self.viewTag + 1
                    self.showHideAllViews ()
//                }
                updateDesignsCount()
            }else {
                if packagesCount == 0 {
                    showToast("Please choose other options", self)
                    return
                }
                self.filter.defaultPriceRange.priceStart = self.filter.priceRange.priceStart
                self.filter.defaultPriceRange.priceEnd = self.filter.priceRange.priceEnd
                self.moveToHomeLandListPage()
            }
                        
//            self.anyButtonTapped(sender: btnNext)
            
        }else {
            
            //            self.handleBackButton(btnPrevious)
            
            if viewTag == 101 {
                
                if (btnDesignsCount.title(for: .normal) == "SKIP >") {
                    
//                    if navigationController?.viewControllers.count == 1 {
//                        self.tabBarController?.navigationController?.popViewController(animated: true)
//                    }else {
//                        self.navigationController?.popViewController(animated: true)
//                    }
//                    return
                }
                
                if self.btnBack.isHidden {
                    
                } else {
                    
                    btnDesignsCount.setTitle("SKIP >", for: .normal)
                    setAppearanceFor(view: btnDesignsCount, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_BUTTON_BODY(size: FONT_14))

                    myPlaceQuiz.region = nil
                    filter.region = RegionMyPlace()
                    
                    
                    if let _ = self.arrRegions {
                        //                    self.filter.region = regions[0]
                        //                    myPlaceQuiz.region = self.filter.region.regionName
//                        self.filter.regionsArr = []
                        self.regionsTable.reloadData()
                    }
                    
                    self.addBreadCrumb(from: myPlaceQuiz.filterStringDisplayHomes())
//                    self.labelInfo.text = myPlaceQuiz.filterStringDisplayHomes()
                    
                    selectBreadCrumb ()
                }
            }
            
            if viewTag > 101 {
                viewTag = viewTag - 1
            }else {
                
            }
            
            showHideAllViews ()
        }
        btnPrevious.backgroundColor = viewTag > 101 ? APPCOLORS_3.EnabledOrange_BG : APPCOLORS_3.LightGreyDisabled_BG
    }
    
    
    // MARK: - View Updates
    
    func updateDesignsCount () {
        
        _ = DashboardDataManagement.shared.getHomeLandFilterValues(with: self.filter) { (filterNew) in
            
            
            if filterNew.defaultPriceRange.priceStart > 0 || filterNew.defaultPriceRange.priceEnd > 1 {
                self.filter.defaultPriceRange = filterNew.defaultPriceRange
                self.filter.priceRange = filterNew.priceRange
            }

            self.packagesCount = filterNew.priceRange.totalCount
            
            if self.filter.priceRange.totalCount !=  self.filter.priceRange.priceRangeCounts.reduce (0, +) {
                self.filter.priceRange.priceRangeCounts[0] = self.filter.priceRange.priceRangeCounts[0] + 1
            }
            

            
            self.priceRangeVC?.bars = self.filter.priceRange.priceRangeCounts
            self.priceRangeVC?.priceListArr = self.filter.priceRange.priceRangeList
            
            print(self.filter.priceRange.priceRangeList)
            print(self.priceRangeVC?.priceListArr)
            
            
            self.priceRangeVC?.updateRangeSliderValues(with: self.filter)
            
        }
        
                
//        DashboardDataManagement.shared.getDesignsCount(filter: self.filter) { (count) in
//
//            self.packagesCount = count
////            self.btnDesignsCount.setTitle("\(count) PACKAGES >", for: .normal)
//
//        }
    }
    
    
    
    
    func selectAllViewsBasedonFilter () {
        
        let regionsArr =  filter.regionsArr.map{ $0.regionName }
        print("----1-1-1-1-1,",regionsArr)
        let regions = regionsArr.joined(separator: ",")
        print("----1-1-1-1-1,",regions)
              
        if filter.regionsArr.count == arrRegions?.count{
            myPlaceQuiz.region = "All regions"
        }
        else{
            myPlaceQuiz.region = regions
        }
        
        if filter.storeysCount == .one {
            
            myPlaceQuiz.storeysCount = "SINGLE"
        }else if filter.storeysCount == .two {
            
            myPlaceQuiz.storeysCount = "DOUBLE"
        }else {
            
            myPlaceQuiz.storeysCount = ""
        }
        
        
        if filter.bedRoomsCount == .three {
            
            myPlaceQuiz.bedRoomCount = "3 BED"
        }else if filter.bedRoomsCount == .four {
            
            myPlaceQuiz.bedRoomCount = "4 BED"
        }else if filter.bedRoomsCount == .five {
            
            myPlaceQuiz.bedRoomCount = "5+ BED"
        }else if filter.bedRoomsCount == .ALL {
            myPlaceQuiz.bedRoomCount = ""
        }
        
        
        if self.filter.priceRange.priceStart == 0 {
            myPlaceQuiz.priceRangeLow = ""
            myPlaceQuiz.priceRangeHigh = ""
        }else {
            myPlaceQuiz.priceRangeLow = "$\(self.filter.priceRange.priceStartStringValue)K"
            myPlaceQuiz.priceRangeHigh = "$\(self.filter.priceRange.priceEndStringValue)K"
        }
        
        /*
         
         
         
         */
        
        
        self.regionsTable.reloadData()
        
        selectStoreys()
        
        selectBedrooms()
        
        self.priceRangeVC?.updateRangeSliderValues(with: self.filter)
    }
    
    
    func selectStoreys () {
        
        storeysViewSetUp()
        
        if self.filter.storeysCount == .one {
            
            storeys_btnSingle.superview?.backgroundColor = APPCOLORS_3.EnabledOrange_BG
           /// storeys_iconSingle.image = UIImage(named: "Ico-SingeWhite")
            storeys_iconSingle.tintColor = APPCOLORS_3.HeaderFooter_white_BG
            storeys_lBSingle.textColor = APPCOLORS_3.HeaderFooter_white_BG
        }else if self.filter.storeysCount == .two {
            
            storeys_btnDouble.superview?.backgroundColor = APPCOLORS_3.EnabledOrange_BG
            //storeys_iconDouble.image = UIImage(named: "Ico-DoubleWhite")
            storeys_iconDouble.tintColor = APPCOLORS_3.HeaderFooter_white_BG
            storeys_lBDouble.textColor = APPCOLORS_3.HeaderFooter_white_BG
        }else if self.filter.storeysCount == .ALL {

            storeys_btnNotSure.superview?.backgroundColor = APPCOLORS_3.EnabledOrange_BG
            //storeys_iconNotSure.image = UIImage(named: "Ico-FaqWhite")
            storeys_iconNotSure.tintColor = APPCOLORS_3.HeaderFooter_white_BG
            storeys_lBNotSure.textColor = APPCOLORS_3.HeaderFooter_white_BG
        }

    }
    
    func selectBedrooms () {
        
        bedroomViewSetUp()
        
        if self.filter.bedRoomsCount == .three {
            
            bedrooms_btn3Bedrooms.superview?.backgroundColor = APPCOLORS_3.EnabledOrange_BG
            _ = setAttributetitleFor(view: bedrooms_btn3Bedrooms, title: "3\nBEDROOMS", rangeStrings: ["3","BEDROOMS"], colors: [APPCOLORS_3.HeaderFooter_white_BG, APPCOLORS_3.HeaderFooter_white_BG], fonts: [FONT_LABEL_BODY(size: FONT_23), FONT_LABEL_SUB_HEADING(size: FONT_9)], alignmentCenter: true)
            
        }else if self.filter.bedRoomsCount == .four {
            
            bedrooms_btn4Bedrooms.superview?.backgroundColor = APPCOLORS_3.EnabledOrange_BG
            _ = setAttributetitleFor(view: bedrooms_btn4Bedrooms, title: "4\nBEDROOMS", rangeStrings: ["4","BEDROOMS"], colors: [APPCOLORS_3.HeaderFooter_white_BG, APPCOLORS_3.HeaderFooter_white_BG], fonts: [FONT_LABEL_BODY(size: FONT_23), FONT_LABEL_SUB_HEADING(size: FONT_9)], alignmentCenter: true)

        }else if self.filter.bedRoomsCount == .five {
            
            bedrooms_btn5Bedrooms.superview?.backgroundColor = APPCOLORS_3.EnabledOrange_BG
            _ = setAttributetitleFor(view: bedrooms_btn5Bedrooms, title: "5+\nBEDROOMS", rangeStrings: ["5+","BEDROOMS"], colors: [APPCOLORS_3.HeaderFooter_white_BG, APPCOLORS_3.HeaderFooter_white_BG], fonts: [FONT_LABEL_BODY(size: FONT_23), FONT_LABEL_SUB_HEADING(size: FONT_9)], alignmentCenter: true)
        }else if self.filter.bedRoomsCount == .ALL{
            bedrooms_btnNotSure.superview?.backgroundColor = APPCOLORS_3.EnabledOrange_BG
            _ = setAttributetitleFor(view: bedrooms_btnNotSure, title: "?\nNot Sure", rangeStrings: ["?","Not Sure"], colors: [APPCOLORS_3.HeaderFooter_white_BG, APPCOLORS_3.HeaderFooter_white_BG], fonts: [FONT_LABEL_LIGHT(size: FONT_40), FONT_LABEL_SUB_HEADING(size: FONT_9)], alignmentCenter: true)
        }

    }
    
    
    func showHideAllViews () {
        
        btnNext.isUserInteractionEnabled = viewTag > 104 ? false : true
        btnPrevious.isUserInteractionEnabled = viewTag == 101 ? false : true
     
        print("viewTag: \(viewTag)")
        [regionView,storeysView,bedroomsView,priceView].forEach({$0?.isHidden = true})//hide all
        
        view.viewWithTag(viewTag)?.isHidden = false
        view.bringSubviewToFront(view.viewWithTag(viewTag)!) // bring next question on screen
        
        self.addBreadCrumb(from: myPlaceQuiz.filterStringDisplayHomes())
//        self.labelInfo.text = myPlaceQuiz.filterStringDisplayHomes()

        //IF CURRENT VIEW HAS ANSWER SELECTED, CHANGE "NEXT BUTTON" BACKGROUND COLOR
        switch viewTag
        {
        case 101 : // region
            
            btnNext.backgroundColor = myPlaceQuiz.region?.count ?? 0 > 0 ? APPCOLORS_3.EnabledOrange_BG : APPCOLORS_3.LightGreyDisabled_BG
            
        case 102: // price
            btnNext.backgroundColor = myPlaceQuiz.priceRangeLow?.count ?? 0 > 0 ? APPCOLORS_3.EnabledOrange_BG : APPCOLORS_3.LightGreyDisabled_BG
        case 103: // storey
           // print(myPlaceQuiz.storeysCount)
            btnNext.backgroundColor = myPlaceQuiz.storeysCount?.count ?? 0 > 0 || self.filter.storeysCount == .ALL ? APPCOLORS_3.EnabledOrange_BG : APPCOLORS_3.LightGreyDisabled_BG
        case 104: // bedroom
            btnNext.backgroundColor = myPlaceQuiz.bedRoomCount?.count ?? 0 > 0 || self.filter.bedRoomsCount == .ALL ? APPCOLORS_3.EnabledOrange_BG : APPCOLORS_3.LightGreyDisabled_BG
        default:
            print(log: "result page")
        }
        selectBreadCrumb ()
    }
    
    func selectBreadCrumb () {
        
        if viewTag == 101 {
            breadcrumbView.changeColorForSelectedBreadCrumb(myPlaceQuiz.region ?? "")
        }else if viewTag == 103 {
            breadcrumbView.changeColorForSelectedBreadCrumb(myPlaceQuiz.storeysCount ?? "")
        }else if viewTag == 104 {
            breadcrumbView.changeColorForSelectedBreadCrumb(myPlaceQuiz.bedRoomCount ?? "")
        }else if viewTag == 102 {
            breadcrumbView.changeColorForSelectedBreadCrumb(((myPlaceQuiz.priceRangeLow ?? "") + "-" + (myPlaceQuiz.priceRangeHigh ?? "")))
        }
        
    }
    
    
    func getRegions () {
        
        if let regions = kStateRegions {
            
            
            for region in regions {
                if self.filter.regionsArr.contains(where: {$0.regionName == region.regionName}){
                    region.isSelected = true
                }
                
            }
            self.arrRegions = regions
         //   self.filter.regionsArr = []
//            self.filter.region = regions[0]
//            myPlaceQuiz.region = self.filter.region.regionName
                
            self.layoutTable ()
        }else {
            
            DashboardDataManagement.shared.getRegions(stateId: kUserState, showActivity: true) { (regions) in
                
                
                if let reg = regions {
                    
                    self.arrRegions = reg
                    self.filter.regionsArr = []
//                    self.filter.region = reg[0]
//                    self.myPlaceQuiz.region = self.filter.region.regionName
                }
                
                self.layoutTable ()
            }
            
        }
        
    }
    
    func layoutTable () {
        
        self.region_lBregion.layoutIfNeeded()
        self.regionView.layoutIfNeeded()
        
        self.regionsTable.reloadData()
        self.regionsTable.layoutIfNeeded()
        
        
        self.regionsTable.isScrollEnabled = true
        
        let maxHeight = self.mainView.frame.size.height - (0 + self.regionsTable.frame.origin.y + 0)
        
        
        regionTableHeight.constant = self.regionsTable.contentSize.height
        
        if let regions = arrRegions {
            
            regionTableHeight.constant = cellHeight*CGFloat((regions.count)) + 10.0*CGFloat((regions.count))
            
            
            if (/*regionsTable.frame.origin.y*/ 0 + regionTableHeight.constant + 0) > maxHeight {
                
                regionTableHeight.constant = (maxHeight - 0)
                
            }else {
                self.regionsTable.isScrollEnabled = false
            }
        }else {
            regionTableHeight.constant = 0
        }
        
//        regionView.backgroundColor = .blue
//        regionsTable.backgroundColor = .yellow
//
//        mainView.backgroundColor = .cyan
        
    }
    
    func moveToHomeLandListPage (_ favorites: Bool = false) {
        
        let homeLand = kStoryboardMain.instantiateViewController(withIdentifier: "HomeLandVC") as! HomeLandVC

        homeLand.myPlaceQuiz = MyPlaceQuiz ()
        homeLand.arrRegions = arrRegions
        homeLand.filter = filter.newFilter()
        
        if (self.filter.priceRange.priceStart != self.filter.defaultPriceRange.priceStart) || (self.filter.priceRange.priceEnd != self.filter.defaultPriceRange.priceEnd) {
        
            homeLand.filter.defaultPriceRange.priceStart = self.filter.priceRange.priceStart
            homeLand.filter.defaultPriceRange.priceEnd = self.filter.priceRange.priceEnd
        }
        
//        homeLand.quizPriceMinimumValue = myPlaceQuiz.sortfilter.priceRange.priceStart ?? "100"
//        homeLand.quizPriceMaximumValue = myPlaceQuiz.sortfilter.priceRange.priceEnd ?? "500"
        
        homeLand.isFavoritesService = favorites
        
        if favorites {
            homeLand.isFromProfileFavorites = true
            
            homeLand.filter = SortFilter ()
        }

//        homeLand.getDefaultPriceRanges(stateId: kUserState, region: self.filter.region)
        
        self.navigationController?.pushViewController(homeLand, animated: true)
        
    }
    
    
    //MARK: - perform selector

    func getPriceValues (after: TimeInterval) {
        cancelPreviousSelector()
        perform(#selector(getPriceRangesForSliderChanges), with: nil, afterDelay: after)
    }
    
    func cancelPreviousSelector () {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(getPriceRangesForSliderChanges), object: nil)
    }
    
    
}



//MARK: - Delegates

extension HomeLandVCSurvey: UITableViewDelegate, UITableViewDataSource, ChildVCDelegate, HeaderBreadCrumpDelegate {
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRegions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegionTableViewCell", for: indexPath) as! RegionTableViewCell
        
        let region = arrRegions![indexPath.row]
        
        cell.titleLabel.text = region.regionName.uppercased()
        
       // cell.selectedRegion = filter.region.regionId == region.regionId
        
      /*  if filter.region.regionName == region.regionName{
            cell.titleLabel.textColor = APPCOLORS_3.HeaderFooter_white_BG
            cell.titleLabel.backgroundColor = APPCOLORS_3.Orange_BG
        }else{
            cell.titleLabel.textColor = APPCOLORS_3.Black_BG
            cell.titleLabel.backgroundColor = APPCOLORS_3.HeaderFooter_white_BG
        }*/
        
        if region.isSelected{
            cell.titleLabel.textColor = APPCOLORS_3.HeaderFooter_white_BG
            cell.titleLabel.backgroundColor = APPCOLORS_3.EnabledOrange_BG
        }else{
            cell.titleLabel.textColor = APPCOLORS_3.GreyTextFont
            cell.titleLabel.backgroundColor = APPCOLORS_3.HeaderFooter_white_BG

        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //MARK: changed region to multiple selection in v2.3
//        filter.regionsArr = [] v2.2
        filter.region = arrRegions![indexPath.row]
//        filter.regionsArr.append(filter.region) v2.2
        if arrRegions?[indexPath.row].isSelected == true{
            arrRegions?[indexPath.row].isSelected = false
            let index = filter.regionsArr.firstIndex(where: { $0.regionName == filter.region.regionName  })
          //  print(index)
            filter.regionsArr.remove(at: index ?? 0)
            if filter.regionsArr.isEmpty{
                btnNext.backgroundColor = APPCOLORS_3.LightGreyDisabled_BG
            }
            
        }  else{
            arrRegions?[indexPath.row].isSelected = true
            filter.regionsArr.append(filter.region)
            btnNext.backgroundColor = APPCOLORS_3.EnabledOrange_BG
        }
        
        
        tableView.reloadData()
        
        viewTag = minViewTag
        
        let regionsArr =  filter.regionsArr.map{ $0.regionName }
        print("----1-1-1-1-1,",regionsArr)
        let regions = regionsArr.joined(separator: ", ")
        print("----1-1-1-1-1,",regions)
        if filter.regionsArr.count == arrRegions?.count{
            myPlaceQuiz.region = "All regions"
        }
        else{
            myPlaceQuiz.region = regions
        }
//        filter.region = selectedRegion
        
        
        myPlaceQuiz.storeysCount = ""
        filter.storeysCount = .none

        
        myPlaceQuiz.bedRoomCount = ""
        filter.bedRoomsCount = .none

        
        myPlaceQuiz.priceRangeLow = ""
        myPlaceQuiz.priceRangeHigh = ""

        filter.defaultPriceRange.priceStart = 0
        filter.defaultPriceRange.priceEnd = 1

        
        filter.priceRange.priceStart = 0
        filter.priceRange.priceEnd = 1

        
        selectStoreys ()
        
        selectBedrooms()

        
        updateDesignsCount()
        
        
        self.addBreadCrumb(from: self.myPlaceQuiz.filterStringDisplayHomes())
//        self.labelInfo.text = self.myPlaceQuiz.filterStringDisplayHomes()
        
        selectBreadCrumb ()

    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight + 10
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight + 10
    }
    
    //MARK: HeaderView
    
    func handleActionFor(sort: Bool, map: Bool, favourites: Bool, howWorks: Bool,reset : Bool) {
        
        if sort {
            
        }
        
        if map {
            
            
        }
        
        if favourites {
            CodeManager.sharedInstance.sendScreenName(burbank_homeAndLand_newQuiz_favourites_button_touch)
            moveToHomeLandListPage (true)
        }
        
        if howWorks {
            
            if let url = AppConfigurations.shared.getHowDoesitWorkURLinHomeandLand(), let _ = URL(string: url) {
                print(log: url)
                playVideoIn(self, url)
            }
            
            CodeManager.sharedInstance.sendScreenName(burbank_homeDesigns_newQuiz_howDoesItWork_button_touch)
        }
        
    }
    
    //MARK: BreadCrumb
    
    func selectedBreadCrumb(_ str: String) {
        print("\(myPlaceQuiz.storeysCount) == \(str)")
        print("\(myPlaceQuiz.bedRoomCount) == \(str)")
        print("\(myPlaceQuiz.region) == \(str)")
        print("\((myPlaceQuiz.priceRangeLow ?? "") + "-" + (myPlaceQuiz.priceRangeHigh ?? "")) == \(str)")
        
        if myPlaceQuiz.region == str.capitalized {
            viewTag = 101
        }else if myPlaceQuiz.storeysCount == str.uppercased() {
            viewTag = 103
        }else if myPlaceQuiz.bedRoomCount == str.uppercased() {
            viewTag = 104
        }else if ((myPlaceQuiz.priceRangeLow ?? "") + "-" + (myPlaceQuiz.priceRangeHigh ?? "")) == str {
            viewTag = 102
        }
        
        showHideAllViews ()

    }
    
}

//MARK: - APIs

extension HomeLandVCSurvey {
    
    @objc func getPriceRangesForSliderChanges () {
                        
        for task in NetworkingManager.shared.arrayPriceRangeTasks {
            if (task as AnyObject).isKind(of: URLSessionDataTask.self), (task as! URLSessionDataTask).state == .running {
                (task as! URLSessionDataTask).cancel()
            }
        }
        
        let datatask = DashboardDataManagement.shared.getHomeLandFilterValues(with: self.filter) { (filterNew) in
            
            self.filter.priceRange.priceRangeCounts = filterNew.priceRange.priceRangeCounts
            self.filter.priceRange.totalCount = filterNew.priceRange.totalCount
            
            self.packagesCount = filterNew.priceRange.totalCount
            
            
            if self.filter.priceRange.totalCount !=  self.filter.priceRange.priceRangeCounts.reduce (0, +) {
                self.filter.priceRange.priceRangeCounts[0] = self.filter.priceRange.priceRangeCounts[0] + 1
            }
            
            
            self.priceRangeVC?.bars = self.filter.priceRange.priceRangeCounts
            self.priceRangeVC?.priceListArr =  filterNew.priceRange.priceRangeList

            print(self.filter.priceRange.priceRangeList)
            print(self.priceRangeVC?.priceListArr)
            
            self.priceRangeVC?.updateRangeSliderValues(with: filterNew)
            self.btnNext.backgroundColor = APPCOLORS_3.EnabledOrange_BG
            //self.btnPrevious.backgroundColor = APPCOLORS_3.EnabledOrange_BG
        }
        
        if let task = datatask {
            NetworkingManager.shared.arrayPriceRangeTasks.add(task)
        }
        
    }
    
    
    func getPriceRanges ( _ succe: (() -> Void)?) {
                
        
        DashboardDataManagement.shared.getPriceRanges(filter: self.filter) { (priceRange) in
            
            if let range = priceRange {
                
                self.filter.defaultPriceRange = range
                
                self.filter.priceRange.priceStart = range.priceStart
                self.filter.priceRange.priceEnd = range.priceEnd
                                
                
                self.priceRangeVC?.updateRangeSliderValues(with: self.filter)
                
//                if self.viewTag != 104 {
//                    self.viewTag = self.viewTag + 1
//                }
//
//                self.showHideAllViews ()
                
//                self.priceRangeVC?.updateRangeSlider()
                
                if let succ = succe {
                    succ ()
                }
                
            }
        }
        
//        viewTag = viewTag - 1
    }
    
}
