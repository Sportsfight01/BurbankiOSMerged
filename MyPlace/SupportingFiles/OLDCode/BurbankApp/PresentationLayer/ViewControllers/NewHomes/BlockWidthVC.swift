//
//  BlockWidthVC.swift
//  BurbankApp
//
//  Created by dmss on 20/01/17.
//  Copyright © 2017 DMSS. All rights reserved.
//

import UIKit
import WARangeSlider

class BlockWidthVC: BurbankAppVC {

    let blockWidthSlider = RangeSlider(frame: CGRect.zero)
    var isFromFilterVC: Bool! = false
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTitleLabel()
        view.addSubview(blockWidthSlider)
//        blockWidthSlider.isNeedSmallSize = true
//        blockWidthSlider.isBlockWidthSlider = true
        setUpBlockWidthSlider()
    }
    private func setUpTitleLabel()
    {
        if isFromFilterVC == true
        {
          let titleLabel = view.viewWithTag(123) as! UILabel
            titleLabel.isHidden = true
        }
        
    }
    private func setUpBlockWidthSlider()
    {
        blockWidthSlider.translatesAutoresizingMaskIntoConstraints = false
        blockWidthSlider.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        blockWidthSlider.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        var constant: CGFloat = 10
        if isFromFilterVC == true
        {
            constant = 0
        }
        blockWidthSlider.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
        blockWidthSlider.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
