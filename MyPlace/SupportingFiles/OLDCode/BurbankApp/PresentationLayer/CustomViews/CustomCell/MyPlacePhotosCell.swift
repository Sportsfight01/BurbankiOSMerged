//
//  MyPlacePhotosCell.swift
//  BurbankApp
//
//  Created by dmss on 09/05/17.
//  Copyright © 2017 DMSS. All rights reserved.
//

import UIKit

let spacing: CGFloat = 10


extension MyPlacePhotosProtocal
{
    func photoTappedForQLDSA(_ photoIndex: Int, _ cvIndex: Int)
    {
        //nothing to do
    }
}

protocol MyPlacePhotosProtocal
{
    func myPlacePhotoTapped(index: Int)
    func photoTappedForQLDSA(_ photoIndex: Int, _ cvIndex: Int)
}
class MyPlacePhotosCVCell: UICollectionViewCell,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
{
    @IBOutlet weak var photosGrid: UICollectionView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var monthAndYearLabel: UILabel!
    @IBOutlet weak var weekNameLabel: UILabel!
    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    var delegate: MyPlacePhotosProtocal?
    let cellID = "CellID"
    var photosArray = [MyPlacePhotos]()
    var photoListForQLDSA = [MyPlaceDocuments]()
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setAppearanceFor(view: dateLabel, backgroundColor: COLOR_CLEAR, textColor: COLOR_WHITE, textFont: FONT_LABEL_SUB_HEADING(size: FONT_32))
        setAppearanceFor(view: monthAndYearLabel, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_LABEL_SUB_HEADING(size: FONT_16))
    }
    
    
    override func draw(_ rect: CGRect)
    {
        super.draw(rect)
        // photosGrid.register(MyPlacePhotosListCVCell.self, forCellWithReuseIdentifier: cellID)
        topViewHeightConstraint.constant = topViewHeight
        photosGrid.dataSource = self
        photosGrid.delegate = self
        
        
    }
    override func prepareForReuse()
    {
        super.prepareForReuse()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return selectedJobNumberRegion == .OLD ? photosArray.count : photoListForQLDSA.count //photosArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MyPlacePhotosListCVCell
        cell.backgroundColor = .white
        cell.photoImageView.tag = indexPath.row
        cell.tag = indexPath.row
        cell.photoImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlePhotoTapped)))
        
        cell.photoImageView.image = UIImage(named: "defaultGallery.png")
        cell.photoImageView.contentMode = .scaleToFill
        

        cell.layer.cornerRadius = 8
        
        cell.layer.masksToBounds = true

        
        func fillCellForVLC()
        {
            if let imagePath = photosArray[indexPath.row].imagePath
            {
                let trimmedImagePath = imagePath.trimmingCharacters(in: NSCharacterSet.whitespaces)
                cell.photoImageView.loadImageUsingCacheUrlString(urlString: trimmedImagePath)//"http://192.168.100.138:8083/files/00000000000000010155/ffa63e153d87491297b35e1333a60432.JPG"
            }
        }
        func fillCellForQLDSA()
        {
            let photoInfo = photoListForQLDSA[indexPath.row]
            CodeManager.sharedInstance.downloadandShowImage(photoInfo,cell.photoImageView)
        }
        selectedJobNumberRegion == .OLD ? fillCellForVLC() : fillCellForQLDSA()
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let division = photoListForQLDSA.count/numOfPhotosToDisplay + (photoListForQLDSA.count % numOfPhotosToDisplay == 0 ? 0 : 1)
        var heightForQLDSA : CGFloat {
//            if division == 1 {
                return (collectionView.frame.size.height - 0) /  CGFloat(max(1,division)) /// 2
//            }else {
//                return (collectionView.frame.size.height - 10) /  CGFloat(max(1,division)) /// 2
//            }
        }
        let height = selectedJobNumberRegion == .OLD ? collectionView.frame.size.height/2 : heightForQLDSA
        let width = (collectionView.frame.size.width - spacing*CGFloat(numOfPhotosToDisplay-1)) / CGFloat(numOfPhotosToDisplay)

        if division == 1 {
            return CGSize(width: width, height: height-5)
        }
        return CGSize(width: width, height: height-8)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return CGFloat(spacing)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        
//        return CGFloat(spacing)
//    }
    
    @objc func handlePhotoTapped(gesture: UITapGestureRecognizer)
    {
        let gestureView = gesture.view
        if let selectedImgViewTag = gestureView?.tag
        {
            if let collectionView = gestureView?.superview?.superview?.superview?.superview
            {
                selectedJobNumberRegion == .OLD ? delegate?.myPlacePhotoTapped(index: selectedImgViewTag) : delegate?.photoTappedForQLDSA(selectedImgViewTag,collectionView.tag)
                //delegate?.myPlacePhotoTapped(index: selectedImgViewTag)
            }
            
        }
        
    }
    
}

class MyPlacePhotosListCVCell : UICollectionViewCell
{
    @IBOutlet weak var photoImageView: UIImageView!
    override func draw(_ rect: CGRect)
    {
        super.draw(rect)
        
    }
    override func prepareForReuse()
    {
        super.prepareForReuse()
    }
}
