//
//  ZoomImageVC.swift
//  BurbankApp
//
//  Created by naresh banavath on 30/11/21.
//  Copyright © 2021 DMSS. All rights reserved.
//

import UIKit
import SDWebImage

class ZoomImageVC: UIViewController,imageSliderDelegate {
    
    
    
    @IBOutlet weak var titleLb: UILabel!
    //var imgData : DocumentsDetailsStruct!
    @IBOutlet weak var imgView : UIImageView!
    var docDate : String?
    var collectionDatasource : [PhotoItem]!
    
    var imageURlsArray : [String] = []
    var currentPhotoIndex : Int = 0
    var imageData : UIImage?
    
    var collectionOfPhotoItemArr : [DocumentsDetailsStruct]!
    @IBOutlet weak var imageSlider: CLabsImageSlider!
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
       
        imageSlider.clipsToBounds = true
        imageSlider.layer.cornerRadius = 5
        imageSlider.sliderDelegate = self
        let swipeleft = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeleft(_:)))
        swipeleft.direction = .left
        imageSlider?.addGestureRecognizer(swipeleft)
        
        let swiperight = UISwipeGestureRecognizer(target: self, action: #selector(self.swiperight(_:)))
        swiperight.direction = .right
        imageSlider?.addGestureRecognizer(swiperight)

        collectionOfPhotoItemArr  = collectionDatasource.compactMap({$0.rowData}).flatMap({$0})
        
        imageURlsArray = collectionDatasource.compactMap({$0.rowData}).flatMap({$0}).map({"\(clickHomeBaseImageURL)/\($0.url ?? "")"})
        loadTitleName(index: currentPhotoIndex)
        
//        self.imageSlider.currentIndex = currentPhotoIndex
        self.imageSlider?.setUpView(imageSource: .Url(imageArray: imageURlsArray, placeHolderImage: UIImage(named: "placeholder")),slideType: .ManualSwipe,isArrowBtnEnabled: true, contentMode: "SC")
    }
    
    
    func loadTitleName(index : Int){
        let date = dateFormatter(dateStr: collectionOfPhotoItemArr[index].docdate ?? "", currentFormate: "yyyy-MM-dd'T'HH:mm:ss.SSS", requiredFormate: "EEEE, dd/MM/yy")
        titleLb.text = "\(collectionOfPhotoItemArr[index].title ?? "") , \(date ?? "")"
       
        
    }
    
    
    @objc func swipeleft(_ gestureRecognizer: UISwipeGestureRecognizer) {
            imageSlider?.swipeRight(swipeGesture: gestureRecognizer)
    }
    @objc func swiperight(_ gestureRecognizer: UISwipeGestureRecognizer)
    {
            imageSlider?.swipeLeft(swipeGesture: gestureRecognizer)
    }
    func didMovedToIndex(index: Int) {
        print(index)
        
        loadTitleName(index: index)
//        let date = dateFormatter(dateStr: collectionOfPhotoItemArr[index].docdate ?? "", currentFormate: "yyyy-MM-dd'T'HH:mm:ss.SSS", requiredFormate: "EEEE, dd/MM/yy")
//        titleLb.text = "\(collectionOfPhotoItemArr[index].title ?? "") , \(date ?? "")"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        titleLb.text = docDate
        imgView.image = imageData
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }


    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func shareBtnTapped(_ sender: UIButton) {
        // shareImage()
    }
    func shareImage() {
        
        // image to share
        let image = imgView.image
        
        // set up activity view controller
        let imageToShare = [ image! ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
}
