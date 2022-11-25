//
//  FilterOptionsCVCell.swift
//  BurbankApp
//
//  Created by dmss on 19/01/17.
//  Copyright © 2017 DMSS. All rights reserved.
//

import UIKit

class FilterOptionsCVCell: UICollectionViewCell
{
    var filterNameLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = ProximaNovaRegular(size: 12.0)
        label.textAlignment = .center
        return label
        
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        addSubview(filterNameLabel)
        setUpFilterNameLabel()
        setUpHorizontalView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpFilterNameLabel()
    {
        filterNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        filterNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    var horizontalBarBViewLeftAnchor: NSLayoutConstraint!
    var horizontalBarView: UIView!
    func setUpHorizontalView()
    {
        horizontalBarView = UIView()
        horizontalBarView.isHidden = true
        horizontalBarView.backgroundColor = UIColor.orangeBurBankColor()
        addSubview(horizontalBarView)
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        horizontalBarBViewLeftAnchor = horizontalBarView.leftAnchor.constraint(equalTo: leftAnchor)
        horizontalBarBViewLeftAnchor.isActive = true
        horizontalBarView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 2.5).isActive = true
        
    }
    override var isHighlighted: Bool
        {
            didSet
            {
                filterNameLabel.textColor = isHighlighted ?  UIColor.orangeBurBankColor() : UIColor.black
                horizontalBarView.isHidden = isHighlighted ? false : true

            }
    }
    override var isSelected: Bool
        {
        didSet 
        {
            filterNameLabel.textColor = isSelected ? UIColor.orangeBurBankColor() : UIColor.black
            if isSelected == true
            {
                horizontalBarView.isHidden = false
            }else
            {
                horizontalBarView.isHidden = true
            }
          //  horizontalBarView.isHidden = isSelected ? false : true
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations:
                {
                    self.layoutIfNeeded()
            }, completion: nil)

        }
    }
    
    
    
}
