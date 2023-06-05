//
//  Constants.swift
//  BurbankApp
//
//  Created by naresh banavath on 17/11/21.
//  Copyright © 2021 DMSS. All rights reserved.
//

import UIKit
//let appDelegate = UIApplication.shared.delegate as! AppDelegate
//var kWindow: UIWindow = UIApplication.shared.windows.last ?? appDelegate.window!
func setAppearanceFor(view: UIView, backgroundColor: UIColor?, textColor: UIColor = UIColor.white, textFont: UIFont = UIFont.systemFont(ofSize: 14)) {
    
    if let color = backgroundColor {
        view.backgroundColor = color
    }
    
    if view.isKind(of: UILabel.self) {
        (view as! UILabel).textColor = textColor
        (view as! UILabel).font = textFont
    }
    
    if view.isKind(of: UIButton.self) {
        (view as! UIButton).setTitleColor(textColor, for: .normal)
        (view as! UIButton).titleLabel?.textColor = textColor
        (view as! UIButton).titleLabel?.font = textFont
    }
    
    if view.isKind(of: UITextField.self) {
        (view as! UITextField).textColor = textColor
        (view as! UITextField).font = textFont
    }
    
    if view.isKind(of: UITextView.self) {
        (view as! UITextView).textColor = textColor
        (view as! UITextView).font = textFont
    }
}

enum namedColors : String {
  case orange = "AppOrange"
    case gray = "AppGray"
}
struct AppColors
{
    static let appOrange : UIColor = UIColor(named: namedColors.orange.rawValue)!
    static let appGray : UIColor = APPCOLORS_3.GreyTextFont
    static let myplaceGray : UIColor = UIColor(red: 65/255, green: 64/255, blue: 66/255, alpha: 1.0)

    static let AppGray : UIColor = UIColor.hexCode("#414042")
    static let appPink : UIColor = UIColor.systemPink
    
    struct StageColors {
        static let admin = UIColor(red: 0, green: 179/255, blue: 199/255, alpha: 1.0)
        static let base = UIColor(red: 102/255, green: 104/255, blue: 170/255, alpha: 1.0)
        static let frame = UIColor(red: 215/255, green: 173/255, blue: 98/255, alpha: 1.0)
        static let lockup = UIColor(red: 255/255, green: 180/255, blue: 0/255, alpha: 1.0)
        static let fixing = UIColor(red: 255/255, green: 54/255, blue: 98/255, alpha: 1.0)
        static let finishing = UIColor(red: 56/255, green: 187/255, blue: 144/255, alpha: 1.0)
        
    }
    
    static let darkGray = APPCOLORS_3.GreyTextFont
    static let lightGray = APPCOLORS_3.GreyTextFont
    static let white = UIColor.white
    static let black = APPCOLORS_3.Black_BG
    @available(iOS 13.0, *)
    static let systemGray2  = UIColor.systemGray2
    
    
}
struct AppVariables
{
  static var user : UserStruct.Result? = nil
}
struct CurrentUser
{
    static var profilePicUrl : UIImage?
    static var userName : String?
    static var currentHomeBuildProgress : String?
    static var email : String?
    static var mobileNo : String?
    static var jobNumber : String?
}
let somethingWentWrong = "Something went wrong, Please try again later"

public var currentWindow : UIWindow = {
    
    if #available(iOS 13.0, *) {
        if let delegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        {
            return delegate.window ?? UIWindow()
        }
    } else {
        // Fallback on earlier versions
        return (UIApplication.shared.delegate as? AppDelegate)?.window ?? UIWindow()
    }
    return UIWindow()
}()


