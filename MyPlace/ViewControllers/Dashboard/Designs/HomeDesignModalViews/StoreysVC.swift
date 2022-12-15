//
//  StoreysVC.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 15/07/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit

class StoreysVC: HomeDesignModalHeaderVC {
        
    
    @IBOutlet weak var storeys_lBstoreys: UILabel!
    
    
        
    @IBOutlet weak var storeys_CollectionView: UICollectionView!
    
    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var collectionViewWidth: NSLayoutConstraint!
    
    var selectedIndex = -1

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        storeysViewSetUp ()
        
        selectionAlertMessage = "Please select storeys"
    }
    
    
    
    func storeysViewSetUp () {
        
        setAppearanceFor(view: storeys_lBstoreys, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_LABEL_BODY (size: FONT_19))
                
    }
    
    
    //MARK: - Fill Selections
    
    func fillSelections () {
        
        storeysViewSetUp ()
                
    }
    
    //MARK: - View Updates
    
    
    override func reloadView () {
        
        collectionViewHeight.constant = 115
        storeys_CollectionView.layoutIfNeeded()
        
        storeys_lBstoreys.layoutIfNeeded()
                
        
        if let option = self.homeDesignFeature?.answerOptions {
            
            if option.count > 2 {
                
                collectionViewWidth.constant = contentView.frame.size.width - 20
            }else {
                
                collectionViewWidth.constant = CGFloat (option.count) * ((contentView.frame.size.width - 20 - CGFloat(option.count-1)*15))/3
            }
            
            storeys_CollectionView.reloadData()
            storeys_CollectionView.layoutIfNeeded()
        }
        
        
        storeys_lBstoreys.layoutIfNeeded()
        
        let maxHeight = view.frame.size.height // - 40 - 10
        
        let yPos = storeys_CollectionView.frame.origin.y // 0 + bedrooms_lBbedrooms.frame.origin.y + bedrooms_lBbedrooms.frame.size.height + 30 //70
        
        if (yPos + storeys_CollectionView.contentSize.height + 0) > maxHeight {
            collectionViewHeight.constant = maxHeight - yPos
        }else {
            collectionViewHeight.constant = storeys_CollectionView.contentSize.height
        }
        
//        storeys_CollectionView.updateConstraints()
        
        print(log: "Story collectionViewWidth \(collectionViewWidth.constant)")
        print(log: "Story collectionViewHeight \(collectionViewHeight.constant)")

        
    }
    
    
    //MARK: - Clear
    
    override func clearSelections () {
        super.clearSelections()
        
        selectedIndex = -1
        self.storeys_CollectionView.reloadData()
    }
    
    
    
    //MARK: - Actions
        
}



//MARK: - CollectionView Delegate

extension StoreysVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let optionss = self.homeDesignFeature?.answerOptions {
            return optionss.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreysCell", for: indexPath) as! StoreysCell
        
        cell.storey = self.homeDesignFeature?.answerOptions[indexPath.row].displayAnswer
        cell.selectedStorey = false
        cell.selectedStorey = self.homeDesignFeature?.selectedAnswer == self.homeDesignFeature?.answerOptions[indexPath.row].answerText
        
//        CoreImage.clear
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (contentView.frame.size.width - 30 - 30)/3
        print(log: " collectionView cell width \(width)")
        return CGSize (width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        homeDesignFeature?.selectedAnswer = homeDesignFeature?.answerOptions[indexPath.row].answerText ?? ""
            
        if homeDesignFeature?.selectedAnswer == "1" {
            homeDesignFeature?.displayString = "Single"
        }else if homeDesignFeature?.selectedAnswer == "2" {
            homeDesignFeature?.displayString = "Double"
        }else if homeDesignFeature?.selectedAnswer == "3" {
           homeDesignFeature?.displayString = "Triple"
        }else {
            homeDesignFeature?.displayString = "All"
        }
                
//        if selectedIndex != -1 {
//            if indexPath.row == selectedIndex {
//                collectionView.reloadItems(at: [indexPath])
//            }else {
//                collectionView.reloadItems(at: [indexPath, IndexPath (row: selectedIndex, section: 0)])
//            }
//        }else {
//            collectionView.reloadItems(at: [indexPath])
//        }
        
        collectionView.reloadData()
        
        selectedIndex = indexPath.row

        if let selection = selectionUpdates {
            selection (self)
        }
    }
    
}


class StoreysCell: UICollectionViewCell {
    
    
    @IBOutlet weak var labelStorey: UILabel!
    @IBOutlet weak var iconStorey: UIImageView!

    
    var storey: String? {
        didSet {
            //            fillDetails()
        }
    }
    
    var selectedStorey: Bool? {
        didSet {
            fillDetails()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        labelStorey.superview?.frame = self.contentView.bounds

        labelStorey.superview?.layer.cornerRadius = radius_5
        labelStorey.font = FONT_LABEL_SUB_HEADING(size: FONT_9)
    }
    
    
    
    func fillDetails () {

        if (storey?.lowercased().contains("1") ?? false) == true {
            iconStorey.image = UIImage(named: selectedStorey == false ? "Ico-Single" : "Ico-SingeWhite")
            labelStorey.text = "SINGLE".capitalized
        }else if (storey?.lowercased().contains("2") ?? false) == true {
            iconStorey.image = UIImage(named: selectedStorey == false ? "Ico-Double" : "Ico-DoubleWhite")
            labelStorey.text = "DOUBLE".capitalized
        }else if (storey?.lowercased().contains("3") ?? false) == true {
            iconStorey.image = UIImage(named: selectedStorey == false ? "Ico-TrippleStory" : "Ico-TripplestoryWhite")
            labelStorey.text = "TRIPLE".capitalized
        }else {
            iconStorey.image = UIImage(named: selectedStorey == false ? "Ico-Question" : "Ico-FaqWhite")
            labelStorey.text = "NOT SURE".capitalized
        }
        
        if selectedStorey == true {
            
            labelStorey.textColor = COLOR_WHITE
            labelStorey.superview?.backgroundColor = COLOR_ORANGE
        }else {
            
            labelStorey.textColor = COLOR_ORANGE
            labelStorey.superview?.backgroundColor = COLOR_WHITE
        }
        
    }
    
}
