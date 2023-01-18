//
//  SeperateLivingAreaVC.swift
//  BurbankApp
//
//  Created by Naveen Kourampalli on 09/11/22.
//  Copyright © 2022 Sreekanth tadi. All rights reserved.
//

class SeperateLivingAreaVC: HomeDesignModalHeaderVC {
    
    //    @IBOutlet weak var contentView: UIView!
    
    
    @IBOutlet weak var separateLiving_lbl: UILabel!
    @IBOutlet weak var separateLiving_btnMust: UIButton!
    @IBOutlet weak var separateLiving_btnDont: UIButton!
    @IBOutlet weak var separateLiving_btnDont_want_this: UIButton!
    
    @IBOutlet weak var stackHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        separateLivingViewSetUp ()
        
        selectionAlertMessage = "Please select one option"

    }
    
    
    func separateLivingViewSetUp () {
        
        let str = "WOULD YOU NEED A SEPARATE LIVING AREA?"
        separateLiving_lbl.text = str
        
        setAppearanceFor(view: separateLiving_lbl, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_BODY (size: FONT_19))
        
        
        setAppearanceFor(view: separateLiving_btnMust, backgroundColor: APPCOLORS_3.HeaderFooter_white_BG, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        setAppearanceFor(view: separateLiving_btnDont, backgroundColor: APPCOLORS_3.HeaderFooter_white_BG, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        setAppearanceFor(view: separateLiving_btnDont_want_this, backgroundColor: APPCOLORS_3.HeaderFooter_white_BG, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        
        
//        setBorder(view: separateLiving_btnMust, color: APPCOLORS_3.Orange_BG, width: 1.0)
//        setBorder(view: separateLiving_btnDont, color: APPCOLORS_3.Orange_BG, width: 1.0)
//        setBorder(view: separateLiving_btnDont_want_this, color: APPCOLORS_3.Orange_BG, width: 1.0)
        
        
        separateLiving_btnMust.layer.cornerRadius = radius_5
        separateLiving_btnDont.layer.cornerRadius = radius_5
        separateLiving_btnDont_want_this.layer.cornerRadius = radius_5
        
        if isDo_not_want_this_ENABLED{
            separateLiving_btnDont_want_this.isHidden = false
            stackHeight = stackHeight.changeMultiplier(stackHeight, multiplier: 0.45)

        }else{
            separateLiving_btnDont_want_this.isHidden = true
            stackHeight = stackHeight.changeMultiplier(stackHeight, multiplier: 0.25)

        }
        
    }
    
    
    //MARK: - Fill Selections
    
    func fillSelections () {
        
        separateLivingViewSetUp ()
        
        if homeDesignFeature?.selectedAnswer == DesignAnswer.must.rawValue {
            
            setAppearanceFor(view: separateLiving_btnMust, backgroundColor: APPCOLORS_3.EnabledOrange_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        }
        else if homeDesignFeature?.selectedAnswer == DesignAnswer.donotwantthis.rawValue  {
            
            setAppearanceFor(view: separateLiving_btnDont_want_this, backgroundColor: APPCOLORS_3.EnabledOrange_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        }else {
            
            setAppearanceFor(view: separateLiving_btnDont, backgroundColor: APPCOLORS_3.EnabledOrange_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_14))
        }
        
    }
    
    
    
    //MARK: - View Updates
    
    override func reloadView() {
        super.reloadView()
        
    }
    
    //MARK: - Clear
    
    override func clearSelections () {
        super.clearSelections()
        
        separateLivingViewSetUp ()
    }
    
    
    //MARK: - Actions
    
    @IBAction func handleSeparateKidsButtonsAction (_ sender: UIButton) {
        
        if sender == separateLiving_btnMust {
            homeDesignFeature?.selectedAnswer = DesignAnswer.must.rawValue
            homeDesignFeature?.displayString = "Separate Living Area"
        }
        else if sender == separateLiving_btnDont_want_this {
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
