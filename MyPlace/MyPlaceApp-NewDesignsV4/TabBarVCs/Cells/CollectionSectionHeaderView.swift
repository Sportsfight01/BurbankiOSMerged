//
//  CollectionSectionHeaderView.swift
//  BurbankApp
//
//  Created by naresh banavath on 30/11/21.
//  Copyright © 2021 DMSS. All rights reserved.
//

import UIKit

class CollectionSectionHeaderView: UICollectionReusableView {
  static let identifier = "CollectionSectionHeaderView"
  @IBOutlet weak var dateLb: UILabel!
    {
        didSet
        {
            dateLb.font = FONT_LABEL_BODY(size: FONT_10)
        }
    }
  @IBOutlet weak var dotView: UIView!
  @IBOutlet weak var sectionTitleLb: UILabel!
    {
        didSet
        {
            dateLb.font = FONT_LABEL_BODY(size: FONT_10)
        }
    }
  
    
}
