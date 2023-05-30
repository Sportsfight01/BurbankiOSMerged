//
//  HomeCareProfileScreen.swift
//  BurbankApp
//
//  Created by Naveen Kourampalli on 03/05/23.
//  Copyright © 2023 Sreekanth tadi. All rights reserved.
//

import UIKit

class HomeCareProfileScreen: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var burbankLogoBTN: UIButton!
    @IBOutlet weak var baseImageView: UIImageView!
    
    @IBOutlet weak var navigationView: UIView!
    
    @IBOutlet weak var menuAndBackBtn: UIButton!
    @IBOutlet weak var contactUsBtn: UIButton!
    
    @IBOutlet weak var profileBaseView: UIView!
    
    @IBOutlet weak var profileView: UIImageView!
    
    @IBOutlet weak var titleLBL: UILabel!
    
    @IBOutlet weak var notificationCountLBL: UILabel!
    @IBOutlet weak var descriptionLBL: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit()
    {
        Bundle.main.loadNibNamed("HomeCareProfileScreen", owner: self)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth,
            .flexibleHeight]
    }
    

}
