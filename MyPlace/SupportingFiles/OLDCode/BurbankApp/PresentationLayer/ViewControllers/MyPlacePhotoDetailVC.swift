//
//  MyPlacePhotoDetailVC.swift
//  BurbankApp
//
//  Created by Mohan Kumar on 09/05/17.
//  Copyright © 2017 DMSS. All rights reserved.
//

import UIKit


class MyPlacePhotoDetailVC: BurbankAppVC/*MyPlaceWithTabBarVC*/,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var titleLabel : UILabel!

    @IBOutlet weak var photosDetailTable: UITableView!
    @IBOutlet weak var dateAndMonthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var topDescriptionView: UIView!
    
    @IBOutlet weak var nextButton: UIImageView!
    @IBOutlet weak var previousButton: UIImageView!
    
    var photosInfo:MyPlacePhotosWithDateInfo?
    var selectedImgViewIndex = 0
    let CELLHEIGHT = (SCREEN_HEIGHT - 0.11 * SCREEN_HEIGHT - 0.095 * SCREEN_HEIGHT) / 1.25
    var dayWisePhotoList : DayWisePhotoList<MyPlaceDocuments>!//for QLDSA
    var selectedDayIndex = 0//for QLS SA
    var monthWisePhotoList : YearMonthList!//for QLDSA for next and previous
    var yearMonthNumber = 0
    var isFromNotifications = false
    
    var favPhotos = MyPlaceFavPhoto.fetchFavPhotos()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setAppearanceFor(view: titleLabel, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_LABEL_HEADING(size: FONT_18))

        setAppearanceFor(view: dateAndMonthLabel, backgroundColor: COLOR_CLEAR, textColor: COLOR_WHITE, textFont: FONT_LABEL_SUB_HEADING(size: FONT_18))
        setAppearanceFor(view: yearLabel, backgroundColor: COLOR_CLEAR, textColor: COLOR_WHITE, textFont: FONT_LABEL_SUB_HEADING(size: FONT_18))

        
        //print(photosInfo?.year,photosInfo?.myPlacePhotos[0].dateCreated)
        let height: CGFloat = CGFloat(selectedImgViewIndex) * CELLHEIGHT
        let point = CGPoint(x: 0, y: height)
        photosDetailTable.setContentOffset(point, animated: true)
        
        selectedJobNumberRegion == .OLD ? fillDayDataForVLC() : fillDayDataForQLDSA()
        selectedJobNumberRegion == .OLD ? updateMonthAndYearLabelForVLC() : updateMonthAndYearLabelForQLDSA()
        updateViewIfFromNotifications()
        updateNextPreviousButtonsAlpha()
    }
    override func viewWillAppear(_ animated: Bool)
    {
        favPhotos = MyPlaceFavPhoto.fetchFavPhotos()
        photosDetailTable.reloadData()
    }
    func fillDayDataForQLDSA()
    {
        if isFromNotifications {return}
        dayWisePhotoList = monthWisePhotoList.list[selectedDayIndex]
    }
    func fillDayDataForVLC()
    {
        
    }
    func updateViewIfFromNotifications()
    {
        if isFromNotifications
        {
            for view in topDescriptionView.subviews
            {
                if view is UILabel
                {
                    
                }else
                {
                    view.isHidden = true
                }
            }
        }
    }
    func updateMonthAndYearLabelForQLDSA()
    {
      //  monthLabel.text = String(format: "%@", presentMonthName)
      //  yearLabel.text = String(format: "%d", presentYear)
        let monthName = getMonthNameWith(id: yearMonthNumber%100)
        let year = yearMonthNumber/100
        if dayWisePhotoList == nil{return}
        self.dateAndMonthLabel.text = "\(dayWisePhotoList.day) \(monthName)"
        self.yearLabel.text = "\(year)"
    }
    func updateMonthAndYearLabelForVLC()
    {
        let monthName = getMonthNameWith(id: photosInfo?.month ?? 0)
        let photoAddedDate = photosInfo?.myPlacePhotos[selectedImgViewIndex].dateCreated ?? 01
        self.dateAndMonthLabel.text = "\(photoAddedDate) \(monthName)"
        self.yearLabel.text = "\(photosInfo?.year ?? 2017)"
    }
    /**
     Back button action
     
     - parameter sender: button object
     */
    // MARK: Button action
    @IBAction func backTapped(_ sender: AnyObject) {

        _  = self.navigationController?.popViewController(animated: true)

        
        if isFromNotifications
        {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
    }
    @IBAction func nextButtonTapped(_ sender: UIButton)
    {
        if dayWisePhotoList == nil{
            return
        }
        selectedDayIndex = min(monthWisePhotoList.list.count - 1, selectedDayIndex + 1)
        updateNextPreviousButtonsAlpha()
        reloadList()
    }
    @IBAction func previousButtonTapped(_ sender: UIButton)
    {
        if dayWisePhotoList == nil{
            return
        }
        selectedDayIndex = max(0, selectedDayIndex - 1)
        updateNextPreviousButtonsAlpha()
        reloadList()
    }
    func updateNextPreviousButtonsAlpha()
    {
        if isFromNotifications {return}
        previousButton.alpha = selectedDayIndex == 0 ?  0 : 1
        nextButton.alpha = selectedDayIndex == monthWisePhotoList.list.count - 1 ? 0 : 1
    }
    func reloadList()
    {
        dayWisePhotoList = monthWisePhotoList.list[selectedDayIndex]
        yearMonthNumber = monthWisePhotoList.yearMonth
        updateMonthAndYearLabelForQLDSA()
        photosDetailTable.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: Table View DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        func countForVLC() -> Int
        {
            if let myPlacePhotos = photosInfo?.myPlacePhotos {
                return myPlacePhotos.count
            }
            return 0
        }
        func countForQLD() -> Int
        {
            return dayWisePhotoList == nil ? 0 : dayWisePhotoList.list.count
        }
        return selectedJobNumberRegion == .OLD ? countForVLC() : countForQLD()
    }
    
    lazy var imageID = selectedJobNumberRegion == .OLD ? self.photosInfo?.myPlacePhotos[0].imageId : self.dayWisePhotoList.list[0].urlId
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoDetailCell")as! MyPlacePhotoDetailCell
        cell.selectionStyle = .none
        cell.favButton.isSelected = false
        cell.fullScreenButton.tag = indexPath.row
        cell.imageScrollView.tag = indexPath.row
        cell.zoomString = ""
        
        func fillCellForVLC()
        {
            let myPlacePhoto = photosInfo?.myPlacePhotos[indexPath.row]
            cell.photoInfoForVIC = myPlacePhoto
            favPhotos?.forEach({ (favPhoto) in
                if favPhoto.imageID ?? "" == "\(myPlacePhoto?.imageId ?? 0)"
                {
                    cell.favButton.isSelected = true
                }
                
            })
            imageID = myPlacePhoto?.imageId ?? 0
        }
        func fillCellForQLDSA()
        {
            let photoInfo = dayWisePhotoList.list[indexPath.row]
            cell.photoInfo = photoInfo
            favPhotos?.forEach({ (favPhoto) in
                if favPhoto.urlID ?? "" == "\(photoInfo.urlId)"
                {
                    cell.favButton.isSelected = true
                }
            })
            imageID = photoInfo.urlId
        }
        selectedJobNumberRegion == .OLD ? fillCellForVLC() : fillCellForQLDSA()
        
        cell.addNotesButton.tag = indexPath.row
        cell.addNotesButton.addTarget(self, action: #selector(handleAddNotesButtonTapped(sender:)), for: .touchUpInside)
        let note = "Notes\n\n\n\(MyPlacePhotoNote.fetchPhotoNote("\(imageID ?? 0)")?.noteDescription ?? "")"
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
                constraint.constant = min(250, noteLabelHeight)
            }
        })
        
        return cell
    }
    
    @objc func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
//        let note = "Notes:\n\n\n\(MyPlacePhotoNote.fetchPhotoNote("\(imageID ?? 0)")?.noteDescription ?? "")"
//        let noteTextHeight = note.rectForText(font: burbankFont(size: 16.0), maxSize: CGSize(width: 100, height: 0))
//        let height = noteTextHeight > 260 ? noteTextHeight/4 : 0
        
        
//            let note = "Notes:\n\n\n\(MyPlacePhotoNote.fetchPhotoNote("\(imageID ?? 0)")?.noteDescription ?? "")"
//            let noteTextHeight = note.rectForText(font: burbankFont(size: 16.0), maxSize: CGSize(width: 100, height: 0))
//            let height = noteTextHeight > 260 ? noteTextHeight/4 : 0
//            let CELLHEIGHT = tableView.frame.size.height/1.26
//            return CELLHEIGHT + height
        
        
        return CELLHEIGHT //+ height
    }
    @objc func handleAddNotesButtonTapped(sender: UIButton)
    {
        
        
        CodeManager.sharedInstance.sendScreenName(photos_add_button_touch)
        
        
        
        let storyBoard = UIStoryboard(name: "Main_OLD", bundle: nil)
        let notesVC = storyBoard.instantiateViewController(withIdentifier: "MyPhotosNotesVCID") as! MyPhotosNotesVC
        func fillForQLDSA()
        {
           let photoInfo = dayWisePhotoList.list[sender.tag]
            notesVC.photoInfo = photoInfo
            notesVC.imageId = "\(photoInfo.urlId)"
        }
        func fillForVLC()
        {
             let myPlacePhoto = photosInfo?.myPlacePhotos[sender.tag]
            notesVC.imageId = "\(myPlacePhoto?.imageId ?? 0)"
        }
        selectedJobNumberRegion == .OLD ? fillForVLC() : fillForQLDSA()
        
        notesVC.addedNoteAction = {
            
            self.photosDetailTable.reloadData()
        }
        
        self.present(notesVC, animated: true, completion: nil)
        
        
    }
    
    @IBAction func fullScreenTapped(_ sender: UIButton) {
        
        
        CodeManager.sharedInstance.sendScreenName(photos_fullscreen_button_touch)
        
        
        let indexPath = NSIndexPath(row: sender.tag, section: 0)
        let cell = photosDetailTable.cellForRow(at: indexPath as IndexPath) as! MyPlacePhotoDetailCell
        
        CodeManager.sharedInstance.openImageLikePop(frame: cell.mainImage.frame, imageObj: (cell.mainImage.image)!)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
@objc protocol favPhotosProtocal
{
    @objc optional func favPhotoDeleted()
}
    class MyPlacePhotoDetailCell: UITableViewCell, UIScrollViewDelegate
    {
        @IBOutlet weak var imageScrollView: UIScrollView!
        @IBOutlet weak var mainImage: UIImageView!
        @IBOutlet weak var descriptionLabel: UILabel!
        @IBOutlet weak var favButton: UIButton!
        @IBOutlet weak var addNotesButton: UIButton!
        @IBOutlet weak var notesLabel: UILabel!
        @IBOutlet weak var fullScreenButton: UIButton!
        
        var imageID = "0" //we are filling imageID according to region Select
        var delegate: favPhotosProtocal?
        var photoInfo: MyPlaceDocuments?
        {
            didSet
            {
                guard let photoInfo = photoInfo else {return}
                CodeManager.sharedInstance.downloadandShowImage(photoInfo,mainImage)
               // print(docDate)
                descriptionLabel.text = "photo added on \(photoInfo.docDate.displayInTimeFormat())"
//                descriptionLabel.text = "Date taken: \(photoInfo.docDate)"

                imageID = "\(photoInfo.urlId)"
            }
        }
        var photoInfoForVIC: MyPlacePhotos?
        {
            didSet
            {
                guard let photoInfoForVIC = photoInfoForVIC else {return}
                if let imagePath = photoInfoForVIC.imagePath
                {
                    let trimmedImagePath = imagePath.trimmingCharacters(in: NSCharacterSet.whitespaces)
                    mainImage.loadImageUsingCacheUrlString(urlString: trimmedImagePath)
                    descriptionLabel.text = "photo added on \((photoInfoForVIC.dateUploaded ?? "").displayInTimeFormat())"
//                    descriptionLabel.text = "Date taken: \(photoInfoForVIC.dateUploaded ?? "")"
                    imageID = "\(photoInfoForVIC.imageId)"
                }
            }
        }
        
        var zoomString: String? {
            
            didSet {
                
                let zoomScrollView = imageScrollView
                
                zoomScrollView!.alwaysBounceVertical = false
                zoomScrollView!.alwaysBounceHorizontal = false
                zoomScrollView!.showsVerticalScrollIndicator = true
                zoomScrollView!.flashScrollIndicators()
                
                zoomScrollView!.minimumZoomScale = 1.0
                zoomScrollView!.maximumZoomScale = 10.0
                zoomScrollView!.zoomScale = 1.0
                zoomScrollView!.delegate = self;
                
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onDoubleTap(gestureRecognizer:)))
                tapRecognizer.numberOfTapsRequired = 2
                zoomScrollView!.addGestureRecognizer(tapRecognizer)
                
            }
            
        }
        
        @objc func onDoubleTap(gestureRecognizer: UITapGestureRecognizer) {
            
            let scale = min(imageScrollView.zoomScale * 2, imageScrollView.maximumZoomScale)
            
            if scale != imageScrollView.zoomScale {
                let point = gestureRecognizer.location(in: imageScrollView.subviews[0])
                
                let scrollSize = imageScrollView.frame.size
                let size = CGSize(width: scrollSize.width / scale,
                                  height: scrollSize.height / scale)
                let origin = CGPoint(x: point.x - size.width / 2,
                                     y: point.y - size.height / 2)
                imageScrollView.zoom(to:CGRect(origin: origin, size: size), animated: true)
            }
        }
        
        // MARK: ScrollView Delegate methods
        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return self.mainImage
        }
        
        
        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
            
            addNotesButton.layer.cornerRadius = addNotesButton.frame.size.height/2

            setAppearanceFor(view: addNotesButton, backgroundColor: COLOR_WHITE, textColor: COLOR_ORANGE, textFont: FONT_LABEL_SUB_HEADING(size: FONT_12))
            setBorder(view: addNotesButton, color: COLOR_ORANGE, width: 1.0)
            
            favButton.setImage(UIImage.init(named: "Ico-favorite-Orange"), for: .normal)
            favButton.setImage(UIImage.init(named: "Ico-favorite-Select"), for: .selected)

        }
        
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
            
            // Configure the view for the selected state
        }
        // MARK: - Button Actions
        @IBAction func favouriteButtonTapped(sender: UIButton)
        {
            
            CodeManager.sharedInstance.sendScreenName(photos_fav_symbol_touch)
            
            
            func addFavPhotoForQLDSA()
            {
                guard let photoInfo = photoInfo else {return}
                MyPlaceFavPhoto.addFavPhotoForQLDSA(photoInfo)
            }
            func addFavPhotoForVIC()
            {
                guard let photoInfoForVIC = photoInfoForVIC else {return}
                MyPlaceFavPhoto.addFavPhotoForVIC(photoInfoForVIC)
            }
            if sender.isSelected == false
            {
                //need to add fav.
                selectedJobNumberRegion == .OLD ? addFavPhotoForVIC() : addFavPhotoForQLDSA()
            }else
            {
                //need to delete fav
             
//                func deleteFavPhotoForQLDSA()
//                {
//                    guard let photoInfo = photoInfo else {return}
//                    MyPlaceFavPhoto.deleteFavPhotoForQLDSA(photoInfo)
//                }
//                func deleteFavPhotoForVIC()
//                {
//                    guard let photoInfoForVIC = photoInfoForVIC else {return}
//                    MyPlaceFavPhoto.deleteFavPhotoForVLC(photoInfoForVIC)
//                }
//                 selectedJobNumberRegion == .VLC ? deleteFavPhotoForVIC() : deleteFavPhotoForQLDSA()
                MyPlaceFavPhoto.deleteFavPhotoWithImageID("\(imageID)")
                delegate?.favPhotoDeleted!()
            }
            sender.isSelected = !sender.isSelected
            
        }
        
    }



