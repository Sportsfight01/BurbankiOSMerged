//
//  FInanceViewController.swift
//  Burbank
//
//  Created by Madhusudhan on 03/08/16.
//  Copyright © 2016 DMSS. All rights reserved.
//

import UIKit

class FInanceViewController: BurbankAppVC/*MyPlaceWithTabBarVC*/, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var titleLabel : UILabel!

    @IBOutlet weak var financeTableView : UITableView!
    
    @IBOutlet weak var jobNumberLabelHeading: UILabel!
    @IBOutlet weak var jobNumberLabel : UILabel!

    @IBOutlet weak var priceLabelHeading: UILabel!
    @IBOutlet weak var priceLabel : UILabel!
    
    var dataDictionary = NSMutableDictionary()
    
    var financeDataDictionary : NSMutableDictionary!
    
    let claimsArray : NSArray = ["FinanceVariations", "FinanceClaims", "FinanceReceipts"]

    var totalPropertyAmountValue : Float!
    
    var appDelegate : AppDelegate!
    
    var formatter : NumberFormatter!
    
    var labelHeight : CGFloat = 20
    
    // MARK: View life cycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        _ = setAttributetitleFor(view: titleLabel, title: "Finance", rangeStrings: ["Finance"], colors: [APPCOLORS_3.Black_BG], fonts: [FONT_LABEL_HEADING(size: FONT_18)], alignmentCenter: false)

        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        // Do any additional setup after loading the view.
        
//        let variationDate = ["SV1/CW": "760.00", "V3/CW": "1721.00", "V2/LK": "1721.00", "V4/DF": "0.00", "V5/DF": "0.00", "V7/DF": "0.00", "V8/DF": "0.00", "V10/DF": "0.00", "V11/DF": "0.00"]
//
//        dataDictionary.setObject(variationDate, forKey: "Variation to date")
//        dataDictionary.setObject(claimsDate, forKey: "Claims to Date")
        
        formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_AU") // This is the default
        
//        #if DEDEBUG
//        print(financeDataDictionary)
//        #endif
        
        let user = appDelegate.currentUser
        
        jobNumberLabel.text = user?.userDetailsArray?[0].myPlaceDetailsArray[0].jobNumber

        dataDictionary = financeDataDictionary.mutableCopy() as! NSMutableDictionary
        
        if (dataDictionary.allKeys as NSArray).contains("Id") {
            dataDictionary.removeObject(forKey: "Id")
        }
        
        if (dataDictionary.allKeys as NSArray).contains("ContractPrice") {
            dataDictionary.removeObject(forKey: "ContractPrice")
            
            priceLabel.text = NSString(format: "%.2f", (financeDataDictionary.value(forKey: "ContractPrice") as? Float)!) as String
            
            priceLabel.text = formatter.string(from: NSNumber(value: Float(priceLabel.text!)! as Float))

        }
        
        print(dataDictionary)
        
        if IS_IPAD {
            labelHeight = 32
        }
        else if IS_IPHONE_6 || IS_IPHONE_6P
        {
            labelHeight = 26
        }
        
        
        setAppearanceFor(view: jobNumberLabelHeading, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_BODY(size: FONT_13))
        setAppearanceFor(view: jobNumberLabel, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Orange_BG, textFont: FONT_LABEL_SUB_HEADING(size: FONT_18))

        
        setAppearanceFor(view: priceLabelHeading, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_BODY(size: FONT_13))
        setAppearanceFor(view: priceLabel, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Orange_BG, textFont: FONT_LABEL_SUB_HEADING(size: FONT_18))
        
    }
    
    
    // MARK: - Button Actions
    @IBAction func backButtonTapped(sender: AnyObject) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: TableView DataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataDictionary.allKeys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // To display the data in the cell , Name, Designation, MobileNumber, Email Id
        
        let customCell = tableView.dequeueReusableCell(withIdentifier: "FinanceCustomCellIdentifier", for: indexPath) as! FinanceCustomCell
        
        let tempArray = dataDictionary.value(forKey: (claimsArray.object(at: indexPath.row) as? String)!) as! NSArray

        customCell.selectionStyle = .none
        
        customCell.fieldsView.layoutIfNeeded()

        var y_Gap : CGFloat = 40+5
        
        var totalAmountValue : Float = 0
        

        for viewww in customCell.fieldsView.subviews {
            
            if viewww.tag == 11 || viewww.tag == 12 || viewww.tag == 13 {
                
                viewww.removeFromSuperview()
            }
        }

        
        
//        if customCell.fieldsView.tag != 10 {
                        
            if tempArray.count != 0 {
                for i in 0...tempArray.count-1 {
                    
                    let leftHeadingLabel = UILabel(frame: CGRect(x: 20, y: y_Gap, width: 160, height: labelHeight))
                    leftHeadingLabel.text = (tempArray.object(at: i) as! NSDictionary).value(forKey: "Description") as? String
                    leftHeadingLabel.font = ProximaNovaRegular(size: 12.0)
                    leftHeadingLabel.tag = 11
                    leftHeadingLabel.textColor = UIColor.black
                    customCell.fieldsView .addSubview(leftHeadingLabel)
                    
                    let priceValueLabel = UILabel(frame: CGRect(x: customCell.fieldsView.frame.size.width-120, y: y_Gap, width: 100, height: labelHeight))
                    
                    priceValueLabel.font = ProximaNovaRegular(size: 12.0)
                    priceValueLabel.textAlignment = .right
                    priceValueLabel.backgroundColor = UIColor.clear
                    priceValueLabel.tag = 12
                    priceValueLabel.textColor = UIColor.black
                    customCell.fieldsView .addSubview(priceValueLabel)
                    
                    let lineLabel = UILabel(frame: CGRect(x: 20, y: y_Gap+labelHeight, width: customCell.fieldsView.frame.size.width-40, height: 0.5))
                    lineLabel.backgroundColor = UIColor.black
                    lineLabel.tag = 13
                    customCell.fieldsView .addSubview(lineLabel)
                    
                    if let amount = (tempArray.object(at: i) as! NSDictionary).value(forKey: "Amount") as? Float
                    {
                        #if DEDEBUG
                        print("---")
                        print(amount)
                        #endif
                        
                        priceValueLabel.text = NSString(format: "%.2f",amount) as String
                                                
                        if Float(priceValueLabel.text!)! != 0 {
                            totalAmountValue = totalAmountValue + Float(priceValueLabel.text!)!
                            priceValueLabel.text = NSString(format: "%@", priceValueLabel.text!) as String
                        }
                        priceValueLabel.text = formatter.string(from: NSNumber(value: Float(priceValueLabel.text!)! as Float))
                    }
                    else if let amount = (tempArray.object(at: i) as! NSDictionary).value(forKey: "Amount") as? NSNumber {
                        
                        #if DEDEBUG
                        print("++++")
                        print(amount)
                        #endif
                        
                        priceValueLabel.text = NSString(format: "%.2f",amount.doubleValue) as String
                        
                        if Float(priceValueLabel.text!)! != 0 {
                            totalAmountValue = totalAmountValue + Float(priceValueLabel.text!)!
                            priceValueLabel.text = NSString(format: "%@", priceValueLabel.text!) as String
                        }
                        priceValueLabel.text = formatter.string(from: NSNumber(value: Float(priceValueLabel.text!)! as Float))
                    }
                    y_Gap = y_Gap+labelHeight+1
                }
            }
//        }
//        else {
//
//            var removeDoller = customCell.approcedVariationPriceLabel.text?.replacingOccurrences(of: "$", with: "")
//
//            removeDoller = removeDoller?.replacingOccurrences(of: ",", with: "")
//
//            totalAmountValue = Float(removeDoller!)!
//
//        }
        
//        customCell.fieldsView.tag = 10
        
        customCell.contractValuePriceLabel.text = "0.00"
        customCell.approcedVariationPriceLabel.text = "0.00"

        if indexPath.row == 0 {
            
            customCell.contractValuePriceLabel.text = NSString(format: "%.2f", totalAmountValue+(financeDataDictionary.value(forKey: "ContractPrice") as? Float)!) as String
            
            
            customCell.approcedStaticPriceLabel.text = "Add/Minus Approved Variation"
            customCell.contractStaticPriceLabel.text = "Adjusted Contact Value"

        }
        
        if indexPath.row == 1 {
            
            customCell.headerTitleLabel.text = "Claims to Date"
            
            customCell.approcedStaticPriceLabel.text = "Total Amount Claimed"
            
            customCell.contractStaticPriceLabel.isHidden = true
            customCell.contractValuePriceLabel.isHidden = true
            
            totalPropertyAmountValue = totalAmountValue
        }
        
        if indexPath.row == 2 {
            
            customCell.headerTitleLabel.text = "Receipts to Date"
            
            customCell.approcedStaticPriceLabel.text = "Total Amount Received"
            customCell.contractStaticPriceLabel.text = "Balance Due"
            
            customCell.contractValuePriceLabel.text = NSString(format: "%.2f", totalPropertyAmountValue-totalAmountValue) as String

        }
        
        if totalAmountValue != 0 // && Float(customCell.approcedVariationPriceLabel.text) != 0
        {
        }
        
        customCell.approcedVariationPriceLabel.text = NSString(format: "%.2f", totalAmountValue) as String
        
        customCell.contractValuePriceLabel.text = formatter.string(from: NSNumber(value: Float(customCell.contractValuePriceLabel.text!)! as Float))
        
        customCell.approcedVariationPriceLabel.text = formatter.string(from: NSNumber(value: Float(customCell.approcedVariationPriceLabel.text!)! as Float))
        
        
        return customCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
//        print(dataDictionary)
//        
//        print(dataDictionary.value(forKey: claimsArray.object(at: indexPath.row) as! String))
        
        let tempArray = dataDictionary.value(forKey: (claimsArray.object(at: indexPath.row) as? String)!) as! NSArray
        
        return 115+(CGFloat(tempArray.count)*labelHeight+1)
    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
