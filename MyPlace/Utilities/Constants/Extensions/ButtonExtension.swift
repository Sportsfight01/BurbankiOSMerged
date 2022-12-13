//
//  ButtonExtension.swift
//  BurbankApp
//
//  Created by Naveen Kourampalli on 20/10/22.
//  Copyright © 2022 Sreekanth tadi. All rights reserved.
//

import Foundation

import UIKit

@IBDesignable
final class ProfileButton: UIButton {

    @IBInspectable var titleText: String? {
        didSet {
            self.setTitle(titleText, for: .normal)
            self.setTitleColor(UIColor.black,for: .normal)
        }
    }

    override init(frame: CGRect){
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }

    func setup() {
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.width / 2.0
//        self.layer.borderColor = UIColor.lightGray.cgColor
//        self.layer.borderWidth = 1.0
    }
}

//class ProfileButton : UIButton {
//
//required init?(coder aDecoder: NSCoder) {
//    super.init(coder: aDecoder)
//    layer.borderWidth = 1.0
//    layer.borderColor = UIColor.white.cgColor
//    layer.cornerRadius = self.frame.width/2
//    clipsToBounds = true
//
//}
//}
