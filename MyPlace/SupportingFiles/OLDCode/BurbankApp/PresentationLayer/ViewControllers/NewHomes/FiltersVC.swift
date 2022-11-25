//
//  FiltersVC.swift
//  BurbankApp
//
//  Created by Madhusudhan on 19/01/17.
//  Copyright © 2017 DMSS. All rights reserved.
//

import UIKit

//class FiltersVC: BurbankFilterVC
//{
//
//    @IBOutlet weak var priceSlider : RangeSlider1!
//    
//    @IBOutlet weak var storeySingleCheckBox : MyCustomButton!
//    @IBOutlet weak var storeyDoubleCheckBox : MyCustomButton!
//    
//    @IBOutlet weak var bedroomCheckBox1 : MyCustomButton!
//    @IBOutlet weak var bedroomCheckBox2 : MyCustomButton!
//    @IBOutlet weak var bedroomCheckBox3 : MyCustomButton!
//    
//    @IBOutlet weak var bathroomCheckBox1 : MyCustomButton!
//    @IBOutlet weak var bathroomCheckBox2 : MyCustomButton!
//    
//    var checkBoxesArray = NSMutableArray()
//    
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//    var delegate: mainFilterProtocal?
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//        
//        priceSlider.backgroundColor = UIColor.clear
//        priceSlider.isNeedSmallSize = true
//    
//        checkBoxesArray = [storeySingleCheckBox, storeyDoubleCheckBox, bedroomCheckBox1, bedroomCheckBox2, bedroomCheckBox3, bathroomCheckBox1, bathroomCheckBox2]
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    //MARK : Button actions
//    @IBAction func resetTapped (_ sender : UIButton) {
//        
//        for checkBoxButton in checkBoxesArray {
//            (checkBoxButton as! MyCustomButton).isSelected = false
//        }
//        
//        priceSlider.lowerValue = lowerPrice
//        priceSlider.upperValue = upperPrice
//    }
//    
//    @IBAction func searchTapped (_ sender : UIButton)
//    {
//        
//        let filterOptions = FilterOptions()
//
//        filterOptions.storey.single = storeySingleCheckBox.isChecked
//        filterOptions.storey.double = storeyDoubleCheckBox.isChecked
//        filterOptions.bedRooms.bedroom3 = bedroomCheckBox1.isChecked
//        filterOptions.bedRooms.bedroom4 = bedroomCheckBox2.isChecked
//        filterOptions.bedRooms.bedroom5plus = bedroomCheckBox3.isChecked
//        filterOptions.bathRooms.bathroom2 = bathroomCheckBox1.isChecked
//        filterOptions.bathRooms.bathroom3 = bathroomCheckBox2.isChecked
//        filterOptions.price.minSelectedPrice = priceSlider.lowerValue
//        filterOptions.price.maxSelectedPrice = priceSlider.upperValue
//        saveFilteredOptionsToUserDefaults(filterOptions: filterOptions)
//        delegate?.getAndShowHomesOnView()
//        dismiss(animated: true, completion: nil)
//    }
//    private func saveFilteredOptionsToUserDefaults(filterOptions: FilterOptions)
//    {
//        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: filterOptions)
//        UserDefaults.standard.set(encodedData, forKey: "filterOption")//filterOption
//        UserDefaults.standard.synchronize()
//    }
//    
//    @IBAction func skipTapped (_ sender : UIButton)
//    {
//        delegate?.getAndShowHomesOnViewWithSkipTapped()
//        dismiss(animated: true, completion: nil)
//        
//    }
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
