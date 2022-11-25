//
//  DisplaysMapDetailExpandedCell.swift
//  BurbankApp
//
//  Created by sreekanth reddy Tadi on 07/05/21.
//  Copyright © 2021 Sreekanth tadi. All rights reserved.
//

import UIKit

class DisplaysMapDetailExpandedCell: UITableViewCell {

    @IBOutlet weak var carSpaceCard: UIView!
    @IBOutlet weak var carSpaceIMG: UIImageView!
    @IBOutlet weak var carSpaceCountLBL: UILabel!
    
    @IBOutlet weak var bathRoomCard: UIView!
    @IBOutlet weak var bathRoomIMG: UIImageView!
    @IBOutlet weak var bathRoomCountLBL: UILabel!
    
    @IBOutlet weak var bedRoomCard: UIView!
    @IBOutlet weak var bedRoomIMG: UIImageView!
    @IBOutlet weak var bedRoomCountLBL: UILabel!
    
    @IBOutlet weak var favoriteBTN: UIButton!
    @IBOutlet weak var estateNameLBL: UILabel!
    @IBOutlet weak var houseIMG: UIImageView!
    @IBOutlet weak var mainCardView: UIView!
    
    @IBOutlet weak var cardViewTwo: UIView!
    @IBOutlet weak var tradingHoursLBL: UILabel!
    
    @IBOutlet weak var getDirectionBTN: UIButton!
    @IBOutlet weak var bookAnAppointmentBTN: UIButton!
    
    @IBOutlet weak var houseNameLBL: UILabel!
    @IBOutlet weak var streetNameLBL: UILabel!
    @IBOutlet weak var facadeNameLBL: UILabel!
    var favoriteAction: (() -> Void)?
    
    var estateName : String?
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
        self.bedRoomCountLBL.text = self.displayHomeData!.bedRooms 
        self.bathRoomCountLBL.text = self.displayHomeData!.bathRooms 
        self.carSpaceCountLBL.text = self.displayHomeData!.carSpace
        let tradingHoursSepr = self.displayHomeData!.openTimes.components(separatedBy: ",")
        let tradingHrs = tradingHoursSepr.joined(separator: " " + "|" + " ")
        self.tradingHoursLBL.text = "TRADING HOURS \n\(tradingHrs)"
      self.houseNameLBL.text = (self.displayHomeData!.houseName).capitalized + " " + (self.displayHomeData!.houseSize )
        self.estateNameLBL.text = self.displayHomeData!.displayEstateName
        self.streetNameLBL.text = self.displayHomeData!.suburb
        self.facadeNameLBL.text = "\(self.displayHomeData?.facade ?? "") Facade"
        if self.displayHomeData?.isFav == true {
            self.favoriteBTN.setBackgroundImage(imageFavorite, for: .normal)
            if (Int(kUserID) ?? 0) > 0 {
                self.favoriteBTN.setBackgroundImage(imageFavorite, for: .normal)
            }else{
                self.favoriteBTN.setBackgroundImage(imageUNFavorite, for: .normal)
            }
        }else {
            self.favoriteBTN.setBackgroundImage(imageUNFavorite, for: .normal)
        }
       
        self.favoriteBTN.addTarget(self, action: #selector(didTappedOnFavourites(_:)), for: .touchUpInside)
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
