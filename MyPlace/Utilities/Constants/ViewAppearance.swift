////
////  ViewAppearance.swift
////  MyPlace
////
////  Created by Sreekanth tadi on 23/03/20.
////  Copyright © 2020 Sreekanth tadi. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//
////MARK: - Layer
//
//func setAppearanceFor(view: UIView, backgroundColor: UIColor?, textColor: UIColor = COLOR_APPTHEME, textFont: UIFont = UIFont.systemFont(ofSize: 14)) {
//    
//    if let color = backgroundColor {
//        view.backgroundColor = color
//    }
//    
//    if view.isKind(of: UILabel.self) {
//        (view as! UILabel).textColor = textColor
//        (view as! UILabel).font = textFont
//    }
//    
//    if view.isKind(of: UIButton.self) {
//        (view as! UIButton).setTitleColor(textColor, for: .normal)
//        (view as! UIButton).titleLabel?.textColor = textColor
//        (view as! UIButton).titleLabel?.font = textFont
//    }
//    
//    if view.isKind(of: UITextField.self) {
//        (view as! UITextField).textColor = textColor
//        (view as! UITextField).font = textFont
//    }
//    
//    if view.isKind(of: UITextView.self) {
//        (view as! UITextView).textColor = textColor
//        (view as! UITextView).font = textFont
//    }
//}
//
func setBorder (view: UIView, color: UIColor, width: CGFloat) {
    
    view.layer.borderColor = color.cgColor
    view.layer.borderWidth = width
}

func setShadow (view: UIView, color: UIColor, shadowRadius: CGFloat) {
    
    view.layer.shadowColor = color.cgColor
    view.layer.shadowOpacity = 0.5
    view.layer.shadowRadius = shadowRadius
}

func setShadowatBottom (view: UIView, color: UIColor, shadowRadius: CGFloat) {
    
    view.layer.shadowColor = color.cgColor
    view.layer.shadowOpacity = 0.5
    view.layer.shadowRadius = shadowRadius
    view.layer.shadowOffset = CGSize(width: 0, height: shadowRadius)
    view.layer.masksToBounds = false
    view.layoutIfNeeded()
}
//
//
//
//
//
////MARK: - Title
//
//func setAttributetitleFor (view: UIView?, title: String, rangeStrings: [String], colors: [UIColor], fonts: [UIFont], alignmentCenter: Bool) -> NSMutableAttributedString {
//    
//    if rangeStrings.count != colors.count || rangeStrings.count != fonts.count {
//        assertionFailure("setAttributetitleFor")
////        assert(true, "setAttributetitleFor")
////        abort()
//    }
//    
//    let str = NSString(format: "%@", title)
//    
//    let attr = NSMutableAttributedString(string: str as String)
//    
//    for i in 0...rangeStrings.count-1 {
//        let rangeStr = rangeStrings[i]
//        let color = colors.count>i ? colors[i] : UIColor.black
//        let font = fonts.count>i ? fonts[i] : regularFontWith(size: 12)
//        
//        attr.addAttributes([NSAttributedString.Key.foregroundColor: color, .font: font], range: str.range(of: rangeStr))
//    }
//    
//    
//    if let vie = view {
//        if vie.isKind(of: UIButton.self) {
//            (vie as! UIButton).setAttributedTitle(attr, for: .normal)
//            (vie as! UIButton).titleLabel?.numberOfLines = title.components(separatedBy: "\n").count
//            if alignmentCenter { (vie as! UIButton).titleLabel?.textAlignment = NSTextAlignment.center }
//        }else {
//            //label
//            (vie as! UILabel).attributedText = attr
//            if alignmentCenter { (vie as! UILabel).textAlignment = NSTextAlignment.center }
//            if (vie as! UILabel).lineBreakMode != .byTruncatingTail { (vie as! UILabel).numberOfLines = title.components(separatedBy: "\n").count }
//        }
//        return attr
//    }else {
//        
//        return attr
//    }
//    
//}
///*
// – assert()
// – precondition()
// – assertionFailure()
// – preconditionFailure()
// – fatalError()
// */
//
