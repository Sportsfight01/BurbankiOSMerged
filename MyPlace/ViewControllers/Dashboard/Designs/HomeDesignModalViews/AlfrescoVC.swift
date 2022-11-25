//
//  AlfrescoVC.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 15/07/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit

class AlfrescoVC: HomeDesignModalHeaderVC {
    
    //    @IBOutlet weak var contentView: UIView!
    
    
    @IBOutlet weak var alfresco_lBAlfresco: UILabel!
    @IBOutlet weak var alfresco_btnMust: UIButton!
    @IBOutlet weak var alfresco_btnDont: UIButton!
    @IBOutlet weak var alfresco_btnDont_want_this: UIButton!
    
    @IBOutlet weak var stackHeight: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        alfrescoViewSetUp ()
                
        selectionAlertMessage = "Please select one option"

    }
    
    
    func alfrescoViewSetUp () {
        
        let str = "DO YOU NEED AN\nALFRESCO IN YOUR DESIGN?"
        alfresco_lBAlfresco.text = str
        
        setAppearanceFor(view: alfresco_lBAlfresco, backgroundColor: COLOR_CLEAR, textColor: COLOR_DARK_GRAY, textFont: FONT_LABEL_BODY (size: FONT_19))
        
        
        setAppearanceFor(view: alfresco_btnMust, backgroundColor: COLOR_WHITE, textColor: COLOR_ORANGE, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        setAppearanceFor(view: alfresco_btnDont, backgroundColor: COLOR_WHITE, textColor: COLOR_ORANGE, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        setAppearanceFor(view: alfresco_btnDont_want_this, backgroundColor: COLOR_WHITE, textColor: COLOR_ORANGE, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        
        
        setBorder(view: alfresco_btnMust, color: COLOR_ORANGE, width: 1.0)
        setBorder(view: alfresco_btnDont, color: COLOR_ORANGE, width: 1.0)
        setBorder(view: alfresco_btnDont_want_this, color: COLOR_ORANGE, width: 1.0)
        
        
        alfresco_btnMust.layer.cornerRadius = radius_5
        alfresco_btnDont.layer.cornerRadius = radius_5
        alfresco_btnDont_want_this.layer.cornerRadius = radius_5
        
        if isDo_not_want_this_ENABLED{
            alfresco_btnDont_want_this.isHidden = false
            stackHeight = stackHeight.changeMultiplier(stackHeight, multiplier: 0.45)

        }else{
            alfresco_btnDont_want_this.isHidden = true
            stackHeight = stackHeight.changeMultiplier(stackHeight, multiplier: 0.25)

        }
        
    }
    
    
    
    //MARK: - Fill Selections
    
    func fillSelections () {
        
        alfrescoViewSetUp ()
        
        if homeDesignFeature?.selectedAnswer == DesignAnswer.must.rawValue {
            
            setAppearanceFor(view: alfresco_btnMust, backgroundColor: COLOR_ORANGE, textColor: COLOR_WHITE, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        }else if homeDesignFeature?.selectedAnswer == DesignAnswer.donotwantthis.rawValue {
            setAppearanceFor(view: alfresco_btnDont_want_this, backgroundColor: COLOR_ORANGE, textColor: COLOR_WHITE, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        } else {
            
            setAppearanceFor(view: alfresco_btnDont, backgroundColor: COLOR_ORANGE, textColor: COLOR_WHITE, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        }
        
    }
    
    
    //MARK: - View Updates
    
    override func reloadView() {
        super.reloadView()
        
    }
    
    //MARK: - Clear
    
    override func clearSelections () {
        super.clearSelections()
        
        alfrescoViewSetUp ()
    }
    
    
    
    //MARK: - Actions
    
    @IBAction func handleAlfrescoButtonsAction (_ sender: UIButton) {
        
        if sender == alfresco_btnMust {
            homeDesignFeature?.selectedAnswer = DesignAnswer.must.rawValue
            homeDesignFeature?.displayString = "Alfresco"
        }else if sender == alfresco_btnDont_want_this {
            homeDesignFeature?.selectedAnswer = DesignAnswer.donotwantthis.rawValue
//            homeDesignFeature?.displayString = "NO ALFRESCO"
            homeDesignFeature?.displayString = ""
        }else {
            homeDesignFeature?.selectedAnswer = DesignAnswer.dontmind.rawValue
//            homeDesignFeature?.displayString = "NO ALFRESCO"
            homeDesignFeature?.displayString = ""
        }
        
        fillSelections()        
        
        if let selection = selectionUpdates {
            selection (self)
        }
        
    }
    
}
