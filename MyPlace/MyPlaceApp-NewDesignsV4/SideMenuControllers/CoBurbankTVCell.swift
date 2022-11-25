//
//  CoBurbankTVCell.swift
//  BurbankApp
//
//  Created by Naresh Banavath on 12/04/22.
//  Copyright © 2022 DMSS. All rights reserved.
//

//class CoBurbankTVCell: UITableViewCell
//{
//
//    weak var nameLabel: UILabel!
////    @IBOutlet weak var contactDetailsLabel: UILabel!
//    @IBOutlet weak var statusButton: UIButton!
//    @IBOutlet weak var deleteButton: UIButton!
//
//    @IBOutlet weak var btnStatus: UIButton!
//
//    @IBOutlet weak var Stackheight: NSLayoutConstraint!
//
////    @IBOutlet weak var statusMessage: UILabel!
////    @IBOutlet weak var statusMessageLabelBottomConstraint: NSLayoutConstraint!
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//    }
//
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//
//    }
//
//}

import UIKit

class CoBurbankTVCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var btnStatus: UIButton!
    
    @IBOutlet weak var statusButton: UIButton!
    
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var Stackheight: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
