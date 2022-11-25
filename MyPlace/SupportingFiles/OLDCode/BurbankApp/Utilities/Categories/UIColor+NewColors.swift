//
//  UIColor+NewColors.swift
//  Burbenk
//
//  Created by Satya on 18/02/16.
//  Copyright © 2016 DMSS. All rights reserved.
//

/*: 
 
 #Table of contents
 
 * hercBlackTitleHeaderColor
 * orangeBurBankColor
 
 
 #overview
 
 This file maintaining application Text colour, Background of selected and unselected color.
 
 */

import Foundation
import UIKit

extension UIColor
{
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat)
    {
        self.init(red:r/255 ,green: g/255,blue: b/255, alpha: 1.0)
    }
    
    public class func hercBlackTitleHeaderColor () -> UIColor
    {
        let hercBlackTitleHeaderColor = UIColor.init(red: 15.0/255.0, green: 15.0/255.0, blue: 15.0/255.0, alpha: 1.0)
//        (colorLiteralRed: 15.0/255.0, green: 15.0/255.0, blue: 15.0/255.0, alpha: 1.0)
        return hercBlackTitleHeaderColor
    }
    
    public class func orangeBurBankColor () -> UIColor
    {
        let orangeBurBankColor = UIColor.init(red: 246.0/255.0, green: 139.0/255.0, blue: 21.0/255.0, alpha: 1.0)
//        (colorLiteralRed: 246.0/255.0, green: 139.0/255.0, blue: 21.0/255.0, alpha: 1.0)
        return orangeBurBankColor
    }

}
