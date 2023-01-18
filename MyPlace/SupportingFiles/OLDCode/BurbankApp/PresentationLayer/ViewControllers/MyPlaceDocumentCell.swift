//
//  MyPlaceDocumentCell.swift
//  Burbank
//
//  Created by Mohan Kumar on 25/10/16.
//  Copyright © 2016 DMSS. All rights reserved.
//

import UIKit

class MyPlaceDocumentCell: BurbankTVCell {

    @IBOutlet weak var docImage:UIImageView!
    @IBOutlet weak var docNameLabel:UILabel!
    @IBOutlet weak var uploaded:UILabel!
    @IBOutlet weak var dateLabel:UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setAppearanceFor(view: docNameLabel, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_SUB_HEADING(size: FONT_13))
        
        setAppearanceFor(view: uploaded, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_SUB_HEADING(size: FONT_10))
        setAppearanceFor(view: dateLabel, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_SUB_HEADING(size: FONT_10))

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
