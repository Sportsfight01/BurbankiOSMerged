//
//  MyPlaceStagesCell.swift
//  Burbank
//
//  Created by Mohan Kumar on 24/10/16.
//  Copyright © 2016 DMSS. All rights reserved.
//

import UIKit
import MBCircularProgressBar

class MyPlaceStagesCell: BurbankAppCVCell {
    
    @IBOutlet weak var stagesProgressView : MBCircularProgressBarView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var breakDown: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setAppearanceFor(view: nameLabel, backgroundColor: COLOR_CLEAR, textColor: COLOR_WHITE, textFont: FONT_LABEL_HEADING(size: FONT_13))
        
        
//        stagesProgressView.valueFontSize = 32
        stagesProgressView.valueFontName = FONT_LABEL_HEADING().fontName

//        stagesProgressView.unitFontSize = 31
        stagesProgressView.unitFontName = FONT_LABEL_HEADING().fontName
        
        
        setAppearanceFor(view: breakDown, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_LABEL_BODY(size: FONT_11))
        
    }
    
}

class MainProgressCell: UICollectionViewCell
{
    @IBOutlet weak var mainProgressView : MBCircularProgressBarView!
    @IBOutlet weak var newHome: UILabel!
    @IBOutlet weak var onItsWay: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setAppearanceFor(view: newHome, backgroundColor: COLOR_CLEAR, textColor: COLOR_WHITE, textFont: FONT_LABEL_HEADING(size: FONT_11))
        setAppearanceFor(view: onItsWay, backgroundColor: COLOR_CLEAR, textColor: COLOR_WHITE, textFont: FONT_LABEL_HEADING(size: FONT_11))
        
        
//        mainProgressView.valueFontSize = 55
        mainProgressView.valueFontName = FONT_LABEL_HEADING().fontName

//        mainProgressView.unitFontSize = 50
        mainProgressView.unitFontName = FONT_LABEL_HEADING().fontName
        
    }
    
    
}
