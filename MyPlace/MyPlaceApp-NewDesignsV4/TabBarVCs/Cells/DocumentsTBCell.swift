//
//  DocumentsTBCell.swift
//  BurbankApp
//
//  Created by naresh banavath on 30/11/21.
//  Copyright © 2021 DMSS. All rights reserved.
//

import UIKit

class DocumentsTBCell: UITableViewCell {

   static let identifier = "DocumentsTBCell"
  
  @IBOutlet weak var docIconImgView: UIImageView!
  @IBOutlet weak var pdfNameLb: UILabel!
  {
    didSet
    {
      pdfNameLb.numberOfLines = 0
        pdfNameLb.font = UIFont.systemFont(ofSize: 14.0 , weight: .semibold)
    }
  }
  @IBOutlet weak var uploadedOnDateLb: UILabel!
  {
    didSet{
      uploadedOnDateLb.numberOfLines = 0
        uploadedOnDateLb.font = UIFont.systemFont(ofSize: 13.0 , weight: .medium)
    }
  }
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
