//
//  AppTheme.swift
//  MyPlace
//
//  Created by Sreekanth tadi on 23/03/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import Foundation
import UIKit
import AssetsLibrary
import Photos


//MARK: - Images

let imageEmpty = UIImage(named: "")

let imageChecked = UIImage(named: "Ico-Checked")
let imageUnChecked = UIImage(named: "Ico-Uncheckd")


let imageCheckedEnquiry = UIImage(named: "Ico-Checked-1")
let imageUnCheckedEnquiry = UIImage(named: "Ico-Unchecked")
//@available(iOS 13.0, *)
//let imageUnCheckedEnquiry = UIImage(systemName: "square.fill")





let IMAGE_MYPLACE = UIImage(named: "Ico-MyPlace-White")
let IMAGE_MYCOLLECTION = UIImage(named: "Img-MyCollection")
let IMAGE_HOMELAND = UIImage(named: "Img-H&L")
//let IMAGE_MYPROFILE = UIImage(named: "Img-Profile")
let IMAGE_MYPROFILE = UIImage(named: "MyProfile")



//let Image_defaultDP = UIImage(named: "Ico-BB-Black")
let Image_defaultDP = UIImage(named: "BurbankLogo")

//let imageBack = UIImage(named: "Ico-Back1")
let imageBack = UIImage(named: "ico-Back")

let imageHome = UIImage(named: "Ico-Home-1")//Ico-MenuIcon")




var imageUNFavorite : UIImage
{
    
    return UIImage(named: "Ico-HeartFill")!.withRenderingMode(.alwaysTemplate)
//    if #available(iOS 13.0, *)
//    {
//        return UIImage(systemName: "heart")!.withRenderingMode(.alwaysTemplate).withTintColor(APPCOLORS_3.GreyTextFont)
//    }
//    else {
//        return UIImage(named: "Ico-HeartFill")!
//    }
//
}
let imageFavorite = UIImage(named: "Ico-LikeFill")




