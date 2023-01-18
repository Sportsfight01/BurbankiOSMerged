//
//  HomeLandTVCell.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 06/04/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit

class HomeLandTVCell: UITableViewCell {
    
    @IBOutlet weak var imageHouse: UIImageView!
    @IBOutlet weak var imageHouseHeight: NSLayoutConstraint!
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    
    @IBOutlet weak var viewData: UIView!
    
    @IBOutlet weak var lBPrice: UILabel!
    @IBOutlet weak var lBName: UILabel!
    @IBOutlet weak var lBAddress: UILabel!
    @IBOutlet weak var btnFavorite: UIButton!
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var imageBedroom: UIImageView!
    @IBOutlet weak var lBBedroom: UILabel!
    
    @IBOutlet weak var imageBathroom: UIImageView!
    @IBOutlet weak var lBBathroom: UILabel!
    
    @IBOutlet weak var imageParking: UIImageView!
    @IBOutlet weak var lBParking: UILabel!
    
    
    var homeLand: HomeLandPackage? {
        
        didSet {
            fillAllDetails()
        }
    }
    var displayHomeData: DisplayHomeModel? {
        
        didSet {
            fillAllDisplayHomeDetails()
        }
    }
    
    var favoriteAction: (() -> Void)?
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setAppearanceFor(view: lBPrice, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Orange_BG, textFont: FONT_LABEL_SUB_HEADING(size: FONT_16))
        
        setAppearanceFor(view: lBName, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_SUB_HEADING(size: FONT_14))
        
        setAppearanceFor(view: lBAddress, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_LIGHT(size: FONT_12))
        
        
        setAppearanceFor(view: lBBedroom, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_SUB_HEADING(size: FONT_13))
        setAppearanceFor(view: lBBathroom, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_SUB_HEADING(size: FONT_13))
        setAppearanceFor(view: lBParking, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_SUB_HEADING(size: FONT_13))

        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func fillAllDetails () {
        
        self.imageHouse?.image = imageEmpty
        activity.startAnimating()
        
        
        if let imageurl = homeLand?.facadePermanentUrl {
            
            ImageDownloader.downloadImage(withUrl: ServiceAPI.shared.URL_imageUrl(imageurl), withFilePath: nil, with: { (image, success, error) in
                
                self.activity.stopAnimating()
                self.imageHouse.contentMode = .scaleToFill
                
                if let img = image {
                    self.imageHouse.image = img
                }else {
                    self.imageHouse.image = UIImage (named: "BG-Half")
                }
                                    
            }) { (progress) in
                
            }
        }
        
        //self.lBPrice.text = "$" + self.homeLand!.price!
        if let price = self.homeLand?.price {
            self.lBPrice.text = String.currencyFormate((price as NSString).intValue)
        }
//        self.lBPrice.text = String.currencyFormate(Int32(self.homeLand!.price ?? "0")!)
        self.lBName.text = (self.homeLand!.houseName ?? "") + " " + (self.homeLand!.houseSize ?? "")
        self.lBAddress.text = self.homeLand!.address?.replacingOccurrences(of: " ,", with: ",").replacingOccurrences(of: " ,", with: ",").replacingOccurrences(of: " ,", with: ",").replacingOccurrences(of: " ,", with: ",")
        self.lBBedroom.text = self.homeLand!.bedRooms ?? ""
        self.lBBathroom.text = self.homeLand!.bathRooms ?? ""
        self.lBParking.text = self.homeLand!.carSpace ?? ""
        
        if self.homeLand?.isFav == true {
            self.btnFavorite.setBackgroundImage(imageFavorite, for: .normal)
        }else {
            self.btnFavorite.setBackgroundImage(imageUNFavorite, for: .normal)
        }
        
    }
    
    func fillAllDisplayHomeDetails () {
        
        self.imageHouse?.image = imageEmpty
        activity.startAnimating()
        
        
        if let imageurl = displayHomeData?.facadePermanentUrl {
            
            ImageDownloader.downloadImage(withUrl: ServiceAPI.shared.URL_imageUrl(imageurl), withFilePath: nil, with: { (image, success, error) in
                
                self.activity.stopAnimating()
                self.imageHouse.contentMode = .scaleToFill
                
                if let img = image {
                    self.imageHouse.image = img
                }else {
                    self.imageHouse.image = UIImage (named: "BG-Half")
                }
                                    
            }) { (progress) in
                
            }
        }
        
        //self.lBPrice.text = "$" + self.homeLand!.price!
//        if let price = self.displayHomeData?.price {
//            self.lBPrice.text = String.currencyFormate((price as NSString).intValue)
//        }
//        self.lBPrice.text = String.currencyFormate(Int32(self.homeLand!.price ?? "0")!)
        self.lBName.text = (self.displayHomeData!.houseName ?? "") + " " + (self.displayHomeData!.houseSize ?? "")
        self.lBAddress.text = self.displayHomeData!.lotStreet1 ?? ""
        self.lBBedroom.text = self.displayHomeData!.bedRooms ?? ""
        self.lBBathroom.text = self.displayHomeData!.bathRooms ?? ""
        self.lBParking.text = self.displayHomeData!.carSpace ?? ""
        
        if self.homeLand?.isFav == true {
            self.btnFavorite.setBackgroundImage(imageFavorite, for: .normal)
        }else {
            self.btnFavorite.setBackgroundImage(imageUNFavorite, for: .normal)
        }
        
    }
    
    
    @IBAction func handleFavoriteAction (_ sender: UIButton) {
        
        if let action = favoriteAction {
            action()
        }
        
    }
    
    
}
