//
//  LandVC.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 15/07/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit

class LandVC: HomeDesignModalHeaderVC {
    
    
    @IBOutlet weak var land_lBAnswer: UILabel!
    @IBOutlet weak var land_lBLand: UILabel!
    
    @IBOutlet weak var land_iconYes: UIImageView!
    @IBOutlet weak var land_lBYes: UILabel!
    @IBOutlet weak var land_btnYes: UIButton!
    
    @IBOutlet weak var land_iconNo: UIImageView!
    @IBOutlet weak var land_lBNo: UILabel!
    @IBOutlet weak var land_btnNo: UIButton!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        landViewSetUp ()
        
        selectionAlertMessage = "Please select one option"

    }
    
    
    
    func landViewSetUp () {
        
        setAppearanceFor(view: land_lBAnswer, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_BODY (size: FONT_18))
        setAppearanceFor(view: land_lBLand, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_BODY (size: FONT_19))
        
        setAppearanceFor(view: land_lBYes, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Orange_BG, textFont: FONT_LABEL_SUB_HEADING(size: FONT_11))
        setAppearanceFor(view: land_lBNo, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Orange_BG, textFont: FONT_LABEL_SUB_HEADING(size: FONT_11))
        
        land_lBYes.superview?.layer.cornerRadius = radius_5
        land_lBNo.superview?.layer.cornerRadius = radius_5
        
        

    }
    
}
