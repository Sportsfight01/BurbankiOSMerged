//
//  FinanceCVCell.swift
//  BurbankApp
//
//  Created by naresh banavath on 08/12/21.
//  Copyright © 2021 DMSS. All rights reserved.
//

import UIKit

class FinanceCVCell: UICollectionViewCell {
  
//MARK:- Variations To Date
  
    var shareBTNPressed : (() -> ()) = {}
    
    
    @IBOutlet weak var shareBTN: UIButton!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var approvedVariationLb: UILabel!
  @IBOutlet weak var adjustedContractValueLb: UILabel!
  
  //MARK:- Claims to Date
  
  @IBOutlet weak var totalClaimedLb: UILabel!
  
  //MARK:- Receipts to Date
  
  @IBOutlet weak var totalReceivedLb: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 10
        contentView.layer.shadowOffset = CGSize(width: -5, height: 5)
        contentView.layer.shadowOpacity = 0.5
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowRadius = 10
    }
    @IBAction func didTappedOnShare(_ sender: UIButton) {
        shareBTNPressed()
    }
    
}
