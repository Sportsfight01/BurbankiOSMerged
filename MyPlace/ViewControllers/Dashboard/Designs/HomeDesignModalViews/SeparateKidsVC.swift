//
//  SeparateKidsVC.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 15/07/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit

class SeparateKidsVC: HomeDesignModalHeaderVC {
    
    //    @IBOutlet weak var contentView: UIView!
    
    
    @IBOutlet weak var separateKids_lbl: UILabel!
    @IBOutlet weak var separateKids_btnMust: UIButton!
    @IBOutlet weak var separateKids_btnDont: UIButton!
    @IBOutlet weak var separateKids_btnDont_want_this: UIButton!
    
    @IBOutlet weak var stackHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        // Do any additional setup after loading the view.
        
        separateKidsViewSetUp ()
        
        selectionAlertMessage = "Please select one option"

    }
    
    
    func separateKidsViewSetUp () {
        
        let str = "WOULD YOU NEED A SEPARATE KIDS LIVING AREA?"
        separateKids_lbl.text = str
        
        setAppearanceFor(view: separateKids_lbl, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_LABEL_BODY (size: FONT_19))
        
        
        setAppearanceFor(view: separateKids_btnMust, backgroundColor: COLOR_WHITE, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        setAppearanceFor(view: separateKids_btnDont, backgroundColor: COLOR_WHITE, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        setAppearanceFor(view: separateKids_btnDont_want_this, backgroundColor: COLOR_WHITE, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        
//
//        setBorder(view: separateKids_btnMust, color: COLOR_ORANGE, width: 1.0)
//        setBorder(view: separateKids_btnDont, color: COLOR_ORANGE, width: 1.0)
//        setBorder(view: separateKids_btnDont_want_this, color: COLOR_ORANGE, width: 1.0)
        
        
        separateKids_btnMust.layer.cornerRadius = radius_5
        separateKids_btnDont.layer.cornerRadius = radius_5
        separateKids_btnDont_want_this.layer.cornerRadius = radius_5
        
        if isDo_not_want_this_ENABLED{
            separateKids_btnDont_want_this.isHidden = false
            stackHeight = stackHeight.changeMultiplier(stackHeight, multiplier: 0.45)

        }else{
            separateKids_btnDont_want_this.isHidden = true
            stackHeight = stackHeight.changeMultiplier(stackHeight, multiplier: 0.25)

        }
        
    }
    
    
    //MARK: - Fill Selections
    
    func fillSelections () {
        
        separateKidsViewSetUp ()
        
        if homeDesignFeature?.selectedAnswer == DesignAnswer.must.rawValue {
            
            setAppearanceFor(view: separateKids_btnMust, backgroundColor: APPCOLORS_3.EnabledOrange_BG, textColor: COLOR_WHITE, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        }
        else if homeDesignFeature?.selectedAnswer == DesignAnswer.donotwantthis.rawValue  {
            
            setAppearanceFor(view: separateKids_btnDont_want_this, backgroundColor: APPCOLORS_3.EnabledOrange_BG, textColor: COLOR_WHITE, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        }else {
            
            setAppearanceFor(view: separateKids_btnDont, backgroundColor: APPCOLORS_3.EnabledOrange_BG, textColor: COLOR_WHITE, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        }
        
    }
    
    
    
    //MARK: - View Updates
    
    override func reloadView() {
        super.reloadView()
        
    }
    
    //MARK: - Clear
    
    override func clearSelections () {
        super.clearSelections()
        
        separateKidsViewSetUp ()
    }
    
    
    //MARK: - Actions
    
    @IBAction func handleSeparateKidsButtonsAction (_ sender: UIButton) {
        
        if sender == separateKids_btnMust {
            homeDesignFeature?.selectedAnswer = DesignAnswer.must.rawValue
            homeDesignFeature?.displayString = "Separate Kids Living Area"
        }
        else if sender == separateKids_btnDont_want_this {
            homeDesignFeature?.selectedAnswer = DesignAnswer.donotwantthis.rawValue
            homeDesignFeature?.displayString = ""
        }else {
            homeDesignFeature?.selectedAnswer = DesignAnswer.dontmind.rawValue
//            homeDesignFeature?.displayString = "NO SEPARATE KIDS"
            homeDesignFeature?.displayString = ""
        }
        
        fillSelections()
        
        if let selection = selectionUpdates {
            selection (self)
        }
        
    }
    
}
