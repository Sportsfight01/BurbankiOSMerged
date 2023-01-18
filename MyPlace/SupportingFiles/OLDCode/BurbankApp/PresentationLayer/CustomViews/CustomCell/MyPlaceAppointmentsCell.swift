//
//  MyPlaceContactUSCell.swift
//  BurbankApp
//
//  Created by Mohan Kumar on 27/04/17.
//  Copyright © 2017 DMSS. All rights reserved.
//

import UIKit

class MyPlaceAppointmentsCell: UITableViewCell {
    @IBOutlet weak var appointmentType: UILabel!
    @IBOutlet weak var appointmentDate: UILabel!
    @IBOutlet weak var icon: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setAppearanceFor(view: appointmentType, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_LABEL_SUB_HEADING(size: FONT_15))
        setAppearanceFor(view: appointmentDate, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_BODY(size: FONT_13))

        icon.superview?.layer.cornerRadius = icon.superview!.frame.size.height/2
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
