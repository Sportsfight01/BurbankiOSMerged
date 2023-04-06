//
//  MenuVC.swift
//  Burbank
//
//  Created by Madhusudhan on 03/03/16.
//  Copyright © 2016 DMSS. All rights reserved.
//

import UIKit


class MenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var menuTableView : UITableView!
    @IBOutlet weak var noNotificationsLabel: UILabel!
    @IBOutlet weak var jobNumberTextField: UITextField!
    var menuOpenLayerView : UIControl!
//    struct PhotoList
//    {
//        var docDate: String
//        var photoList: [MyPlaceDocuments]
//    }
    struct StageList
    {
        var stageName: String
        var completedStages: [MyPlaceProgressDetails]
    }
   // var photoListArray = [PhotoList]()
  //  var stageListArray = [StageList]()
    var dayWisePhotoList = [DayWisePhotoList<MyPlaceDocuments>]()
    var storedDayWisePhotoList = [DayWisePhotoList<MyPlaceStoredPhotoInfo>]()
    var completedStageListArray = [MyPlaceProgressDetails]()
    var completedStageList = [MyPlaceStageCompleteDetails]()
    var stageChangeList = [MyPlaceStoredProgressDetails]()
  //  var photoListWithDocDate = [String:[MyPlaceDocuments]]()
    var stagesProgressDetailsDic = [String: [MyPlaceProgressDetails]]()
    var notificationListArray = NSMutableArray()
    var currentJobNumber = ""
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    // MARK: View life cycle methods
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentJobNumber = getJobNumber()
        
//        let notificationType = NotificationTypes.getSelectedNotificationType()
//        if notificationType == nil
//        {
//            callServerAndUpdateUserSelectedNotificationTypes()
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        CodeManager.sharedInstance.sendScreenName(notifications_screen_notifications_touch)
        self.setupNavigationBarButtons(title: "", backButton: true, notificationIcon: false)
        noNotificationsLabel.alpha = 0
        
        let notificationType = NotificationTypes.getSelectedNotificationType()
        if notificationType == nil
        {
            notificationListArray.removeAllObjects()
            callServerAndUpdateUserSelectedNotificationTypes()
        }
        let jobNumber = getJobNumber()
        if notificationListArray.count == 0 || currentJobNumber != jobNumber
        {
            notificationListArray.removeAllObjects()
            dayWisePhotoList.removeAll()
          //  photoListArray.removeAll()
            completedStageListArray.removeAll()
            stageChangeList.removeAll()
            
            storedDayWisePhotoList.removeAll()
            completedStageList.removeAll()
            stageChangeList.removeAll()
            currentJobNumber = jobNumber
            reloadList()
            getNotificationList()
        }else
        {
              reloadNotificationList()
        }
     
      
        //self.screenName = ""
        //we have to call this method after checking and done of currentjobnumber filed and jobnumber which user coming from
        fillJobNumber()
 
    }
    func callServerAndUpdateUserSelectedNotificationTypes()
    {
        let userID = appDelegate.currentUser?.userDetailsArray?[0].id
        ServiceSession.shared.callToPostDataToServer(appendUrlString: getProfileURL, postBodyDictionary: ["Id": userID!], completionHandler: {(json) in
            
            let jsonDic = json as! NSDictionary
          
            DispatchQueue.main.async(execute: {
                self.appDelegate.hideActivity()
            })
            
            if let status = jsonDic.object(forKey: "Status") as? Bool
            {
                
                if status == true
                {
                    if let resultArray = jsonDic.object(forKey: "Result") as? NSDictionary
                    {
                        if let notificationType = resultArray.value(forKey: "NotificationTypes") as? NSArray {
                            //  self.notificationArray = (resultArray.value(forKey: "NotificationTypes") as! NSArray).mutableCopy() as! NSMutableArray
                            let photoAdded = (notificationType[0] as? NSDictionary)?.value(forKey: "IsUserOpted") as? Bool ?? true
                            let stageCompleted = (notificationType[1] as? NSDictionary)?.value(forKey: "IsUserOpted") as? Bool ?? true
                            let stageChange = (notificationType[2] as? NSDictionary)?.value(forKey: "IsUserOpted") as? Bool ?? true
                            NotificationTypes.updatedSelectedNotificationType(photoAdded, stageCompleted, stageChanged: stageChange)
                            
                        }
                    }
                }
                else{
                    
                    AlertManager.sharedInstance.alert(jsonDic.value(forKey: "Message") as? String ?? somethingWentWrong)
                }
            }
        })
    }
    fileprivate func fillJobNumber()
    {
        jobNumberTextField.text = appDelegate.currentUser?.jobNumber
    }
    override func viewDidDisappear(_ animated: Bool) {
//        self.revealViewController().frontViewController.view.isUserInteractionEnabled=true
//        menuOpenLayerView.removeFromSuperview()
    }
    func getJobNumber() -> String
    {
        return appDelegate.currentUser?.jobNumber ?? appDelegate.currentUser?.userDetailsArray?[0].myPlaceDetailsArray[0].jobNumber ?? ""
    }
    // MARK: - getPhoto/Stage list logic Methods
    func getNotificationList()
    {
        selectedJobNumberRegion == .OLD ? notifyUserAboutVIC() : getNotificationListForQLDSA()
    }
   
    func notifyUserAboutVIC()
    {
        noNotificationsLabel.alpha = 0.0
       // AlertManager.sharedInstance.showAlert(alertMessage: "Notifications for VIC region will be available after ClickHome3 migration.", title: "")
      presentAlert("Notifications for VIC region will be available after ClickHome3 migration.")
    }
    func presentAlert(_ message: String,_ title: String = "")
    {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.hideNotificationView()
        }))
        noNotificationsLabel.alpha = 1.0
        noNotificationsLabel.text = message
        
        self.view.bringSubviewToFront(noNotificationsLabel)
        
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // appDelegate.window?.rootViewController?.present(alertVC, animated: true, completion: nil)
        //self.present(alertVC, animated: true , completion: nil)
    }
    func getNotificationListForQLDSA()
    {
        let notificationType = NotificationTypes.getSelectedNotificationType()
        let photoAdded = notificationType?.photoAdded
        let stageComplete = notificationType?.stageComplete
        let stageChange = notificationType?.stageChange
        if photoAdded == false && stageComplete == false && stageChange == false
        {
            presentAlert("Notifications Settings are not Enabled, Please enable preferred Notifications from Settings.")
            return
        }
        noNotificationsLabel.alpha = 0
        getPhotosNotificationListForQLDSA() //for photos Notifications
        
    }
    func getPhotosNotificationListForQLDSA()
    {
        MyPlaceServiceSession.shared.callToGetDataFromServer(myPlaceDocumentsDetailsURLString(), successBlock: { (json, response) in
           
            if let jsonArray = json as? NSArray
            {
               // var photoInfoList = [MyPlaceDocuments]()
                
                #if DEDEBUG
                print("++++++++")
                print(jsonArray)
                #endif
                
                for obj in jsonArray
                {
                    if let jsonDic = obj as? [String: Any]
                    {
                        let photoInfo = MyPlaceDocuments(jsonDic)
                        if photoInfo.type.uppercased() == "JPG" || photoInfo.type.uppercased() == "PNG"
                        {
                           // photoInfoList.append(photoInfo)
                            
                            let date = photoInfo.docDate.stringToDateConverter()//dateFormater.date(from: photoInfo.docDate)
                            let month = date?.monthNumber ?? 1
                            let monthStr = month < 10 ? String(format:"%02d",month) : "\(month)"
                            let dayValue = date?.dayValue ?? 1
                            let day = dayValue < 10 ? String(format:"%02d",dayValue) : "\(dayValue)"
                            let presetnYearStr = "\(date?.presentYear ?? 1)\(monthStr)\(day)"
                            // let presentYearInt = Int(presetnYearStr) ?? 0
 //                           var isAdded = false
                            var isPhotoAdded = false

                            self.dayWisePhotoList.forEach({ (photo) in
                                if photo.yyyymmddString == presetnYearStr
                                {
                                    isPhotoAdded = true
                                    var list = photo.list
                                    list.append(photoInfo)
                                    photo.list = list
                                }
                            })
                            if isPhotoAdded == false
                            {
                                let photo = DayWisePhotoList(dayValue,[photoInfo],presetnYearStr)
                                self.dayWisePhotoList.append(photo)
                            }
                            let storedPhotoInfo = MyPlaceStoredPhotoInfo.fetchPhotoInfo(photoInfo.urlId)
                            if storedPhotoInfo == nil
                            {
                                MyPlaceStoredPhotoInfo.addPhotoInfo(photoInfo)
                            }
                        }
                    }
                }
               
               
                self.getStageCompleteNotificationListForQLDSA() //for Stage Complete Notifications
            }
        }, errorBlock: { (error, isJSON) in
            //
            self.getStageCompleteNotificationListForQLDSA()
        })
        
    }
    func getStageCompleteNotificationListForQLDSA()
    {
        #if DEDEBUG
        print(myPlaceProgressDetailsURLString())
        #endif
        
        MyPlaceServiceSession.shared.callToGetDataFromServer(myPlaceProgressDetailsURLString(), successBlock: { (json, response) in
            if let jsonArray = json as? NSArray
            {
                #if DEDEBUG
                print("------")
                print(jsonArray)
                #endif
                
                for obj in jsonArray
                {
                    if let jsonDic = obj as? [String: Any]
                    {
                        let progressDetails = MyPlaceProgressDetails(dic: jsonDic)
                        self.stagesProgressDetailsDic = CodeManager.sharedInstance.fillAndGetMyPlaceProgressDetails(jsonArray)
                        self.calculateProgressValues()
                        if progressDetails.status == kStageCompleted
                        {
                            //  let stage = StageList(stageName: progressDetails.stageName, completedStages: progressDetails)
                            if progressDetails.phasecode == adminStagePhaseCode || progressDetails.stageName == kFrameStage || progressDetails.stageName == kLockUpStage || progressDetails.stageName == kFixoutStage || progressDetails.stageName == kCompletion || progressDetails.stageName == kHandover || progressDetails.stageName == kBaseStage
                            {
                                self.completedStageListArray.append(progressDetails)
                                let completedStageDetails = MyPlaceStageCompleteDetails.fetchProgressDetails(progressDetails.taskid)
                                if completedStageDetails == nil
                                {
                                    MyPlaceStageCompleteDetails.addProgressDetails(progressDetails)
                                }
                            }

                        }
                        let stroredProgressResult = MyPlaceStoredProgressDetails.fetchStoredProgressDetails(progressDetails.taskid)
                        if stroredProgressResult == nil
                        {
                            //need to add stages
                            // MyPlaceStoredProgressDetails.addNotetoPhotoForQLDSA(progressDetails, "", "")
                            MyPlaceStoredProgressDetails.addStoredProgressDetails(progressDetails, progressDetails.status, progressDetails.status)
                        }else
                        {
                            //need to check whether stage is changed or not
                           // progressDetails.status = "toTestPlan"//kCompletion
                            if stroredProgressResult?.currentStatus != progressDetails.status
                            {
                                MyPlaceStoredProgressDetails.updateStoredProgressDetails(progressDetails, stroredProgressResult?.currentStatus ?? "", progressDetails.status)
                            }
                        }
                    }
                }
                
           
                self.reloadNotificationList()
            }
        }, errorBlock: { (error, isJson) in
            self.presentAlert("No Notifications available")
        })
        
    }
    var progressValues = [CGFloat]()
    func calculateProgressValues()
    {
        progressValues.removeAll()
        for i in 0...4 //number of stages are 4
        {
            let progressValue = CodeManager.sharedInstance.calculateProgressValue(stagesProgressDetailsDic[myPlaceStageNames[i]])
            progressValues.append(progressValue)
        }
       // self.performSegue(withIdentifier: "showProgressDetailVC", sender: indexPath.row)
    }
    func reloadNotificationList()
    {
        notificationListArray.removeAllObjects()
        self.stageChangeList.removeAll()
        self.completedStageList.removeAll()
        self.storedDayWisePhotoList.removeAll()
        //        dayWisePhotoList.sort { (list1, list2) -> Bool in
        //            return list1.yyyymmddString > list2.yyyymmddString
        //        }
        if let storedProgressDetails = MyPlaceStoredProgressDetails.fetchAllStoredProgressDetails()
        {
            for progressDetails in storedProgressDetails
            {
                if progressDetails.previousStatus != progressDetails.currentStatus
                {
                    //need to add in stage
                    self.stageChangeList.append(progressDetails)
                }
            }
        }
        self.completedStageList = MyPlaceStageCompleteDetails.fetchAllProgressDetails()!
        guard let photoList = MyPlaceStoredPhotoInfo.fetchAllStoredPhotoInfo() else {return}
        photoList.forEach { (photoInfo) in
            let dateString = photoInfo.docDate ?? ""
            let date = dateString.stringToDateConverter()//dateFormater.date(from: photoInfo.docDate)
            let month = date?.monthNumber ?? 1
            let monthStr = month < 10 ? String(format:"%02d",month) : "\(month)"
            let dayValue = date?.dayValue ?? 1
            let day = dayValue < 10 ? String(format:"%02d",dayValue) : "\(dayValue)"
            let presetnYearStr = "\(date?.presentYear ?? 1)\(monthStr)\(day)"
            // let presentYearInt = Int(presetnYearStr) ?? 0
            //                           var isAdded = false
            var isPhotoAdded = false
            
            self.storedDayWisePhotoList.forEach({ (photo) in
                if photo.yyyymmddString == presetnYearStr
                {
                    isPhotoAdded = true
                    var list = photo.list
                    list.append(photoInfo)
                    photo.list = list
                }
            })
            if isPhotoAdded == false
            {
                let photo = DayWisePhotoList(dayValue,[photoInfo],presetnYearStr)
                self.storedDayWisePhotoList.append(photo)
            }
        }
        // notificationListArray.addObjects(from: photoListArray)
        let notificationTypes = NotificationTypes.getSelectedNotificationType()
        let photoAdded = notificationTypes?.photoAdded
        let stageCompleted = notificationTypes?.stageComplete
        let stageChange = notificationTypes?.stageChange
        if photoAdded == false && stageCompleted == false && stageChange == false
        {
            presentAlert("Notifications Settings are not Enabled, Please enable preffered Notifications from Settings.")
            //            reloadList()
            //            return
        }
        storedDayWisePhotoList.sort { (list1, list2) -> Bool in
            return list1.yyyymmddString > list2.yyyymmddString
        }
        
        
        if photoAdded == true
        {
            notificationListArray.addObjects(from: storedDayWisePhotoList)
        }
        if stageCompleted == true
        {
            notificationListArray.addObjects(from: completedStageList)//completedStageListArray
        }
        if stageChange == true
        {
            notificationListArray.addingObjects(from: stageChangeList)
        }
        
        
//        let datesArray = NSMutableArray()
        
        
        
        let sortedNames = notificationListArray.sorted { (list1, list2) -> Bool in

            if let photoList1 = list1 as? DayWisePhotoList<MyPlaceStoredPhotoInfo> {

                if let photoList2 = list2 as? DayWisePhotoList<MyPlaceStoredPhotoInfo> {

                    return photoList1.yyyymmddString > photoList2.yyyymmddString
                }
                else if let completedStage2 = list2 as? MyPlaceStageCompleteDetails {

                    return ((photoList1.list[0]).docDate)! > (completedStage2.dateActual)!
                }
                else if let stageChange2 = list2 as? MyPlaceStoredProgressDetails {
                    
                    return ((photoList1.list[0]).docDate)! > (stageChange2.dateActual)!
                }
            }
            else if let completedStage1 = list1 as? MyPlaceStageCompleteDetails {
                #if DEDEBUG
                print(completedStage1.dateActual as Any)
                #endif
                if let photoList2 = list2 as? DayWisePhotoList<MyPlaceStoredPhotoInfo> {
                    
                    return (completedStage1.dateActual)! > ((photoList2.list[0]).docDate)!
                }
                else if let completedStage2 = list2 as? MyPlaceStageCompleteDetails {
                    
                    return (completedStage1.dateActual)! > (completedStage2.dateActual)!
                }
                else if let stageChange2 = list2 as? MyPlaceStoredProgressDetails {
                    
                    return (completedStage1.dateActual)! > (stageChange2.dateActual)!
                }
            }
            else if let stageChange1 = list1 as? MyPlaceStoredProgressDetails {
                
                if let photoList2 = list2 as? DayWisePhotoList<MyPlaceStoredPhotoInfo> {
                    
                    return (stageChange1.dateActual)! > ((photoList2.list[0]).docDate)!
                }
                else if let completedStage2 = list2 as? MyPlaceStageCompleteDetails {
                    
                    return (stageChange1.dateActual)! > (completedStage2.dateActual)!
                }
                else if let stageChange2 = list2 as? MyPlaceStoredProgressDetails {
                    
                    return (stageChange1.dateActual)! > (stageChange2.dateActual)!
                }
            }


            return false
        }
        
        #if DEDEBUG
        print(sortedNames)
        #endif
        
        notificationListArray = (sortedNames as NSArray).mutableCopy() as! NSMutableArray
        
//        'Swift._SwiftDeferredNSArray' (0x10558e410) to 'NSMutableArray' (0x10451cea8).
//        2019-03-26 17:30:02.663199+0530 BurbankApp[13605:208279] Could not cast value of type 'Swift._SwiftDeferredNSArray' (0x10558e410) to 'NSMutableArray' (0x10451cea8).
        
//        for value in notificationListArray {
//            if let photoList = value as? DayWisePhotoList<MyPlaceStoredPhotoInfo> {
//                print("++++++++")
//                print(photoList.yyyymmddString)
//            }
//
//            else if let completedStage = value as? MyPlaceStageCompleteDetails {
//                print("------")
//                print(completedStage.dateActual as Any)
//            }
//            else if let stageChange = value as? MyPlaceStoredProgressDetails {
//                print("//////////")
//                print(stageChange.dateActual as Any)
//            }
//        }
        
        
        
        
        //        notificationListArray.addObjects(from: stageChangeList)
        //        struct ListWithDate
        //        {
        //            var dateString: String
        //            var list: NSMutableArray
        //        }
        if notificationListArray.count == 0
        {
            self.appDelegate.notificationCount = notificationListArray.count
            presentAlert("No Notifications to Display")
        }
        else {
            
            #if DEDEBUG
            print(notificationListArray.count)
            #endif
            

            let tempNotificationArray = NSMutableArray()
            
            // remove Read notification from List
            for i in 0..<notificationListArray.count {
                
                let value = notificationListArray[i]
                
                if let photoList = value as? DayWisePhotoList<MyPlaceStoredPhotoInfo> {
                    let photoInfo = photoList.list[0]
                    if photoInfo.isRead == false {
                        tempNotificationArray.add(value)
                    }
                }
                else if let completedStage = value as? MyPlaceStageCompleteDetails {
                    if completedStage.isRead == false {
                        tempNotificationArray.add(value)
                    }
                }
                else if let stageChange = value as? MyPlaceStoredProgressDetails {
                    if stageChange.isRead == false {
                        tempNotificationArray.add(value)
                    }
                }
            }
            
            notificationListArray = tempNotificationArray
            
            #if DEDEBUG
            print(notificationListArray.count)
            #endif
            self.appDelegate.notificationCount = notificationListArray.count
        }
        reloadList()
    }
    func reloadList()
    {
        if notificationListArray.count == 0
        {
            presentAlert("No Notifications to Display")
        }
        menuTableView.reloadData()
    }
     // MARK: - TableView Datasource Methods
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        
        
        return notificationListArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
         let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuTableViewCell
        // let unreadColor = UIColor.init(r: 215, g: 215, b: 215)
        // Configure the cell...
        
       // cell.nameLabel.text = "Home"
         // cell.selectionStyle=UITableViewCellSelectionStyle.none
        let value = notificationListArray[indexPath.row]
        if let photoList = value as? DayWisePhotoList<MyPlaceStoredPhotoInfo>
        {
            let photoInfo = photoList.list[0]
          //  let key = Array(photoListWithDocDate.keys)[indexPath.row]
           // let photoInfo = photoListWithDocDate[key]![0]
            let dateString = photoInfo.docDate ?? ""
            let date = dateString.stringToDateConverter()//dateFormater.date(from: photoInfo.docDate)
            let month = date?.monthNumber ?? 1
            let monthName = getMonthNameWith(id: month)
            //  let monthStr = month < 10 ? String(format:"%02d",month) : "\(month)"
            let dayValue = String(format:"%02d",date?.dayValue ?? 1)//date?.dayValue ?? 1
            let dayString = ""
            let presetnYearStr = "\(dayValue) - \(monthName) - \(date?.presentYear ?? 1)"
            let nameText = NSMutableAttributedString()
            nameText.append(NSMutableAttributedString(string: "Check out the new photos added on \(presetnYearStr)\n", attributes: [:]))
            nameText.append(NSMutableAttributedString(string: "\(date?.getElapsedInterval() ?? "")", attributes: [NSAttributedString.Key.font: ProximaNovaRegular(size: 12),NSAttributedString.Key.foregroundColor: UIColor.black]))
            cell.nameLabel.attributedText = nameText
           // cell.timeLabel.text = "\(date?.timeAgoDisplay() ?? "")"
            cell.iconImageView.image = #imageLiteral(resourceName: "Ico-ImageNotify")
            //cell.contentView.backgroundColor = photoList.list[0].isRead == false ? unreadColor : .clear
        }else if let completedStage = value as? MyPlaceStageCompleteDetails
        {
            let dateActual = completedStage.dateActual ?? ""
            var date = dateActual.stringToDateConverter()
            if date == nil
            {
                date = dateActual.stringToDateConverterForProgress()
            }
        //    cell.nameLabel.text = "Check out  \(compledtedSatgesCount) satges completed for \(stageList.stageName)"
            let month = date?.monthNumber ?? 1
            let monthName = getMonthNameWith(id: month)
            //  let monthStr = month < 10 ? String(format:"%02d",month) : "\(month)"
            let dayValue = String(format:"%02d",date?.dayValue ?? 1)//date?.dayValue ?? 1
            let presetnYearStr = "\(dayValue) - \(monthName) - \(date?.presentYear ?? 1)"
            let nameText = NSMutableAttributedString()
            nameText.append(NSMutableAttributedString(string: "\"\(completedStage.name ?? "")\" Completed on \(presetnYearStr)\n", attributes: [:]))
            nameText.append(NSMutableAttributedString(string: "\(date?.getElapsedInterval() ?? "")", attributes: [NSAttributedString.Key.font: ProximaNovaRegular(size: 12),NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.7)]))
          
            cell.nameLabel.attributedText = nameText
         //   cell.timeLabel.text = "\(date?.timeAgoDisplay() ?? "")"
            cell.iconImageView.image = #imageLiteral(resourceName: "Ico-StageNotify")
            //cell.contentView.backgroundColor = completedStage.isRead == false ? unreadColor : .clear
        }else if let stageChange = value as? MyPlaceStoredProgressDetails
        {
           
            let dateActual = stageChange.dateActual ?? ""
            var date = dateActual.stringToDateConverter()
            if date == nil
            {
                date = dateActual.stringToDateConverterForProgress()
            }
            let month = date?.monthNumber ?? 1
            let monthName = getMonthNameWith(id: month)
            //  let monthStr = month < 10 ? String(format:"%02d",month) : "\(month)"
            let dayValue = String(format:"%02d",date?.dayValue ?? 1)//date?.dayValue ?? 1
            let presetnYearStr = "\(dayValue) - \(monthName) - \(date?.presentYear ?? 1)"
            let nameText = NSMutableAttributedString()
            nameText.append(NSMutableAttributedString(string: "\"\(stageChange.name ?? "")\" changed from \(stageChange.previousStatus ?? "") to \(stageChange.currentStatus ?? "") on \(presetnYearStr)\n", attributes: [:]))
            nameText.append(NSMutableAttributedString(string: "\(date?.getElapsedInterval() ?? "")", attributes: [NSAttributedString.Key.font: ProximaNovaRegular(size: 12),NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
            cell.nameLabel.attributedText = nameText
          //  cell.timeLabel.text = "\(date?.timeAgoDisplay() ?? "")"
            cell.iconImageView.image = #imageLiteral(resourceName: "Ico-StageNotify")
           
           // cell.contentView.backgroundColor = stageChange.isRead == false ? unreadColor : .clear
        }
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        CodeManager.sharedInstance.sendScreenName("notifications_screen_loading")
        
       let value = notificationListArray[indexPath.row]
        
        print("value is \(value)")
        
        if value is MyPlaceStageCompleteDetails
        {
            let stageComplete = value as! MyPlaceStageCompleteDetails
            MyPlaceStageCompleteDetails.updateProgressDetails(stageComplete, true)
            self.performSegue(withIdentifier: "showProgressDetailsVC", sender: value)
            
        }else if value is DayWisePhotoList<MyPlaceStoredPhotoInfo>
        {
             let dayWiseList = value as! DayWisePhotoList<MyPlaceStoredPhotoInfo>
            for photoInfo in dayWiseList.list
            {
                MyPlaceStoredPhotoInfo.updatePhotoInfo(photoInfo, true)
            }
            
            self.performSegue(withIdentifier: "showPhotoDetailsVC", sender: value)
            
        }else if value is MyPlaceStoredProgressDetails
        {
            let stageChange = value as! MyPlaceStoredProgressDetails
            MyPlaceStoredProgressDetails.updateProgressDetailsToRead(stageChange, true)
            self.performSegue(withIdentifier: "showProgressDetailsVC", sender: value)
        }
        hideNotificationView()
    //    self.perform(#selector(hideNotificationView), with: nil, afterDelay: 0.5)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

       let value = notificationListArray[indexPath.row]
        if value is MyPlaceStoredProgressDetails
        {
            let stageChange = value as! MyPlaceStoredProgressDetails
            let text = "\"\(stageChange.name ?? "")\" is changed from \(stageChange.previousStatus ?? "") to \(stageChange.currentStatus ?? "")on 31-January-2018\n"
            let rect = text.rectForText(font: ProximaNovaRegular(size: 15), maxSize: CGSize(width: 0, height: 100))
            return 75 + rect
        }
        return 75
    }
    
    func hideNotificationViewWithAnimation()
    {
        UIView.animate(withDuration: 0.4) {
            self.hideNotificationView()
        }
    }
    @objc func hideNotificationView()
    {
//        self.revealViewController().revealToggle(animated: false)
    }
    enum stageNames: Int
    {
        case kAdminStage = 0, kFrameStage,kLockupStage,kFixoutStage,kFinishStage
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showProgressDetailsVC"
        {
            let destination = segue.destination as! MyProgressVC
            var selectedIndex = 0
            if let progressDetails = sender as? MyPlaceStageCompleteDetails
            {
                destination.selectedStageName = progressDetails.name ?? ""
                if progressDetails.phasecode == adminStagePhaseCode
                {
                    selectedIndex = stageNames.kAdminStage.rawValue
                }else
                {
                     if progressDetails.stageName == kFrameStage
                     {
                        selectedIndex = stageNames.kFrameStage.rawValue
                    }else if progressDetails.stageName == kLockUpStage
                     {
                        selectedIndex = stageNames.kLockupStage.rawValue
                }else if progressDetails.stageName == kFixoutStage
                 {
                    selectedIndex = stageNames.kFixoutStage.rawValue
                }else if progressDetails.stageName == kHandover || progressDetails.stageName == kCompletion
                     {
                        selectedIndex = stageNames.kFinishStage.rawValue
                    }
                }
            }
            if let storedProgressDetails = sender as? MyPlaceStoredProgressDetails
            {
                destination.selectedStageName = storedProgressDetails.name ?? ""
                if storedProgressDetails.phaseCode == adminStagePhaseCode
                {
                    selectedIndex = stageNames.kAdminStage.rawValue
                }else
                {
                    if storedProgressDetails.stageName == kFrameStage
                    {
                        selectedIndex = stageNames.kFrameStage.rawValue
                    }else if storedProgressDetails.stageName == kLockUpStage
                    {
                        selectedIndex = stageNames.kLockupStage.rawValue
                    }else if storedProgressDetails.stageName == kFixoutStage
                    {
                        selectedIndex = stageNames.kFixoutStage.rawValue
                    }else if storedProgressDetails.stageName == kHandover || storedProgressDetails.stageName == kCompletion
                    {
                        selectedIndex = stageNames.kFinishStage.rawValue
                    }
                }
            }
            destination.selectedIndex = selectedIndex
            destination.progressValues = progressValues
            destination.progressDetailsDic = stagesProgressDetailsDic
        } else if segue.identifier == "showPhotoDetailsVC"
        {
            let destination = segue.destination as! PhotosVC
         
           // destination.yearMonthNumber = self.yearMonthPhotoListArray[selectedIndexForQLDSA].yearMonth
            guard let  photosList = sender as? DayWisePhotoList<MyPlaceStoredPhotoInfo> else {return}
            dayWisePhotoList.forEach({ (dayWisePhoto) in
                if dayWisePhoto.yyyymmddString == photosList.yyyymmddString
                {
//                    destination.dayWisePhotoList = dayWisePhoto //temparory solution
                }
            })
               //1 is list index in sender
           // destination.selectedDayIndex = indexs[1]
          //  destination.monthWisePhotoList = self.yearMonthPhotoListArray[selectedIndexForQLDSA]
//            destination.selectedImgViewIndex = 0 //0 is selected  Image index in sender
//            destination.isFromNotifications = true
            let dateString = photosList.list[0].docDate ?? ""
            let date = dateString.stringToDateConverter()//dateFormater.date(from: photoInfo.docDate)
            let month = date?.monthNumber ?? 1
            let monthStr = month < 10 ? String(format:"%02d",month) : "\(month)"
            let dayValue = date?.dayValue ?? 1
            let presetnYearStr = "\(date?.presentYear ?? 1)\(monthStr)"
            let presentYearInt = Int(presetnYearStr) ?? 0
//            destination.yearMonthNumber = presentYearInt
        }
    }
   

}
