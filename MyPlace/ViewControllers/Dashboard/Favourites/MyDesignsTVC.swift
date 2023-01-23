//
//  MyDesignsTVC.swift
//  BurbankApp
//
//  Created by Naveen Kourampalli on 23/11/22.
//  Copyright © 2022 Sreekanth tadi. All rights reserved.
//

import UIKit

class MyDesignsTVC: UITableViewCell {
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var lbRecentSearch: UILabel!
    
    @IBOutlet weak var lbRecentSearchTitle: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var lBCount: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var lBTitle: UILabel!
    @IBOutlet weak var btnArrow: UIButton!
    
    @IBOutlet weak var btnSearch: UIButton!
    
    
    @IBOutlet weak var btnSavedDesigns: UIButton!
    
    @IBOutlet weak var lBLine: UILabel!
    
    
    var searchResultSortFilter: [NSDictionary]? {
        didSet {

            var features = [HomeDesignFeature] ()
            
            for feature in searchResultSortFilter! {
                features.append(HomeDesignFeature (recentSearch: feature))
            }
            
            homeDesignFeatures = features
            
            fillTheData(features: features)
        }
    }
//    var searchResultSortFilter1: [NSDictionary]? {
//        didSet {
//
//            fillTheData1()
//        }
//    }

    
        
    
    var homeDesignFeatures: [HomeDesignFeature]?
    var actionHandler: ((_ sender: UIButton) -> Void)?
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnArrow.tintColor = APPCOLORS_3.GreyTextFont
        setAppearanceFor(view: lBCount, backgroundColor: APPCOLORS_3.EnabledOrange_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_LABEL_HEADING(size: FONT_12))
        setAppearanceFor(view: lBTitle, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_SUB_HEADING (size: FONT_14))
        setAppearanceFor(view: lBLine, backgroundColor: APPCOLORS_3.Orange_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_LABEL_BODY(size: FONT_10))
        
        
        setAppearanceFor(view: btnSavedDesigns, backgroundColor: APPCOLORS_3.EnabledOrange_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        
        setAppearanceFor(view: lbRecentSearchTitle, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_SUB_HEADING(size: FONT_15))
        setAppearanceFor(view: lbRecentSearch, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_SUB_HEADING (size: FONT_12))
        
        
        setAppearanceFor(view: btnSearch, backgroundColor: APPCOLORS_3.Orange_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_BODY(size: FONT_10))

        
        
        
        btnSavedDesigns.layer.cornerRadius = radius_5 //5.0
        
        lBCount.layer.cornerRadius = lBCount.frame.size.height/2
        icon.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        icon.tintColor = .black
        
        let count = kDesignFavoritesCount
        
        let countText = count == 0 ? "NO" : "\(count)"
        let designs = count == 1 ? "DESIGN" : "DESIGNS"
        
        
        btnSavedDesigns.setTitle("\(countText) SAVED \(designs)", for: .normal)
        btnSavedDesigns.backgroundColor = count == 0 ? APPCOLORS_3.LightGreyDisabled_BG : APPCOLORS_3.EnabledOrange_BG
        btnSavedDesigns.isUserInteractionEnabled = count == 0 ? false : true
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
    
    func fillTheData(features : [HomeDesignFeature]) {
    
        
//        lBCount.isHidden = kCollectionFavoritesCount == 0
        lBCount.text = "\(kDesignFavoritesCount)"
        let displaytext = displayTextWithDesignFeatures(features).capitalized
//        print(displaytext)
        lbRecentSearch.numberOfLines = 0
        lbRecentSearch.text = displaytext

    }
    
//    func fillTheData1 ( diplayFaoritesCount : Int ) {
//        
//        
//        let count = diplayFaoritesCount
//        let countText = count == 0 ? "NO" : "\(count)"
//        let designs = count == 1 ? "DISPLAYS" : "DISPLAYS"
//        
//        
//        btnSavedDesigns.setTitle("\(countText) SAVED \(designs)", for: .normal)
//        
//        
////        lBCount.isHidden = kCollectionFavoritesCount == 0
//        lBCount.text = "\(diplayFaoritesCount)"
//
//    }

    func displayTextWithDesignFeatures (_ features: [HomeDesignFeature]) -> String {
        
        var displayValue = ""
        
        for feature in features {
            displayValue = addSpaceandnewValue(displayValue, feature.displayString)
        }
        
        if displayValue == "" {
            displayValue = infoStaicText
        }
        
        return displayValue
    }

    
    @IBAction func handleButtonActions (_ sender: UIButton) {
        
        if let action = actionHandler {
            action(sender)
        }
        
    }
    


}
