//
//  CollectionViewExtension.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 04/05/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import Foundation

extension UICollectionView {
    
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
    
    func restore() {
        self.backgroundView = nil
    }
}
