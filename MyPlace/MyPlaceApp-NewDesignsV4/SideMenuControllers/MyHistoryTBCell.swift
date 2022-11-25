//
//  MyHistoryTBCell.swift
//  BurbankApp
//
//  Created by Naresh Banavath on 14/04/22.
//  Copyright © 2022 DMSS. All rights reserved.
//

import UIKit

class MyHistoryTBCell: UITableViewCell {

    @IBOutlet weak var subjectLb: UILabel!
    
    @IBOutlet weak var authorNameLb: UILabel!
    
    @IBOutlet weak var bodyLb: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
