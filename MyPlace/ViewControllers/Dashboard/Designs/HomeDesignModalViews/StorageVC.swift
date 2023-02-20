//
//  StorageVC.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 15/07/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit

class StorageVC: HomeDesignModalHeaderVC {
    
    //    @IBOutlet weak var contentView: UIView!
    
    
    @IBOutlet weak var storage_lBStorage: UILabel!
    @IBOutlet weak var storage_btnMust: UIButton!
    @IBOutlet weak var storage_btnDont: UIButton!
    @IBOutlet weak var storage_btnDont_want_this: UIButton!
    
    @IBOutlet weak var stackHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        storageViewSetUp ()
        
        
        selectionAlertMessage = "Please select one option"
        
    }
    
    
    
    
    func storageViewSetUp () {
        
        let str = "IS LOTS OF STORAGE IMPORTANT? (MORE THAN 1 PER BEDROOM)"
        storage_lBStorage.text = str
        
        setAppearanceFor(view: storage_lBStorage, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_BODY (size: FONT_19))
        
        
        setAppearanceFor(view: storage_btnMust, backgroundColor: APPCOLORS_3.HeaderFooter_white_BG, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        setAppearanceFor(view: storage_btnDont_want_this, backgroundColor: APPCOLORS_3.HeaderFooter_white_BG, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        
        setAppearanceFor(view: storage_btnDont, backgroundColor: APPCOLORS_3.HeaderFooter_white_BG, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        
//
//        setBorder(view: storage_btnMust, color: APPCOLORS_3.Orange_BG, width: 1.0)
//        setBorder(view: storage_btnDont, color: APPCOLORS_3.Orange_BG, width: 1.0)
//        setBorder(view: storage_btnDont_want_this, color: APPCOLORS_3.Orange_BG, width: 1.0)
        
        
        
        storage_btnMust.layer.cornerRadius = radius_5
        storage_btnDont.layer.cornerRadius = radius_5
        storage_btnDont_want_this.layer.cornerRadius = radius_5
        
        
        if isDo_not_want_this_ENABLED{
            storage_btnDont_want_this.isHidden = false
            stackHeight = stackHeight.changeMultiplier(stackHeight, multiplier: 0.45)

        }else{
            storage_btnDont_want_this.isHidden = true
            stackHeight = stackHeight.changeMultiplier(stackHeight, multiplier: 0.25)

        }
        
    }
    
    
    
    //MARK: - Fill Selections
    
    func fillSelections () {
        
        storageViewSetUp ()
        
        if homeDesignFeature?.selectedAnswer == DesignAnswer.must.rawValue {
            
            setAppearanceFor(view: storage_btnMust, backgroundColor: APPCOLORS_3.Orange_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        }else if homeDesignFeature?.selectedAnswer == DesignAnswer.donotwantthis.rawValue {
            
            setAppearanceFor(view: storage_btnDont_want_this, backgroundColor: APPCOLORS_3.Orange_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        } else {
            
            setAppearanceFor(view: storage_btnDont, backgroundColor: APPCOLORS_3.Orange_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        }
        
    }
    
    //MARK: - View Updates
    
    override func reloadView() {
        super.reloadView()
        
    }
    
    //MARK: - Clear
    
    override func clearSelections () {
        super.clearSelections()
        
        storageViewSetUp ()
    }
    
    
    //MARK: - Actions
    
    @IBAction func handleStorageButtonsAction (_ sender: UIButton) {
        
        if sender == storage_btnMust {
            homeDesignFeature?.selectedAnswer = DesignAnswer.must.rawValue
            homeDesignFeature?.displayString = "Storage (more than 1 per room)"
        }else if sender == storage_btnDont_want_this {
            homeDesignFeature?.selectedAnswer = DesignAnswer.donotwantthis.rawValue
            homeDesignFeature?.displayString = ""
        }
        else {
            homeDesignFeature?.selectedAnswer = DesignAnswer.dontmind.rawValue
//            homeDesignFeature?.displayString = "NO STORAGE"
            homeDesignFeature?.displayString = ""
        }
        
        fillSelections()
        
        if let selection = selectionUpdates {
            selection (self)
        }
        
    }
    
}
