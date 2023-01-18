//
//  ProgressCutomCell.swift
//  Burbank
//
//  Created by Madhusudhan on 02/08/16.
//  Copyright © 2016 DMSS. All rights reserved.
//

import UIKit
import MBCircularProgressBar

class ProgressCutomCell: BurbankTVCell {

    @IBOutlet weak var titleLabel : UILabel!
    
    @IBOutlet weak var dateLabel : UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusImageView : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setAppearanceFor(view: titleLabel, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_SUB_HEADING (size: FONT_12))

        setAppearanceFor(view: dateLabel, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_BODY(size: FONT_10))
        setAppearanceFor(view: statusLabel, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_BODY(size: FONT_8))

        
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)

    }

    var top = false
    var bottom = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 0
        layer.mask = nil
        layer.masksToBounds = false
        
        if top && bottom {
            layer.cornerRadius = 10
            layer.masksToBounds = true
            return
        }
        
        if self.top || self.bottom {
            let shape = CAShapeLayer()
            let rect = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.size.height)
            let corners: UIRectCorner = self.top ? [.topLeft, .topRight] : [.bottomRight, .bottomLeft]
            
            shape.path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: 10, height: 10)).cgPath
            layer.mask = shape
            layer.masksToBounds = true
        }
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

class DetailProgressValueCell: BurbankTVCell
{
    @IBOutlet weak var progressView : MBCircularProgressBarView!
    @IBOutlet weak var completedLabel : UILabel!
    @IBOutlet weak var progressStageLabel : UILabel!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        selectionStyle = .none
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setAppearanceFor(view: completedLabel, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_LABEL_HEADING(size: FONT_16))
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
