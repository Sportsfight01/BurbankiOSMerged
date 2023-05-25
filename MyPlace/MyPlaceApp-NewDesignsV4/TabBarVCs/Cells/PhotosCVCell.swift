//
//  PhotosCVCell.swift
//  BurbankApp
//
//  Created by naresh banavath on 30/11/21.
//  Copyright © 2021 DMSS. All rights reserved.
//

import UIKit

class PhotosCVCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    {
        didSet
        {
            imageView.contentMode = .scaleAspectFill
        }
    }
    @IBOutlet weak var sectionNameLb: UILabel!
    {
        didSet
        {
            sectionNameLb.font = FONT_LABEL_SUB_HEADING(size: FONT_15)
        }
    }
    @IBOutlet weak var photosCountLb: UILabel!
    {
        didSet
        {
            photosCountLb.font = FONT_LABEL_SUB_HEADING(size: FONT_12)
        }
    }
    
    
}
