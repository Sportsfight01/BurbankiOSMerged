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
  func setupCircularBar(progressColor : UIColor , progress : CGFloat , cicleImage : UIImage? = nil)
    {
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
        circleBar.translatesAutoresizingMaskIntoConstraints = false
        circleBar.topAnchor.constraint(equalTo: progressView.topAnchor).isActive = true
        circleBar.bottomAnchor.constraint(equalTo: progressView.bottomAnchor).isActive = true
        circleBar.leadingAnchor.constraint(equalTo: progressView.leadingAnchor).isActive = true
        circleBar.trailingAnchor.constraint(equalTo: progressView.trailingAnchor).isActive = true
        progressView.backgroundColor = .clear
        // seeMoreBtn.setTitleColor(progressColor, for: UIControl.State())
    }
}
