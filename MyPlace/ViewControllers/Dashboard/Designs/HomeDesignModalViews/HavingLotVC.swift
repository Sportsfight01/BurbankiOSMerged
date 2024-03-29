//
//  HavingLotVC.swift
//  BurbankApp
//
//  Created by Naveen Kourampalli on 20/10/21.
//  Copyright © 2021 Sreekanth tadi. All rights reserved.
//

import UIKit

class HavingLotVC: HomeDesignModalHeaderVC,UITextFieldDelegate {

    @IBOutlet weak var lotHeaderLBL: UILabel!
    @IBOutlet weak var iHaveLandBTN: UIButton!
    @IBOutlet weak var iHaveLandCard: UIView!
    @IBOutlet weak var iDontHaveBTN: UIButton!
    @IBOutlet weak var iDintHaveLandIMG: UIImageView!
    @IBOutlet weak var iDontHaveLandCard: UIView!
    @IBOutlet weak var iHaveLandIMG: UIImageView!
    @IBOutlet weak var iDontHaveLandLBL: UILabel!
    @IBOutlet weak var iHaveLandLBL: UILabel!
    @IBOutlet weak var enterLotCard: UIView!
    @IBOutlet weak var lotTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lotViewSetUp ()
        
       // NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear1), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    NotificationCenter.default.addObserver(self, selector: #selector(nextFeatureResponse(_:)), name: NSNotification.Name("NewHomesNextFeatureResponse"), object: nil)
  }
    func lotViewSetUp () {
        
        setAppearanceFor(view: lotHeaderLBL, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_BODY (size: FONT_19))
       // setAppearanceFor(view: lotHeaderLBL, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_BODY (size: FONT_19))
        
        iDintHaveLandIMG.image = UIImage(named: "Ico-Question")
        iHaveLandIMG.image = UIImage(named: "Ico-Rite")
        iHaveLandIMG.tintColor = APPCOLORS_3.GreyTextFont

        
        setAppearanceFor(view: iDontHaveLandLBL, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_SUB_HEADING(size: FONT_9))
        setAppearanceFor(view: iHaveLandLBL, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_SUB_HEADING(size: FONT_9))
        
        setAppearanceFor(view: lotTF, backgroundColor: .white, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_BODY(size: FONT_14))
      
        
        iDontHaveBTN.superview?.layer.cornerRadius = radius_5
        iHaveLandBTN.superview?.layer.cornerRadius = radius_5
        enterLotCard.layer.cornerRadius = radius_5
        iDontHaveLandLBL.text = "I Don't Have \nLand Yet".uppercased()
        enterLotCard.isHidden = true
        
        setAppearanceFor(view: iDontHaveBTN.superview!, backgroundColor: APPCOLORS_3.HeaderFooter_white_BG)
        setAppearanceFor(view: iHaveLandBTN.superview!, backgroundColor: APPCOLORS_3.HeaderFooter_white_BG)
        lotTF.delegate = self
        lotTF.keyboardType = .decimalPad
        selectionAlertMessage = "Please select one option"
    }

    
    @IBAction func anyButtonTapped(_ sender: UIButton) {
        lotViewSetUp()
        lotTF.text?.removeAll()
        if sender.tag == 111{ //i don't have land
            iDontHaveBTN.superview?.backgroundColor = APPCOLORS_3.Orange_BG
            iDintHaveLandIMG.image = UIImage(named: "Ico-FaqWhite")
            iDontHaveLandLBL.textColor = APPCOLORS_3.HeaderFooter_white_BG
            homeDesignFeature?.selectedAnswer = "NOT SURE"
            homeDesignFeature?.displayString = "NOT SURE"
            
            if let selection = selectionUpdates {
                selection (self)
            }
        }else{ // I have land
            iHaveLandBTN.superview?.backgroundColor = APPCOLORS_3.Orange_BG
            //print(self.parent)
            if let parent = self.parent as? MyCollectionSurveyVC
            {
                parent.btnNext.backgroundColor = APPCOLORS_3.LightGreyDisabled_BG
                parent.btnNext.isUserInteractionEnabled = false
            }
            //iHaveLandIMG.image = UIImage(named: "Ico-Rite")?.withRenderingMode(.alwaysTemplate)
            iHaveLandIMG.tintColor = .white
            
            iHaveLandLBL.textColor = APPCOLORS_3.HeaderFooter_white_BG
            enterLotCard.isHidden = false
            if lotTF.text?.count == 0
            {
                homeDesignFeature?.selectedAnswer = ""
                selectionAlertMessage = "Please enter lot width"
            }
            
        }
        
        
        
    }
  @objc func nextFeatureResponse(_ notification : Notification)
  {
    if let dict = notification.userInfo as NSDictionary?
    {
      if let message = dict.value(forKey: "message") as? String
      {
        showToast(message) // When Some Error comes
       // homeDesignFeature?.selectedAnswer = ""
          lotTF.text?.removeAll()
          homeDesignFeature?.selectedAnswer = ""
         // homeDesignFeature?.selectedAnswer = lotTF.text ?? ""
          homeDesignFeature?.displayString = ""
          
        
      }
     
    }
  }
    let ACCEPTABLE_CHARACTERS = "0123456789."

//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//
//        return (string == filtered)
//    }
    //MARK:- Textfield Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        
        //MaxCharacter
        
        //restricting 2 successive dots
        let dotsCount = textField.text!.components(separatedBy: ".").count - 1
        if dotsCount > 0 && (string == "." || string == ",") {
            return false
        }
        
        if string == "," {
            textField.text! += "."
            return false
        }
        //        if string == filtered {
        
        return string == filtered && range.location < 5
        //        }
        //      return range.location < 8
        
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        homeDesignFeature?.selectedAnswer = ""
        selectionAlertMessage = "Please enter lot width"
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard lotTF.text!.count > 0 else {showToast("Please enter lot width");
            
            if let parent = self.parent as? MyCollectionSurveyVC
            {
                parent.btnNext.isUserInteractionEnabled = false
                parent.btnNext.backgroundColor = APPCOLORS_3.LightGreyDisabled_BG
                parent.removeAllBreadCrumbs()
                parent.addBreadcrumb(infoStaicText)
            }
            
            
            
            ;return}
    let value = Double(lotTF.text!)! * 100
    let finalLotWidth = value/100
    guard 0..<100 ~= finalLotWidth else{   // ' ~= ' --> is pattern matchin symbol
        
        if let parent = self.parent as? MyCollectionSurveyVC
        {
            parent.btnNext.backgroundColor = APPCOLORS_3.LightGreyDisabled_BG
            parent.btnNext.isUserInteractionEnabled = false
        }
        showToast("Please enter value between 1 to 100m");return}
    //  print(finalLotWidth.round)
    let displayStr = lotTF.text ?? ""
    homeDesignFeature?.selectedAnswer = String(format: "%.3f",finalLotWidth)
   // homeDesignFeature?.selectedAnswer = lotTF.text ?? ""
    homeDesignFeature?.displayString = "\(displayStr)M"
        
    
    
    if let selection = selectionUpdates {
      selection (self)
    }
  }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
