//
//  MyPlacePhotosVC.swift
//  BurbankApp
//
//  Created by dmss on 04/05/17.
//  Copyright © 2017 DMSS. All rights reserved.
//

import UIKit


class MyPlacePhotosVC: BurbankAppVC/*MyPlaceWithTabBarVC*/,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,MyPlacePhotosProtocal//UICollectionViewDelegateFlowLayout
{
    
    @IBOutlet weak var titleLabel : UILabel!

    @IBOutlet weak var photosGridView: UICollectionView!
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var noPhotosLabel: UILabel!
  
    @IBOutlet weak var nextButtonImgView: UIImageView!
    @IBOutlet weak var previousButtonImgView: UIImageView!
    
    var presentMonth : nameOfMonths = .None
    var presentYear = 2017
    var constructionID = 10155
    var myPlacePhotosArray = [MyPlacePhotos]()
    var presentMonthName : String
    {
        let monthId = presentMonth.rawValue
        return getMonthNameWith(id: monthId)
    }
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var photoDateCreatedArray = [Int]()
    var myPlacePhotoInfoArray = [Int: [MyPlacePhotos]]()
    var myPlacePhotosListArray = [MyPlacePhotosWithDateInfo]()
    var myPlacePhotosToDisplay = [MyPlacePhotos]()
    var presentMonthIndex = 0
    var selectedIndexForQLDSA = 0
    var yearMonthPhotoListArray = [YearMonthList]()
    // MARK: - View Cycle Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setAppearanceFor(view: titleLabel, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_LABEL_HEADING(size: FONT_18))
        
        
//        let cellWidth : CGFloat = SCREEN_WIDTH - 2.0 //photosGridView.frame.size.width
//        let height = SCREEN_HEIGHT - SCREEN_HEIGHT * 0.095 - SCREEN_HEIGHT * 0.11
//        let cellheight : CGFloat = height / 2.25//- 2.0
//        let cellSize = CGSize(width: cellWidth , height:cellheight)
        
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical //.horizontal
//        layout.itemSize = cellSize
//        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
//        layout.minimumLineSpacing = 0
//        layout.minimumInteritemSpacing = 0
//
//        photosGridView.setCollectionViewLayout(layout, animated: true)
        
        constructionID = Int(appDelegate.myPlaceStatusDetails?.constructionID ?? "") ?? 1
        photosGridView.dataSource = self
        photosGridView.delegate = self
        
        
        let today = Date()
       
        presentMonth = nameOfMonths(rawValue: today.monthNumber)! //nameOfMonths(rawValue: today.monthNumber())!
        presentYear = today.presentYear
       // updateMonthAndYearLabel()
        getPresentMonthPhotosList()
        self.updateNextPreviousButtonsAlpha()
        
        setAppearanceFor(view: noPhotosLabel, backgroundColor: COLOR_CLEAR, textColor: COLOR_WHITE, textFont: FONT_LABEL_HEADING(size: FONT_18))
        
        setAppearanceFor(view: monthLabel, backgroundColor: COLOR_CLEAR, textColor: COLOR_WHITE, textFont: FONT_LABEL_HEADING (size: FONT_16))
        
        noPhotosLabel.isHidden = true

    }
  
    
    func getPresentMonthPhotosList()
    {
        self.photoDateCreatedArray.removeAll()
        self.myPlacePhotoInfoArray.removeAll()
        self.myPlacePhotosArray.removeAll()
        self.photosGridView.reloadData()

        selectedJobNumberRegion == .OLD ? getPresentMonthListForVLC() : getPresentMonthListForQLDSA()
   
    }
    func getPresentMonthListForVLC()
    {
        if appDelegate.myPlaceStatusDetails?.constructionID == ""
        {
            AlertManager.sharedInstance.showAlert(alertMessage: "Photo's not available", title: "")
            return
        }
        let MyPlacePhotosURL = String(format: "%@photos/GetAllPhotosByConstructionId/",getMyPlaceURL())
        guard let myPlaceProgressDetails = appDelegate.myPlaceStatusDetails else { return }
        let newURL = String(format: "%@%@", MyPlacePhotosURL,myPlaceProgressDetails.constructionID)
        ServiceSession.shared.callToGetDataFromServerWithGivenURLString(newURL, withactivity: true) { (json) in
            if let jsonArray = json as? NSArray
            {
                for jsonObj in jsonArray
                {
                    let jsonDic = jsonObj as! [String: Any]
                    
                    let myplacePhotosInfo = MyPlacePhotosWithDateInfo(dic: jsonDic)
                    self.myPlacePhotosListArray.append(myplacePhotosInfo)
                    
                }
                let presentMonthPhotos = self.myPlacePhotosListArray[0].myPlacePhotos
                self.convertMyPlacePhotosListArrayToDisplayFlowModel(myPlacePhotos: presentMonthPhotos)
                self.presentMonthIndex = 0
                self.updateNextPreviousButtonsAlpha()
            }
        }
    }
    func getPresentMonthListForQLDSA()
    {
        MyPlaceServiceSession.shared.callToGetDataFromServer(myPlaceDocumentsDetailsURLString(), successBlock: { (json, response) in
           
            if let jsonArray = json as? NSArray
            {
                var photoInfoList = [MyPlaceDocuments]()
                for obj in jsonArray
                {
                    if let jsonDic = obj as? [String: Any]
                    {
                        let photoInfo = MyPlaceDocuments(jsonDic)
                      //  print(photoInfo.type.uppercased())
                        if photoInfo.type.uppercased() != kPDF
                        {
                           // let dateFormater = DateFormatter()
                           // dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.zzz"
                            let date = photoInfo.docDate.stringToDateConverter()//dateFormater.date(from: photoInfo.docDate)
                            let month = date?.monthNumber ?? 1
                            let monthStr = month < 10 ? String(format:"%02d",month) : "\(month)"
                            let dayValue = date?.dayValue ?? 1
                            let presetnYearStr = "\(date?.presentYear ?? 1)\(monthStr)"
                            let presentYearInt = Int(presetnYearStr) ?? 0
                            photoInfoList.append(photoInfo)
                            var isListAdded = false
                            self.yearMonthPhotoListArray.forEach({ (yearMonthList) in
                                if yearMonthList.yearMonth == presentYearInt
                                {
                                    isListAdded = true
                                    var isDayAdded = false
                                    yearMonthList.list.forEach({ (dayList) in
                                        if dayList.day == dayValue
                                        {
                                            isDayAdded = true
                                            dayList.list.append(photoInfo)
                                        }
                                        
                                    })
                                    if isDayAdded == false
                                    {
                                        let dayList = DayWisePhotoList(dayValue,[photoInfo])
                                        yearMonthList.list.append(dayList)
                                    }
                                    // yearMonthList.list.append(photoInfo)
                                }
                            })
                            if isListAdded == false
                            {
                                let dayList = DayWisePhotoList(dayValue,[photoInfo])
                                let yearMonthList = YearMonthList(yearMonth: presentYearInt, list: [dayList])
                                self.yearMonthPhotoListArray.append(yearMonthList)
                            }
                            // monthYearIntArray.append(<#T##newElement: Int##Int#>)
                        }
                    }
                }
                self.yearMonthPhotoListArray = self.yearMonthPhotoListArray.sorted(by: { (yearMonthList1, yearMonthList2) -> Bool in
                    return yearMonthList1.yearMonth < yearMonthList2.yearMonth
                })
                self.selectedIndexForQLDSA = self.yearMonthPhotoListArray.count - 1
                self.photosGridView.reloadData()
                self.updateNextPreviousButtonsAlpha()
            }
        }, errorBlock: { (error, isJSON) in
            //
        })
    }
    func convertMyPlacePhotosListArrayToDisplayFlowModel(myPlacePhotos:[MyPlacePhotos])
    {
        if myPlacePhotos.count == 0
        {
            return
        }
        if let monthNumber = myPlacePhotos[0].monthCreatedId , let year = myPlacePhotos[0].yearCreated
        {
            presentMonth = nameOfMonths(rawValue: monthNumber)!
            presentYear = year
            updateMonthAndYearLabel()
        }
        self.photoDateCreatedArray.removeAll()
        for myPlacePhoto in myPlacePhotos
        {
            if let dateCreated = myPlacePhoto.dateCreated
            {
                if self.photoDateCreatedArray.count == 0
                {
                    self.photoDateCreatedArray.append(dateCreated)
                }
                self.photoDateCreatedArray.forEach({ (num) in
                    if num != dateCreated
                    {
                        self.photoDateCreatedArray.append(dateCreated)
                    }
                })
            }
            
        }
        self.myPlacePhotoInfoArray.removeAll()
        for dateCreated in self.photoDateCreatedArray
        {
            var tempPhotosArray = [MyPlacePhotos]()
            tempPhotosArray.removeAll()
            myPlacePhotos.forEach({ (myplacePhotosDic) in
                
                if myplacePhotosDic.dateCreated == dateCreated
                {
                    tempPhotosArray.append(myplacePhotosDic)
                    self.myPlacePhotoInfoArray[dateCreated]?.removeAll()
                    self.myPlacePhotoInfoArray[dateCreated] = tempPhotosArray
                }
            })
        }
        self.photosGridView.reloadData()
        
    }
    func updateMonthAndYearLabel()
    {
        let mutableText = NSMutableAttributedString(string: "\(presentMonthName)".uppercased(), attributes: [:])
        mutableText.append(NSAttributedString(string: "\n\(presentYear)", attributes: [NSAttributedString.Key.font: UIFont(name: monthLabel.font.fontName, size: monthLabel.font.pointSize)!]))
        monthLabel.attributedText = mutableText //String(format: "%@", presentMonthName)
       // yearLabel.text = String(format: "%d", presentYear)
        
        print("\(presentMonthName)".uppercased())
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showMyPlacePhotosDetailVC"
        {
            let destination = segue.destination as! MyPlacePhotoDetailVC
            func fillDataForVLC()
            {
                destination.photosInfo = myPlacePhotosListArray[presentMonthIndex]
                if let selectedViewTag = sender as? Int
                {
                    destination.selectedImgViewIndex = selectedViewTag
                    
                }
            }
            func fillDataForQLDSA()
            {
                destination.yearMonthNumber = self.yearMonthPhotoListArray[selectedIndexForQLDSA].yearMonth
                guard let  indexs = sender as? [Int] else {return}
              //  destination.dayWisePhotoList = self.yearMonthPhotoListArray[selectedIndexForQLDSA].list[indexs[1]] //1 is list index in sender
                destination.selectedDayIndex = indexs[1]
                destination.monthWisePhotoList = self.yearMonthPhotoListArray[selectedIndexForQLDSA]
                destination.selectedImgViewIndex = indexs[0] //0 is selected  Image index in sender
            }
            selectedJobNumberRegion == .OLD ? fillDataForVLC() : fillDataForQLDSA()
        }
    }
    // MARK: - collectionview DataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        func countForVLC() -> Int
        {
            if myPlacePhotoInfoArray.count == 0
            {
                self.view.bringSubviewToFront(noPhotosLabel)
                noPhotosLabel.isHidden = false
            }else
            {
                noPhotosLabel.isHidden = true
            }
            return myPlacePhotoInfoArray.count
        }
        func countForQLDSA() -> Int
        {
            if yearMonthPhotoListArray.count == 0
            {
                self.view.bringSubviewToFront(noPhotosLabel)
                noPhotosLabel.isHidden = false
            }else
            {
                noPhotosLabel.isHidden = true
            }
            return yearMonthPhotoListArray.count == 0 ? 0 : yearMonthPhotoListArray[selectedIndexForQLDSA].list.count
        }
        
        return selectedJobNumberRegion == .OLD ? countForVLC() : countForQLDSA()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellID = "CellID"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MyPlacePhotosCVCell
        cell.photosGrid.tag = indexPath.row
        cell.photosGrid.layoutIfNeeded()
        
        
        func fillCellForVLC()
        {
            let myPlacePhotosInfo = myPlacePhotosListArray[indexPath.row]
            _ = myPlacePhotosInfo.myPlacePhotos
            let dateCreated = photoDateCreatedArray[indexPath.row] //myPlacePhotosArray[indexPath.row].dateCreated
            var photsToDisplayArray = [MyPlacePhotos]()
            photsToDisplayArray.removeAll()
            myPlacePhotoInfoArray.forEach { (dateAdded: Int ,photosArray: [MyPlacePhotos]) in
                //
                if dateAdded == dateCreated
                {
                    photsToDisplayArray = photosArray
                }
            }
            cell.dateLabel.text = String(format: "%d", dateCreated)
            
            let refPhotosDic = photsToDisplayArray[indexPath.row]
            if let monthCreatedID = refPhotosDic.monthCreatedId, let yearCreated = refPhotosDic.yearCreated , let dateUploadedString = refPhotosDic.dateUploaded
            {
                let monthName = getMonthNameWith(id: monthCreatedID)
                let monthYearWeekNameAttributedText = NSMutableAttributedString(string: "\(monthName.uppercased()) \(yearCreated)", attributes: [:])
                let dateFormater = DateFormatter()
                dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                let dateUploaded = dateFormater.date(from: dateUploadedString)
                let weekNum = dateUploaded?.dayNumberOfWeek()
                let weekName = getWeekName(weekNum: weekNum!)
                #if DEDEBUG
                print(weekName)
                #endif
                monthYearWeekNameAttributedText.append(NSAttributedString(string: "\n\(weekName)", attributes: [NSAttributedString.Key.font: UIFont(name: cell.monthAndYearLabel.font.fontName, size: 15)!]))
                cell.monthAndYearLabel.attributedText = monthYearWeekNameAttributedText //String(format: "%@ %d", monthName, yearCreated)
            }
//            if let dateUploadedString = refPhotosDic.dateUploaded
//            {
//                let dateFormater = DateFormatter()
//                dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
//                let dateUploaded = dateFormater.date(from: dateUploadedString)
//                let weekNum = dateUploaded?.dayNumberOfWeek()
//                let weekName = getWeekName(weekNum: weekNum!)
//                print(weekName)
//                cell.weekNameLabel.text = String(format: "%@", weekName)
//            }
            
            cell.photosArray.removeAll()
            cell.photosArray =  photsToDisplayArray
            cell.photosGrid.reloadData()
            cell.delegate = self
            
//            if cell.photosArray.count > numOfPhotosToDisplay {
//                cell.photosGrid.showsVerticalScrollIndicator = true
//            }else {
//                cell.photosGrid.showsVerticalScrollIndicator = false
//            }
            
        }
        func fillCellForQLD()
        {
            let yearMonthList = self.yearMonthPhotoListArray[selectedIndexForQLDSA]
            let dayWiseList = yearMonthList.list[indexPath.row]
            cell.dateLabel.text = "\(dayWiseList.day)"
            let monthName = getMonthNameWith(id: yearMonthList.yearMonth%100)
            let year = yearMonthList.yearMonth/100
            let yearFont = UIFont(name: monthLabel.font.fontName, size: monthLabel.font.pointSize)
            let mutableText = NSMutableAttributedString(string: "\(monthName)".uppercased(), attributes: [:])
            mutableText.append(NSAttributedString(string: "\n\(year)", attributes: [NSAttributedString.Key.font: yearFont!]))
            let monthYearWeekNameAttributedText = NSMutableAttributedString(string: "\(monthName) \(year)", attributes: [:])
            let weekNum = dayWiseList.list[0].docDate.stringToDateConverter()?.dayNumberOfWeek() ?? 0
            let weekName = getWeekName(weekNum: weekNum)
            #if DEDEBUG
            print(weekName)
            #endif
            monthYearWeekNameAttributedText.append(NSAttributedString(string: "\n\(weekName)", attributes: [NSAttributedString.Key.font: UIFont(name: cell.monthAndYearLabel.font.fontName, size: 15)!]))
            cell.monthAndYearLabel.attributedText = monthYearWeekNameAttributedText//"\(monthName) \(year)"
            
            cell.monthAndYearLabel.text = weekName
            
            self.monthLabel.attributedText = mutableText
           // self.yearLabel.text = "\(year)"
            
            print("\(monthName)".uppercased())
            
            
            cell.photoListForQLDSA.removeAll()
            cell.photoListForQLDSA = dayWiseList.list
            cell.delegate = self
            cell.photosGrid.reloadData()
        }
        
        
        selectedJobNumberRegion == .OLD ? fillCellForVLC() : fillCellForQLD()
        
        
        return cell
    }
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let height = collectionView.frame.size.height / 2.25
//        let width = collectionView.frame.size.width
        let cellWidth : CGFloat = SCREEN_WIDTH - 2.0 //photosGridView.frame.size.width
        _ = SCREEN_HEIGHT - SCREEN_HEIGHT * 0.095 - SCREEN_HEIGHT * 0.11
        func sizeForVLC() -> CGSize
        {
            let cellWidth : CGFloat = SCREEN_WIDTH - 2.0 //photosGridView.frame.size.width
            let height = SCREEN_HEIGHT - SCREEN_HEIGHT * 0.095 - SCREEN_HEIGHT * 0.11
            let cellheight : CGFloat = height / 2.25//- 2.0
            return CGSize(width: cellWidth , height:cellheight)
        }
        func sizeForQLDSA() -> CGSize
        {
            let yearMonthList = self.yearMonthPhotoListArray[selectedIndexForQLDSA]
            let dayWiseList = yearMonthList.list[indexPath.row]//height / 2.25//- 2.0
            #if DEDEBUG
            print(dayWiseList.list.count)
            #endif
            let numOfCells = dayWiseList.list.count/numOfPhotosToDisplay
            let count = dayWiseList.list.count%numOfPhotosToDisplay == 0 ? 0 : 1
            let heightMutliplier = numOfCells + count
            let forOneRow: CGFloat = heightMutliplier == 1 ? 25.0 : 0
            var cvHeight = ((topViewHeight + 62.0 + forOneRow) * CGFloat(heightMutliplier)) //collectionView.frame.size.height - collectionView.frame.size.height * 0.26
            if heightMutliplier == 1 {
                cvHeight = cvHeight + 15
            }
            #if DEDEBUG
            print(cvHeight)
            #endif
            
            return CGSize(width: cellWidth , height:cvHeight)
        }
        
        return selectedJobNumberRegion == .OLD ? sizeForVLC() : sizeForQLDSA()  //cellSize//CGSize(width: width, height: height)
    }
     // MARK: - collectionview Delegate Methods
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    // MARK: - MyPlacePhotosProtocal Methods
    func myPlacePhotoTapped(index: Int)
    {
        CodeManager.sharedInstance.sendScreenName(photo_touch)
        
        self.performSegue(withIdentifier: "showMyPlacePhotosDetailVC", sender: index)
    }
    func photoTappedForQLDSA(_ photoIndex: Int, _ cvIndex: Int)
    {
        self.performSegue(withIdentifier: "showMyPlacePhotosDetailVC", sender: [photoIndex,cvIndex])
    }
    // MARK: - IBActions
    @IBAction  func nextButtonTapped(sender: AnyObject?)
    {
//        let today = Date()
//        let todayMonth = today.monthNumber
//        let todayYear = today.presentYear
//        if presentMonth.rawValue == todayMonth && presentYear == todayYear
//        {
//            return
//        }
//        if presentMonth == .December
//        {
//            presentYear = presentYear + 1
//            presentMonth = .NoName
//        }
//        let nextMonth = presentMonth.rawValue + 1
//        presentMonth = nameOfMonths(rawValue: nextMonth)!
//        
//        updateMonthAndYearLabel()
//        getPresentMonthPhotosList()
       func handleForVLC()
       {
        presentMonthIndex = presentMonthIndex - 1
        if presentMonthIndex < 0
        {
            presentMonthIndex = 0
            return
        }
        let presentMonthPhotos = myPlacePhotosListArray[presentMonthIndex].myPlacePhotos
        convertMyPlacePhotosListArrayToDisplayFlowModel(myPlacePhotos: presentMonthPhotos)
        }
        func handleForQLDSA()
        {
            selectedIndexForQLDSA = min(self.yearMonthPhotoListArray.count - 1, selectedIndexForQLDSA+1)
            photosGridView.reloadData()
        }
        selectedJobNumberRegion == .OLD ? handleForVLC() : handleForQLDSA()
        updateNextPreviousButtonsAlpha()
    }
    @IBAction  func PreviousButtonTapped(sender: AnyObject?)
    {
//        if presentMonth == .January
//        {
//            presentYear = presentYear - 1
//            presentMonth = .None
//        }
//        
//        let previousMonth = presentMonth.rawValue - 1
//        presentMonth = nameOfMonths(rawValue: previousMonth)!
        
       func handleForVLC()
       {
        presentMonthIndex = presentMonthIndex + 1
        if presentMonthIndex >= self.myPlacePhotosListArray.count
        {
            presentMonthIndex = self.myPlacePhotosListArray.count - 1
            return
        }
        let presentMonthPhotos = myPlacePhotosListArray[presentMonthIndex].myPlacePhotos
        convertMyPlacePhotosListArrayToDisplayFlowModel(myPlacePhotos: presentMonthPhotos)
        }
        func handleForQLDSA()
        {
            selectedIndexForQLDSA = max(0, selectedIndexForQLDSA-1)
            photosGridView.reloadData()
        }
        selectedJobNumberRegion == .OLD ? handleForVLC() : handleForQLDSA()
        updateNextPreviousButtonsAlpha()
       // updateMonthAndYearLabel()
       // getPresentMonthPhotosList()
    }
    func updateNextPreviousButtonsAlpha()
    {
        let selectedDayIndex = selectedJobNumberRegion == .OLD ? presentMonthIndex : selectedIndexForQLDSA
        let maxCount = selectedJobNumberRegion == .OLD ? myPlacePhotosListArray.count : yearMonthPhotoListArray.count
        previousButtonImgView.alpha = selectedDayIndex <= 0 ?  0 : 1
        nextButtonImgView.alpha = selectedDayIndex >= maxCount - 1 ? 0 : 1
    }
    @IBAction func backButtonTapped(sender: AnyObject?)
    {
        
        CodeManager.sharedInstance.sendScreenName(photos_back_button_touch)
        
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}

class MyPlacePhotosWithDateInfo
{
    var month: Int?
    var year: Int?
    var myPlacePhotos = [MyPlacePhotos]()
    init(dic: [String: Any])
    {
        month = dic["Month"] as? Int
        year = dic["Year"] as? Int
        if let myPlacePhotosArray = dic["Photos"] as? NSArray
        {
            for myPlacePhotoInfo in myPlacePhotosArray
            {
                let myplacePhoto = MyPlacePhotos(dic: myPlacePhotoInfo as! [String : Any])
                myPlacePhotos.append(myplacePhoto)
            }
        }
    }
}

class MyPlacePhotos
{
    var imagePath : String?
    var dateCreated: Int?
    var monthCreatedId: Int?
    var yearCreated: Int?
    var dateUploaded: String?
    var imageId: Int
    init(dic: [String: Any])
    {
        imagePath = dic["ImagePath"] as? String
        dateCreated = dic["Day"] as? Int
        monthCreatedId = dic["Month"] as? Int
        yearCreated = dic["Year"] as? Int
        dateUploaded = dic["DateUploaded"] as? String
        imageId = dic["Id"] as? Int ?? 0
    }
}
