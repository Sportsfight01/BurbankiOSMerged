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

let COLOR_APPTHEME = UIColor.white
let COLOR_NAVIGATIONBAR = UIColor.orange

let COLOR_CLEAR = UIColor.clear
let COLOR_WHITE = UIColor.white

let COLOR_APP_BACKGROUND = UIColor.init(red: 246.0/255.0, green: 246.0/255.0, blue: 246.0/255.0, alpha: 1.0) //#F6F6F6


let COLOR_ORANGE = UIColor.init(red: 246.0/255.0, green: 133.0/255.0, blue: 33.0/255.0, alpha: 1.0) //#F68521
let COLOR_ORANGE_LIGHT = UIColor.init(red: 248.0/255.0, green: 150.0/255.0, blue: 56.0/255.0, alpha: 1.0) //#F89638
//let COLOR_BLACK = UIColor.init(red: 35.0/255.0, green: 31.0/255.0, blue: 32.0/255.0, alpha: 1.0) //#231F20
let COLOR_BLACK = APPCOLORS_3.Black_BG


let app_greenColor = UIColor(red: 91.0/255.0, green: 199.0/255.0, blue: 82.0/255.0, alpha: 1.0)


//HexColors
let COLOR_GRAY = UIColor.hexCode("#414042")
let COLOR_DARK_GRAY = UIColor.hexCode("#58595B")
let COLOR_LIGHT_GRAY = UIColor.hexCode("#E6E7E8")

//V3.1 Colors
struct APPCOLORS_3
{
    static let HeaderFooter_white_BG = UIColor.hexCode("#FFFFFF")
    static let Body_BG = UIColor.hexCode("#F6F6F6")
    static let LightGreyDisabled_BG = UIColor.hexCode("#D1D3D4")
    static let GreyTextFont =  UIColor.hexCode("#5C5E5E")
    static let DarkGrey_BG = UIColor.hexCode("#A7A9AC")
    static let Orange_BG = UIColor.hexCode("#F6891F")
    static let EnabledOrange_BG = UIColor.hexCode("#F7AE71")
    static let Black_BG = UIColor.hexCode("#000000")
    static let DisabledFooterIconGrey = UIColor.hexCode("#A2A2A1")

}

let COLOR_APP_GRAY = UIColor.init(red: 225.0/255.0, green: 226.0/255.0, blue: 225.0/255.0, alpha: 1.0) //#E1E2E1
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
