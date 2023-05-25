//
//  FinanceCVCell.swift
//  BurbankApp
//
//  Created by naresh banavath on 08/12/21.
//  Copyright © 2021 DMSS. All rights reserved.
//

import UIKit

class FinanceCVCell: UICollectionViewCell {
    
    
    
    var shareBTNPressed : (() -> ()) = {}
    
    
    @IBOutlet weak var totalReceivedTitleLb: UILabel!
    @IBOutlet weak var ReceiptsToDateHeaderLb: UILabel!
    @IBOutlet weak var totalClaimedTitleLb: UILabel!
    @IBOutlet weak var claimsToDateHeaderLb: UILabel!
    @IBOutlet weak var adjustedContractValueTitleLb: UILabel!
    @IBOutlet weak var approvedVariationTitleLb: UILabel!
    @IBOutlet weak var variationToDateHeaderLb: UILabel!
    @IBOutlet weak var tapForMoreInfoLb: UILabel!
    @IBOutlet weak var overViewLb: UILabel!
    
    @IBOutlet weak var shareBTN: UIButton!
    @IBOutlet weak var baseView: UIView!
    
    //MARK:- Variations To Date
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
    func setupFonts()
    {
        //titles
        [totalClaimedTitleLb,totalReceivedTitleLb,approvedVariationTitleLb,approvedVariationTitleLb,adjustedContractValueTitleLb].forEach({
            $0?.font = FONT_LABEL_BODY(size: FONT_10)
        })
        //headers
        [variationToDateHeaderLb, claimsToDateHeaderLb, ReceiptsToDateHeaderLb].forEach({
            $0?.font = FONT_LABEL_SUB_HEADING(size: FONT_14)
        })
        //values labes
        [approvedVariationLb,adjustedContractValueLb,totalClaimedLb,totalReceivedLb].forEach({
            $0?.font = FONT_LABEL_SUB_HEADING(size: FONT_10)
        })
        
        //top labels
        overViewLb.font = FONT_LABEL_BODY(size: FONT_25)
        tapForMoreInfoLb.font = FONT_LABEL_BODY(size: FONT_10)
        
    }
}
