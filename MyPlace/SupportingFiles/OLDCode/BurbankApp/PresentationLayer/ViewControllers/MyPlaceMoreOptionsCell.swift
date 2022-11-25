//
//  MyPlaceMoreOptionsCell.swift
//  BurbankApp
//
//  Created by Mohan Kumar on 04/05/17.
//  Copyright © 2017 DMSS. All rights reserved.
//

import UIKit

class MyPlaceMoreOptionsCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subNameLabel: UILabel!
    @IBOutlet weak var menuIcon: UIImageView!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setAppearanceFor(view: nameLabel, backgroundColor: COLOR_CLEAR, textColor: COLOR_WHITE, textFont: FONT_LABEL_SUB_HEADING(size: FONT_16))
        setAppearanceFor(view: subNameLabel, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_LABEL_BODY(size: FONT_11))

//        icon.superview?.layer.cornerRadius = icon.superview!.frame.size.height/2

        
//        setAppearanceFor(view: nameLabel, backgroundColor: COLOR_CLEAR, textColor: COLOR_WHITE, textFont: FONT_LABEL_SUB_HEADING(size: FONT_16))
//        setAppearanceFor(view: subNameLabel, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_LABEL_BODY(size: FONT_12))

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
