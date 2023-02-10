//
//  DisplaysCVCell.swift
//  BurbankApp
//
//  Created by sreekanth reddy Tadi on 04/05/21.
//  Copyright © 2021 Sreekanth tadi. All rights reserved.
//

import UIKit


//MARK: - Cell1
protocol displaySuggestedVCProtocol: NSObject {
    func didTappedOnSuggestedHome (index : Int)
    func didTappedOnSuggestedHomeFavourite (index : Int)
}


class DisplaysSuggestedCVCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var DisplayHomeDataArr = [DisplayHomeModel]()
    var delegate : displaySuggestedVCProtocol?
    var favoriteAction: (() -> Void)?
    var isFavoritesService: Bool = false
    var arrFavouriteDisplays = [[DisplayHomeModel]]()
    
    //    var displays: [Any] = [1, 2, 3, 4, 5, 6, 7, 8]
    
    //    override init(frame: CGRect) {
    //        super.init(frame: frame)
    //
    ////        loadCellView ()
    //    }
    //
    //    required init?(coder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //        loadCellView ()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let scaleFactor = UIScreen.main.bounds.width * 0.7
        layout.itemSize = CGSize(width: scaleFactor , height: 250)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.collectionView.collectionViewLayout = layout
        
    }
    func reloadData () {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        return displays?.count ?? 0
        return DisplayHomeDataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DisplaysSuggestedSubCVCell", for: indexPath) as! DisplaysSuggestedSubCVCell
        let displayData = DisplayHomeDataArr[indexPath.item]
        
        
        
        cell.LBLDesignsCount.text = displayData.locations?.count == 1 ? "\(displayData.locations?.count ?? 0 )  DESIGN"  :  "\(displayData.locations?.count ?? 0 )  DESIGNS"
        //        cell.LBLDesignsCount.text = "\(displayData.locations?.count ?? 0) DESIGNS"
        cell.estateNameLBL.text = "\(displayData.estateName ?? ""), \(displayData.houseName ?? "")"
        cell.likeBTN.tag = indexPath.row
        
        if let imageurl = displayData.facadePermanentUrl {
            
            ImageDownloader.downloadImage(withUrl: ServiceAPI.shared.URL_imageUrl(imageurl), withFilePath: nil, with: { (image, success, error) in
                
                //                self.activity.stopAnimating()
                cell.displayHomeImg.contentMode = .scaleToFill
                
                if let img = image {
                    cell.displayHomeImg.image = img
                }else {
                    cell.displayHomeImg.image = UIImage (named: "BG-Half")
                }
                
            }) { (progress) in
                
            }
        }
        
        
        if isFavoritesService == true {
            //             let displayData = DisplayHomeDataArr[indexPath.item]
            //            let package = arrFavouritePackages[indexPath.section][indexPath.row]
            let displayData = DisplayHomeDataArr[indexPath.item]
            
            
            cell.likeBTN.isHidden = displayData.favouritedUser?.userID != kUserID
            
        }else {
            //             let displayData = DisplayHomeDataArr[indexPath.item]
            let displayHomeData = DisplayHomeDataArr[indexPath.item]
            
        }
        cell.likeBTN.tintColor = APPCOLORS_3.GreyTextFont
        if displayData.isFav == true {
            if (Int(kUserID) ?? 0) > 0 {
                cell.likeBTN.setBackgroundImage(imageFavorite, for: .normal)
            }else{
                cell.likeBTN.setBackgroundImage(imageUNFavorite, for: .normal)
            }
        }else {
            cell.likeBTN.setBackgroundImage(imageUNFavorite, for: .normal)
        }
        cell.favoriteAction = {
            if noNeedofGuestUserToast(UIApplication.shared.visibleViewController!, message: "Please login to add favourites") {
                
                if self.isFavoritesService {
                    CodeManager.sharedInstance.sendScreenName(burbank_homeAndLand_favourite_makeFavourite_button_touch)
                    
                }else {
                    CodeManager.sharedInstance.sendScreenName(burbank_homeAndLand_results_makeFavourite_button_touch)
                }
                
                self.makeDisplayHomeFavorite(!(displayData.isFav), displayData) { (success) in
                    if success {
                        
                        if (!(displayData.isFav) == true) {
                            if let vc = UIApplication.shared.visibleViewController{
                                ActivityManager.showToast("Added to your favourites", vc)
                            }
                        }else{
                            if let vc = UIApplication.shared.visibleViewController{
                                ActivityManager.showToast("Item removed from favourites", vc)
                            }
                        }
                        
                        var updateDefaults = true
                        
//                        if displayData.favouritedUser?.userID == kUserID {
//                            updateDefaults = true
//                        }
                        
                        
                        if self.isFavoritesService {
                            
                            var arr = self.arrFavouriteDisplays[indexPath.row]
                            arr.remove(at: indexPath.row)
                            
                            if arr.count == 0 {
                                self.arrFavouriteDisplays.remove(at: indexPath.row)
                                
                                if updateDefaults {
                                    setHomeLandFavouritesCount(count: 0, state: kUserState)
                                }
                                
                            }else {
                                self.arrFavouriteDisplays[indexPath.row] = arr
                                
                                if updateDefaults {
                                    
                                    
                                    setHomeLandFavouritesCount(count: arr.count, state: kUserState)
                                }
                            }
                            
                        }else {
                            
                            displayData.isFav = !(displayData.isFav)
                            self.DisplayHomeDataArr[indexPath.item] = displayData
                            
                            self.collectionView.reloadItems(at: [IndexPath.init(row: indexPath.item, section: 0)])
                            if updateDefaults {
                                updateDisplayHomesFavouritesCount(displayData.isFav == true)
                                
                            }
                        }
                    }
                }
            }
            }
            print(log: "indexpath \(indexPath.row), arraycount \(DisplayHomeDataArr.count)")
            
            
            
            return cell
        }
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            let scaleFactor = UIScreen.main.bounds.width * 0.7
            return CGSize (width: scaleFactor, height: self.frame.size.height)
            
            
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 0
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 10
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets (top: 0, left: 0, bottom: 0, right: 0)
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            delegate?.didTappedOnSuggestedHome (index : indexPath.row)
        }
        
        
        
        
        func makeDisplayHomeFavorite (_ favorite: Bool, _ design: DisplayHomeModel, callBack: @escaping ((_ successss: Bool) -> Void)) {
            
            let params = NSMutableDictionary()
            params.setValue(3, forKey: "TypeId")
            params.setValue(appDelegate.userData?.user?.userID, forKey: "UserId")
            params.setValue(design.id, forKey: "HouseId")
            params.setValue(kUserState, forKey: "StateId")
            params.setValue(favorite, forKey: "isfavourite")
            
            
            
            _ = Networking.shared.POST_request(url: ServiceAPI.shared.URL_Favorite, parameters: params, userInfo: nil, success: { (json, response) in
                
                if let result: AnyObject = json {
                    
                    let result = result as! NSDictionary
                    
                    if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {
                        
                        callBack (true)
                        
                    }else { print(log: String.init(format: "Couldn't %@ home", arguments: [favorite ? "Favourite" : "Unfavourite"])) }
                    
                }else {
                    
                    //                showToast(kServerErrorMessage)
                }
                
            }, errorblock: { (error, isJSONerror) in
                
                if isJSONerror {
                    //                showToast(String.init(format: "Couldn't %@ home", arguments: [favorite ? "Favourite" : "Unfavourite"]))
                }else {
                    print(log: error?.localizedDescription as Any)
                    //                showToast(String.init(format: "Couldn't %@ home", arguments: [favorite ? "Favourite" : "Unfavourite"]))
                }
                
            }, progress: nil)
            
        }
        
    }
    





class SectionHeader: UICollectionReusableView {
    @IBOutlet weak var sectionHeaderlabel: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        loadCellView ()
    }
    
}

class DisplaysSuggestedSubCVCell: UICollectionViewCell {
    @IBOutlet weak var LBLDesignsCount: UILabel!
    @IBOutlet weak var BTNdesigns: UIButton!
    @IBOutlet weak var likeBTN: UIButton!
    @IBOutlet weak var estateNameLBL: UILabel!
    @IBOutlet weak var detailsCardView: UIView!
    @IBOutlet weak var displayHomeImg: UIImageView!
    var favoriteAction: (() -> Void)?
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
////        loadCellView ()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        self.likeBTN.addTarget(self, action: #selector(didTappedOnFavourites(_:)), for: .touchUpInside)
    }
    
    
    @IBAction func didTappedOnFavourites (_ sender: UIButton) {
        if let action = favoriteAction {
            action()
        }
//        delegate?.didTappedOnSuggestedHomeFavourite(index: sender.tag)
    }
    
}








//MARK: - Cell2

class DisplaysCVCell: UICollectionViewCell {
    
    @IBOutlet weak var designNameLBL: UILabel!
    @IBOutlet weak var houseIMG: UIImageView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var locationsBTN: UIButton!
    @IBOutlet weak var locationsLBL: UILabel!
    //
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
////        loadCellView ()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        let mapImg = UIImage(named: "ico-DisplayHomeFooter")
        
        locationsBTN.setImage(mapImg?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        locationsBTN.tintColor = .white
      
    }
}
