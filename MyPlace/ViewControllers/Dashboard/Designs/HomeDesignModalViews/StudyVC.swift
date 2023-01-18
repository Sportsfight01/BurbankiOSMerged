//
//  StudyVC.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 15/07/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit

class StudyVC: HomeDesignModalHeaderVC {
    
    //    @IBOutlet weak var contentView: UIView!
    
    
    @IBOutlet weak var study_lBStudy: UILabel!
    @IBOutlet weak var study_btnMust: UIButton!
    @IBOutlet weak var study_btnDont: UIButton!
    @IBOutlet weak var study_btnDont_want_this: UIButton!
    
    @IBOutlet weak var stackHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        studyViewSetUp ()
        
        selectionAlertMessage = "Please select one option"

    }
    
    
    
    
    func studyViewSetUp () {
        
        let str = "DO YOU NEED A\nSTUDY IN YOUR DESIGN?"
        study_lBStudy.text = str
        
        setAppearanceFor(view: study_lBStudy, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_LABEL_BODY (size: FONT_19))
        
        
        setAppearanceFor(view: study_btnMust, backgroundColor: COLOR_WHITE, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        setAppearanceFor(view: study_btnDont, backgroundColor: COLOR_WHITE, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        setAppearanceFor(view: study_btnDont_want_this, backgroundColor: COLOR_WHITE, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        
        
//        setBorder(view: study_btnMust, color: COLOR_ORANGE, width: 1.0)
//        setBorder(view: study_btnDont, color: COLOR_ORANGE, width: 1.0)
//        setBorder(view: study_btnDont_want_this, color: COLOR_ORANGE, width: 1.0)
        
        
        study_btnMust.layer.cornerRadius = radius_5
        study_btnDont.layer.cornerRadius = radius_5
        study_btnDont_want_this.layer.cornerRadius = radius_5
        
        if isDo_not_want_this_ENABLED{
            study_btnDont_want_this.isHidden = false
            stackHeight = stackHeight.changeMultiplier(stackHeight, multiplier: 0.45)

        }else{
            stackHeight = stackHeight.changeMultiplier(stackHeight, multiplier: 0.25)
            study_btnDont_want_this.isHidden = true
        }
    }
    
    
    //MARK: - Fill Selections
    
    func fillSelections () {
        
        studyViewSetUp ()
        
        if homeDesignFeature?.selectedAnswer == DesignAnswer.must.rawValue {
            
            setAppearanceFor(view: study_btnMust, backgroundColor: APPCOLORS_3.EnabledOrange_BG, textColor: COLOR_WHITE, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        }else if homeDesignFeature?.selectedAnswer == DesignAnswer.donotwantthis.rawValue {
            
            setAppearanceFor(view: study_btnDont_want_this, backgroundColor: APPCOLORS_3.EnabledOrange_BG, textColor: COLOR_WHITE, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        }
        else {
            
            setAppearanceFor(view: study_btnDont, backgroundColor: APPCOLORS_3.EnabledOrange_BG, textColor: COLOR_WHITE, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        }
        
    }
    
    //MARK: - View Updates
    
    override func reloadView() {
        super.reloadView()
        
    }
    
    //MARK: - Clear
    
    override func clearSelections () {
        super.clearSelections()
        
        studyViewSetUp()
    }
    
    
    //MARK: - Actions
    
    @IBAction func handleStudyButtonsAction (_ sender: UIButton) {
        
        if sender == study_btnMust {
            homeDesignFeature?.selectedAnswer = DesignAnswer.must.rawValue
            homeDesignFeature?.displayString = "Study"
        }
        else if sender == study_btnDont_want_this{
            homeDesignFeature?.selectedAnswer = DesignAnswer.donotwantthis.rawValue
            homeDesignFeature?.displayString = ""
        }else {
            homeDesignFeature?.selectedAnswer = DesignAnswer.dontmind.rawValue
            homeDesignFeature?.displayString = ""
        }
        
        fillSelections ()
        
        if let selection = selectionUpdates {
            selection (self)
        }
        
    }
    
}
