

import Foundation
import UIKit

class MyCustomButton: UIButton
{
    // Images
    let uncheckedImage = UIImage(named: "Ico-Check-Unfill")! as UIImage
    let checkedImage = UIImage(named: "Ico-Check-Fill")! as UIImage
    var isChecked: Bool = false {
        didSet
        {
            isSelected = isChecked
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.addTarget(self, action: #selector(MyCustomButton.buttonClicked(_:)), for: .touchUpInside)
        
        self.setImage(uncheckedImage, for: .normal)
        self.setImage(checkedImage, for: .selected)
        
        /*
         If user is selected in XIB
         */
        if self.isSelected == true {
            isChecked = true
        }
    }
    
    
    @objc func buttonClicked(_ sender: UIButton) {
        
        if sender.isSelected == true {
            sender.isSelected = false
            isChecked = false
        }
        else
        {
            sender.isSelected = true
            isChecked = true
        }
    }
    
    //MARK: - Maintain button selection
    
    /*
     to handle the bool condition If user selected option already in Filters Screen.
     */
    func isButtonSelected(isSelect : Bool) {
        
        if isSelect == true {
            self.isSelected = true
            isChecked = true
        }
        else
        {
            self.isSelected = false
            isChecked = false
        }
    }
}
