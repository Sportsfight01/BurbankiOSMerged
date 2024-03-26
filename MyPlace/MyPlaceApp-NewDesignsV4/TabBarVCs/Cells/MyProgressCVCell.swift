//
//  MyProgressCVCell.swift
//  BurbankApp
//
//  Created by naresh banavath on 19/11/21.
//  Copyright © 2021 DMSS. All rights reserved.
//

import UIKit
protocol MyProgressCellDelegate : AnyObject
{
    func didTappedSeeMoreButton(index : Int)
}
class MyProgressCVCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var seeMoreBtn: UIButton!
    @IBOutlet weak var lastUpdatedLb: UILabel!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var detailLb: UILabel!
    weak var delegate : MyProgressCellDelegate?
    
     //MARK: - LifeCycle
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        progressView.subviews.forEach({$0.removeFromSuperview()})
    }
    
     //MARK: - Button Action
    @objc func seemoreBtnTapped(_ sender : UIButton)
    {
        delegate?.didTappedSeeMoreButton(index: sender.tag)
    }
    
    
     //MARK: - SetupUI
    func setupFonts()
    {
        titleLb.font = FONT_LABEL_BODY(size: FONT_20)
        lastUpdatedLb.font = FONT_LABEL_BODY(size: FONT_10)
        detailLb.font = FONT_LABEL_BODY(size: FONT_10)
        seeMoreBtn.titleLabel?.font = FONT_LABEL_SUB_HEADING(size: FONT_12)
    }
    
    func setup(model : MyProgressVM.ProgressItem?, index : Int)
    {
        if model != nil {  self.stopSkeletonAnimation();self.hideSkeleton() }
        containerView.appalyShadow()
        titleLb.text = model?.stage?.rawValue
        seeMoreBtn.setTitleColor(model?.stage?.progressColor, for: .normal)
        seeMoreBtn.tag = index
        seeMoreBtn.addTarget(self, action: #selector(seemoreBtnTapped(_:)), for: .touchUpInside)
        titleLb.superview?.layer.cornerRadius = 10.0
        titleLb.superview?.layer.masksToBounds = true
        detailLb.text = model?.stage?.detailedText
        if index > 0 {
            //cell.lastUpdatedLb.isHidden = false
            seeMoreBtn.isHidden = false
            lastUpdatedLb.textColor = AppColors.darkGray
            lastUpdatedLb.text = Self.setupLastUpdateDate(progressData: model?.progressDetails).lastUpdate
            detailLb.numberOfLines = 2
        }
        else { /// - for first item in collectionview
           detailLb.numberOfLines = 0
           lastUpdatedLb.text = "dummy text"
           lastUpdatedLb.textColor = .clear
           //lastUpdatedLb.isHidden = true
           seeMoreBtn.isHidden = true
            
          
        }
        setupCircularBar(progressColor: model?.stage?.progressColor ?? .black, progress: model?.progress ?? 0 , cicleImage: UIImage(named :model?.imageName ?? ""))
    }
    
     //MARK: - Helper Methods
    func setupCircularBar(progressColor : UIColor , progress : CGFloat , cicleImage : UIImage? = nil)
    {
        setupFonts()
        let circleBar = CircularProgressView(frame: progressView.frame)
        circleBar.strokeColor = progressColor
        circleBar.progress = progress
        circleBar.image = cicleImage
        let progressInt = Int(progress * 100)
         print("progress Int :- \(progressInt)")
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
        circleBar.addAnimation(duration: 1.0)
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
    /// - to get lastUpdated value for givenstage
    static func setupLastUpdateDate(progressData : [ProgressStruct]?) -> (lastUpdate : String , overallProgress : String)
    {
        guard progressData != nil else {return (lastUpdate : "0 Tasks to Complete" , overallProgress : "PENDING PREVIOUS STAGE") }// progressData nill means we are not getting any data of that stage
        let totalTaks = progressData?.count ?? 0
        let completedTaks = progressData?.filter({$0.status == "Completed"}).count ?? 0
        
        if totalTaks == completedTaks && totalTaks > 0
        {
           // yourOverallProgressLb.text = "COMPLETED STAGE"
            let date = dateFormatter(dateStr: progressData?.last?.dateactual ?? "", currentFormate: "yyyy-MM-dd'T'HH:mm:ss", requiredFormate: "dd/MM/yyyy")
            return (lastUpdate : "Completed \(date ?? "")" , overallProgress : "COMPLETED STAGE")
        }
        else if completedTaks == 0
        {
           // yourOverallProgressLb.text = "PENDING PREVIOUS STAGE"
            return (lastUpdate : "\(totalTaks) Tasks to Complete" , overallProgress : "PENDING PREVIOUS STAGE")
           
        }
        else if completedTaks < totalTaks
        {
           // yourOverallProgressLb.text = "YOUR CURRENT STAGE"
            return (lastUpdate : "\(completedTaks ) of \(totalTaks ) Tasks Complete" , overallProgress : "YOUR CURRENT STAGE")
           
        }
        return (lastUpdate : "no data" , overallProgress : "no data")
        
        //  noOfTaskCompletedLb.text = "\(completedTaks ?? 0) of \(totalTaks ?? 0) Tasks Completed"
    }
  
}
