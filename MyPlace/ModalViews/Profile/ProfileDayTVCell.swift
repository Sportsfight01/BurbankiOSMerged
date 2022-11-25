//
//  ProfileDayTVCell.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 01/04/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit

class ProfileDayTVCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var lBCount: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var lBTitle: UILabel!
    @IBOutlet weak var btnArrow: UIButton!

    
    @IBOutlet weak var lBDayTitle: UILabel!
    @IBOutlet weak var btnViewJourney: UIButton!


    @IBOutlet weak var lBLine: UILabel!

    
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setAppearanceFor(view: lBCount, backgroundColor: COLOR_BLACK, textColor: COLOR_WHITE, textFont: FONT_LABEL_SUB_HEADING(size: FONT_8))
        setAppearanceFor(view: lBTitle, backgroundColor: COLOR_CLEAR, textColor: COLOR_WHITE, textFont: FONT_LABEL_SUB_HEADING (size: FONT_14))
        setAppearanceFor(view: lBLine, backgroundColor: COLOR_ORANGE_LIGHT, textColor: COLOR_WHITE, textFont: FONT_LABEL_BODY(size: FONT_10))

                
        setAppearanceFor(view: lBDayTitle, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_LABEL_BODY(size: FONT_14))
        setAppearanceFor(view: btnViewJourney, backgroundColor: COLOR_WHITE, textColor: COLOR_ORANGE, textFont: FONT_BUTTON_BODY(size: FONT_14))
        
        
        btnViewJourney.layer.cornerRadius = radius_5 //5.0
        
        lBCount.layer.cornerRadius = lBCount.frame.size.height/2

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
