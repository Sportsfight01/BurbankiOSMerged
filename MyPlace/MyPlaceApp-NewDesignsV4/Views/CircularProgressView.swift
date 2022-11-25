//
//  CircularProgressView.swift
//  BurbankApp
//
//  Created by naresh banavath on 19/11/21.
//  Copyright © 2021 DMSS. All rights reserved.
//

import UIKit
class CircularProgressView : UIView {
    
    //MARK: - Properties
    
  var imgView = UIImageView(frame: .zero)
  let trackLayer = CAShapeLayer()
  let label = UILabel()
  let progressLayer = CAShapeLayer()
  var lineWidth : CGFloat = 6 { didSet { progressLayer.lineWidth = lineWidth; trackLayer.lineWidth = lineWidth / 2 } }
  var strokeColor = UIColor.lightGray.withAlphaComponent(0.3) { didSet { progressLayer.strokeColor = strokeColor.cgColor ; label.textColor = strokeColor ; } }
  var progress : CGFloat = 0.0 { didSet { progressLayer.strokeEnd = progress } }
  var image : UIImage? { didSet {imgView.image = image  } }
  var labelText : String? = "0% Progress" { didSet { label.text = labelText} }
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
    //MARK: - Initializers
    
  required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      setup()
  }
  override func layoutSubviews() {
    super.layoutSubviews()
    setup()
  }
    
    //MARK: - Helper Methods
    
  func setup()
  {
    //ProgressLayer
    progressLayer.lineWidth = 6
    progressLayer.strokeColor = strokeColor.cgColor
    progressLayer.fillColor = UIColor.clear.cgColor
    let circularPath = UIBezierPath(arcCenter: self.center, radius: self.bounds.width / 2 , startAngle: CGFloat(-0.5 * .pi), endAngle: CGFloat(1.5 * .pi), clockwise: true)
    progressLayer.path = circularPath.cgPath
    progressLayer.lineCap = .round
    progressLayer.strokeStart = 0
    progressLayer.strokeEnd = progress
   // progressLayer.frame = bounds
    //TrackLayer
  
    trackLayer.lineCap = .round
    trackLayer.path = circularPath.cgPath
    trackLayer.fillColor = UIColor.clear.cgColor
    trackLayer.lineWidth = 3
    trackLayer.strokeColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
  //  trackLayer.frame = bounds
    self.layer.sublayers?.forEach({$0.removeFromSuperlayer()})
    self.layer.addSublayer(trackLayer)
    self.layer.addSublayer(progressLayer)
    //ImageView
    imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.bounds.width/2, height: self.bounds.width/2))
    imgView.image = image
    //imgView.backgroundColor = .yellow
    self.addSubview(imgView)
    
    //LabelText
   
    label.text = labelText
    label.textColor = strokeColor
    label.font = UIFont.systemFont(ofSize: self.bounds.width / 12.0 , weight: .semibold)
   // label.font = UIFont.systemFont(ofSize: 11.0, weight: .regular)
    self.addSubview(label)
    
    //ImageView Constraints
    
    imgView.translatesAutoresizingMaskIntoConstraints = false
    imgView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
    imgView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -10).isActive = true
    imgView.heightAnchor.constraint(equalToConstant: (self.bounds.height / 2) * 0.8).isActive = true
    imgView.widthAnchor.constraint(equalToConstant: (self.bounds.width / 2) * 0.8).isActive = true
//
    label.translatesAutoresizingMaskIntoConstraints = false
    label.topAnchor.constraint(equalTo: imgView.bottomAnchor , constant: 8.0).isActive = true
    label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    
  }

}
