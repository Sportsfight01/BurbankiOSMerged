//
//  LotVC.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 14/07/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit



class LotVC: HomeDesignModalHeaderVC {
    
    
    //    @IBOutlet weak var contentView: UIView!
    
    
    @IBOutlet weak var lot_lBLot: UILabel!
    @IBOutlet weak var lot_CollectionView: UICollectionView!
    
    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var collectionViewWidth: NSLayoutConstraint!
    
    
    var selectedIndex = -1

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        lotViewSetUp ()
        
        selectionAlertMessage = "Please select lot width"
        
    }
    
    
    
    func lotViewSetUp () {
        
        setAppearanceFor(view: lot_lBLot, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_BODY (size: FONT_19))
    }
    
    
    //MARK: - View Updates
    
    override func reloadView () {

//        let width = (contentView.frame.size.width - 30 - 30)/3

        collectionViewHeight.constant = 115
        
        lot_CollectionView.reloadData()
        lot_CollectionView.layoutIfNeeded()
        
        lot_lBLot.layoutIfNeeded()
        
        lot_CollectionView.reloadData()
        lot_CollectionView.layoutIfNeeded()
        
        //        bedrooms_lBbedrooms.layoutIfNeeded()
        //        bedrooms_CollectionView.layoutIfNeeded()
        
        
        if let option = self.homeDesignFeature?.answerOptions {
            
            if option.count > 2 {
                
                collectionViewWidth.constant = contentView.frame.size.width - 20
            }else {
                
                collectionViewWidth.constant = CGFloat (option.count) * (contentView.frame.size.width - 20 - CGFloat(option.count-1)*15)/3
            }
            
            lot_CollectionView.reloadData()
            lot_CollectionView.layoutIfNeeded()
        }
//
        
        lot_lBLot.layoutIfNeeded()
        
        let maxHeight = view.frame.size.height //- 40 - 10
        
        let yPos = lot_CollectionView.frame.origin.y // 0 + lot_lBLot.frame.origin.y + lot_lBLot.frame.size.height + 30 //70

        if (yPos + lot_CollectionView.contentSize.height + 0) > maxHeight {
            collectionViewHeight.constant = maxHeight - yPos
        }else {
            collectionViewHeight.constant = lot_CollectionView.contentSize.height
        }
        
        lot_CollectionView.updateConstraints()
        
        print(log: "lot collectionViewWidth \(collectionViewWidth.constant)")
        print(log: "lot collectionViewHeight \(collectionViewHeight.constant)")
        
        
    }
    
    
    
    //MARK: - Clear
    
    override func clearSelections () {
        super.clearSelections()
        
        selectedIndex = -1
        self.lot_CollectionView.reloadData()
    }
    
    
}


//MARK: - CollectionView Delegate

extension LotVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LotCell", for: indexPath) as! LotCell
        
        cell.lotWidth = self.homeDesignFeature?.answerOptions[indexPath.row].displayAnswer
        
        
        cell.selectedLot = false
        cell.selectedLot = self.homeDesignFeature?.selectedAnswer == self.homeDesignFeature?.answerOptions[indexPath.row].answerText
        
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
        if homeDesignFeature?.answerOptions[indexPath.row].answerText ?? "" == "NOT SURE"{
            homeDesignFeature?.selectedAnswer = homeDesignFeature?.answerOptions[indexPath.row].answerText ?? ""
            homeDesignFeature?.displayString = homeDesignFeature?.answerOptions[indexPath.row].answerText ?? ""
        }else{
            homeDesignFeature?.selectedAnswer = homeDesignFeature?.answerOptions[indexPath.row].answerText ?? ""
            homeDesignFeature?.displayString = homeDesignFeature?.answerOptions[indexPath.row].addM() ?? "0"
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


class LotCell: UICollectionViewCell {
    
    
    @IBOutlet weak var buttonLot: UIButton!
    
    
    var lotWidth: String? {
        didSet {
            //            fillDetails()
        }
    }
    
    var selectedLot: Bool? {
        didSet {
            fillDetails()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        buttonLot.superview?.layer.cornerRadius = radius_5
        
    }
    
    
    
    func fillDetails () {
        
        if selectedLot == true {
            if lotWidth! == "NOT SURE"{
                _ = setAttributetitleFor(view: buttonLot, title: "?\nI Don’t Have \nLand Yet", rangeStrings: ["?", "I Don’t Have \nLand Yet"], colors: [COLOR_DARK_GRAY, COLOR_WHITE], fonts: [FONT_LABEL_BODY(size: FONT_22), FONT_LABEL_SUB_HEADING(size: FONT_9)], alignmentCenter: true)
                buttonLot.superview?.backgroundColor = COLOR_ORANGE
            }else{
            _ = setAttributetitleFor(view: buttonLot, title: "\(lotWidth!)\nMETRES", rangeStrings: [lotWidth!, "METRES"], colors: [COLOR_DARK_GRAY, COLOR_WHITE], fonts: [FONT_LABEL_BODY(size: FONT_22), FONT_LABEL_SUB_HEADING(size: FONT_9)], alignmentCenter: true)
            
            buttonLot.superview?.backgroundColor = COLOR_ORANGE
            }
        }else {
            if lotWidth! == "NOT SURE"{
                _ = setAttributetitleFor(view: buttonLot, title: "?\nI Don’t Have \nLand Yet", rangeStrings: ["?", "I Don’t Have \nLand Yet"], colors: [COLOR_DARK_GRAY, COLOR_ORANGE], fonts: [FONT_LABEL_BODY(size: FONT_22), FONT_LABEL_SUB_HEADING(size: FONT_9)], alignmentCenter: true)
                
                buttonLot.superview?.backgroundColor = COLOR_WHITE
            }else{
            _ = setAttributetitleFor(view: buttonLot, title: "\(lotWidth!)\nMETRES", rangeStrings: [lotWidth!, "METRES"], colors: [COLOR_DARK_GRAY, COLOR_ORANGE], fonts: [FONT_LABEL_BODY(size: FONT_22), FONT_LABEL_SUB_HEADING(size: FONT_9)], alignmentCenter: true)
            
            buttonLot.superview?.backgroundColor = COLOR_WHITE
        }
        }
    }
    
}
