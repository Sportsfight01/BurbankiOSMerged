//
//  H&LQuiz.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 26/08/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit

class H_LQuiz: HeaderVC, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {

    @IBOutlet weak var mainView : UIView!
    @IBOutlet weak var mainCollectionView : UICollectionView!
    
    
    @IBOutlet weak var btnDesignsCount: UIButton!
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnPrevious: UIButton!
    
    @IBOutlet weak var viewRecentSearch: UIView!
    
    
    var index: CGFloat = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
                
        headerLogoText = "MyHome&Land"
                
        if btnBack.isHidden {
            showBackButton()
            //            hideBackButton()
            btnBack.addTarget(self, action: #selector(handleBackButton(_:)), for: .touchUpInside)
            btnBackFull.addTarget(self, action: #selector(handleBackButton(_:)), for: .touchUpInside)
        }
        
        addHeaderOptions(sort: false, map: false, favourites: false, howWorks: false, delegate: nil)

    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.mainCollectionView.contentSize = CGSize (width: index*mainCollectionView.frame.size.width, height: mainCollectionView.frame.size.height)

    }
    
    
    
    
    
    
    //MARK: - Actions
    
    @IBAction func handleBackButton (_ sender: UIButton) {

        self.navigationController?.popViewController(animated: true)
        
    }
    
        
    @IBAction func handlePreviousNextButtonActions (_ sender: UIButton) {
    
        if sender == btnNext {
            if index > 3 { }
            else {
                index = index + 1
                self.mainCollectionView.reloadData()
                self.mainCollectionView.contentSize = CGSize (width: index*mainCollectionView.frame.size.width, height: mainCollectionView.frame.size.height)
                
                self.mainCollectionView.scrollToItem(at: IndexPath (row: Int(index), section: 0), at: .right, animated: true)
            }
        }else {
            if index > 0 {
                index = index - 1
                self.mainCollectionView.reloadData()
                self.mainCollectionView.contentSize = CGSize (width: index*mainCollectionView.frame.size.width, height: mainCollectionView.frame.size.height)
                
                self.mainCollectionView.scrollToItem(at: IndexPath (row: Int(index), section: 0), at: .left, animated: true)
                
            } else { }
            
        }
    }
    
    
    
    
    //MARK: - CollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(index) + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        print(log: collectionView.contentSize)

    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        print(log: collectionView.contentSize)
        
        var cell: UICollectionViewCell?
        
        
        if indexPath.row == 0 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "H_LRegionsCVCell", for: indexPath) as! H_LRegionsCVCell
            
        }else if indexPath.row == 1 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "H_LStoreysCVCell", for: indexPath) as! H_LStoreysCVCell
            
            
        }else if indexPath.row == 2 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "H_LBedroomsCVCell", for: indexPath) as! H_LBedroomsCVCell
            
        }else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "H_LPriceCVCell", for: indexPath) as! H_LPriceCVCell
            
        }
        
        cell?.frame.size.width = collectionView.frame.size.width
        
        
        cell?.layoutSubviews()
        cell!.layoutIfNeeded()
        for vi in cell!.subviews {
            vi.updateConstraints()
        }
        
        cell!.updateConstraints()
        
        // print(log: cell?.frame.size.width as Any)
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print(log: collectionView.frame.size.width)
        return CGSize (width: collectionView.frame.size.width-0, height: collectionView.frame.size.height)
    }
            
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
    
    
}
