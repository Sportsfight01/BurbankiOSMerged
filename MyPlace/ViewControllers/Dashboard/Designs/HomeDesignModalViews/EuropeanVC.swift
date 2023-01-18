//
//  EuropeanVC.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 15/07/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit

class EuropeanVC: HomeDesignModalHeaderVC {
    
    //    @IBOutlet weak var contentView: UIView!
    
    
    @IBOutlet weak var europeanLaundry_lbl: UILabel!
    @IBOutlet weak var europeanLaundry_btnMust: UIButton!
    @IBOutlet weak var europeanLaundry_btnDont: UIButton!
    @IBOutlet weak var europeanLaundry_btnDont_want_this: UIButton!
    
    @IBOutlet weak var stackHeight: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        // Do any additional setup after loading the view.
        
        europeanViewSetUp ()
        
        selectionAlertMessage = "Please select one option"
    }
    
    
    
    func europeanViewSetUp () {
        
        let str = "DO YOU PREFER A EUROPEAN (CUPBOARD) LAUNDRY IN YOUR DESIGN?"
        europeanLaundry_lbl.text = str
        
        setAppearanceFor(view: europeanLaundry_lbl, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_BODY (size: FONT_19))
        
        
        setAppearanceFor(view: europeanLaundry_btnMust, backgroundColor: APPCOLORS_3.HeaderFooter_white_BG, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        setAppearanceFor(view: europeanLaundry_btnDont, backgroundColor: APPCOLORS_3.HeaderFooter_white_BG, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        setAppearanceFor(view: europeanLaundry_btnDont_want_this, backgroundColor: APPCOLORS_3.HeaderFooter_white_BG, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        
//
//        setBorder(view: europeanLaundry_btnMust, color: APPCOLORS_3.Orange_BG, width: 1.0)
//        setBorder(view: europeanLaundry_btnDont, color: APPCOLORS_3.Orange_BG, width: 1.0)
//        setBorder(view: europeanLaundry_btnDont_want_this, color: APPCOLORS_3.Orange_BG, width: 1.0)
//
        
        europeanLaundry_btnMust.layer.cornerRadius = radius_5
        europeanLaundry_btnDont.layer.cornerRadius = radius_5
        europeanLaundry_btnDont_want_this.layer.cornerRadius = radius_5
        
        if isDo_not_want_this_ENABLED{
            europeanLaundry_btnDont_want_this.isHidden = false
            stackHeight = stackHeight.changeMultiplier(stackHeight, multiplier: 0.45)

        }else{
            europeanLaundry_btnDont_want_this.isHidden = true
            stackHeight = stackHeight.changeMultiplier(stackHeight, multiplier: 0.25)

        }
        
    }
    
    
    //MARK: - View Updates
    
    override func reloadView() {
        super.reloadView()
        
    }
    
    //MARK: - Fill Selections
    
    func fillSelections () {
        
        europeanViewSetUp ()
        
        if homeDesignFeature?.selectedAnswer == DesignAnswer.must.rawValue {
            
            setAppearanceFor(view: europeanLaundry_btnMust, backgroundColor: APPCOLORS_3.EnabledOrange_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        }else if homeDesignFeature?.selectedAnswer == DesignAnswer.donotwantthis.rawValue {
            
            setAppearanceFor(view: europeanLaundry_btnDont_want_this, backgroundColor: APPCOLORS_3.EnabledOrange_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        }
        else {
            
            setAppearanceFor(view: europeanLaundry_btnDont, backgroundColor: APPCOLORS_3.EnabledOrange_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        }
        
    }
    
    
    
    //MARK: - Clear
    
    override func clearSelections () {
        super.clearSelections()
        
        europeanViewSetUp ()
    }
    
    
    
    //MARK: - Actions
    
    @IBAction func handleEuropeanButtonsAction (_ sender: UIButton) {
        
        if sender == europeanLaundry_btnMust {
            homeDesignFeature?.selectedAnswer = DesignAnswer.must.rawValue
            homeDesignFeature?.displayString = "European Laundry"
        }else if sender == europeanLaundry_btnDont_want_this {
            homeDesignFeature?.selectedAnswer = DesignAnswer.donotwantthis.rawValue
            homeDesignFeature?.displayString = ""
        }
        else {
            homeDesignFeature?.selectedAnswer = DesignAnswer.dontmind.rawValue
//            homeDesignFeature?.displayString = "NO EUROPEAN"
            homeDesignFeature?.displayString = ""
        }
        
        fillSelections()
        
        if let selection = selectionUpdates {
            selection (self)
        }
        
    }
    
}
