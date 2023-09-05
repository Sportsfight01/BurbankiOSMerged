//
//  LogIssueVC.swift
//  BurbankApp
//
//  Created by Naresh Banavath on 31/05/23.
//  Copyright © 2023 Sreekanth tadi. All rights reserved.
//

import UIKit
import PhotosUI
import GrowingTextView

class LogIssueVC: UIViewController {
    
    //MARK: - Properties
    
    @IBOutlet weak var titleOfIssueTF: UITextField!
    @IBOutlet weak var roomInHouseTF : UITextField!
    @IBOutlet weak var detailsTF     : GrowingTextView!
    
    
    
    @IBOutlet weak var logIssueBTN: UIButton!
    @IBOutlet weak var saveEditBTN: UIButton!
    @IBOutlet weak var deleteBTN: UIButton!
    @IBOutlet weak var cancelBTN: UIButton!
    @IBOutlet weak var newIssueLBL: UILabel!
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
//        TopFlagView.addBorder(color: APPCOLORS_3.LightGreyDisabled_BG)
        self.setupNavigationBarButtons()
    }
    
    //MARK: - Helper Methods
    
    @objc func addPhotosClicker()
    {
        imagesPickerColectionView.maxPhotosCount = 6 // max 6 can be selecteed
        imagesPickerColectionView.showOptions()
//        imagesPickerColectionView.imagesSelectionClosure = { [weak self] photosCount in
//            self?.imagesPickerColectionView.isHidden = photosCount > 0 ? false : true
//            UIView.animate(withDuration: 0.250, delay: 0) {
//                self?.view.layoutIfNeeded()
//            }
//        }
        
    }
    

    func setUpUI(){
        if isEditIssueScreen{
            [logIssueBTN].forEach({$0?.isHidden = true})
            self.newIssueLBL.text = "EDIT ISSUE"
            titleOfIssueTF.text = "Hall"
            roomInHouseTF.text  = "3"
            detailsTF.text      = "Can’t stop the tap from dripping in the master bedroom, Has been running for a few days now and wasting alot of water. Concerned about water bills and flooding if something else goes wrong."
            
        }else{
            [saveEditBTN,deleteBTN,cancelBTN].forEach({$0?.isHidden = true})
            titleOfIssueTF.text = ""
            roomInHouseTF.text  = ""
            detailsTF.text      = ""
        }
    }
    
    @IBAction func didTappedOnIssues(_ sender: UIButton) {
        
        switch sender.tag {
        case 1:
            print("log issues")
            let vc = LoggedissuesVC.instace(sb: .reports)
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            print("save & edit issues")
            self.navigationController?.popViewController(animated: true)
        case 3:
            print("Delete issues")
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: LoggedissuesVC.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
            
//            self.navigationController?.popToViewController(<#T##UIViewController#>, animated: <#T##Bool#>)
        case 4:
            print("Cancel")
            self.navigationController?.popViewController(animated: true)
        default:
            print("log issues")
        }
    }
    
    
}
