//
//  MasterBedroomVC.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 15/07/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit

class MasterBedroomVC: HomeDesignModalHeaderVC {
        
    
    @IBOutlet weak var bedroomFront_lBBedroomFront: UILabel!
    
    @IBOutlet weak var bedroomFront_btnMust: UIButton!
    @IBOutlet weak var bedroomFront_btnDont: UIButton!
    
    @IBOutlet weak var bedroomFront_btnDont_want_this: UIButton!
    
    @IBOutlet weak var stackHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        bedroomFrontViewSetUp ()
        
        selectionAlertMessage = "Please select one option"

    }
    
    
    
    
    func bedroomFrontViewSetUp () {
        
        setAppearanceFor(view: bedroomFront_lBBedroomFront, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_LABEL_BODY (size: FONT_19))
        
        bedroomFront_btnMust.layer.cornerRadius = radius_5
        bedroomFront_btnDont.layer.cornerRadius = radius_5
        bedroomFront_btnDont_want_this.layer.cornerRadius = radius_5
        
        setAppearanceFor(view: bedroomFront_btnMust, backgroundColor: COLOR_WHITE, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        setAppearanceFor(view: bedroomFront_btnDont_want_this, backgroundColor: COLOR_WHITE, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        setAppearanceFor(view: bedroomFront_btnDont, backgroundColor: COLOR_WHITE, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        
        
        
//        setBorder(view: bedroomFront_btnMust, color: COLOR_ORANGE, width: 1.0)
//        setBorder(view: bedroomFront_btnDont, color: COLOR_ORANGE, width: 1.0)
//        setBorder(view: bedroomFront_btnDont_want_this, color: COLOR_ORANGE, width: 1.0)
        
        if isDo_not_want_this_ENABLED{
            bedroomFront_btnDont_want_this.isHidden = false
            stackHeight = stackHeight.changeMultiplier(stackHeight, multiplier: 0.45)
        }else{
            bedroomFront_btnDont_want_this.isHidden = true
            stackHeight = stackHeight.changeMultiplier(stackHeight, multiplier: 0.25)
        }
    }
    
    
    //MARK: - Fill Selections
    
    func fillSelections () {
        
        bedroomFrontViewSetUp ()
        
        if homeDesignFeature?.selectedAnswer == DesignAnswer.must.rawValue {
            
            setAppearanceFor(view: bedroomFront_btnMust, backgroundColor: APPCOLORS_3.EnabledOrange_BG, textColor: COLOR_WHITE, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        }
        else if homeDesignFeature?.selectedAnswer == DesignAnswer.donotwantthis.rawValue {

            setAppearanceFor(view: bedroomFront_btnDont_want_this, backgroundColor: APPCOLORS_3.EnabledOrange_BG, textColor: COLOR_WHITE, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        }
        else {
            
            setAppearanceFor(view: bedroomFront_btnDont, backgroundColor: APPCOLORS_3.EnabledOrange_BG, textColor: COLOR_WHITE, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        }
        
    }
    
    //MARK: - View Updates
    
    override func reloadView() {
        super.reloadView()
        
    }
    //MARK: - Clear
    
    override func clearSelections () {
        super.clearSelections()
        
        bedroomFrontViewSetUp()
        
    }
    
    
    //MARK: - Actions
    
    @IBAction func handleMasterBedroomsButtonsAction (_ sender: UIButton) {
        
        if sender == bedroomFront_btnMust {
            homeDesignFeature?.selectedAnswer = DesignAnswer.must.rawValue
            homeDesignFeature?.displayString = "Bedroom At Front"
        }
        else if sender == bedroomFront_btnDont_want_this {
            homeDesignFeature?.selectedAnswer = DesignAnswer.donotwantthis.rawValue
            homeDesignFeature?.displayString = ""
        }
        else {
            homeDesignFeature?.selectedAnswer = DesignAnswer.dontmind.rawValue
//            homeDesignFeature?.displayString = "NO FRONT BEDROOM"
            homeDesignFeature?.displayString = ""
        }
        
        fillSelections()
        
        if let selection = selectionUpdates {
            selection (self)
        }
        
    }
}
