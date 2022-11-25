//
//  FinanceDetailVC.swift
//  BurbankApp
//
//  Created by naresh banavath on 19/12/21.
//  Copyright © 2021 DMSS. All rights reserved.
//

import UIKit

class FinanceDetailVC: UIViewController {
  
  //MARK:- Properties
    
    @IBOutlet weak var lb_lastUpdated: UILabel!
    {
        didSet
        {
            let currentDate = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let str = dateFormatter.string(from: currentDate)
            lb_lastUpdated.text = "Last Updated \(str)"
        }
    }
    @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var contractValueLb: UILabel!
  @IBOutlet weak var balanceDueLb: UILabel!
    
    @IBOutlet weak var shareBTN: UIButton!
    
    var sectionTitles : [String] = ["Variations to Date", "Claims to Date", "Receipts to Date"]
  var financeDetails : FinanceDetailsStruct?
  
  //MARK:- LifeCycle
  override func viewDidLoad() {
        super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
        // Do any additional setup after loading the view.
    let dummyViewHeight = CGFloat(40)
    self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: dummyViewHeight))
    self.tableView.contentInset = UIEdgeInsets(top: -dummyViewHeight, left: 0, bottom: 0, right: 0)
    setupData()
    }
  
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    @IBAction func didTappedOnShareBTN(_ sender: UIButton) {
        let takenIMG = screenshot()
        let takenPDF = createPDFDataFromImage(image: takenIMG)
//                let documento = NSData(contentsOfFile: takenPDF)
         let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [takenPDF], applicationActivities: nil)
         activityViewController.popoverPresentationController?.sourceView=self.view
         self.present(activityViewController, animated: true, completion: nil)
    }
    @IBAction func backBtnClicked(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  //MARK:- Helper Methods
  func setupData()
  {
    let contractValue = dollarCurrencyFormatter(value: Double(financeDetails!.contractPrice))
    self.contractValueLb.text = "\(contractValue!)"
  }
}

extension FinanceDetailVC : UITableViewDelegate, UITableViewDataSource
{
  func numberOfSections(in tableView: UITableView) -> Int {
    return sectionTitles.count
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0: //VariationToDate
      return (financeDetails?.financeVariations?.count ?? 0) + 1
    case 1: //ClaimsToDate
      return (financeDetails?.financeClaims?.count ?? 0) + 1
    case 2: //ReceiptsToDate
      return (financeDetails?.financeReceipts?.count ?? 0) + 1
    default:
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "FinanceDetailCell") as! FinanceDetailCell
    cell.staticLabelStackView.isHidden = true
    let noOfRows = tableView.numberOfRows(inSection: indexPath.section)
    
    if indexPath.row == noOfRows - 1 //Last Row
    {
      cell.FinanceDataStackView.isHidden = true
      cell.staticLabelStackView.isHidden = false
      //Variations
      let totalVariation = financeDetails?.financeVariations?.map({Double($0.amount)}).reduce(0, +)
        cell.approvedVariationsLb.text = dollarCurrencyFormatter(value: totalVariation ?? 0.0)
        let adjustedContractValue = Double(financeDetails?.contractPrice ?? 0) + (totalVariation ?? 0.0)
        cell.adjustedContractValueLb.text = dollarCurrencyFormatter(value: adjustedContractValue)
      //Claims
      let totClaims = financeDetails?.financeClaims?.map({Double($0.amount)}).reduce(0, +)
      cell.totalAmountClaimedLb.text = dollarCurrencyFormatter(value: totClaims ?? 0.0)
      
      //Receipts
      let totRcvd = financeDetails?.financeReceipts?.map({Double($0.amount)}).reduce(0, +)
      cell.totalAmountReceivedLb.text = dollarCurrencyFormatter(value: totRcvd ?? 0.0)
      switch indexPath.section {
      case 0: //Variation
        cell.totalAmountClaimedLb.superview?.isHidden = true
        cell.totalAmountReceivedLb.superview?.isHidden = true
        cell.approvedVariationsLb.superview?.isHidden = false
        cell.adjustedContractValueLb.superview?.isHidden = false
      case 1: //Claims
        cell.totalAmountClaimedLb.superview?.isHidden = false
        cell.totalAmountReceivedLb.superview?.isHidden = true
        cell.approvedVariationsLb.superview?.isHidden = true
        cell.adjustedContractValueLb.superview?.isHidden = true
      case 2: // Receipts
        cell.totalAmountClaimedLb.superview?.isHidden = true
        cell.totalAmountReceivedLb.superview?.isHidden = false
        cell.approvedVariationsLb.superview?.isHidden = true
        cell.adjustedContractValueLb.superview?.isHidden = true
      default:
        break
      }
    }
    else {
      cell.FinanceDataStackView.isHidden = false
      switch indexPath.section
      {
      case 0://variation
        cell.financeDescriptionLb.text = financeDetails?.financeVariations?[indexPath.row].financeDescription
        cell.financeAmountLb.text = dollarCurrencyFormatter(value: financeDetails?.financeVariations?[indexPath.row].amount ?? 0.0)
      case 1://Claims
        cell.financeDescriptionLb.text = financeDetails?.financeClaims?[indexPath.row].financeDescription
        cell.financeAmountLb.text = dollarCurrencyFormatter(value: financeDetails?.financeClaims?[indexPath.row].amount ?? 0.0)
      case 2://receipts
        cell.financeDescriptionLb.text = financeDetails?.financeReceipts?[indexPath.row].financeDescription
        cell.financeAmountLb.text = dollarCurrencyFormatter(value: financeDetails?.financeReceipts?[indexPath.row].amount ?? 0.0)
      default:
        break
      }
    }
    return cell
  }
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 40
  }
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = UIView()
    //Label
    let label = UILabel()
    label.text = sectionTitles[section]
    label.font = UIFont.systemFont(ofSize: 16.0 , weight: .semibold)
    label.textColor =  AppColors.appOrange
    view.addSubview(label)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    label.leadingAnchor.constraint(equalTo: view.leadingAnchor , constant: 0).isActive = true
    return view
  }
  
}
extension FinanceDetailVC{
    func screenshot() -> UIImage{
    var image = UIImage();
        UIGraphicsBeginImageContextWithOptions(self.tableView.contentSize, false, UIScreen.main.scale)

        // save initial values
        let savedContentOffset = self.tableView.contentOffset;
        let savedFrame = self.tableView.frame;
        let savedBackgroundColor = self.tableView.backgroundColor

        // reset offset to top left point
        self.tableView.contentOffset = CGPoint(x: 0, y: 0);
        // set frame to content size
        self.tableView.frame = CGRect(x: 0, y: 0, width: self.tableView.contentSize.width, height: self.tableView.contentSize.height);
        // remove background
        self.tableView.backgroundColor = UIColor.clear

        // make temp view with scroll view content size
        // a workaround for issue when image on ipad was drawn incorrectly
        let tempView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.contentSize.width, height: self.tableView.contentSize.height));

        // save superview
        let tempSuperView = self.tableView.superview
        // remove scrollView from old superview
        self.tableView.removeFromSuperview()
        // and add to tempView
        tempView.addSubview(self.tableView)

        // render view
        // drawViewHierarchyInRect not working correctly
        tempView.layer.render(in: UIGraphicsGetCurrentContext()!)
        // and get image
        image = UIGraphicsGetImageFromCurrentImageContext()!;

        // and return everything back
        tempView.subviews[0].removeFromSuperview()
        tempSuperView?.addSubview(self.tableView)

        // restore saved settings
        self.tableView.contentOffset = savedContentOffset;
        self.tableView.frame = savedFrame;
        self.tableView.backgroundColor = savedBackgroundColor

        UIGraphicsEndImageContext();

        return image
    }
}
