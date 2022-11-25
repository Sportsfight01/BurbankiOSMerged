//
//  MyPlaceContractCell.swift
//  Burbank
//
//  Created by Mohan Kumar on 24/10/16.
//  Copyright © 2016 DMSS. All rights reserved.
//

import UIKit

class MyPlaceContractCell: BurbankTVCell {
    
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var valueLabel:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setAppearanceFor(view: nameLabel, backgroundColor: .clear, textColor: COLOR_BLACK, textFont: FONT_LABEL_BODY(size: FONT_12))
        setAppearanceFor(view: valueLabel, backgroundColor: .clear, textColor: COLOR_WHITE, textFont: FONT_LABEL_SUB_HEADING(size: FONT_14))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
