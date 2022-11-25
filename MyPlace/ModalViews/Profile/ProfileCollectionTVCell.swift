//
//  ProfileCollectionTVCell.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 31/03/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit

class ProfileCollectionTVCell: UITableViewCell {
    
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
    @IBOutlet weak var lBPriceRange: UILabel!
    
    @IBOutlet weak var lBLineSearch: UILabel!
    
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var iconSearch: UIImageView!
    
    
    @IBOutlet weak var lBLine: UILabel!
    
    
    var searchResultSortFilter: [NSDictionary]? {
        didSet {
            fillTheData ()
        }
    }
    
    var homeDesignFeatures: [HomeDesignFeature]?
    var actionHandler: ((_ sender: UIButton) -> Void)?
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setAppearanceFor(view: lBCount, backgroundColor: COLOR_BLACK, textColor: COLOR_WHITE, textFont: FONT_LABEL_SUB_HEADING(size: FONT_8))
        setAppearanceFor(view: lBTitle, backgroundColor: COLOR_CLEAR, textColor: COLOR_WHITE, textFont: FONT_LABEL_SUB_HEADING (size: FONT_14))
        setAppearanceFor(view: lBLine, backgroundColor: COLOR_ORANGE_LIGHT, textColor: COLOR_WHITE, textFont: FONT_LABEL_BODY(size: FONT_10))
        
        
        setAppearanceFor(view: btnSavedDesigns, backgroundColor: COLOR_WHITE, textColor: COLOR_ORANGE, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        
        setAppearanceFor(view: lBRecentSearch, backgroundColor: COLOR_CLEAR, textColor: COLOR_DARK_GRAY, textFont: FONT_LABEL_SUB_HEADING(size: FONT_15))
        setAppearanceFor(view: lBPriceRange, backgroundColor: COLOR_CLEAR, textColor: COLOR_DARK_GRAY, textFont: FONT_LABEL_SUB_HEADING (size: FONT_12))
        
        
        setAppearanceFor(view: btnSearch, backgroundColor: COLOR_ORANGE, textColor: COLOR_ORANGE, textFont: FONT_BUTTON_BODY(size: FONT_10))
        
        
        btnSavedDesigns.layer.cornerRadius = radius_5 //5.0
        bottomViewBottom.layer.cornerRadius = radius_5 //5.0
        
        btnSearch.layer.cornerRadius = radius_5 //5.0
        
        lBCount.layer.cornerRadius = lBCount.frame.size.height/2
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
    
    func fillTheData () {
        
        let count = kCollectionFavoritesCount
            
        btnSavedDesigns.setTitle(String.init(format: "\(count) %@", count == 1 ? "DESIGN" : "DESIGNS"), for: .normal)
        
        
        lBCount.text = "\(kCollectionFavoritesCount)"

        
        if let recentFeatures = searchResultSortFilter {
            
            var features = [HomeDesignFeature] ()
            
            for feature in recentFeatures {
                features.append(HomeDesignFeature (recentSearch: feature))
            }
            
            homeDesignFeatures = features
            
            self.lBPriceRange.text = displayTextWithDesignFeatures(features).capitalized
        }
                
    }
    
    
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
