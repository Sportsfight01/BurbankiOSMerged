//
//  ProgressStatusDetailVC.swift
//  Burbank
//
//  Created by Madhusudhan on 02/08/16.
//  Copyright © 2016 DMSS. All rights reserved.
//

import UIKit


class ProgressStatusDetailVC: BurbankAppVC, UITableViewDataSource, UITableViewDelegate {

    var valuesDictionary : NSMutableDictionary!
    enum stageNames: String
    {
        case adminStage
        case frameStage
        case lockUpStage
        case fixingStage
        case finishStage
        case none
    }
    @IBOutlet weak var titleLabel : UILabel!
 
    @IBOutlet weak var buttonsLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonsTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    
    @IBOutlet weak var filedDataTableView: UITableView!
    @IBOutlet weak var completedDateLabel: UILabel!
    var dataArray : NSMutableArray! // = ["Acceptance of job", "Client Introduction", "EarthWorks", "Notify", "Silt Fence", "Toilet/Cage", "Temporary Fencing", "Water Tapping", "Retaining Wall", "Acceptance of job", "Client Introduction", "EarthWorks", "Notify", "Silt Fence", "Toilet/Cage", "Temporary Fencing", "Water Tapping"];
    var administrationDataArray: NSMutableArray!
    var frameStageDataArray: NSMutableArray!
    var lockUpStageDataArray: NSMutableArray!
    var fixingStageDataArray: NSMutableArray!
    var finishingStageDataArray: NSMutableArray!
    
    var allStageValuesArray: NSArray!
    
    var stageName: stageNames = .none
    var progressDetailsDic = [String:[MyPlaceProgressDetails]]()
    //For QLD and SA
     var selectedIndex = 1
     var progressValues = [CGFloat]()
    var selectedStageName = "" //user can select particular stage from notifications
    /** 
     * View life cycle methods
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        viewsetUp()
        
        // Do any additional setup after loading the view.
        //selectedJobNumberRegion == .VLC ? fillStageData() : fillStageDataForQLDSA()
        if stageName == .adminStage
        {
            previousButton.isEnabled = false
        }
        if stageName == .finishStage
        {
            nextButton.isEnabled = false
        }
        CodeManager.sharedInstance.setLabelsFontInView(self.view)

        // Service data {
//        ContractId = 268;
//        DateCompleted = "2016-10-17T00:00:00";
//        Id = 53950;
//        ItemName = Tiler;
//        StageName = Completion;
//    },
        let selectedStage = myPlaceStageNames[selectedIndex] //myPlaceStageNames[selectedIndex]
        let selectedStageArray = progressDetailsDic[selectedStage]
       let selectedStageIndex =  selectedStageArray?.firstIndex(where: { (progredDetails) -> Bool in
            return progredDetails.stageName == selectedStageName
        })
        if selectedStageIndex ?? 0 > 0
        {
            filedDataTableView.setContentOffset(CGPoint(x: 0,y: CGFloat(selectedStageIndex ?? 0) * rowHeight + progressCellHeight), animated: true)
        }
    }
    
    
    
    
    //MARK: - View
    func viewsetUp () {
        
        setAppearanceFor(view: titleLabel, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_LABEL_HEADING(size: FONT_18))

        setAppearanceFor(view: nextButton, backgroundColor: COLOR_ORANGE, textColor: COLOR_WHITE, textFont: FONT_BUTTON_SUB_HEADING(size: FONT_14))
        setAppearanceFor(view: previousButton, backgroundColor: COLOR_ORANGE, textColor: COLOR_WHITE, textFont: FONT_BUTTON_SUB_HEADING(size: FONT_14))

        setAppearanceFor(view: completedDateLabel, backgroundColor: COLOR_CLEAR, textColor: COLOR_GRAY, textFont: FONT_LABEL_BODY(size: FONT_10))

    }
    
    
    
    
    func fillStageData()
    {
         //from 23-11-2017, we added progressView to table view to achive view scroll. so we need to reload data to change values for prev or next
        filedDataTableView.reloadData()
    }
    
    func fillStageData(_ cell: DetailProgressValueCell)
    {
//        titleLabel.text = (valuesDictionary.value(forKey: "name") as? String)?.capitalized // myPlaceStageNames[selectedIndex].uppercased()//(valuesDictionary.value(forKey: "name") as? NSString)?.capitalized
//
//        titleLabel.text = valuesDictionary.value(forKey: "name") as? String ?? ""

        
        cell.progressStageLabel.text = NSString(format: "%@", (valuesDictionary.value(forKey: "name") as? String)!.capitalized) as String
        
        
        if cell.progressStageLabel.text?.lowercased() == "fixout stage" {
            cell.progressStageLabel.text = "Fixing Stage" //cell.nameLabel.text?.replacingOccurrences(of: cell.nameLabel.text!, with: "FIXING STAGE")
        }

        
        //        progressView.setValue(valuesDictionary.value(forKey: "value") as! CGFloat, animateWithDuration: 1.0)
        cell.progressView.value = 0
        UIView.animate(withDuration: 0.5) {
            cell.progressView.value = self.valuesDictionary.value(forKey: "value") as! CGFloat //Need to set animation
        }
        cell.progressView.progressColor = valuesDictionary.value(forKey: "filledcolor") as? UIColor
        cell.progressView.progressStrokeColor = valuesDictionary.value(forKey: "filledcolor") as? UIColor
        cell.progressView.fontColor = valuesDictionary.value(forKey: "filledcolor") as? UIColor
        cell.completedLabel.textColor = valuesDictionary.value(forKey: "filledcolor") as? UIColor
        cell.progressStageLabel.textColor = valuesDictionary.value(forKey: "filledcolor") as? UIColor
    }
    func fillStageDataForQLDSA()
    {
        //from 23-11-2017, we added progressView to table view to achive view scroll. so we need to reload data to change values for prev or next
        filedDataTableView.reloadData()
    }
    func fillStageDataForQLDSA(_ cell: DetailProgressValueCell)
    {
        titleLabel.text = myPlaceStageNames[selectedIndex].uppercased()
        titleLabel.text = myPlaceStageNames[selectedIndex]
        
        
        if titleLabel.text?.lowercased() == "fixout stage" {
            titleLabel.text = "Fixing Stage" //cell.nameLabel.text?.replacingOccurrences(of: cell.nameLabel.text!, with: "FIXING STAGE")
        }

        if titleLabel.text?.lowercased() == "completion" {
            titleLabel.text = "Finishing Stage" //cell.nameLabel.text?.replacingOccurrences(of: cell.nameLabel.text!, with: "FINISHING STAGE")
        }

        
        if selectedIndex == 0 {
//            25+70
            buttonsLeadingConstraint.constant = 95
            buttonsTrailingConstraint.constant = 95
            
            previousButton.isHidden = true
        }
        else if selectedIndex == progressValues.count-1 {
            
            buttonsLeadingConstraint.constant = 95
            buttonsTrailingConstraint.constant = 95
            
            nextButton.isHidden = true
        }
        else {
            
            buttonsLeadingConstraint.constant = 25
            buttonsTrailingConstraint.constant = 25
            
            previousButton.isHidden = false
            nextButton.isHidden = false
        }
        
        var moduleName = myprogress_adminstration_stage_break_down_button_touch
        
        if selectedIndex == 0 {
            moduleName =  myprogress_adminstration_stage_break_down_button_touch
        }
        else if selectedIndex == 1 {
            moduleName =  myprogress_frame_stage_break_down_button_touch
        }
        else if selectedIndex == 2 {
            moduleName =  myprogress_lockup_stage_break_down_button_touch
        }
        else if selectedIndex == 3 {
            moduleName =  myprogress_fixout_stage_break_down_button_touch
        }
        else if selectedIndex == 4 {
            moduleName =  myprogress_finishing_stage_break_down_button_touch
        }
        
        
        
        CodeManager.sharedInstance.sendScreenName(moduleName)
        
        
        cell.progressStageLabel.text = myPlaceStageNames[selectedIndex]
        
        
        if cell.progressStageLabel.text?.lowercased() == "fixout stage" {
            cell.progressStageLabel.text = "Fixing Stage" //cell.nameLabel.text?.replacingOccurrences(of: cell.nameLabel.text!, with: "FIXING STAGE")
        }

        if cell.progressStageLabel.text?.lowercased() == "completion" {
            cell.progressStageLabel.text = "FINISHING STAGE" //cell.nameLabel.text?.replacingOccurrences(of: cell.nameLabel.text!, with: "FINISHING STAGE")
        }

        
        
        cell.progressView.value = 0
        UIView.animate(withDuration: 0.5) {
            cell.progressView.value = self.progressValues[self.selectedIndex]
        }
        
//        cell.progressView.progressColor = myPlaceStagesColorArray[selectedIndex]
//        cell.progressView.progressStrokeColor = myPlaceStagesColorArray[selectedIndex]
//        cell.progressView.fontColor = myPlaceStagesColorArray[selectedIndex]
//        cell.completedLabel.textColor = myPlaceStagesColorArray[selectedIndex]
//        cell.progressStageLabel.textColor = myPlaceStagesColorArray[selectedIndex]
    }
    /**
     Back button action
     
     - parameter sender: button object
     */
     // MARK: Button action
    @IBAction func backTapped(_ sender: AnyObject) {
        _  = self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func previousStageButtonTapped(sender: AnyObject?)
    {
        selectedJobNumberRegion == .OLD ? handlePreviousButtonTappedForVIC() : handlePreviousButtonTappedForQLDSA()
    }
    func handlePreviousButtonTappedForQLDSA()
    {
        selectedIndex = max(selectedIndex-1, 0)
        
        
        
        fillStageDataForQLDSA()
        updateDataWithStage()
    }
    func handlePreviousButtonTappedForVIC()
    {
        nextButton.isEnabled = true
        switch stageName
        {
        case .adminStage:
            return
        case .frameStage:
            dataArray = administrationDataArray
            valuesDictionary = allStageValuesArray[0] as? NSMutableDictionary
//            titleLabel.text = "ADMINISTRATION"
            titleLabel.text = "Administration"
            valuesDictionary.setValue("ADMINISTRATION", forKey: "name")
            fillStageData()
            stageName = .adminStage
            updateDataWithStage()
            previousButton.isEnabled = false
            return
        case .lockUpStage:
            dataArray = frameStageDataArray
            valuesDictionary = allStageValuesArray[1] as? NSMutableDictionary
//            titleLabel.text = "FRAME STAGE"
            titleLabel.text = "Frame Stage"
            valuesDictionary.setValue("FRAME STAGE", forKey: "name")
            fillStageData()
            stageName = .frameStage
            updateDataWithStage()
            return
        case .fixingStage:
            dataArray = lockUpStageDataArray
            valuesDictionary = allStageValuesArray[2] as? NSMutableDictionary
//            titleLabel.text = "FIXOUT STAGE"
            titleLabel.text = "Fixing Stage"
            valuesDictionary.setValue("LOCKUP STAGE", forKey: "name")
            fillStageData()
            stageName = .lockUpStage
            updateDataWithStage()
            return
        case .finishStage:
            dataArray = fixingStageDataArray
            stageName = .fixingStage
            valuesDictionary = allStageValuesArray[3] as? NSMutableDictionary
//            titleLabel.text = "FIXOUT STAGE"
            titleLabel.text = "Fixing Stage"
            valuesDictionary.setValue("FIXING STAGE", forKey: "name")
            fillStageData()
            updateDataWithStage()
            return
        default:
            return
        }
    }
    @IBAction func nextStageButtonTapped(sender: AnyObject?)
    {
        selectedJobNumberRegion == .OLD ? handleNextButtonTappedForVIC() : handleNextButtonTappedForQLDSA()
    }
    func handleNextButtonTappedForQLDSA()
    {
        selectedIndex = min(selectedIndex+1, progressValues.count-1)
        
        fillStageDataForQLDSA()
        updateDataWithStage()
    }
    func handleNextButtonTappedForVIC()
    {
        previousButton.isEnabled = true
        switch stageName
        {
        case .adminStage:
            dataArray = frameStageDataArray
            stageName = .frameStage
            valuesDictionary = allStageValuesArray[1] as? NSMutableDictionary
            titleLabel.text = "FRAME STAGE"
             valuesDictionary.setValue("FRAME STAGE", forKey: "name")
            fillStageData()
            updateDataWithStage()
            return
        case .frameStage:
            dataArray = lockUpStageDataArray
            valuesDictionary = allStageValuesArray[2] as? NSMutableDictionary
            titleLabel.text = "LOCKUP STAGE"
            valuesDictionary.setValue("LOCKUP STAGE", forKey: "name")
            fillStageData()
            stageName = .lockUpStage
            updateDataWithStage()
            return
        case .lockUpStage:
            dataArray = fixingStageDataArray
            valuesDictionary = allStageValuesArray[3] as? NSMutableDictionary
            titleLabel.text = "Fixing Stage"
               valuesDictionary.setValue("FIXING STAGE", forKey: "name")
            fillStageData()
            stageName = .fixingStage
            updateDataWithStage()
            return
        case .fixingStage:
            dataArray = finishingStageDataArray
            valuesDictionary = allStageValuesArray[4] as? NSMutableDictionary
            titleLabel.text = "FINISHING STAGE"
            valuesDictionary.setValue("FINISHING STAGE", forKey: "name")
            fillStageData()
            stageName = .finishStage
            updateDataWithStage()
            nextButton.isEnabled = false
            return
        case .finishStage:
            
            return
        default:
            return
        }
    }
    func updateDataWithStage()
    {
       // filedDataTableView.reloadData()
    }
    // MARK: TableView DataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        func numOfStagesForVIC() -> Int
        {
            if dataArray != nil
            {
                return dataArray.count + 1 //first cell is progress view
            }
            return 1//we have to show the main progress view with 0 progress
        }
        func numOFStagesForQLDSA() -> Int
        {
            let selectedStage = myPlaceStageNames[selectedIndex]
            let selectedStageArray = progressDetailsDic[selectedStage]
            return (selectedStageArray?.count  ?? 0) + 1//we have to show the main progress view with 0 progress
        }
        let numOfStages = selectedJobNumberRegion == .OLD ? numOfStagesForVIC() : numOFStagesForQLDSA()
        completedDateLabel.alpha = numOfStages == 0 ? 0 : 1
        return numOfStages
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // To display the data in the cell , Name, Designation, MobileNumber, Email Id
        if indexPath.row == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "progressValueCell", for: indexPath) as! DetailProgressValueCell
            selectedJobNumberRegion == .OLD ? fillStageData(cell) : fillStageDataForQLDSA(cell)
            
            return cell
        }
        let indexPath = IndexPath(row: indexPath.row - 1, section: 0)
       
      
        let progressCutomCell = tableView.dequeueReusableCell(withIdentifier: "ProgressCutomCellIdentifier") as! ProgressCutomCell //tableView.dequeueReusableCell(withIdentifier: "ProgressCutomCellIdentifier", for: indexPath) as! ProgressCutomCell
    
        progressCutomCell.selectionStyle = .none
        func fillCellForVICRegion()
        {
            progressCutomCell.titleLabel.text = (dataArray.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "ItemName") as? String
            progressCutomCell.statusImageView?.image = UIImage(named: "Asset 1.png")
            progressCutomCell.dateLabel.text = ""
            if (dataArray.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "DateCompleted")  is NSNull
            {
                progressCutomCell.statusImageView?.image = #imageLiteral(resourceName: "Ico-Pending")  // UIImage(named: "PENDING.png")
            }
            else {
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat="yyyy-MM-dd"
                
                let dateString = ((dataArray.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "DateCompleted") as! NSString).substring(to: 10)
                
                let date : Date! = dateFormatter.date(from: dateString)! as Date
                
                let dateFormatter1 = DateFormatter()
                dateFormatter1.dateFormat="dd/MM/yyyy"
                
                progressCutomCell.dateLabel.text = dateFormatter1.string(from: date)
            }
        }
        
        func fillCellForQLDRegion()
        {
            let selectedStage = myPlaceStageNames[selectedIndex]
          
            guard let selectedStageArray = progressDetailsDic[selectedStage] else { return }
          
            let selectesStageDetails = selectedStageArray[indexPath.row]
            if selectedStageName == selectesStageDetails.name
            {
                selectedStageName = ""
                progressCutomCell.contentView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
                UIView.animate(withDuration: 1.25, delay: 0.5, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    //
                    progressCutomCell.statusImageView.layer.transform = CATransform3DMakeScale(1.75, 1.75, 1.75)
                }, completion: { (isFinished) in
                    progressCutomCell.statusImageView.layer.transform = CATransform3DIdentity
                })
                tableView.bringSubviewToFront(progressCutomCell.contentView)
            }else
            {
                 progressCutomCell.contentView.backgroundColor = .clear
            }
            
            var dateConvertMonthString = ""
            
            if selectesStageDetails.dateActual.count != 0 {
                let dateFormatObj = DateFormatter()
                dateFormatObj.dateFormat = "dd MMM yyyy"
                let dateObj = selectesStageDetails.dateActual.stringToDateConverter()
                dateConvertMonthString = dateFormatObj.string(from: dateObj!) //dic["dateactual"] as? String ?? ""
            }
            
            progressCutomCell.titleLabel.text = selectesStageDetails.name
            progressCutomCell.statusImageView.image =  selectesStageDetails.status == kStageCompleted ? #imageLiteral(resourceName: "Asset 1") : #imageLiteral(resourceName: "Ico-Pending")
            let dateText = NSMutableAttributedString()
            dateText.append(NSAttributedString(string: "\(selectesStageDetails.status)\n", attributes: [NSAttributedString.Key.font: ProximaNovaRegular(size: 9.0),NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
            dateText.append(NSAttributedString(string: "\(dateConvertMonthString)", attributes: [NSAttributedString.Key.font: ProximaNovaRegular(size: 15.0),NSAttributedString.Key.foregroundColor: UIColor.black]))
            progressCutomCell.statusLabel.text = selectesStageDetails.status
            if progressCutomCell.statusLabel.text == "Completed" {
                progressCutomCell.statusLabel.text = "Completed Date"
            }
            progressCutomCell.dateLabel.text = dateConvertMonthString
            
            
            
            if selectesStageDetails.status != "Completed" {
                progressCutomCell.statusLabel.text = ""
                progressCutomCell.dateLabel.text = ""
            }
        }
        selectedJobNumberRegion == .OLD ? fillCellForVICRegion() : fillCellForQLDRegion()
        
        
        progressCutomCell.top = false
        progressCutomCell.bottom = false
        
        if indexPath.row == 0, indexPath.row == tableView.numberOfRows(inSection: indexPath.section)-2 {
        
            progressCutomCell.top = true
            progressCutomCell.bottom = true

        }else if indexPath.row == 0 {
            progressCutomCell.top = true
        }else if indexPath.row == tableView.numberOfRows(inSection: indexPath.section)-2 {
            progressCutomCell.bottom = true
        }
        
        
        progressCutomCell.layoutSubviews()

        
        return progressCutomCell
    }
    
    
    let rowHeight = (SCREEN_HEIGHT * 0.4 / 6.12)
    var progressCellHeight: CGFloat
    {
        if IS_IPHONE_X
        {
            return SCREEN_HEIGHT * 0.3
        }
        return SCREEN_HEIGHT * 0.4
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var CellHeight: CGFloat
        {
            if indexPath.row == 0
            {
               return progressCellHeight
            }else
            {
                return rowHeight + 5
            }
        }
       return CellHeight
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
