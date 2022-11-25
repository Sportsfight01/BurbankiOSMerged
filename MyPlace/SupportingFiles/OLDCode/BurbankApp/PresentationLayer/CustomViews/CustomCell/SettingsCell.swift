//
//  SettingsCell.swift
//  BurbankApp
//
//  Created by Mohan Kumar on 25/04/17.
//  Copyright © 2017 DMSS. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var nextButton : UIButton!
    
    @IBOutlet weak var arrow : UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
                
        nameLabel.textColor = UIColor.darkGray
        nameLabel.textAlignment = .left
        nextButton.isHidden = false
        
        // Initialization code
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
