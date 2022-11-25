//
//  ProgressStatusVC.swift
//  Burbank
//
//  Created by Madhusudhan on 02/08/16.
//  Copyright © 2016 DMSS. All rights reserved.
//

import UIKit


import MBCircularProgressBar

protocol ProgressStatusVCDelegate {
    func selectedItemValues(_ index : Int, valuesArray : NSArray)
}

class ProgressStatusVC: BurbankAppVC/*MyPlaceWithTabBarVC*/, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var appDelegate : AppDelegate!
    var progressDataDictionary : NSMutableDictionary!
    let collectViewWidth = (SCREEN_WIDTH-60)
    
    
    @IBOutlet weak var titleLabel : UILabel!

    @IBOutlet weak var myPlaceStagesView : UICollectionView!

    var sortedArray = NSArray()

    var mainProgressCompleted:CGFloat = 0
    
    var delegateProgress : ProgressStatusVCDelegate!
    //for QLD, SA
    var progressDetailsDic = [String: [MyPlaceProgressDetails]]()
    var progressValues = [CGFloat]()
   // MARK: View life cycle methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        _ = setAttributetitleFor(view: titleLabel, title: "MyHomeProgress", rangeStrings: ["MyHome", "Progress"], colors: [COLOR_BLACK, COLOR_ORANGE], fonts: [FONT_LABEL_HEADING(size: FONT_18), FONT_LABEL_HEADING(size: FONT_18)], alignmentCenter: false)

        
        appDelegate=UIApplication.shared.delegate as? AppDelegate

       // mainProgressView.value = 0.0
        
        //print(" PROGRESS STATUS VALUES %@ ",progressDataDictionary)
        
                
//        colorsArray = [
//     //   UIColor.init(r: 236, g: 209, b: 2),
//        UIColor.init(colorLiteralRed: 236/255.0, green: 209/255.0, blue: 2/255.0, alpha: 1.0),
//        UIColor.init(colorLiteralRed: 0/255.0, green: 176/255.0, blue: 76/255.0, alpha: 1.0),
//        UIColor.init(colorLiteralRed: 236/255.0, green: 50/255.0, blue: 148/255.0, alpha: 1.0),
//        UIColor.init(colorLiteralRed: 3/255.0, green: 161/255.0, blue: 230/255.0, alpha: 1.0),
//        UIColor.init(colorLiteralRed: 139/255.0, green: 102/255.0, blue: 171/255.0, alpha: 1.0),
//        UIColor.init(colorLiteralRed: 187/255.0, green: 78/255.0, blue: 18/255.0, alpha: 1.0),
//        UIColor.init(colorLiteralRed: 223/255.0, green: 112/255.0, blue: 28/255.0, alpha: 1.0),
//        UIColor.init(colorLiteralRed: 17/255.0, green: 96/255.0, blue: 39/255.0, alpha: 1.0)]
        
        sortedArray = ["Administration", "Frame Stage", "Lockup Stage", "Fixing Stage", "Completion"]

     //   myPlaceStagesView.isScrollEnabled = false
        myPlaceStagesView.setNeedsLayout()
        myPlaceStagesView.layoutIfNeeded()
        
      //sortedArray = (appDelegate.myPlaceStagesArray.allObjects as NSArray).sorted { ($0 as! String).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending } as NSArray

      
        //progressCalculationForStagesWithTotalCount()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        
    }

    /**
     Back button action
     
     - parameter sender: button object
     */
    // MARK: Back button action
    @IBAction func backTapped(_ sender: AnyObject) {
        _  = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    
        if segue.identifier == "showProgressDetailVC"
        {
            let destination = segue.destination as! ProgressStatusDetailVC
            if let selectedIndex = sender as? Int
            {
                destination.selectedIndex = selectedIndex
            }
            destination.progressValues = progressValues
            destination.progressDetailsDic = progressDetailsDic
        }
    }
        // MARK: - CollectionView Datasource Methods
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
       return 6//appDelegate.myPlaceStagesArray.count
    }
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if indexPath.row == 0
        {
            //main progress view
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainProgressView", for: indexPath)  as! MainProgressCell
            selectedJobNumberRegion == .OLD ? progressCalculationForStagesWithTotalCount(cell.mainProgressView) : progressCalculationForQLDSA(cell.mainProgressView)
            
            if mainProgressCompleted == 100 {
                cell.onItsWay.text = "COMPLETED"
            }
            return cell
        }
        let indexPath = IndexPath(row: indexPath.row-1, section: 0) //we included Main progress view in collection view which will caluse increase one cell in collection view, but we are loadind data with 5 values.so we need to decrease row value to 1.
//        print("---->",indexPath.row)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyPlaceStagesIdentifier", for: indexPath) as! MyPlaceStagesCell
        if myPlaceStageNames[indexPath.row] == kFinishingStage
        {
            cell.stagesProgressView.superview?.constraints.forEach { (constraint) in
                if constraint.identifier == "progressViewWidthAnchorID"//progressViewWidthAnchorID
                {
                    constraint.constant = -(collectViewWidth * (constraint.multiplier)/2)
                }
            }
        }
        func fillStageCellForQLDSA()
        {
            //print(myPlaceStageNames[indexPath.row])
            cell.nameLabel.text = myPlaceStageNames[indexPath.row].uppercased()
            let progressValue = calculateProgressValue(progressDetailsDic[myPlaceStageNames[indexPath.row]])
            cell.stagesProgressView.value = progressValue
            
            if cell.nameLabel.text?.lowercased() == "fixout stage" {
                cell.nameLabel.text = "FIXING STAGE" //cell.nameLabel.text?.replacingOccurrences(of: cell.nameLabel.text!, with: "FIXING STAGE")
            }

            if cell.nameLabel.text?.lowercased() == "completion" {
                cell.nameLabel.text = "FINISHING STAGE" //cell.nameLabel.text?.replacingOccurrences(of: cell.nameLabel.text!, with: "FINISHING STAGE")
            }

        }
        func fillStageCellForVIC()
        {
            cell.nameLabel.text = sortedArray.object(at: indexPath.row) as? String
            cell.nameLabel.text = myPlaceStageNames[indexPath.row].uppercased() //cell.nameLabel.text?.uppercased()

            if cell.nameLabel.text?.lowercased() == "fixout stage" {
                cell.nameLabel.text = "FIXING STAGE" //cell.nameLabel.text?.replacingOccurrences(of: cell.nameLabel.text!, with: "FIXING STAGE")
            }

            if cell.nameLabel.text?.lowercased() == "completion" {
                cell.nameLabel.text = "FINISHING STAGE" //cell.nameLabel.text?.replacingOccurrences(of: cell.nameLabel.text!, with: "FINISHING STAGE")
            }
            
            cell.stagesProgressView.value = CGFloat(self.progressCalculationForStage(indexPath.row))
        }
        selectedJobNumberRegion == .OLD ? fillStageCellForVIC() : fillStageCellForQLDSA()
//        if cell.stagesProgressView.value >= 100.0
//        {
//            cell.stagesProgressView.valueFontSize = 28
//        }
//        
       // cell.stagesProgressView.progressColor = myPlaceStagesColorArray[indexPath.row] //colorsArray.object(at: indexPath.row) as! UIColor changed by Pranith
        
      //  cell.stagesProgressView.fontColor = myPlaceStagesColorArray[indexPath.row]
        
      //  cell.nameLabel.textColor = myPlaceStagesColorArray[indexPath.row]
        
        if SCREEN_HEIGHT == 568 {
            
            cell.stagesProgressView.valueFontSize = 16;
            cell.stagesProgressView.unitFontSize = 16;
        }
        
        return cell
    }
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
        if indexPath.row == 0
        {
            return
        }
        let indexPath = IndexPath(row: indexPath.row-1, section: 0)
       func handleForVICRegion()
       {
            let valuesArray = NSMutableArray()
            for i in 0 ... 4//appDelegate.myPlaceStagesArray.count - 1
            {
               // let index = IndexPath(item: i, section: 0)
                let dictionary = NSMutableDictionary()
                let value = progressCalculationForStage(i)
                dictionary.setObject(value, forKey: "value" as NSCopying)
               // dictionary.setObject(myPlaceStagesColorArray[i], forKey: "filledcolor" as NSCopying)
                dictionary.setObject(myPlaceStageNames[indexPath.row].uppercased(), forKey: "name" as NSCopying)
                
                #if DEDEBUG
                print(appDelegate.myPlaceStagesArray)
                #endif
                
                
                if appDelegate.myPlaceStagesArray.count > indexPath.row
                {
                dictionary.setObject((sortedArray.object(at: indexPath.row) as? String)!, forKey: "stageName" as NSCopying)
                }
                valuesArray.add(dictionary)
            }
            delegateProgress.selectedItemValues(indexPath.row, valuesArray: valuesArray)
        }
        func handleForQLDSARegion()
        {
            progressValues.removeAll()
            for i in 0...4 //number of stages are 4
            {
                let progressValue = CGFloat(calculateProgressValue(progressDetailsDic[myPlaceStageNames[i]]))
                progressValues.append(progressValue)
            }
            self.performSegue(withIdentifier: "showProgressDetailVC", sender: indexPath.row)
        }
        selectedJobNumberRegion == .OLD ? handleForVICRegion() : handleForQLDSARegion()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width : CGFloat{
            if indexPath.row == 0 || indexPath.row == 5
            {
                return collectViewWidth
            }else
            {
                return collectViewWidth/2
            }
        }
        var height: CGFloat{
            if indexPath.row == 0
            {
                if IS_IPHONE_X
                {
                    return SCREEN_HEIGHT * 0.3
                }
                return SCREEN_HEIGHT * 0.4
            }else
            {
                if IS_IPHONE_X
                {
                    return (SCREEN_HEIGHT * 0.7)/2.2
                }
                return (SCREEN_HEIGHT * 0.6)/1.75 //(collectionView.frame.size.height / 1.45)
            }
        }
         return CGSize(width: width, height: height)
    
    }
    func progressCalculationForQLDSA(_ progressView: MBCircularProgressBarView)
    {
        //for administration stage
        let adminStageProgressValue = calculateProgressValue(progressDetailsDic[kAdminStage])
        let frameStageProgressValue = calculateProgressValue(progressDetailsDic[kFrameStage])
        let lockupStageProgressValue = calculateProgressValue(progressDetailsDic[kLockUpStage])
        let fixoutStageProgressValue = calculateProgressValue(progressDetailsDic[kFixoutStage])
        let finishingStageProgressValue = calculateProgressValue(progressDetailsDic[kFinishingStage])
        let totalProgressValue = (adminStageProgressValue + frameStageProgressValue + lockupStageProgressValue + fixoutStageProgressValue + finishingStageProgressValue)/CGFloat(progressDetailsDic.count)
        
        mainProgressCompleted = totalProgressValue
        
        UIView.animate(withDuration: 0.85) {
            progressView.value = totalProgressValue
        }
        
        
    }
    func calculateProgressValue(_ progressDetailArray: [MyPlaceProgressDetails]?) -> CGFloat
    {
        return CodeManager.sharedInstance.calculateProgressValue(progressDetailArray)
    }
    func progressCalculationForStagesWithTotalCount(_ progressView: MBCircularProgressBarView)
    {
        //getting progress values for all stages
        mainProgressCompleted = 0
        for i in 0..<sortedArray.count {
            
            mainProgressCompleted = progressCalculationForStage(i)+mainProgressCompleted
            
            #if DEDEBUG
            print(mainProgressCompleted)
            #endif
            
        }
        let progressValue : CGFloat = mainProgressCompleted/CGFloat(5)
       // print(progressValue)
       // progressValue = CGFloat(mainProgressCompleted).truncatingRemainder(dividingBy: 5) >= 5 ? progressValue+1 : progressValue
        /**
         *  progress bar Animation Running in Background thread
         */
        DispatchQueue.main.async(execute: { () -> Void in
            
            #if DEDEBUG
            print("This is run on the main queue, after the previous code in outer block")
            #endif
            
           // self.mainProgressView.setValue(CGFloat(progressValue), animateWithDuration: 5.0)
            progressView.value = progressValue //Need To work
        })
    }
    
    func progressCalculationForStage(_ index : Int) -> CGFloat {
        
//        #if DEDEBUG
//        print(progressDataDictionary)
//        #endif
        
//        if sortedArray.count < index
//        {
//
//        }
        if let name = sortedArray[index] as? String
        {
            if let valueee = progressDataDictionary.value(forKey: name)
            {
                if let allItemsCount = (valueee as AnyObject).count
                {
                    // let allItemsCount : Int = ((progressDataDictionary.value(forKey: sortedArray.object(at: index) as! String) as AnyObject).count)!
                    let uncompletedDateArray = NSMutableArray()
                    for j in 0..<allItemsCount {
                        let temp = sortedArray.object(at: index) as! String
                        let tempValue = progressDataDictionary.value(forKey: temp) as AnyObject
                        let valueObj = tempValue.object(at: j) as AnyObject
                        let value = valueObj.value(forKey: "DateCompleted") //By Pranith
                        if (value is NSNull)
                        {
                            let progressTempValue = progressDataDictionary.value(forKey: temp) as AnyObject
                            let tempValueObj = progressTempValue.object(at: j) as AnyObject
                            let toAddValue = tempValueObj.value(forKey: "DateCompleted")
                            uncompletedDateArray.add(toAddValue ?? "") //By Pranith
                        }
                        
                    }
                    let completedItemsCount : Int = allItemsCount-uncompletedDateArray.count
                    let progressCompleted : CGFloat = CGFloat((completedItemsCount*100))/CGFloat(allItemsCount)
                    //progressCompleted = CGFloat((completedItemsCount*100)).truncatingRemainder(dividingBy: CGFloat(allItemsCount)) >= 5 ? progressCompleted+1 : progressCompleted
                    return progressCompleted
                }
          
            }
        }
     
        return 0
       
    }
}
