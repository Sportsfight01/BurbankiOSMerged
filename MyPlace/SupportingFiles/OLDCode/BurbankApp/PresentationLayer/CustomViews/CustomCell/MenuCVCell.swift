//
//  MenuCVCell.swift
//  Burbank
//
//  Created by dmss on 20/09/16.
//  Copyright © 2016 DMSS. All rights reserved.
//

import UIKit

class MenuCVCell: BurbankAppCVCell
{
    
    @IBOutlet weak var menuIconImageView: UIImageView!
    @IBOutlet weak var menuNameLabel: UILabel!
    @IBOutlet weak var horizontalLineImageView: UIImageView!
    @IBOutlet weak var verticalLineImageView: UIImageView!
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var menuIconCenterXConstraint: NSLayoutConstraint!

    
    @IBOutlet weak var newMenuIconCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuNameLabelCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuNameLabelTopConstraint: NSLayoutConstraint!
    
    override func draw(_ rect: CGRect)
    {
        super.draw(rect)
       
    }
    override func prepareForReuse()
    {
        super.prepareForReuse()
    }
}
