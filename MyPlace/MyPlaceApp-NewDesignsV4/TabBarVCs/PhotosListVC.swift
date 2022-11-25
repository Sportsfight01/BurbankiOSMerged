//
//  PhotosListVC.swift
//  BurbankApp
//
//  Created by naresh banavath on 30/11/21.
//  Copyright © 2021 DMSS. All rights reserved.
//

import UIKit

class PhotosListVC: UIViewController {
    
    //MARK: - Properties
    @IBOutlet weak var newCountView: UIView!
    @IBOutlet weak var countPhotosLb: UILabel!    
    @IBOutlet weak var newCountLb: UILabel!
    
    
    // var photoList : [DocumentsDetailsStruct]!
    var yearMonthPhotoListArray = [YearMonthListNewFlow]()
    var selectedIndexForQLDSA = 0
    var groupedPhotos : [String : [DocumentsDetailsStruct]]?
  
    var dayWisePhotoList : DayWisePhotoList<MyPlaceDocuments>!//for QLDSA
    var selectedDayIndex = 0//for QLS SA
    var monthWisePhotoList : YearMonthList!//for QLDSA for next and previous
    var yearMonthNumber = 0
    var isFromNotifications = false
    var selectedImgViewIndex = 0
  @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - LifeCycle
  override func viewDidLoad() {
        super.viewDidLoad()
    collectionView.delegate = self
    collectionView.dataSource = self
    let layout = UICollectionViewFlowLayout()
    let width = collectionView.bounds.width / 5
    layout.itemSize = CGSize(width: width, height: width)
    layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 8)
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    
    collectionView.collectionViewLayout = layout
      let photoCount = groupedPhotos?.values.flatMap({$0}).count
      print("photoscount :- \(photoCount)")
      self.countPhotosLb.text = "\(photoCount ?? 0) photos"
        // Do any additional setup after loading the view.
    }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    title = "BURBANK MYPLACE"
      newCountLb.isHidden = true
      newCountView.isHidden = true

    self.navigationController?.setNavigationBarHidden(true, animated: false)
      
      if let photosCount = groupedPhotos?.values.flatMap({$0}).count , photosCount > 0
      {
          if let newPhotosCount = UserDefaults.standard.value(forKey: "NewPhotosCount") as? Int
          {
              //when photos are updated need to show increased photos count
              if newPhotosCount < photosCount
              {
                  let newCount = photosCount - newPhotosCount
                  newCountLb.text = "\(newCount) New"
                  UserDefaults.standard.setValue(photosCount, forKey: "NewPhotosCount")
                  newCountLb.isHidden = false
                  newCountView.isHidden = false
              }
              //when we don't have new photos hide the label
              else {
                  newCountLb.isHidden = true
                  newCountView.isHidden = true
              }
          }
          else {
              newCountLb.isHidden = false
              newCountView.isHidden = false
              UserDefaults.standard.setValue(photosCount, forKey: "NewPhotosCount")
              newCountLb.text = "\(photosCount) New"
          }
      }
      
    self.collectionView.reloadData()
    
    
  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: false)
  }
  //MARK: - Helper functions
    //will try for future versions
    @available(iOS 13.0, *)
  func collectionViewCompositionalLayout() -> UICollectionViewLayout
    {
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2), heightDimension: .fractionalWidth(0.2)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 2.0
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 8)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
  @IBAction func backBtnClicked(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
}

extension PhotosListVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout
{
  func numberOfSections(in collectionView: UICollectionView) -> Int {
   // return  selectedIndexForQLDSA
      return groupedPhotos?.keys.count ?? 0
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//    return yearMonthPhotoListArray[selectedIndexForQLDSA].list.count
      let arr = Array(groupedPhotos!.keys)
      let key = arr[section]
      return groupedPhotos?[key]?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosListCVCell.identifier, for: indexPath) as! PhotosListCVCell
      
      let sectionArray = Array(groupedPhotos!.keys)
     let sectionTitle = sectionArray[indexPath.section]
      //cell.sectionNameLb.text = sectionTitle
      let arr = groupedPhotos?[sectionTitle]
      
      CodeManager.sharedInstance.downloadandShowImageForNewFlow(arr![indexPath.row],cell.imView)
   
    return cell
  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let vc = UIStoryboard(name: StoryboardNames.newDesing, bundle: nil).instantiateViewController(withIdentifier: "ZoomImageVC") as! ZoomImageVC
      //let item = collectionView.cellForItem(at: indexPath) as? PhotosListCVCell
      //vc.imgView.image = item?.imView.image
      
      let sectionArray = Array(groupedPhotos!.keys)
     let sectionTitle = sectionArray[indexPath.section]
      //cell.sectionNameLb.text = sectionTitle
      let arr = groupedPhotos?[sectionTitle]
      vc.imgData = arr![indexPath.row]
      let date = dateFormatter(dateStr: groupedPhotos?[sectionTitle]?[indexPath.row].docdate ?? "", currentFormate: "yyyy-MM-dd'T'HH:mm:ss.SSS", requiredFormate: "EEEE, dd/MM/yy")
      vc.docDate = date
    
    self.navigationController?.pushViewController(vc, animated: true)
  }
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let section = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionSectionHeaderView.identifier, for: indexPath) as! CollectionSectionHeaderView
      
      let sectionArray = Array(groupedPhotos!.keys)
    //  print(sectionArray)
     let sectionTitle = sectionArray[indexPath.section]
      //print(sectionArray[indexPath.section])
      section.sectionTitleLb.text = sectionTitle
      
      let date = dateFormatter(dateStr: groupedPhotos?[sectionTitle]?[0].docdate?.components(separatedBy: ".").first ?? "", currentFormate: "yyyy-MM-dd'T'HH:mm:ss", requiredFormate: "EEEE, dd/MM/yy")
      //print(date)
      //print(groupedPhotos?[sectionTitle]?[0].docdate ?? "")

      section.dateLb.text = date
      
    
    return section
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return CGSize(width: collectionView.frame.width, height: 50)
  }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 8)
    }
  
  
  
}
