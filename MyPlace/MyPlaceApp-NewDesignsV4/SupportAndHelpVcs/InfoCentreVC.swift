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
    
    @IBOutlet weak var searchBTN: UIButton!
    @IBOutlet weak var categoriesCollection: UICollectionView!
    
    @IBOutlet weak var resultCollection: UICollectionView!
    var colors = [
        UIColor(red: 0.7373, green: 1, blue: 0.9882, alpha: 1.0) /* #bcfffc */,
        UIColor(red: 0.9725, green: 0.7294, blue: 0.9882, alpha: 1.0) /* #f8bafc */,
        UIColor(red: 0.7373, green: 1, blue: 0.9882, alpha: 1.0) /* #bcfffc */,
        UIColor(red: 1, green: 0.9922, blue: 0.7373, alpha: 1.0) /* #fffdbc */,
        UIColor(red: 0.7569, green: 0.9882, blue: 0.7294, alpha: 1.0) /* #c1fcba */,
        UIColor(red: 0.7451, green: 0.7373, blue: 1, alpha: 1.0) /* #bebcff */,
        UIColor(red: 0.949, green: 0.7373, blue: 1, alpha: 1.0) /* #f2bcff */,
        UIColor(red: 1, green: 0.7373, blue: 0.7412, alpha: 1.0) /* #ffbcbd */,
        UIColor(red: 0.7373, green: 0.9922, blue: 1, alpha: 1.0) /* #bcfdff */]
    
    var borderColors = [#colorLiteral(red: 0, green: 0.9077788919, blue: 0.9912686944, alpha: 1),#colorLiteral(red: 0.9871214032, green: 0, blue: 0.9912000299, alpha: 1),#colorLiteral(red: 0, green: 0.7988556338, blue: 0.9912686944, alpha: 1),#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1),#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1),#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1),#colorLiteral(red: 0.8404042343, green: 0, blue: 0.6789172535, alpha: 1),#colorLiteral(red: 1, green: 0.5731489273, blue: 0.5818556252, alpha: 1),#colorLiteral(red: 0.4831717577, green: 0.7491303682, blue: 1, alpha: 1)]
    
    
    var typeOfInfo = ["What is a PCI and what can you do?","Using the MyPlace App.","Sorting out your Finance","What is a PCI and what can you do?","Using the MyPlace App.","Sorting out your Finance","What is a PCI and what can you do?"]
    var imagesInfo = [UIImage(named: "1"),UIImage(named: "2"),UIImage(named: "1"),UIImage(named: "2"),UIImage(named: "1"),UIImage(named: "2"),UIImage(named: "2")]
    var isSearchSelected = false
    
    var infoCentreDataArr = [LstInfo]()
    
    var infoCentreCategories : [String : [LstInfo]] = [:]
    
    //MARK- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBTN.tintColor = AppColors.appOrange
        
        categoriesCollection.delegate = self
        categoriesCollection.dataSource = self
        
        resultCollection.delegate = self
        resultCollection.dataSource = self
        self.categoriesCollection.isHidden = true
        
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

        getIfocentreDetails()
        // Do any additional setup after loading the view.
    }
    func getIfocentreDetails()
    {
        NetworkRequest.makeRequest(type: InfoCentreStruct.self, urlRequest: Router.infoCentreDetails) { [weak self](result) in
        switch result
        {
        case .success(let data):
            
//            appDelegate.currentUser?.userDetailsArray[0].region
            var currenUserJobDetails : MyPlaceDetails?
            currenUserJobDetails = (UIApplication.shared.delegate as! AppDelegate).currentUser?.userDetailsArray![0].myPlaceDetailsArray[0]

            let region = getRegionName(currenUserJobDetails?.region ?? "")
            for i in 0..<data.lstFAQ.count{
                if data.lstFAQ[i].state.contains(region){
                    self?.infoCentreDataArr.append(data.lstFAQ[i]) 
                }
                    
            }
         self?.infoCentreCategories = Dictionary(grouping: data.lstFAQ, by: { $0.category ?? "" })
           

//            append(contentsOf: data.filter({$0.Category}))
//            = data.filter({$0.type?.uppercased() == "JPG"})
          DispatchQueue.main.async {
          //  print(self?.infoCentreDataArr)
            //  print(self?.infoCentreCategories)
            self?.resultCollection.reloadData()
              self?.categoriesCollection.reloadData()
              
          }
        
        case.failure(let err):
          print(err.localizedDescription)
        }
      }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBarButtons(title: "", backButton: true, notificationIcon: false)
        
    }
    
    
    @IBAction func didTappedOnBackBTN(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func didTappedOnSupport(_ sender: UIButton) {
    }
    
    @IBAction func didTappedOnSearch(_ sender: UIButton) {
        sender.isSelected.toggle()
        self.categoriesCollection.isHidden = !sender.isSelected
    }
    
    
}

extension InfoCentreVC : UICollectionViewDelegate , UICollectionViewDataSource
{
    //MARK:-  CollectionView Delegate Datasource
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.categoriesCollection {
           
            return infoCentreCategories.count
        }else{
            
            return infoCentreDataArr.count
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.categoriesCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfoCategoriesCVC", for: indexPath) as! InfoCategoriesCVC
            let color1 = colors[indexPath.row]
            let bColors = borderColors[indexPath.row]
//            cell.cardView.backgroundColor = UIColor(hexString: colors[indexPath.row % cellColors.count])
//            
            cell.cardView.backgroundColor = colors[indexPath.row]
            cell.cardView.layer.borderColor = bColors.cgColor
            cell.cardView.layer.borderWidth = 0.5
            let index = indexPath.row
            cell.categoriesLBL.text = Array(self.infoCentreCategories)[index].key
//            self.infoCentreCategories.keys[index]
            
            return cell
            
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfoCVC", for: indexPath) as! InfoCVC
            cell.infoTextLBL.text = self.infoCentreDataArr[indexPath.row].heading
            let url = infoCentreDataArr[indexPath.row].image.replacingOccurrences(of: "~", with: "")
            let documentURL = "\(clickHomeBaseImageURLForLive)\(url ?? "")"
            print(documentURL)
            cell.imageView.sd_setImage(with: URL(string: documentURL), placeholderImage: UIImage(named: "placeholder"))
            return cell
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == resultCollection
        {
            let vc = UIStoryboard(name: "NewDesignsV5", bundle: nil).instantiateViewController(withIdentifier: "InfoCentreDetailsVC") as! InfoCentreDetailsVC
            vc.infoCentreDetails = self.infoCentreDataArr[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension InfoCentreVC : UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.categoriesCollection {
            let width = collectionView.frame.size.width / 3
            return CGSize(width: width - 10, height: 40)
            
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
