//
//  HomeCareIssueStatusTVC.swift
//  BurbankApp
//
//  Created by Naveen Kourampalli on 26/06/23.
//  Copyright © 2023 Sreekanth tadi. All rights reserved.
//

import UIKit

class HomeCareIssueStatusTVC: UITableViewCell {

    @IBOutlet weak var statusCOLORLBL: UILabel!
    @IBOutlet weak var statusLBL: UILabel!
    @IBOutlet weak var statusdetailsLBL: UILabel!
    @IBOutlet weak var issueLBL: UILabel!
    @IBOutlet weak var issueTypeimage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
