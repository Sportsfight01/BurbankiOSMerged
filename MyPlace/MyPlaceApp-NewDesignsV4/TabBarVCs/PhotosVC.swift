//
//  PhotosVC.swift
//  BurbankApp
//
//  Created by naresh banavath on 24/11/21.
//  Copyright © 2021 DMSS. All rights reserved.
//

import UIKit
import SideMenu
import PagingCollectionViewLayout
import SDWebImage

class PhotosVC: UIViewController {
    
    //MARK: - Properties
    
    @IBOutlet weak var helpTextLBL: UILabel!
    @IBOutlet weak var notificationCountLBL: UILabel!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var seeAllPhotosBtn : UIButton!

    var collectionDataSource : [PhotoItem]?
    var menu : SideMenuNavigationController!
    
    var cellWidth = (3/4) * UIScreen.main.bounds.width
    var spacing = (1/8) * UIScreen.main.bounds.width
//    var cellSpacing = (1/16) * UIScreen.main.bounds.width
    var cellSpacing : CGFloat = 0.0
    var sectionTitles : [String]?
    
    //MARK: - LifeCycleMethods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        addGradientLayer()
        getPresentMonthListForVLC()
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
        self.navigationController?.navigationBar.isHidden = true
        setupProfile()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    //MARK: - Helper Funcs
    
    func setupUI()
    {
        
        let layout = PagingCollectionViewLayout()
        layout.itemSize = CGSize(width: cellWidth, height: collectionView.frame.height - 20)
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        layout.minimumLineSpacing = cellSpacing
        collectionView.decelerationRate = .fast
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        
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
        if let imgURlStr = CurrentUservars.profilePicUrl
        {
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
    func setupServiceData(_ PhotosList : [DocumentsDetailsStruct])
    {
        
        let groupedDict = Dictionary.init(grouping: PhotosList, by: {$0.title!.components(separatedBy: " ")[0]})
        self.collectionDataSource = []
        groupedDict.forEach { (key: String, value: [DocumentsDetailsStruct]) in
            let sortedValue = value.sorted(by: { item1 , item2 in
                let date1 = item1.date
                let date2 = item2.date
                return date1.compare(date2) == .orderedDescending
            })
         //   print("beforeSorting : \(value.map({$0.docdate})) after sorting : \(sortedValue.map({$0.docdate}))")
            self.collectionDataSource?.append(PhotoItem(title: key, rowData: sortedValue))
        }
        self.collectionDataSource = collectionDataSource?.sorted(by: { item1 , item2 in
            guard let date1 = item1.rowData.first?.date,
                  let date2 = item2.rowData.first?.date else {return false}
            return date1.compare(date2) == .orderedDescending
        })
        DispatchQueue.main.async {
            //  print(self.documentList)
            self.collectionView.reloadData()
          
            
        }
    }
    
    
    @objc func handleProfileClick (recognizer: UIGestureRecognizer) {
        let vc = UIStoryboard(name: StoryboardNames.newDesing, bundle: nil).instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
        self.navigationController?.pushViewController(vc, animated: true)

    }

    //MARK: - Service Calls
    func getPresentMonthListForVLC()
    {
        var currenUserJobDetails : MyPlaceDetails?
        currenUserJobDetails = (UIApplication.shared.delegate as! AppDelegate).currentUser?.userDetailsArray![0].myPlaceDetailsArray[0]
        if selectedJobNumberRegionString == ""
        {
            let jobRegion = currenUserJobDetails?.region
            selectedJobNumberRegionString = jobRegion!
            // print("jobregion :- \(jobRegion)")
        }
        let authorizationString = "\(currenUserJobDetails?.userName ?? ""):\(currenUserJobDetails?.password ?? "")"
        let encodeString = authorizationString.base64String
        let valueStr = "Basic \(encodeString)"
        var contractNo : String = ""
    
            if let jobNum = appDelegate.currentUser?.jobNumber, !jobNum.trim().isEmpty
            {
                contractNo = jobNum
            }
            else {
                contractNo = appDelegate.currentUser?.userDetailsArray?.first?.myPlaceDetailsArray.first?.jobNumber ?? ""
            }
        
        
        NetworkRequest.makeRequestArray(type: DocumentsDetailsStruct.self, urlRequest: Router.documentsDetails(auth: valueStr, contractNo: contractNo)) { [weak self](result) in
            switch result
            {
            case .success(let data):
                guard let self = self else {return}
                let imageTypes = ["jpg", "png","jpeg"]
                let documentList = data.filter( { imageTypes.contains( $0.type?.lowercased() ?? "") } )
                guard documentList.count > 0 else {
                    DispatchQueue.main.async {
                        self.collectionView.setEmptyMessage("No recent photos")
                        self.helpTextLBL.text = "No photos available for this job number."
                        self.seeAllPhotosBtn.isHidden = documentList.count == 0 ? true : false
//                     self.showAlert(message: "No photos found") { _ in
//                        // self.backButtonPressed()
//                    }
                }; return}
                
                self.setupServiceData(documentList)
                
                
            case.failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    
    //MARK:- Actions
    @IBAction func seeAllPhotosBtnClicked(_ sender: UIButton) {
        let vc = UIStoryboard(name: StoryboardNames.newDesing, bundle: nil).instantiateViewController(withIdentifier: "PhotosListVC") as! PhotosListVC
        vc.collectionDataSource = self.collectionDataSource ?? []
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
}

//MARK: -  CollectionView Delegate & Datasource
extension PhotosVC : UICollectionViewDelegate , UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return collectionDataSource?.count ?? 0
    }
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCVCell", for: indexPath) as! PhotosCVCell

        cell.sectionNameLb.text = collectionDataSource?[indexPath.row].rowData.first?.title?.capitalized
        cell.photosCountLb.text = "\(collectionDataSource?[indexPath.row].rowData.count ?? 0)"
        let photoInfo = collectionDataSource?[indexPath.row].rowData.first
//        CodeManager.sharedInstance.downloadandShowImageForNewFlow(photoInfo!,cell.imageView)
        cell.imageView.tintColor = .lightGray
        
        cell.imageView.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        cell.imageView.sd_setImage(with: URL(string: "\(clickHomeBaseImageURL)/\(photoInfo?.url ?? "")"))
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: StoryboardNames.newDesing, bundle: nil).instantiateViewController(withIdentifier: "PhotosListVC") as! PhotosListVC
        vc.collectionDataSource = self.collectionDataSource ?? []
        vc.moveToSection = indexPath.item
        self.navigationController?.pushViewController(vc, animated: true)
    }
  
  
}

extension PhotosVC : UICollectionViewDelegateFlowLayout
{
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
   // let width = collectionView.frame.size.width * 0.8
    return CGSize(width: cellWidth , height: collectionView.frame.size.height)
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return cellSpacing
  }
}

extension UIImageView {
    
    func downloadImage(url : String)
    {
        if #available(iOS 13.0, *) {
            image = UIImage(systemName: "photo")
        } else {
            // Fallback on earlier versions
            image = nil
        }
        guard let url = URL(string: url) else {return}
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, error == nil
            {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            }
        }.resume()
    }
}


