//
//  AppThemeFonts.swift
//  MyPlace
//
//  Created by Sreekanth tadi on 23/03/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import Foundation
import UIKit


//MARK: - Corner Radius

let radius_3 = SCREEN_HEIGHT/189.3
let radius_5 = SCREEN_HEIGHT/113.6
let radius_10 = SCREEN_HEIGHT/56.8



//MARK: - DEVICE FONTS

let FONT_5 = SCREEN_WIDTH/55
let FONT_6 = SCREEN_WIDTH/53
let FONT_7 = SCREEN_WIDTH/45.7
let FONT_8 = SCREEN_WIDTH/40
let FONT_9 = SCREEN_WIDTH/35.5
let FONT_10 = SCREEN_WIDTH/32 //height/56.8
let FONT_11 = SCREEN_WIDTH/29 //height/51.6
let FONT_12 = SCREEN_WIDTH/26.6 //height/47.3
let FONT_13 = SCREEN_WIDTH/24.6 //height/43.7
let FONT_14 = SCREEN_WIDTH/22.8 //height/40.6
let FONT_15 = SCREEN_WIDTH/21.3 //height/37.8
let FONT_16 = SCREEN_WIDTH/20 //height/35.5
let FONT_17 = SCREEN_WIDTH/18.8 //height/33.4
let FONT_18 = SCREEN_WIDTH/17.7 //height/31.5
let FONT_19 = SCREEN_WIDTH/16.8 //height/30
let FONT_20 = SCREEN_WIDTH/16 //height/28.4

let FONT_21 = SCREEN_WIDTH/15.2 //height/27
let FONT_22 = SCREEN_WIDTH/14.5 //height/25.8
let FONT_23 = SCREEN_WIDTH/13.9 //height/24.6
let FONT_24 = SCREEN_WIDTH/13.3 //height/23.6
let FONT_25 = SCREEN_WIDTH/12.8 //height/22.7

let FONT_26 = SCREEN_WIDTH/12.3 //height/22.7
let FONT_27 = SCREEN_WIDTH/11.85 //height/22.7
let FONT_28 = SCREEN_WIDTH/11.4 //height/22.7
let FONT_29 = SCREEN_WIDTH/11 //height/22.7
let FONT_30 = SCREEN_WIDTH/10.6 //height/22.7

let FONT_31 = SCREEN_WIDTH/10.32 //height/22.7
let FONT_32 = SCREEN_WIDTH/10 //height/22.7
let FONT_33 = SCREEN_WIDTH/9.69 //height/22.7
let FONT_34 = SCREEN_WIDTH/9.41 //height/22.7
let FONT_35 = SCREEN_WIDTH/9.14 //height/22.7

let FONT_40 = SCREEN_WIDTH/8.0

let FONT_50 = SCREEN_WIDTH/6.4
let FONT_55 = SCREEN_WIDTH/5.8 //height/22.7


let FONT_signin = SCREEN_HEIGHT/50.6




//MARK: - SYSTEM FONTS

func lightFontWith (size: CGFloat) -> UIFont {
    return  UIFont(name: "Montserrat-Light", size: size)!
}


func regularFontWith (size: CGFloat) -> UIFont {
    return  UIFont(name: "Montserrat-Regular", size: size)!
}

func mediumFontWith (size: CGFloat) -> UIFont {
    return UIFont(name: "Montserrat-Medium", size: size)!
}

func boldFontWith (size: CGFloat) -> UIFont {
    return  UIFont(name: "Montserrat-Bold", size: size)!
}

func semiboldFontWith (size: CGFloat) -> UIFont {
    return  UIFont(name: "Montserrat-SemiBold", size: size)!
}

func extraBoldFontWith (size: CGFloat) -> UIFont {
    return UIFont(name: "Montserrat-ExtraBold", size: size)!
}



func FONT_LABEL_HEADING (size: CGFloat = FONT_12) -> UIFont {
   return extraBoldFontWith(size: size)
}

func FONT_LABEL_SUB_HEADING (size: CGFloat = FONT_12) -> UIFont {
   return mediumFontWith(size: size)
}

func FONT_LABEL_BODY (size: CGFloat = FONT_12) -> UIFont {
   return regularFontWith(size: size)
}

func FONT_LABEL_LIGHT (size: CGFloat = FONT_12) -> UIFont {
   return lightFontWith(size: size)
}
func FONT_LABEL_SEMI_BOLD (size: CGFloat = FONT_12) -> UIFont {
   return semiboldFontWith(size: size)
}






func FONT_BUTTON_HEADING (size: CGFloat = FONT_12) -> UIFont {
   return extraBoldFontWith(size: size)
}

func FONT_BUTTON_SUB_HEADING (size: CGFloat = FONT_12) -> UIFont {
   return mediumFontWith(size: size)
}

func FONT_BUTTON_BODY (size: CGFloat = FONT_12) -> UIFont {
   return regularFontWith(size: size)
}

func FONT_BUTTON_LIGHT (size: CGFloat = FONT_12) -> UIFont {
   return lightFontWith(size: size)
}




func FONT_TEXTFIELD_HEADING (size: CGFloat = FONT_12) -> UIFont {
   return mediumFontWith(size: size)
}

func FONT_TEXTFIELD_BODY (size: CGFloat = FONT_12) -> UIFont {
   return regularFontWith(size: size)
}



func systemRegularFont (size: CGFloat = FONT_12) -> UIFont {
    return UIFont.systemFont(ofSize: size)
}

func systemBoldFont (size: CGFloat = FONT_12) -> UIFont {
    return UIFont.boldSystemFont(ofSize: size)
}

