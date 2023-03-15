//
//  FinanceVC.swift
//  BurbankApp
//
//  Created by naresh banavath on 24/11/21.
//  Copyright © 2021 DMSS. All rights reserved.
//

import UIKit
import SideMenu

class FinanceVC: UIViewController {
    
    @IBOutlet weak var notificationCountLBL: UILabel!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var balanceDueLb: UILabel!
    @IBOutlet weak var contractValueLb: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var financeDetails : FinanceDetailsStruct?
    var menu : SideMenuNavigationController!
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addGradientLayer()
        setupNavigationBar()
        collectionView.backgroundColor = .clear
        let layout = UICollectionViewFlowLayout()
        // collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: collectionView.frame.width * 0.8, height: collectionView.frame.height)
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        checkUserLoginForFinance()
        setupProfile()
        sideMenuSetup()
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 20)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.isHidden = true
        collectionView.reloadData()
        setupProfile()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    func sideMenuSetup()
    {
        let sideMenuVc = UIStoryboard(name: "NewDesignsV4", bundle: nil).instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menu = SideMenuNavigationController(rootViewController: sideMenuVc)
        menu.leftSide = true
        menu.menuWidth = 0.8 * UIScreen.main.bounds.width
        menu.presentationStyle = .menuSlideIn
     
        menu.setNavigationBarHidden(true, animated: false)
        SideMenuManager.default.leftMenuNavigationController = menu
        
        
    }
    func setupProfile()
    {
        profileImgView.contentMode = .scaleToFill
        profileImgView.clipsToBounds = true
        profileImgView.layer.cornerRadius = profileImgView.bounds.width/2
//        if let imgURlStr = CurrentUservars.profilePicUrl , let url = URL(string: imgURlStr)
//        {
//           // profileImgView.sd_setImage(with: url, placeholderImage: UIImage(named: "icon_User"))
//            profileImgView.downloaded(from: url)
//        }
        if let imgURlStr = CurrentUservars.profilePicUrl
        {
           // profileImgView.sd_setImage(with: url, placeholderImage: UIImage(named: "icon_User"))
            profileImgView.image = imgURlStr
        }
//        profileImgView.addBadge(number: appDelegate.notificationCount)
        if appDelegate.notificationCount == 0{
            notificationCountLBL.isHidden = true
        }else{
            notificationCountLBL.text = "\(appDelegate.notificationCount)"
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileClick(recognizer:)))
        profileImgView.addGestureRecognizer(tap)
        
    }
    @objc func handleProfileClick (recognizer: UIGestureRecognizer) {
        let vc = UIStoryboard(name: StoryboardNames.newDesing, bundle: nil).instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
        self.navigationController?.pushViewController(vc, animated: true)

    }
 
    
    @IBAction func didTappedOnMenuIcon(_ sender: UIButton) {
        
        present(menu, animated: true, completion: nil)
//        guard let vc = UIStoryboard(name: StoryboardNames.newDesing5, bundle: nil).instantiateInitialViewController() else {return}
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func supportBtnTapped(_ sender: UIButton) {
        guard let vc = UIStoryboard(name: StoryboardNames.newDesing5, bundle: nil).instantiateViewController(withIdentifier: "ContactUsVC") as? ContactUsVC else {return}
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    //MARK: - Service Calls
    func checkUserLoginForFinance()
    {
        guard  let myPlaceDetails = self.appDelegate.currentUser?.userDetailsArray?[0].myPlaceDetailsArray[0] else {return }
        let region = myPlaceDetails.region ?? ""
        var contractNo : String = ""
    
            if let jobNum = appDelegate.currentUser?.jobNumber, !jobNum.trim().isEmpty
            {
                contractNo = jobNum
            }
            else {
                contractNo = appDelegate.currentUser?.userDetailsArray?.first?.myPlaceDetailsArray.first?.jobNumber ?? ""
            }
        
        let password = myPlaceDetails.password ?? ""
        let userName = myPlaceDetails.userName ?? ""
        // ServiceSessionMyPlace.sharedInstance.serviceConnection("POST", url: url, postBodyDictionary: ["Region": region, "JobNumber":jobNumber, "UserName":userName, "Password":password], serviceModule:"PropertyStatusService")
        let postDic =  ["Region": region, "JobNumber":contractNo, "UserName":userName, "Password":password]
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
        appDelegate.showActivity()
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { [weak self](data, response, error) in
            DispatchQueue.main.async {
                self?.appDelegate.hideActivity()
            }
            print("URL:- \(response?.url) postData :- \(postDic)")
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
        var contractNo : String = ""
    
            if let jobNum = appDelegate.currentUser?.jobNumber, !jobNum.trim().isEmpty
            {
                contractNo = jobNum
            }
            else {
                contractNo = appDelegate.currentUser?.userDetailsArray?.first?.myPlaceDetailsArray.first?.jobNumber ?? ""
            }
        NetworkRequest.makeRequest(type: FinanceDetailsStruct.self, urlRequest: Router.getFinanceDetails(jobNumber: contractNo)) {[weak self] (result) in
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
        self.contractValueLb.text = "Contract Value : \(contractValue!)"
        collectionView.reloadData()
        
    }
    
}
extension FinanceVC : UICollectionViewDataSource , UICollectionViewDelegate
{
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
            cell.approvedVariationLb.text = dollarCurrencyFormatter(value: totalVariation ?? 0.0)
            cell.adjustedContractValueLb.text = dollarCurrencyFormatter(value: adjustedContractValue)
            //Claims
            cell.totalClaimedLb.text = dollarCurrencyFormatter(value: totClaims ?? 0.0)
            //Receipts
            cell.totalReceivedLb.text = dollarCurrencyFormatter(value: totRcvd ?? 0.0)
         //   cell.shareBTN.isHidden = true
//            cell.shareBTNPressed = {
//                cell.shareBTN.isHidden = true
//               let takenIMG = cell.baseView.takeScreenshot()
//               let takenPDF = createPDFDataFromImage(image: takenIMG)
////                let documento = NSData(contentsOfFile: takenPDF)
//                let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [takenPDF], applicationActivities: nil)
//                activityViewController.popoverPresentationController?.sourceView=self.view
//                self.present(activityViewController, animated: true, completion: nil)
//                cell.shareBTN.isHidden = false
//            }
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
        let vc = UIStoryboard(name: StoryboardNames.newDesing, bundle: nil).instantiateViewController(withIdentifier: "FinanceDetailVC") as! FinanceDetailVC
        if let financeDetails = self.financeDetails
        {
            vc.financeDetails = financeDetails
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let vc = UIStoryboard(name: StoryboardNames.newDesing, bundle: nil).instantiateViewController(withIdentifier: "FinanceDetailVC") as! FinanceDetailVC
      if let financeDetails = self.financeDetails
      {
          vc.financeDetails = financeDetails
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
