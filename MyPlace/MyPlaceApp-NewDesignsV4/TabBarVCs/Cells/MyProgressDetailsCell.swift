//
//  MyProgressDetailsCell.swift
//  BurbankApp
//
//  Created by naresh banavath on 29/11/21.
//  Copyright © 2021 DMSS. All rights reserved.
//

import UIKit

class MyProgressDetailsCell: UITableViewCell {

  @IBOutlet weak var checkMarkImage: UIImageView!
  @IBOutlet weak var dateLb: UILabel!
  @IBOutlet weak var progressNameLb: UILabel!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
