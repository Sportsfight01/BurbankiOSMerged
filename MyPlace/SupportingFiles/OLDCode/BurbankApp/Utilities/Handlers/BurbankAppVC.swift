//
//  BurbankAppVC.swift
//  BurbankApp
//
//  Created by dmss on 28/12/16.
//  Copyright © 2016 DMSS. All rights reserved.
//

import UIKit

class BurbankAppVC: UIViewController {

    var headerView = UIView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        CodeManager.sharedInstance.setLabelsFontInView(view)
        
        view.addSubview(headerView)
        headerView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: statusBarHeight())
        setBurbankAppStatusBarColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    
    func setBurbankAppStatusBarColor (_ color: UIColor = .white) {
        headerView.backgroundColor = color
    }
    

}
