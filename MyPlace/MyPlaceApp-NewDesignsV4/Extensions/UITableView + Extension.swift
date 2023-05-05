//
//  UITableView + Extension.swift
//  BurbankApp
//
//  Created by Naresh Banavath on 25/03/22.
//  Copyright © 2022 DMSS. All rights reserved.
//

import UIKit

extension UITableView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = boldFontWith(size: FONT_18)
        if IS_IPAD
        {
            messageLabel.font = boldFontWith(size: FONT_18)
        }
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
    }


}
