//
//  LogIssueVC.swift
//  BurbankApp
//
//  Created by Naresh Banavath on 31/05/23.
//  Copyright © 2023 Sreekanth tadi. All rights reserved.
//

import UIKit
import PhotosUI

class LogIssueVC: UIViewController {
    
    @IBOutlet weak var logIssueBTN: UIButton!
    @IBOutlet weak var saveEditBTN: UIButton!
    @IBOutlet weak var deleteBTN: UIButton!
    @IBOutlet weak var cancelBTN: UIButton!
    
    
    //MARK: - Properties
    @IBOutlet weak var addImagesView: UIView!
    @IBOutlet weak var TopFlagView: UIView!
    
    var isEditIssueScreen = false
    
    @IBOutlet weak var imagesPickerColectionView: ImagePickerCollectionView!
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 14.0, *) {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addPhotosClicker))
            addImagesView.addGestureRecognizer(tapGesture)
        } else {
            // Fallback on earlier versions
        }
        setUpUI()
       
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TopFlagView.addBorder()
        self.setupNavigationBarButtons()
    }
    
    //MARK: - Helper Methods
    
    @objc func addPhotosClicker()
    {
        imagesPickerColectionView.maxPhotosCount = 6 // max 6 can be selecteed
        imagesPickerColectionView.showOptions()
        imagesPickerColectionView.imagesSelectionClosure = { [weak self] photosCount in
            self?.imagesPickerColectionView.isHidden = photosCount > 0 ? false : true
            UIView.animate(withDuration: 0.250, delay: 0) {
                self?.view.layoutIfNeeded()
            }
        }
        
    }
    

    func setUpUI(){
        imagesPickerColectionView.isHidden = true
        if isEditIssueScreen{
            [logIssueBTN].forEach({$0?.isHidden = true})
        }else{
            [saveEditBTN,deleteBTN,cancelBTN].forEach({$0?.isHidden = true})
        }
    }
    
    @IBAction func didTappedOnIssues(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            print("log issues")
        case 1:
            print("log issues")
           
        case 2:
            print("save & edit issues")

        case 3:
            print("Delete issues")
            
        case 4:
            print("Cancel")
        default:
            print("log issues")
        }
    }
    
    
}
