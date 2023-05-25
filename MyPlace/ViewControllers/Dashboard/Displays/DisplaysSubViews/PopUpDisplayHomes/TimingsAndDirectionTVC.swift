//
//  TimingsAndDirectionTVC.swift
//  BurbankApp
//
//  Created by Naveen Kourampalli on 26/10/22.
//  Copyright © 2022 Sreekanth tadi. All rights reserved.
//

import UIKit

class TimingsAndDirectionTVC: UITableViewCell {

    
    @IBOutlet weak var downArrowImage: UIImageView!
    @IBOutlet weak var cardViewTwo: UIView!
    @IBOutlet weak var tradingHoursLBL: UILabel!
    
    @IBOutlet weak var getDirectionBTN: UIButton!
    @IBOutlet weak var bookAnAppointmentBTN: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bookAnAppointmentBTN.titleLabel?.font = FONT_BUTTON_HEADING(size: 12)
        getDirectionBTN.titleLabel?.font = FONT_BUTTON_HEADING(size: 12)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
