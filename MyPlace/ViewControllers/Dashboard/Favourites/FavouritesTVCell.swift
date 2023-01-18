//
//  FavouritesTVCell.swift
//  BurbankApp
//
//  Created by Naveen Kourampalli on 30/11/22.
//  Copyright © 2022 Sreekanth tadi. All rights reserved.
//

import UIKit

class FavouritesTVCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var lBCount: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var lBTitle: UILabel!
    @IBOutlet weak var btnArrow: UIButton!
    @IBOutlet weak var lBLine: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setAppearanceFor(view: lBCount, backgroundColor: APPCOLORS_3.EnabledOrange_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_LABEL_HEADING(size: FONT_12))
        setAppearanceFor(view: lBTitle, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_SUB_HEADING (size: FONT_14))
        setAppearanceFor(view: lBLine, backgroundColor: APPCOLORS_3.Orange_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_LABEL_LIGHT(size: FONT_12))
        
        lBCount.layer.cornerRadius = lBCount.frame.size.height/2
        
        lBCount.isHidden = true
        
        lBCount.text = "0"
        btnArrow.setImage(UIImage(named: "Ico-DownArrow")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnArrow.tintColor = .lightGray
        btnArrow.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
