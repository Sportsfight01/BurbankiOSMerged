//
//  StraightCorridorVC.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 15/07/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit

class StraightCorridorVC: HomeDesignModalHeaderVC {
    
    //    @IBOutlet weak var contentView: UIView!
    
    
    @IBOutlet weak var straightCorridor_lbl: UILabel!
    @IBOutlet weak var straightCorridor_btnMust: UIButton!
    @IBOutlet weak var straightCorridor_btnDont: UIButton!
    @IBOutlet weak var straightCorridor_btnDont_want_this: UIButton!
    
    @IBOutlet weak var stackHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        straightCorridorViewSetUp ()
        
        selectionAlertMessage = "Please select one option"
        
    }
    
    
    
    func straightCorridorViewSetUp () {
        
        let str = "DO YOU PREFER A STRAIGHT CORRIDOR AT THE ENTRY?"
        straightCorridor_lbl.text = str
        
        setAppearanceFor(view: straightCorridor_lbl, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_BODY(size: FONT_19))
        
        
        setAppearanceFor(view: straightCorridor_btnMust, backgroundColor: APPCOLORS_3.HeaderFooter_white_BG, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        setAppearanceFor(view: straightCorridor_btnDont, backgroundColor: APPCOLORS_3.HeaderFooter_white_BG, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        setAppearanceFor(view: straightCorridor_btnDont_want_this, backgroundColor: APPCOLORS_3.HeaderFooter_white_BG, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        
        
//        setBorder(view: straightCorridor_btnMust, color: APPCOLORS_3.Orange_BG, width: 1.0)
//        setBorder(view: straightCorridor_btnDont, color: APPCOLORS_3.Orange_BG, width: 1.0)
//        setBorder(view: straightCorridor_btnDont_want_this, color: APPCOLORS_3.Orange_BG, width: 1.0)
        
        
        straightCorridor_btnMust.layer.cornerRadius = radius_5
        straightCorridor_btnDont.layer.cornerRadius = radius_5
        straightCorridor_btnDont_want_this.layer.cornerRadius = radius_5
        
        if isDo_not_want_this_ENABLED{
            straightCorridor_btnDont_want_this.isHidden = false
            stackHeight = stackHeight.changeMultiplier(stackHeight, multiplier: 0.45)

        }else{
            straightCorridor_btnDont_want_this.isHidden = true
            stackHeight = stackHeight.changeMultiplier(stackHeight, multiplier: 0.25)

        }
    }
    
    
    //MARK: - Fill Selections
    
    func fillSelections () {
        
        straightCorridorViewSetUp ()
        
        if homeDesignFeature?.selectedAnswer == DesignAnswer.must.rawValue {
            
            setAppearanceFor(view: straightCorridor_btnMust, backgroundColor: APPCOLORS_3.EnabledOrange_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        }else if homeDesignFeature?.selectedAnswer == DesignAnswer.donotwantthis.rawValue  {
            
            setAppearanceFor(view: straightCorridor_btnDont_want_this, backgroundColor: APPCOLORS_3.EnabledOrange_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        }
        else {
            
            setAppearanceFor(view: straightCorridor_btnDont, backgroundColor: APPCOLORS_3.EnabledOrange_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        }
        
    }
    
    
    
    //MARK: - View Updates
    
    override func reloadView() {
        super.reloadView()
        
    }
    
    //MARK: - Clear
    
    override func clearSelections () {
        super.clearSelections()
        
        straightCorridorViewSetUp ()
    }
    
    
    
    //MARK: - Actions
    
    @IBAction func handleStraightCorridorButtonsAction (_ sender: UIButton) {
        
        if sender == straightCorridor_btnMust {
            homeDesignFeature?.selectedAnswer = DesignAnswer.must.rawValue
            homeDesignFeature?.displayString = "Straight Corridor"
        }else if sender == straightCorridor_btnDont_want_this  {
            homeDesignFeature?.selectedAnswer = DesignAnswer.donotwantthis.rawValue
            homeDesignFeature?.displayString = ""
        }
        else {
            homeDesignFeature?.selectedAnswer = DesignAnswer.dontmind.rawValue
//            homeDesignFeature?.displayString = "NO STRAIGHT CORRIDOR"
            homeDesignFeature?.displayString = ""
        }
        
        fillSelections ()
        
        if let selection = selectionUpdates {
            selection (self)
        }
        
    }
    
}
