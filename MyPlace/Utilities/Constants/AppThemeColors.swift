//
//  AppTheme.swift
//  MyPlace
//
//  Created by Sreekanth tadi on 18/03/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import Foundation
import UIKit


//MARK: - COLOR


let COLOR_CLEAR = UIColor.clear

//V3.1 Colors
struct APPCOLORS_3
{
    static let HeaderFooter_white_BG = UIColor.hexCode("#FFFFFF")
    static let Body_BG = UIColor.hexCode("#F6F6F6")
    static let LightGreyDisabled_BG = UIColor.hexCode("#D1D3D4")
    static let GreyTextFont =  UIColor.hexCode("#5C5E5E")
    static let DarkGrey_BG = UIColor.hexCode("#A7A9AC")
//    static let Orange_BG = UIColor.hexCode("#F6891F")
    static let Orange_BG = UIColor.hexCode("#FF6224")
  
    static let EnabledOrange_BG = UIColor.hexCode("#F7AE71")
    static let Black_BG = UIColor.hexCode("#000000")
    static let DisabledFooterIconGrey = UIColor.hexCode("#A2A2A1")

}

let COLOR_CUSTOM_VIEWS_OVERLAY = UIColor.init(red: 98.0/255.0, green: 98.0/255.0, blue: 98.0/255.0, alpha: 0.8)




extension UIColor {
    
    public class func hexCode(_ hexString: String) -> UIColor {
        
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") || hexString.count == 6 {
//            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = hexString.replacingOccurrences(of: "#", with: "")// String(hexString[start]) // Swift 4 //hexString.substring(from: start)
            
            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt32 = 0
                
                if scanner.scanHexInt32(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat((hexNumber & 0x0000ff) >> 0) / 255
                    a = CGFloat(1)
                    
                    return UIColor(red: r, green: g, blue: b, alpha: a)
                }
            }
        }
        
        return UIColor.black
    }
}
