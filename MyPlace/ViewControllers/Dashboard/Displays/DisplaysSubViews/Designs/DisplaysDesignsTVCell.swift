//
//  DisplaysDesignsTVCell.swift
//  BurbankApp
//
//  Created by sreekanth reddy Tadi on 07/05/21.
//  Copyright © 2021 Sreekanth tadi. All rights reserved.
//

import UIKit

protocol displayDesignDetailsProtocol: NSObject {
    func didTappedOnestateName (index : Int)
}

class DisplaysDesignsTVCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {

    let displaysDesignsSubTVCellHeight: CGFloat = 30
    
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    var arrayLocations = [1, 2, 3, 4,5,6]
    @IBOutlet weak var mainCardView: UIView!
    @IBOutlet weak var houseIMG: UIImageView!
    @IBOutlet weak var estateNameLBL: UILabel!
    @IBOutlet weak var locationsLBL: UILabel!
    @IBOutlet weak var subTableView: UITableView!
    @IBOutlet weak var bedCountLBL: UILabel!
    @IBOutlet weak var bathroomCountLBL: UILabel!
    @IBOutlet weak var parkingCountLBL: UILabel!
    var delegate : displayDesignDetailsProtocol?
    var displayHomeModelLocations : PupularDisplays? {
        didSet {
            fillAllDisplayHomeDetails()
        }
    }
     var arrCount = 6
    override func awakeFromNib() {
        super.awakeFromNib()
        subTableView.tableFooterView = UIView()
        subTableView.separatorColor = .clear
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        houseIMG.image = nil
        estateNameLBL.text = nil
        locationsLBL.text = nil
        bedCountLBL.text = nil
        bathroomCountLBL.text = nil
        parkingCountLBL.text = nil
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func fillAllDisplayHomeDetails () {
        
        self.houseIMG?.image = imageEmpty
//        activity.startAnimating()
        
        
        if let imageurl = displayHomeModelLocations!.imageUrl {
            
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
        
        //self.lBPrice.text = "$" + self.homeLand!.price!
//        if let price = self.displayHomeData?.price {
//            self.lBPrice.text = String.currencyFormate((price as NSString).intValue)
//        }
//        self.lBPrice.text = String.currencyFormate(Int32(self.homeLand!.price ?? "0")!)
        self.estateNameLBL.text = (self.displayHomeModelLocations!.houseName ?? "" ) + " " + (self.displayHomeModelLocations!.houseSize ?? "" )
//        self.lBAddress.text = self.displayHomeData!.lotStreet1 ?? ""
        self.bedCountLBL.text = self.displayHomeModelLocations!.bedRooms ?? "0"
        self.bathroomCountLBL.text = self.displayHomeModelLocations!.bathRooms ?? "0"
        self.parkingCountLBL.text = self.displayHomeModelLocations!.carSpace ?? "0"
        if self.displayHomeModelLocations!.locations.count > 0{
            self.locationsLBL.isHidden = false
          if self.displayHomeModelLocations!.locations.count == 1 {
           self.locationsLBL.text = "\(self.displayHomeModelLocations!.locations.count ) LOCATION"
          }else{
            self.locationsLBL.text = "\(self.displayHomeModelLocations!.locations.count ) LOCATIONS"
          }
        }else{
            self.locationsLBL.isHidden = true
        }
       
        
        tableHeight.constant = displaysDesignsSubTVCellHeight*CGFloat(self.displayHomeModelLocations!.locations.count )
//       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.displayHomeModelLocations?.locations.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DisplaysDesignsSubTVCell", for: indexPath) as! DisplaysDesignsSubTVCell
        let name = "\(self.displayHomeModelLocations?.locations[indexPath.row].lotSuburb ?? "") - \(self.displayHomeModelLocations?.locations[indexPath.row].eststeName ?? "")"
        cell.propertyNameLBL.text = name
        cell.contentView.addUnderlineView(.bottom)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return displaysDesignsSubTVCellHeight
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return displaysDesignsSubTVCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //  print("=====",indexPath.row)
        
        
        delegate?.didTappedOnestateName(index : indexPath.row)
    }
}




class DisplaysDesignsSubTVCell: UITableViewCell {

    @IBOutlet weak var propertyNameLBL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
enum Sides
{
    case top,left,right,bottom
}

extension UIView
{
    func addUnderlineView(_ to : Sides)
    {
        switch to
        {
        case .bottom:
            let underLineView = UIView(frame: CGRect(x: 0, y: self.frame.height-1, width: self.frame.width, height: 1.0))
            underLineView.backgroundColor = APPCOLORS_3.GreyTextFont
            self.addSubview(underLineView)
            underLineView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                underLineView.heightAnchor.constraint(equalToConstant: 0.5),
                underLineView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                underLineView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                underLineView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            
            ])
        default:
                print(log: "not implemented yet")
        }
    }
}
