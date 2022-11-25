//
//  BurbankTVCell.swift
//  Burbank
//
//  Created by dmss on 28/09/16.
//  Copyright © 2016 DMSS. All rights reserved.
//

import UIKit

class BurbankTVCell: UITableViewCell {

    var isFirstTime: Bool = false
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func draw(_ rect: CGRect)
    {
        if isFirstTime == false
        {
            isFirstTime = true
            
            /**
             To set font size of every Text in view with compatible for each device
             */
            CodeManager.sharedInstance.setLabelsFontInView(contentView)
        }
        
    }
    
    

}
