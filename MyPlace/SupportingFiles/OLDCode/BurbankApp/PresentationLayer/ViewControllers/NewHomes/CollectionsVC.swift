//
//  CollectionsVC.swift
//  BurbankApp
//
//  Created by dmss on 24/01/17.
//  Copyright © 2017 DMSS. All rights reserved.
//

import UIKit

class CollectionsVC: BurbankAppVC {

    @IBOutlet weak var gemsButton: MyCustomButton!
    @IBOutlet weak var elementsButton: MyCustomButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        if let decoded  = UserDefaults.standard.object(forKey: "filterOption")
        {
            let decodedFilterOptions = NSKeyedUnarchiver.unarchiveObject(with: decoded as! Data)
            if  let filterOptions = decodedFilterOptions as? FilterOptions
            {
                gemsButton.isChecked = filterOptions.collections.gen
                elementsButton.isChecked = filterOptions.collections.elements
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
