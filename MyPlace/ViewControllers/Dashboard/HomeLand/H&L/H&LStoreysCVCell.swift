//
//  H&LStoreysCVCell.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 26/08/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit

class H_LStoreysCVCell: UICollectionViewCell {
    
    

    @IBOutlet weak var storeysView : UIView!

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
       
       
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        addView()
//
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    @IBAction func anyButtonTapped(sender: UIButton) {
            
//
//            if sender == btnDesignsCount {
//
//    //            if Int(self.filter.region.regionId)! == 0 {
//    //                showToast("Please select one region", self, .top)
//    //                return
//    //            }
//
//                if viewTag == 101, (btnDesignsCount.title(for: .normal)?.contains("SKIP"))! {
//
//                    viewTag = viewTag + 1
//
//                    self.filter = SortFilter ()
//
//                    selectStoreys ()
//                    selectBedrooms()
//
//
//                    updateDesignsCount()
//
//                    showHideAllViews ()
//
//
//                    return
//                }
//
//                if filter.priceRange.priceStart == 0 || filter.priceRange.priceEnd == 1 {
//
//    //                getPriceRanges {
//                        self.moveToHomeLandListPage ()
//    //                }
//                }else {
//
//                    self.moveToHomeLandListPage ()
//                }
//
//                return
//            }
//
//
//            if btnBack.isHidden {
//                showBackButton()
//            }
//
//            if viewTag == 101 {
//
//                myPlaceQuiz.region = sender.title(for: .normal)
//                filter.region = RegionMyPlace()
//
//    //            btnDesignsCount.setTitle("0 PACKAGES >", for: .normal)
//
//            }else if viewTag == 102 {
//
//
//                myPlaceQuiz.bedRoomCount = ""
//                filter.bedRoomsCount = .none
//
//
//                myPlaceQuiz.priceRangeLow = ""
//                myPlaceQuiz.priceRangeHigh = ""
//
//                filter.defaultPriceRange.priceStart = 0
//                filter.defaultPriceRange.priceEnd = 1
//
//                filter.priceRange.priceStart = 0
//                filter.priceRange.priceEnd = 1
//
//
//                if sender == storeys_btnSingle {
//
//                    myPlaceQuiz.storeysCount = "SINGLE"
//                    filter.storeysCount = .one
//                }else if sender == storeys_btnDouble {
//
//                    myPlaceQuiz.storeysCount = "DOUBLE"
//                    filter.storeysCount = .two
//                }else if sender == storeys_btnNotSure {
//
//                    myPlaceQuiz.storeysCount = ""
//                    filter.storeysCount = .ALL
//                }
//
//                selectStoreys ()
//
//
//                selectBedrooms()
//
//            }else if viewTag == 103 {
//
//                myPlaceQuiz.priceRangeLow = ""
//                myPlaceQuiz.priceRangeHigh = ""
//
//                filter.defaultPriceRange.priceStart = 0
//                filter.defaultPriceRange.priceEnd = 1
//
//
//                filter.priceRange.priceStart = 0
//                filter.priceRange.priceEnd = 1
//
//
//                if sender == bedrooms_btn3Bedrooms {
//
//                    myPlaceQuiz.bedRoomCount = "3 BED"
//                    filter.bedRoomsCount = .three
//
//                }else if sender == bedrooms_btn4Bedrooms {
//
//                    myPlaceQuiz.bedRoomCount = "4 BED"
//                    filter.bedRoomsCount = .four
//                }else if sender == bedrooms_btn5Bedrooms {
//
//                    myPlaceQuiz.bedRoomCount = "5+ BED"
//                    filter.bedRoomsCount = .five
//                }
//
//                selectBedrooms()
//
//                getPriceRanges (nil)
//
//            }else if viewTag == 104 {
//                if sender == price_btnContinue {
//
//                    myPlaceQuiz.priceRangeLow = "$\(Int((priceRangeVC?.rangeslider.lowerValue)!))K"
//                    myPlaceQuiz.priceRangeHigh = "$\(Int((priceRangeVC?.rangeslider.upperValue)!))K"
//
//
//                    filter.priceRange.priceStart = priceRangeVC?.rangeslider.lowerValue ?? 0
//                    filter.priceRange.priceEnd = priceRangeVC?.rangeslider.upperValue ?? 1
//
//                }else if sender == price_btnSkip {
//
//                    myPlaceQuiz.priceRangeLow = ""
//                    myPlaceQuiz.priceRangeHigh = ""
//
//                    filter.priceRange.priceStart = priceRangeVC?.rangeslider.minimumValue ?? 0
//                    filter.priceRange.priceEnd = priceRangeVC?.rangeslider.maximumValue ?? 1
//                }
//
//            }
//
//
//            if viewTag >= 104 {
//
//                moveToHomeLandListPage ()
//            }else {
//
//            }
//
//            updateDesignsCount()
//
//
//            showHideAllViews ()
        
        }
    
}
