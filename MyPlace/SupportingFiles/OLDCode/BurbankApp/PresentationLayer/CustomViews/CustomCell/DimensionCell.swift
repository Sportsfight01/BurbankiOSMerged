//
//  DimensionCell.swift
//  BurbankApp
//
//  Created by Madhusudhan on 17/01/17.
//  Copyright © 2017 DMSS. All rights reserved.
//

import UIKit

class DimensionCell: UITableViewCell {

    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var sqmLabel : UILabel!
    @IBOutlet weak var sqLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
