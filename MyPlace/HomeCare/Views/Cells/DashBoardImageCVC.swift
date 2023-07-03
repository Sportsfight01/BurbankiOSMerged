//
//  DashBoardImageCVC.swift
//  BurbankApp
//
//  Created by Naveen Kourampalli on 04/05/23.
//  Copyright © 2023 Sreekanth tadi. All rights reserved.
//

import UIKit

class DashBoardImageCVC: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var detailViewBTN: UIButton!
    @IBOutlet weak var detailViewDescriptionLBL: UILabel!
    @IBOutlet weak var detailViewTitleLBL: UILabel!
    @IBOutlet weak var detailsView: UIView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setAppearanceFor(view: detailViewDescriptionLBL, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_BODY(size: FONT_15))
        setAppearanceFor(view: detailViewTitleLBL, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Orange_BG, textFont: FONT_LABEL_BODY(size: FONT_30))
        setAppearanceFor(view: detailViewBTN, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Orange_BG, textFont: FONT_BUTTON_BODY(size: FONT_12))
        
    }

   
}
