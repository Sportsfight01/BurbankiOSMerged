//
//  MyPlaceJobListTVCell.swift
//  BurbankApp
//
//  Created by dmss on 09/06/17.
//  Copyright © 2017 DMSS. All rights reserved.
//

import UIKit

class MyPlaceJobListTVCell: UITableViewCell {

    @IBOutlet weak var jobNumberTextFiled: UITextField!
    @IBOutlet weak var selectedImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setAppearanceFor(view: self.jobNumberTextFiled, backgroundColor: .clear, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_BODY(size: FONT_14))

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
