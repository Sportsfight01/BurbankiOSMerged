//
//  ProfileViewClass.swift
//  BurbankApp
//
//  Created by Naveen Kourampalli on 12/05/22.
//  Copyright © 2022 DMSS. All rights reserved.
//

import UIKit

class ProfileViewClass: UIView {
    @IBOutlet var countLBL: UILabel!
    @IBOutlet var profileImage: UIImageView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commInit()
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commInit()
    }
    
    func commInit(){
        let view = Bundle.main.loadNibNamed("ProfileViewClass", owner: self, options: nil)![0] as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
}

