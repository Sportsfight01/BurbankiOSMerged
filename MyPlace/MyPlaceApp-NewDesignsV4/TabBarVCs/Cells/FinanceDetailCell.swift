//
//  FinanceDetailCell.swift
//  BurbankApp
//
//  Created by naresh banavath on 19/12/21.
//  Copyright © 2021 DMSS. All rights reserved.
//

import UIKit

class FinanceDetailCell: UITableViewCell {
    
    
    @IBOutlet var bottomTitleLbs: [UILabel]!
    
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
    //Intitialization methods
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFonts()
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupFonts()
    }
    
    func setupFonts()
    {
        //titlesLbs
        (bottomTitleLbs + [financeDescriptionLb]).forEach({$0.font = FONT_LABEL_BODY(size: FONT_10)})
        //valuesLbs
        [approvedVariationsLb,adjustedContractValueLb,totalAmountClaimedLb, totalAmountReceivedLb,financeAmountLb].forEach({
            
            $0?.font = FONT_LABEL_SUB_HEADING(size: FONT_10)
        })
    }
    
    
}
