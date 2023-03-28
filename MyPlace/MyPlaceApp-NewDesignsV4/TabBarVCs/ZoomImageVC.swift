//
//  ZoomImageVC.swift
//  BurbankApp
//
//  Created by naresh banavath on 30/11/21.
//  Copyright © 2021 DMSS. All rights reserved.
//

import UIKit
import SDWebImage

class ZoomImageVC: UIViewController {
    
    @IBOutlet weak var titleLb: UILabel!
    //var imgData : DocumentsDetailsStruct!
    @IBOutlet weak var imgView : UIImageView!
    var docDate : String?
    var imageURlsArray : [String] = []
    var currentPhotoIndex : Int = 0
    var imageData : UIImage?
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture))
        rightSwipeGesture.direction = .right
        self.imgView.superview?.addGestureRecognizer(rightSwipeGesture)
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture))
        leftSwipeGesture.direction = .left
        self.imgView.superview?.addGestureRecognizer(leftSwipeGesture)
        
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
    
    //MARK: - Helper Methods
    @objc func swipeGesture(_ gesture : UISwipeGestureRecognizer)
    {
        print(gesture.direction)
        switch gesture.direction
        {
        case .left:
            currentPhotoIndex += 1
        case .right:
            currentPhotoIndex -= 1
        default:
            debugPrint("other direction")
        }
        handleImageSwipe()
        
    }
    
    func handleImageSwipe()
    {
        guard 0..<imageURlsArray.count ~= currentPhotoIndex else {return}
        self.imgView.backgroundColor = .lightGray.withAlphaComponent(0.5)
        let imgURL = URL(string:"\(clickHomeBaseImageURL)/\(imageURlsArray[currentPhotoIndex] )")
        self.imgView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        //  cell.imView.sd_setImage(with: imgURL)
        self.imgView.sd_setImage(with: imgURL, placeholderImage: nil) { _, _, _, _ in
            self.imgView.backgroundColor = .white
        }
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        dismiss(animated: true)
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
