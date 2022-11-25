//
//  SupportTVC.swift
//  BurbankApp
//
//  Created by Lifecykul on 15/12/21.
//  Copyright © 2021 DMSS. All rights reserved.
//

import UIKit

class SupportTVC: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var titleLBL: UILabel!
    @IBOutlet weak var subjectLBL: UILabel!
    @IBOutlet weak var seeMoreBTN: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
