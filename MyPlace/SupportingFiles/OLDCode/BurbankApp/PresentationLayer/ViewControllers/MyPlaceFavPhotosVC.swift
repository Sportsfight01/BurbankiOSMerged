//
//  MyPlaceFavPhotosVC.swift
//  BurbankApp
//
//  Created by dmss on 05/12/17.
//  Copyright © 2017 DMSS. All rights reserved.
//

import UIKit


class MyPlaceFavPhotosVC: BurbankAppVC/*MyPlaceWithTabBarVC*/,UITableViewDataSource,UITableViewDelegate,favPhotosProtocal
{
    
    @IBOutlet weak var titleLabel : UILabel!

    
//    @IBOutlet weak var favPhotosGridView: UICollectionView!
    @IBOutlet weak var jobNumberTextFiled : UITextField!
    @IBOutlet weak var favPhotosTableView: UITableView!
    @IBOutlet weak var noPhotosLabel: UILabel!

    @IBOutlet weak var noDataLabelbottom: NSLayoutConstraint!

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var favPhotos = MyPlaceFavPhoto.fetchFavPhotos()
    let cellID = "FavPhotoCellID"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewSetUp()
        
        let user = appDelegate.currentUser
        if let jobNumber = user?.userDetailsArray?[0].myPlaceDetailsArray[0].jobNumber
        {
            jobNumberTextFiled.text = jobNumber
        }
//        favPhotosGridView.dataSource = self
//        favPhotosGridView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        favPhotosTableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func viewSetUp () {
        
        _ = setAttributetitleFor(view: titleLabel, title: "FavouritePhotos", rangeStrings: ["Favourite", "Photos"], colors: [COLOR_BLACK, COLOR_ORANGE], fonts: [FONT_LABEL_HEADING(size: FONT_18), FONT_LABEL_HEADING(size: FONT_18)], alignmentCenter: true)
        
        setAppearanceFor(view: jobNumberTextFiled, backgroundColor: COLOR_CLEAR, textColor: COLOR_WHITE, textFont: FONT_LABEL_HEADING (size: FONT_16))
        
        setAppearanceFor(view: noPhotosLabel, backgroundColor: COLOR_CLEAR, textColor: COLOR_LIGHT_GRAY, textFont: FONT_LABEL_HEADING (size: FONT_20))

    }
    
    
    func showHideTable (_ count: Int) {
        
        noDataLabelbottom.constant = -jobNumberTextFiled.superview!.frame.size.height/2
        
        if count == 0
        {
            noPhotosLabel.isHidden = false
            noPhotosLabel.superview?.isHidden = false

            jobNumberTextFiled.superview!.isHidden = true
            favPhotosTableView.isHidden = true
        }else
        {
            noPhotosLabel.isHidden = true
            noPhotosLabel.superview?.isHidden = true

            jobNumberTextFiled.superview!.isHidden = false
            favPhotosTableView.isHidden = false
        }
    }
    
    
    // MARK: Table View DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = favPhotos?.count ?? 0
        
        showHideTable(count)
        
        return count
    }
    
    lazy var imageID = selectedJobNumberRegion == .OLD ? self.favPhotos![0].imageID : self.favPhotos![0].urlID
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavCell")as! MyPlacePhotoDetailCell
        cell.selectionStyle = .none
        cell.fullScreenButton.tag = indexPath.row
        cell.imageScrollView.tag = indexPath.row
        cell.mainImage.tag = indexPath.row
        
        cell.zoomString = ""
        
        
        let favPhoto = favPhotos![indexPath.row]
        func loadImageForQLDSA()
        {
            let urlID = favPhoto.urlID ?? ""
            CodeManager.sharedInstance.downloadAndShowImage(urlID,urlID,cell.mainImage)
            imageID = urlID
        }
        func loadImageForVLC()
        {
            let imagePath = favPhoto.imagePathForVLC ?? ""
            let trimmedImagePath = imagePath.trimmingCharacters(in: NSCharacterSet.whitespaces)
            cell.mainImage.loadImageUsingCacheUrlString(urlString: trimmedImagePath)
            imageID = favPhoto.imageID
        }
        selectedJobNumberRegion == .OLD ? loadImageForVLC() : loadImageForQLDSA()
        
        cell.addNotesButton.tag = indexPath.row
        cell.favButton.isSelected = true
        cell.imageID  = imageID ?? ""
        cell.delegate = self
        let presentDate = favPhoto.uploadedDate?.stringToDateConverter()
        let year = presentDate?.presentYear ?? 2017
        let monthID = presentDate?.monthNumber ?? 0
        let monthName = getMonthNameWith(id: monthID)
        let day = presentDate?.dayValue ?? 0
        cell.descriptionLabel.text = "photo added on \(favPhoto.uploadedDate?.displayInTimeFormat() ?? "") \(day) \(monthName) \(year)"
        cell.addNotesButton.addTarget(self, action: #selector(handleAddNotesButtonTapped(sender:)), for: .touchUpInside)
        
        
        let note = "Notes\n\n\n\(MyPlacePhotoNote.fetchPhotoNote("\(imageID ?? "0")")?.noteDescription ?? "")"
        if note == "Notes\n\n\n"
        {
            cell.addNotesButton.setTitle("  Add Notes  ", for: .normal)
            
            cell.addNotesButton.constraints.forEach({ (constraint) in
                if constraint.identifier == "noteAspectratioID"
                {
                    constraint.constant = 0
                }
            })
        }else
        {
            cell.addNotesButton.setTitle("  show/edit  ", for: .normal)
            cell.addNotesButton.constraints.forEach({ (constraint) in
                if constraint.identifier == "noteAspectratioID"
                {
                    constraint.constant = 30
                }
            })
        }
        cell.notesLabel.text = note.replacingOccurrences(of: "Notes\n\n\n", with: "Notes\n\n")
        let noteLabelHeight = note.heightForView(font: cell.notesLabel.font, width: SCREEN_WIDTH - 100)
        cell.notesLabel.superview?.constraints.forEach({ (constraint) in
            if constraint.identifier == "heightID"
            {
                let noteLabelHeight = noteLabelHeight >= 200 ? noteLabelHeight + 25 : noteLabelHeight + 10
                constraint.constant = noteLabelHeight//min(300, noteLabelHeight)
            }
        })
        return cell
    }
    
    @IBAction func fullScreenTapped(_ sender: UIButton) {
        
        
        CodeManager.sharedInstance.sendScreenName(photos_fav_fullscreen_button_touch)
        
        
        let indexPath = NSIndexPath(row: sender.tag, section: 0)
        let cell = favPhotosTableView.cellForRow(at: indexPath as IndexPath) as! MyPlacePhotoDetailCell
        
        CodeManager.sharedInstance.openImageLikePop(frame: cell.mainImage.frame, imageObj: (cell.mainImage.image)!)
    }
    
    @objc func handleAddNotesButtonTapped(sender: UIButton)
    {
        
        
        CodeManager.sharedInstance.sendScreenName(photos_add_button_touch)
        
        
        let storyBoard = UIStoryboard(name: "Main_OLD", bundle: nil)
        let notesVC = storyBoard.instantiateViewController(withIdentifier: "MyPhotosNotesVCID") as! MyPhotosNotesVC
        let favPhoto = favPhotos![sender.tag]
        notesVC.imageId = (selectedJobNumberRegion == .OLD ? favPhoto.imageID : favPhoto.urlID) ?? ""
        self.present(notesVC, animated: true, completion: nil)
    }
    // MARK: FavPhoto Deletated Protocal Method
    func favPhotoDeleted()
    {
        
        CodeManager.sharedInstance.sendScreenName(photos_fav_symbol_touch)
        
        
        favPhotos = MyPlaceFavPhoto.fetchFavPhotos()
        favPhotosTableView.setContentOffset(.zero, animated: true)
        favPhotosTableView.reloadData()
        
        showHideTable(favPhotos?.count ?? 0)
    }
    
    
    @objc func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let note = "Notes:\n\n\n\(MyPlacePhotoNote.fetchPhotoNote("\(imageID ?? "0")")?.noteDescription ?? "")"
        let noteTextHeight = note.rectForText(font: ProximaNovaRegular(size: 16.0), maxSize: CGSize(width: 100, height: 0))
        let height = noteTextHeight > 260 ? noteTextHeight/4 : 0
        let CELLHEIGHT = tableView.frame.size.height/1.26
        return CELLHEIGHT + height
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func backButtonTapped(sender: AnyObject?)
    {
        
        CodeManager.sharedInstance.sendScreenName(photos_fav_back_button_touch)
        
        
        self.navigationController?.popViewController(animated: true)
    }
}

class MyPlaceFavPhotoCell: UICollectionViewCell
{
    @IBOutlet weak var favPhotoImageView: UIImageView!
}
