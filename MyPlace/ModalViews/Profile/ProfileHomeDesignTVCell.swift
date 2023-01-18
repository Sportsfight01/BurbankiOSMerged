//
//  ProfileHomeDesignTVCell.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 27/07/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit

class ProfileHomeDesignTVCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var lBCount: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var lBTitle: UILabel!
    @IBOutlet weak var btnArrow: UIButton!
    
    
    
    @IBOutlet weak var btnSavedDesigns: UIButton!        
    
    @IBOutlet weak var lBLine: UILabel!
    
    
    var searchResultSortFilter: [NSDictionary]? {
        didSet {

            var features = [HomeDesignFeature] ()
            
            for feature in searchResultSortFilter! {
                features.append(HomeDesignFeature (recentSearch: feature))
            }
            
            homeDesignFeatures = features
            
            fillTheData()
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
        
        setAppearanceFor(view: lBCount, backgroundColor: APPCOLORS_3.Black_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_LABEL_SUB_HEADING(size: FONT_8))
        setAppearanceFor(view: lBTitle, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_LABEL_SUB_HEADING (size: FONT_14))
        setAppearanceFor(view: lBLine, backgroundColor: APPCOLORS_3.EnabledOrange_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_LABEL_BODY(size: FONT_10))
        
        
        setAppearanceFor(view: btnSavedDesigns, backgroundColor: APPCOLORS_3.HeaderFooter_white_BG, textColor: APPCOLORS_3.Orange_BG, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        
        
        btnSavedDesigns.layer.cornerRadius = radius_5 //5.0
        
        lBCount.layer.cornerRadius = lBCount.frame.size.height/2
        icon.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        icon.tintColor = .black
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
    
    func fillTheData () {
        
        
        let count = kDesignFavoritesCount
        
        let countText = count == 0 ? "NO" : "\(count)"
        let designs = count == 1 ? "DESIGN" : "DESIGNS"
        
        
        btnSavedDesigns.setTitle("\(countText) SAVED \(designs)", for: .normal)
        
        
//        lBCount.isHidden = kCollectionFavoritesCount == 0
        lBCount.text = "\(kDesignFavoritesCount)"

    }
    
    func fillTheData1 ( diplayFaoritesCount : Int ) {
        
        
        let count = diplayFaoritesCount
        let countText = count == 0 ? "NO" : "\(count)"
        let designs = count == 1 ? "DISPLAYS" : "DISPLAYS"
        
        
        btnSavedDesigns.setTitle("\(countText) SAVED \(designs)", for: .normal)
        
        
//        lBCount.isHidden = kCollectionFavoritesCount == 0
        lBCount.text = "\(diplayFaoritesCount)"

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
