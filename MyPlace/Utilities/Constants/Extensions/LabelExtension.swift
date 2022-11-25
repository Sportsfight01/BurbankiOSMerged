//
//  LabelExtension.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 09/10/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import Foundation


extension UILabel {
    
    
  func addCharacterSpacing(kernValue: Double = 1.15) {
    if let labelText = text, labelText.count > 0 {
      let attributedString = NSMutableAttributedString(string: labelText)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length - 1))
      attributedText = attributedString
    }
  }
    
    
}
