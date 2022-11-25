//
//  FinanceCustomCell.swift
//  Burbank
//
//  Created by Madhusudhan on 03/08/16.
//  Copyright © 2016 DMSS. All rights reserved.
//

import UIKit

class FinanceCustomCell: BurbankTVCell
{

    @IBOutlet weak var fieldsView : UIView!
    @IBOutlet weak var headerTitleLabel : UILabel!
    @IBOutlet weak var approcedStaticPriceLabel : UILabel!
    @IBOutlet weak var contractStaticPriceLabel : UILabel!
    @IBOutlet weak var approcedVariationPriceLabel : UILabel!
    @IBOutlet weak var contractValuePriceLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setAppearanceFor(view: headerTitleLabel, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: boldFontWith(size: FONT_13))
        
        setAppearanceFor(view: approcedStaticPriceLabel, backgroundColor: COLOR_CLEAR, textColor: COLOR_WHITE, textFont: boldFontWith(size: FONT_13))
        setAppearanceFor(view: contractStaticPriceLabel, backgroundColor: COLOR_CLEAR, textColor: COLOR_WHITE, textFont: boldFontWith(size: FONT_13))
        setAppearanceFor(view: approcedVariationPriceLabel, backgroundColor: COLOR_CLEAR, textColor: COLOR_WHITE, textFont: boldFontWith(size: FONT_13))
        setAppearanceFor(view: contractValuePriceLabel, backgroundColor: COLOR_CLEAR, textColor: COLOR_WHITE, textFont: boldFontWith(size: FONT_13))

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
