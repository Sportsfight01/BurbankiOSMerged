//
//  DisplaysMapDetailCell.swift
//  BurbankApp
//
//  Created by sreekanth reddy Tadi on 07/05/21.
//  Copyright © 2021 Sreekanth tadi. All rights reserved.
//

import UIKit

class DisplaysMapDetailCell: UITableViewCell {

    @IBOutlet weak var carSpacesCard: UIView!
    @IBOutlet weak var carSpaceIMG: UIImageView!
    @IBOutlet weak var carSpaceCountLBL: UILabel!
    
    @IBOutlet weak var bathRoomsCard: UIView!
    @IBOutlet weak var bathRoomIMG: UIImageView!
    @IBOutlet weak var bathRoomCountLBL: UILabel!
    
    @IBOutlet weak var bedRoomsCard: UIView!
    @IBOutlet weak var bedRoomIMG: UIImageView!
    @IBOutlet weak var bedRoomCountLBL: UILabel!
    
    @IBOutlet weak var favoriteBTN: UIButton!
    @IBOutlet weak var estateNameLBL: UILabel!
    @IBOutlet weak var houseIMG: UIImageView!
    @IBOutlet weak var mainCardView: UIView!
    @IBOutlet weak var houseNameLBL: UILabel!
    @IBOutlet weak var streetNameLBL: UILabel!
    @IBOutlet weak var facadeNameLBL: UILabel!
    var estateName : String?
    var favoriteAction: (() -> Void)?
   
    
    var displayHomeData: houseDetailsByHouseType? {
        
        didSet {
            fillAllDisplayHomeDetails()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func fillAllDisplayHomeDetails () {
        
        self.houseIMG?.image = imageEmpty
//        activity.startAnimating()
        pageUISetup()
        
        if let imageurl = displayHomeData?.facadePermanentUrl {
            
            ImageDownloader.downloadImage(withUrl: ServiceAPI.shared.URL_imageUrl(imageurl), withFilePath: nil, with: { (image, success, error) in
                
//                self.activity.stopAnimating()
                self.houseIMG.contentMode = .scaleToFill
                
                if let img = image {
                    self.houseIMG.image = img
                }else {
                    self.houseIMG.image = UIImage (named: "BG-Half")
                }
                                    
            }) { (progress) in
                
            }
        }
      self.houseNameLBL.text = (self.displayHomeData!.houseName.capitalized) + " " + (self.displayHomeData!.houseSize)
        self.estateNameLBL.text = self.displayHomeData!.displayEstateName
        self.streetNameLBL.text = self.displayHomeData!.suburb
        self.facadeNameLBL.text = "\(self.displayHomeData!.facade) Facade"
        self.bedRoomCountLBL.text = self.displayHomeData!.bedRooms
        self.bathRoomCountLBL.text = self.displayHomeData!.bathRooms
        self.carSpaceCountLBL.text = self.displayHomeData!.carSpace
        self.favoriteBTN.setImage(displayHomeData?.isFav == true ? imageFavorite : imageUNFavorite, for: .normal)
//        if self.displayHomeData?.isFav == true {
////            self.favoriteBTN.setBackgroundImage(imageFavorite, for: .normal)
//            if (Int(kUserID) ?? 0) > 0 {
//                self.favoriteBTN.setBackgroundImage(imageFavorite, for: .normal)
//            }else{
//                self.favoriteBTN.setBackgroundImage(imageUNFavorite, for: .normal)
//            }
//        }else {
//            self.favoriteBTN.setBackgroundImage(imageUNFavorite, for: .normal)
//        }
        self.favoriteBTN.addTarget(self, action: #selector(didTappedOnFavourites(_:)), for: .touchUpInside)
        
    }
    
    func pageUISetup()
    {
        [bedRoomCountLBL,bathRoomCountLBL,carSpaceCountLBL].forEach { lbl in
            setAppearanceFor(view: lbl, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_SUB_HEADING(size: FONT_14))
        }
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
