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
//import PagingCollectionViewLayout

class PhotosVC: UIViewController {
    
    //MARK: - Properties
    
    @IBOutlet weak var notificationCountLBL: UILabel!
    @IBOutlet weak var profileImgView: UIImageView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var groupedDict : [String : [DocumentsDetailsStruct]]?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - LifeCycleMethods
    var documentList : [DocumentsDetailsStruct]?
    var menu : SideMenuNavigationController!
    
    var cellWidth = (3/4) * UIScreen.main.bounds.width
    var spacing = (1/8) * UIScreen.main.bounds.width
    var cellSpacing = (1/16) * UIScreen.main.bounds.width
    var sectionTitles : [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
//        let layout = UICollectionViewFlowLayout()
//        layout.itemSize = CGSize(width: collectionView.frame.width * 0.8, height: collectionView.frame.height)
//        layout.scrollDirection = .horizontal
//        collectionView.collectionViewLayout = layout
        
        let layout = PagingCollectionViewLayout()
       // let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: cellWidth, height: collectionView.frame.height - 20)
        layout.scrollDirection = .horizontal
       // layout.collectionView?.decelerationRate = .fast
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        layout.minimumLineSpacing = cellSpacing
        collectionView.decelerationRate = .fast
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        
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
        let contractNo = currenUserJobDetails?.jobNumber ?? ""
        
        
        NetworkRequest.makeRequestArray(type: DocumentsDetailsStruct.self, urlRequest: Router.documentsDetails(auth: valueStr, contractNo: contractNo)) { [weak self](result) in
            switch result
            {
            case .success(let data):
                guard let self = self else {return}
                self.documentList = data.filter({$0.type?.uppercased() == "JPG"})
                guard self.documentList?.count ?? 0 > 0 else {DispatchQueue.main.async {
                
                    self.showAlert(message: "No photos found") { _ in
                       // self.backButtonPressed()
                    }
                } ; return}
                self.groupedDict = Dictionary.init(grouping: self.documentList!, by: {$0.title!.components(separatedBy: " ")[0]})
                
              //  self.groupedDict = Dictionary.init(grouping: self.documentList!, by: {$0.title!})
                DispatchQueue.main.async {
                    //  print(self.documentList)
                    self.collectionView.reloadData()
                }
                
            case.failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    
    //MARK:- Actions
    @IBAction func seeAllPhotosBtnClicked(_ sender: UIButton) {
        let vc = UIStoryboard(name: StoryboardNames.newDesing, bundle: nil).instantiateViewController(withIdentifier: "PhotosListVC") as! PhotosListVC
        vc.groupedPhotos = self.groupedDict
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


extension PhotosVC : UICollectionViewDelegate , UICollectionViewDataSource
{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return groupedDict?.keys.count ?? 0
  }
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCVCell", for: indexPath) as! PhotosCVCell
    
        let sectionArray = Array(groupedDict!.keys)
        let sectionTitle = sectionArray[indexPath.row]
        cell.sectionNameLb.text = sectionTitle
        cell.photosCountLb.text = "\(groupedDict?[sectionTitle]?.count ?? 0)"
        let photoInfo = groupedDict?[sectionTitle]?.last
        CodeManager.sharedInstance.downloadandShowImageForNewFlow(photoInfo!,cell.imageView) 
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: StoryboardNames.newDesing, bundle: nil).instantiateViewController(withIdentifier: "PhotosListVC") as! PhotosListVC
        vc.groupedPhotos = self.groupedDict
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
