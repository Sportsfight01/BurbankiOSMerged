//
//  RegionListTVCell.swift
//  BurbankApp
//
//  Created by dmss on 05/01/17.
//  Copyright © 2017 DMSS. All rights reserved.
//

import UIKit

class RegionListTVCell: BurbankTVCell
{
    
    
    var region: String?
        {
        didSet{
            
            textLabel?.text = region
//            labelWidth = rectForText(text: region!, font: (textLabel?.font)!, maxSize: (textLabel?.frame.size)!).width + extendedWidth
//
            if let currentRegion = UserDefaults.standard.value(forKey: "currentRegion") as? [String: Any]
            {
                let currentRegionName = currentRegion["Name"] as? String
                if currentRegionName == region
                {
                    regionSelectedImageView.isHidden = false
                    imageView?.image = #imageLiteral(resourceName: "Ico-Region")
                    
                }else
                {
                    regionSelectedImageView.isHidden = true
                    imageView?.image = #imageLiteral(resourceName: "Ico-Location-Unfill")
                }
            }
        }
    }
    var suburb: String?
    {
        didSet
        {
            textLabelLeftAnchoreConstraint = 15
            textLabel?.text = suburb
            regionSelectedImageView.isHidden = true
            if let currentSuburb = UserDefaults.standard.value(forKey: "CurrentSuburb") as? String
            {
                if currentSuburb == suburb
                {
                    regionSelectedImageView.isHidden = false
                }else
                {
                    regionSelectedImageView.isHidden = true
                }
            }
        }
    }
    var estate: String?
        {
        didSet
        {
            textLabelLeftAnchoreConstraint = 15
            textLabel?.text = estate
            regionSelectedImageView.isHidden = true
            if let currentEstate = UserDefaults.standard.value(forKey: "CurrentEstate") as? String
            {
                if currentEstate == estate
                {
                    regionSelectedImageView.isHidden = false
                }else
                {
                    regionSelectedImageView.isHidden = true
                }
            }
        }
    }

    var bottomLine: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(r: 87, g: 87, b: 87)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var regionSelectedImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "Ico-Select")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .gray
        textLabel?.numberOfLines = 0
        textLabel?.font = ProximaNovaRegular(size: 14.0)
        addSubview(bottomLine)
        addSubview(regionSelectedImageView)
       // contentView.addSubview(regionSelectedImageView)
       // addSubview(cuurenLocationLabel)
        setUpBottomLine()
        
    }
    func setUpBottomLine()
    {
        bottomLine.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        bottomLine.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
        bottomLine.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        bottomLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
   
    func setUpRegionSelectedImageView()
    {
        regionSelectedImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -18).isActive = true
        regionSelectedImageView.centerYAnchor.constraint(equalTo: (imageView?.centerYAnchor)!).isActive = true
        regionSelectedImageView.widthAnchor.constraint(equalTo: (imageView?.widthAnchor)!, constant: 6.0).isActive = true
        regionSelectedImageView.heightAnchor.constraint(equalTo: (imageView?.heightAnchor)!, constant: 6.0).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        
        imageView?.frame = CGRect.zero
        bottomLine.frame = CGRect.zero
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var labelWidth: CGFloat!
    var textLabelLeftAnchoreConstraint: CGFloat! = 35
    override func layoutSubviews()
    {
        super.layoutSubviews()
        let height = frame.size.height * 0.3
        imageView?.frame.size = CGSize(width: height, height: height)
        imageView?.center =  CGPoint(x: 20, y: (textLabel?.center.y)!)
        
        textLabel?.frame.origin = CGPoint(x: textLabelLeftAnchoreConstraint, y: (textLabel?.frame.origin.y)!)
        setUpRegionSelectedImageView()
    }
    
    func rectForText(text: String, font: UIFont, maxSize: CGSize) -> CGSize {
        let attrString = NSAttributedString.init(string: text, attributes: [NSAttributedString.Key.font:font])
        let rect = attrString.boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        let size = CGSize(width: rect.size.width, height: rect.size.height)  
        return size
    }
}
