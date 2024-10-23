//
//  MinorBedroomsVC.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 15/07/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit


class MinorBedroomsVC: HomeDesignModalHeaderVC {
    
    //    @IBOutlet weak var contentView: UIView!
    
    
    @IBOutlet weak var minorBedrooms_lbl: UILabel!
    @IBOutlet weak var minorBedrooms_btnMust: UIButton!
    @IBOutlet weak var minorBedrooms_btnDont: UIButton!
    @IBOutlet weak var minorBedrooms_btnDont_want_this: UIButton!
    
    @IBOutlet weak var stackHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        // Do any additional setup after loading the view.
        
        minorBedroomsViewSetUp ()
        
        
        selectionAlertMessage = "Please select one option"

    }
    
    
    
    func minorBedroomsViewSetUp () {
        
        let str = "DO YOU NEED THE BEDROOMS GROUPED IN A \"WING\" IN YOUR DESIGN?"
        minorBedrooms_lbl.text = str
        
        setAppearanceFor(view: minorBedrooms_lbl, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_BODY(size: FONT_19))
        
        
        minorBedrooms_btnMust.layer.cornerRadius = radius_5
        minorBedrooms_btnDont.layer.cornerRadius = radius_5
        minorBedrooms_btnDont_want_this.layer.cornerRadius = radius_5
        
        
        
        setAppearanceFor(view: minorBedrooms_btnMust, backgroundColor: APPCOLORS_3.HeaderFooter_white_BG, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        setAppearanceFor(view: minorBedrooms_btnDont, backgroundColor: APPCOLORS_3.HeaderFooter_white_BG, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        setAppearanceFor(view: minorBedrooms_btnDont_want_this, backgroundColor: APPCOLORS_3.HeaderFooter_white_BG, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        
        
//        setBorder(view: minorBedrooms_btnMust, color: APPCOLORS_3.Orange_BG, width: 1.0)
//        setBorder(view: minorBedrooms_btnDont, color: APPCOLORS_3.Orange_BG, width: 1.0)
//        setBorder(view: minorBedrooms_btnDont_want_this, color: APPCOLORS_3.Orange_BG, width: 1.0)
        
        
        minorBedrooms_btnMust.layer.cornerRadius = radius_5
        minorBedrooms_btnDont.layer.cornerRadius = radius_5
        minorBedrooms_btnDont_want_this.layer.cornerRadius = radius_5
        
        if isDo_not_want_this_ENABLED{
            minorBedrooms_btnDont_want_this.isHidden = false
            stackHeight = stackHeight.changeMultiplier(stackHeight, multiplier: 0.45)

        }else{
            minorBedrooms_btnDont_want_this.isHidden = true
            stackHeight = stackHeight.changeMultiplier(stackHeight, multiplier: 0.25)

        }
    }
    
    
    //MARK: - Fill Selections
    
    func fillSelections () {
        
        minorBedroomsViewSetUp ()
        
        if homeDesignFeature?.selectedAnswer == DesignAnswer.must.rawValue {
            
            setAppearanceFor(view: minorBedrooms_btnMust, backgroundColor: APPCOLORS_3.Orange_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        }
        else if homeDesignFeature?.selectedAnswer == DesignAnswer.donotwantthis.rawValue {
            
            setAppearanceFor(view: minorBedrooms_btnDont_want_this, backgroundColor: APPCOLORS_3.Orange_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        }
        else {
            
            setAppearanceFor(view: minorBedrooms_btnDont, backgroundColor: APPCOLORS_3.Orange_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        }
        
    }
    
    
    
    //MARK: - View Updates
    
    override func reloadView() {
        super.reloadView()
        
    }
    
    //MARK: - Clear
    
    override func clearSelections () {
        super.clearSelections()
        
        minorBedroomsViewSetUp ()
    }
    
    
    
    //MARK: - Actions
    
    @IBAction func handleMinorBedroomsButtonsAction (_ sender: UIButton) {
        
        if sender == minorBedrooms_btnMust {
            homeDesignFeature?.selectedAnswer = DesignAnswer.must.rawValue
            homeDesignFeature?.displayString = "Minor Bedrooms Wing"
        }else if sender == minorBedrooms_btnDont_want_this {
            homeDesignFeature?.selectedAnswer = DesignAnswer.donotwantthis.rawValue
            homeDesignFeature?.displayString = ""
        }
        else {
            homeDesignFeature?.selectedAnswer = DesignAnswer.dontmind.rawValue
            homeDesignFeature?.displayString = ""
        }
        
        fillSelections()
        
        if let selection = selectionUpdates {
            selection (self)
        }
        
    }
    
}
