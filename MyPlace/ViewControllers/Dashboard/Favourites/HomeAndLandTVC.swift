//
//  HomeAndLandTVC.swift
//  BurbankApp
//
//  Created by Naveen Kourampalli on 23/11/22.
//  Copyright © 2022 Sreekanth tadi. All rights reserved.
//

import UIKit

class HomeAndLandTVC: UITableViewCell {
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var lBCount: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var lBTitle: UILabel!
    @IBOutlet weak var btnArrow: UIButton!

    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var btnSavedDesigns: UIButton!
    
    @IBOutlet weak var bottomViewBottom: UIView!

    @IBOutlet weak var lBRecentSearch: UILabel!
    @IBOutlet weak var lBRegion: UILabel!
    @IBOutlet weak var lBPriceRange: UILabel!

    
    @IBOutlet weak var lBLineSearch: UILabel!
    @IBOutlet weak var lBLineRegion: UILabel!
    @IBOutlet weak var lBLinePrice: UILabel!
    @IBOutlet weak var lBLineHouse: UILabel!

    @IBOutlet weak var iconHouse: UIImageView!
    @IBOutlet weak var lBNameHouse: UILabel!

    @IBOutlet weak var iconBedRoom: UIImageView!
    @IBOutlet weak var lBNameBedRoom: UILabel!

    @IBOutlet weak var iconParking: UIImageView!
    @IBOutlet weak var lBNameParking: UILabel!

    @IBOutlet weak var iconBathroom: UIImageView!
    @IBOutlet weak var lBNameBathroom: UILabel!

    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var iconSearch: UIImageView!

    
    @IBOutlet weak var lBLine: UILabel!
    
    
    var actionHandler: ((_ action: UIButton) -> Void )?
    
    
    
    var searchResultSortFilter: SortFilter? {
        didSet {
            fillTheData(searchResultSortFilter!)
        }
    }
    
    
//    var collection: String? {
//        didSet {
//            fillTheData()
//        }
//    }
//
//    var homeLand: String? {
//        didSet {
//            fillTheData(homeLand: true)
//        }
//    }

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnArrow.tintColor = .lightGray
        setAppearanceFor(view: lBCount, backgroundColor: AppColors.appOrange, textColor: COLOR_WHITE, textFont: FONT_LABEL_HEADING(size: FONT_12))
        setAppearanceFor(view: lBTitle, backgroundColor: COLOR_CLEAR, textColor: COLOR_GRAY, textFont: FONT_LABEL_SUB_HEADING (size: FONT_14))
        setAppearanceFor(view: lBLine, backgroundColor: COLOR_ORANGE_LIGHT, textColor: COLOR_WHITE, textFont: FONT_LABEL_BODY(size: FONT_10))

        
        setAppearanceFor(view: btnSavedDesigns, backgroundColor: COLOR_ORANGE, textColor: COLOR_WHITE, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        
        setAppearanceFor(view: lBRecentSearch, backgroundColor: COLOR_CLEAR, textColor: COLOR_DARK_GRAY, textFont: FONT_LABEL_SUB_HEADING(size: FONT_15))
        setAppearanceFor(view: lBRegion, backgroundColor: COLOR_CLEAR, textColor: COLOR_DARK_GRAY, textFont: FONT_LABEL_SUB_HEADING (size: FONT_12))
        setAppearanceFor(view: lBPriceRange, backgroundColor: COLOR_CLEAR, textColor: COLOR_DARK_GRAY, textFont: FONT_LABEL_SUB_HEADING (size: FONT_12))
        
        
        setAppearanceFor(view: lBNameHouse, backgroundColor: COLOR_CLEAR, textColor: COLOR_DARK_GRAY, textFont: FONT_LABEL_SUB_HEADING(size: FONT_12))
        setAppearanceFor(view: lBNameBedRoom, backgroundColor: COLOR_CLEAR, textColor: COLOR_DARK_GRAY, textFont: FONT_LABEL_SUB_HEADING(size: FONT_12))
        setAppearanceFor(view: lBNameParking, backgroundColor: COLOR_CLEAR, textColor: COLOR_DARK_GRAY, textFont: FONT_LABEL_SUB_HEADING(size: FONT_12))
        setAppearanceFor(view: lBNameBathroom, backgroundColor: COLOR_CLEAR, textColor: COLOR_DARK_GRAY, textFont: FONT_LABEL_SUB_HEADING(size: FONT_12))
        
        
        setAppearanceFor(view: btnSearch, backgroundColor: COLOR_ORANGE, textColor: COLOR_ORANGE, textFont: FONT_BUTTON_HEADING(size: FONT_10))
        

        let price1 = "$0K"
        let price2 = "$1K"

        _ = setAttributetitleFor(view: lBPriceRange, title: "Price Range \(price1) to \(price2)", rangeStrings: ["Price Range", "\(price1) to \(price2)"], colors: [COLOR_ORANGE, COLOR_DARK_GRAY], fonts: [FONT_LABEL_SUB_HEADING (size: FONT_12), FONT_LABEL_SUB_HEADING (size: FONT_12)], alignmentCenter: false)

        
        let region = "North"
        
        _ = setAttributetitleFor(view: lBRegion, title: "Region \(region)", rangeStrings: ["Region", "\(region)"], colors: [COLOR_ORANGE, COLOR_DARK_GRAY], fonts: [FONT_LABEL_SUB_HEADING (size: FONT_12), FONT_LABEL_SUB_HEADING (size: FONT_12)], alignmentCenter: false)

        
        btnSavedDesigns.layer.cornerRadius = radius_5 //5.0
        bottomViewBottom.layer.cornerRadius = radius_5 //5.0
        
        btnSearch.layer.cornerRadius = radius_5 //5.0


        lBCount.layer.cornerRadius = lBCount.frame.size.height/2
        
        
        btnSearch.addTarget(self, action: #selector(handleButtonActions(_:)), for: .touchUpInside)
        btnSavedDesigns.addTarget(self, action: #selector(handleButtonActions(_:)), for: .touchUpInside)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
    func fillTheData (_ filter: SortFilter) {
        
        let count = kHomeLandFavoritesCount
        
        let countText = count == 0 ? "NO" : "\(count)"
        let designs = count == 1 ? "PACKAGE" : "PACKAGES"
        
        
        btnSavedDesigns.setTitle("\(countText) SAVED \(designs)", for: .normal)
        

//         lBCount.isHidden = kHomeLandFavoritesCount == 0

         lBCount.text = "\(kHomeLandFavoritesCount)"
        
        
        
//        var region = filter.region.regionName
        
        let regionsArr =  filter.regionsArr.map{ $0.regionName }
        print("----1-1-1-1-1,",regionsArr)
        let regions = regionsArr.joined(separator: ",")
        print("----1-1-1-1-1,",regions)
        
        var region = regions
        
        if region == "" {
            region = ""
        }
            
        _ = setAttributetitleFor(view: lBRegion, title: "Region \(region)", rangeStrings: ["Region"], colors: [COLOR_ORANGE], fonts: [regularFontWith(size: FONT_12)], alignmentCenter: false)
        
        
//        if region.count > 0 {
            
        let price1 = String.init(format: "$\(filter.priceRange.priceStartStringValue)K")
        let price2 = String.init(format: "$\(filter.priceRange.priceEndStringValue)K")
            
            
            _ = setAttributetitleFor(view: lBPriceRange, title: "Price Range \(price1) to \(price2)", rangeStrings: ["Price Range"], colors: [ COLOR_ORANGE], fonts: [regularFontWith(size: FONT_12)], alignmentCenter: false)
//        }else {
//            _ = setAttributetitleFor(view: lBPriceRange, title: "Price Range", rangeStrings: ["Price Range"], colors: [ COLOR_ORANGE], fonts: [regularFontWith(size: FONT_12)], alignmentCenter: false)
//        }
        
        
        lBNameBedRoom.text = filter.bedRoomsCount.rawValue.capitalized
        lBNameHouse.text = filter.storeysCount.rawValue.capitalized
        lBNameParking.text = filter.CarSpacesCount.rawValue.capitalized
        lBNameBathroom.text = filter.BathRoomsCount.rawValue.capitalized
                
    }
    
    
    
    @IBAction func handleButtonActions (_ sender: UIButton) {
        
        if let action = actionHandler {
            action(sender)
        }
        
    }
    
    
}
