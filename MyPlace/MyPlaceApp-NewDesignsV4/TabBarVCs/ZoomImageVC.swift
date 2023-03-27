//
//  ZoomImageVC.swift
//  BurbankApp
//
//  Created by naresh banavath on 30/11/21.
//  Copyright © 2021 DMSS. All rights reserved.
//

import UIKit

class ZoomImageVC: UIViewController {
    
    @IBOutlet weak var titleLb: UILabel!
    //var imgData : DocumentsDetailsStruct!
    @IBOutlet weak var imgView : UIImageView!
    var docDate : String?
    var imageURlsArray : [PhotoItem]?
    var imageData : UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // CodeManager.sharedInstance.downloadandShowImageForNewFlow(imgData,imgView)
        // Do any additional setup after loading the view.
//        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture))
//        self.view.addGestureRecognizer(swipeGesture)
        
    }
    @objc func swipeGesture(_ gesture : UISwipeGestureRecognizer)
    {
        if gesture.direction == .left
        {
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        //CodeManager.sharedInstance.downloadandShowImageForNewFlow(imgData,imgView)
        titleLb.text = docDate
        imgView.image = imageData
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
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
