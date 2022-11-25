//
//  ContactUsTVC.swift
//  BurbankApp
//
//  Created by Naveen Kourampalli on 17/12/21.
//  Copyright © 2021 DMSS. All rights reserved.
//

import UIKit

class ContactUsTVC: UITableViewCell {

    @IBOutlet weak var noteDateLb: UILabel!
    @IBOutlet weak var bodyLb: UILabel!
    @IBOutlet weak var subjectLb: UILabel!
    @IBOutlet weak var authorNameLb: UILabel!
    
    @IBOutlet weak var circlelb: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
