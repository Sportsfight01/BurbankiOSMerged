//
//  ProfileHeaderView.swift
//  BurbankApp
//
//  Created by Naresh Banavath on 24/04/23.
//  Copyright © 2023 Sreekanth tadi. All rights reserved.
//

import UIKit

class ProfileHeaderView: UIView {

    //MARK: - Properties
    
    @IBOutlet weak var contactUsBtn: UIButton!
    @IBOutlet var contentView: UIView!    
    @IBOutlet weak var navBarTitleImg: UIImageView!
    @IBOutlet weak var menubtn: UIButton!
    @IBOutlet weak var stackLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var profilePicImgView: UIImageView!
    @IBOutlet weak var notificationCountLb: UILabel!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var helpTextLb: UILabel!
    
    @IBOutlet weak var secondHelpTextLb: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit()
    {
        Bundle.main.loadNibNamed("ProfileHeaderView", owner: self)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth,
            .flexibleHeight]
        setAppearanceFor(view: titleLb, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_BODY(size: FONT_25))
    }
    
    @IBAction func menuBtnAction(_ sender: UIButton) {
    }
    
}
