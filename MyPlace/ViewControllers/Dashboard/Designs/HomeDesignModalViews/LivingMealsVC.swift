//
//  LivingMealsVC.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 15/07/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit

class LivingMealsVC: HomeDesignModalHeaderVC {
    
    //    @IBOutlet weak var contentView: UIView!
    
    
    @IBOutlet weak var livingMeals_lbl: UILabel!
    @IBOutlet weak var livingMeals_btnMust: UIButton!
    @IBOutlet weak var livingMeals_btnDont: UIButton!
    @IBOutlet weak var livingMeals_btnDont_want_this: UIButton!
    
    @IBOutlet weak var stackHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()        
        // Do any additional setup after loading the view.
        
        livingMealsViewSetUp ()
        
        selectionAlertMessage = "Please select one option"
    }
    
    
    func livingMealsViewSetUp () {
        
        let str = "DO YOU PREFER THE LIVING MEALS ACROSS THE ENTIRE REAR OF YOUR DESIGN?"
        livingMeals_lbl.text = str
        
        setAppearanceFor(view: livingMeals_lbl, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_LABEL_BODY(size: FONT_19))
        
        
        livingMeals_btnMust.layer.cornerRadius = radius_5
        livingMeals_btnDont.layer.cornerRadius = radius_5
        livingMeals_btnDont_want_this.layer.cornerRadius = radius_5
        
        
        
        setAppearanceFor(view: livingMeals_btnMust, backgroundColor: COLOR_WHITE, textColor: COLOR_ORANGE, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        setAppearanceFor(view: livingMeals_btnDont, backgroundColor: COLOR_WHITE, textColor: COLOR_ORANGE, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        setAppearanceFor(view: livingMeals_btnDont_want_this, backgroundColor: COLOR_WHITE, textColor: COLOR_ORANGE, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        
        
        setBorder(view: livingMeals_btnMust, color: COLOR_ORANGE, width: 1.0)
        setBorder(view: livingMeals_btnDont, color: COLOR_ORANGE, width: 1.0)
        setBorder(view: livingMeals_btnDont_want_this, color: COLOR_ORANGE, width: 1.0)
        
        if isDo_not_want_this_ENABLED{
            livingMeals_btnDont_want_this.isHidden = false
            stackHeight = stackHeight.changeMultiplier(stackHeight, multiplier: 0.45)

        }else{
            livingMeals_btnDont_want_this.isHidden = true
            stackHeight = stackHeight.changeMultiplier(stackHeight, multiplier: 0.25)

        }
        
    }
    
    
    //MARK: - Fill Selections
    
    func fillSelections () {
        
        livingMealsViewSetUp ()
        
        if homeDesignFeature?.selectedAnswer == DesignAnswer.must.rawValue {
            
            setAppearanceFor(view: livingMeals_btnMust, backgroundColor: COLOR_ORANGE, textColor: COLOR_WHITE, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        }
        else if homeDesignFeature?.selectedAnswer == DesignAnswer.donotwantthis.rawValue {
            
            setAppearanceFor(view: livingMeals_btnDont_want_this, backgroundColor: COLOR_ORANGE, textColor: COLOR_WHITE, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        }
        else {
            
            setAppearanceFor(view: livingMeals_btnDont, backgroundColor: COLOR_ORANGE, textColor: COLOR_WHITE, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        }
        
    }
    
    
    
    //MARK: - View Updates
    
    override func reloadView() {
        super.reloadView()
        
    }
    
    //MARK: - Clear
    
    override func clearSelections () {
        super.clearSelections()
        
        livingMealsViewSetUp ()
    }
    
    
    
    //MARK: - Actions
    
    @IBAction func handleLivingMealsButtonsAction (_ sender: UIButton) {
        
        if sender == livingMeals_btnMust {
            homeDesignFeature?.selectedAnswer = DesignAnswer.must.rawValue
            homeDesignFeature?.displayString = "Living/Meals Entire Rear"
        }
        else if sender == livingMeals_btnDont_want_this {
            homeDesignFeature?.selectedAnswer = DesignAnswer.donotwantthis.rawValue
            homeDesignFeature?.displayString = ""
        }
        else{
            homeDesignFeature?.selectedAnswer = DesignAnswer.dontmind.rawValue
//            homeDesignFeature?.displayString = "NO LIVING MEALS"
            homeDesignFeature?.displayString = ""
        }
        
        fillSelections()
        
        if let selection = selectionUpdates {
            selection (self)
        }
        
    }
    
}
