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

let COLOR_BLACK = UIColor.init(red: 35.0/255.0, green: 31.0/255.0, blue: 32.0/255.0, alpha: 1.0) //#231F20


let app_greenColor = UIColor(red: 91.0/255.0, green: 199.0/255.0, blue: 82.0/255.0, alpha: 1.0)



let COLOR_GRAY = UIColor.gray
let COLOR_DARK_GRAY = UIColor.darkGray
let COLOR_LIGHT_GRAY = UIColor.lightGray

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
