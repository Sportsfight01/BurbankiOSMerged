//
//  FinanceVC.swift
//  BurbankApp
//
//  Created by naresh banavath on 24/11/21.
//  Copyright © 2021 DMSS. All rights reserved.
//

import UIKit
import SideMenu
import SkeletonView

class FinanceVC: BaseProfileVC {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var financeDetails : FinanceDetailsStruct?

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addGradientLayer()
        collectionView.backgroundColor = .clear
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: collectionView.frame.width * 0.8, height: collectionView.frame.height)
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        setupTitles()
        checkUserLoginForFinance()

        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 20)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
//        self.navigationController?.navigationBar.isHidden = true
       // collectionView.reloadData()
    
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func setupTitles()
    {
        profileView.titleLb.text = "MyFinance"
        profileView.helpTextLb.text = "--"
    }
    //MARK: - Service Calls
    
    func checkUserLoginForFinance()
    {
        self.collectionView.isSkeletonable = true
        self.collectionView.showAnimatedGradientSkeleton()
        let jobAndAuth = APIManager.shared.getJobNumberAndAuthorization()
        guard let jobNumber = jobAndAuth.jobNumber else {debugPrint("Job Number is Null");return}
        let password = APIManager.shared.currentJobDetails?.password ?? ""
        let userName = APIManager.shared.currentJobDetails?.userName ?? ""
        let region = APIManager.shared.currentJobDetails?.region ?? ""
        let postDic =  ["Region": region, "JobNumber":jobNumber, "UserName":userName, "Password":password]
        //callMyPlaceLoginServie(myPlaceDetails)
        let url = URL(string: checkUserLogin())
        var urlRequest = URLRequest(url: url!)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.httpMethod = kPost
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: postDic, options:[])
        }
        catch {
#if DEDEBUG
            print("JSON serialization failed:  \(error)")
#endif
        }
       // appDelegate.showActivity()
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { [weak self](data, response, error) in
            DispatchQueue.main.async {
                self?.appDelegate.hideActivity()
            }
            debugPrint("URL:- \(String(describing: response?.url)) postData :- \(postDic)")
            if error != nil
            {
#if DEDEBUG
                print("fail to Logout")
#endif
                return
            }
            if let strData = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            {
                print(strData)
                guard strData == "true" || strData.contains("true") else {return}
                self?.getFinanceData()
                
                
            }
        }).resume()
    }
    func getFinanceData()
    {
        guard let jobNumber = APIManager.shared.currentJobDetails?.jobNumber else {print("jobNumber is Null"); return}
        NetworkRequest.makeRequest(type: FinanceDetailsStruct.self, urlRequest: Router.getFinanceDetails(jobNumber: jobNumber), showActivity: false) {[weak self] (result) in
            DispatchQueue.main.async {
                self?.collectionView.stopSkeletonAnimation()
                self?.view.hideSkeleton()
            }
            switch result
            {
            case .success(let data):
                //print(data)
                // let contractPrice =  String(format: "%.2f",data.contractPrice)
                self?.financeDetails = data
                self?.setupUI()
                
            case .failure(let err):
                print(err.localizedDescription)
                DispatchQueue.main.async {
                    self?.showAlert(message: "No Data Found")
                }
            }
        }
    }
    
    func setupUI()
    {
        
        let contractValue = dollarCurrencyFormatter(value: Double(financeDetails!.contractPrice))
        self.profileView.helpTextLb.text = "Contract Value : \(contractValue!)"
        self.profileView.secondHelpTextLb.isHidden = false
        self.profileView.secondHelpTextLb.text = "Balance Due : $0.00"
        collectionView.reloadData()
        
    }
    
}
extension FinanceVC : UICollectionViewDataSource , SkeletonCollectionViewDataSource
{
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        if indexPath.item == 0{
            return "FinanceCVCell"
        }
        return "FinanceCVCell2"
    }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 4
  }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let totalVariation = financeDetails?.financeVariations?.map({Double($0.amount)}).reduce(0, +)
        let totClaims = financeDetails?.financeClaims?.map({Double($0.amount)}).reduce(0, +)
        let totRcvd = financeDetails?.financeReceipts?.map({Double($0.amount)}).reduce(0, +)
        let adjustedContractValue = Double(financeDetails?.contractPrice ?? 0) + (totalVariation ?? 0.0)
        
        if indexPath.item == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FinanceCVCell", for: indexPath) as! FinanceCVCell
            //Variations
            cell.setupFonts()
            cell.approvedVariationLb.text = dollarCurrencyFormatter(value: totalVariation ?? 0.0)
            cell.adjustedContractValueLb.text = dollarCurrencyFormatter(value: adjustedContractValue)
            //Claims
            cell.totalClaimedLb.text = dollarCurrencyFormatter(value: totClaims ?? 0.0)
            //Receipts
            cell.totalReceivedLb.text = dollarCurrencyFormatter(value: totRcvd ?? 0.0)
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FinanceCVCell2", for: indexPath) as! FinanceCVCell2
            //  if let financeDet = financeDetails {
            cell.loadMoreBtn.tag = indexPath.row
            cell.loadMoreBtn.addTarget(self, action: #selector(loadMoreBtnTapped(_:)), for: .touchUpInside)
            cell.setupFinanceDetails(financeDetails: financeDetails, rowNo: indexPath.row)
            cell.approvedVariationLb.text = dollarCurrencyFormatter(value: totalVariation ?? 0.0)
            cell.adjustedContractValueLb.text = dollarCurrencyFormatter(value: adjustedContractValue)
            cell.totalReceivedLb.text = dollarCurrencyFormatter(value: totRcvd ?? 0.0)
            cell.totalClaimedLb.text = dollarCurrencyFormatter(value: totClaims ?? 0.0)
            cell.layoutIfNeeded()
            // }
            return cell
        }
    }
    
   
  
    @objc func loadMoreBtnTapped(_ sender : UIButton)
    {
        let vc = FinanceDetailVC.instace()
        if let financeDetails = self.financeDetails
        {
            vc.moveToSection = sender.tag - 1
            vc.financeDetails = financeDetails
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let vc = FinanceDetailVC.instace()
        if let financeDetails = self.financeDetails
        {
            vc.financeDetails = financeDetails
            if 0...2 ~= indexPath.row - 1 // pass only when in IndexBounds
            {
                vc.moveToSection = indexPath.row - 1
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
extension FinanceVC : UICollectionViewDelegateFlowLayout
{
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
  //  print("size of item :- \(CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height))")
    let width = collectionView.frame.size.width * 0.8
    return CGSize(width: width , height: collectionView.frame.size.height)
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
}
// MARK: - FinanceDetailsStruct
struct FinanceDetailsStruct: Codable {
    let contractPrice: Int
    let financeVariations: [Finance]?
    let financeClaims, financeReceipts: [Finance]?
    let id: Int

    enum CodingKeys: String, CodingKey {
        case contractPrice = "ContractPrice"
        case financeVariations = "FinanceVariations"
        case financeClaims = "FinanceClaims"
        case financeReceipts = "FinanceReceipts"
        case id = "Id"
    }
}

// MARK: - Finance
struct Finance: Codable {
    let amount: Double
    let financeDescription: String

    enum CodingKeys: String, CodingKey {
        case amount = "Amount"
        case financeDescription = "Description"
    }
}
