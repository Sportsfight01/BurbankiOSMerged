//
//  TableViewExtension.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 04/05/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import Foundation

extension UITableView {
    
    func setEmptyMessage(_ message: String,bgColor : UIColor) {
        let messageLabel = UILabel(frame: CGRect(x: 5, y: 5, width: self.bounds.size.width-10, height: self.bounds.size.height-10))
        messageLabel.text = message
        messageLabel.textColor = UIColor.gray
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.backgroundColor = bgColor
        messageLabel.font = boldFontWith(size: FONT_18)
//        if deviceInfo.IS_IPAD
//        {
//            messageLabel.font = AppFonts.CustomeBoldFontWithSize(size: 24.0)
//        }
        messageLabel.sizeToFit()
        self.backgroundView = messageLabel;
    }
    
    func restore() {
        self.backgroundView = nil
    }
}
