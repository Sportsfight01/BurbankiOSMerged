//
//  MyPlaceContactUSCell.swift
//  BurbankApp
//
//  Created by Mohan Kumar on 27/04/17.
//  Copyright © 2017 DMSS. All rights reserved.
//

import UIKit

class MyPlaceContactUSCell: UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageLabel: UILabel!
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setAppearanceFor(view: titleLabel, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_LABEL_SUB_HEADING(size: FONT_16))
        
        setAppearanceFor(view: authorLabel, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_BODY (size: FONT_13))
        setAppearanceFor(view: detailsLabel, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_BODY(size: FONT_13))

        
        icon.superview?.layer.cornerRadius = (icon.superview?.frame.size.height ?? 0)/2
        icon.superview?.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
