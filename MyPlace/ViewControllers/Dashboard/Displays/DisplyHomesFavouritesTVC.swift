//
//  DisplyHomesFavouritesTVC.swift
//  BurbankApp
//
//  Created by Naveen Kourampalli on 12/07/21.
//  Copyright © 2021 Sreekanth tadi. All rights reserved.
//

import UIKit

class DisplyHomesFavouritesTVC: UITableViewCell {
    @IBOutlet weak var homeIMG: UIImageView!
    @IBOutlet weak var estateNameLBL: UILabel!
    @IBOutlet weak var designCountLBL: UILabel!
    @IBOutlet weak var designsBTN: UIButton!
    @IBOutlet weak var favouriteBTN: UIButton!
    var favoriteAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.favouriteBTN.addTarget(self, action: #selector(didTappedOnFavourites(_:)), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func didTappedOnFavourites (_ sender: UIButton) {
        if let action = favoriteAction {
            action()
        }
    }
}
