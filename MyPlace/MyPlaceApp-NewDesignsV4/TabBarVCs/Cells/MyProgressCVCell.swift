//
//  MyProgressCVCell.swift
//  BurbankApp
//
//  Created by naresh banavath on 19/11/21.
//  Copyright © 2021 DMSS. All rights reserved.
//

import UIKit

class MyProgressCVCell: UICollectionViewCell {
    
    @IBOutlet weak var seeMoreBtn: UIButton!
    @IBOutlet weak var lastUpdatedLb: UILabel!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var detailLb: UILabel!
    
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        progressView.subviews.forEach({$0.removeFromSuperview()})
    }
    func setupFonts()
    {
        titleLb.font = FONT_LABEL_BODY(size: FONT_20)
        lastUpdatedLb.font = FONT_LABEL_BODY(size: FONT_10)
        detailLb.font = FONT_LABEL_BODY(size: FONT_22)
        seeMoreBtn.titleLabel?.font = FONT_LABEL_SUB_HEADING(size: FONT_12)
    }
    
    func setupCircularBar(progressColor : UIColor , progress : CGFloat , cicleImage : UIImage? = nil, index : Int)
    {
        setupFonts()
        let circleBar = CircularProgressView(frame: progressView.frame)
        circleBar.strokeColor = progressColor
        circleBar.progress = progress
        circleBar.image = cicleImage
        let progressInt = Int(progress * 100)
        //  print("progress Int :- \(progressInt)")
        if progressInt == 0
        {
            circleBar.labelText = "PENDING"
        }
        else if progressInt == 100
        {
            circleBar.labelText = "COMPLETE"
        }
        else{
            circleBar.labelText = "\(progressInt)% PROGRESS"
        }
        progressView.addSubview(circleBar)
      //  if index == 0{
            circleBar.addAnimation(duration: 1.0)
//        }else {
//            circleBar.removeAnimation()
//        }
        circleBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            circleBar.topAnchor.constraint(equalTo: progressView.topAnchor),
            circleBar.bottomAnchor.constraint(equalTo: progressView.bottomAnchor),
            circleBar.leadingAnchor.constraint(equalTo: progressView.leadingAnchor),
            circleBar.trailingAnchor.constraint(equalTo: progressView.trailingAnchor)
            
        ])
        
        progressView.backgroundColor = .clear
        // seeMoreBtn.setTitleColor(progressColor, for: UIControl.State())
    }
    
  
}
