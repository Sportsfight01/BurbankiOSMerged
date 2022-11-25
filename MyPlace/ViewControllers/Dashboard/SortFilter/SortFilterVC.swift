//
//  SortFilterVC.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 07/04/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit


protocol SortFilterDelegate: NSObject {
    
    func handleSortFilterDelegate (close: Bool, searchBtn: Bool, results: Any)
    
}




class SortFilterVC: UIViewController {
    
    weak var delegate: SortFilterDelegate?
    
    
    @IBOutlet weak var sortView: UIView!
    @IBOutlet weak var btnSortDone: UIButton!
    @IBOutlet weak var pickerView : UIPickerView!
    
    
    
    @IBOutlet weak var sortFilterView: UIView!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var priceRangeContainerView: UIView!
    
    
    @IBOutlet weak var lBPriceRange: UILabel!
    
    
    @IBOutlet weak var lBStoreys: UILabel!
    @IBOutlet weak var lBBedrooms: UILabel!
    @IBOutlet weak var lBCarSpaces: UILabel!
    @IBOutlet weak var lBBathrooms: UILabel!
    
    
    @IBOutlet weak var segmentStoreys: UISegmentedControl!
    @IBOutlet weak var segmentBedrooms: UISegmentedControl!
    @IBOutlet weak var segmentCarSpaces: UISegmentedControl!
    @IBOutlet weak var segmentBathrooms: UISegmentedControl!
    
    
    @IBOutlet weak var lBSortBy: UILabel!
    @IBOutlet weak var lBSort: UILabel!
    
    
    @IBOutlet weak var sortFilterTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var sortFilterbottomConstraint: NSLayoutConstraint!
    
    
    var priceRangeVC: PriceRangeVC?
    var sortFilterFrame: CGRect = .zero
    
    
    fileprivate let titles = ["Price (Low - High)", "Price (High - Low)"/*, "Estate", "Suburb"*/]
    
    
    var filter = SortFilter()
    
    
    
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        CodeManager.sharedInstance.sendScreenName(burbank_homeAndLand_sortFilter_screen_loading)
        
        filter.priceSorting = .lowtoHigh
        
        
        segmentStoreys.setOldLayout(tintColor: .white, selectedColor: COLOR_APP_GRAY)
        segmentBedrooms.setOldLayout(tintColor: .white)
        segmentCarSpaces.setOldLayout(tintColor: .white)
        segmentBathrooms.setOldLayout(tintColor: .white)
        
        
        segmentStoreys.selectedSegmentIndex = segmentStoreys.numberOfSegments - 1
        segmentBedrooms.selectedSegmentIndex = segmentBedrooms.numberOfSegments - 1
        segmentCarSpaces.selectedSegmentIndex = segmentCarSpaces.numberOfSegments - 1
        segmentBathrooms.selectedSegmentIndex = segmentBathrooms.numberOfSegments - 1
        
        
        pageUISetUp()
        
        
        self.priceRangeVC?.updatedPriceRangeValues = {
            
            self.filter.priceRange.priceStart = (self.priceRangeVC?.rangeslider.lowerValue)!
            self.filter.priceRange.priceEnd = (self.priceRangeVC?.rangeslider.upperValue)!
            
            
            self.getPriceValues (after: 1)
        }
        
    }
    
    //MARK: - View
    
    func pageUISetUp () {
        //        FONT_LABEL_LIGHT
        setAppearanceFor(view: lBPriceRange, backgroundColor: COLOR_CLEAR, textColor: UIColor.hexCode("5C5E5E"), textFont: FONT_LABEL_HEADING(size: FONT_14))
        
        
        setAppearanceFor(view: lBStoreys, backgroundColor: COLOR_CLEAR, textColor: UIColor.hexCode("5C5E5E"), textFont: FONT_LABEL_HEADING(size: FONT_14))
        setAppearanceFor(view: lBBedrooms, backgroundColor: COLOR_CLEAR, textColor: UIColor.hexCode("5C5E5E"), textFont: FONT_LABEL_HEADING(size: FONT_14))
        setAppearanceFor(view: lBBathrooms, backgroundColor: COLOR_CLEAR, textColor: UIColor.hexCode("5C5E5E"), textFont: FONT_LABEL_HEADING(size: FONT_14))
        setAppearanceFor(view: lBCarSpaces, backgroundColor: COLOR_CLEAR, textColor: UIColor.hexCode("5C5E5E"), textFont: FONT_LABEL_HEADING(size: FONT_14))
        
        setAppearanceFor(view: lBSortBy, backgroundColor: COLOR_CLEAR, textColor: UIColor.hexCode("5C5E5E"), textFont: FONT_LABEL_HEADING(size: FONT_14))
        
        setAppearanceFor(view: lBSort, backgroundColor: COLOR_CLEAR, textColor: UIColor.hexCode("5C5E5E"), textFont: FONT_LABEL_SUB_HEADING(size: FONT_14))
        
    }
    
    
    func updatePriceRangeView() {
        
        if IS_IPHONE {
            sortFilterTopConstraint.constant = statusBarHeight () + 50
        }else {
            
            sortFilterTopConstraint.constant = statusBarHeight () + headerViewHeight + 50
        }
        
        
        priceRangeVC?.updateRangeSlider()
        
        
        if filter.storeysCount == .one {
            segmentStoreys.selectedSegmentIndex = 0
        }else if filter.storeysCount == .two {
            segmentStoreys.selectedSegmentIndex = 1
        }
        
        
        if filter.bedRoomsCount == .three {
            segmentBedrooms.selectedSegmentIndex = 0
        }else if filter.bedRoomsCount == .four {
            segmentBedrooms.selectedSegmentIndex = 1
        }else if filter.bedRoomsCount == .five {
            segmentBedrooms.selectedSegmentIndex = 2
        }
        
        if filter.CarSpacesCount == .one {
            segmentCarSpaces.selectedSegmentIndex = 0
        }else if filter.CarSpacesCount == .two {
            segmentCarSpaces.selectedSegmentIndex = 1
        }
        
        
        if filter.BathRoomsCount == .two {
            segmentBathrooms.selectedSegmentIndex = 0
        }else if filter.BathRoomsCount == .three {
            segmentBathrooms.selectedSegmentIndex = 1
        }
        
    }
    
    
    
    //MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "priceRange" {
            priceRangeVC = segue.destination as? PriceRangeVC
        }
    }
    
    
    //MARK: - Button Actoins
    
    @IBAction func handleCloseButton (_ sender: UIButton) {
        
        CodeManager.sharedInstance.sendScreenName(burbank_homeAndLand_sortFilter_close_button_touch)
        
        delegate?.handleSortFilterDelegate(close: true, searchBtn: false, results: filter)
    }
    
    @IBAction func handlSearchButtonAction () {
        
        CodeManager.sharedInstance.sendScreenName(burbank_homeAndLand_sortFilter_search_button_touch)
        
        if self.filter.priceRange.totalCount == 0 {
            showToast("No Packages found, Please refine your filter", self)
            return
        }
        
        filter.priceRange.priceStart = self.priceRangeVC?.rangeslider.lowerValue ?? 0
        filter.priceRange.priceEnd = self.priceRangeVC?.rangeslider.upperValue ?? 1
        
        
        delegate?.handleSortFilterDelegate(close: false, searchBtn: true, results: filter)
    }
    
    
    @IBAction func handlSortArrowButtonAction () {
        
        CodeManager.sharedInstance.sendScreenName(burbank_homeAndLand_sortFilter_sort_button_touch)
        
        if sortView.isHidden {
            sortView.isHidden = false
            
            sortFilterFrame = self.sortFilterView.frame
            
            sortFilterView.frame.origin.y = 0
            
        }else {
            sortView.isHidden = true
            
            self.sortFilterView.frame = sortFilterFrame
        }
        
    }
    
    @IBAction func handlSortDoneButtonAction () {
        
        CodeManager.sharedInstance.sendScreenName(burbank_homeAndLand_sortFilter_sort_done_button_touch)
        
        sortView.isHidden = true
        sortFilterView.frame = sortFilterFrame
        
        
        if titles[0] == lBSort.text {
            filter.priceSorting = .lowtoHigh
        }else if titles[1] == lBSort.text {
            filter.priceSorting = .hightoLow
        }
        
    }
    
    
    
    @IBAction func segmentControlChanged (_ segment: UISegmentedControl) {
        
        if segment == segmentCarSpaces {
            
            CodeManager.sharedInstance.sendScreenName(burbank_homeAndLand_sortFilter_carspaces_segment_touch)
            
            if segment.selectedSegmentIndex == 0 {
                filter.CarSpacesCount = .one
            }else if segment.selectedSegmentIndex == 1 {
                filter.CarSpacesCount = .two
            }else {
                filter.CarSpacesCount = .ALL
            }
        }else if segment == segmentStoreys {
            
            CodeManager.sharedInstance.sendScreenName(burbank_homeAndLand_sortFilter_storeys_segment_touch)
            
            if segment.selectedSegmentIndex == 0 {
                filter.storeysCount = .one
            }else if segment.selectedSegmentIndex == 1 {
                filter.storeysCount = .two
            }else {
                filter.storeysCount = .ALL
            }
            
        }else if segment == segmentBedrooms {
            
            CodeManager.sharedInstance.sendScreenName(burbank_homeAndLand_sortFilter_bedRooms_segment_touch)
            
            if segment.selectedSegmentIndex == 0 {
                filter.bedRoomsCount = .three
            }else if segment.selectedSegmentIndex == 1 {
                filter.bedRoomsCount = .four
            }else if segment.selectedSegmentIndex == 2 {
                filter.bedRoomsCount = .five
            }else {
                filter.bedRoomsCount = .ALL
            }
            
        }else if segment == segmentBathrooms {
            
            CodeManager.sharedInstance.sendScreenName(burbank_homeAndLand_sortFilter_bathRooms_segment_touch)
            
            if segment.selectedSegmentIndex == 0 {
                filter.BathRoomsCount = .two
            }else if segment.selectedSegmentIndex == 1 {
                filter.BathRoomsCount = .three
            }else {
                filter.BathRoomsCount = .ALL
            }
            
        }
        
        updateFilterValues ()
        
    }
    
    
    @objc func updateFilterValues () {
        
        CodeManager.sharedInstance.sendScreenName(burbank_homeAndLand_sortFilter_minPrice_slider_swipe)
        
        
        if filter.searchType == SearchType.shared.homeLand {
            
            for task in NetworkingManager.shared.arrayPriceRangeTasks {
                if (task as AnyObject).isKind(of: URLSessionDataTask.self), (task as! URLSessionDataTask).state == .running {
                    (task as! URLSessionDataTask).cancel()
                }
            }
            
            //            let datatask = DashboardDataManagement.shared.getHomeLandFilterValues(with: self.filter) { (filterNew) in
            
            let datatask = self.getHomeLandFilterValues(with: self.filter) { (filterNew) in
                
                self.filter.priceRange.totalCount = filterNew.priceRange.totalCount
                self.filter.priceRange.priceRangeCounts = filterNew.priceRange.priceRangeCounts
                
                
                if self.filter.priceRange.totalCount !=  self.filter.priceRange.priceRangeCounts.reduce (0, +) {
                    self.filter.priceRange.priceRangeCounts[0] = self.filter.priceRange.priceRangeCounts[0] + 1
                }
                
                
                
                self.priceRangeVC?.bars = self.filter.priceRange.priceRangeCounts
                
                
                self.priceRangeVC?.updateRangeSliderValues(with: self.filter)
            }
            
            
            if let task = datatask {
                NetworkingManager.shared.arrayPriceRangeTasks.add(task)
            }
        }
    }
    
    
    //MARK: - perform selector
    
    func getPriceValues (after: TimeInterval) {
        cancelPreviousSelector()
        perform(#selector(updateFilterValues), with: nil, afterDelay: after)
    }
    
    func cancelPreviousSelector () {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(updateFilterValues), object: nil)
    }
    
    
    //MARK: - APIs
    
    func getHomeLandFilterValues (with filter: SortFilter, succe: @escaping ((_ newFilter: SortFilter) -> Void)) -> Any? {
        
        let region = filter.region.regionName
        let regionsArr =  filter.regionsArr.map{ $0.regionName }
        print("----1-1-1-1-1,",regionsArr)
        let regions = regionsArr.joined(separator: ",")
        print("----1-1-1-1-1,",regions)

        
        var storeys: Int {
            if filter.storeysCount == .one { return 1 }
            else if filter.storeysCount == .two { return 2 }
            else { return 0 }
        }
        
        var bedrooms: [Int] {
            if filter.bedRoomsCount == .three { return [3] }
            else if filter.bedRoomsCount == .four { return [4] }
            else if filter.bedRoomsCount == .five { return [5,6] }
            else if filter.bedRoomsCount == .six { return [6] }
                
            else { return [3,4,5,6] }
        }
        
        var carSpaces: [Int] {
            if filter.CarSpacesCount == .one { return [1] }
            else if filter.CarSpacesCount == .two { return [2] }
            else { return [1, 2] }
        }
        
        var bathrooms: [Int] {
            if filter.BathRoomsCount == .two { return [2] }
            else if filter.BathRoomsCount == .three { return [3,4,5,6] }
            else { return [1,2,3,4,5,6] }
        }
        
        
        var minPrice: String {
            if filter.priceRange.priceStart > 0 {
                return filter.priceRange.priceStartStringValue + "000"
                //                return NSNumber(value: Int(filter.priceRange.priceStart)).stringValue + "000"
            }else {
                return "0"
            }
        }
        
        var maxPrice: String {
            if filter.priceRange.priceEnd > 1 {
                return filter.priceRange.priceEndStringValue + "000"
                //                return NSNumber(value: Int(filter.priceRange.priceEnd)).stringValue + "000"
            }else {
                return "0"
            }
        }
        
        
        let params1 = NSMutableDictionary()
        params1.setValue(regions, forKey: "Region")
        
        
        params1.setValue(storeys > 0 ? NSArray (object: storeys) : NSArray (), forKey: "Storey")
        params1.setValue(bedrooms, forKey: "BedRooms")
        params1.setValue(carSpaces, forKey: "CarSpaces")
        params1.setValue(bathrooms, forKey: "Bathrooms")
        
        params1.setValue(kUserState, forKey: "StateId")
        params1.setValue(minPrice, forKey: "SelectedMinValue")
        params1.setValue(maxPrice, forKey: "SelectedMaxValue")
        params1.setValue(0, forKey: "IncludePackages")
        params1.setValue(0, forKey: "PageNo")
        params1.setValue(filter.priceSorting == .hightoLow ? 1 : 0 , forKey: "SortByPrice")
        
        
        let params = NSDictionary.init(objects: [params1 as Any], forKeys: ["HnLQuizItems" as NSCopying])
        
        
        let datatask = Networking.shared.POST_request(url: ServiceAPI.shared.URL_packagesFilter (kUserID), parameters: params, userInfo: nil, success: { (json, response) in
            
            if let result: AnyObject = json {
                
                let result = result as! NSDictionary
                
                if let _ = result.value(forKey: "status"), (result.value(forKey: "status") as? Bool) == true {
                    
                    let filterNew = SortFilter (values: result)
                    
                    succe (filterNew)
                    
                }else {
                    print(log: "count not found")
                    
                    succe (SortFilter ())
                }
                
            }else {
                
                succe ( SortFilter ())
            }
            
        }, errorblock: { (error, isJSONerror) in
            
            if isJSONerror {
                
            }else {
                
            }
            succe (SortFilter ())
            
        }, progress: nil)
        
        
        if let task = datatask {
            return task
        }else {
            return nil
        }
        
    }
    
}




extension SortFilterVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.titles.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.titles[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.lBSort.text = self.titles[row]
        
        if row == 0 || row == 1 {
            updateFilterValues ()
        }
    }
}




extension UISegmentedControl
{
    func setOldLayout(tintColor: UIColor, selectedColor: UIColor = COLOR_APP_GRAY)
    {
        //        if #available(iOS 13, *)
        //        {
        let bg = UIImage(color: .clear, size: CGSize(width: 1, height: self.frame.size.height))
        let devider = UIImage(color: selectedColor, size: CGSize(width: 1, height: self.frame.size.height))
        
        let deviderSelected = UIImage(color: COLOR_DARK_GRAY, size: CGSize(width: 1, height: self.frame.size.height))
        
        //set background images
        self.setBackgroundImage(bg, for: .normal, barMetrics: .default)
        self.setBackgroundImage(devider, for: .selected, barMetrics: .default)
        
        self.setBackgroundImage(deviderSelected, for: .selected, barMetrics: .default)
        //            self.setBackgroundImage(devider, for: .selected, barMetrics: .default)
        
        
        //set divider color
        self.setDividerImage(devider, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        
        //             //set label color
        self.setTitleTextAttributes([.font : FONT_LABEL_HEADING(size: FONT_9), .foregroundColor: UIColor.hexCode("5C5E5E")], for: .normal)
        self.setTitleTextAttributes([.font : FONT_LABEL_HEADING(size: FONT_9), .foregroundColor: UIColor.white], for: .selected)
        //        }
        //        else
        //        {
        //            self.tintColor = tintColor
        //        }
        
        //        self.layer.cornerRadius = 0
        //        self.clipsToBounds = true
        //set border
        self.layer.borderWidth = 0.5
        self.layer.borderColor = selectedColor.cgColor
        
    }
}

extension UIImage {
    convenience init(color: UIColor, size: CGSize) {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        color.set()
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.fill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.init(data: image.pngData()!)!
    }
}
