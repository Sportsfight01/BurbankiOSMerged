//
//  CollectionTVCell.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 14/04/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit

class CollectionTVCell: UITableViewCell {
    
    @IBOutlet weak var imageHouse : UIImageView!
    @IBOutlet weak var activity : UIActivityIndicatorView!

    @IBOutlet weak var lBHouseName : UILabel!
    @IBOutlet weak var lBPrice : UILabel!
    
    @IBOutlet weak var lBBedrooms : UILabel!
    @IBOutlet weak var lBBathrooms : UILabel!
    @IBOutlet weak var lBParking : UILabel!
        
    @IBOutlet weak var lBLot : UILabel!
    @IBOutlet weak var lBLotWidth : UILabel!
    
    
    @IBOutlet weak var btnFavourite: UIButton!

    
    
    var homeDesign: HomeDesigns? {
        didSet {
            fillAllDetails()
        }
    }
    
    
    var favoriteAction: (() -> Void)?

    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        
        setAppearanceFor(view: lBHouseName, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_LABEL_BODY (size: FONT_13))
        setAppearanceFor(view: lBPrice, backgroundColor: COLOR_CLEAR, textColor: COLOR_ORANGE, textFont: FONT_LABEL_SUB_HEADING (size: FONT_11))
        
        
        setAppearanceFor(view: lBParking, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_LABEL_SUB_HEADING (size: FONT_9))
        setAppearanceFor(view: lBBedrooms, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_LABEL_SUB_HEADING (size: FONT_9))
        setAppearanceFor(view: lBBathrooms, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_LABEL_SUB_HEADING (size: FONT_9))
        
        
        setAppearanceFor(view: lBLot, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_LABEL_BODY (size: FONT_8))
        setAppearanceFor(view: lBLotWidth, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_LABEL_SUB_HEADING (size: FONT_8))
        
        
        if let superview = lBLot.superview {
            
            superview.layer.cornerRadius = (superview.frame.size.height)/2
//            setShadow(view: superview, color: COLOR_LIGHT_GRAY, shadowRadius: 8)
            setBorder(view: superview, color: COLOR_APP_GRAY, width: 0.5)
            
            setAppearanceFor(view: lBLot, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_LABEL_LIGHT(size: 6))
            lBLot.text = "LOT\nWIDTH"
            setAppearanceFor(view: lBLotWidth, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_LABEL_LIGHT(size: 10))
            
            superview.layer.masksToBounds = true

        }
        
//        layoutIfNeeded()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
       
    
    
    func fillAllDetails () {
        
        self.imageHouse?.image = imageEmpty
        
        activity.startAnimating()
        
        
        if let imageurl = homeDesign?.facadePermanentUrl {
            
            ImageDownloader.downloadImage(withUrl: ServiceAPI.shared.URL_imageUrl(imageurl), withFilePath: nil, with: { (image, success, error) in
                
                self.activity.stopAnimating()
                self.imageHouse.contentMode = .scaleToFill
                
                if let img = image {
                    self.imageHouse.image = img
                }else {
                    print(ServiceAPI.shared.URL_imageUrl(imageurl))
                    self.imageHouse.image = UIImage (named: "placeHolderIMG")
                }
                                    
            }) { (progress) in
                
            }
        }
        
       // self.lBPrice.text = "$" + self.homeDesign!.price!
//        self.lBPrice.text = String.currencyFormate(Int32(self.homeDesign!.price!)!)    //----------> V2.2 changes
        self.lBPrice.isHidden = true  // --------> V2.2 changes
        
        self.lBHouseName.text = (self.homeDesign?.houseName ?? "") + " " + (self.homeDesign?.houseSize ?? "")
        self.lBBedrooms.text = self.homeDesign!.bedRooms
        self.lBBathrooms.text = self.homeDesign!.bathRooms
        self.lBParking.text = self.homeDesign!.carSpace
        
        
        self.lBLotWidth.text = (self.homeDesign!.minLotWidth ?? "0") + "m"
        
        
        if self.homeDesign?.isFav == true {
            self.btnFavourite.setBackgroundImage(imageFavorite, for: .normal)
        }else {
            self.btnFavourite.setBackgroundImage(imageUNFavorite, for: .normal)
        }

        
    }
    
    
    
    @IBAction func handleFavoriteAction (_ sender: UIButton) {
        
        if let action = favoriteAction {
            action()
        }
        
    }
    
    
}
