//
//  FinanceCVCell2.swift
//  BurbankApp
//
//  Created by Naresh Banavath on 09/02/22.
//  Copyright © 2022 DMSS. All rights reserved.
//

import Foundation

import UIKit

class FinanceCVCell2: UICollectionViewCell {
  
//MARK:- Variations To Date
  
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var approvedVariationLb: UILabel!

    @IBOutlet weak var adjustedContractValueLb: UILabel!
    
  //MARK:- Claims to Date
    @IBOutlet weak var totalClaimedLb: UILabel!
    
  
  //MARK:- Receipts to Date

    @IBOutlet weak var totalReceivedLb: UILabel!
    
    @IBOutlet weak var loadMoreBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var titleLb: UILabel!
    
    var tableDataSource : [Finance]?
    
    
    override func prepareForReuse() {
        tableView.reloadData()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 10
        contentView.layer.shadowOffset = CGSize(width: -5, height: 5)
        contentView.layer.shadowOpacity = 0.5
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowRadius = 10
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
    
 
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if tableView.contentSize.height > 12.0
        {
            tableHeightConstraint.constant = tableView.contentSize.height
        }
        else{
            tableHeightConstraint.constant = 100.0
        }
       
    }
 
    
    
    func setupFinanceDetails(financeDetails : FinanceDetailsStruct? , rowNo : Int)
    {
        if financeDetails == nil
        {
            loadMoreBtn.isHidden = true
        }
        else {
            loadMoreBtn.isHidden = false
        }
        let sectionTitles : [String] = ["Variations to Date", "Claims to Date", "Receipts to Date"]
        tableView.allowsSelection = false
        switch rowNo{
        case 1: //Variations
            titleLb.text = sectionTitles[0]
            approvedVariationLb.superview?.isHidden = false
            adjustedContractValueLb.superview?.isHidden = false
            totalClaimedLb.superview?.isHidden = true
            totalReceivedLb.superview?.isHidden = true
            tableDataSource = financeDetails?.financeVariations
            tableView.reloadData()
            
        case 2: //Claims
            titleLb.text = sectionTitles[1]
            approvedVariationLb.superview?.isHidden = true
            adjustedContractValueLb.superview?.isHidden = true
            totalClaimedLb.superview?.isHidden = false
            totalReceivedLb.superview?.isHidden = true
            tableDataSource = financeDetails?.financeClaims
            tableView.reloadData()
        case 3: //Receipts
            titleLb.text = sectionTitles[2]
            approvedVariationLb.superview?.isHidden = true
            adjustedContractValueLb.superview?.isHidden = true
            totalClaimedLb.superview?.isHidden = true
            totalReceivedLb.superview?.isHidden = false
            tableDataSource = financeDetails?.financeReceipts
            tableView.reloadData()
        default:
            break
        }
     
    }
    
    
}
//TableView Delegate & DataSource

extension FinanceCVCell2 : UITableViewDelegate , UITableViewDataSource
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 25
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableDataSource?.count ?? 0 > 4 ? 4 : tableDataSource?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {return UITableViewCell()}
        cell.contentView.subviews.forEach { view in
            if view.isKind(of: UIStackView.self)
            {
                view.subviews.forEach { view2 in
                    if view2.tag == 100 // titleLb
                    {
                        let lb = view2 as! UILabel
                        lb.text = tableDataSource?[indexPath.row].financeDescription
                    }
                    else if view2.tag == 101 // detailLb
                    {
                        let lb = view2 as! UILabel
                        let dollarAmount = UIViewController().dollarCurrencyFormatter(value: tableDataSource?[indexPath.row].amount ?? 0.0)
                        lb.text = dollarAmount
                        //lb.text = "\(tableDataSource?[indexPath.row].amount ?? 0.0)"
                    }
                }
            }
        }

        return cell
    }
    
    
}
