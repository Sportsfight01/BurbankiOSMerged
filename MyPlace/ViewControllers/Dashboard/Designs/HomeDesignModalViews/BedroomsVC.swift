//
//  BedroomsVC.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 15/07/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit

class BedroomsVC: HomeDesignModalHeaderVC {
    
    //    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var bedrooms_lBbedrooms: UILabel!
    
    
    @IBOutlet weak var bedrooms_CollectionView: UICollectionView!
    
    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionViewWidth: NSLayoutConstraint!
    
    
    var selectedIndex = -1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        bedroomViewSetUp ()
        
        selectionAlertMessage = "Please select bedrooms"

    }
    
    
    func bedroomViewSetUp () {
        
        setAppearanceFor(view: bedrooms_lBbedrooms, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_LABEL_BODY (size: FONT_19))
        
    }
    
    
    //MARK: - View Updates
    
    override func reloadView () {
        
        collectionViewHeight.constant = 115
        bedrooms_CollectionView.layoutIfNeeded()
        
        bedrooms_lBbedrooms.layoutIfNeeded()
        
//        bedrooms_CollectionView.reloadData()
//        bedrooms_CollectionView.layoutIfNeeded()
//
//        bedrooms_lBbedrooms.layoutIfNeeded()
//        bedrooms_CollectionView.layoutIfNeeded()
        
        
        if let option = self.homeDesignFeature?.answerOptions {
            
            if option.count > 2 {
                
                collectionViewWidth.constant = contentView.frame.size.width - 20
            }else {
                
                collectionViewWidth.constant = CGFloat (option.count) * (contentView.frame.size.width - 20 - CGFloat(option.count-1)*15)/3
            }
            
            bedrooms_CollectionView.layoutIfNeeded()

        }
        
        
        bedrooms_lBbedrooms.layoutIfNeeded()
        
        let maxHeight = view.frame.size.height // - 40 - 10
        
        let yPos = bedrooms_CollectionView.frame.origin.y // 0 + bedrooms_lBbedrooms.frame.origin.y + bedrooms_lBbedrooms.frame.size.height + 30 //70
        
        if (yPos + bedrooms_CollectionView.contentSize.height + 0) > maxHeight {
            collectionViewHeight.constant = maxHeight - yPos
        }else {
            collectionViewHeight.constant = bedrooms_CollectionView.contentSize.height
        }
        
        bedrooms_CollectionView.updateConstraints()
        
        print(log: "bedrooms collectionViewWidth \(collectionViewWidth.constant)")
        print(log: "bedrooms collectionViewHeight \(collectionViewHeight.constant)")

        
    }
    
    
    
    //MARK: - Clear
    
    override func clearSelections () {
        super.clearSelections()
        
        selectedIndex = -1
        bedroomViewSetUp()
    }
    
    
    
}


//MARK: - CollectionView Delegate

extension BedroomsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BedRoomCell", for: indexPath) as! BedRoomCell
        
        cell.bedroomCount = ""
        
        
        cell.bedroomCount = self.homeDesignFeature?.answerOptions[indexPath.row].displayAnswer
        
        cell.selectedBedroom = false
        cell.selectedBedroom = self.homeDesignFeature?.selectedAnswer == cell.bedroomCount
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (contentView.frame.size.width - 30 - 30)/3
        
        return CGSize (width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if  homeDesignFeature?.answerOptions[indexPath.row].displayAnswer ?? "" == "NOT SURE"{
            print("Not sure")
            homeDesignFeature?.selectedAnswer = homeDesignFeature?.answerOptions[indexPath.row].displayAnswer ?? ""
            
            homeDesignFeature?.displayString = (homeDesignFeature?.selectedAnswer)!

        }else{
            homeDesignFeature?.selectedAnswer = homeDesignFeature?.answerOptions[indexPath.row].displayAnswer ?? ""
            
            homeDesignFeature?.displayString = (homeDesignFeature?.selectedAnswer)! + " Bed"

        }
       
        if selectedIndex != -1 {
            if selectedIndex == indexPath.row {
                collectionView.reloadItems(at: [indexPath])
            }else {
                collectionView.reloadItems(at: [indexPath, IndexPath (row: selectedIndex, section: 0)])
            }
        }else {
            collectionView.reloadItems(at: [indexPath])
        }
                
        selectedIndex = indexPath.row
        
        if let selection = selectionUpdates {
            selection (self)
        }
        
    }
    
}



class BedRoomCell: UICollectionViewCell {
    
    
    @IBOutlet weak var buttonBedroom: UIButton!
    
    
    var bedroomCount: String? {
        didSet {
            fillDetails()
        }
    }
    
    var selectedBedroom: Bool? {
        didSet {
            fillDetails()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        buttonBedroom.superview?.frame = self.contentView.bounds
        
        buttonBedroom.superview?.layer.cornerRadius = radius_5
    }
    
    
    
    func fillDetails () {
        
        if selectedBedroom == true {
            
            if bedroomCount == "NOT SURE"{
                _ = setAttributetitleFor(view: buttonBedroom, title: "?\nNOT SURE", rangeStrings: ["?", "NOT SURE"], colors: [COLOR_WHITE, COLOR_WHITE], fonts: [FONT_LABEL_BODY(size: FONT_22), FONT_LABEL_SUB_HEADING(size: FONT_9)], alignmentCenter: true)
                
                buttonBedroom.superview?.backgroundColor = COLOR_ORANGE
            }else{
            _ = setAttributetitleFor(view: buttonBedroom, title: "\(bedroomCount!)\nBEDROOMS", rangeStrings: [bedroomCount!, "BEDROOMS"], colors: [COLOR_WHITE, COLOR_WHITE], fonts: [FONT_LABEL_BODY(size: FONT_22), FONT_LABEL_SUB_HEADING(size: FONT_9)], alignmentCenter: true)
            
                buttonBedroom.superview?.backgroundColor = APPCOLORS_3.EnabledOrange_BG
            }
        }else {
            if bedroomCount == "NOT SURE"{
                _ = setAttributetitleFor(view: buttonBedroom, title: "?\nNOT SURE", rangeStrings: ["?", "NOT SURE"], colors: [APPCOLORS_3.GreyTextFont, APPCOLORS_3.GreyTextFont], fonts: [FONT_LABEL_BODY(size: FONT_22), FONT_LABEL_SUB_HEADING(size: FONT_9)], alignmentCenter: true)
                
                buttonBedroom.superview?.backgroundColor = COLOR_WHITE
            }else{
            _ = setAttributetitleFor(view: buttonBedroom, title: "\(bedroomCount!)\nBEDROOMS", rangeStrings: [bedroomCount!, "BEDROOMS"], colors: [APPCOLORS_3.GreyTextFont, APPCOLORS_3.GreyTextFont], fonts: [FONT_LABEL_BODY(size: FONT_22), FONT_LABEL_SUB_HEADING(size: FONT_9)], alignmentCenter: true)
            
            buttonBedroom.superview?.backgroundColor = COLOR_WHITE
            }
        }
        
    }
    
}
