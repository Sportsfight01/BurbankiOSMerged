//
//  PhotosListVC.swift
//  BurbankApp
//
//  Created by naresh banavath on 30/11/21.
//  Copyright © 2021 DMSS. All rights reserved.
//

import UIKit
import SDWebImage

struct PhotoItem
{
    let title : String
    let rowData : [DocumentsDetailsStruct]
}


class PhotosListVC: UIViewController {
    
    //MARK: - Properties
    @IBOutlet weak var newCountView: UIView!
    @IBOutlet weak var countPhotosLb: UILabel!
    @IBOutlet weak var newCountLb: UILabel!
    @IBOutlet weak var titleLb : UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedIndexForQLDSA = 0
    var selectedDayIndex = 0//for QLS SA
    var selectedImgViewIndex = 0
    var collectionDataSource : [PhotoItem] = []
    var photosCount : Int = 0
    var moveToSection : Int?
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        let width = (collectionView.bounds.width - 24) / 5
        layout.itemSize = CGSize(width: width, height: width)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 8)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView.collectionViewLayout = layout

        
        self.photosCount = collectionDataSource.compactMap({$0.rowData}).flatMap({$0}).count
        //   print("photoscount :- \(photoCount)")
        self.countPhotosLb.text = "\(photosCount) photo".appending(photosCount > 1 ? "s" : "")
        // Do any additional setup after loading the view.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4)
        {[weak self] in
            if let moveToSection = self?.moveToSection
            {
                let lastItem = (self?.collectionView.numberOfItems(inSection: moveToSection) ?? 1) - 1
                self?.collectionView.scrollToItem(at: IndexPath(item: lastItem, section: moveToSection), at: .bottom, animated: true)
            }
        }
    }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
      self.setupNavigationBarButtons()
      setupFonts()
      newCountLb.isHidden = true
      newCountView.isHidden = true
      
       if photosCount > 0
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
    
  //MARK: - Helper functions
    //will try for future versions
    @available(iOS 13.0, *)
  func collectionViewCompositionalLayout() -> UICollectionViewLayout
    {
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2), heightDimension: .fractionalWidth(0.2)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 2.0
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
//  @IBAction func backBtnClicked(_ sender: UIButton) {
//    self.navigationController?.popViewController(animated: true)
//  }
    
    func setupFonts()
    {
        countPhotosLb.font = FONT_LABEL_BODY(size: FONT_10)
        titleLb.font = FONT_LABEL_BODY(size: FONT_16)
        newCountLb.font = FONT_LABEL_SUB_HEADING(size: FONT_10)
        
    }
  
}
//MARK: - CollectionView Delegate & Datasource
extension PhotosListVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout
{
  func numberOfSections(in collectionView: UICollectionView) -> Int {

      return collectionDataSource.count
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return collectionDataSource[section].rowData.count
  }
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosListCVCell.identifier, for: indexPath) as! PhotosListCVCell
        
        let arr = collectionDataSource[indexPath.section].rowData
        //      CodeManager.sharedInstance.downloadandShowImageForNewFlow(arr[indexPath.row],cell.imView)
        cell.imView.backgroundColor = .lightGray.withAlphaComponent(0.5)
        let imgURL = URL(string:"\(clickHomeBaseImageURL)/\(arr[indexPath.item].url ?? "")")
        cell.imView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.imView.sd_imageIndicator?.indicatorView.tintColor = APPCOLORS_3.Orange_BG
        //  cell.imView.sd_setImage(with: imgURL)
        cell.imView.sd_setImage(with: imgURL, placeholderImage: nil) { _, _, _, _ in
            cell.imView.backgroundColor = .white
        }
        
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = collectionDataSource[indexPath.section].rowData[indexPath.item]
        //vc.imgData = item
        let flatImageUrls = collectionDataSource.compactMap({$0.rowData}).flatMap({$0}).compactMap({$0.url})
        
        let imgVC = ImageSliderVC()
        let items = collectionDataSource
            .compactMap({$0.rowData})
            .flatMap({$0})
            .map({ImageSliderVC.SliderItem(title: $0.title ?? "", docDate: dateFormatter(dateStr: $0.docdate?.components(separatedBy: "T").first ?? "", currentFormate: "yyyy-MM-dd", requiredFormate: "EEEE, dd/MM/yy") ?? "", url: $0.url ?? "") })
        /*testing purpose to see exact time on photo
         //                .map({ImageSliderVC.SliderItem(title: $0.title ?? "", docDate: dateFormatter(dateStr: $0.docdate?.components(separatedBy: ".").first ?? "", currentFormate: "yyyy-MM-dd'T'HH:mm:ss", requiredFormate: "EEEE, dd/MM/yy, HH:mm:ss") ?? "", url: $0.url ?? "") })*/
        imgVC.collectionDataSource = items
        imgVC.initialIndex = flatImageUrls.firstIndex(of: item.url ?? "") ?? 0
        self.navigationController?.pushViewController(imgVC, animated: true)
        
        
        
    }
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
      
    let section = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionSectionHeaderView.identifier, for: indexPath) as! CollectionSectionHeaderView
      
      let title = collectionDataSource[indexPath.section].rowData.first?.title?.capitalized
      section.sectionTitleLb.text = title
      section.sectionTitleLb.font = ProximaNovaRegular(size: 15.0)
    
      
      let date = dateFormatter(dateStr: collectionDataSource[indexPath.section].rowData.first?.docdate?.components(separatedBy: ".").first ?? "", currentFormate: "yyyy-MM-dd'T'HH:mm:ss", requiredFormate: "EEEE, dd/MM/yy")
      section.dateLb.font = ProximaNovaRegular(size: 14.0)
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
