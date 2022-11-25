//
//  HomesDetailsVC.swift
//  BurbankApp
//
//  Created by Madhusudhan on 09/01/17.
//  Copyright © 2017 DMSS. All rights reserved.
//

import UIKit

class HomesDetailsVC: UIViewController {

    @IBOutlet weak var optionsView : UIView!
    
    var isDisplayHomesNeedToShow : Bool!
    
    let optionTitlesArray: NSArray = ["Over View", "Floor Plan", "Display Home"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Remove the after passing value to this object
        isDisplayHomesNeedToShow = true
        
        
        var optionButtonCount : Int = 2
        
        if isDisplayHomesNeedToShow == true {
            optionButtonCount = 3
        }
        
        var widthGap : CGFloat = 0.0
        
        // *****  Create option buttons to show OverView, FloorPlan and Display Homes  ***** //
        
        for i in 0...optionButtonCount {
            
            let optionButton = UIButton(type: .custom)
            optionButton.frame = CGRect(x: widthGap, y: 0, width: (SCREEN_WIDTH/2), height: optionsView.frame.size.height)
            optionButton.tag = i
            optionButton.setTitle(optionTitlesArray.object(at: i) as? String, for: .normal)
            optionButton.addTarget(self, action: Selector(("optoinsTapped:")), for: .touchDown)
            optionsView.addSubview(optionButton)
            
            if i == 0 {
                optionButton.setTitleColor(UIColor.white, for: .normal)
                optionButton.backgroundColor = UIColor.orangeBurBankColor()
            }
            else
            {
                optionButton.setTitleColor(UIColor.hercBlackTitleHeaderColor(), for: .normal)
                optionButton.backgroundColor = UIColor.lightGray
            }
            
            widthGap = (widthGap + SCREEN_WIDTH/2)
        }
        
        // ** Ended for created the Option Buttons // ***
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Button Actions
    
    func optoinsTapped(sender : AnyObject) {
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
