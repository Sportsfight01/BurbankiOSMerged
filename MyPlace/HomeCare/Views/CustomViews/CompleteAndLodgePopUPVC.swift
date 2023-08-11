//
//  CompleteAndLodgePopUPVC.swift
//  BurbankApp
//
//  Created by Naveen Kourampalli on 26/06/23.
//  Copyright © 2023 Sreekanth tadi. All rights reserved.
//

import UIKit

protocol didTappedOncomplete {
    func didTappedOnCompleteAndLodgeBTN()
}

class CompleteAndLodgePopUPVC: UIViewController {
    var delegate : didTappedOncomplete? = nil

    @IBOutlet weak var descriptionLBL: UILabel!
    @IBOutlet weak var titleLBL: UILabel!
    
    @IBOutlet weak var checkBoxBTN: UIButton!
    @IBOutlet weak var conditionLBL: UILabel!
    
    @IBOutlet weak var completeAndLodgeBTN: UIButton!
    @IBOutlet weak var addMoreIssueBTN: UIButton!
    
    var isPopUpFromHomeScreen = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        setUpUI()
       
   // Do any additional setup after loading the view.
    }
    
    func setUpUI(){
        if isPopUpFromHomeScreen{
            titleLBL.text = "FOR EMERGENCY REPAIRS"
//            descriptionLBL.text = "For urgent repairs such as flooding, weatherproofing, electrical failures etc, Please call 13 2872 to get immediate action."
           
            setAttributetitleFor(view: descriptionLBL, title: "For urgent repairs such as flooding, weather proofing, electrical failures etc, Please call 13 2872 to get immediate action.", rangeStrings: ["For urgent repairs such as flooding, weather proofing, electrical failures etc, Please call ", "13 2872 ", "to get immediate action."], colors: [APPCOLORS_3.Black_BG, APPCOLORS_3.Black_BG, APPCOLORS_3.Black_BG], fonts: [FONT_LABEL_BODY (size: FONT_13), FONT_LABEL_SEMI_BOLD (size: FONT_13),FONT_LABEL_BODY (size: FONT_13)], alignmentCenter: false)
            
            addMoreIssueBTN.isHidden =  true
            checkBoxBTN.isHidden =  true
            conditionLBL.isHidden =  true
            completeAndLodgeBTN.setTitle("DISMISS", for: .normal)
        }else{
            titleLBL.text = "IMPORTANT INFORMATION"
//            descriptionLBL.text = "Your warranty issues must be logged including all issues you need to be action.DO NOT LODGE if you have more issues to add. If you have questions about this, please call our Home Care team on 13 2872"
            
            setAttributetitleFor(view: descriptionLBL, title: "Your warranty issues must be logged including all issues you need to be action. DO NOT LODGE if you have more issues to add. If you have questions about this, please call our Home Care team on 13 2872", rangeStrings: ["Your warranty issues must be logged including all issues you need to be action. ","DO NOT LODGE"," if you have more issues to add. If you have questions about this, please call our Home Care team on ", "13 2872"], colors: [APPCOLORS_3.Black_BG, APPCOLORS_3.Black_BG,APPCOLORS_3.Black_BG,APPCOLORS_3.Black_BG], fonts: [FONT_LABEL_BODY (size: FONT_12), FONT_LABEL_SEMI_BOLD (size: FONT_12),FONT_LABEL_BODY (size: FONT_12),FONT_LABEL_SEMI_BOLD (size: FONT_12)], alignmentCenter: false)
           
            
            addMoreIssueBTN.isHidden =  false
            checkBoxBTN.isHidden =  false
            conditionLBL.isHidden =  false
            completeAndLodgeBTN.setTitle("COMPLETE & LODGE", for: .normal)
        }
//        descriptionLBL.setLineHeight(lineHeight: 1.5)
        
        descriptionLBL.numberOfLines = 0
    }
    
    @IBAction func didTappedOnAddMoreIssues(_ sender: Any) {
        self.dismiss(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        setStatusBarColor(color: AppColors.AppGray)
    }
    @IBAction func didTappedOnCheckBox(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected{
            sender.tintColor = APPCOLORS_3.Orange_BG
        }else{
            sender.tintColor = APPCOLORS_3.GreyTextFont
        }
        
    }
    
    @IBAction func didTappedOnCompleteAndLodge(_ sender: UIButton) {
        if !isPopUpFromHomeScreen{
        self.delegate?.didTappedOnCompleteAndLodgeBTN()
        }
        self.dismiss(animated: true)
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
