//
//  CheckBox.swift
//  BurbankApp
//
//  Created by Madhusudhan on 19/01/17.
//  Copyright © 2017 DMSS. All rights reserved.
//

import UIKit

class CheckBox: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    // Images
    let uncheckedImage = UIImage(named: "Ico-Check-Unfill")! as UIImage
    let checkedImage = UIImage(named: "Ico-Check-Fill")! as UIImage
    
    /*
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, for: .normal)
            } else {
                self.setImage(uncheckedImage, for: .normal)
            }
        }
    }*/
    
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(CheckBox.buttonClicked(_:)), for: UIControl.Event.touchUpInside)
        
        self.setImage(uncheckedImage, for: .normal)
        self.setImage(checkedImage, for: .selected)
    }
    
    @objc func buttonClicked(_ sender: UIButton) {
        
        if sender.isSelected == true {
            sender.isSelected = false
        }
        else
        {
            sender.isSelected = true
        }
    }
}
