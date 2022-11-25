//
//  FinanceDetailCell.swift
//  BurbankApp
//
//  Created by naresh banavath on 19/12/21.
//  Copyright © 2021 DMSS. All rights reserved.
//

import UIKit

class FinanceDetailCell: UITableViewCell {
  
  @IBOutlet weak var FinanceDataStackView: UIStackView!
  @IBOutlet weak var financeDescriptionLb: UILabel!
  @IBOutlet weak var financeAmountLb: UILabel!
  
  @IBOutlet weak var totalAmountReceivedLb: UILabel!
  @IBOutlet weak var totalAmountClaimedLb: UILabel!
  
  @IBOutlet weak var approvedVariationsLb: UILabel!
  @IBOutlet weak var adjustedContractValueLb: UILabel!
  @IBOutlet weak var staticLabelStackView: UIStackView!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
