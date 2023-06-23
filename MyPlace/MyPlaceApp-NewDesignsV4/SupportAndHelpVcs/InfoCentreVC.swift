//
//  InfoCentreVC.swift
//  BurbankApp
//
//  Created by Lifecykul on 16/12/21.
//  Copyright © 2021 DMSS. All rights reserved.
//

import UIKit
import SDWebImage

class InfoCentreVC: UIViewController {
    
    @IBOutlet weak var categoriesCollectionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBTN: UIButton!
    @IBOutlet weak var categoriesCollection: UICollectionView!
    
    @IBOutlet weak var resultCollection: UICollectionView!

    var isSearchSelected = false
    var infoCentreDataArr = [LstInfo]()
    var infoCentreDataFilterArr = [LstInfo]()
    var infoCentreCategories : [String : [LstInfo]] = [:]
    var categoriesArray : [String] = []
    var selectedCategoryIndex : Int = -1//selected category
    
    //MARK- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBTN.tintColor = AppColors.appOrange
        
        categoriesCollection.delegate = self
        categoriesCollection.dataSource = self
        
        resultCollection.delegate = self
        resultCollection.dataSource = self
        self.categoriesCollection.isHidden = true
        
        // Custom Layouts
        let layout = UICollectionViewFlowLayout()
        let width = resultCollection.frame.size.width / 2
        layout.itemSize = CGSize(width: width - 10, height: width - 20)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        resultCollection.collectionViewLayout = layout
        
        let categoryLayout = UICollectionViewFlowLayout()
        let Cwidth = categoriesCollection.frame.size.width / 3
        categoryLayout.itemSize = CGSize(width: Cwidth - 10, height: 40)
        categoriesCollection.collectionViewLayout = categoryLayout
        //
        
        getIfocentreDetails()
        resultCollection.addRefressControl {[weak self] in
            self?.getIfocentreDetails()
        }
        // Do any additional setup after loading the view.
    }

    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        categoriesCollectionHeightConstraint.constant = categoriesCollection.contentSize.height
    }
    
//    @available(iOS 13.0, *)
//    func getCompositionalLayout() -> UICollectionViewLayout
//    {
//
//    }
//
    func getIfocentreDetails()
    {
        guard isNetworkReachable else { showAlert(message: checkInternetPullRefresh) {[weak self] _ in
            DispatchQueue.main.async {
                self?.resultCollection.refreshControl?.endRefreshing()
            }
        }; return}
        NetworkRequest.makeRequest(type: InfoCentreStruct.self, urlRequest: Router.infoCentreDetails) { [weak self](result) in
        switch result
        {
        case .success(let data):
            guard let self = self else {return}
            guard data.lstFAQ.count > 0 else {self.showAlert(message: "Found Zero Records");return}
//            appDelegate.currentUser?.userDetailsArray[0].region
            var currenUserJobDetails : MyPlaceDetails?
            currenUserJobDetails = (UIApplication.shared.delegate as! AppDelegate).currentUser?.userDetailsArray![0].myPlaceDetailsArray[0]

            // Getting only current region values
            let region = getRegionName(currenUserJobDetails?.region ?? "")
            self.infoCentreDataArr = data.lstFAQ.filter({$0.state.contains(region)}) // filtering based on current state
            guard self.infoCentreDataArr.count > 0 else {self.showAlert(message: "Found Zero Records");return}
            self.infoCentreDataFilterArr = self.infoCentreDataArr
            let groupedDict = Dictionary(grouping: self.infoCentreDataArr, by: { $0.category })
            self.infoCentreCategories = groupedDict
            self.categoriesArray = Array(groupedDict.keys).sorted(by: {$0 < $1}) //categories array
            
            DispatchQueue.main.async {
                //  print(self?.infoCentreDataArr)
                //  print(self?.infoCentreCategories)
                self.resultCollection.reloadData()
                self.categoriesCollection.reloadData()
                
            }
        
        case.failure(let err):
          print(err.localizedDescription)
            
          
        }
            DispatchQueue.main.async {
                appDelegate.hideActivity()
                self?.resultCollection.refreshControl?.endRefreshing()
            }
      }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBarButtons()
        
    }
    
    
    @IBAction func didTappedOnBackBTN(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func didTappedOnSupport(_ sender: UIButton) {
    }
    
    @IBAction func didTappedOnSearch(_ sender: UIButton) {
        sender.isSelected.toggle()
        selectedCategoryIndex = -1 // show original collection
        self.categoriesCollection.isHidden = !sender.isSelected
        self.infoCentreDataFilterArr = self.infoCentreDataArr
        self.resultCollection.reloadData()
        categoriesCollection.reloadData()
        categoriesCollection.layoutIfNeeded()
    }
    
    
}

extension InfoCentreVC : UICollectionViewDelegate , UICollectionViewDataSource
{
    //MARK:-  CollectionView Delegate Datasource
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.categoriesCollection {
           
            return categoriesArray.count
        }else{
            
            return infoCentreDataFilterArr.count
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.categoriesCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfoCategoriesCVC", for: indexPath) as! InfoCategoriesCVC
          // let index = (indexPath.row) % (colors.count) // to get rid of out of bouds of colors
//            let color = colors[index]
//            let bColors = borderColors[index]
//            cell.cardView.backgroundColor = UIColor(hexString: colors[indexPath.row % cellColors.count])
//
            cell.cardView.backgroundColor = selectedCategoryIndex == indexPath.row ? AppColors.appOrange : .white
            cell.cardView.layer.borderColor = AppColors.appOrange.cgColor
            cell.cardView.layer.borderWidth = 0.5
            cell.categoriesLBL.text = categoriesArray[indexPath.row]
            cell.categoriesLBL.textColor = selectedCategoryIndex == indexPath.row ? .white : .black
            cell.categoriesLBL.font = selectedCategoryIndex == indexPath.row ? .systemFont(ofSize: 14.0, weight: .semibold) : .systemFont(ofSize: 14.0 , weight: .semibold)
//            self.infoCentreCategories.keys[index]
            
            return cell
            
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfoCVC", for: indexPath) as! InfoCVC
            cell.infoTextLBL.text = self.infoCentreDataFilterArr[indexPath.row].heading
            let url = infoCentreDataFilterArr[indexPath.row].image.replacingOccurrences(of: "~", with: "")
            let documentURL = "\(clickHomeBaseImageURLForLive)\(url)"
            print(documentURL)
            cell.imageView.sd_setImage(with: URL(string: documentURL), placeholderImage: UIImage(named: "BurbankLogo"))
            return cell
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == resultCollection
        {
            let vc = InfoCentreDetailsVC.instace(sb: .supportAndHelp)
            
            vc.infoCentreDetails = self.infoCentreDataFilterArr[indexPath.row]
            
            self.navigationController?.pushViewController(vc, animated: true)
        }else{ //categories collectionview click
            selectedCategoryIndex = indexPath.row
            self.infoCentreDataFilterArr = []
            let key = categoriesArray[indexPath.row]
            
            self.infoCentreDataFilterArr = infoCentreCategories[key] ?? []
            resultCollection.reloadData()
            categoriesCollection.reloadData()
        }
    }
}

extension InfoCentreVC : UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.categoriesCollection {
            let width = collectionView.frame.size.width / 3
            return CGSize(width: width - 10, height: 50)
            
        }else{
            let width = collectionView.frame.size.width / 2
            return CGSize(width: width - 5 , height: width - 20)
            
        }
        //  print("size of item :- \(CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height))")
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == resultCollection
        {
            return 0
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == resultCollection
        {
            return 0
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == resultCollection
        {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
// MARK: - InfoCentre
struct InfoCentreStruct: Codable {
    let lstFAQ: [LstInfo]

    enum CodingKeys: String, CodingKey {
        case lstFAQ = "lstFaq"
    }
}

// MARK: - LstFAQ
struct LstInfo: Codable {
    let state, category, image, heading: String
    let lstFAQDescription: String
    let videoURL: String

    enum CodingKeys: String, CodingKey {
        case state = "State"
        case category = "Category"
        case image = "Image"
        case heading = "Heading"
        case lstFAQDescription = "Description"
        case videoURL = "VideoUrl"
    }
}

