//
//  PhotosVC.swift
//  BurbankApp
//
//  Created by naresh banavath on 24/11/21.
//  Copyright © 2021 DMSS. All rights reserved.
//

import UIKit
import SideMenu
//import PagingCollectionViewLayout
import SDWebImage
import SkeletonView

class PhotosVC: BaseProfileVC {
    
    //MARK: - Properties
    

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var seeAllPhotosBtn : UIButton!
    {
        didSet{
            seeAllPhotosBtn.titleLabel?.font = FONT_LABEL_BODY(size: FONT_16)
            seeAllPhotosBtn.isHidden = true
        }
    }

    var collectionDataSource : [PhotoItem]?
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
        getPhotos()
        setupTitles()
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGestue))
        swipeDownGesture.direction = .down
        view.addGestureRecognizer(swipeDownGesture)
        view.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 20)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.collectionView.stopSkeletonAnimation()
        self.collectionView.refreshControl?.endRefreshing()
       
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    //MARK: - Helper Funcs
    @objc func handleSwipeGestue(_ sender : UISwipeGestureRecognizer)
    {
        if sender.state == .ended
        {
            self.getPhotos()
        }
    }
    func setupTitles()
    {
        profileView.titleLb.text = "MyPhotos"
        profileView.helpTextLb.text = "Here's your most recent site photos.\nTap below to see all."
    }
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
    
    func setupServiceData(_ PhotosList : [DocumentsDetailsStructV3])
    {
        
        let groupedDict = Dictionary.init(grouping: PhotosList, by: {$0.title!.components(separatedBy: " ")[0]})
        self.collectionDataSource = []
        groupedDict.forEach { (key: String, value: [DocumentsDetailsStructV3]) in
            let sortedValue = value.sorted(by: { item1 , item2 in
                let date1 = item1.metaData.date
                let date2 = item2.metaData.date
                return date1.compare(date2) == .orderedDescending
            })
         //   print("beforeSorting : \(value.map({$0.docdate})) after sorting : \(sortedValue.map({$0.docdate}))")
            self.collectionDataSource?.append(PhotoItem(title: key, rowData: sortedValue))
        }
        self.collectionDataSource = collectionDataSource?.sorted(by: { item1 , item2 in
            guard let date1 = item1.rowData.first?.metaData.date,
                  let date2 = item2.rowData.first?.metaData.date else {return false}
            return date1.compare(date2) == .orderedDescending
        })
        DispatchQueue.main.async {
            //  print(self.documentList)
            self.collectionView.reloadData()
          
            
        }
    }
    

    //MARK: - Service Calls
    func getPhotos(){
        guard isNetworkReachable else { showAlert(message: checkInternetPullRefresh) {[weak self] _ in
            DispatchQueue.main.async {
                self?.collectionView.refreshControl?.endRefreshing()
            }
        }; return}
        appDelegate.showActivity()
        APIManager.shared.getMyDocuments(isDocuments: false) {[weak self] result in
            DispatchQueue.main.async {
                appDelegate.hideActivity()
                self?.collectionView.refreshControl?.endRefreshing()
            }
            guard let self else { return }
            switch result{
            case .success(let photos):
                //hide skeleton
                DispatchQueue.main.async {
                    self.collectionView.stopSkeletonAnimation()
                    self.view.hideSkeleton()
                }
                DispatchQueue.main.async {
                    appDelegate.hideActivity()
                    self.collectionView.refreshControl?.endRefreshing()
                }
//                guard let self = self else {return}
                let imageTypes = ["jpg", "png","jpeg"]
                let documentList = photos.filter( { imageTypes.contains( $0.type?.trim().lowercased() ?? "") } )
                guard photos.count > 0 else {
                    DispatchQueue.main.async {
                        self.collectionView.setEmptyMessage("No recent photos")
                        self.profileView.helpTextLb.text = "No photos available for this job number."
                        
                    }; return}
                DispatchQueue.main.async {
                    self.seeAllPhotosBtn.isHidden = photos.count == 0 ? true : false
                    self.setupServiceData(photos)
                }
                
                
                
                
            case .failure(let err):
                debugPrint(err.localizedDescription)
                DispatchQueue.main.async {
                    self.showAlert(message: err.description)
                    return}
            }
        }
        
        
    }
//    {
//
//        guard isNetworkReachable else { showAlert(message: "Check your internet and pull to refresh again") {[weak self] _ in
//            DispatchQueue.main.async {
//                appDelegate.hideActivity()
//                self?.collectionView.refreshControl?.endRefreshing()
//            }
//        };return
//        }
//        let jobAndAuth = APIManager.shared.getJobNumberAndAuthorization()
//        guard let jobNumber = jobAndAuth.jobNumber else {debugPrint("Job Number is Null");return}
//        let auth = jobAndAuth.auth
//        self.collectionView.showAnimatedGradientSkeleton()
//        NetworkRequest.makeRequestArray(type: DocumentsDetailsStruct.self, urlRequest: Router.documentsDetails(auth: auth, contractNo: jobNumber), showActivity: false) { [weak self](result) in
//            DispatchQueue.main.async {
//                self?.collectionView.stopSkeletonAnimation()
//                self?.view.hideSkeleton()
//            }
//            switch result
//            {
//            case .success(let data):
//                guard let self = self else {return}
//                let imageTypes = ["jpg", "png","jpeg"]
//                let documentList = data.filter( { imageTypes.contains( $0.type?.trim().lowercased() ?? "") } )
//                guard documentList.count > 0 else {
//                    DispatchQueue.main.async {
//                        self.collectionView.setEmptyMessage("No recent photos")
//                        self.profileView.helpTextLb.text = "No photos available for this job number."
//
//                }; return}
//                self.seeAllPhotosBtn.isHidden = documentList.count == 0 ? true : false
//                self.setupServiceData(documentList)
//               
//            case.failure(let err):
//                print(err.localizedDescription)
//            }
//            DispatchQueue.main.async {
//                appDelegate.hideActivity()
//                self?.collectionView.refreshControl?.endRefreshing()
//            }
//            
//        }
//    }
    
    
    //MARK:- Actions
    @IBAction func seeAllPhotosBtnClicked(_ sender: UIButton) {
        let vc = PhotosListVC.instace()
        vc.collectionDataSource = self.collectionDataSource ?? []
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func didTappedOnMenuIcon(_ sender: UIButton) {
        present(menu, animated: true, completion: nil)
    }
    
    @IBAction func supportBtnTapped(_ sender: UIButton) {
        let vc = ContactUsVC.instace(sb: .supportAndHelp)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: -  CollectionView Delegate & Datasource
extension PhotosVC : UICollectionViewDelegate, SkeletonCollectionViewDataSource
{
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "PhotosCVCell"
    }
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
        cell.imageView.sd_setImage(with: URL(string: "\(photoInfo?.url ?? "")"))
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PhotosListVC.instace()
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



